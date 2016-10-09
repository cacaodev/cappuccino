/*
 * AppController.j
 * QuadrilateralDemo
 *
 * Created by You on August 4, 2016.
 * Copyright 2016, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@import "CPMouseTracker.j"

var EDIT_PRIORITY = 1000;

@implementation AppController : CPObject
{
    CPInteger pNum;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var constraints = @[];
    pNum = 0;

    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
    [contentView setIdentifier:@"contentView"];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];

    var container = [[ColorView alloc] initWithFrame:CGRectMakeZero()];
    [container setIdentifier:@"container"];
    [container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:container];

    var tf = [[CPTextField alloc] initWithFrame:CGRectMake(50, 10, 1200, 50)];
    [tf setFont:[CPFont boldSystemFontOfSize:32]];
    [tf setStringValue:@"cmd-click on a point to edit the priority of its constrained coordinates."];
    [contentView addSubview:tf];

// Add constraints for the container view
    var left = [[container leftAnchor] constraintEqualToAnchor:[contentView leftAnchor] constant:50],
        top  = [[container topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:100],
        right = [[container rightAnchor] constraintEqualToAnchor:[contentView rightAnchor] constant:-50],
        bottom = [[container bottomAnchor] constraintEqualToAnchor:[contentView bottomAnchor] constant:-50];

    [CPLayoutConstraint activateConstraints:@[left, top, right, bottom]];

// Install edges points
 
    var p1 = [self installLayoutPointAtLocation:CGPointMake(100, 100) inView:container priority:900];
    var p2 = [self installLayoutPointAtLocation:CGPointMake(1100, 100) inView:container priority:910];
    var p3 = [self installLayoutPointAtLocation:CGPointMake(1100, 500) inView:container priority:920];
    var p4 = [self installLayoutPointAtLocation:CGPointMake(100, 500) inView:container priority:930];

// Install mid points

    var p5 = [self installLayoutPointAtLocation:CGPointMake(600, 100) inView:container priority:500];
    var p6 = [self installLayoutPointAtLocation:CGPointMake(1100,300) inView:container priority:500];
    var p7 = [self installLayoutPointAtLocation:CGPointMake(600,500) inView:container priority:500];
    var p8 = [self installLayoutPointAtLocation:CGPointMake(100,300) inView:container priority:500];

// Constrain mid points
    var midConstraints1 = [p5 constraintsBetweenPoint:p1 andPoint:p2];
    var midConstraints2 = [p6 constraintsBetweenPoint:p2 andPoint:p3];
    var midConstraints3 = [p7 constraintsBetweenPoint:p3 andPoint:p4];
    var midConstraints4 = [p8 constraintsBetweenPoint:p4 andPoint:p1];

    [constraints addObjectsFromArray:midConstraints1];
    [constraints addObjectsFromArray:midConstraints2];
    [constraints addObjectsFromArray:midConstraints3];
    [constraints addObjectsFromArray:midConstraints4];
/*
// Constrain points inside the container view
    var p1Constraints = [p1 constraintsContainingWithinView:container];
    var p2Constraints = [p2 constraintsContainingWithinView:container];
    var p3Constraints = [p3 constraintsContainingWithinView:container];
    var p4Constraints = [p4 constraintsContainingWithinView:container];
// ... and also mid points

    var p5Constraints = [p5 constraintsContainingWithinView:container];
    var p6Constraints = [p6 constraintsContainingWithinView:container];
    var p7Constraints = [p7 constraintsContainingWithinView:container];
    var p8Constraints = [p8 constraintsContainingWithinView:container];

    [constraints addObjectsFromArray:p1Constraints];
    [constraints addObjectsFromArray:p2Constraints];
    [constraints addObjectsFromArray:p3Constraints];
    [constraints addObjectsFromArray:p4Constraints];

    [constraints addObjectsFromArray:p5Constraints];
    [constraints addObjectsFromArray:p6Constraints];
    [constraints addObjectsFromArray:p7Constraints];
    [constraints addObjectsFromArray:p8Constraints];
*/
// Activate the Quadrilateral constraints
    [CPLayoutConstraint activateConstraints:constraints];
    [theWindow orderFront:self];

 //   CPLog.debug([container _layoutEngine]);
}

