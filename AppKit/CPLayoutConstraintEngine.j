@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import <Foundation/CPBundle.j>
@import <Foundation/CPIndexSet.j>

@import "CPLayoutConstraint.j"
@import "Engine.js"
@import "c.js"

@typedef Engine
@typedef Map

@implementation CPLayoutConstraintEngine : CPObject
{
    Engine _engine;
    Map    _ownerForVariable;
    id     _delegate @accessors(getter=delegate);
}

- (id)initWithDelegate:(id)aDelegate
{
    self = [super init];

    _ownerForVariable = new Map();
    _delegate = aDelegate;

    _engine = new Engine(false, function(changes)
              {
                  changes.forEach(function(change)
                  {
                      var variable = change.variable,
                          owner = _ownerForVariable.get(variable);

                      [_delegate engine:self variableDidChange:variable withOwner:owner];
                  });
              });

    return self;
}


- (void)disableOnSolvedNotification
{
    _engine.disableOnSolvedNotification();
}

- (void)suggestValues:(CPArray)values forVariables:(CPArray)variables withPriority:(CPLayoutPriority)priority
{
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

- (void)addStayConstraintsForItem:(id)anItem priority:(CPLayoutPriority)aPriority
{
    var container = [anItem UID],
        variables = [[anItem _variableWidth], [anItem _variableHeight]],
        json_constraints = [];

    for (var i = 0; i < variables.length; i++)
    {
        var variable = variables[i],
            hash = (container + "_" + variable.name + "_" + variable.valueOf());

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

- (Variable)variableWithPrefix:(CPString)aPrefix name:(CPString)aName value:(float)aValue owner:(id)anOwner
{
    var variable = _engine.Variable({prefix:aPrefix, name:aName, value:aValue});
    _ownerForVariable.set(variable, anOwner);

    return variable;
}

@end
