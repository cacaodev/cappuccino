/*
 * CPLayoutAnchor.j
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

@import <Foundation/CPObject.j>
@import <Foundation/CPGeometry.j>
@import <Foundation/CPSet.j>

@import "CPLayoutConstraintEngine.j"

@class CPLayoutConstraint
@class _CPCibCustomView

@global _CPLayoutItemIsDescendantOf

@typedef Expression
@typedef Variable
@typedef CPLayoutAnchorType

var CPLayoutAnchorTypeSimple    = 0;
var CPLayoutAnchorTypeAxis      = 2;
var CPLayoutAnchorTypeDimension = 4;
var CPLayoutAnchorTypeComposite = 8;

var CPLayoutAttributeLabels = ["NotAnAttribute", // 0
                               "left",
                               "right",
                               "top",
                               "bottom",
                               "leading",
                               "trailing",
                               "width",
                               "height",
                               "centerX",
                               "centerY",
                               "lastBaseline",
                               "firstBaseline"];

@implementation CPLayoutAnchor : CPObject
{
    id        _item                     @accessors(getter=item);
    CPInteger _attribute                @accessors(getter=attribute, setter=_setAttribute:);
    CPString  _name                     @accessors(getter=_name, setter=_setName:);
    Variable  _variable                 @accessors(setter=_setVariable:);
    CPSet     _referencedLayoutItems;
    CPArray   _constituentAnchors;
    id        _delegate                 @accessors(property=delegate);
}

+ (id)anchorWithItem:(id)anItem attribute:(CPInteger)anAttribute
{
    return [self anchorWithItem:anItem attribute:anAttribute name:nil];
}

+ (id)anchorWithItem:(id)anItem attribute:(CPInteger)anAttribute name:(CPString)aName
{
    return [[self alloc] initWithItem:anItem attribute:anAttribute name:aName];
}

+ (id)anchorNamed:(CPString)aName inItem:(id)anItem
{
    return [[self alloc] initWithItem:anItem attribute:-1 name:aName];
}

- (id)init
{
    self = [super init];

    _item = nil;
    _attribute = CPLayoutAttributeNotAnAttribute;
    _name = nil;
    _variable = nil;
    _referencedLayoutItems = nil;
    _constituentAnchors = nil;
    _delegate = nil;

    return self;
}

- (id)initWithItem:(id)anItem attribute:(CPInteger)anAttribute name:(CPString)aName
{
    self = [super init];

    _item = anItem;
    _attribute = anAttribute;
    _name = aName;
    _variable = nil;
    _referencedLayoutItems = nil;
    _constituentAnchors = nil;
    _delegate = nil;

    return self;
}

- (id)copy
{
    var copy = [[[self class] alloc] initWithItem:[self _referenceItem] attribute:_attribute name:_name];
    if (_delegate)
        [copy setDelegate:_delegate];
    return copy;
}

- (void)setDelegate:(id)aDelegate
{
    if (![aDelegate respondsToSelector:@selector(engine:didChangeAnchor:)])
        [CPException raise:CPInvalidArgumentException format:@"Delegate %@ should implement engine:didChangeAnchor:"];

    _delegate = aDelegate;
}

- (Variable)variable
{
    if (_variable == nil)
    {
        var item = [self _referenceItem],
            prefix = [item UID],
            engine = [item _layoutEngine];
#if DEBUG
            prefix += "-" + [item debugID];
#endif
        _variable = [engine variableWithPrefix:prefix name:[self name] value:[self valueInLayoutSpace] owner:self];
    }

    return _variable;
}

- (CPString)name
{
    if (_name == nil && _attribute >= 0)
        _name = CPLayoutAttributeLabels[_attribute];

    return _name;
}

- (id)_referenceItem
{
    return [self item];
}

- (CPLayoutAnchorType)_anchorType
{
    return CPLayoutAnchorTypeSimple;
}

- (Expression)expressionInContext:(id)otherAnchor
{
    return engine_expressionFromVariable([self variable]); // Overrided by subclasses.
}

// Default for CPLayout(X|Y)AxisAnchor and CPLayoutDimension
- (float)valueInEngine:(id)anEngine
{
#if defined (CASSOWARY_ENGINE)
    return [self variable].valueOf();
#elif defined (KIWI_ENGINE)
    return [self variable].value();
#endif
}

- (float)valueInLayoutSpace
{
    return 0.0;
}

- (BOOL)isEqual:(id)otherAnchor
{
    if (otherAnchor === self)
        return YES;

    if ([otherAnchor class] !== [self class] || [otherAnchor _referenceItem] !== [self _referenceItem] || [otherAnchor attribute] !== _attribute || [otherAnchor name] !== [self name])
        return NO;

    return YES;
}

- (float)alignmentRectOffset
{
    if (_attribute === CPLayoutAttributeNotAnAttribute)
        return 0;

    var inset = [[self _referenceItem] alignmentRectInsets],
        offset = 0;

    switch (_attribute)
    {
        case CPLayoutAttributeLeading :
        case CPLayoutAttributeLeft     : offset = -inset.left;
        break;
        case CPLayoutAttributeTrailing :
        case CPLayoutAttributeRight    : offset = inset.right;
        break;
        case CPLayoutAttributeTop      : offset = -inset.top;
        break;
        case CPLayoutAttributeBottom   : offset = inset.bottom;
        break;
        case CPLayoutAttributeFirstBaseline :
        case CPLayoutAttributeLastBaseline  :
        case CPLayoutAttributeBaseline : offset = inset.bottom + [_item baselineOffsetFromBottom];
        break;
        case CPLayoutAttributeWidth    : offset = inset.left + inset.right;
        break;
        case CPLayoutAttributeHeight   : offset = inset.top + inset.bottom;
        break;
        case CPLayoutAttributeCenterX  : offset = inset.right - inset.left;
        break;
        case CPLayoutAttributeCenterY  : offset = inset.bottom - inset.top;
        break;
    }

    return offset;
}

- (BOOL)_isParentOfAnchor:(CPLayoutAnchor)otherAnchor
{
    if (otherAnchor == nil)
        return NO;

    var item = [self _referenceItem],
        otherItem = [otherAnchor _referenceItem];

    if (otherItem == nil || [otherItem _superitem] == nil || [item _superitem] == [otherItem _superitem])
        return NO;

    return _CPLayoutItemIsDescendantOf(otherItem, item);
}

- (void)_replaceItem:(id)anItem withItem:(id)otherItem
{
    if (anItem === _item)
        _item = otherItem;
}

- (void)_replaceCustomViewsIfNeeded
{
    if ([_item isKindOfClass:[_CPCibCustomView class]])
        _item = [_item replacementView];
}

- (CPString)descriptionEquation
{
    return [CPString stringWithFormat:@"%@.%@", [[self _referenceItem] debugID], [self name]];
}

- (CPArray)_childAnchors
{
    return @[];
}

- (CPArray)_constituentAnchors
{
    if (_constituentAnchors == nil)
    {
        var result = @[];

        if ([self _anchorType] !== CPLayoutAnchorTypeComposite)
        {
            [result addObject:self];
        }
        else
        {
            [[self _childAnchors] enumerateObjectsUsingBlock:function(anchor, idx, stop)
            {
                [result addObjectsFromArray:[anchor _constituentAnchors]];
            }];
        }

        _constituentAnchors = result;
    }

    return _constituentAnchors;
}

- (CPArray)_referencedLayoutItems
{
    if (_referencedLayoutItems == nil)
    {
        var result = [CPSet set];

        if ([self _anchorType] !== CPLayoutAnchorTypeComposite)
        {
            [result addObject:[self _referenceItem]];
        }
        else
        {
            [[self _childAnchors] enumerateObjectsUsingBlock:function(anchor, idx, stop)
            {
                [result addObjectsFromArray:[anchor _referencedLayoutItems]];
            }];
        }

        _referencedLayoutItems = result;
    }

    return [_referencedLayoutItems allObjects];
}

- (id)_nearestAncestorLayoutItem
{
    if ([self _anchorType] !== CPLayoutAnchorTypeComposite)
        return [self _referenceItem];

    var items = [self _referencedLayoutItems],
        result = nil;

    [items enumerateObjectsUsingBlock:function(layoutItem, idx, stop)
    {
        if (result == nil)
            result = layoutItem;
        else
            result = [CPLayoutConstraint _findCommonAncestorOfItem:result andItem:layoutItem];
    }];

    return result;
}

// CPLayoutAnchor creation

- (CPCompositeLayoutAxisAnchor)anchorAtMidpointToAnchor:(id)anAnchor
{
    var distance = [self anchorWithOffsetToAnchor:anAnchor];

    return [self anchorByOffsettingWithDimension:distance multiplier:0.5 constant:0];
}

- (CPDistanceLayoutDimension)anchorWithOffsetToAnchor:(id)anAnchor
{
    return [CPDistanceLayoutDimension distanceFromAnchor:self toAnchor:anAnchor];
}

- (CPCompositeLayoutAxisAnchor)anchorByOffsettingWithConstant:(float)aConstant
{
    if (aConstant == 0)
        return [self copy];

    return [self anchorByOffsettingWithDimension:nil multiplier:0 constant:aConstant];
}

// CPLayoutConstraint creation

- (CPLayoutConstraint)constraintLessThanOrEqualToConstant:(double)constant
{
    return [self _constraintwithRelation:CPLayoutRelationLessThanOrEqual constant:constant];
}

- (CPLayoutConstraint)constraintGreaterThanOrEqualToConstant:(double)constant
{
    return [self _constraintwithRelation:CPLayoutRelationGreaterThanOrEqual constant:constant];
}

- (CPLayoutConstraint)constraintEqualToConstant:(double)constant
{
    return [self _constraintwithRelation:CPLayoutRelationEqual constant:constant];
}

- (CPLayoutConstraint)constraintLessThanOrEqualToAnchor:(id)otherAnchor
{
    return [self constraintLessThanOrEqualToAnchor:otherAnchor constant:0];
}

- (CPLayoutConstraint)constraintGreaterThanOrEqualToAnchor:(id)otherAnchor
{
    return [self constraintGreaterThanOrEqualToAnchor:otherAnchor constant:0];
}

- (CPLayoutConstraint)constraintEqualToAnchor:(id)otherAnchor
{
    return [self constraintEqualToAnchor:otherAnchor constant:0];
}

- (CPLayoutConstraint)constraintLessThanOrEqualToAnchor:(id)otherAnchor constant:(double)constant
{
    return [self constraintLessThanOrEqualToAnchor:otherAnchor multiplier:1 constant:constant];
}

- (CPLayoutConstraint)constraintGreaterThanOrEqualToAnchor:(id)otherAnchor constant:(double)constant
{
    return [self constraintGreaterThanOrEqualToAnchor:otherAnchor multiplier:1 constant:constant];
}

- (CPLayoutConstraint)constraintEqualToAnchor:(id)otherAnchor constant:(double)constant
{
    return [self constraintEqualToAnchor:otherAnchor multiplier:1 constant:constant];
}

- (CPLayoutConstraint)constraintLessThanOrEqualToAnchor:(id)otherAnchor multiplier:(double)multiplier constant:(double)constant
{
    return [self _constraintwithRelation:CPLayoutRelationLessThanOrEqual toAnchor:otherAnchor multiplier:multiplier constant:constant];
}

- (CPLayoutConstraint)constraintGreaterThanOrEqualToAnchor:(id)otherAnchor multiplier:(double)multiplier constant:(double)constant
{
    return [self _constraintwithRelation:CPLayoutRelationGreaterThanOrEqual toAnchor:otherAnchor multiplier:multiplier constant:constant];
}

- (CPLayoutConstraint)constraintEqualToAnchor:(id)otherAnchor multiplier:(double)multiplier constant:(double)constant
{
    return [self _constraintwithRelation:CPLayoutRelationEqual toAnchor:otherAnchor multiplier:multiplier constant:constant];
}

- (id)_constraintwithRelation:(CPLayoutRelation)aRelation toAnchor:(id)otherAnchor multiplier:(double)multiplier constant:(double)constant
{
    return [CPLayoutConstraint constraintWithAnchor:self relatedBy:aRelation toAnchor:otherAnchor multiplier:multiplier constant:constant];
}

- (id)_constraintwithRelation:(CPLayoutRelation)aRelation constant:(double)constant
{
    return [CPLayoutConstraint constraintWithAnchor:self relatedBy:aRelation toAnchor:nil multiplier:1 constant:constant];
}

@end

@implementation CPLayoutAxisAnchor : CPLayoutAnchor
{
}

- (CPLayoutAnchorType)_anchorType
{
    return CPLayoutAnchorTypeAxis;
}

- (Expression)expressionInContext:(id)otherAnchor
{
    // Are we the container ?
    if ([self _isParentOfAnchor:otherAnchor])
        return engine_expressionFromConstant(0);

    return engine_expressionFromVariable([self variable]);
}

@end

@implementation CPLayoutXAxisAnchor : CPLayoutAxisAnchor

- (float)valueInLayoutSpace
{
    return CGRectGetMinX([[self item] frame]);
}

// CPLayoutAnchor creation

- (CPCompositeLayoutXAxisAnchor)anchorByOffsettingWithDimension:(CPLayoutDimension)distance multiplier:(float)multiplier constant:(float)constant
{
    return [[CPCompositeLayoutXAxisAnchor alloc] initWithAnchor:self plusDimension:distance times:multiplier plus:constant name:nil];
}

@end

@implementation CPLayoutYAxisAnchor : CPLayoutAxisAnchor
{
}

- (float)valueInLayoutSpace
{
    return CGRectGetMinY([[self item] frame]);
}

// CPLayoutAnchor creation

- (CPCompositeLayoutYAxisAnchor)anchorByOffsettingWithDimension:(CPLayoutDimension)distance multiplier:(float)multiplier constant:(float)constant
{
    return [[CPCompositeLayoutYAxisAnchor alloc] initWithAnchor:self plusDimension:distance times:multiplier plus:constant name:nil];
}

@end

@implementation CPLayoutDimension : CPLayoutAnchor
{
}

- (CPLayoutAnchorType)_anchorType
{
    return CPLayoutAnchorTypeDimension;
}

- (Expression)expressionInContext:(id)otherAnchor
{
    return engine_expressionFromVariable([self variable]);
}

- (float)valueInLayoutSpace
{
    var frame = [[self item] frame];
    return (_attribute == CPLayoutAttributeWidth) ? CGRectGetWidth(frame) : CGRectGetHeight(frame);
}

- (id)anchorByMultiplyingByConstant:(float)aMultiplier
{
    return [[CPArithmeticLayoutDimension alloc] initWithMultiplier:aMultiplier dimension:self constant:0];
}

- (id)anchorByAddingConstant:(float)aConstant
{
    return [[CPArithmeticLayoutDimension alloc] initWithMultiplier:1 dimension:self constant:aConstant];
}

- (id)anchorByAddingDimension:(id)aDimension
{
    return [[CPCompositeLayoutDimension alloc] initWithDimension:self plusDimension:aDimension times:1];
}

- (id)anchorBySubtractingDimension:(id)aDimension
{
    return [[CPCompositeLayoutDimension alloc] initWithDimension:self plusDimension:aDimension times:-1];
}

- (id)copy
{
    var copy = [[[self class] alloc] initWithItem:[self _referenceItem] attribute:_attribute name:_name];
    if (_delegate)
        [copy setDelegate:_delegate];
    return copy;
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@.%@", [[self item] debugID], [self name]];
}

@end

@implementation CPCompositeLayoutAxisAnchor : CPLayoutAnchor
{
    CPLayoutXAxisAnchor  _axisAnchor            @accessors(getter=axisAnchor);
    CPLayoutDimension    _dimension             @accessors(getter=dimension);
    float                _constant              @accessors(getter=constant);
    float                _dimensionMultiplier   @accessors(getter=dimensionMultiplier);
}

- (id)copy
{
    return [[[self class] alloc] initWithAnchor:_axisAnchor plusDimension:_dimension times:_dimensionMultiplier plus:_constant name:_name attribute:_attribute];
}

- (BOOL)isEqual:(id)otherAnchor
{
    if (otherAnchor === self)
        return YES;

    if ([otherAnchor class] !== [self class] || ![[otherAnchor axisAnchor] isEqual:_axisAnchor] || ![[otherAnchor dimension] isEqual:_dimension] || [otherAnchor constant] !== _constant || [otherAnchor dimensionMultiplier] !== _dimensionMultiplier)
        return NO;

    return YES;
}

- (CPLayoutAnchorType)_anchorType
{
    return CPLayoutAnchorTypeComposite;
}

- (void)_replaceItem:(id)anItem withItem:(id)otherItem
{
    [_axisAnchor _replaceItem:anItem withItem:otherItem];
    [_dimension _replaceItem:anItem withItem:otherItem];
}

- (void)_replaceCustomViewsIfNeeded
{
    [_axisAnchor _replaceCustomViewsIfNeeded];
    [_dimension _replaceCustomViewsIfNeeded];
}

- (Expression)expressionInContext:(id)otherAnchor
{
    var exp2;

    if (_dimension !== nil && _dimensionMultiplier !== 0)
    {
        exp2 = [_dimension expressionInContext:otherAnchor];

        if (_dimensionMultiplier !== 1)
            exp2 = engine_multiply(exp2, _dimensionMultiplier);
    }
    else {
        exp2 = engine_expressionFromConstant(0);
    }

    if (_constant !== 0)
    {
        var constantExp = engine_expressionFromConstant(_constant);
        exp2 = engine_plus(exp2, constantExp);
    }

    if ([_axisAnchor _isParentOfAnchor:otherAnchor])
        return exp2;

    var exp1 = [_axisAnchor expressionInContext:otherAnchor];

    return engine_plus(exp1, exp2);
}

- (id)_referenceItem
{
    return [_axisAnchor _referenceItem];
}

- (float)valueInLayoutSpace
{
    return [_axisAnchor valueInLayoutSpace] + _dimensionMultiplier * [_dimension valueInLayoutSpace] + _constant;
}

- (float)valueInEngine:(id)anEngine
{
    return [_axisAnchor valueInEngine:anEngine] + _dimensionMultiplier * [_dimension valueInEngine:anEngine] + _constant;
}

- (CPArray)_childAnchors
{
    var result = @[_axisAnchor];

    if (_dimension)
        [result addObject:_dimension];

    return result;
}

- (CPString)descriptionEquation
{
    if ([self name])
        return [super descriptionEquation];

    return [CPString stringWithFormat:@"(%@ + %@x%@ + %@)",[[self axisAnchor] descriptionEquation], [_dimension descriptionEquation], _dimensionMultiplier, _constant];
}

// CPLayoutAnchor creation

- (CPCompositeLayoutAxisAnchor)anchorByOffsettingWithDimension:(CPLayoutDimension)distance multiplier:(float)multiplier constant:(float)constant
{
    return [[[self class] alloc] initWithAnchor:self plusDimension:distance times:multiplier plus:constant name:nil];
}

@end

@implementation CPCompositeLayoutXAxisAnchor : CPCompositeLayoutAxisAnchor
{
}

- (id)initWithAnchor:(id)axisAnchor plusDimension:(id)dimension times:(float)multiplier plus:(float)constant name:(CPString)aName
{
    return [self initWithAnchor:axisAnchor plusDimension:dimension times:multiplier plus:constant name:aName attribute:-1];
}

- (id)initWithAnchor:(id)axisAnchor plusDimension:(id)dimension times:(float)multiplier plus:(float)constant name:(CPString)aName attribute:(CPLayoutAttribute)attr
{
    self = [super initWithItem:[axisAnchor _referenceItem] attribute:attr name:aName];

    _axisAnchor = [axisAnchor copy];
    _dimension = [dimension copy];
    _dimensionMultiplier = _dimension ? multiplier : 0.0;
    _constant = constant;

    return self;
}

- (CPString)description
{
    return [CPString stringWithFormat:@"<%@ 0x%d axisAnchor=%@ dimension=%@ multiplier=%@ constant=%@>", [self class], [self UID], _axisAnchor, _dimension, _dimensionMultiplier, _constant];
}

+ (id)anchorWithItem:(id)anItem attribute:(CPInteger)anAttribute name:(CPString)aName
{
    var multiplier,
        name;

    switch (anAttribute)
    {
        case CPLayoutAttributeTrailing:
        case CPLayoutAttributeRight:
             multiplier = 1;
             name = @"right";
            break;
        case CPLayoutAttributeCenterX:
            multiplier = 0.5;
            name = "centerX";
            break;

        default: [CPException raise:CPInvalidArgumentException format:@"%@ Unknown attribute %@", self, anAttribute];
    }

    return [[self alloc] initWithAnchor:[anItem leftAnchor] plusDimension:[anItem widthAnchor] times:multiplier plus:0 name:name attribute:anAttribute];
}

@end

@implementation CPCompositeLayoutYAxisAnchor : CPCompositeLayoutAxisAnchor
{
}

- (id)initWithAnchor:(id)axisAnchor plusDimension:(id)dimension times:(float)multiplier plus:(float)constant name:(CPString)aName
{
    return [self initWithAnchor:axisAnchor plusDimension:dimension times:multiplier plus:constant name:aName attribute:-1];
}

- (id)initWithAnchor:(id)axisAnchor plusDimension:(id)dimension times:(float)multiplier plus:(float)constant name:(CPString)aName attribute:(CPLayoutAttribute)attr
{
    self = [super initWithItem:[axisAnchor _referenceItem] attribute:attr name:aName];

    _axisAnchor = [axisAnchor copy];
    _dimension = [dimension copy];
    _dimensionMultiplier = _dimension ? multiplier : 0.0;
    _constant = constant;

    return self;
}

+ (id)anchorWithItem:(id)anItem attribute:(CPInteger)anAttribute name:(CPString)aName
{
    var multiplier,
        name;

    switch (anAttribute)
    {
        case CPLayoutAttributeLastBaseline:
        case CPLayoutAttributeFirstBaseline:
        case CPLayoutAttributeBaseline:
            multiplier = 1;
            name = "baseline";
        case CPLayoutAttributeBottom:
            multiplier = 1;
            name = "bottom";
            break;
        case CPLayoutAttributeCenterY:
            multiplier = 0.5;
            name = "centerY";
            break;

        default: [CPException raise:CPInvalidArgumentException format:@"%@ Unknown attribute %@", [self class], anAttribute];
    }

    return [[self alloc] initWithAnchor:[anItem topAnchor] plusDimension:[anItem heightAnchor] times:multiplier plus:0 name:name attribute:anAttribute];
}

@end

@implementation CPCompositeLayoutDimension : CPLayoutDimension
{
    CPLayoutDimension _firstLayoutDimension            @accessors(getter=firstLayoutDimension);
    float             _secondLayoutDimensionMultiplier @accessors(getter=secondLayoutDimensionMultiplier);
    CPLayoutDimension _secondLayoutDimension           @accessors(getter=secondLayoutDimension);
}

- (id)initWithDimension:(id)firstDimension plusDimension:(id)secondDimension times:(float)multiplier
{
    self = [super initWithItem:[firstDimension _referenceItem] attribute:-1 name:nil];

    _firstLayoutDimension = [firstDimension copy];
    _secondLayoutDimension = [secondDimension copy];
    _secondLayoutDimensionMultiplier = multiplier;

    return self;
}

- (id)copy
{
    return [[CPCompositeLayoutDimension alloc] initWithDimension:_firstLayoutDimension plusDimension:_secondLayoutDimension times:_secondLayoutDimensionMultiplier];
}

- (BOOL)isEqual:(id)otherAnchor
{
    if (otherAnchor === self)
        return YES;

    if ([otherAnchor class] !== [self class] || ![[otherAnchor firstLayoutDimension] isEqual:_firstLayoutDimension] || ![[otherAnchor secondLayoutDimension] isEqual:_secondLayoutDimension] || [otherAnchor secondLayoutDimensionMultiplier] !== _secondLayoutDimensionMultiplier)
        return NO;

    return YES;
}

- (CPLayoutAnchorType)_anchorType
{
    return CPLayoutAnchorTypeDimension;
}

- (void)_replaceItem:(id)anItem withItem:(id)otherItem
{
    [_firstLayoutDimension _replaceItem:anItem withItem:otherItem];
    [_secondLayoutDimension _replaceItem:anItem withItem:otherItem];
}

- (void)_replaceCustomViewsIfNeeded
{
    [_firstLayoutDimension _replaceCustomViewsIfNeeded];
    [_secondLayoutDimension _replaceCustomViewsIfNeeded];
}

- (Expression)expressionInContext:(id)aContext
{
    var exp1 = [_firstLayoutDimension expressionInContext:aContext];

    if (_secondLayoutDimensionMultiplier == 0)
        return exp1;

    var exp2 = [_secondLayoutDimension expressionInContext:aContext];

    return engine_plus(exp1, engine_multiply(exp2, _secondLayoutDimensionMultiplier));
}

- (id)_referenceItem
{
    return [_firstLayoutDimension _referenceItem];
}

- (float)valueInLayoutSpace
{
    return [_firstLayoutDimension valueInLayoutSpace] + _secondLayoutDimensionMultiplier * [_secondLayoutDimension valueInLayoutSpace];
}

- (float)valueInEngine:(id)anEngine
{
    return [_firstLayoutDimension valueInEngine:anEngine] + _secondLayoutDimensionMultiplier * [_secondLayoutDimension valueInEngine:anEngine];
}

- (CPArray)_childAnchors
{
    return @[_firstLayoutDimension, _secondLayoutDimension];
}

- (CPString)descriptionEquation
{
    if ([self name])
        return [super descriptionEquation];

    var add_sign = (_secondLayoutDimensionMultiplier >= 0) ? "+" : "-";

    return [CPString stringWithFormat:@"%@ %@ %d x (%@)", [_firstLayoutDimension descriptionEquation], add_sign, ABS(_secondLayoutDimensionMultiplier), [_secondLayoutDimension descriptionEquation]];
}

@end

@implementation CPArithmeticLayoutDimension : CPLayoutDimension
{
    CPLayoutDimension _rootLayoutDimension;
    float             _multiplier;
    float             _constant;
}

/*
- (id)initWithAnchor:(id)arg1
{
  self = [super initWithAnchor:arg1];

  if ( self )
  {
    _rootLayoutDimension = [[arg1 rootLayoutDimension] copy];
    _multiplier = [arg1 multiplier];
    _constant = [arg1 constant];
  }

  return self;
}
*/
- (id)initWithMultiplier:(float)aMultiplier dimension:(id)aDimension constant:(float)aConstant
{
    self = [super initWithItem:[aDimension _referenceItem] attribute:-1 name:nil];

    if ( self )
    {
        _rootLayoutDimension = [aDimension copy];
        _multiplier = aMultiplier;
        _constant = aConstant;
    }

    return self;
}