- (id)installLayoutPointAtLocation:(CPPoint)loc inView:(CPView)aView priority:(CPInteger)priority
{
    var idx = pNum++;

    var anchorX = [CPLayoutXAxisAnchor anchorNamed:(@"x"+idx) inItem:aView];
    var anchorY = [CPLayoutYAxisAnchor anchorNamed:(@"y"+idx) inItem:aView];

    var layoutPoint = [CPLayoutPoint layoutPointWithXAxisAnchor:anchorX yAxisAnchor:anchorY];

    var xConstraint = [anchorX constraintEqualToConstant:loc.x];
    var yConstraint = [anchorY constraintEqualToConstant:loc.y];

    [xConstraint setPriority:priority];
    [yConstraint setPriority:priority];

    var constraints = @[xConstraint, yConstraint];
    [aView addConstraints:constraints forLayoutPoint:layoutPoint atLocation:loc withPriority:priority];
    [CPLayoutConstraint activateConstraints:constraints];

    var constraintsWithinView = [layoutPoint constraintsContainingWithinView:aView];
    [CPLayoutConstraint activateConstraints:constraintsWithinView];

    return layoutPoint;
}

@end

@implementation CPLayoutPoint (Additions)

- (CPArray)constraintsBetweenPoint:(id)p1 andPoint:(id)p2
{
    var midAnchorX = [[p1 xAxisAnchor] anchorAtMidpointToAnchor:[p2 xAxisAnchor]];
    var midAnchorY = [[p1 yAxisAnchor] anchorAtMidpointToAnchor:[p2 yAxisAnchor]];

    var cstX = [[self xAxisAnchor] constraintEqualToAnchor:midAnchorX];
    var cstY = [[self yAxisAnchor] constraintEqualToAnchor:midAnchorY];

    return @[cstX, cstY];
}

- (CPArray)constraintsContainingWithinView:(CPView)aView
{
    var cst1 = [[self xAxisAnchor] constraintGreaterThanOrEqualToConstant:0];
    var cst2 = [[self yAxisAnchor] constraintGreaterThanOrEqualToConstant:0];
 //   var cst3 = [[self xAxisAnchor] constraintLessThanOrEqualToAnchor:[aView rightAnchor]];
 //   var cst4 = [[self yAxisAnchor] constraintLessThanOrEqualToAnchor:[aView bottomAnchor]];

    return @[cst1, cst2];
}

@end

@implementation ColorView : CPView
{
    Map layoutPointToConstraints;
    CPMouseTracker mouseTracker;
    CPLayoutPoint trackingPoint;
    CGPoint currentLocation;

    CPPopover popover;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    mouseTracker = [[CPMouseTracker alloc] init];
    trackingPoint = nil;
    layoutPointToConstraints = new Map();
    currentLocation = CGPointMakeZero();
    popover = nil;

    return self;
}

- (void)addConstraints:(CPArray)constraints forLayoutPoint:(id)aLayoutPoint atLocation:(CGPoint)aLocation withPriority:(CPInteger)priority
{
    layoutPointToConstraints.set(aLayoutPoint, @{"constraints" : constraints, "priority" : priority, "currentPoint" : aLocation});
}

- (void)setPriority:(CPInteger)aPriority forLayoutPoint:(CPLayoutPoint)aLayoutPoint
{
    var info = layoutPointToConstraints.get(aLayoutPoint);
    [info setObject:aPriority forKey:@"priority"];

    var constraints = [self stayConstraintsForLayoutPoint:aLayoutPoint];
    [constraints makeObjectsPerformSelector:@selector(setPriority:) withObject:aPriority];
}

- (CPInteger)priorityForLayoutPoint:(CPLayoutPoint)aLayoutPoint
{
    var info = layoutPointToConstraints.get(aLayoutPoint);
    if (info == null)
        return CPNotFound;

    return [info objectForKey:@"priority"];
}

- (CPArray)stayConstraintsForLayoutPoint:(CPLayoutPoint)aLayoutPoint
{
    var info = layoutPointToConstraints.get(aLayoutPoint);
    if (info == null)
        return nil;

    return [info objectForKey:@"constraints"];
}

- (void)updateStayConstraints
{
    layoutPointToConstraints.forEach(function(info, point)
    {
        var p = [point valueInEngine:nil],
            constraints = [info objectForKey:@"constraints"],
            constraintX = [constraints objectAtIndex:0],
            constraintY = [constraints objectAtIndex:1];

        if (info && point == trackingPoint)
        {
            [self setPriority:[info objectForKey:@"priority"] forLayoutPoint:point];
        }

        var currentPoint = [info objectForKey:@"currentPoint"];
        var newOffsetX = p.x - currentPoint.x,
            newOffsetY = p.y - currentPoint.y;

        CPLog.debug("offset=" + newOffsetX + "," + newOffsetY + " constraints=" + [constraints description]);

        [constraintX setConstant:p.x];
        [constraintY setConstant:p.y];

        [info setObject:CGPointMake(p.x, p.y) forKey:@"currentPoint"];
    });
}

