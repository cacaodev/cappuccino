@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@class CPArray

@typedef CPLayoutRelation
CPLayoutRelationLessThanOrEqual = -1;
CPLayoutRelationEqual = 0;
CPLayoutRelationGreaterThanOrEqual = 1;

@typedef CPLayoutConstraintOrientation
CPLayoutConstraintOrientationHorizontal = 0;
CPLayoutConstraintOrientationVertical = 1;

@typedef CPLayoutAttribute
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

@typedef CPLayoutPriority
CPLayoutPriorityRequired = 1000; // a required constraint.  Do not exceed this.
CPLayoutPriorityDefaultHigh = 750; // this is the priority level with which a button resists compressing its content.  Note that it is higher than NSLayoutPriorityWindowSizeStayPut.  Thus dragging to resize a window will not make buttons clip.  Rather the window frame is constrained.
CPLayoutPriorityDragThatCanResizeWindow = 510; // This is the appropriate priority level for a drag that may end up resizing the window.  This needn't be a drag whose explicit purpose is to resize the window. The user might be dragging around window contents, and it might be desirable that the window get bigger to accommodate.
CPLayoutPriorityWindowSizeStayPut = 500; // This is the priority level at which the window prefers to stay the same size.  It's generally not appropriate to make a constraint at exactly this priority. You want to be higher or lower.
CPLayoutPriorityDragThatCannotResizeWindow = 490; // This is the priority level at which a split view divider, say, is dragged.  It won't resize the window.
CPLayoutPriorityDefaultLow = 250; // this is the priority level at which a button hugs its contents horizontally.
CPLayoutPriorityFittingSizeCompression = 50; // When you issue -[NSView fittingSize], the smallest size that is large enough for the view's contents is computed.  This is the priority level with which the view wants to be as small as possible in that computation.  It's quite low.  It is generally not appropriate to make a constraint at exactly this priority.  You want to be higher or lower.

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

@implementation CPLayoutConstraint : CPObject
{
    id                  _container        @accessors(getter=container);
    id                  _firstItem        @accessors(getter=firstItem);
    id                  _secondItem       @accessors(getter=secondItem);
    CPLayoutAttribute   _firstAttribute   @accessors(getter=firstAttribute);
    CPLayoutAttribute   _secondAttribute  @accessors(getter=secondAttribute);
    CPLayoutRelation    _relation         @accessors(getter=relation);
    double              _constant         @accessors(getter=constant);
    float               _coefficient      @accessors(getter=multiplier);
    CPLayoutPriority    _priority         @accessors(getter=priority);
    BOOL                _active           @accessors(getter=isActive);
    CPString            _identifier       @accessors(property=identifier);
    BOOL                _shouldBeArchived @accessors(property=shouldBeArchived);

    unsigned            _constraintFlags   @accessors(getter=constraintFlags);
    CPString            _symbolicConstant;
    CPArray             _engineConstraints @accessors(property=_engineConstraints);
}

+ (CPSet)keyPathsForValuesAffectingValueForKey:(CPString)aKey
{
    if (aKey == @"description")
        return [CPSet setWithObjects:@"constant", @"priority"];

    return [CPSet set];
}

+ (id)constraintWithItem:(id)item1 attribute:(CPLayoutAttribute)att1 relatedBy:(CPLayoutRelation)relation toItem:(id)item2 attribute:(CPLayoutAttribute)att2 multiplier:(double)multiplier constant:(double)constant
{
    return [[[self class] alloc] initWithItem:item1 attribute:att1 relatedBy:relation toItem:item2 attribute:att2 multiplier:multiplier constant:constant];
}

- (id)initWithItem:(id)item1 attribute:(CPLayoutAttribute)att1 relatedBy:(CPLayoutRelation)relation toItem:(id)item2 attribute:(CPLayoutAttribute)att2 multiplier:(double)multiplier constant:(double)constant
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
    _engineConstraints = nil;
    _constraintFlags = 0;
    _active = NO;
}

- (id)copy
{
    var copy = [CPLayoutConstraint constraintWithItem:_firstItem attribute:_firstAttribute relatedBy:_relation toItem:_secondItem attribute:_secondAttribute multiplier:_coefficient constant:_constant];
    [copy setPriority:_priority];
    [copy _setActive:_active];
    [copy _setContainer:_container];

    return copy;
}

- (CPString)hash
{
    return [CPString stringWithFormat:@"%d%d%d%d%d%d%d%d", [_firstItem UID], [_secondItem UID], _firstAttribute, _secondAttribute, _relation, _constant, _coefficient, _priority];
}