- (id)copy
{
    return [[[self class] alloc] initWithMultiplier:_multiplier dimension:_rootLayoutDimension constant:_constant];
}

- (float)valueInEngine:(id)anEngine
{
    return [_rootLayoutDimension valueInEngine:anEngine] * _multiplier + _constant;
}

- (float)valueInLayoutSpace
{
    return [_rootLayoutDimension valueInLayoutSpace] * _multiplier + _constant;
}

- (CPArray)_childAnchors
{
    return @[_rootLayoutDimension];
}

- (id)_nearestAncestorLayoutItem
{
    return [_rootLayoutDimension _nearestAncestorLayoutItem];
}

- (Expression)expressionInContext:(id)aContext
{
    var constantExp = engine_expressionFromConstant(_constant);

    if (_multiplier == 0)
        return constantExp;

    var rootExp = [_rootLayoutDimension expressionInContext:aContext];

    return engine_plus(engine_multiply(rootExp, _multiplier), constantExp);
}

- (CPString)descriptionEquation
{
    if ([self name])
        return [super descriptionEquation];

    var add_sign = (_constant >= 0) ? "+" : "-";

    return [CPString stringWithFormat:@"%d x (%@) %@ %d", _multiplier, _rootLayoutDimension, add_sign, ABS(_constant)];
}

