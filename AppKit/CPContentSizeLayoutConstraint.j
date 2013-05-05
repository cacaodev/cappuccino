@import "CPLayoutConstraint.j"

@implementation CPContentSizeLayoutConstraint : CPLayoutConstraint
{
    double _huggingPriority;
    double _compressPriority;
    int    _orientation;

    Object _huggingConstraint;
    Object _compressConstraint;
}

- (id)initWithLayoutItem:(id)anItem value:(float)value huggingPriority:(double)huggingPriority compressionResistancePriority:(double)compressionResistancePriority orientation:(int)orientation
{
    self = [super init];
    if (self)
    {
        _huggingConstraint = nil;
        _compressConstraint = nil;

        _huggingPriority = huggingPriority;
        _compressPriority = compressionResistancePriority;

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

    var variable = (_orientation === CPLayoutConstraintOrientationHorizontal) ? [_firstItem _variableWidth] : [_firstItem _variableHeight];

    _huggingConstraint  = [self _cassowaryConstraintWithVariable:variable operator:c.LEQ priority:_huggingPriority];
    _compressConstraint = [self _cassowaryConstraintWithVariable:variable operator:c.GEQ priority:_compressPriority];

    // TODO: Fix priority - depends on compression/hugging priorities and if we change the size and hit a size constraint.
    //[anEngine addStayVariable:variable strength:c.Strength.medium weight:1];

    [anEngine _addCassowaryConstraint:_huggingConstraint];
    [anEngine _addCassowaryConstraint:_compressConstraint];
    [constraintsInEngine addObject:self];

    return YES;
}

- (BOOL)removeFromEngine:(id)anEngine
{
CPLog.debug(self +_cmd);
    var constraintsInEngine = [anEngine constraints];

    if (![constraintsInEngine containsObjectIdenticalTo:self])
        return NO;

    [anEngine _removeCassowaryConstraint:_compressConstraint];
    [anEngine _removeCassowaryConstraint:_huggingConstraint];

    [constraintsInEngine removeObject:self];

    return YES;
}

- (Object)_cassowaryConstraintWithVariable:(Object)aVariable operator:(Object)operator priority:(double)aPriority
{
    var variableExp = new c.Expression(aVariable),
        constantExp = new c.Expression([self constant]);

    return (new c.Inequality(variableExp, operator, constantExp, c.Strength.medium, aPriority));
}

- (void)setConstant:(double)aConstant inEngine:(id)anEngine
{
    if (!anEngine || aConstant === [self constant])
        return;

    var shouldAdd = [self removeFromEngine:anEngine];

    if (aConstant === -1) // CPViewNoInstrinsicMetric
        return;

    [self setConstant:aConstant];

    if (shouldAdd)
        [self addToEngine:anEngine];
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@:[%@(%@)] hug=%@ compressionResistance=%@", (_orientation ? "H:" : "W:"), ([_firstItem identifier] || _firstItem), [self constant], _huggingPriority, _compressPriority];
}

@end