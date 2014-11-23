@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@import "CPLayoutConstraintEngine.j"

@class _CPCibCustomView;

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

var CPLayoutAttributeLabels = ["NotAnAttribute", "left", "right", "top", "bottom", "left", "right", "width",  "height", "centerX", "centerY", "baseline"];

var CPLayoutItemIsNull = 1 << 1,
    CPLayoutItemIsContainer = 1 << 2,
    CPLayoutItemIsNotContainer = 1 << 3;

@implementation CPLayoutConstraint : CPObject
{
    id       _container        @accessors(getter=container);
    id       _firstItem        @accessors(getter=firstItem, setter=_setFirstItem:);
    id       _secondItem       @accessors(getter=secondItem, setter=_setSecondItem:);
    unsigned _firstAttribute   @accessors(getter=firstAttribute);
    unsigned _secondAttribute  @accessors(getter=secondAttribute);
    unsigned _relation         @accessors(getter=relation);
    double   _constant         @accessors(property=constant);
    float    _coefficient      @accessors(getter=multiplier);
    float    _priority         @accessors(property=priority);
    BOOL     _active           @accessors(getter=isActive);
    CPString _identifier       @accessors(getter=identifier);
    unsigned _contraintFlags   @accessors(getter=contraintFlags);

    CPString _symbolicConstant;
    BOOL     _shouldBeArchived @accessors(property=shouldBeArchived);
    CPString _uuid;
    BOOL     _addedToEngine    @accessors(property=addedToEngine);
}

+ (CPSet)keyPathsForValuesAffectingValueForKey:(CPString)key
{
    if (key == @"description")
    {
        return [CPSet setWithObjects:@"constant", @"priority"];
    }

    return [CPSet set];
}

+ (id)constraintWithItem:(id)item1 attribute:(CPInteger)att1 relatedBy:(CPInteger)relation toItem:(id)item2 attribute:(CPInteger)att2 multiplier:(double)multiplier constant:(double)constant
{
    return [[[self class] alloc] initWithItem:item1 attribute:att1 relatedBy:relation toItem:item2 attribute:att2 multiplier:multiplier constant:constant];
}

- (id)initWithItem:(id)item1 attribute:(int)att1 relatedBy:(int)relation toItem:(id)item2 attribute:(int)att2 multiplier:(double)multiplier constant:(double)constant
{
    self = [super init];

    [self _setFirstItem:item1];
    [self _setSecondItem:item2];
    _firstAttribute = att1;
    _secondAttribute = att2;
    _relation = relation;
    _coefficient = multiplier;
    _constant = constant;
    _symbolicConstant = nil;
    _priority = CPLayoutPriorityRequired;
    _identifier = nil;
    _shouldBeArchived = NO;

    [self _init];

    return self;
}

- (CPString)_constraintType
{
    return @"Constraint";
}

- (void)_init
{
    _container = nil;
    _contraintFlags = 0;
    _active = NO;
    _addedToEngine = NO;
    _uuid = uuidgen();
}

- (id)_findCommonAncestorForItem:(id)firstItem andItem:(id)secondItem
{
    var ancestor = nil;

    if (firstItem !== nil && secondItem == nil)
        ancestor = _firstItem;
    else if (firstItem == nil && secondItem !== nil)
        ancestor = _secondItem;
    else if (firstItem !== nil && secondItem !== nil)
        ancestor = [firstItem ancestorSharedWithView:secondItem];

    return ancestor;
}

- (BOOL)_isSubtreeRelationship
{
    return ((_contraintFlags & 8) || (_contraintFlags & 64)) > 0;
}

- (void)setActive:(BOOL)shouldActivate
{
    if (shouldActivate == _active)
        return;

    if (shouldActivate)
    {
        var container = [self _findCommonAncestorForItem:_firstItem andItem:_secondItem];

        if (container !== nil)
        {
            [container addConstraint:self];
        }
        else
        {
            [CPException raise:CPGenericException format:@"Unable to activate constraint with items %@ and %@ because they have no common ancestor. Does the constraint reference items in different view hierarchies ? That's illegal.", _firstItem, _secondItem];
        }
    }
    else
    {
        [_container removeConstraint:self];
    }
}

- (void)_setActive:(BOOL)active
{
    _active = active;
}

+ (void)activateConstraints:(CPArray)constraints
{
    [self constraints:constraints activateOrNot:YES];
}