@end

@implementation CPDistanceLayoutDimension : CPLayoutDimension
{
    CPLayoutAnchor _minAnchor @accessors(getter=minAnchor);
    CPLayoutAnchor _maxAnchor @accessors(getter=maxAnchor);
}

+ (id)distanceFromAnchor:(id)fromAnchor toAnchor:(id)toAnchor
{
    return [[[self class] alloc] initWithMinAnchor:fromAnchor maxAnchor:toAnchor name:nil];
}

- (id)initWithMinAnchor:(id)minAnchor maxAnchor:(id)maxAnchor name:(CPString)aName
{
    self = [super initWithItem:nil attribute:-1 name:aName];

    _minAnchor = [minAnchor copy];
    _maxAnchor = [maxAnchor copy];
    _name = [aName copy];
    _item = [self _nearestAncestorLayoutItem];

    return self;
}

- (BOOL)isEqual:(id)otherAnchor
{
    if (otherAnchor === self)
        return YES;

    if ([otherAnchor class] !== [self class] || ![[otherAnchor minAnchor] isEqual:_minAnchor] || ![[otherAnchor maxAnchor] isEqual:_maxAnchor] || [otherAnchor _name] !== _name)
        return NO;

    return YES;
}

- (id)copy
{
    return [[[self class] alloc] initWithMinAnchor:_minAnchor maxAnchor:_maxAnchor name:_name];
}

