@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import <Foundation/CPBundle.j>
@import <Foundation/CPIndexSet.j>

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

var SUPPORTS_WEB_WORKER;

var _CPEngineRegisteredItems = {},
    _CPEngineViewsNeedUpdateConstraints = [],
    _CPEngineCallbacks = {},
    _CPEngineLayoutItems;

@implementation CPLayoutConstraintEngine : CPObject
{
    //SimplexSolver   solver @accessors(getter=solver);
    CPArray         _constraints @accessors(getter=constraints);

    Object          _worker;
    CPInteger       _solverBachingModeLevel;
    CPArray         _workerMessagesQueue;
}

+ (void)initialize
{
#if PLATFORM(DOM)
    SUPPORTS_WEB_WORKER = !!window.Worker;
#else
    SUPPORTS_WEB_WORKER = NO;
#endif
}

+ (BOOL)shouldEnableWebWorker
{
    return (SUPPORTS_WEB_WORKER && [CPLayoutConstraint allowsWebWorker]);
}

+ (void)informViewNeedsConstraintUpdate:(CPView)aView
{
    if (aView && ![_CPEngineViewsNeedUpdateConstraints containsObjectIdenticalTo:aView])
    {
        _CPEngineViewsNeedUpdateConstraints.push(aView);

        CPLog.debug(_cmd + ([aView identifier] || aView));
    }
}

- (id)initWithWindow:(CPWindow)aWindow
{
CPLog.debug(self + _cmd);
    self = [super init];

    var contentViewUUID = [[aWindow contentView] UID];
    _CPEngineLayoutItems = _CPEngineLayoutItemsFunction(contentViewUUID);

    if ([[self class] shouldEnableWebWorker])
    {
        // A webworker is created and the JavaScript file CassowaryBridge.js
        // is loaded into its context.

        var appkitBundle = [CPBundle bundleForClass:[self class]],
            workerPath = [appkitBundle pathForResource:@"cassowary/Worker.js"];

        _worker = new Worker(workerPath);

        if (_worker)
        {
            // Register an event handler that will receive messages from our
            // web worker
            _worker.addEventListener('message', function(e)
            {
                onWorkerMessage(e.data);
            });

            [self sendCommand:"createSolver" withArguments:null];
        }
    }
    else
    {
        _worker = {

        postMessage : function(messages)
                      {
                          messages.forEach(function(message)
                                          {
                                              var command = caller[message.command];

                                              command(message.args);

                                              //if (message.callback)
                                              //    returnMessage("callback", message.callback);
                                          });
                      }
        };

        var s = caller["createSolver"]();
        s.onsolved = _CPEngineLayoutItems;
    }

CPLog.debug("Web Worker mode " + [[self class] shouldEnableWebWorker] + " worker=" + _worker);

    _constraints = [];
    //_stayVariables = [];
    //_CPEngineRegisteredItems = {};
    _solverBachingModeLevel = 0;
    _workerMessagesQueue = [];

    return self;
}

- (void)registerItem:(id)anItem forIdentifier:(CPString)anIdentifier
{
    if (anItem && anIdentifier && !_CPEngineRegisteredItems[anIdentifier])
    {
        CPLog.debug("register " + anItem + " ID " + anIdentifier);
        _CPEngineRegisteredItems[anIdentifier] = anItem;
    }
}

- (void)unregisterItemWithIdentifier:(CPString)anIdentifier
{
    delete (_CPEngineRegisteredItems[anIdentifier]);
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
        return caller[aCommand](args);
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

    CPLog.debug([self class] + " addStay " + anItem + " tag:" + tag + " priority:" + aPriority);
}

- (void)solver_updateConstraintsIfNeeded
{
    [self solver_updateConstraintsIfNeededOfTypes:["Constraint", "SizeConstraint"]];
}

- (void)solver_updateConstraintsIfNeededOfTypes:(CPArray)types
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
                 [self solver_updateConstraintsOfType:type forView:aView];
            }];

            [aView setNeedsUpdateConstraints:NO];
            [updatedIndexes addIndex:idx];
        }
    }];

    [_CPEngineViewsNeedUpdateConstraints removeObjectsAtIndexes:updatedIndexes];
}

- (void)solver_updateConstraintsOfType:(CPString)aType forView:(CPView)aView
{
CPLog.debug(_cmd + aType + aView);
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

    [self sendCommand:"updateConstraints" withArguments:args];
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

var _CPEngineLayoutItemsFunction = function(excludeUID)
{
    return function (records)
    {
        for (var identifier in records)
        {
            if (identifier === excludeUID)
                continue;

            var record = records[identifier],
                target = _CPEngineRegisteredItems[identifier];

            if (target)
                updateFrameFromSolver(target, record.changeMask, record.changeValues);
        }
    };
};

var updateFrameFromSolver = function(target, mask, values)
{
    //CPLog.debug("Updated view " + target + " mask " + mask + " values " + values);

    var frame = [target frame];

    var pmask = mask & 6,
        smask = mask & 24;

    if (pmask == 6)
    {
        [target setFrameOrigin:CGPointMake(values[2], values[4])];
    }
    else if (pmask == 4)
    {
        [target setFrameOrigin:CGPointMake(CGRectGetMinX(frame), values[4])];
    }
    else if (pmask == 2)
    {
        [target setFrameOrigin:CGPointMake(values[2], CGRectGetMinY(frame))];
    }

    if (smask == 24)
    {
        [target setFrameSize:CGSizeMake(values[8], values[16])];
    }
    else if (smask == 16)
    {
        [target setFrameSize:CGSizeMake(CGRectGetWidth(frame), values[16])];
    }
    else if (smask == 8)
    {
        [target setFrameSize:CGSizeMake(values[8], CGRectGetHeight(frame))];
    }

    //[target setNeedsDisplay:YES];
};

// No worker version
function returnMessage(type, result)
{
 //  Send a message back to the main thread with the result
    onWorkerMessage({type:type, result:result});
};

var onWorkerMessage = function(message)
{
// Our webworker sends us a message when it is done.
    var type = message.type,
        result = message.result;

    if (type === 'solved')
    {
        _CPEngineLayoutItems(result);
        [[CPRunLoop mainRunLoop] performSelectors];
    }
    else if (type === 'log')
       CPLog.debug("Worker: did " + result);
    else if (type === 'warn')
       CPLog.warn(result);
    else if (type === 'callback')
    {
        var callbackUUID = message.uuid,
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