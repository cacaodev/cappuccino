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

@implementation CPLayoutConstraintEngine : CPObject
{
    SimplexSolver   _engine;
    Object          _CPEngineRegisteredItems;
}

- (id)init
{
    self = [super init];

    _CPEngineRegisteredItems = @{};

    var onvaluechange = function(v, records)
    {
        //console.log(v._identifier + " " + v.toString());
        var uid = v._identifier;
        records[uid] = (records[uid] || 0) | v._tag;
    };

    var onsolved = function(records)
    {
        for (var uuid in records)
        {
            var item = _CPEngineRegisteredItems[uuid],
                mask = records[uuid];

            if (mask !== 0)
            {
                [item _setConstraintBasedNeedsLayoutMask:mask];
                [[item superview] setNeedsLayout];
            }
            //console.log(item + " = " + records[uuid]);
        }
    };

    _engine = new Engine(false, onvaluechange, onsolved);

    return self;
}

- (void)registerItem:(id)anItem forIdentifier:(CPString)anIdentifier
{
    if (anItem && anIdentifier)
    {
        //CPLog.debug("Register " + ([anItem identifier] || [anItem className]) + " for ID " + anIdentifier);
        _CPEngineRegisteredItems[anIdentifier] = anItem;
    }
}

- (id)registeredItemForIdentifier:(CPString)anIdentifier
{
    if (anIdentifier !== nil)
        return _CPEngineRegisteredItems[anIdentifier];

    return nil;
}

- (CPString)registeredItems
{
    var str = "";

    for (var key in _CPEngineRegisteredItems)
    {
        var obj = _CPEngineRegisteredItems[key];
        str += (key + " = " + [obj debugID] + "\n");
    }

    return str;
}

- (void)unregisterItemWithIdentifier:(CPString)anIdentifier
{
    if (anIdentifier !== nil)
        delete _CPEngineRegisteredItems[anIdentifier];
}

- (void)disableOnSolvedNotification
{
    _engine.disableOnSolvedNotification();
}

- (void)suggestSize:(CGSize)aSize forItem:(id)anItem priority:(CPInteger)priority
{
    var variables = [[anItem _variableWidth], [anItem _variableHeight]],
        values = [aSize.width, aSize.height];

    _engine.suggestValues(variables, values, priority);
}

- (void)suggestOrigin:(CGPoint)aPoint forItem:(id)anItem priority:(CPInteger)priority
{
    var variables = [[anItem _variableMinX], [anItem _variableMinY]],
        values = [aPoint.x, aPoint.y];

    _engine.suggestValues(variables, values, priority);
}

- (void)stopEditing
{
    _engine.stopEditing();
}

- (void)solve
{
    _engine.solve();
}

- (void)resolve
{
    _engine.resolve();
}

- (void)addStayConstraintsForItem:(id)anItem priority:(CPInteger)aPriority
{
    var container = [anItem UID],
        variables = [[anItem _variableWidth], [anItem _variableHeight]],
        json_constraints = [];

    for (var i = 0; i < variables.length; i++)
    {
        var variable = variables[i];

        var hash = (container + "_" + variable.name + "_" + variable.valueOf());
        json_constraints.push({uuid:hash, variable:variable, priority:aPriority});
    }

    var args = {type:@"StayConstraint", container:container, constraints:json_constraints};
    _engine.replaceConstraints(args);
}

- (BOOL)solver_replaceConstraints:(CPDictionary)constraintsByView
{
    CPLog.debug("Constraints to replace = \n");

    var errors = @[],
        constraintByHash = @{},
        result = NO;

    [constraintsByView enumerateKeysAndObjectsUsingBlock:function(container, constraintsByType, stop)
    {
        CPLog.debug([_CPEngineRegisteredItems[container] debugID] + " = " + [constraintsByType description]);

        [constraintsByType enumerateKeysAndObjectsUsingBlock:function(type, constraints, stop)
        {
            var json_constraints = @[];

            [constraints enumerateObjectsUsingBlock:function(constraint, idx, stop)
            {
                [constraint setAddedToEngine:YES];
                [constraintByHash setObject:constraint forKey:[constraint hash]];
                [json_constraints addObjectsFromArray:[constraint toJSON]];
            }];

            var args = {type:type, container:container, constraints:json_constraints};

            result |= _engine.replaceConstraints(args, errors);
        }];
    }];

    if ([errors count])
    {
        [errors enumerateObjectsUsingBlock:function(solverError, idx, stop)
        {
            var type = solverError.type,
                reason = solverError.reason();

            if (type == "c.RequiredFailure")
            {
                var hash = solverError.userInfo.uuid,
                    constraint = [constraintByHash objectForKey:hash];

                [constraint setAddedToEngine:NO];
                CPLog.warn(reason + " : " + [constraint description]);
            }
            else
                CPLog.error(reason);
        }];
    }

    return result;
}

- (void)solver_removeConstraints:(CPArray)constraints
{
    var args = [];

    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        [args addObject:[aConstraint toJSON]];
    }];

    _engine.removeConstraints(args);
}

- (CPString)description
{
    return _engine.description();
}

- (Variable)variableForItem:(id)anItem tag:(CPInteger)tag
{
    var uuid = [anItem UID],
        prefix = [anItem debugID],
        frame = [anItem frame],
        name, value;

    switch(tag)
    {
        case 2 : name = "minX";
                 value = CGRectGetMinX(frame);
        break;
        case 4 : name = "minY";
                 value = CGRectGetMinY(frame);
        break;
        case 8 : name = "width";
                 value = CGRectGetWidth(frame);
        break;
        case 16 : name = "height";
                  value = CGRectGetHeight(frame);
        break;
        default : name = "unknown";
                  value = 0;
    }

    return _engine.Variable(uuid, prefix, name, tag, value);
}

@end
