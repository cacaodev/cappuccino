@import <Foundation/CPObject.j>

@implementation CPLayoutConstraintEngine : CPObject
{
    SimplexSolver   _solver @accessors(getter=_solver);
    CPArray         _constraints @accessors(getter=constraints);
    CPArray         _stayVariables;
    id              _context;
    BOOL            _isSolving;
}

- (id)init
{
    self = [super init];

    _solver = new c.SimplexSolver();
CPLog.debug("created solver");
    _solver.autoSolve = false;
    _solver.onsolved = function(observers)
    {
        [observers enumerateObjectsUsingBlock:updateFrameWithObserver];
    };

    _constraints = [];
    _stayVariables = [];
    _context = nil;

    return self;
}

- (void)suggestValue:(id)aValue forVariable:(id)aVariable
{
    _solver.autoSolve = true;
    _solver.addEditVar(aVariable).beginEdit();
    _solver.suggestValue(aVariable, aValue);
    _solver.endEdit();
    _solver.resolve();
    _solver.autoSolve = false;

    // This will force "context" edit vars to be re-added next time;
    if (_context !== nil)
    {
        _context = nil;
        _solver.removeAllEditVars();
    }
}

- (void)_suggestValue:(id)aValue1 forVariable:(id)aVariable1 value:(id)aValue2 forVariable:(id)aVariable2 context:(id)aContext
{
    if (_isSolving)
        return;

    //var d = new Date();
    if (aContext !== _context)
    {
        try
        {
            if (_context)
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

    //CPLog.debug("Solved in " + (new Date() - d));
    _isSolving = NO;
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

var updateFrameWithObserver = function(observer, idx, stop)
{
    var mask = observer.mask,
        target = observer.target;
    //CPLog.debug("Updated view " + observer.target + " mask " + observer.mask);

    if (mask & 6)
    {
        var x = (mask & 2) ? observer[2] : CGRectGetMinX([target frame]),
            y = (mask & 4) ? observer[4] : CGRectGetMinY([target frame]);

        [target setFrameOrigin:CGPointMake(x, y)];
    }

    if (mask & 24)                                // v: wrong wrong wrong ! what if the changed value is 0 ?
    {
        var w = (mask & 8)  ? observer[8]  : CGRectGetWidth([target frame]),
            h = (mask & 16) ? observer[16] : CGRectGetHeight([target frame]);

        [target setFrameSize:CGSizeMake(w, h)];
    }
/*
    if (mask & 6)
        CPLog.debug(target + ". Updated frame origin " + CPStringFromPoint([target frameOrigin]));

    if (mask & 24)
        CPLog.debug(target + ". Updated frame size " + CPStringFromSize([target frameSize]));
*/
    observer.mask = 0;
};