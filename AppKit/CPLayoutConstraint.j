@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@import "CPLayoutConstraintEngine.j"

CPLayoutRelationLessThanOrEqual = -1;
CPLayoutRelationEqual = 0;
CPLayoutRelationGreaterThanOrEqual = 1;

CPLayoutConstraintOrientationHorizontal = 0;
CPLayoutConstraintOrientationVertical = 1;

CPLayoutAttributeLeft       = 1;
CPLayoutAttributeRight      = 2;
CPLayoutAttributeTop        = 3;
CPLayoutAttributeBottom     = 4;
CPLayoutAttributeLeading    = 5;
CPLayoutAttributeTrailing   = 6;
CPLayoutAttributeWidth      = 7;
CPLayoutAttributeHeight     = 8;
CPLayoutAttributeCenterX    = 9;
CPLayoutAttributeCenterY    = 10;
CPLayoutAttributeBaseline   = 11;

CPLayoutAttributeNotAnAttribute = 0;

/* Where AppKit's use of priority levels interacts with the user's use, we must define the priority levels involved.  Note that most of the time there is no interaction.  The use of priority levels is likely to be local to one sub-area of the window that is under the control of one author.
 */

CPLayoutPriorityRequired = 1000; // a required constraint.  Do not exceed this.
CPLayoutPriorityDefaultHigh = 750; // this is the priority level with which a button resists compressing its content.  Note that it is higher than NSLayoutPriorityWindowSizeStayPut.  Thus dragging to resize a window will not make buttons clip.  Rather the window frame is constrained.
CPLayoutPriorityDragThatCanResizeWindow = 510; // This is the appropriate priority level for a drag that may end up resizing the window.  This needn't be a drag whose explicit purpose is to resize the window. The user might be dragging around window contents, and it might be desirable that the window get bigger to accommodate.
CPLayoutPriorityWindowSizeStayPut = 500; // This is the priority level at which the window prefers to stay the same size.  It's generally not appropriate to make a constraint at exactly this priority. You want to be higher or lower.
CPLayoutPriorityDragThatCannotResizeWindow = 490; // This is the priority level at which a split view divider, say, is dragged.  It won't resize the window.
CPLayoutPriorityDefaultLow = 250; // this is the priority level at which a button hugs its contents horizontally.
CPLayoutPriorityFittingSizeCompression = 50; // When you issue -[NSView fittingSize], the smallest size that is large enough for the view's contents is computed.  This is the priority level with which the view wants to be as small as possible in that computation.  It's quite low.  It is generally not appropriate to make a constraint at exactly this priority.  You want to be higher or lower.

var CPLayoutAttributeLabels = ["NotAnAttribute",  "Left",  "Right",  "Top",  "Bottom",  "Left",  "Right",  "Width",  "Height",  "CenterX",  "CenterY",  "Baseline"];


@implementation CPLayoutConstraint : CPObject
{
    id       _container        @accessors(property=container);
    id       _firstItem        @accessors(property=firstItem);
    id       _secondItem       @accessors(property=secondItem);
    int      _firstAttribute   @accessors(property=firstAttribute);
    int      _secondAttribute  @accessors(property=secondAttribute);
    int      _relation         @accessors(property=relation);
    double   _constant         @accessors(property=constant);
    float    _coefficient      @accessors(property=multiplier);
    float    _priority         @accessors(property=priority);
    int      _strength         @accessors(property=_strength);
//    BOOL     _shouldBeArchived @accessors(property=shouldBeArchived);
}

+ (id)constraintWithItem:(id)item1 attribute:(int)att1 relatedBy:(int)relation toItem:(id)item2 attribute:(int)att2 multiplier:(double)multiplier constant:(double)constant
{
    return [[CPLayoutConstraint alloc] initWithItem:item1 attribute:att1 relatedBy:relation toItem:item2 attribute:att2 multiplier:multiplier constant:constant];
}

- (id)initWithItem:(id)item1 attribute:(int)att1 relatedBy:(int)relation toItem:(id)item2 attribute:(int)att2 multiplier:(double)multiplier constant:(double)constant
{
    self = [super init];

    [self setFirstItem:item1];
    [self setSecondItem:item2];
    _firstAttribute = att1;
    _secondAttribute = att2;
    _relation = relation;
    _coefficient = multiplier;
    _constant = constant;
    _priority = CPLayoutPriorityRequired;
//    _shouldBeArchived = NO;

    [self _init];

    return self;
}

- (void)setFirstItem:(id)anItem
{
    _firstItem = [anItem isEqual:[CPNull null]] ? nil : anItem;
}

- (void)setSecondItem:(id)anItem
{
    _secondItem = [anItem isEqual:[CPNull null]] ? nil : anItem;
}

- (void)_init
{
    _strength = 0;
    _container = nil;
}

- (void)registerItemsInEngine:(id)anEngine
{
    [anEngine registerItem:_container forIdentifier:[_container UID]];
    [anEngine registerItem:_firstItem forIdentifier:[_firstItem UID]];
    [anEngine registerItem:_secondItem forIdentifier:[_secondItem UID]];
}

- (void)addToEngine:(id)anEngine
{
    [self registerItemsInEngine:anEngine];
    [anEngine addConstraint:self];
}

- (void)removeFromEngine:(id)anEngine
{
CPLog.debug(self +_cmd);

    [anEngine unregisterItemWithIdentifier:[_firstItem UID]];
    [anEngine removeConstraint:self];
}

