/*
 * AppController.j
 * CPLayoutConstraintTest
 *
 * Created by You on January 23, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <Foundation/CPValueTransformer.j>
@import <AppKit/CPWindow.j>
@import <AppKit/CPView.j>
@import <AppKit/CPArrayController.j>
@import <AppKit/CPBezierPath.j>
@import <AppKit/CPApplication.j>

// @import "../CPTrace.j"

var CONSTRAINT_PROPS = ["firstItem", "firstAttribute", "relation", "secondItem", "secondAttribute", "multiplier", "constant", "priority"];

CPLogRegister(CPLogConsole);

@implementation CPStringToFloatTransformer : CPValueTransformer
{
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)aValue
{
    return [aValue stringValue];
}

- (id)reverseTransformedValue:(id)aValue
{
    return [aValue floatValue];
}

@end

@implementation CPFloatToIntegerTransformer : CPValueTransformer
{
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)aValue
{
    return aValue;
}

- (id)reverseTransformedValue:(id)aValue
{
    return ROUND(aValue);
}

@end

@implementation CPBoolToColorTransformer : CPValueTransformer
{
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)aValue
{
    return aValue ? [CPColor redColor] : [CPColor greenColor];
}

@end

@implementation ConstraintsController : CPArrayController
{
}

- (id)newObject
{
    var delegate = [CPApp delegate];

    return LayoutConstraint([delegate view1], CPLayoutAttributeLeft, CPLayoutRelationEqual, nil, CPLayoutAttributeNotAnAttribute, 1, 50, 1000);
}

@end

@implementation CPNonKeyWindow : CPWindow
{
}

- (BOOL)canBecomeKeyWindow
{
    return NO;
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow theWindow;
    @outlet CPTableView tableView;
    @outlet CPTextField infoField;
    @outlet ConstraintsController constraintsController;
    @outlet CPPopover popover;

    CPWindow  constraintWindow;
    ColorView mainView  @accessors;
    ColorView view1     @accessors;
    ColorView view2     @accessors;

    CPArray constraints @accessors;
    CPArray items       @accessors;
}

+ (CPSet)keyPathsForValuesAffectingCanUpdate
{
    return [CPSet setWithObjects:@"constraints"];
}

- (id)init
{
    self = [super init];

    constraints = [];

    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(constraintSelectionDidChange:) name:@"CONSTRAINT_SELECTION" object:nil];

    return self;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    constraintWindow = [[CPNonKeyWindow alloc] initWithContentRect:CGRectMake(0,0,520,200) styleMask:CPTitledWindowMask|CPResizableWindowMask];
    [constraintWindow setTitle:@"Autolayout"];
    [constraintWindow setAutolayoutEnabled:YES];

    mainView = [[ConstraintView alloc] initWithFrame:[[constraintWindow contentView] frame]];
    //[mainView setVisualizeConstraints:YES];
    [mainView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [constraintWindow setContentView:mainView];

    view1 = [[ColorView alloc] initWithFrame:CGRectMake(50,50,300,100)];
    view2 = [[ColorView alloc] initWithFrame:CGRectMake(370,50,100,100)];

    [mainView setIdentifier:@"contentView"];
    [view1 setIdentifier:@"leftView"];
    [view2 setIdentifier:@"rightView"];

    [mainView addSubview:view1];
    [mainView addSubview:view2];

    [self setItems:[mainView, view1, view2]];

    [constraintWindow center];
    [constraintWindow orderFront:self];

    [self addDemoConstraints:nil];
    //[constraintWindow layout];
    [theWindow setFullPlatformWindow:YES];
}

- (void)awakeFromCib
{
CPLog.debug(_cmd);
}

- (BOOL)canUpdate
{
    return [constraints indexOfObjectPassingTest:function(obj,idx,stop)
    {
        return [obj dirty];
    }] !== CPNotFound;
}

- (IBAction)priorityAction:(id)sender
{
    var text = "",
        priority = [sender intValue];

    if (![popover isShown])
        [popover showRelativeToRect:nil ofView:sender preferredEdge:CPMaxYEdge];

    if (priority < CPLayoutPriorityDefaultLow)
        text = "Weaker than default weak priority at witch a control holds to its intrinsic content size.";
    else if (priority < CPLayoutPriorityDragThatCannotResizeWindow)
        text = "Weaker than the user resizing the window.";
    else if (priority < CPLayoutPriorityWindowSizeStayPut)
        text = "Weaker than the window staying same size.";
    else if (priority < CPLayoutPriorityDragThatCanResizeWindow)
        text = "Stronger than the window staying same size.";
    else if (priority < CPLayoutPriorityDefaultHigh)
        text = "Stronger than the user resizing the window.";
    else if (priority < CPLayoutPriorityRequired)
        text = "Not required but stronger than the priority at witch controls maintain their intrinsic content size.";
    else if (priority == CPLayoutPriorityRequired)
        text = "Required";

    var view = [[popover contentViewController] view],
        valueField = [view viewWithTag:1001],
        summaryField = [view viewWithTag:1000];

    [valueField setStringValue:priority];
    [summaryField setStringValue:text];
}

- (void)popoverShouldClose:(CPPopover)aPopover
{
    var flags = [[CPApp currentEvent] modifierFlags];
    CPLog.debug(_cmd + flags);

    return NO;
}

- (void)constraintSelectionDidChange:(CPNotification)aNote
{
    var constraint = [aNote object];

    var idx = [constraints indexOfObjectPassingTest:function(obj,i,stop)
    {
       return ([obj inEngineConstraint] == [constraint UID]);
    }];

    if (idx !== CPNotFound)
        [constraintsController setSelectionIndexes:[CPIndexSet indexSetWithIndex:idx]];
    else
        CPLog.debug(_cmd + [constraint container]);
}

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
    var row = [[aNotification object] selectedRow];
    if (row == CPNotFound)
        return;

    var constraintObject = [constraints objectAtIndex:row];
    [[mainView segments] enumerateObjectsUsingBlock:function(segment, idx, stop)
    {
        if ([[segment constraint] UID] == [constraintObject inEngineConstraint])
        {
            [mainView selectSegment:segment];
            stop(YES);
        }
    }];
}

- (IBAction)updateConstraints:(id)sender
{
    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        if ([aConstraint dirty] == YES)
        {
            var uuid = [aConstraint inEngineConstraint];
            if (uuid != nil)
            {
                var layoutConstraints = [mainView constraints];
                var idx = [layoutConstraints indexOfObjectPassingTest:function(obj,idx,stop)
                {
                    return [obj UID] == uuid;
                }];

                if (idx != CPNotFound)
                    [mainView removeConstraint:[layoutConstraints objectAtIndex:idx]];
            }

            var layoutConstraint = [aConstraint layoutConstraint];
            [mainView addConstraint:layoutConstraint];
            [aConstraint setDirty:NO];
            [aConstraint setInEngineConstraint:[layoutConstraint UID]];
        }
    }];

    [mainView setNeedsUpdateConstraints:YES];
}

- (IBAction)layout:(id)sender
{
    [constraintWindow layoutWithCallback:function()
    {
        [mainView layoutConstraints];
        [self updateTableauInfo];
    }];
}

- (IBAction)visualizeConstraints:(id)sender
{
    [mainView setVisualizeConstraints:[sender state]];
}

- (void)updateTableauInfo
{
    var engine = [constraintWindow _layoutEngineIfExists];

    [engine sendCommand:"info" withArguments:null callback:function(info)
    {
        [infoField setStringValue:info];
    }];
}

- (IBAction)addDemoConstraints:(id)sender
{
    var constraint1 = LayoutConstraint(mainView, CPLayoutAttributeRight, CPLayoutRelationEqual, view2, CPLayoutAttributeRight, 1, 50, 490);
//    [constraint1 setName:@"H:View1(0.25x(mainView))"];

    var constraint11 = LayoutConstraint(view1, CPLayoutAttributeWidth, CPLayoutRelationLessThanOrEqual, nil, CPLayoutAttributeNotAnAttribute, 1, 300, 1000);
//    [constraint11 setName:@"H:View1(<=400)"];

    var constraint2 = LayoutConstraint(view1, CPLayoutAttributeHeight, CPLayoutRelationEqual, nil, CPLayoutAttributeNotAnAttribute, 1, 100, 1000);
//    [constraint2 setName:@"V:View1(100)"];

    var constraint3 = LayoutConstraint(view1, CPLayoutAttributeLeft, CPLayoutRelationEqual, nil, CPLayoutAttributeNotAnAttribute, 1, 50, 1000);
    //[constraint3 setName:@"H:100-(view1)"];

    var constraint4 = LayoutConstraint(view1, CPLayoutAttributeTop, CPLayoutRelationEqual, nil, CPLayoutAttributeNotAnAttribute, 1, 50, 1000);
    //[constraint4 setName:@"V:100-(view1)"];

    var constraint5 = LayoutConstraint(view2, CPLayoutAttributeWidth, CPLayoutRelationEqual, nil, CPLayoutAttributeNotAnAttribute, 1, 100, 1000);
    //[constraint5 setName:@"H:View2(100)"];

    var constraint6 = LayoutConstraint(view2, CPLayoutAttributeHeight, CPLayoutRelationEqual, nil, CPLayoutAttributeNotAnAttribute, 1, 100, 1000);
    //[constraint6 setName:@"V:View2(100)"];

    var constraint7 = LayoutConstraint(view2, CPLayoutAttributeLeft, CPLayoutRelationEqual, view1, CPLayoutAttributeRight, 1, 20, 1000);
    //[constraint7 setName:@"H:(view1)-0-(view2)"];

    var constraint8 = LayoutConstraint(view2, CPLayoutAttributeTop, CPLayoutRelationEqual, nil, CPLayoutAttributeNotAnAttribute, 1, 50, 1000);
    //[constraint8 setName:@"V:100-(view1)"];

    var add = [constraint1, constraint11, constraint2, constraint3, constraint4, constraint5, constraint6, constraint7, constraint8];

    [self willChangeValueForKey:@"constraints"];
    [constraints addObjectsFromArray:add];
    [self didChangeValueForKey:@"constraints"];
}

- (void)logMetrics:(id)sender
{
    CPLog.debug("mainView " + CGStringFromRect([mainView frame]) + "\nleftView " + CGStringFromRect([view1 frame]) + "\nrightView " + CGStringFromRect([view2 frame]));
}

// Indexed accessors

- (id)countOfConstraints
{
    return [constraints count];
}

- (CPArray)objectInConstraintsAtIndexes:(CPIndexSet)indexes
{
    return [constraints objectsAtIndexes:indexes];
}

- (void)insertObjects:(CPArray)aConstraints inConstraintsAtIndexes:(CPIndexSet)indexes
{
    [constraints insertObjects:aConstraints atIndexes:indexes];
}

- (void)removeObjectsFromConstraintsAtIndexes:(CPIndexSet)indexes
{
    [constraints removeObjectsAtIndexes:indexes];
}

@end

@implementation ConstraintView : CPView
{
    CPArray _constraintSegments   @accessors(getter=segments);
    BOOL    _visualizeConstraints @accessors(property=visualizeConstraints);
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    _constraintSegments = [];
    _visualizeConstraints = YES;

    return self;
}

- (void)setVisualizeConstraints:(BOOL)flag
{
    if (flag !== _visualizeConstraints)
    {
        if (flag == NO)
            [self removeAccessoryViews];

        _visualizeConstraints = flag;
    }

    [self setNeedsDisplay:YES];
}

- (void)removeAccessoryViews
{
    [_constraintSegments enumerateObjectsUsingBlock:function(aSegment, idx, stop)
    {
        [[aSegment accessoryView] removeFromSuperview];
    }];
}

- (void)layoutConstraints
{
    [self removeAccessoryViews];

    _constraintSegments = [];

    [[self constraints] enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        var segment = [[ConstraintSegment alloc] initWithConstraint:aConstraint];
        [_constraintSegments addObject:segment];
    }];

    [self setNeedsDisplay:YES];
}

- (void)selectSegment:(id)aSegment
{
    [_constraintSegments enumerateObjectsUsingBlock:function(segment, idx, stop)
    {
        [segment setSelected:NO];
    }];

    [aSegment setSelected:YES];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(CGRect)aRect
{
    if (!_visualizeConstraints)
        return;

    [_constraintSegments enumerateObjectsUsingBlock:function(aSegment, idx, stop)
    {
        [aSegment layout];

        var path = [aSegment path];
        var color = [aSegment selected] ? [CPColor orangeColor] : [CPColor blueColor];
        [color setStroke];
        [path stroke];

        var view = [aSegment accessoryView];
        if (![view superview])
            [self addSubview:view];
    }];

    [[CPColor redColor] setStroke];
    [CPBezierPath strokeRect:[self bounds]];
}

- (void)_layoutSubviews
{
    CPLog.debug(_cmd);
}

@end

@implementation ConstraintSegment : CPObject
{
    CPLayoutConstraint _constraint    @accessors(getter=constraint);
    CPBezierPath       _path          @accessors(getter=path);
    CPView             _accessoryView @accessors(getter=accessoryView);
    BOOL               _selected      @accessors(getter=selected);
}

- (id)initWithConstraint:(id)aConstraint
{
    self = [super init];

    _constraint = aConstraint;
    _path = nil;
    _selected = NO;
    _accessoryView = [[OperatorView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    [_accessoryView setSegment:self];
    [_accessoryView setRelation:[_constraint relation]];

    return self;
}

- (void)setSelected:(BOOL)flag
{
    _selected = flag;
    [_accessoryView setSelected:flag];
}

- (void)layout
{
    var container       = [_constraint container],
        firstItem       = [_constraint firstItem] || container,
        secondItem      = [_constraint secondItem] || container,
        firstAttribute  = [_constraint firstAttribute],
        secondAttribute = [_constraint secondAttribute],
        relation        = [_constraint relation],
        multiplier      = [_constraint multiplier],
        constant        = [_constraint constant],
        priority        = [_constraint priority],
        angle = 0;

    if (container == nil)
        return;

    if (secondAttribute === CPLayoutAttributeNotAnAttribute && firstAttribute !== CPLayoutAttributeWidth && firstAttribute !== CPLayoutAttributeHeight)
        secondAttribute = firstAttribute;

    var startPoint = CGPointMakeZero(),
        endPoint = CGPointMakeZero();

    if (firstAttribute == CPLayoutAttributeLeft)
    {
        startPoint.x = (firstItem !== container) ? CGRectGetMinX([firstItem frame]) : 0;
        startPoint.y = (firstItem !== container) ? CGRectGetMidY([firstItem frame]) : CGRectGetMidY([secondItem frame]);
        angle = 0;
    }
    else if (firstAttribute == CPLayoutAttributeRight)
    {
        startPoint.x = (firstItem !== container) ? CGRectGetMaxX([firstItem frame]) : CGRectGetWidth([container frame]);
        startPoint.y = (firstItem !== container) ? CGRectGetMidY([firstItem frame]) : CGRectGetMidY([secondItem frame]);
        angle = 180;
    }
    else if (firstAttribute == CPLayoutAttributeTop)
    {
        startPoint.y = (firstItem !== container) ? CGRectGetMinY([firstItem frame]) : 0;
        startPoint.x = (firstItem !== container) ? CGRectGetMidX([firstItem frame]) : CGRectGetMidX([secondItem frame]);
        angle = 90;
    }
    else if (firstAttribute == CPLayoutAttributeBottom)
    {
        startPoint.y = (firstItem !== container) ? CGRectGetMaxY([firstItem frame]) : CGRectGetHeight([container frame]);
        startPoint.x = (firstItem !== container) ? CGRectGetMidX([firstItem frame]) : CGRectGetMidX([secondItem frame]);
        angle = -90;
    }
    else if (firstAttribute == CPLayoutAttributeWidth)
    {
        startPoint.x = CGRectGetMinX([firstItem frame]);
        startPoint.y = CGRectGetMaxY([firstItem frame]) - 10;
        endPoint.x   = CGRectGetMaxX([firstItem frame]);
        endPoint.y   = CGRectGetMaxY([firstItem frame]) - 10;
        angle = -180;
    }
    else if (firstAttribute == CPLayoutAttributeHeight)
    {
        startPoint.x = CGRectGetMinX([firstItem frame]) + 10;
        startPoint.y = CGRectGetMinY([firstItem frame]);
        endPoint.x   = CGRectGetMinX([firstItem frame]) + 10;
        endPoint.y   = CGRectGetMaxY([firstItem frame]);
        angle = -90;
    }

    if (secondAttribute == CPLayoutAttributeLeft)
    {
        endPoint.x = (secondItem !== container) ? CGRectGetMinX([secondItem frame]) : 0;
        endPoint.y = startPoint.y;
    }
    else if (secondAttribute == CPLayoutAttributeRight)
    {
        endPoint.x = (secondItem !== container) ? CGRectGetMaxX([secondItem frame]) : CGRectGetWidth([container frame]);
        endPoint.y = startPoint.y;
    }
    else if (secondAttribute == CPLayoutAttributeTop)
    {
        endPoint.y = (secondItem !== container) ? CGRectGetMinY([secondItem frame]) : 0;
        endPoint.x = startPoint.x;
    }
    else if (secondAttribute == CPLayoutAttributeBottom)
    {
        endPoint.y = (secondItem !== container) ? CGRectGetMaxY([secondItem frame]) : CGRectGetHeight([container frame]);
        endPoint.x = startPoint.x;
    }

    var path = [CPBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path lineToPoint:endPoint];

    [path setLineDash:((priority < 1000) ? [5,5]:[]) phase:0];

    _path = path;
    [_accessoryView setFrameOrigin:CGPointMake((startPoint.x + endPoint.x)/2 - 7, (startPoint.y + endPoint.y)/2 - 7)];
}

@end

@implementation OperatorView : CPView
{
    id        _segment  @accessors(property=segment);
    CPString  _text;
    BOOL      _selected @accessors(property=selected);
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    _segment = nil;
    _text = "";
    _selected = NO;

    return self;
}

- (void)setRelation:(CPInteger)aRelation
{
    switch (aRelation)
    {
        case -1 : _text = "≤";
        break;
        case 0 : _text = "=";
        break;
        case 1 : _text = "≥";
        break;
    }
}

- (void)drawRect:(CGRect)aRect
{
    var bounds = [self bounds],
        radius = CGRectGetWidth(bounds)/2;

    var path = [CPBezierPath bezierPathWithRoundedRect:bounds xRadius:radius yRadius:radius];
    var color = _selected ? [CPColor orangeColor] : [CPColor blueColor];

    [color setFill];
    [path fill];

    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    ctx.font = "bold 16px American Typewriter";
    ctx.textAlign = "center";
    ctx.fillStyle = "white";
    ctx.fillText(_text, 7, 12);
}

- (void)setSelected:(BOOL)flag
{
    _selected = flag;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(CPEvent)anEvent
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"CONSTRAINT_SELECTION" object:[_segment constraint] userInfo:nil];
}

@end

@implementation ColorView : CPView
{
    CPColor color;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    [self setColor:[CPColor blackColor]];

    return self;
}

- (void)awakeFromCib
{
    [self setColor:[CPColor blackColor]];
}

- (void)setColor:(CPColor)aColor
{
    color = aColor;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(CGRect)aRect
{
    [color setStroke];
    [CPBezierPath setDefaultLineWidth:2];
    [CPBezierPath strokeRect:[self bounds]];
}

@end

@implementation ConstraintObject : CPObject
{
    id       _firstItem            @accessors(property=firstItem);
    id       _secondItem           @accessors(property=secondItem);
    int      _firstAttribute       @accessors(property=firstAttribute);
    int      _secondAttribute      @accessors(property=secondAttribute);
    int      _relation             @accessors(property=relation);
    double   _constant             @accessors(property=constant);
    float    _coefficient          @accessors(property=multiplier);
    float    _priority             @accessors(property=priority);

    BOOL     _dirty                @accessors(property=dirty);
    CPString _inEngineConstraint   @accessors(property=inEngineConstraint);
}


- (id)initWithItem:(id)item1 attribute:(int)att1 relatedBy:(int)relation toItem:(id)item2 attribute:(int)att2 multiplier:(double)multiplier constant:(double)constant priority:(float)priority
{
    self = [super init];

    _firstItem = item1;
    _secondItem = item2;
    _firstAttribute = att1;
    _secondAttribute = att2;
    _relation = relation;
    _coefficient = multiplier;
    _constant = constant;
    _priority = priority;
    _dirty    = YES;
    _inEngineConstraint = nil;

    [self addObserver:self forKeyPath:@"description" options:CPKeyValueObservingOptionOld|CPKeyValueObservingOptionNew context:"description"];

    return self;
}

+ (CPSet)keyPathsForValuesAffectingDescription
{
    return [CPSet setWithObjects:@"firstItem",@"secondItem",@"firstAttribute",@"secondAttribute",@"relation",@"constant",@"multiplier",@"priority"];
}

- (CPLayoutConstraint)layoutConstraint
{
    var cst = [CPLayoutConstraint constraintWithItem:_firstItem attribute:_firstAttribute relatedBy:_relation toItem:_secondItem attribute:_secondAttribute multiplier:_coefficient constant:_constant];

    [cst setPriority:_priority];

    return cst;
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@ %@ %@ %@ %@ x%@ +%@ (%@)", ([_firstItem identifier] || [_firstItem className] || ""), CPStringFromAttribute(_firstAttribute), CPStringFromRelation(_relation), ([_secondItem identifier] || [_secondItem className] || ""), CPStringFromAttribute(_secondAttribute), _coefficient, _constant, _priority];
}

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
CPLog.debug("change " + [change description]);

    if (context == "description")
    {
        [self setDirty:YES];
    }
}

@end

var CPStringFromAttribute = function(attr)
{
    return ["NotAnAttribute", "Left", "Right", "Top", "Bottom", "Left", "Right", "Width",  "Height", "CenterX", "CenterY", "Baseline"][attr];
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

var LayoutConstraint = function(firstItem, firstAttr, relation, secondItem, secondAttr, multiplier, constant, priority)
{
    return [[ConstraintObject alloc] initWithItem:firstItem attribute:firstAttr relatedBy:relation toItem:secondItem attribute:secondAttr multiplier:multiplier constant:constant priority:priority];
};
