@import <Foundation/CPObject.j>

@implementation CPLayoutConstraintEngine : CPObject
{
    SimplexSolver   _solver @accessors(getter=_solver);
    CPArray         _constraints @accessors(getter=constraints);
    CPArray         _stayVariables;
    id              _context;
}

- (id)init
{
    self = [super init];

    _solver = new c.SimplexSolver();
CPLog.debug("created solver");
    _solver.autoSolve = false;
    _constraints = [];
    _stayVariables = [];
    _context = nil;

    return self;
}

- (void)suggestValue:(id)aValue forVariable:(id)aVariable
{
    _solver.suggestValue(aVariable, aValue).resolve();
}

- (void)_suggestValue:(id)aValue1 forVariable:(id)aVariable1 value:(id)aValue2 forVariable:(id)aVariable2 context:(id)aContext
{
    if (aContext !== _context)
    {
        //if (_context)
        try
        {
            _solver.removeAllEditVars();
            _solver.addEditVar(aVariable1).addEditVar(aVariable2);
        }
        catch (e)
        {
            CPLog.warn(e);
        }

        _context = aContext;
    }

    _solver.suggestValue(aVariable1, aValue1).suggestValue(aVariable2, aValue2);
    _solver.resolve();
}

- (void)solve
{
    _solver.solve();
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

- (BOOL)_addCassowaryConstraint:(Object)aCassowaryConstraint
{
    var result;

    try
    {
        _solver.addConstraint(aCassowaryConstraint);
        CPLog.debug(".addConstraint(" + aCassowaryConstraint.toString() + ")");
        result = YES;
    }
    catch (e)
    {
        CPLog.debug(_cmd + e);
        result = NO;
    }

    return result;
}

- (BOOL)_removeCassowaryConstraint:(Object)aCassowaryConstraint
{
    var result;

    try
    {
        _solver.removeConstraint(aCassowaryConstraint);
        CPLog.debug(".removeConstraint(" + aCassowaryConstraint.toString() + ")");
        result = YES;
    }
    catch (e)
    {
        CPLog.debug(_cmd + e);
        result = NO;
    }

    return result;
}

- (CPString)description
{
    return _solver.getInternalInfo();
}

@end
