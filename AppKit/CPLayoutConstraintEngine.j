@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import <Foundation/CPBundle.j>
@import <Foundation/CPIndexSet.j>

@import "CPLayoutConstraint.j"

@import "c.js"
@import "Engine.js"

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

- (id)initWithSolverCreatedCallback:(Function)solverReadyFunction onSolvedCallback:(Function)onSolvedFunction
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
                CPLog.error("Worker error: Line " + e.lineno + " in " + e.filename + ": " + e.message);
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

    //CPLog.warn("Web Worker mode is " + [[self class] shouldEnableWebWorker] + "; worker=" + _worker.toString());

    return self;
}

- (void)registerItem:(id)anItem forIdentifier:(CPString)anIdentifier
{
    if (anItem && anIdentifier)
    {
        //CPLog.debug("Register " + ([anItem identifier] || [anItem className]) + " for ID " + anIdentifier);
        [_CPEngineRegisteredItems setObject:anItem forKey:anIdentifier];
    }
}

- (id)registeredItemForIdentifier:(CPString)anIdentifier
{
    if (anIdentifier !== nil)
        return [_CPEngineRegisteredItems objectForKey:anIdentifier];

    return nil;
}

- (CPString)registeredItems
{
    var str = "";
    [_CPEngineRegisteredItems enumerateKeysAndObjectsUsingBlock:function(key,obj,stop)
    {
        str += (key + " = " + [obj debugID] + "\n");
    }];

    return str;
}

- (void)unregisterItemWithIdentifier:(CPString)anIdentifier
{
    if (anIdentifier !== nil)
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

- (void)suggestValue:(float)aValue forVariable:(CPInteger)aTag priority:(CPInteger)aPriority fromItem:(id)anItem
{
    var args = {tag:aTag, value:aValue, identifier:[anItem UID], priority:aPriority};

    [self sendCommand:"suggestValue" withArguments:args];
}

- (void)suggestSize:(CPArray)values forItem:(id)anItem
{
// TODO: in no-worker mode, call the target function directly for perf.
    var args = {values:values, uuid:[anItem UID], prefix:[anItem debugID], tags:[8, 16], priority:1000};

    [self sendCommand:"suggestValues" withArguments:args];
}

- (void)suggestOrigin:(CPArray)values forItem:(id)anItem
{
// TODO: in no-worker mode, call the target function directly for perf.
    var args = {values:values, uuid:[anItem UID], prefix:[anItem debugID], tags:[2, 4], priority:1000};

    [self sendCommand:"suggestValues" withArguments:args];
}

/*
- (void)setEditVariables:(CPArray)tags priority:(CPInteger)aPriority fromItem:(id)anItem
{
    var prefix = [anItem identifier] || [anItem className],
        args = {identifier:[anItem UID], prefix:prefix, tags:tags, priority:aPriority};

    [self sendCommand:"registerEditVariables" withArguments:args];
}
*/
- (void)stopEditing
{
    [self sendCommand:"stopEditing" withArguments:null];
}

- (void)solve
{
    [self sendCommand:"solve" withArguments:null];
}

- (void)resolve
{
    [self sendCommand:"resolve" withArguments:null];
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

- (void)solver_replaceConstraints:(CPDictionary)constraintsByView
{
    CPLog.debug("Registered Items = \n " + [self registeredItems]);
    CPLog.debug("Constraints to replace = \n");

    var toJSON = function(constraint)
    {
        return [constraint toJSON];
    }

    [constraintsByView enumerateKeysAndObjectsUsingBlock:function(containerUID, constraintsDict, stop)
    {
        CPLog.debug([[self registeredItemForIdentifier:containerUID] debugID] + "=" + [constraintsDict description]);

        var json_constraints = [constraintsDict objectForKey:@"Constraint"],
            json_size_constraints = [constraintsDict objectForKey:@"SizeConstraint"];

        if (json_size_constraints)
        {
            var sizeConstraints = [json_size_constraints mapUsingFunction:toJSON];
            var args = {container:containerUID, constraints:sizeConstraints};
            [self sendCommand:"replaceSizeConstraints" withArguments:args];
        }

        if (json_constraints)
        {
            var constraints = [json_constraints mapUsingFunction:toJSON];
            var args = {container:containerUID, constraints:constraints};
            [self sendCommand:"replaceConstraints" withArguments:args];
        }
    }];
}

- (void)solver_updateSizeConstraints:(CPArray)sizeConstraints forView:(CPView)aView
{
    var containerUID = [aView UID],
        json_constraints = [];

    [sizeConstraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        [[aConstraint firstItem] resisterInEngineIfNeeded];
        json_constraints.push([aConstraint toJSON]);
    }];

    var args = {container:containerUID, constraints:json_constraints};
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

@implementation CPArray (CPLayoutConstraint)

- (CPArray)mapUsingFunction:(Function)aFunction
{
    var result = @[];

    [self enumerateObjectsUsingBlock:function(obj, idx, stop)
    {
        var r;
        if (r = aFunction(obj))
            [result addObject:r];
    }];

    return result;
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
    {
       CPLog.debug("Worker: " + result);
    }
    else if (type === 'warn')
    {
       CPLog.warn("Worker: " + result);
    }
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
