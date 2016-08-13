@import <Foundation/CPObject.j>

@import "CPLayoutConstraint.j"
@import "c.js"

@class CPLayoutConstraint
@typedef Expression

var CPLayoutAnchorTypeSimple    = 0;
var CPLayoutAnchorTypeComposite = 1;

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
    CPString  _name                     @accessors(setter=_setName:);
    Variable  _variable                 @accessors(setter=_setVariable:);
    CPSet     _referencedLayoutItems;
    CPArray   _constituentAnchors;
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
    return [self anchorWithItem:anItem attribute:-1 name:aName];
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

    return self;
}

- (id)copy
{
    return [[[self class] alloc] initWithItem:[self _referenceItem] attribute:_attribute name:[self name]];
}

- (Variable)variable
{
    if (_variable == nil)
    {
        var item = [self _referenceItem],
            engine = [item _layoutEngine];

        _variable = [engine variableWithPrefix:[item UID] name:[self name] value:[self valueInLayoutSpace] owner:self];
    }

    return _variable;
}

- (id)name
{
    if (_name == nil && _attribute >= 0)
        _name = CPLayoutAttributeLabels[_attribute];

    return _name;
}

- (id)_referenceItem
{
    return [self item];
}

- (Expression)expressionInContext:(id)otherAnchor
{
    return new c.Expression.fromVariable([self variable]); // Overrided by subclasses.
}

// Default for x|yAxisAnchor and dimension
- (float)valueInEngine:(id)anEngine
{
    return [self variable].valueOf();
}

// Default for dimension
- (float)valueInItem:(id)anItem
{
    return [self valueInEngine:nil];
}

- (float)valueInLayoutSpace
{
    return 0.0;
}

- (BOOL)isEqual:(id)otherAnchor
{
    if (otherAnchor === self)
        return YES;

    if ([otherAnchor class] !== [self class] || [otherAnchor _referenceItem] !== [self _referenceItem] || [otherAnchor attribute] !== _attribute)
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

    if (otherItem == nil || [otherItem _is_superitem] == nil || [item _is_superitem] == [otherItem _is_superitem])
        return NO;

    return [otherItem isDescendantOf:item];
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

        if ([self _anchorType] == CPLayoutAnchorTypeSimple)
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

        if ([self _anchorType] == CPLayoutAnchorTypeSimple)
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
    if ([self _anchorType] == CPLayoutAnchorTypeSimple)
        return [self _referenceItem];

    var items = [self _referencedLayoutItems];
    var result = nil;

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

- (CPCompositeLayoutAxisAnchor)anchorAtMidpointToAnchor:(id)arg1
{
    var distance = [self anchorWithOffsetToAnchor:arg1];

    return [self anchorByOffsettingWithDimension:distance multiplier:0.5 constant:0];
}

- (CPDistanceLayoutDimension)anchorWithOffsetToAnchor:(id)arg1
{
    return [CPDistanceLayoutDimension distanceFromAnchor:self toAnchor:arg1];
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

- (int)_anchorType
{
    return CPLayoutAnchorTypeSimple;
}

- (Expression)expressionInContext:(id)otherAnchor
{
    // Are we the container ?
    if ([self _isParentOfAnchor:otherAnchor])
        return new c.Expression.fromConstant(0);

    return new c.Expression.fromVariable([self variable]);
}

- (void)valueOfVariable:(Variable)aVariable didChangeInEngine:(CPLayoutConstraintEngine)anEngine
{
    [[self _referenceItem] _engineDidChangeVariableOfType:2];
}

- (CPCompositeLayoutAxisAnchor)anchorByOffsettingWithConstant:(float)arg1
{
    return [self anchorByOffsettingWithDimension:nil multiplier:0 constant:arg1];
}

@end

@implementation CPLayoutXAxisAnchor : CPLayoutAxisAnchor

- (float)valueInLayoutSpace
{
    return CGRectGetMinX([[self item] frame]);
}

- (float)valueInItem:(id)anItem
{
    return [self valueInEngine:nil] - CGRectGetMinX([anItem frame]);
}

// CPLayoutAnchor creation

- (CPCompositeLayoutXAxisAnchor)anchorByOffsettingWithDimension:(CPLayoutDimension)distance multiplier:(float)multiplier constant:(float)constant
{
    return [[CPCompositeLayoutXAxisAnchor alloc] initWithAnchor:self plusDimension:distance times:multiplier plus:constant name:@"[]"];
}

@end

@implementation CPLayoutYAxisAnchor : CPLayoutAxisAnchor
{
}

- (float)valueInLayoutSpace
{
    return CGRectGetMinY([[self item] frame]);
}

- (float)valueInItem:(id)anItem
{
    return [self valueInEngine:nil] - CGRectGetMinY([anItem frame]);
}

// CPLayoutAnchor creation

- (CPCompositeLayoutYAxisAnchor)anchorByOffsettingWithDimension:(CPLayoutDimension)distance multiplier:(float)multiplier constant:(float)constant
{
    return [[CPCompositeLayoutYAxisAnchor alloc] initWithAnchor:self plusDimension:distance times:multiplier plus:constant name:@"[]"];
}

@end

@implementation CPLayoutDimension : CPLayoutAnchor
{
}

- (int)_anchorType
{
    return CPLayoutAnchorTypeSimple;
}

- (Expression)expressionInContext:(id)otherAnchor
{
    return new c.Expression.fromVariable([self variable]);
}

- (float)valueInLayoutSpace
{
    var frame = [[self item] frame];
    return (_attribute == CPLayoutAttributeWidth) ? CGRectGetWidth(frame) : CGRectGetHeight(frame);
}

- (void)valueOfVariable:(Variable)aVariable didChangeInEngine:(CPLayoutConstraintEngine)anEngine
{
    [[self _referenceItem] _engineDidChangeVariableOfType:4];
}

@end

@implementation CPCompositeLayoutAxisAnchor : CPLayoutAnchor
{
    CPLayoutXAxisAnchor  _axisAnchor @accessors(getter=axisAnchor);
    CPLayoutDimension    _dimension;
    float                _constant;
    float                _dimensionMultiplier;
}

- (id)initWithAnchor:(id)axisAnchor plusDimension:(id)dimension times:(float)multiplier plus:(float)constant name:(CPString)aName
{
    self = [super initWithItem:[axisAnchor _referenceItem] attribute:-1 name:aName];

    _axisAnchor = [axisAnchor copy];
    _dimension = [dimension copy];
    _dimensionMultiplier = _dimension ? multiplier : 0.0;
    _constant = constant;

    return self;
}

- (id)copy
{
    return [[[self class] alloc] initWithAnchor:_axisAnchor plusDimension:_dimension times:_dimensionMultiplier plus:_constant name:[self name]];
}

- (int)_anchorType
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
            exp2 = exp2.times(_dimensionMultiplier);
    }
    else {
        exp2 = new c.Expression.fromConstant(0);
    }

    if (_constant !== 0)
    {
        var constantExp = new c.Expression.fromConstant(_constant);
        exp2 = exp2.plus(constantExp);
    }

    if ([_axisAnchor _isParentOfAnchor:otherAnchor])
        return exp2;

    var exp1 = [_axisAnchor expressionInContext:otherAnchor];

    return c.plus(exp1, exp2);
}

