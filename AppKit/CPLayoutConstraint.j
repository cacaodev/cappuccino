@import <Foundation/CPObject.j>
@import <Foundation/CPArray.j>
@import <Foundation/CPString.j>

@class CPLayoutConstraintEngine
@class CPLayoutAnchor

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

@implementation CPLayoutConstraint : CPObject
{
    id                  _container        @accessors(getter=container);
    CPLayoutAnchor      _firstAnchor      @accessors(getter=firstAnchor, setter=_setFirstAnchor:);
    CPLayoutAnchor      _secondAnchor     @accessors(getter=secondAnchor, setter=_setSecondAnchor:);
    CPLayoutRelation    _relation         @accessors(getter=relation);
    double              _constant         @accessors(getter=constant);
    float               _coefficient      @accessors(getter=multiplier, setter=_setMultiplier:);
    CPLayoutPriority    _priority         @accessors(getter=priority);

    CPString            _identifier       @accessors(property=identifier);

    BOOL                _active           @accessors(getter=isActive);
    BOOL                _shouldBeArchived @accessors(property=shouldBeArchived);

// Private ivars
    unsigned            _constraintFlags   @accessors(getter=constraintFlags);
    CPString            _symbolicConstant;
    CPArray             _engineConstraints;
}

+ (CPSet)keyPathsForValuesAffectingValueForKey:(CPString)aKey
{
    if (aKey == @"description")
        return [CPSet setWithObjects:@"constant", @"priority"];

    return [CPSet set];
}

+ (CPLayoutConstraint)constraintWithAnchor:(CPLayoutAnchor)firstAnchor relatedBy:(CPLayoutRelation)relation toAnchor:(CPLayoutAnchor)secondAnchor multiplier:(float)multiplier constant:(float)constant
{
    var constraint = [[[self class] alloc] init];
    [constraint _setFirstAnchor:firstAnchor];
    [constraint _setRelation:relation];

    [constraint _setSecondAnchor:secondAnchor];
    [constraint _setMultiplier:multiplier];

    [constraint _setConstant:constant];

    return constraint;
}

+ (CPLayoutConstraint)constraintWithItem:(id)item1 attribute:(CPLayoutAttribute)att1 relatedBy:(CPLayoutRelation)relation toItem:(id)item2 attribute:(CPLayoutAttribute)att2 multiplier:(double)multiplier constant:(double)constant
{
    var firstAnchor = [CPLayoutAnchor layoutAnchorWithItem:item1 attribute:att1],
        secondAnchor = (multiplier !== 0  && item2 !== nil) ? [CPLayoutAnchor layoutAnchorWithItem:item2 attribute:att2] : nil;

    return [[self class] constraintWithAnchor:firstAnchor relatedBy:relation toAnchor:secondAnchor multiplier:multiplier constant:constant];
}

- (CPString)_constraintType
{
    return @"Constraint";
}

- (id)init
{
    self = [super init];

    _priority = CPLayoutPriorityRequired;
    _identifier = nil;
    _shouldBeArchived = NO;
    _symbolicConstant = nil;

    [self _init];

    return self;
}

- (void)_init
{
    _container = nil;
    _engineConstraints = nil;
    _constraintFlags = 0;
    _active = NO;

    [self resolveConstant];
}

- (id)copy
{
    var copy = [CPLayoutConstraint constraintWithAnchor:_firstAnchor relatedBy:_relation toAnchor:_secondAnchor multiplier:_coefficient constant:_constant];

    [copy setPriority:_priority];
    [copy _setActive:_active];
    [copy _setContainer:_container];

    return copy;
}

- (CPString)hash
{
    return [CPString stringWithFormat:@"%d-%d-%d-%d-%d-%d-%d-%d", [_firstAnchor UID], [_secondAnchor UID], _relation, _constant, _coefficient, _priority];
}

- (BOOL)isEqual:(id)anObject
{
    if (anObject === self)
        return YES;

    if (!anObject || [anObject class] !== [self class] || ![[anObject firstAnchor] isEqual:_firstAnchor] || ![[anObject secondAnchor] isEqual:_secondAnchor] || [anObject relation] !== _relation || [anObject multiplier] !== _coefficient || [anObject constant] !== _constant || [anObject priority] !== _priority)
        return NO;

    return YES;
}

- (CPArray)_engineConstraints
{
    if (!_engineConstraints)
        _engineConstraints = [CPLayoutConstraintEngine _engineConstraintsFromConstraint:self];

    return _engineConstraints;
}

