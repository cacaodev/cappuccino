@import <AppKit/CGGeometry.j>
@import "CPLayoutConstraint.j"

CPLayoutConstraintOrientationHorizontal  = 0;
CPLayoutConstraintOrientationVertical  = 1;

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
        _secondItem = nil;
        _uuid = uuidgen();
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

- (Object)toJSON
{
    var frame = [_firstItem frame],
        value = _orientation ? CGRectGetHeight(frame) : CGRectGetWidth(frame),
        //inset = [_firstItem alignmentRectInsets],
        //offset = _orientation ? (inset.top + inset.bottom) : (inset.left + inset.right),
        constant = _constant, //+ offset,
        containerUID = [_firstItem UID],
        containerName = [_firstItem debugID];        

    return [{uuid           : _uuid + "_HUG",
       relation             : CPLayoutRelationLessThanOrEqual,
       priority             : _huggingPriority,
       type                 : "SizeConstraint",
       container            : containerUID,
       containerName        : containerName,
       value                : value,
       constant             : constant,
       orientation          : _orientation},
       
       {uuid                : _uuid + "_COMPR",
       relation             : CPLayoutRelationGreaterThanOrEqual,
       priority             : _compressPriority,
       type                 : "SizeConstraint",
       container            : containerUID,
       containerName        : containerName,
       value                : value,
       constant             : constant,
       orientation          : _orientation}];
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@:[%@(%@)] hug=%@ compressionResistance=%@", [self _orientationDescription], ([_firstItem debugID]), _constant, _huggingPriority, _compressPriority];
}

- (CPString)_orientationDescription
{
    return _orientation ? "V" : "H";
}

@end
