@import "CPLayoutAnchor.j"

@implementation CPLayoutRect : CPObject
{
    CPLayoutXAxisAnchor _leadingAnchor @accessors(getter=leadingAnchor);
    CPLayoutYAxisAnchor _topAnchor     @accessors(getter=topAnchor);
    CPLayoutDimension   _heightAnchor  @accessors(getter=heightAnchor);
    CPLayoutDimension   _widthAnchor   @accessors(getter=widthAnchor);
    CPString            _name          @accessors(getter=name);
}

+ (id)layoutRectWithLeadingAnchor:(id)arg1 topAnchor:(id)arg2 widthAnchor:(id)arg3 heightAnchor:(id)arg4
{
    return [[self alloc] initWithLeadingAnchor:arg1 topAnchor:arg2 widthAnchor:arg3 heightAnchor:arg4];
}

+ (id)layoutRectWithLeadingAnchor:(id)arg1 topAnchor:(id)arg2 trailingAnchor:(id)arg3 bottomAnchor:(id)arg4
{
    var widthAnchor = [arg1 anchorWithOffsetToAnchor:arg3],
        heightAnchor = [arg2 anchorWithOffsetToAnchor:arg4];

    return [[self alloc] initWithLeadingAnchor:arg1 topAnchor:arg2 widthAnchor:widthAnchor heightAnchor:heightAnchor];
}

+ (id)layoutRectWithCenterXAnchor:(id)arg1 centerYAnchor:(id)arg2 widthAnchor:(id)arg3 heightAnchor:(id)arg4
{
    var leadingAnchor = [arg1 anchorByOffsettingWithDimension:arg3 multiplier:-0.5 constant:0],
        topAnchor = [arg3 anchorByOffsettingWithDimension:arg4 multiplier:-0.5 constant:0];

    return [[self alloc] initWithLeadingAnchor:leadingAnchor topAnchor:topAnchor widthAnchor:arg3 heightAnchor:arg4];
}

+ (id)layoutRectWithCenterLayoutPoint:(id)arg1 widthAnchor:(id)arg2 heightAnchor:(id)arg3
{
    return [self layoutRectWithCenterXAnchor:[arg1 xAxisAnchor] centerYAnchor:[arg1 yAxisAnchor] widthAnchor:arg2 heightAnchor:arg3];
}

- (id)initWithLeadingAnchor:(id)arg1 topAnchor:(id)arg2 widthAnchor:(id)constant heightAnchor:(id)arg4
{
    return [self initWithLeadingAnchor:arg1 topAnchor:arg2 widthAnchor:constant heightAnchor:arg4 name:nil];
}

- (id)initWithLeadingAnchor:(id)arg1 topAnchor:(id)arg2 widthAnchor:(id)arg3 heightAnchor:(id)arg4 name:(id)arg5
{
    self = [super init];

    _leadingAnchor = [arg1 copy];
    _topAnchor = [arg2 copy];
    _widthAnchor = [arg3 copy];
    _heightAnchor = [arg4 copy];
    _name = [arg5 copy];

    return self;
}

- (BOOL)isEqual:(id)arg1 {

    if (self == arg1)
        return YES;

    return [arg1 isKindOfClass:[CPLayoutRect class]] && [self isEqualToRectangle:arg1];
}

- (BOOL)isEqualToRectangle:(id)arg1
{
    return ([[self leadingAnchor] isEqual:[arg1 leadingAnchor]] &&
            [[self topAnchor] isEqual:[arg1 topAnchor]] &&
            [[self widthAnchor] isEqual:[arg1 widthAnchor]] &&
            [[self heightAnchor] isEqual:[arg1 heightAnchor]] &&
            [[self name] isEqualToString:[arg1 name]]);
}

- (id)description
{
    if (_name !== nil)
        return [CPString stringWithFormat:@"%@ <%@ %@>", [self class], self, _name];

    return [super description];
}

- (id)centerYAnchor
{
    var result = [_topAnchor anchorByOffsettingWithDimension:_heightAnchor multiplier:0.5 constant:0];

    if (_name)
      result = [result anchorWithName:[CPString stringWithFormat:@"%@__centerY", _name]];

    return result;
}

- (id)bottomAnchor
{
    var result = [_topAnchor anchorByOffsettingWithDimension:_heightAnchor multiplier:1 constant:0];

    if (_name)
      result = [result anchorWithName:[CPString stringWithFormat:@"%@__bottom", _name]];

    return result;
}

