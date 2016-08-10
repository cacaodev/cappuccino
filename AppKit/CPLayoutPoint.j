@import <Foundation/CPObject.j>

@implementation CPLayoutPoint : CPObject
{
    CPLayoutAnchor _xAxisAnchor @accessors(getter=xAxisAnchor);
    CPLayoutAnchor _yAxisAnchor @accessors(getter=yAxisAnchor);
}

- (CPArray)constraintsEqualToLayoutPoint:(id)arg1
{
  var xConstraint = [_xAxisAnchor constraintEqualToAnchor:[arg1 xAxisAnchor]];
  var yConstraint = [_yAxisAnchor constraintEqualToAnchor:[arg1 yAxisAnchor]];

  return @[xConstraint, yConstraint];
}

- (BOOL)isEqual:(id)arg1
{
  if (arg1 === self)
    return YES;

    return [arg1 isKindOfClass:[CPLayoutPoint class]] && [_xAxisAnchor isEqual:[arg1 xAxisAnchor]] && [_yAxisAnchor isEqual:[arg1 yAxisAnchor]];
}

+ (id)layoutPointWithXAxisAnchor:(id)arg1 yAxisAnchor:(id)arg2
{
    return [[CPLayoutPoint alloc] initWithXAxisAnchor:arg1 yAxisAnchor:arg2];
}

- (id)layoutPointByOffsettingWithXOffset:(double)arg1 yOffset:(double)arg2
{
    var xAnchor = ( arg1 != 0.0 ) ? [_xAxisAnchor anchorByOffsettingWithConstant:arg1] : _xAxisAnchor;
    var yAnchor = ( arg2 != 0.0 ) ? [_yAxisAnchor anchorByOffsettingWithConstant:arg2] : _yAxisAnchor;

    return [CPLayoutPoint layoutPointWithXAxisAnchor:xAnchor yAxisAnchor:yAnchor];
}

+ (id)pointWithXAxisAnchor:(id)arg1 yAxisAnchor:(id)arg2
{
    return [self layoutPointWithXAxisAnchor:arg1 yAxisAnchor:arg2];
}

- (id)initWithXAxisAnchor:(id)arg1 yAxisAnchor:(id)arg2
{
  self = [super init];

  _xAxisAnchor = arg1;
  _yAxisAnchor = arg2;

  return self;
}

- (id)pointByOffsettingWithXOffsetDimension:(id)arg1 yOffsetDimension:(id)arg2
{
    return [self layoutPointByOffsettingWithXOffsetDimension:arg1 yOffsetDimension:arg2];
}

- (CGPoint)valueInItem:(id)arg1
{
    return CGPointMake([_xAxisAnchor valueInItem:arg1], [_yAxisAnchor valueInItem:arg1]);
}

- (id)layoutPointByOffsettingWithXOffsetDimension:(id)arg1 yOffsetDimension:(id)arg2
{
    var xanchor = ( arg1 ) ? [_xAxisAnchor _anchorByOffsettingWithDimension:arg1] : _xAxisAnchor;
    var yanchor = ( arg2 ) ? [_yAxisAnchor _anchorByOffsettingWithDimension:arg2] : _yAxisAnchor;

    return [CPLayoutPoint _layoutPointWithXAxisAnchor:xanchor yAxisAnchor:yanchor];
}

- (id)pointByOffsettingWithXOffset:(double)arg1 yOffset:(double)arg2
{
    return [self layoutPointByOffsettingWithXOffset:arg1 yOffset:arg2];
}

- (id)_is_superitem
{
    return [CPLayoutConstraint _findCommonAncestorOfItem:[_xAxisAnchor _referenceItem] andItem:[_yAxisAnchor _referenceItem]];
}

@end
/*
@implementation CPLayoutPoint (CPCoding)

- (id)initWithCoder:(id)aCoder
{
    self = [super init];

    _xAxisAnchor = [aCoder decodeObjectForKey:@"CPLayoutXAxisAnchor"];
    _yAxisAnchor = [aCoder decodeObjectForKey:@"CPLayoutYAxisAnchor"];

    return self;
}

- (void)encodeWithCoder:(id)aCoder
{
    [aCoder encodeObject:_xAxisAnchor forKey:@"CPLayoutXAxisAnchor"];
    [aCoder encodeObject:_yAxisAnchor forKey:@"CPLayoutYAxisAnchor"];
}

@end
*/