- (void)_resetEngineConstraints
{
    _engineConstraints = nil;
}

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
        var container = [CPLayoutConstraint _findCommonAncestorOfItem:[self firstItem] andItem:[self secondItem]];

        if (container !== nil)
        {
            [container addConstraint:self];
        }
        else
        {
            [CPException raise:CPGenericException reason:[CPString stringWithFormat:@"Unable to activate constraint with items %@ and %@ because they have no common ancestor. Does the constraint reference items in different view hierarchies ? That's illegal.", [self firstItem], [self secondItem]]];
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

    _constraintFlags = (CPLayoutConstraintFlags(_container, [self firstItem])) |
                      (CPLayoutConstraintFlags(_container, [self secondItem]) << 3);
}

- (id)firstItem
{
    return [_firstAnchor item];
}

- (id)secondItem
{
    return [_secondAnchor item];
}

- (CPInteger)firstAttribute
{
    if (_firstAnchor == nil)
        return CPLayoutAttributeNotAnAttribute;

    return [_firstAnchor attribute];
}

- (CPInteger)secondAttribute
{
    if (_secondAnchor == nil)
        return CPLayoutAttributeNotAnAttribute;

    return [_secondAnchor attribute];
}

- (void)_setFirstItem:(id)anItem
{
    if (anItem == nil)
        _firstAnchor = nil;
    else
        [_firstAnchor setItem:[self _validateItem:anItem]];
}

- (void)_setSecondItem:(id)anItem
{
    if (anItem == nil)
        _secondAnchor = nil;
    else
        [_secondAnchor setItem:[self _validateItem:anItem]];
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
    var lhs = [_firstAnchor description],
        rhs = (_coefficient !== 0 && _secondAnchor !== nil) ? [CPString stringWithFormat:@"%@ x%@", [_secondAnchor description], _coefficient] : "",
        identifier = (_identifier) ? [CPString stringWithFormat:@" [%@]"] : "",
        plusMinus = (_constant < 0) ? "-" : "+",
        active = _active ? "":" [inactive]";

    return [CPString stringWithFormat:@"%@ %@ %@ %@%@ (%@)%@%@", lhs, CPStringFromRelation(_relation), rhs, plusMinus, _constant, _priority, identifier, active];
}

- (void)_replaceItem:(id)anItem withItem:(id)aNewItem
{
    if (anItem === [self firstItem])
    {
        [self _setfirstItem:aNewItem];
    }
    else if (anItem === [self secondItem])
    {
        [self _setSecondItem:aNewItem];
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
        else if (symbol == @"NSSpace" && [self firstAttribute] <= 6 && [self secondAttribute] <= 6)
        {
            var firstItem = [self firstItem],
                secondItem = [self secondItem];

            if (firstItem == _container || secondItem == _container)
                constant = 20.0;
            else if (firstItem !== nil && secondItem !== nil)
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
    var firstOffset  = _firstAnchor ? [_firstAnchor alignmentRectOffset] : 0,
        secondOffset = _secondAnchor ? [_secondAnchor alignmentRectOffset] : 0;

    return _constant + firstOffset - secondOffset * _coefficient;
}

- (BOOL)_isContainerItem:(id)anItem
{
    return (anItem !== nil && anItem == _container);
}

@end

var CPFirstAnchor       = @"CPFirstAnchor",
    CPSecondAnchor      = @"CPSecondAnchor",
    CPFirstItem         = @"CPFirstItem",
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
    [aCoder encodeConditionalObject:_firstAnchor forKey:CPFirstAnchor];
    [aCoder encodeConditionalObject:_secondAnchor forKey:CPSecondAnchor];

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

    if ([aCoder containsValueForKey:CPFirstAnchor])
        _firstAnchor = [aCoder decodeObjectForKey:CPFirstAnchor];
    else
    {
        var item = [aCoder decodeObjectForKey:CPFirstItem],
            attr = [aCoder decodeIntForKey:CPFirstAttribute];
        _firstAnchor = [CPLayoutAnchor layoutAnchorWithItem:item attribute:attr];
    }

    var hasKey = [aCoder containsValueForKey:CPMultiplier];
    _coefficient = (hasKey) ? [aCoder decodeDoubleForKey:CPMultiplier] : 1;

    if ([aCoder containsValueForKey:CPSecondAnchor])
        _secondAnchor = [aCoder decodeObjectForKey:CPSecondAnchor];
    else
    {
        var item = [aCoder decodeObjectForKey:CPSecondItem],
            attr = [aCoder decodeIntForKey:CPSecondAttribute];
        _secondAnchor = (item !== nil && _coefficient !== 0) ? [CPLayoutAnchor layoutAnchorWithItem:item attribute:attr] : nil;
    }

    var hasKey = [aCoder containsValueForKey:CPRelation];
    _relation = (hasKey) ? [aCoder decodeIntForKey:CPRelation] : CPLayoutRelationEqual;

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