- (BOOL)isEqual:(id)anObject
{
    if (anObject === self)
        return YES;

    if (!anObject || [anObject class] !== [self class] || [anObject firstItem] !== _firstItem || [anObject secondItem] !== _secondItem || [anObject firstAttribute] !== _firstAttribute || [anObject secondAttribute] !== _secondAttribute || [anObject relation] !== _relation || [anObject multiplier] !== _coefficient || [anObject constant] !== _constant || [anObject priority] !== _priority)
        return NO;

    return YES;
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
+ (id)_findCommonAncestorOfItem:(id)anItem andItem:(id)otherItem
{
    var parent1,
        parent2,
        result;

    parent1 = anItem;
  
    if (anItem)
    {
        if (otherItem)
        {
            parent2 = otherItem;
          
            while (parent1 !== parent2)
            {
                parent2 = [parent2 _is_superitem];
                
                if (!parent2)
                {
                    parent1 = [parent1 _is_superitem];
                    
                    if (parent1)
                        parent2 = otherItem;
                }
            }
        }
        
        result = parent1;
    }
    else
    {
        result = otherItem;
    }
    
    return result;
}

- (BOOL)_isSubtreeRelationship
{
    return (_constraintFlags & 8) || (_constraintFlags & 64);
}

- (void)setActive:(BOOL)shouldActivate
{
    if (shouldActivate == _active)
        return;

    if (shouldActivate)
    {
        var container = [CPLayoutConstraint _findCommonAncestorOfItem:_firstItem andItem:_secondItem];

        if (container !== nil)
        {
            [container addConstraint:self];
        }
        else
        {
            [CPException raise:CPGenericException reason:[CPString stringWithFormat:@"Unable to activate constraint with items %@ and %@ because they have no common ancestor. Does the constraint reference items in different view hierarchies ? That's illegal.", _firstItem, _secondItem]];
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

+ (void)deactivateConstraints:(CPArray)constraints
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

    _constraintFlags = (CPLayoutConstraintFlags(_container, _firstItem)) |
                      (CPLayoutConstraintFlags(_container, _secondItem) << 3);
}

- (void)_setFirstItem:(id)anItem
{
    _firstItem = [self _validateItem:anItem];
}

- (void)_setSecondItem:(id)anItem
{
    _secondItem = [self _validateItem:anItem];
}

- (id)_validateItem:(id)anItem
{
    if ([anItem isEqual:[CPNull null]])
        return nil;

    return anItem;
}

- (void)setConstant:(double)aConstant
{
    if (aConstant === _constant)
        return;

    var CPLayoutConstraintSetConstantBlock = function()
    {
        [self _setConstant:aConstant];
    };

    if (_active)
        [_container _updateConstraint:self usingBlock:CPLayoutConstraintSetConstantBlock];
    else
        CPLayoutConstraintSetConstantBlock();
}

- (void)_setConstant:(double)aConstant
{
    _constant = aConstant;
}

- (void)setPriority:(CPLayoutPriority)aPriority
{
    var priority = MAX(MIN(aPriority, CPLayoutPriorityRequired), 0);

    if (priority === _priority)
        return;

    var CPLayoutConstraintSetPriorityBlock = function()
    {
        [self _setPriority:priority];
    };

    if (_active)
        [_container _updateConstraint:self usingBlock:CPLayoutConstraintSetPriorityBlock];
    else
        CPLayoutConstraintSetPriorityBlock();
}

- (void)_setPriority:(CPLayoutPriority)aPriority
{
    _priority = aPriority;
}

- (CPString)description
{
    var term1 = (_firstItem && _firstAttribute) ? [CPString stringWithFormat:@"%@.%@", [_firstItem debugID], CPStringFromAttribute(_firstAttribute)] : "",
        term2 = (_secondItem && _secondAttribute && _coefficient) ? [CPString stringWithFormat:@"%@.%@ x%@", [_secondItem debugID], CPStringFromAttribute(_secondAttribute), _coefficient] : "",
        identifier = (_identifier) ? [CPString stringWithFormat:@" [%@]"] : "",
        plusMinus = (_constant < 0) ? "" : "+",
        active = _active ? "":" [inactive]";

    return [CPString stringWithFormat:@"%@ %@ %@ %@%@ (%@)%@%@", term1, CPStringFromRelation(_relation), term2, plusMinus, _constant, _priority, identifier, active];
}

- (void)_replaceItem:(id)anItem withItem:(id)aNewItem
{
    if (anItem === _firstItem)
    {
        _firstItem = aNewItem;
    }
    else if (anItem === _secondItem)
    {
        _secondItem = aNewItem;
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

- (float)_frameBasedConstant
{
    var firstOffset  = alignmentRectOffsetForItem(_firstItem, _firstAttribute),
        secondOffset = alignmentRectOffsetForItem(_secondItem, _secondAttribute);

    return _constant + firstOffset - secondOffset * _coefficient;
}

- (BOOL)_isContainerItem:(id)anItem
{
    return (anItem !== nil && anItem == _container);
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

var alignmentRectOffsetForItem = function(anItem, anAttribute)
{
    if (anAttribute === CPLayoutAttributeNotAnAttribute || anItem == nil)
        return 0;

    var inset = [anItem alignmentRectInsets],
        offset = 0;

    switch (anAttribute)
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
        case CPLayoutAttributeBaseline : offset = inset.bottom + [anItem baselineOffsetFromBottom];
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
        return 2;
    else if (anItem == aContainer)
        return 4;
    else
        return 8;
};