- (id)_referenceItem
{
    return [_axisAnchor _referenceItem];
}

- (float)valueInLayoutSpace
{
    return [_axisAnchor valueInLayoutSpace] + _dimensionMultiplier * [_dimension valueInLayoutSpace] + _constant;
}

- (float)valueInItem:(id)anItem
{
    return [_axisAnchor valueInItem:anItem] + _dimensionMultiplier * [_dimension valueInItem:anItem] + _constant;
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
        [super descriptionEquation];

    return [CPString stringWithFormat:@"{%@ + %@x%@ + %@}",[[self axisAnchor] descriptionEquation], [_dimension descriptionEquation], _dimensionMultiplier, _constant];
}

@end

@implementation CPCompositeLayoutXAxisAnchor : CPCompositeLayoutAxisAnchor
{
}

+ (id)anchorWithItem:(id)anItem attribute:(CPInteger)anAttribute
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

        default: [CPException raise:CPInvalidArgumentException format:@"%@ Unknown attribute %@", [self class], anAttribute];
    }

    var anchor = [[CPCompositeLayoutXAxisAnchor alloc] initWithAnchor:[anItem leftAnchor] plusDimension:[anItem widthAnchor] times:multiplier plus:0 name:name];
    [anchor _setAttribute:anAttribute];

    return anchor;
}
// CPLayoutAnchor creation

- (CPCompositeLayoutYAxisAnchor)anchorByOffsettingWithDimension:(CPLayoutDimension)distance multiplier:(float)multiplier constant:(float)constant
{
    return [[CPCompositeLayoutXAxisAnchor alloc] initWithAnchor:self plusDimension:distance times:multiplier plus:constant name:@"[]"];
}

@end

@implementation CPCompositeLayoutYAxisAnchor : CPCompositeLayoutAxisAnchor
{
}

+ (id)anchorWithItem:(id)anItem attribute:(CPInteger)anAttribute
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

    var anchor = [[CPCompositeLayoutYAxisAnchor alloc] initWithAnchor:[anItem topAnchor] plusDimension:[anItem heightAnchor] times:multiplier plus:0 name:name];
    [anchor _setAttribute:anAttribute];

    return anchor;
}
// CPLayoutAnchor creation

- (CPCompositeLayoutYAxisAnchor)anchorByOffsettingWithDimension:(CPLayoutDimension)distance multiplier:(float)multiplier constant:(float)constant
{
    return [[CPCompositeLayoutXAxisAnchor alloc] initWithAnchor:self plusDimension:distance times:multiplier plus:constant name:@"[]"];
}

