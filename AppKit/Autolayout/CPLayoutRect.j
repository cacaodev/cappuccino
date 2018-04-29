/*
 * CPLayoutRect.j
 * AppKit
 *
 * Created by cacaodev on April 26, 2018.
 * Copyright 2018, cacaodev. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import "CPLayoutAnchor.j"
@import "CPView.j"

@class CPLayoutPoint

@implementation CPLayoutRect : CPObject
{
    CPLayoutXAxisAnchor _leadingAnchor @accessors(getter=leadingAnchor);
    CPLayoutYAxisAnchor _topAnchor     @accessors(getter=topAnchor);
    CPLayoutDimension   _widthAnchor   @accessors(getter=widthAnchor);
    CPLayoutDimension   _heightAnchor  @accessors(getter=heightAnchor);
    CPString            _name          @accessors(getter=name);
    id                  _superItem;
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

+ (id)layoutRectWithName:(CPString)aName inItem:(id)superItem
{
    return [[self alloc] initWithName:aName inItem:superItem];
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
    _superItem = nil;

    return self;
}

- (id)initWithName:(id)aName inItem:(id)superItem
{
    if (aName == nil || superItem == nil)
        [CPException raise:CPInvalidArgumentException format:@"CPLayoutRect " + _cmd + " argument name or item cannot be nil."];

    self = [super init];

    _leadingAnchor = [CPLayoutXAxisAnchor anchorNamed:@"_leading" inItem:self];
    _topAnchor = [CPLayoutYAxisAnchor anchorNamed:@"_top" inItem:self];
    _widthAnchor = [CPLayoutDimension anchorNamed:@"_width" inItem:self];
    _heightAnchor = [CPLayoutDimension anchorNamed:@"_height" inItem:self];
    _name = [aName copy];
    _superItem = superItem;

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
        return [CPString stringWithFormat:@"<%@ %@ %@>", [self class], [self UID], _name];

    return [super description];
}

- (id)bottomAnchor
{
    var result = [_topAnchor anchorByOffsettingWithDimension:_heightAnchor multiplier:1 constant:0];

    if (_name)
        [result _setName:@"_bottom"];

    return result;
}

- (id)trailingAnchor
{
    var result = [_leadingAnchor anchorByOffsettingWithDimension:_widthAnchor multiplier:1 constant:0];

    if (_name)
        [result _setName:@"_trailing"];

    return result;
}

- (id)centerXAnchor
{
    var result = [_leadingAnchor anchorByOffsettingWithDimension:_widthAnchor multiplier:0.5 constant:0];

    if (_name)
        [result _setName:@"_centerX"];

    return result;
}

- (id)centerYAnchor
{
    var result = [_topAnchor anchorByOffsettingWithDimension:_heightAnchor multiplier:0.5 constant:0];

    if (_name)
        [result _setName:@"_centerY"];

    return result;
}

- (id)centerLayoutPoint
{
    return [CPLayoutPoint layoutPointWithXAxisAnchor:[self centerXAnchor] yAxisAnchor:[self centerYAnchor]];
}

- (id)layoutRectByInsettingTop:(double)top leading:(double)leading bottom:(double)bottom trailing:(double)trailing
{
    var topAnchor = [self topAnchor];
    if (top != 0.0)
        topAnchor = [topAnchor anchorByOffsettingWithConstant:top];

    var leadingAnchor = [self leadingAnchor];
    if (leading != 0.0)
        leadingAnchor = [leadingAnchor anchorByOffsettingWithConstant:leading];

    var bottomAnchor = [self bottomAnchor];
    if (bottom != 0.0)
        bottomAnchor = [bottomAnchor anchorByOffsettingWithConstant:-bottom];

    var trailingAnchor = [self trailingAnchor];
    if (trailing != 0.0)
        trailingAnchor = [trailingAnchor anchorByOffsettingWithConstant:-trailing];

    return [[self class] layoutRectWithLeadingAnchor:leadingAnchor topAnchor:topAnchor trailingAnchor:trailingAnchor bottomAnchor:bottomAnchor];
}

- (id)layoutRectByInsettingTopWithDimension:(id)topDim leadingWithDimension:(id)leadDim bottomWithDimension:(id)bottomDim trailingWithDimension:(id)trailDim
{
    var topAnchor = [self topAnchor];
    if (topDim)
        topAnchor = [topAnchor anchorByOffsettingWithDimension:topDim];

    var leadingAnchor = [self leadingAnchor];
    if (leadDim)
        leadingAnchor = [leadingAnchor anchorByOffsettingWithDimension:leadDim];

    var bottomAnchor = [self bottomAnchor];
    if (bottomDim)
        bottomAnchor = [bottomAnchor anchorByOffsettingWithDimension:bottomDim multiplier:-1 constant:0];

    var trailingAnchor = [self trailingAnchor];
    if (trailDim)
        trailingAnchor = [trailingAnchor anchorByOffsettingWithDimension:trailDim multiplier:-1 constant:0];

    return [[self class] layoutRectWithLeadingAnchor:leadingAnchor topAnchor:topAnchor trailingAnchor:trailingAnchor bottomAnchor:bottomAnchor];
}

- (id)layoutRectByInsettingWithConstant:(double)arg1
{
    return [self layoutRectByInsettingTop:arg1 leading:arg1 bottom:arg1 trailing:arg1];
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
            if (aDimension)
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

            if (aDimension)
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

            if (aDimension)
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
            if (aDimension)
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

- (id)layoutRectBySlicingWithDistance:(double)aDistance fromEdge:(CPInteger)anEdge
{
    return [self _rectangleBySlicingWithDimension:nil plusConstant:aDistance fromEdge:anEdge];
}

- (id)layoutRectBySlicingWithDimension:(id)aDimension fromEdge:(CPInteger)anEdge
{
    return [self _rectangleBySlicingWithDimension:aDimension plusConstant:0 fromEdge:anEdge];
}

- (id)layoutRectBySlicingWithProportion:(double)aProportion fromEdge:(CPInteger)anEdge
{
      var anchor;

      switch (anEdge)
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

    var dimension = [anchor anchorByMultiplyingByConstant:aProportion];

    return [[self class] layoutRectBySlicingWithDimension:dimension fromEdge:anEdge];
}

- (CGRect)valueInEngine:(id)anEngine
{
    var x = [_leadingAnchor valueInEngine:anEngine],
        y = [_topAnchor valueInEngine:anEngine],
        w = [_widthAnchor valueInEngine:anEngine],
        h = [_heightAnchor valueInEngine:anEngine];

    return CGRectMake(x, y, w, h);
}

- (id)layoutRectWithName:(id)arg1
{
    return [[[self class] alloc] initWithLeadingAnchor:_leadingAnchor topAnchor:_topAnchor widthAnchor:_widthAnchor heightAnchor:_heightAnchor name:arg1];
}

- (id)constraintsEqualToLayoutRect:(id)arg1
{
    var leading = [[self leadingAnchor] constraintEqualToAnchor:[arg1 leadingAnchor]],
        top = [[self topAnchor] constraintEqualToAnchor:[arg1 topAnchor]],
        width = [[self widthAnchor] constraintEqualToAnchor:[arg1 widthAnchor]],
        height = [[self heightAnchor] constraintEqualToAnchor:[arg1 heightAnchor]];

    return @[leading, top, width, height];
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

@implementation CPLayoutRect (CPLayoutItemProtocol)

- (void)addConstraint:(CPLayoutConstraint)aConstraint
{
    [self addConstraints:@[aConstraint]];
}

- (void)addConstraints:(CPArray)theConstraints
{
    // TODO rewrite addConstraints in the context of a layoutRect and ignore superitem.
    [[self _superitem] addConstraints:theConstraints];
}

- (void)removeConstraint:(CPLayoutConstraint)aConstraint
{
    [self removeConstraints:@[aConstraint]];
}

- (void)removeConstraints:(CPArray)theConstraints
{
    // TODO rewrite removeConstraints in the context of a layoutRect and ignore superitem.
    [[self _superitem] removeConstraints:theConstraints];
}

- (id)_superitem
{
    if (_superItem !== nil)
        return _superItem;

    var leadingItem = [[self leadingAnchor] _nearestAncestorLayoutItem],
        topItem = [[self topAnchor] _nearestAncestorLayoutItem],
        widthItem = [[self widthAnchor] _nearestAncestorLayoutItem],
        heightItem = [[self heightAnchor] _nearestAncestorLayoutItem];

    var ancestor1 = [leadingItem _ancestorSharedWithItem:topItem],
        ancestor2 = [ancestor1 _ancestorSharedWithItem:widthItem],
        ancestor3 = [ancestor2 _ancestorSharedWithItem:heightItem];

    return [ancestor3 _superitem];
}

- (id)_layoutEngine
{
    return [[self _superitem] _layoutEngine];
}

- (CPString)debugID
{
    return _name || [self className];
}

- (id)_ancestorSharedWithItem:(id)anItem
{
    return _CPLayoutItemSharedAncestor(self, anItem);
}

- (CPLayoutAnchor)layoutAnchorForAttribute:(CPLayoutAttribute)anAttribute
{
    if (anAttribute == CPLayoutAttributeLastBaseline || anAttribute == CPLayoutAttributeFirstBaseline)
        anAttribute = CPLayoutAttributeBottom;

    return _CPLayoutItemAnchorForAttribute(self, anAttribute);
}

- (void)_setNeedsConstraintBasedLayout
{
}

- (void)_engineDidChangeVariableOfType:(CPInteger)aType
{
}

- (CGInset)alignmentRectInsets
{
    return CGInsetMakeZero();
}

- (CGRect)frame
{
    return CGRectMakeZero();
}

@end

@implementation CPView (CPLayoutRect)

- (CPLayoutRect)layoutRect
{
    return [CPLayoutRect layoutRectWithLeadingAnchor:[self leadingAnchor] topAnchor:[self topAnchor] widthAnchor:[self widthAnchor] heightAnchor:[self heightAnchor]];
}

@end