+ (void)desactivateConstraints:(CPArray)constrainst
{
    [self constraints:constraints activateOrNot:NO];
}

+ (void)constraints:(CPArray)constraints activateOrNot:(BOOL)activate
{
    [constraints enumerateObjectsUsingBlock:function(cst, idx, stop)
    {
        [cst setActive:activate];
    }];
}

- (void)_setContainer:(id)aContainer
{
    _container = aContainer;

    _contraintFlags = (CPLayoutConstraintFlags(_container, _firstItem)) |
                      (CPLayoutConstraintFlags(_container, _secondItem) << 3);
}

- (void)_setFirstItem:(id)anItem
{
    var item = [self _validateItem:anItem];
    [item setAutolayoutEnabled:YES];

    _firstItem = item;
}

- (void)_setSecondItem:(id)anItem
{
    var item = [self _validateItem:anItem];
    [item setAutolayoutEnabled:YES];

    _secondItem = item;
}

- (id)_validateItem:(id)anItem
{
    if ([anItem isEqual:[CPNull null]])
        return nil;

    return anItem;
}

- (void)setConstant:(double)aConstant
{
    if (aConstant !== _constant)
    {
        _constant = aConstant;
        [self _forceLayoutIfAlreadyInEngine];
    }
}

- (void)setPriority:(float)aPriority
{
    if (aPriority !== _priority)
    {
        _priority = aPriority;
        [self _forceLayoutIfAlreadyInEngine];
    }
}

- (void)_forceLayoutIfAlreadyInEngine
{
    if (_container)
    {
        _uuid = uuidgen();
        [_container setNeedsUpdateConstraints:YES];
        [[_container window] setNeedsLayout];
    }
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
    if (_container == nil)
        CPLog.warn(self + " container is nil and it should not");

    var firstItemJSON = JSONForItem(_container, _firstItem, _firstAttribute),
        secondItemJSON = JSONForItem(_container, _secondItem, _secondAttribute);

    var firstOffset = alignmentRectOffsetForItem(_firstItem, _firstAttribute),
        secondOffset = alignmentRectOffsetForItem(_secondItem, _secondAttribute);

    return [{
       type           : "Constraint",
       uuid           : _uuid,
       container      : [_container UID],
       firstItem      : firstItemJSON,
       secondItem     : secondItemJSON,
       relation       : _relation,
       multiplier     : _coefficient,
       constant       : (_constant + secondOffset * _coefficient - firstOffset),
       priority       : _priority,
       flags          : _contraintFlags
    }];
}

