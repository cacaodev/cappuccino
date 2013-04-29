@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@import "c.js"
@import "HashTable.js"
@import "HashSet.js"
@import "Error.js"
@import "SymbolicWeight.js"
@import "Strength.js"
@import "Variable.js"
@import "Point.js"
@import "Expression.js"
@import "Constraint.js"
@import "EditInfo.js"
@import "Tableau.js"
@import "SimplexSolver.js"
@import "Timer.js"

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
    Object  _constraint;
    //CPArray _stayVariables    @accessors(getter=stayVariables);

    id       _container        @accessors(property=container);
    id       _firstItem        @accessors(property=firstItem);
    id       _secondItem       @accessors(property=secondItem);
    int      _firstAttribute   @accessors(property=firstAttribute);
    int      _secondAttribute  @accessors(property=secondAttribute);
    int      _relation         @accessors(property=relation);
    double   _constant         @accessors(property=constant);
    float    _coefficient      @accessors(property=multiplier);
    float    _priority         @accessors(property=priority);
    Strength _strength         @accessors(property=_strength);
    BOOL     _shouldBeArchived @accessors(property=shouldBeArchived);

    CPInteger _firstItemRestrictedAttribute;
    CPInteger _secondItemRestrictedAttribute;
}

+ (id)constraintWithItem:(id)item1 attribute:(int)att1 relatedBy:(int)relation toItem:(id)item2 attribute:(int)att2 multiplier:(double)multiplier constant:(double)constant
{
    return [[CPLayoutConstraint alloc] initWithItem:item1 attribute:att1 relatedBy:relation toItem:item2 attribute:att2 multiplier:multiplier constant:constant];
}

- (id)initWithItem:(id)item1 attribute:(int)att1 relatedBy:(int)relation toItem:(id)item2 attribute:(int)att2 multiplier:(double)multiplier constant:(double)constant
{
    self = [super init];

    _firstItem = item1;
    _secondItem = item2;
    _firstAttribute = att1;
    _secondAttribute = att2;
    _relation = relation;
    _coefficient = multiplier;
    _constant = constant;
    _priority = CPLayoutPriorityRequired;
    _shouldBeArchived = NO;

    [self _init];

    return self;
}

- (void)_init
{
    _strength = c.Strength.medium;
    //_stayVariables = [];
    _container = nil;
    _firstItemRestrictedAttribute = CPLayoutAttributeNotAnAttribute;
    _secondItemRestrictedAttribute = CPLayoutAttributeNotAnAttribute;
}

- (void)setStrength:(CPInteger)aStrength
{
    switch(aStrength)
    {
        case 0 : _strength = c.Strength.weak;
            break;
        case 1 : _strength = c.Strength.medium;
            break;
        case 2 : _strength = c.Strength.strong;
            break;
        case 3 : _strength = c.Strength.required;
            break;
    }
}

- (Object)_generateCassowaryConstraint
{
    if (!_constraint)
    {
        var first  = [self _expressionFromItem:_firstItem attribute:_firstAttribute],
            second = [self _expressionFromItem:_secondItem attribute:_secondAttribute];

        var msecond = second ? c.plus(c.times(second, _coefficient), _constant) : _constant;

        switch(_relation)
        {
            case CPLayoutRelationLessThanOrEqual    : _constraint = new c.Inequality(first, c.LEQ, msecond, _strength, _priority);
                break;
            case CPLayoutRelationGreaterThanOrEqual : _constraint = new c.Inequality(first, c.GEQ, msecond, _strength, _priority);
                break;
            case CPLayoutRelationEqual              : _constraint = new c.Equation(first, msecond, _strength, _priority);
                break;
        }
    }

    return _constraint;
}

- (id)expressionForAttributeLeft:(id)anItem
{
    if (anItem !== _container)
        return [anItem _variableMinX];

    return 0;
}

- (id)expressionForAttributeTop:(id)anItem
{
    if (anItem !== _container)
        return [anItem _variableMinY];

    return 0;
}

- (id)expressionForAttributeRight:(CPView)anItem
{
    var variableWidth = [anItem _variableWidth],
        expression;

    if (anItem === _container)
        expression = new c.Expression(variableWidth);
    else
        expression = new c.Expression([anItem _variableMinX]).plus(variableWidth);

    return expression;
}

- (id)expressionForAttributeBottom:(CPView)anItem
{
    var variableHeight = [anItem _variableHeight],
        expression;

    if (anItem === _container)
        expression = new c.Expression(variableHeight);
    else
        expression = new c.Expression([anItem _variableMinY]).plus(variableHeight);

    return expression;
}

- (id)expressionForAttributeCenterX:(CPView)anItem
{
    var midWidth = new c.Expression([anItem _variableWidth]).divide(2),
        expression;

    if (anItem === _container)
        expression = midWidth;
    else
    {
        var left = new c.Expression([anItem _variableMinX]);
        expression = c.plus(left, midWidth);
    }

    return expression;
}

- (id)expressionForAttributeCenterY:(CPView)anItem
{
    var midHeight = new c.Expression([anItem _variableHeight]).divide(2),
        expression;

    if (anItem === _container)
        expression = midHeight;
    else
    {
        var top = new c.Expression([anItem _variableMinY]);
        expression = c.plus(top, midHeight);
    }

    return expression;
}

