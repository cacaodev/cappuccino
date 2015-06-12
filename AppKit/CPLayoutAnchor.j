@import "CPLayoutConstraint.j"
@import <Foundation/CPObject.j>

@class CPLayoutConstraint

@implementation CPLayoutAnchor : CPObject
{
    id _item                @accessors(property=item);
    long long _attribute    @accessors(property=attribute);
}

+ (id)layoutAnchorWithItem:(id)anItem attribute:(long long)anAttribute
{
    return [[CPLayoutAnchor alloc] initWithItem:anItem attribute:anAttribute];
}

- (id)initWithItem:(id)anItem attribute:(long long)anAttribute
{
    self = [super init];
    
    _item = anItem;
    _attribute = anAttribute;
    
    return self;
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