- (CPString)description
{
    var term1 = (_firstItem && _firstAttribute) ? [CPString stringWithFormat:@"%@.%@", [_firstItem debugID], CPStringFromAttribute(_firstAttribute)] : "",
        term2 = (_secondItem && _secondAttribute && _coefficient) ? [CPString stringWithFormat:@"%@.%@ x%@", [_secondItem debugID], CPStringFromAttribute(_secondAttribute), _coefficient] : "",
        identifier = (_identifier) ? [CPString stringWithFormat:@" [%@]"] : "",
        plusMinus = (_constant < 0) ? "-" : "+";

    return [CPString stringWithFormat:@"%@ %@ %@ %@%@ (%@)%@", term1, CPStringFromRelation(_relation), term2, plusMinus, _constant, _priority, identifier];
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

- (void)resolveConstant
{
    var constant = _constant;

    if ([self resolvedConstant:@ref(constant) forSymbolicConstant:_symbolicConstant error:nil])
        _constant = constant;
}

- (BOOL)resolvedConstant:(@ref)refConstant forSymbolicConstant:(CPString)symbol error:(@ref)refError
{
    var error = nil,
        constant = @deref(refConstant),
        result = NO;

    if (symbol !== nil)
    {
        if (_container == nil)
        {
            error = @"Cannot resolve symbolic constant because the constraint is not installed.";
            result = NO;
        }
        else if (symbol == @"NSSpace" && _firstAttribute <= 6 && _secondAttribute <= 6)
        {
            if (_firstItem == _container || _secondItem == _container)
                constant = 20.0;
            else if (_firstItem !== nil && _secondItem !== nil)
                constant = 8.0;

            result = YES;
        }
    }

    if (refError)
        refError(error);

    refConstant(constant);

    return result;
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

- (void)awakeFromCib
{
    [self _enableAutoLayoutIfNeeded];
}

- (void)_enableAutoLayoutIfNeeded
{
    [_firstItem setAutolayoutEnabled:YES];
    [_secondItem setAutolayoutEnabled:YES];
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    if (_firstItem)
        [aCoder encodeConditionalObject:_firstItem forKey:CPFirstItem];

    if (_secondItem)
        [aCoder encodeConditionalObject:_secondItem forKey:CPSecondItem];

    [aCoder encodeInt:_firstAttribute forKey:CPFirstAttribute];
    [aCoder encodeInt:_secondAttribute forKey:CPSecondAttribute];

    if (_relation !== CPLayoutRelationEqual)
        [aCoder encodeInt:_relation forKey:CPRelation];

    if (_coefficient !== 1)
        [aCoder encodeDouble:_coefficient forKey:CPMultiplier];

    [aCoder encodeDouble:_constant forKey:CPConstant];

    if (_symbolicConstant)
        [aCoder encodeObject:_symbolicConstant forKey:CPSymbolicConstant];

    if (_priority !== CPLayoutPriorityRequired)
        [aCoder encodeInt:_priority forKey:CPPriority];

    [aCoder encodeObject:_identifier forKey:CPLayoutIdentifier];
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];

    var firstItem = [aCoder decodeObjectForKey:CPFirstItem];
    [self _setFirstItem:firstItem];

    _firstAttribute = [aCoder decodeIntForKey:CPFirstAttribute];

    var hasKey = [aCoder containsValueForKey:CPRelation];
    _relation = (hasKey) ? [aCoder decodeIntForKey:CPRelation] : CPLayoutRelationEqual ;

    var hasKey = [aCoder containsValueForKey:CPMultiplier];
    _coefficient = (hasKey) ? [aCoder decodeDoubleForKey:CPMultiplier] : 1 ;

    var secondItem = [aCoder decodeObjectForKey:CPSecondItem];
    [self _setSecondItem:secondItem];
    _secondAttribute = [aCoder decodeIntForKey:CPSecondAttribute];

    _constant = [aCoder decodeDoubleForKey:CPConstant];
    _symbolicConstant = [aCoder decodeObjectForKey:CPSymbolicConstant];
    _identifier = [aCoder decodeObjectForKey:CPLayoutIdentifier];

    var hasKey = [aCoder containsValueForKey:CPPriority];
    _priority = (hasKey) ? [aCoder decodeIntForKey:CPPriority] : CPLayoutPriorityRequired;

    _shouldBeArchived = YES;

    [self _init];

    return self;
}

@end

var JSONForItem = function(aContainer, anItem, anAttribute)
{
    if (anItem == nil || anAttribute == CPLayoutAttributeNotAnAttribute)
        return {attribute:CPLayoutAttributeNotAnAttribute, flags:CPLayoutItemIsNull};

    return {
        uuid        : [anItem UID],
        name        : [anItem debugID],
        rect        : [anItem frame],
        attribute   : anAttribute,
        flags       : CPLayoutConstraintFlags(aContainer, anItem)
    };
};

var alignmentRectOffsetForItem = function(anItem, anAttribute)
{
    if (anAttribute === CPLayoutAttributeNotAnAttribute || anItem == nil)
        return 0;

    var inset = [anItem alignmentRectInsets],
        offset = 0;

    switch (anAttribute)
    {
        case CPLayoutAttributeLeading :
        case CPLayoutAttributeLeft     : offset = inset.left;
        break;
        case CPLayoutAttributeTrailing :
        case CPLayoutAttributeRight    : offset = - inset.right;
        break;
        case CPLayoutAttributeTop      : offset = inset.top;
        break;
        case CPLayoutAttributeBottom   : offset = - inset.bottom;
        break;
        case CPLayoutAttributeBaseline : offset = - inset.bottom - [anItem baselineOffsetFromBottom];
        break;
        case CPLayoutAttributeWidth    : offset = - inset.left - inset.right;
        break;
        case CPLayoutAttributeHeight   : offset = - inset.top - inset.bottom;
        break;
        case CPLayoutAttributeCenterX  : offset = - inset.right + inset.left;
        break;
        case CPLayoutAttributeCenterY  : offset = - inset.bottom + inset.top;
        break;
    }

    return offset;
};

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

var CPLayoutConstraintFlags = function(aContainer, anItem)
{
    if (anItem == nil)
        return CPLayoutItemIsNull;
    else if (anItem == aContainer)
        return CPLayoutItemIsContainer;
    else
        return CPLayoutItemIsNotContainer;
};
