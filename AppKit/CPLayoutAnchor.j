@import "CPLayoutConstraint.j"
@import <Foundation/CPObject.j>

@class CPLayoutConstraint

var CPLayoutAttributeLabels = ["NotAnAttribute", // 0
                               "left",
                               "right",
                               "top",
                               "bottom",
                               "left",
                               "right",
                               "width",
                               "height",
                               "centerX",
                               "centerY",
                               "baseline"];

var _CPReferencedAnchors;

@implementation CPLayoutAnchor : CPObject
{
    id        _item      @accessors(property=item);
    CPInteger _attribute @accessors(property=attribute);
}

+ (void)initialize
{
    _CPReferencedAnchors = @{};
}

+ (id)layoutAnchorWithItem:(id)anItem attribute:(CPInteger)anAttribute
{
    var anchor_key = [anItem UID] + "_" + anAttribute, // TODO: use -hash ?
        result = [_CPReferencedAnchors objectForKey:anchor_key];

    if (result == nil)
    {
        result = [[[self class] alloc] initWithItem:anItem attribute:anAttribute];
        [_CPReferencedAnchors setObject:result forKey:anchor_key];
    }

    return result;
}

- (id)initWithItem:(id)anItem attribute:(CPInteger)anAttribute
{
    if (anItem == nil)
    {
        [CPException raise:CPInvalidArgumentException reason:@"CPLayoutAnchor cannot be created without an item."];
        return nil;
    }

    self = [super init];

    _item = anItem;
    _attribute = anAttribute;

    return self;
}

- (BOOL)isEqual:(id)otherAnchor
{
    if (otherAnchor === self)
        return YES;

    if ([otherAnchor class] !== [self class] || [otherAnchor item] !== _item || [otherAnchor attribute] !== _attribute)
        return NO;

    return YES;
}

- (float)alignmentRectOffset
{
    if (_attribute === CPLayoutAttributeNotAnAttribute)
        return 0;

    var inset = [_item alignmentRectInsets],
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

- (CPString)description
{
    return [CPString stringWithFormat:@"%@.%@", [_item debugID], CPStringFromAttribute(_attribute)];
}

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
    return [CPLayoutConstraint constraintWithItem:_item attribute:_attribute relatedBy:aRelation toItem:[otherAnchor item] attribute:[otherAnchor attribute] multiplier:multiplier constant:constant];
}

- (id)_constraintwithRelation:(CPLayoutRelation)aRelation constant:(double)constant
{
    return [CPLayoutConstraint constraintWithItem:_item attribute:_attribute relatedBy:aRelation toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:constant];
}

@end

@implementation CPLayoutAnchor (CPCoding)

- (id)initWithCoder:(id)aCoder {
/*
    var type = 2;
    if ([aCoder containsValueForKey:@"NSLayoutAnchor_type"])
        type = [aCoder decodeIntegerForKey:@"NSLayoutAnchor_type"];
*/
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

var CPStringFromAttribute = function(attr)
{
    return CPLayoutAttributeLabels[attr];
};
