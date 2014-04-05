@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import <Foundation/CPBundle.j>
@import <Foundation/CPIndexSet.j>

@import "CPLayoutConstraint.j"

@import "c.js"
@import "HashTable.js"
@import "HashSet.js"
@import "Error.js"
@import "SymbolicWeight.js"
@import "Strength.js"
@import "Variable.js"
@import "Point.js"
@import "Expression.js"
@import "Constraint.js"
@import "EditInfo.js"
@import "Tableau.js"
@import "SimplexSolver.js"

@import "CassowaryBridge.js"

/*
@import <AppKit/c.js>
@import <AppKit/HashTable.js>
@import <AppKit/HashSet.js>
@import <AppKit/Error.js>
@import <AppKit/SymbolicWeight.js>
@import <AppKit/Strength.js>
@import <AppKit/Variable.js>
@import <AppKit/Point.js>
@import <AppKit/Expression.js>
@import <AppKit/Constraint.js>
@import <AppKit/EditInfo.js>
@import <AppKit/Tableau.js>
@import <AppKit/SimplexSolver.js>

@import "Resources/cassowary/CassowaryBridge.js"
*/

var ENGINE_SUPPORTS_WEB_WORKER,
    ENGINE_ALLOWS_WEB_WORKER,
    ENGINE_WORKER_PATH;

var _CPLayoutEngineCachedEngines = {},
    _CPEngineViewsNeedUpdateConstraints = [],
    _CPEngineCallbacks = {};

@implementation CPLayoutConstraintEngine : CPObject
{
    CPArray         _constraints @accessors(getter=constraints);

    Object          _worker;
    CPInteger       _solverBachingModeLevel;
    CPArray         _workerMessagesQueue;
    CPDictionary    _CPEngineRegisteredItems;
}

+ (void)initialize
{
#if PLATFORM(DOM)
    ENGINE_SUPPORTS_WEB_WORKER = !!window.Worker;
#else
    ENGINE_SUPPORTS_WEB_WORKER = NO;
#endif

    ENGINE_ALLOWS_WEB_WORKER = YES;

    ENGINE_WORKER_PATH = [[CPBundle bundleForClass:self] pathForResource:@"cassowary/Worker.js"];
}

+ (void)setAllowsWebWorker:(BOOL)flag
{
    ENGINE_ALLOWS_WEB_WORKER = flag;
}

+ (BOOL)shouldEnableWebWorker
{
    return (ENGINE_SUPPORTS_WEB_WORKER && ENGINE_ALLOWS_WEB_WORKER);
}

+ (void)informViewNeedsConstraintUpdate:(CPView)aView
{
// Note: class method (and class var bellow) because some views may need to register themselves
// before their related engine (window engine) was created.
// Turn into instance method if we decide to create the CPEngine & Cassowary-solver earlier.
    if (aView && ![_CPEngineViewsNeedUpdateConstraints containsObjectIdenticalTo:aView])
    {
        _CPEngineViewsNeedUpdateConstraints.push(aView);
    }
}

- (id)initWithSolverSetup:(Function)solverReadyFunction engineCompletion:(Function)onSolvedFunction
{
    self = [super init];

    _constraints = [];
    //_stayVariables = [];
    _CPEngineRegisteredItems = @{};
    _solverBachingModeLevel = 0;
    _workerMessagesQueue = [];

    if ([[self class] shouldEnableWebWorker])
    {
        // A webworker is created and the JavaScript file CassowaryBridge.js
        // is loaded into its context.

        _worker = new Worker(ENGINE_WORKER_PATH);

        if (_worker)
        {
            var engineUID = [self UID];
            _CPLayoutEngineCachedEngines[engineUID] = self;
            // Register an event handler that will receive messages from our
            // web worker
            _worker.addEventListener('message', function(e)
            {
                onWorkerMessage(e.data, onSolvedFunction, engineUID);
            }, false);

            _worker.addEventListener('error', function(e)
            {
                CPLog.error('ERROR: Line ' + e.lineno + ' in ' + e.filename + ': ' + e.message);
            }, false);

            [self beginUpdates];
            [self sendCommand:"createSolver" withArguments:null];
            solverReadyFunction(self);
            [self endUpdates];
        }
    }
    else
    {
        _worker = new Object();

        InitCassowaryFunctions(_worker);

        _worker.postMessage = function(messages)
        {
            messages.forEach(function(message)
            {
                var command = _worker[message.command];
                command(message.args);

                //if (message.callback)
                //    returnMessage("callback", message.callback);
            });
        };

        var s = _worker.createSolver();
        s.onsolved = new NoWorkerOnSlovedFunctionCreate(onSolvedFunction, self);

        solverReadyFunction(self);
    }

CPLog.warn("Web Worker mode is " + [[self class] shouldEnableWebWorker] + "; worker=" + _worker.toString());

    return self;
}