- (CPLayoutAnchorType)_anchorType
{
    return CPLayoutAnchorTypeComposite;
}

- (CPArray)_childAnchors
{
    return @[_minAnchor, _maxAnchor];
}

- (CPString)descriptionEquation
{
    if ([self name])
        return [super descriptionEquation];

    return [CPString stringWithFormat:@"❮%@ ⤑ %@❯", [_minAnchor descriptionEquation], [_maxAnchor descriptionEquation]];
}

- (float)valueInEngine:(id)arg1
{
    return [_maxAnchor valueInEngine:arg1] - [_minAnchor valueInEngine:arg1];
}

- (float)valueInLayoutSpace
{
    return [_maxAnchor valueInLayoutSpace] - [_minAnchor valueInLayoutSpace];
}

- (Expression)expressionInContext:(id)aContext
{
    var expMax = [_maxAnchor expressionInContext:_minAnchor],
        expMin = [_minAnchor expressionInContext:_maxAnchor];

    return engine_plus(expMax, engine_multiply(expMin, -1));
}

@end

var CPLayoutAnchorTypeKey      = @"CPLayoutAnchorTypeKey",
    CPLayoutAnchorItemKey      = @"CPLayoutAnchorItemKey",
    CPLayoutAnchorAttributeKey = @"CPLayoutAnchorAttributeKey";

@implementation CPLayoutAnchor (CPCoding)

- (id)initWithCoder:(id)aCoder
{
/*
    var hasKey = [aCoder containsValueForKey:CPLayoutAnchorTypeKey];
    var type = hasKey ? [aCoder decodeIntForKey:CPLayoutAnchorTypeKey] : 2; // simple or composite
*/

    var item = [aCoder decodeObjectForKey:CPLayoutAnchorItemKey];

    var hasKey = [aCoder containsValueForKey:CPLayoutAnchorAttributeKey],
        attr = hasKey ? [aCoder decodeIntForKey:CPLayoutAnchorAttributeKey] : 0;

    // The name will be lazily resolved.
    self = [self initWithItem:item attribute:attr name:nil];

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeConditionalObject:_item forKey:CPLayoutAnchorItemKey];
    [aCoder encodeInt:_attribute forKey:CPLayoutAnchorAttributeKey];
}

@end