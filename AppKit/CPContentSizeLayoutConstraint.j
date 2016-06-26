@import <Foundation/_CGGeometry.j>
@import "CPLayoutConstraint.j"
@import "CPLayoutAnchor.j"

@class CPLayoutConstraintEngine

@implementation CPContentSizeLayoutConstraint : CPLayoutConstraint
{
    CPLayoutPriority _huggingPriority          @accessors(property=huggingPriority);
    CPLayoutPriority _compressPriority         @accessors(property=compressPriority);
}

- (id)initWithLayoutItem:(id)anItem value:(float)value huggingPriority:(CPLayoutPriority)huggingPriority compressionResistancePriority:(CPLayoutPriority)compressionResistancePriority orientation:(CPLayoutConstraintOrientation)orientation
{
    self = [super init];

    if (self)
    {
        [super _init];

        _huggingPriority  = huggingPriority;
        _compressPriority = compressionResistancePriority;
        _constant = value;
        _container = anItem;
        var attribute = orientation ? CPLayoutAttributeHeight : CPLayoutAttributeWidth;
        _firstAnchor = [CPLayoutAnchor layoutAnchorWithItem:anItem attribute:attribute];
        _secondAnchor = nil;
    }

    return self;
}

- (CPLayoutConstraintOrientation)orientation
{
    return ([_firstAnchor attribute] == CPLayoutAttributeHeight) ? CPLayoutConstraintOrientationVertical : CPLayoutConstraintOrientationHorizontal;
}

- (CPString)_constraintType
{
    return @"SizeConstraint";
}

- (id)copy
{
    return [[[self class] alloc] initWithLayoutItem:[self firstItem] value:_constant huggingPriority:_huggingPriority compressionResistancePriority:_compressPriority orientation:[self orientation]];
}

- (BOOL)isEqual:(id)anObject
{
    if (anObject === self)
        return YES;

    if (!anObject || [anObject class] !== [self class] || [[anObject firstAnchor] isEqual:[self firstAnchor]] || [anObject constant] !== _constant || [anObject huggingPriority] !== _huggingPriority || [anObject compressPriority] !== _compressPriority)
        return NO;

    return YES;
}

- (CPArray)_engineConstraints
{
    if (!_engineConstraints)
        _engineConstraints = [CPLayoutConstraintEngine _engineConstraintsFromContentSizeConstraint:self];

    return _engineConstraints;
}

- (void)resolveConstant
{
}

- (Variable)variableForOrientation
{
    var item = [self firstItem];
    return [self orientation] ? [item _variableHeight] : [item _variableWidth];
}

- (Variable)valueForOrientation
{
    var itemRect = [[self firstItem] frame];

    return [self orientation] ? CGRectGetHeight(itemRect) : CGRectGetWidth(itemRect);
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@:[%@(%@)] hug=%@ compressionResistance=%@%@", [self orientation] ? "V" : "H", [[self firstItem] debugID], _constant, _huggingPriority, _compressPriority, _active ? "" : " [inactive]"];
}

@end
