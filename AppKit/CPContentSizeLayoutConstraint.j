@import <Foundation/_CGGeometry.j>
@import "CPLayoutConstraint.j"

@implementation CPContentSizeLayoutConstraint : CPLayoutConstraint
{
    CPLayoutPriority _huggingPriority          @accessors(property=huggingPriority);
    CPLayoutPriority _compressPriority         @accessors(property=compressPriority);
    CPLayoutConstraintOrientation _orientation @accessors(getter=orientation);
}

- (id)initWithLayoutItem:(id)anItem value:(float)value huggingPriority:(CPLayoutPriority)huggingPriority compressionResistancePriority:(CPLayoutPriority)compressionResistancePriority orientation:(CPLayoutConstraintOrientation)orientation
{
    self = [super init];

    if (self)
    {
        [super _init];

        _huggingPriority = huggingPriority;
        _compressPriority = compressionResistancePriority;
        _orientation = orientation;

        _constant = value;
        _container = anItem;
        _firstItem = anItem;
        _secondItem = nil;
    }

    return self;
}

- (CPString)_constraintType
{
    return @"SizeConstraint";
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

- (Variable)variableForOrientation
{
    return _orientation ? [_firstItem _variableHeight] : [_firstItem _variableWidth];
}

- (Variable)valueForOrientation
{
    var itemRect = [_firstItem frame];

    return _orientation ? CGRectGetHeight(itemRect) : CGRectGetWidth(itemRect);
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@:[%@(%@)] hug=%@ compressionResistance=%@%@", _orientation ? "V" : "H", [_firstItem debugID], _constant, _huggingPriority, _compressPriority, _active ? "" : " [inactive]"];
}

@end
