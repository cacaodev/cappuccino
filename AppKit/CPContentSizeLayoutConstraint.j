@import "CPLayoutConstraint.j"

@implementation CPContentSizeLayoutConstraint : CPLayoutConstraint
{
    double _huggingPriority  @accessors(property=huggingPriority);
    double _compressPriority @accessors(property=compressPriority);
    int    _orientation      @accessors(getter=orientation);
}

- (id)initWithLayoutItem:(id)anItem value:(float)value huggingPriority:(double)huggingPriority compressionResistancePriority:(double)compressionResistancePriority orientation:(int)orientation
{
    self = [super init];

    if (self)
    {
        _huggingPriority = huggingPriority;
        _compressPriority = compressionResistancePriority;
        _orientation = orientation;

        _constant = value;
        _firstItem = anItem;
    }

    return self;
}

- (void)registerItemsInEngine:(id)anEngine
{
    [anEngine registerItem:_firstItem forIdentifier:[_firstItem UID]];
}

- (BOOL)addToEngine:(id)anEngine
{
CPLog.debug(self +_cmd);

    [anEngine registerItem:_firstItem forIdentifier:[_firstItem UID]];
    [anEngine addConstraint:self];

    return YES;
}

- (BOOL)removeFromEngine:(id)anEngine
{
CPLog.debug(self +_cmd);

    [anEngine unregisterItemWithIdentifier:[_firstItem UID]];
    [anEngine removeConstraint:self];

    return YES;
}

- (void)setConstant:(CPInteger)aConstant
{
    if (aConstant < 0)
        aConstant = 0;

    if (aConstant !== _constant)
    {
        _constant = aConstant;

        var args = {container:[_firstItem UID], constraints:[{constant:_constant, orientation:_orientation}]};
        [[_firstItem _layoutEngine] sendCommand:"updateSizeConstraints" withArguments:args];
    }
}

- (id)copy
{
    return [[[self class] alloc] initWithLayoutItem:_firstItem value:_constant huggingPriority:_huggingPriority compressionResistancePriority:_compressPriority orientation:_orientation];
}

- (BOOL)isEqual:(id)anObject
{
    if (anObject === self)
        return YES;

    if (!anObject || anObject.isa !== self.isa || [anObject firstItem] !== _firstItem || [anObject orientation] !== _orientation || [anObject constant] !== _constant || [anObject huggingPriority] !== _huggingPriority || [anObject compressPriority] !== _compressPriority)
        return NO;

    return YES;
}

- (Object)toJSON
{
    var frame = [_firstItem frame],
        uuid = [_firstItem UID] + "_" + _orientation,
        value = _orientation ? CGRectGetHeight(frame) : CGRectGetWidth(frame);

    return {
       type                 : "SizeConstraint",
       uuid                 : uuid,
       orientation          : _orientation,
       firstItemUID         : [_firstItem UID],
       firstItemName        : [_firstItem identifier] || [_firstItem className],
       value                : value,
       constant             : _constant,
       huggingPriority      : _huggingPriority,
       compressionPriority  : _compressPriority
    };
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@:[%@(%@)] hug=%@ compressionResistance=%@", (_orientation ? "H:" : "W:"), ([_firstItem identifier] || _firstItem), _constant, _huggingPriority, _compressPriority];
}

@end