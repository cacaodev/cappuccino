@import <Foundation/CPObject.j>

@implementation CPLayoutConstraintEngine : CPObject
{
    SimplexSolver   _solver;
    CPArray         _constraints @accessors(getter=constraints);
    CPArray         _stayVariables;
    CPArray         _editingVariables;
}

- (id)init
{
    self = [super init];

    _solver = new c.SimplexSolver();
CPLog.debug("created solver");
    _solver.autoSolve = false;
    _constraints = [];
    _stayVariables = [];
    _editingVariables = [];

    return self;
}

- (void)suggestValue:(id)aValue forVariable:(id)aVariable
{
    _solver.suggestValue(aVariable, aValue).resolve();
}

- (void)suggestValue:(id)aValue1 forVariable:(id)aVariable1 value:(id)aValue2 forVariable:(id)aVariable2
{
    _solver.suggestValue(aVariable1, aValue1).suggestValue(aVariable2, aValue2);
    _solver.resolve();
}

- (void)addEditingVariable:(id)aVariable
{
    if (![_editingVariables containsObjectIdenticalTo:aVariable])
    {
        _solver.addEditVar(aVariable);
        [_editingVariables addObject:aVariable];
    }
}

- (void)_addCassowaryConstraint:(Object)aCassowaryConstraint
{
    try
    {
        _solver.addConstraint(aCassowaryConstraint);
        CPLog.debug(".addConstraint(" + aCassowaryConstraint.toString() + ")");
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

- (CPString)description
{
    return _solver.getInternalInfo();
}

@end