- (id)centerXAnchor
{
    var result = [_leadingAnchor anchorByOffsettingWithDimension:_widthAnchor multiplier:0.5 constant:0];

    if (_name)
      result = [result anchorWithName:[CPString stringWithFormat:@"%@__centerX", _name]];

    return result;
}

- (id)trailingAnchor
{
    var result = [_leadingAnchor anchorByOffsettingWithDimension:_widthAnchor multiplier:1 constant:0];

    if (_name)
        result = [result anchorWithName:[CPString stringWithFormat:@"%@__trailing", _name]];

    return result;
}

- (id)_is_superitem
{
    var leadingItem = [[self leadingAnchor] _nearestAncestorLayoutItem];
    var topItem = [[self topAnchor] _nearestAncestorLayoutItem];
    var widthItem = [[self widthAnchor] _nearestAncestorLayoutItem];
    var heightItem = [[self heightAnchor] _nearestAncestorLayoutItem];

    var v13 = [leadingItem is_ancestorSharedWithItem:topItem];
    var v14 = [v13 is_ancestorSharedWithItem:widthItem];
    var v15 = [v14 is_ancestorSharedWithItem:heightItem];

    return [v15 _is_superitem];
}

- (id)centerLayoutPoint
{
    return [CPLayoutPoint layoutPointWithXAxisAnchor:[self centerXAnchor] yAxisAnchor:[self centerYAnchor]];
}

- (id)layoutRectByInsettingTop:(double)arg1 leading:(double)arg2 bottom:(double)arg3 trailing:(double)arg4
{
    var topAnchor = [self topAnchor];
    if (arg1 != 0.0)
        topAnchor = [topAnchor anchorByOffsettingWithConstant:arg1];

    var leadingAnchor = [self leadingAnchor];
    if (arg2 != 0.0)
        leadingAnchor = [leadingAnchor anchorByOffsettingWithConstant:arg2];

    var bottomAnchor = [self bottomAnchor];
    if (arg3 != 0.0)
        bottomAnchor = [bottomAnchor anchorByOffsettingWithConstant:arg3];

    var trailingAnchor = [self trailingAnchor];
    if (arg4 != 0.0)
        trailingAnchor = [trailingAnchor anchorByOffsettingWithConstant:arg4];

    return [[self class] layoutRectWithLeadingAnchor:leadingAnchor topAnchor:topAnchor trailingAnchor:trailingAnchor bottomAnchor:bottomAnchor];
}

- (id)layoutRectByInsettingTopWithDimension:(id)arg1 leadingWithDimension:(id)arg2 bottomWithDimension:(id)arg3 trailingWithDimension:(id)arg4
{
    var topAnchor = [self topAnchor];
    if (arg1)
        topAnchor = [topAnchor anchorByOffsettingWithDimension:arg1];

    var leadingAnchor = [self leadingAnchor];
    if (arg2)
        leadingAnchor = [leadingAnchor anchorByOffsettingWithDimension:arg2];

    var bottomAnchor = [self bottomAnchor];
    if (arg3)
        bottomAnchor = [bottomAnchor anchorByOffsettingWithDimension:arg3 multiplier:-1 constant:0];

    var trailingAnchor = [self trailingAnchor];
    if (arg4)
        trailingAnchor = [trailingAnchor anchorByOffsettingWithDimension:arg4 multiplier:-1 constant:0];

    return [[self class] layoutRectWithLeadingAnchor:leadingAnchor topAnchor:topAnchor trailingAnchor:trailingAnchor bottomAnchor:bottomAnchor];
}