- (void)registerItem:(id)anItem forIdentifier:(CPString)anIdentifier
{
    if (anItem && anIdentifier)
    {
        //CPLog.debug("Register " + anItem + " ID " + anIdentifier);
        [_CPEngineRegisteredItems setObject:anItem forKey:anIdentifier];
    }
}

- (id)registeredItemForIdentifier:(CPString)anIdentifier
{
    if (anIdentifier == nil)
        return nil;

    return [_CPEngineRegisteredItems objectForKey:anIdentifier];
}

- (void)unregisterItemWithIdentifier:(CPString)anIdentifier
{
    [_CPEngineRegisteredItems removeObjectForKey:anIdentifier];
}

// ===================================
// Working with remote or local solver
// ===================================
- (void)beginUpdates
{
    _solverBachingModeLevel++;
}

- (void)endUpdates
{
    _solverBachingModeLevel--;

    if (_solverBachingModeLevel === 0)
    {
        _worker.postMessage(_workerMessagesQueue);
        _workerMessagesQueue = [];
    }
}

- (id)sendCommand:(CPString)aCommand withArguments:(Object)args
{
    if ([[self class] shouldEnableWebWorker])
        [self sendMessage:{command:aCommand, args:args}];
    else
        return _worker[aCommand](args);
}

- (id)sendCommand:(CPString)aCommand withArguments:(Object)args callback:(Function)aCallBack
{
    var callbackUUID = uuidgen();

    _CPEngineCallbacks[callbackUUID] = aCallBack;

    [self sendMessage:{command:aCommand, args:args, callback:callbackUUID}];
}

- (void)sendMessage:(CPString)aMessage
{
    if (_solverBachingModeLevel > 0)
        [_workerMessagesQueue addObject:aMessage];
    else
        _worker.postMessage([aMessage]);
}

- (void)setDisableOnSolvedNotification:(BOOL)shouldDisable
{
    [self sendCommand:"setDisableOnSolvedNotification" withArguments:shouldDisable];
}

- (void)suggestValue:(id)aValue forVariable:(int)aTag priority:(CPInteger)aPriority fromItem:(id)anItem
{
    var args = {tag:aTag, value:aValue, identifier:[anItem UID], priority:aPriority};

    [self sendCommand:"suggestValue" withArguments:args];
}

- (void)setEditVariables:(CPArray)tags priority:(CPInteger)aPriority fromItem:(id)anItem
{
    var args = {identifier:[anItem UID], tags:tags, priority:aPriority};

    [self sendCommand:"setEditVarsForContext" withArguments:args];
}

- (void)stopEditing
{
    [self sendCommand:"removeAllEditVars" withArguments:null];
}

- (void)suggestValues:(CPArray)values fromItem:(id)anItem
{
// TODO: in no-worker mode, call the target function directly for perf.
    var context = [anItem UID];

    [self sendCommand:"suggestValuesMultiple" withArguments:{values:values, context:context}];
}

- (void)solve
{
    [self sendCommand:"solve" withArguments:null];
}

- (void)addStayVariable:(int)tag priority:(int)aPriority fromItem:(id)anItem
{
    var value = [anItem valueForVariable:tag],
        identifier = [anItem UID],
        prefix = [anItem identifier] || [anItem className];

    var args = {identifier:identifier, prefix:prefix, value:value, tag:tag, priority:aPriority};

    [self sendCommand:"addStay" withArguments:args];

    //CPLog.debug([self class] + " addStay " + anItem + " tag:" + tag + " priority:" + aPriority);
}

- (void)solver_replaceConstraintsIfNeeded
{
    [self solver_replaceConstraintsIfNeededOfTypes:["Constraint", "SizeConstraint"]];
}

