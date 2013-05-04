@import "CPLayoutConstraint.j"

@implementation CPContentSizeLayoutConstraint : CPLayoutConstraint
{
    double _huggingPriority;
    double _compressionResistancePriority;
    int    _orientation;

    Object _huggingConstraint;
    Object _compressionResistanceConstraint;
}

- (id)initWithLayoutItem:(id)anItem value:(float)value huggingPriority:(double)huggingPriority compressionResistancePriority:(double)compressionResistancePriority orientation:(int)orientation
{
    self = [super init];
    if (self)
    {
        _huggingConstraint = nil;
        _compressionResistanceConstraint = nil;

        _huggingPriority = huggingPriority;
        _compressionResistancePriority = compressionResistancePriority;

        [self setConstant:value];
        [self setFirstItem:anItem];
        _orientation = orientation;
    }

    return self;
}

- (BOOL)addToEngine:(id)anEngine
{
CPLog.debug(self +_cmd);
    var constraintsInEngine = [anEngine constraints];

    if ([constraintsInEngine containsObjectIdenticalTo:self])
        return NO;

    _huggingConstraint = [self _cassowaryConstraintWithOperator:c.LEQ priority:_huggingPriority];
    _compressionResistanceConstraint = [self _cassowaryConstraintWithOperator:c.GEQ priority:_compressionResistancePriority];

    [anEngine _addCassowaryConstraint:_huggingConstraint];
    [anEngine _addCassowaryConstraint:_compressionResistanceConstraint];
    [constraintsInEngine addObject:self];

    return YES;
}

- (BOOL)removeFromEngine:(id)anEngine
{
CPLog.debug(self +_cmd);
    var constraintsInEngine = [anEngine constraints];

    if (![constraintsInEngine containsObjectIdenticalTo:self])
        return NO;

    [anEngine _removeCassowaryConstraint:_huggingConstraint];
    [anEngine _removeCassowaryConstraint:_compressionResistanceConstraint];

    [constraintsInEngine removeObject:self];

    return YES;
}

- (Object)_cassowaryConstraintWithOperator:(Object)operator priority:(double)aPriority
{
    var variable = (_orientation === CPLayoutConstraintOrientationHorizontal) ? [_firstItem _variableWidth] : [_firstItem _variableHeight],
        variableExp = new c.Expression(variable),
        constantExp = new c.Expression([self constant]);

    return (new c.Inequality(variableExp, operator, constantExp, c.Strength.medium, aPriority));
}

- (void)setConstant:(double)aConstant inEngine:(id)anEngine
{
    var shouldAdd = (anEngine && [self removeFromEngine:anEngine]);

    [self setConstant:aConstant];
CPLog.debug(_cmd + aConstant);
    if (shouldAdd)
        [self addToEngine:anEngine];
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@:[%@(%@)] hug=%@ compressionResistance=%@", (_orientation ? "H:" : "W:"), ([_firstItem identifier] || _firstItem), [self constant], _huggingPriority, _compressionResistancePriority];
}

@end