- (void)drawString:(CPString)aString inRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    ctx.font = [[CPFont boldSystemFontOfSize:20] cssString];
    var metrics = ctx.measureText(aString);
    ctx.fillText(aString, CGRectGetMinX(aRect) + (CGRectGetWidth(aRect) - metrics.width)/2, CGRectGetMinY(aRect) + (CGRectGetHeight(aRect) + 5)/2);
}

- (void)drawRect:(CGRect)aRect
{
    // Please, do not look at the drawing code, it's really quick & dirty.
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [[CPColor redColor] set];

    CGContextFillRect(ctx, [self bounds]);

    var normal = [CPColor blackColor],
        selected = [CPColor blueColor];

    [normal setStroke];
    var path = [CPBezierPath bezierPath];
    var rectanglePath = [CPBezierPath bezierPath];
    [path setLineWidth:3];

    var points = Array.from(layoutPointToConstraints.keys());

    [points enumerateObjectsUsingBlock:function(point, idx, stop)
    {
        var p = [point valueInEngine:nil];

        if (idx == 0)
        {
            [path moveToPoint:p];
        }
        else if (idx == 4)
        {
            [rectanglePath moveToPoint:p];
        }
        else if (idx < 4)
        {
            [path lineToPoint:p];
        }
        else
        {
            [rectanglePath lineToPoint:p];
        }

        if (idx == 3)
        {
            [path closePath];
        }
        else if (idx == 7)
        {
            [rectanglePath closePath];
        }
    }];

    [path stroke];
    [rectanglePath stroke];
    [[CPColor colorWithWhite:0.5 alpha:0.2] set];
    [rectanglePath fill];

    [points enumerateObjectsUsingBlock:function(point, idx, stop)
    {
        var isSelected = (point == trackingPoint);
        var color =  isSelected ? selected : normal;
        [color setFill];

        var p = [point valueInEngine:nil];
        CPLog.debug(CPStringFromPoint(p));
        var rect = CGRectMake(p.x - 25, p.y - 25, 50, 50);
        [[CPBezierPath bezierPathWithOvalInRect:rect] fill];

        var priority = isSelected ? EDIT_PRIORITY : [self priorityForLayoutPoint:point];
        [[CPColor whiteColor] setFill];
        [self drawString:ROUND(priority) inRect:rect];
    }];
}

- (CPPopover)popover
{
    if (popover == nil)
    {
        popover = [[CPPopover alloc] init];
        [popover setBehavior:CPPopoverBehaviorTransient];
        [popover setDelegate:self];
        var vc = [[ContentViewController alloc] init];
        [vc setTarget:self];
        [popover setContentViewController:vc];
    }

    return popover;
}

- (void)closePopover:(id)sender
{
    [popover close];
}

- (void)popoverDidClose:(CPPopover)aPopover
{
    var controller = [popover contentViewController],
        currentLayoutPoint = [controller layoutPoint],
        priority = [controller priority];

    [self setPriority:priority forLayoutPoint:currentLayoutPoint];
    [controller setLayoutPoint:nil];
    [self setNeedsDisplay:YES];
}

- (void)popoverWillShow:(CPPopover)aPopover
{
    var controller = [aPopover contentViewController],
        currentLayoutPoint = [controller layoutPoint],
        priority = [self priorityForLayoutPoint:currentLayoutPoint];

    [controller setPriority:priority];
}

- (void)mouseDown:(CPEvent)theEvent
{
    if ([theEvent type] !== CPLeftMouseDown)
        return;

    if ([theEvent modifierFlags] & CPCommandKeyMask)
    {
        var clickedPoint = [self layoutPointAtLocation:[self convertPointFromBase:[theEvent locationInWindow]]];
        if (clickedPoint)
        {
            [[[self popover] contentViewController] setLayoutPoint:clickedPoint];

            var p = [clickedPoint valueInEngine:nil];
            [[self popover] showRelativeToRect:CGRectMake(p.x-25, p.y-25, 50, 50) ofView:self preferredEdge:1];
        }
    }
    else
    {
        [mouseTracker trackWithEvent:theEvent inView:self withDelegate:self];
    }
}

