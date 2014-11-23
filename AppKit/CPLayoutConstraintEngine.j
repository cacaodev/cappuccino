@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import <Foundation/CPBundle.j>
@import <Foundation/CPIndexSet.j>

@import "CPLayoutConstraint.j"
@import "Engine.js"
@import "c.js"

/*
@import <AppKit/c.js>
@import "Resources/cassowary/Engine.js"
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
    ENGINE_WORKER_PATH = [[CPBundle bundleForClass:self] pathForResource:@"cassowary/Worker.js"];
#else
    ENGINE_SUPPORTS_WEB_WORKER = NO;
#endif

    ENGINE_ALLOWS_WEB_WORKER = YES;
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
    _CPEngineRegisteredItems = @{};
    _solverBachingModeLevel = 0;
    _workerMessagesQueue = [];

    if ([[self class] shouldEnableWebWorker])
    {
        // A webworker is created and the JavaScript file Worker.js
        // is loaded into its context.

        _worker = new Worker(ENGINE_WORKER_PATH);

        if (_worker)
        {
            var engineUID = [self UID];
            _CPLayoutEngineCachedEngines[engineUID] = self;
            // Register an event handler that will receive messages from our web worker
            _worker.addEventListener('message', function(e)
            {
                onWorkerMessage(e.data, onSolvedFunction, engineUID);
            }, false);

            _worker.addEventListener('error', function(e)
            {
                console.error("%c Worker error: Line " + e.lineno + " in " + e.filename + ": " + e.message, 'color:darkred; font-weight:bold');
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

- (void)addStayConstraintForItem:(id)anItem tags:(CPArray)tags priority:(CPInteger)aPriority
{
    var container = [anItem UID],
        prefix = [anItem debugID],
        count = tags.length,
        json_constraints = [];

    while (count--)
    {
        var tag = tags[count],
            value = [anItem valueForVariable:tag],
            hash = (container + "_" + tag + "_" + value + "_" + aPriority);

        var json = {uuid:hash, prefix:prefix, value:value, tag:tag, priority:aPriority};
        json_constraints.push(json);
    }

    var args = {type:@"StayConstraint", container:container, constraints:json_constraints};
    [self sendCommand:"replaceConstraints" withArguments:args];

    //CPLog.debug([self class] + " addStay " + anItem + " tag:" + tag + " priority:" + aPriority);
}

- (void)solver_replaceConstraints:(CPDictionary)constraintsByView
{
    CPLog.debug("Constraints to replace = \n");

    [constraintsByView enumerateKeysAndObjectsUsingBlock:function(container, constraintsByType, stop)
    {
        CPLog.debug([[self registeredItemForIdentifier:container] debugID] + "=" + [constraintsByType description]);

        [constraintsByType enumerateKeysAndObjectsUsingBlock:function(type, constraints, stop)
        {
            var json_constraints = @[];

            [constraints enumerateObjectsUsingBlock:function(constraint, idx, stop)
            {
                [constraint setAddedToEngine:YES];
                [json_constraints addObjectsFromArray:[constraint toJSON]];
            }];

            var args = {type:type, container:container, constraints:json_constraints};
            [self sendCommand:"replaceConstraints" withArguments:args];
        }];
    }];
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
       console.log('%c [worker]: ' + result, 'color:darkblue; font-weight:bold');
    }
    else if (type === 'warn')
    {
       console.warn('%c [worker]: ' + result, 'color:brown; font-weight:bold');
    }
    else if (type === 'error')
    {
       console.error('%c [worker]: ' + result, 'color:darkred; font-weight:bold');
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