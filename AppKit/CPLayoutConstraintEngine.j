@import <Foundation/CPObject.j>

@implementation CPLayoutConstraintEngine : CPObject
{
    SimplexSolver   _solver;
    CPArray         _constraints @accessors(getter=constraints);
    CPArray         _stayVariables;
    CPView          _container;
}

- (id)initWithContainer:(CPView)aContainer
{
    self = [super init];

    _solver = new c.SimplexSolver();
CPLog.debug("created solver");
    _constraints = [];
    _stayVariables = [];
    _container = aContainer;

    return self;
}

- (void)suggestValue:(id)aValue forVariable:(id)aVariable
{
    _solver.addEditVar(aVariable).beginEdit();
    _solver.suggestValue(aVariable, aValue).resolve();
    _solver.endEdit();
    // CPLog.debug(".addEditVar.suggestValue(" + aVariable + ", " + aValue + ") >> " + aVariable);
}

- (void)_addCassowaryConstraint:(Object)aJSConstraint
{
    try
    {
        _solver.addConstraint(aJSConstraint);
        CPLog.debug(".addConstraint(" + aJSConstraint.toString() + ")");
    }
    catch (e)
    {
        CPLog.debug(_cmd + e);
    }
}

- (void)removeAllConstraints
{
    // Not implemented
}

- (void)removeConstraint:(CPLayoutConstraint)aConstraint
{
    _solver.removeConstraint([aConstraint _constraint]);
}

- (void)addStayVariable:(id)aVariable strength:(Object)aStrength weight:(int)aWeight
{
    if ([_stayVariables indexOfObjectIdenticalTo:aVariable] !== CPNotFound)
        return;

    try
    {
        _solver.addStay(aVariable, aStrength, aWeight);
        [_stayVariables addObject:aVariable];
        CPLog.debug(".addStay(" + aVariable + ", " + aStrength + ", " + aWeight);
    }
    catch (e)
    {
        CPLog.debug(_cmd + e);
    }
}

- (void)addStayVariables:(CPArray)variables strength:(Object)aStrength weight:(int)aWeight
{
    [variables enumerateObjectsUsingBlock:function(aVariable, idx, stop)
    {
        [self addStayVariable:aVariable strength:aStrength weight:aWeight];
    }];
}

- (void)layout
{
    // CPLog.debug(_cmd + [_container subviews]);

    [[_container subviews] enumerateObjectsUsingBlock:function(aSubview, idx, stop)
    {
        [aSubview _updateConstraintFrame];
    }];
}

@end