- (BOOL)mouseTracker:(CPMouseTracker)tracker shouldStartTrackingWithEvent:(CPEvent)anEvent
{
    var locationInWindow = [anEvent locationInWindow];
    trackingPoint = [self layoutPointAtLocation:[self convertPointFromBase:locationInWindow]];

    if (trackingPoint == nil)
        return NO;
/*
    var constraints = [self stayConstraintsForLayoutPoint:trackingPoint];

    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        [aConstraint setPriority:CPLayoutPriorityRequired];
    }];
*/
    currentLocation = locationInWindow;

    return YES;
}

- (BOOL)mouseTracker:(CPMouseTracker)tracker shouldContinueTrackingWithEvent:(CPEvent)anEvent
{
    if (trackingPoint == nil)
        return NO;

    var locationInWindow = [anEvent locationInWindow],
        deltas = @[locationInWindow.x - currentLocation.x, locationInWindow.y - currentLocation.y];

    var constraints = [self stayConstraintsForLayoutPoint:trackingPoint];

    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        var constant = [aConstraint constant] + [deltas objectAtIndex:idx];
        [aConstraint setConstant:constant priority:EDIT_PRIORITY];
    }];

    currentLocation = locationInWindow;

    [[self window] setNeedsLayout];
    [self setNeedsDisplay:YES];

    return YES;
}

- (void)mouseTracker:(CPMouseTracker)tracker didStopTrackingWithEvent:(CPEvent)anEvent
{
    [[self window] layout];
    [self setNeedsDisplay:YES];

    if (trackingPoint)
    {
        [self updateStayConstraints];
        trackingPoint = nil;
    }

    currentLocation = CGPointMakeZero();
}

- (CPLayoutPoint)layoutPointAtLocation:(CGPoint)localEventPoint
{
    var result = nil;
    var points = Array.from(layoutPointToConstraints.keys());

    [points enumerateObjectsUsingBlock:function(point, idx, stop)
    {
        var cgpoint = [point valueInEngine:nil];
        var grabrect = CGRectMake(cgpoint.x - 25, cgpoint.y - 25, 50, 50);

        if (CGRectContainsPoint(grabrect, localEventPoint))
        {
            result = point;
            stop(YES);
        }
    }];

    return result;
}

@end

@implementation ContentViewController : CPViewController
{
    CPLayoutPoint layoutPoint @accessors;
    CPInteger priority @accessors;
    id target @accessors;
}

+ (void)initialize
{
    var transformer = [[CPFloatToIntegerTransformer alloc] init];
    [CPValueTransformer setValueTransformer:transformer forName:@"FloatToInt"];
}

-(id)initWithCibName:(id)aName owner:(id)anOwner
{
    self = [super initWithCibName:aName owner:anOwner];

    priority = 0;
CPLog.debug(_cmd);
    return self;
}

- (void)setPriority:(CPInteger)p
{
    if (priority !== p)
    {
        priority = p;
        CPLog.debug(_cmd + priority);
    }
}

- (void)viewDidLoad
{
    CPLog.debug(_cmd);

    [[self view] setFrame:CGRectMake(0, 0, 290, 42)];
    var slider = [[CPSlider alloc] initWithFrame:CGRectMake(10, 10, 150, 22)];
    [slider setTranslatesAutoresizingMaskIntoConstraints:YES];
    [slider setIdentifier:@"Slider"];
    [slider setContinuous:YES];
    [slider setMaxValue:1000];
    [[self view] addSubview:slider];
    [[self view] setNeedsLayout];

    var textField = [[CPTextField alloc] initWithFrame:CGRectMake(170, 10, 50, 22)];
    [textField setIdentifier:@"TextField"];
    [textField setFont:[CPFont boldSystemFontOfSize:20]];
    [[self view] addSubview:textField];

    var oc = [[CPObjectController alloc] init];
    [oc bind:CPContentBinding toObject:self withKeyPath:@"self" options:nil];
    [textField bind:CPValueBinding toObject:oc withKeyPath:@"selection.priority" options:@{CPValueTransformerNameBindingOption:"FloatToInt"}];
    [slider bind:CPValueBinding toObject:oc withKeyPath:@"selection.priority" options:nil];

    var ok = [[CPButton alloc] initWithFrame:CGRectMake(230, 7, 50, 28)];
    [ok setIdentifier:@"OKButton"];
    [ok setTitle:"OK"];
    [ok setTarget:target];
    [ok setAction:@selector(closePopover:)];
    [[self view] addSubview:ok];
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
    return ROUND(aValue);
}

- (id)reverseTransformedValue:(id)aValue
{
    return aValue;
}

@end
