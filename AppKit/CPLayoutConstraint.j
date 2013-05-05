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

CPViewVariableMinX   = 1 << 1,
CPViewVariableMinY   = 1 << 2,
CPViewVariableWidth  = 1 << 3,
CPViewVariableHeight = 1 << 4;

var CPLayoutAttributeLabels = ["NotAnAttribute",  "Left",  "Right",  "Top",  "Bottom",  "Left",  "Right",  "Width",  "Height",  "CenterX",  "CenterY",  "Baseline"];


@implementation CPLayoutConstraint : CPObject
{
    Object  _constraint;

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
    _constraint = nil;
    _strength = c.Strength.medium;
    _container = nil;
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

- (Object)_constraint
{
    return _constraint;
}

- (Object)_generateCassowaryConstraint
{
    var first  = [self _expressionFromItem:_firstItem attribute:_firstAttribute],
        second = [self _expressionFromItem:_secondItem attribute:_secondAttribute],
        constraint;

    var msecond = second ? c.plus(c.times(second, _coefficient), _constant) : _constant;

    switch(_relation)
    {
        case CPLayoutRelationLessThanOrEqual    : constraint = new c.Inequality(first, c.LEQ, msecond, _strength, _priority);
            break;
        case CPLayoutRelationGreaterThanOrEqual : constraint = new c.Inequality(first, c.GEQ, msecond, _strength, _priority);
            break;
        case CPLayoutRelationEqual              : constraint = new c.Equation(first, msecond, _strength, _priority);
            break;
    }

    return constraint;
}

- (id)expressionForAttributeLeft:(id)anItem
{
    if (anItem !== _container)
        return CPViewLayoutVariable(anItem, CPViewVariableMinX);

    return 0;
}

- (id)expressionForAttributeTop:(id)anItem
{
    if (anItem !== _container)
        return CPViewLayoutVariable(anItem, CPViewVariableMinY);

    return 0;
}

- (id)expressionForAttributeRight:(CPView)anItem
{
    var variableWidth = CPViewLayoutVariable(anItem, CPViewVariableWidth);

    if (anItem === _container)
        return new c.Expression(variableWidth);

    return new c.Expression(CPViewLayoutVariable(anItem, CPViewVariableMinX)).plus(variableWidth);
}

- (id)expressionForAttributeBottom:(CPView)anItem
{
    var variableHeight = CPViewLayoutVariable(anItem, CPViewVariableHeight);

    if (anItem === _container)
        return new c.Expression(variableHeight);

    return new c.Expression(CPViewLayoutVariable(anItem, CPViewVariableMinY)).plus(variableHeight);
}

- (id)expressionForAttributeCenterX:(CPView)anItem
{
    var midWidth = new c.Expression(CPViewLayoutVariable(anItem, CPViewVariableWidth)).divide(2);

    if (anItem === _container)
        return midWidth;

    var left = new c.Expression(CPViewLayoutVariable(anItem, CPViewVariableMinX));

    return c.plus(left, midWidth);
}

- (id)expressionForAttributeCenterY:(CPView)anItem
{
    var midHeight = new c.Expression(CPViewLayoutVariable(anItem, CPViewVariableHeight)).divide(2);

    if (anItem === _container)
        return midHeight;

    var top = new c.Expression(CPViewLayoutVariable(anItem, CPViewVariableMinY));

    return c.plus(top, midHeight);
}

- (Object)_expressionFromItem:(id)anItem attribute:(int)attr
{
    if (anItem == nil || attr == CPLayoutAttributeNotAnAttribute)
        return nil;

    var exp;

    switch(attr)
    {
        case CPLayoutAttributeLeading   :
        case CPLayoutAttributeLeft      : exp = [self expressionForAttributeLeft:anItem];
            break;
        case CPLayoutAttributeTrailing  :
        case CPLayoutAttributeRight     : exp = [self expressionForAttributeRight:anItem];
            break;
        case CPLayoutAttributeTop       : exp = [self expressionForAttributeTop:anItem];
            break;
        case CPLayoutAttributeBottom    : exp = [self expressionForAttributeBottom:anItem];
            break;
        case CPLayoutAttributeWidth     : exp = CPViewLayoutVariable(anItem, CPViewVariableWidth);
            break;
        case CPLayoutAttributeHeight    : exp = CPViewLayoutVariable(anItem, CPViewVariableHeight);
            break;
        case CPLayoutAttributeCenterX   : exp = [self expressionForAttributeCenterX:anItem];
            break;
        case CPLayoutAttributeBaseline  :
        case CPLayoutAttributeCenterY   : exp = [self expressionForAttributeCenterY:anItem];
            break;
    }

    return exp;
}

- (void)addToEngine:(id)anEngine
{
    try
    {
        _constraint = [self _generateCassowaryConstraint];

        [anEngine _addCassowaryConstraint:_constraint];

        [[anEngine constraints] addObject:self];
    }
    catch (e)
    {
        CPLog.warn(e  + "\nEngine content:\n" + [anEngine description]);
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

    _constant = [aCoder decodeDoubleForKey:CPConstant];

    _shouldBeArchived = [aCoder decodeBoolForKey:CPShouldBeArchived];
    //[self _setIdentifier:[aCoder decodeObjectForKey:CPLayoutIdentifier]];

    var hasKey = [aCoder containsValueForKey:CPPriority];
    _priority = (hasKey) ? [aCoder decodeIntForKey:CPPriority] : CPLayoutPriorityRequired;

    [self _init];

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

function CPViewLayoutVariable(anItem, aVariableFlag)
{
    var variable;

    switch (aVariableFlag)
    {
        case CPViewVariableMinX   : variable = [anItem _variableMinX];
        break;
        case CPViewVariableMinY   : variable = [anItem _variableMinY];
        break;
        case CPViewVariableWidth  : variable = [anItem _variableWidth];
        break;
        case CPViewVariableHeight : variable = [anItem _variableHeight];
        break;
    }

    return variable;
}