- (Object)_expressionFromItem:(id)item attribute:(int)attr
{
    if (item == nil || attr == CPLayoutAttributeNotAnAttribute)
        return nil;

    var exp;

    switch(attr)
    {
        case CPLayoutAttributeLeading   :
        case CPLayoutAttributeLeft      : exp = [self expressionForAttributeLeft:item];
            break;
        case CPLayoutAttributeTrailing  :
        case CPLayoutAttributeRight     : exp = [self expressionForAttributeRight:item];
            break;
        case CPLayoutAttributeTop       : exp = [self expressionForAttributeTop:item];
            break;
        case CPLayoutAttributeBottom    : exp = [self expressionForAttributeBottom:item];
            break;
        case CPLayoutAttributeWidth     : exp = [item _variableWidth];
            break;
        case CPLayoutAttributeHeight    : exp = [item _variableHeight];
            break;
        case CPLayoutAttributeCenterX   : exp = [self expressionForAttributeCenterX:item];
            break;
        case CPLayoutAttributeCenterY   : exp = [self expressionForAttributeCenterY:item];
            break;
        case CPLayoutAttributeBaseline  :
            break;
    }

    return exp;
}

- (void)_addEditingVariablesForAttribute:(CPInteger)anAttribute ofItem:(id)anItem inEngine:(id)anEngine
{
    if (anAttribute === CPLayoutAttributeNotAnAttribute)
        return;

    var variable = nil;

    switch(anAttribute)
    {
        case CPLayoutAttributeLeft   : variable = [anItem _variableMinX];
        break;
        case CPLayoutAttributeTop    : variable = [anItem _variableMinY];
        break;
        case CPLayoutAttributeWidth  : variable = [anItem _variableWidth];
        break;
        case CPLayoutAttributeHeight : variable = [anItem _variableHeight];
        break;
    }

    if (variable)
        [anEngine addEditingVariable:variable];
}

- (void)restrictFirstItemAttribute:(CPInteger)anAttribute
{
    _firstItemRestrictedAttribute = anAttribute;
}

- (void)restrictSecondItemAttribute:(CPInteger)anAttribute
{
    _secondItemRestrictedAttribute = anAttribute;
}

- (void)addToEngine:(id)anEngine
{
    // CPLog.debug([self class] + " " + _cmd + " " + self);

    try
    {
        [self _generateCassowaryConstraint];

        //[anEngine addStayVariables:_stayVariables strength:_strength weight:_priority];

        [anEngine _addCassowaryConstraint:_constraint];

        [self _addEditingVariablesForAttribute:_firstItemRestrictedAttribute ofItem:_firstItem inEngine:anEngine];
        [self _addEditingVariablesForAttribute:_secondItemRestrictedAttribute ofItem:_secondItem inEngine:anEngine];

        [[anEngine constraints] addObject:self];
    }
    catch (e)
    {
        CPLog.warn(e  + "\nEngine content:\n" + [anEngine description]);
    }
}

- (CPView)layoutItem
{
    if (_firstItem === _container)
        return _secondItem;

    return _firstItem;
}

- (BOOL)isEqual:(id)anObject
{
    if (anObject === self)
        return YES;

    if (!anObject || anObject.isa !== self.isa || [anObject firstItem] !== _firstItem || [anObject secondItem] !== _secondItem || [anObject firstAttribute] !== _firstAttribute || [anObject secondAttribute] !== _secondAttribute || [anObject relation] !== _relation || [anObject multiplier] !== _coefficient || [anObject constant] !== _constant || [anObject priority] !== _priority)
        return NO;

    return YES;
}

- (CPString)description
{
    if (_constraint)
        return _constraint.toString();

    return [CPString stringWithFormat:@"%@ %@ %@ %@ %@ x%@ +%@ (%@)", ([_firstItem identifier] || ""), CPStringFromAttribute(_firstAttribute), CPStringFromRelation(_relation), ([_secondItem identifier] || ""), CPStringFromAttribute(_secondAttribute), _coefficient, _constant, _priority];
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
    //[aCoder encodeObject:_symbolicConstant forKey:CPSymbolicConstant];
    if (_coefficient !== 1)
        [aCoder encodeDouble:_coefficient forKey:CPMultiplier];

    [aCoder encodeDouble:_constant forKey:CPConstant];

    if (_priority !== CPLayoutPriorityRequired)
        [aCoder encodeInt:_priority forKey:CPPriority];

    [aCoder encodeBool:_shouldBeArchived forKey:CPShouldBeArchived];
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

    //var symbolicConstant = [aCoder decodeObjectForKey:CPSymbolicConstant];
    _constant = [aCoder decodeDoubleForKey:CPConstant];
    //[self _setSymbolicConstant:symbolicConstant constant:constant];

    _shouldBeArchived = [aCoder decodeBoolForKey:CPShouldBeArchived];
    //[self _setIdentifier:[aCoder decodeObjectForKey:CPLayoutIdentifier]];

    var hasKey = [aCoder containsValueForKey:CPPriority];
    _priority = (hasKey) ? [aCoder decodeIntForKey:CPPriority] : CPLayoutPriorityRequired;

    [self _init];

    //_ConstraintDidPerformInitialSetup(self);
    return self;
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