- (void)solver_replaceConstraintsIfNeededOfTypes:(CPArray)types
{
    if ([_CPEngineViewsNeedUpdateConstraints count] === 0)
        return;

    var updatedIndexes = [CPIndexSet indexSet];

    [_CPEngineViewsNeedUpdateConstraints enumerateObjectsUsingBlock:function(aView, idx, stop)
    {
        if ([[aView window] _layoutEngineIfExists] === self && [aView needsUpdateConstraints])
        {
            [aView updateConstraints];

            [types enumerateObjectsUsingBlock:function(type, idx, stop)
            {
                 [self solver_replaceConstraintsOfType:type forView:aView];
            }];

            [aView setNeedsUpdateConstraints:NO];
            [updatedIndexes addIndex:idx];
        }
    }];

    [_CPEngineViewsNeedUpdateConstraints removeObjectsAtIndexes:updatedIndexes];
}

- (void)solver_replaceConstraintsOfType:(CPString)aType forView:(CPView)aView
{
    var containerUID = [aView UID],
        json_constraints = [];

    [[aView constraints] enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        var json_constraint = [aConstraint toJSON];

        if (json_constraint.type == aType)
        {
            [aConstraint registerItemsInEngine:self];
            [json_constraints addObject:json_constraint];
        }
    }];

    var args = {container:containerUID, type:aType, constraints:json_constraints};

    [self sendCommand:"replaceConstraints" withArguments:args];
}

- (void)solver_updateSizeConstraints:(CPArray)sizeConstraints forView:(CPView)aView
{
    var containerUID = [aView UID],
        json_constraints = [];

    [sizeConstraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        var orientation = [aConstraint orientation],
            constant = [aConstraint constant];

        json_constraints.push({orientation:orientation, constant:constant});

        // Not needed if update ?
        [aConstraint registerItemsInEngine:self];
    }];

    var args = {container:containerUID, editPriority:CPLayoutPriorityConstantEditing, constraints:json_constraints};
    [self sendCommand:"updateSizeConstraints" withArguments:args];
}

- (void)solver_addConstraint:(CPLayoutConstraint)aConstraint
{
    var json = [aConstraint toJSON];
    [self sendCommand:"addConstraint" withArguments:json];
}

- (void)solver_addConstraints:(CPArray)constraints
{
    var args = [];
    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        [args addObject:[aConstraint toJSON]];
    }];

    [self sendCommand:"addConstraints" withArguments:args];
}

- (void)solver_removeConstraints:(CPArray)constraints
{
    var args = [];
    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        [args addObject:[aConstraint toJSON]];
    }];

    [self sendCommand:"removeConstraints" withArguments:args];
}

- (void)solver_removeConstraint:(CPLayoutConstraint)aConstraint
{
    var uuid = [aConstraint UID],
        args = {uuid:uuid};

    [self sendCommand:"removeConstraint" withArguments:args];
}

- (void)getInfo
{
    [self sendCommand:"info" withArguments:null];
}

@end

// No worker version
function returnMessage(type, result)
{
 //  Send a message back to the main thread with the result
    onWorkerMessage({type:type, result:result});
};

var NoWorkerOnSlovedFunctionCreate = function(onsolvedFunction, engine)
{
    return function(records)
    {
        onsolvedFunction(engine, records);
    };
};

var onWorkerMessage = function(aMessage, aSolvedFunction, anEngineUID)
{
    var type = aMessage.type,
        result = aMessage.result;

    if (type === 'solved')
    {
        var anEngine = _CPLayoutEngineCachedEngines[anEngineUID];
        aSolvedFunction(anEngine, result);
        [[CPRunLoop mainRunLoop] performSelectors];
    }
    else if (type === 'log')
       CPLog.debug("Worker: did " + result);
    else if (type === 'warn')
       CPLog.warn(result);
    else if (type === 'callback')
    {
        var callbackUUID = aMessage.uuid,
            callback = _CPEngineCallbacks[callbackUUID];

        if (callback)
        {
            callback(result);
            delete (_CPEngineCallbacks[callbackUUID]);

            [[CPRunLoop mainRunLoop] performSelectors];
        }
    }
};

var uuidgen = function () {
    return Math.random().toString(36).substring(2, 15) +
        Math.random().toString(36).substring(2, 15);
}