- (BOOL)isEqual:(id)anObject
{
    if (anObject === self)
        return YES;

    if (!anObject || anObject.isa !== self.isa || [anObject firstItem] !== _firstItem || [anObject secondItem] !== _secondItem || [anObject firstAttribute] !== _firstAttribute || [anObject secondAttribute] !== _secondAttribute || [anObject relation] !== _relation || [anObject multiplier] !== _coefficient || [anObject constant] !== _constant || [anObject priority] !== _priority)
        return NO;

    return YES;
}

- (Object)toJSON
{
    var firstItem = {
        uuid        : [_firstItem UID],
        name        : [_firstItem identifier] || [_firstItem className],
        rect        : [_firstItem frame],
        attribute   : _firstAttribute
    };

    var secondItem = {
        uuid        : [_secondItem UID],
        name        : [_secondItem identifier] || [_secondItem className],
        rect        : [_secondItem frame],
        attribute   : _secondAttribute
    };

    return {
       type           : "Constraint",
       uuid           : [self UID],
       containerUUID  : [_container UID],
       firstItem      : firstItem,
       secondItem     : secondItem,
       relation       : _relation,
       multiplier     : _coefficient,
       constant       : _constant,
       priority       : _priority
    };
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@ %@ %@ %@ %@ x%@ +%@ (%@)", ([_firstItem identifier] || [_firstItem className] || ""), CPStringFromAttribute(_firstAttribute), CPStringFromRelation(_relation), ([_secondItem identifier] || [_secondItem className] || ""), CPStringFromAttribute(_secondAttribute), _coefficient, _constant, _priority];
}

- (void)_replaceItem:(id)anItem withItem:(id)aNewItem
{
    if (anItem === _firstItem)
    {
        _firstItem = aNewItem;
        CPLog.debug("In Constraint replaced " + [_firstItem UID] + " with " + [aNewItem UID]);
    }
    else if (anItem === _secondItem)
    {
        _secondItem = aNewItem;
        CPLog.debug("In Constraint replaced " + [_secondItem UID] + " with " + [aNewItem UID]);
    }
}

@end

var CPFirstItem         = @"CPFirstItem",
    CPSecondItem        = @"CPSecondItem",
    CPFirstAttribute    = @"CPFirstAttribute",
    CPSecondAttribute   = @"CPSecondAttribute",
    CPRelation          = @"CPRelation",
    CPMultiplier        = @"CPMultiplier",
    CPSymbolicConstant  = @"CPSymbolicConstant",
    CPConstant          = @"CPConstant",
    CPShouldBeArchived  = @"CPShouldBeArchived",
    CPPriority          = @"CPPriority",
    CPLayoutIdentifier  = @"CPLayoutIdentifier";

@implementation CPLayoutConstraint (CPCoding)

- (void)encodeWithCoder:(CPCoder)aCoder
{
    if (_firstItem)
        [aCoder encodeObject:_firstItem forKey:CPFirstItem];

    if (_secondItem)
        [aCoder encodeObject:_secondItem forKey:CPSecondItem];

    [aCoder encodeInt:_firstAttribute forKey:CPFirstAttribute];
    [aCoder encodeInt:_secondAttribute forKey:CPSecondAttribute];

    if (_relation !== CPLayoutRelationEqual)
        [aCoder encodeInt:_relation forKey:CPRelation];

    if (_coefficient !== 1)
        [aCoder encodeDouble:_coefficient forKey:CPMultiplier];

    [aCoder encodeDouble:_constant forKey:CPConstant];

    if (_priority !== CPLayoutPriorityRequired)
        [aCoder encodeInt:_priority forKey:CPPriority];

    //[aCoder encodeBool:_shouldBeArchived forKey:CPShouldBeArchived];
    //[aCoder encodeObject:[self _identifier] forKey:CPLayoutIdentifier];
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];

    _firstItem = [aCoder decodeObjectForKey:CPFirstItem];
    _firstAttribute = [aCoder decodeIntForKey:CPFirstAttribute];

    var hasKey = [aCoder containsValueForKey:CPRelation];
    _relation = (hasKey) ? [aCoder decodeIntForKey:CPRelation] : CPLayoutRelationEqual ;

    var hasKey = [aCoder containsValueForKey:CPMultiplier];
    _coefficient = (hasKey) ? [aCoder decodeDoubleForKey:CPMultiplier] : 1 ;

    _secondItem = [aCoder decodeObjectForKey:CPSecondItem];
    _secondAttribute = [aCoder decodeIntForKey:CPSecondAttribute];

    _constant = [aCoder decodeDoubleForKey:CPConstant];

    //_shouldBeArchived = [aCoder decodeBoolForKey:CPShouldBeArchived];
    //[self _setIdentifier:[aCoder decodeObjectForKey:CPLayoutIdentifier]];

    var hasKey = [aCoder containsValueForKey:CPPriority];
    _priority = (hasKey) ? [aCoder decodeIntForKey:CPPriority] : CPLayoutPriorityRequired;

    [self _init];

    return self;
}

@end

@implementation CPLayoutVariable : CPObject
{
    CPView    _item;
    CPInteger _tag;
}

+ (CPLayoutVariable)variableForItem:(id)anItem tag:(CPInteger)aTag
{
    self = [super init];

    _item = anItem;
    _tag = aTag;

    return self;
}

-  (Object)toJSON
{
    return {
        identifier: [_item uuid],
        name: [_item identifier] || [_item className],
        tag: _tag
    }
}

@end

var CPStringFromAttribute = function(attr)
{
    return CPLayoutAttributeLabels[attr];
};

var CPStringFromRelation = function(relation)
{
    switch (relation)
    {
        case -1 : return "<=";
        case 0  : return "==";
        case 1  : return ">=";
    }
};