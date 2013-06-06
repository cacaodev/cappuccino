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

@implementation ConstraintsController : CPArrayController
{
}

- (id)newObject
{
    var delegate = [CPApp delegate];

    var constraint = [CPLayoutConstraint constraintWithItem:[delegate view1] attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:50];

    [constraint setPriority:1000];

    return constraint;
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
    ColorView mainView @accessors;
    ColorView view1    @accessors;
    ColorView view2    @accessors;

    CPArray constraints @accessors;
    CPArray items       @accessors;
}

- (id)init
{
    self = [super init];

    constraints = [];

    [self addObserver:self forKeyPath:@"constraints" options:CPKeyValueObservingOptionOld|CPKeyValueObservingOptionNew context:"constraints"];

    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(constraintSelectionDidChange:) name:@"CONSTRAINT_SELECTION" object:nil];

    return self;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    constraintWindow = [[CPNonKeyWindow alloc] initWithContentRect:CGRectMake(0,0,520,200) styleMask:CPTitledWindowMask|CPResizableWindowMask];

    mainView = [[ConstraintView alloc] initWithFrame:[[constraintWindow contentView] frame]];
    [mainView setVisualizeConstraints:YES];
    [constraintWindow setContentView:mainView];

    view1 = [[ColorView alloc] initWithFrame:CGRectMake(50,50,300,100)];
    view2 = [[ColorView alloc] initWithFrame:CGRectMake(370,50,100,100)];

    [mainView setIdentifier:@"contentView"];
    [view1 setIdentifier:@"leftView"];
    [view2 setIdentifier:@"rightView"];

    [mainView addSubview:view1];
    [mainView addSubview:view2];

CPLog.debug(_cmd);
    [self setItems:[mainView, view1, view2]];

    [constraintWindow center];
    [constraintWindow orderFront:self];

    [self addDemoConstraints:nil];
    //[constraintWindow layout];
}

- (void)awakeFromCib
{
CPLog.debug(_cmd);
    [theWindow setFullPlatformWindow:YES];
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
    CPLog.debug(_cmd + [aNote object]);
    var constraint = [aNote object],
        segment = [aNote userInfo];

    [mainView selectSegment:segment];
    [constraintsController setSelectedObjects:[constraint]];
}

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
    var row = [[aNotification object] selectedRow];
    if (row == CPNotFound)
        return;

    var constraint = [constraints objectAtIndex:row];
    [[mainView segments] enumerateObjectsUsingBlock:function(segment, idx, stop)
    {
        if ([segment constraint] == constraint)
        {
            [mainView selectSegment:segment];
            stop(YES);
        }
    }];
}

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
CPLog.debug("change " + [change description]);

    if (context == "constraints")
    {
        var kind = [change objectForKey:CPKeyValueChangeKindKey];

        if (kind === CPKeyValueChangeSetting || kind === CPKeyValueChangeRemoval)
        {
            var oldConstraints = [change objectForKey:CPKeyValueChangeOldKey];
            [self stopObservingConstraintsProperties:oldConstraints];
            [mainView removeConstraints:oldConstraints];
        }

        if (kind === CPKeyValueChangeSetting || kind === CPKeyValueChangeInsertion)
        {
            var newConstraints = [change objectForKey:CPKeyValueChangeNewKey];
            [self startObservingConstraintsProperties:newConstraints];
            [mainView addConstraints:newConstraints];
        }
    }
    else if (context == "constraint")
    {
        [tableView reloadData];
    }

    [mainView setNeedsUpdateConstraints:YES];
    [mainView layoutConstraints];
}

- (void)startObservingConstraintsProperties:(CPArray)theConstraints
{
    [theConstraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        var constraint = aConstraint;
        [CONSTRAINT_PROPS enumerateObjectsUsingBlock:function(akeyPath, idx, stop)
        {
            [constraint addObserver:self forKeyPath:akeyPath options:CPKeyValueObservingOptionOld|CPKeyValueObservingOptionNew context:"constraint"];
        }];
    }];
}

- (void)stopObservingConstraintsProperties:(CPArray)theConstraints
{
    [theConstraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        var constraint = aConstraint;
        [CONSTRAINT_PROPS enumerateObjectsUsingBlock:function(akeyPath, idx, stop)
        {
            [constraint removeObserver:self forKeyPath:akeyPath];
        }];
    }];
}

- (IBAction)visualizeConstraints:(id)sender
{
    [mainView setVisualizeConstraints:[sender state]];
}
/*
- (IBAction)constraintUpdate:(id)sender
{
    [tableView reloadData];
    [mainView layoutConstraints];
}
*/
- (IBAction)getTableauInformation:(id)sender
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

- (id)objectInConstraintsAtIndex:(CPInteger)anIndex
{
    return [constraints objectAtIndex:anIndex];
}

- (void)insertObject:(id)aConstraint inConstraintsAtIndex:(CPInteger)anIndex
{
    [constraints insertObject:aConstraint atIndex:anIndex];
}

- (void)removeObjectFromConstraintsAtIndex:(CPInteger)anIndex
{
    [constraints removeObjectAtIndex:anIndex];
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

@implementation ConstraintView : CPView
{
    CPArray _constraintSegments @accessors(getter=segments);
    BOOL    _visualizeConstraints @accessors(property=visualizeConstraints);
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    _constraintSegments = [];
    _visualizeConstraints = NO;

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

- (id)initWithConstraint:(CPLayoutConstraint)aConstraint
{
    self = [super init];

    _constraint = aConstraint;
    _path = nil;
    _selected = NO;
    _accessoryView = [[OperatorView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    [_accessoryView setSegment:self];
    [_accessoryView setRelation:[aConstraint relation]];

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
        priority        = [_constraint priority];

    var angle = 0;

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
    [[CPNotificationCenter defaultCenter] postNotificationName:@"CONSTRAINT_SELECTION" object:[_segment constraint] userInfo:_segment];
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

- (id)awakeFromCib
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

var LayoutConstraint = function(firstItem, firstAttr, relation, secondItem, secondAttr, multiplier, constant, priority)
{
    var constraint = [CPLayoutConstraint constraintWithItem:firstItem attribute:firstAttr relatedBy:relation toItem:secondItem attribute:secondAttr multiplier:multiplier constant:constant];

    [constraint setPriority:priority];

    return constraint;
}
