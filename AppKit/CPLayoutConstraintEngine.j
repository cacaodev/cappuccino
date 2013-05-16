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
var _registeredVariableOwners = {};

var SUPPORTS_WEB_WORKER;

var _CPEngineViewsNeedUpdateConstraints = [];
var _CPEngineCallbacks = {};

@implementation CPLayoutConstraintEngine : CPObject
{
    //SimplexSolver   solver @accessors(getter=solver);
    CPArray         _constraints @accessors(getter=constraints);
    //CPArray         _stayVariables;

    Object          _worker;
    //Object          _registeredVariableOwners;
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

+ (void)informViewNeedsConstraintUpdate:(CPView)aView
{
    if (![_CPEngineViewsNeedUpdateConstraints containsObjectIdenticalTo:aView])
    {
        _CPEngineViewsNeedUpdateConstraints.push(aView);

        CPLog.debug(_cmd + ([aView identifier] || aView));
    }
}

- (id)init
{
CPLog.debug(self + _cmd);
    self = [super init];

    if (SUPPORTS_WEB_WORKER)
    {
        // A webworker is created and the JavaScript file CassowaryBridge.js
        // is loaded into its context.

        var appkitBundle = [CPBundle bundleForClass:[self class]],
            workerPath = [appkitBundle pathForResource:@"cassowary/Worker.js"];

        _worker = new Worker(workerPath);
CPLog.debug("CREATED WORKER" + _worker);
        if (_worker)
        {
            // Register an event handler that will receive messages from our
            // web worker
            _worker.addEventListener('message', function(e){onWorkerMessage(e.data);});
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

        var s = [self sendCommand:"createSolver" withArguments:null];
        s.onsolved = updateItemsGeometry;
    }

    _constraints = [];
    //_stayVariables = [];
    //_registeredVariableOwners = {};
    _solverBachingModeLevel = 0;
    _workerMessagesQueue = [];

    return self;
}

- (void)registerItem:(id)anItem forIdentifier:(CPString)anIdentifier
{
    if (anItem && anIdentifier && !_registeredVariableOwners[anIdentifier])
    {
        CPLog.debug("register " + anItem + " ID " + anIdentifier);
        _registeredVariableOwners[anIdentifier] = anItem;
    }
}

- (void)unregisterItemWithIdentifier:(CPString)anIdentifier
{
    delete (_registeredVariableOwners[anIdentifier]);
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
    if (SUPPORTS_WEB_WORKER)
        [self sendMessage:{command:aCommand, args:args}];
    else
        return caller[aCommand](args);
}

- (id)sendCommand:(CPString)aCommand withArguments:(Object)args callback:(Function)aCallBack
{
    // uuidgen needed !!
    var callbackUUID = [self UID] + "_" + aCommand + "_" + (new Date()).getTime();

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

- (void)suggestValue:(id)aValue forVariable:(int)aTag fromItem:(id)anItem
{
    var args = {tag:aTag, value:aValue, identifier:[anItem UID]};

    [self sendCommand:"suggestValue" withArguments:args];
}

- (void)setEditVariables:(CPArray)tags fromItem:(id)anItem
{
    var args = {identifier:[anItem UID], tags:tags};

    [self sendCommand:"setEditVarsForContext" withArguments:args];
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
    if ([_CPEngineViewsNeedUpdateConstraints count] === 0)
        return;

    var updatedIndexes = [CPIndexSet indexSet];

    [_CPEngineViewsNeedUpdateConstraints enumerateObjectsUsingBlock:function(aView, idx, stop)
    {
        if ([[aView window] _layoutEngineIfExists] === self && [aView needsUpdateConstraints])
        {
            [self solver_updateConstraintsForView:aView];
            [aView setNeedsUpdateConstraints:NO];
            [updatedIndexes addIndex:idx];
        }
    }];

    [_CPEngineViewsNeedUpdateConstraints removeObjectsAtIndexes:updatedIndexes];
}

- (void)solver_updateConstraintsForView:(CPView)aView
{
    var uuid = [aView UID],
        json_constraints = [];

    var constraints = [CPArray arrayWithArray:[aView constraints]];
    [constraints addObjectsFromArray:[aView _internalConstraints]];

    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        [aConstraint registerItemsInEngine:self];
        [json_constraints addObject:[aConstraint toJSON]];
    }];

    var args = {uuid:uuid, constraints:json_constraints};

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

var updateItemsGeometry = function(records)
{
    for (var identifier in records)
    {
        var record = records[identifier],
            target = _registeredVariableOwners[identifier];

        updateFrameFromSolver(target, record.changeMask, record.changeValues);
    }
};

var updateFrameFromSolver = function(target, mask, values)
{
    //CPLog.debug("Updated view " + target + " mask " + mask + " values " + values);

    var frame = [target frame];

    if (mask & 6)
    {
        var x = (mask & 2) ? values[2] : CGRectGetMinX(frame),
            y = (mask & 4) ? values[4] : CGRectGetMinY(frame);

        [target setFrameOrigin:CGPointMake(x, y)];
        //CPLog.debug([target identifier] + ". Updated frame origin {" + [x, y] + "}");
    }

    if (mask & 24)                                // v: wrong wrong wrong ! what if the changed value is 0 ?
    {
        var w = (mask & 8)  ? values[8]  : CGRectGetWidth(frame),
            h = (mask & 16) ? values[16] : CGRectGetHeight(frame);

        [target setFrameSize:CGSizeMake(w, h)];
        //CPLog.debug([target identifier] + ". Updated frame size {" + [w, h] + "}");
    }

    [target setNeedsDisplay:YES];
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
        updateItemsGeometry(result);
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

/*
commit 5b7460d3a774468c2ab55dbe40a2623e7df673b7 + 1

Tests for synch mode (no Worker):

2013-05-20 10:47:44.616 objj [warn]: Subviews autoresize mask is 0
2013-05-20 10:47:44.617 objj [warn]:    Autosize setFrame: 0.3 ms. Total 150 ms.
2013-05-20 10:47:45.065 objj [warn]: Auto-layout setFrame: 0.604 ms. Total 302 ms (2.01x times slower).
2013-05-20 10:47:45.768 objj [warn]: Subviews autoresize mask is 1
2013-05-20 10:47:45.769 objj [warn]:    Autosize setFrame: 1.014 ms. Total 507 ms.
2013-05-20 10:47:46.668 objj [warn]: Auto-layout setFrame: 1.502 ms. Total 751 ms (1.48x times slower).
2013-05-20 10:47:47.216 objj [warn]: Subviews autoresize mask is 4
2013-05-20 10:47:47.217 objj [warn]:    Autosize setFrame: 0.722 ms. Total 361 ms.
2013-05-20 10:47:47.632 objj [warn]: Auto-layout setFrame: 0.588 ms. Total 294 ms (0.81x times slower).
2013-05-20 10:47:48.315 objj [warn]: Subviews autoresize mask is 5
2013-05-20 10:47:48.315 objj [warn]:    Autosize setFrame: 0.986 ms. Total 493 ms.
2013-05-20 10:47:49.165 objj [warn]: Auto-layout setFrame: 1.454 ms. Total 727 ms (1.47x times slower).
2013-05-20 10:47:50.190 objj [warn]: Subviews autoresize mask is 2
2013-05-20 10:47:50.191 objj [warn]:    Autosize setFrame: 1.666 ms. Total 833 ms.
2013-05-20 10:47:51.367 objj [warn]: Auto-layout setFrame: 2.054 ms. Total 1027 ms (1.23x times slower).
2013-05-20 10:47:52.429 objj [warn]: Subviews autoresize mask is 3
2013-05-20 10:47:52.430 objj [warn]:    Autosize setFrame: 1.688 ms. Total 844 ms.
2013-05-20 10:47:54.335 objj [warn]: Auto-layout setFrame: 2.49 ms. Total 1245 ms (1.48x times slower).
2013-05-20 10:47:55.393 objj [warn]: Subviews autoresize mask is 6
2013-05-20 10:47:55.394 objj [warn]:    Autosize setFrame: 1.68 ms. Total 840 ms.
2013-05-20 10:47:56.560 objj [warn]: Auto-layout setFrame: 2.084 ms. Total 1042 ms (1.24x times slower).
2013-05-20 10:47:57.622 objj [warn]: Subviews autoresize mask is 7
2013-05-20 10:47:57.623 objj [warn]:    Autosize setFrame: 1.748 ms. Total 874 ms.
2013-05-20 10:47:59.001 objj [warn]: Auto-layout setFrame: 2.482 ms. Total 1241 ms (1.42x times slower).
*/