- (id)_rectangleBySlicingWithDimension:(id)aDimension plusConstant:(float)aConstant fromEdge:(int)anEdge
{
  var leadingAnchor,
      topAnchor,
      widthAnchor,
      heightAnchor;

  switch ( anEdge )
  {
    case 0:
      if ( aDimension )
      {
        heightAnchor = [aDimension anchorByAddingConstant:aConstant];
      }
      else
      {
        var v13 = [self heightAnchor];
        var v14 = [v13 anchorByMultiplyingByConstant:0];
        heightAnchor = [v14 anchorByAddingConstant:aConstant];
      }

      leadingAnchor = [self leadingAnchor];
      topAnchor = [self topAnchor];
      widthAnchor = [self widthAnchor];
      break;
    case 1:
      leadingAnchor = [self leadingAnchor];

      if ( aDimension )
      {
         widthAnchor = [aDimension anchorByAddingConstant:aConstant];
      }
      else
      {
        var v19 = [self widthAnchor];
        var v20 = [v19 anchorByMultiplyingByConstant:0];
        widthAnchor = [v20 anchorByAddingConstant:aConstant];
      }

      topAnchor = [self topAnchor];
      heightAnchor = [self heightAnchor];
      break;
    case 2:
      leadingAnchor = [self leadingAnchor];
      var bottomAnchor = [self bottomAnchor];

      if ( aDimension )
      {
        topAnchor = [bottomAnchor anchorByOffsettingWithDimension:aDimension multiplier:-0.5 constant:aConstant];
        heightAnchor = [aDimension anchorByAddingConstant:aConstant];
      }
      else
      {
        topAnchor = [bottomAnchor anchorByOffsettingWithConstant:aConstant];
        var v16 = [self heightAnchor];
        var v17 = [v16 anchorByMultiplyingByConstant:0];
        heightAnchor = [v17 anchorByAddingConstant:aConstant];
      }
      widthAnchor = [self widthAnchor];
      break;
    case 3:
      var trailingAnchor = [self trailingAnchor];
      if ( aDimension )
      {
        leadingAnchor = [trailingAnchor anchorByOffsettingWithDimension:aDimension multiplier:-0.5 constant:aConstant];
        widthAnchor = [aDimension anchorByAddingConstant:aConstant];
      }
      else
      {
        leadingAnchor = [trailingAnchor anchorByOffsettingWithConstant:aConstant];
        var v19 = [self widthAnchor];
        var v20 = [v19 anchorByMultiplyingByConstant:0];
        widthAnchor = [v20 anchorByAddingConstant:aConstant];
      }
      topAnchor = [self topAnchor];
      heightAnchor = [self heightAnchor];
      break;
    default:
      break;
  }

    return [CPLayoutRect layoutRectWithLeadingAnchor:leadingAnchor topAnchor:topAnchor widthAnchor:widthAnchor heightAnchor:heightAnchor];
}

- (id)layoutRectBySlicingWithDistance:(double)arg1 fromEdge:(CPInteger)arg2
{
    return [self _rectangleBySlicingWithDimension:nil plusConstant:arg1 fromEdge:arg2];
}

- (id)layoutRectBySlicingWithDimension:(id)arg1 fromEdge:(CPInteger)arg2
{
    return [self _rectangleBySlicingWithDimension:arg1 plusConstant:0 fromEdge:arg2];
}

- (id)layoutRectBySlicingWithProportion:(double)arg1 fromEdge:(CPInteger)arg2
{
  var anchor;

  switch (arg2)
  {
    case 0:
    case 2:
      anchor = [self heightAnchor];
      break;
    case 1:
    case 3:
      anchor = [self widthAnchor];
      break;
    default:
      return nil;
  }

    var dimension = [anchor anchorByMultiplyingByConstant:arg1];
    return [[self class] layoutRectBySlicingWithDimension:dimension fromEdge:arg2];
}
/*
- (id)observableValueInItem:(id)arg1
{
    return [CPLayoutRectObservable observableForRect:self inItem:arg1];
}
*/
- (CGRect)valueInItem:(id)arg1
{
    return CGRectMake([_leadingAnchor valueInItem:arg1], [_topAnchor valueInItem:arg1], [_widthAnchor valueInItem:arg1], [_heightAnchor valueInItem:arg1]);
}

- (id)layoutRectWithName:(id)arg1
{
    return [[[self class] alloc] initWithLeadingAnchor:_leadingAnchor topAnchor:_topAnchor widthAnchor:_widthAnchor heightAnchor:_heightAnchor name:arg1];
}

- (id)constraintsEqualToLayoutRect:(id)arg1
{
    var leading = [[self leadingAnchor] constraintEqualToAnchor:[arg1 leadingAnchor]],
        trailing = [[self trailingAnchor] constraintEqualToAnchor:[arg1 trailingAnchor]],
        top = [[self topAnchor] constraintEqualToAnchor:[arg1 topAnchor]],
        bottom = [[self bottomAnchor] constraintEqualToAnchor:[arg1 bottomAnchor]];

    return @[leading, trailing, top, bottom];
}

- (id)constraintsContainingWithinLayoutRect:(id)arg1
{
    var leading = [[self leadingAnchor] constraintGreaterThanOrEqualToAnchor:[arg1 leadingAnchor]],
        trailing = [[self trailingAnchor] constraintLessThanOrEqualToAnchor:[arg1 trailingAnchor]],
        top = [[self topAnchor] constraintGreaterThanOrEqualToAnchor:[arg1 topAnchor]],
        bottom = [[self bottomAnchor] constraintLessThanOrEqualToAnchor:[arg1 bottomAnchor]];

    return @[leading, trailing, top, bottom];
}

@end
