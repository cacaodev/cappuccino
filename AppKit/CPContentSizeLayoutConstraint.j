@import "CPLayoutConstraint.j"

@implementation CPContentSizeLayoutConstraint : CPLayoutConstraint
{
    double _huggingPriority;
    double _compressionResistancePriority;
    int    _orientation;
}

- (id)initWithLayoutItem:(id)anItem value:(float)value huggingPriority:(double)huggingPriority compressionResistancePriority:(double)compressionResistancePriority orientation:(int)orientation
{
    self = [super init];
    if (self)
    {
        _huggingPriority = huggingPriority;
        _compressionResistancePriority = compressionResistancePriority;

        [self setConstant:value];
        [self setFirstItem:anItem];
        _orientation = orientation;
    }

    return self;
}

- (void)addToEngine:(id)anEngine
{
    var variable = (_orientation == 0) ? [_firstItem _variableWidth] : [_firstItem _variableHeight],
        variableExp = new c.Expression(variable),
        constantExp = new c.Expression([self constant]);

    var hugging = new c.Inequality(variableExp, c.LEQ, constantExp, c.Strength.medium, _huggingPriority);
    var compression = new c.Inequality(variableExp, c.GEQ, constantExp, c.Strength.medium, _compressionResistancePriority);

    //[anEngine addStayVariable:variable strength:c.Strength.medium weight:1000];

    [anEngine _addCassowaryConstraint:hugging];
    [anEngine _addCassowaryConstraint:compression];
    [[anEngine constraints] addObject:self];
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@ %@ huggingPriority=%@ compressionPriority=%@ value=%@", (_orientation ? "height " : "width"), ([_firstItem identifier] || _firstItem), _huggingPriority, _compressionResistancePriority, [self constant]];
}

@end