@end

@implementation CPCompositeLayoutDimension : CPLayoutAnchor
{
    CPLayoutDimension _firstLayoutDimension;
    float             _secondLayoutDimensionMultiplier;
    CPLayoutDimension _secondLayoutDimension;
}

- (id)initWithDimension:(id)firstDimension plusDimension:(id)secondDimension times:(float)multiplier
{
    self = [super init];

    _firstLayoutDimension = [firstDimension copy];
    _secondLayoutDimension = [secondDimension copy];
    _secondLayoutDimensionMultiplier = multiplier;

    return self;
}

- (id)copy
{
    return [[[self class] alloc] initWithDimension:_firstDimension plusDimension:_secondDimension times:_secondLayoutDimensionMultiplier];
}

- (int)_anchorType
{
    return CPLayoutAnchorTypeComposite;
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
    var exp1 = [_firstLayoutDimension expressionInContext:aContext],
        exp2 = [_secondLayoutDimension expressionInContext:aContext];

    if (_secondLayoutDimensionMultiplier == 0)
        return exp1;

    return new c.plus(exp1, exp2.times(_secondLayoutDimensionMultiplier));
}

- (id)_referenceItem
{
    return [_firstLayoutDimension _referenceItem];
}

- (float)valueInLayoutSpace
{
    return [_firstLayoutDimension valueInLayoutSpace] + _secondLayoutDimensionMultiplier * [_secondLayoutDimension valueInLayoutSpace];
}

- (float)valueInItem:(id)anItem
{
    return [_firstLayoutDimension valueInItem:anItem] + _secondLayoutDimensionMultiplier * [_secondLayoutDimension valueInItem:anItem];
}

- (float)valueInEngine:(id)anEngine
{
    return [_firstLayoutDimension valueInEngine:anEngine] + _secondLayoutDimensionMultiplier * [_secondLayoutDimension valueInEngine:anEngine];
}

- (CPArray)_childAnchors
{
    return @[_firstLayoutDimension, _secondLayoutDimension];
}

@end

@implementation CPDistanceLayoutDimension : CPLayoutDimension
{
    CPLayoutAnchor _minAnchor;
    CPLayoutAnchor _maxAnchor;
}

+ (id)distanceFromAnchor:(id)arg1 toAnchor:(id)arg2
{
    return [[CPDistanceLayoutDimension alloc] initWithMinAnchor:arg1 maxAnchor:arg2];
}

- (id)initWithMinAnchor:(id)arg1 maxAnchor:(id)arg2
{
    var name = [CPString stringWithFormat:@"[%@-%@]", [arg1 name], [arg2 name]];

    self = [super initWithItem:[arg1 _referenceItem] attribute:-1 name:name];

    _minAnchor = [arg1 copy];
    _maxAnchor = [arg2 copy];

    return self;
}

- (id)copy
{
    return [[CPDistanceLayoutDimension alloc] initWithMinAnchor:_minAnchor maxAnchor:_maxAnchor];
}

- (int)_anchorType
{
    return CPLayoutAnchorTypeComposite;
}

- (CPArray)_childAnchors
{
    return @[_minAnchor, _maxAnchor];
}

- (id)equationDescription
{
    return [CPString stringWithFormat:@"[%@-%@]", [_minAnchor equationDescription], [_maxAnchor equationDescription]];
}

- (float)valueInItem:(id)arg1
{
    return ABS([_maxAnchor valueInItem:arg1] - [_minAnchor valueInItem:arg1]);
}

- (float)valueInEngine:(id)arg1
{
    return ABS([_maxAnchor valueInEngine:arg1] - [_minAnchor valueInEngine:arg1]);
}

- (Expression)expressionInContext:(id)arg1
{
    var expMax = [_maxAnchor expressionInContext:arg1],
        expMin = [_minAnchor expressionInContext:arg1];

    return c.plus(expMax, expMin.times(-1));
}

@end

/*
@implementation CPLayoutAnchor (CPCoding)

- (id)initWithCoder:(id)aCoder {
    var type = 2;
    if ([aCoder containsValueForKey:@"NSLayoutAnchor_type"])
        type = [aCoder decodeIntegerForKey:@"NSLayoutAnchor_type"];

    var attr = 0;
    var item = [aCoder decodeObjectForKey:@"NSLayoutAnchor_referenceView"];

    if ([aCoder containsValueForKey:@"NSLayoutAnchor_attr"])
        attr = [aCoder decodeIntegerForKey:@"NSLayoutAnchor_attr"];

    return [self initWithItem:item attribute:attr];
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_item forKey:@"NSLayoutAnchor_referenceView"];
    [aCoder encodeInteger:_attribute forKey:@"NSLayoutAnchor_attr"];
}

@end
*/