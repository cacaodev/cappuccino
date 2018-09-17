/*
 * AppController.j
 * QuadrilateralDemo
 *
 * Created by cacaodev on August 4, 2016.
 * Copyright 2016.
 *
 * Based on the original QuadrilateralDemo by Greg J. Badros
 * Refactored and optimized by Alex Russell
 * http://infrequently.org/12/txjs/demos/cassowary/demos/quad/quaddemo.html
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
@import <AppKit/CPObjectController.j>

@import "CPMouseTracker.j"

var EDIT_PRIORITY = 490;

@implementation AppController : CPObject
{
    CPView container;
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

    container = [[ColorView alloc] initWithFrame:CGRectMakeZero()];
    [container setIdentifier:@"container"];
    [container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:container];

    var tf = [[CPTextField alloc] initWithFrame:CGRectMake(50, 10, 1200, 50)];
    [tf setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tf setFont:[CPFont boldSystemFontOfSize:16]];
    [tf setTextColor:[CPColor grayColor]];
    [tf setStringValue:@"Right click on a point to edit the priority of its constrained coordinates."];
    [contentView addSubview:tf];

    var tfCenter = [[tf centerXAnchor] constraintEqualToAnchor:[container centerXAnchor]],
        tfBottom = [[tf topAnchor] constraintEqualToAnchor:[container bottomAnchor] constant:10];
    [CPLayoutConstraint activateConstraints:@[tfCenter, tfBottom]];

// Add constraints for the container view
    var left = [[container leftAnchor] constraintEqualToAnchor:[contentView leftAnchor] constant:50],
        top  = [[container topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:50],
        right = [[container rightAnchor] constraintEqualToAnchor:[contentView rightAnchor] constant:-50],
        bottom = [[container bottomAnchor] constraintEqualToAnchor:[contentView bottomAnchor] constant:-50];

    [CPLayoutConstraint activateConstraints:@[left, top, right, bottom]];

// Install edges points
    var p1 = [self installLayoutPointAtLocation:CGPointMake(0, 0) inView:container priority:400];
    var p2 = [self installLayoutPointAtLocation:CGPointMake(2000, 0) inView:container priority:410];
    var p3 = [self installLayoutPointAtLocation:CGPointMake(2000, 1000) inView:container priority:420];
    var p4 = [self installLayoutPointAtLocation:CGPointMake(0, 1000) inView:container priority:430];

// Install mid points
    var p5 = [self installLayoutPointAtLocation:CGPointMakeZero() inView:container priority:250];
    var p6 = [self installLayoutPointAtLocation:CGPointMakeZero() inView:container priority:250];
    var p7 = [self installLayoutPointAtLocation:CGPointMakeZero() inView:container priority:250];
    var p8 = [self installLayoutPointAtLocation:CGPointMakeZero() inView:container priority:250];

// Constrain mid points
    var midConstraints1 = [p5 constraintsBetweenPoint:p1 andPoint:p2];
    var midConstraints2 = [p6 constraintsBetweenPoint:p2 andPoint:p3];
    var midConstraints3 = [p7 constraintsBetweenPoint:p3 andPoint:p4];
    var midConstraints4 = [p8 constraintsBetweenPoint:p4 andPoint:p1];

    [constraints addObjectsFromArray:midConstraints1];
    [constraints addObjectsFromArray:midConstraints2];
    [constraints addObjectsFromArray:midConstraints3];
    [constraints addObjectsFromArray:midConstraints4];

// Constrain edge points inside the box
    var withinContainerConstraint1 = [p1 constraintsContainingWithinView:container];
    var withinContainerConstraint2 = [p2 constraintsContainingWithinView:container];
    var withinContainerConstraint3 = [p3 constraintsContainingWithinView:container];
    var withinContainerConstraint4 = [p4 constraintsContainingWithinView:container];

    [constraints addObjectsFromArray:withinContainerConstraint1];
    [constraints addObjectsFromArray:withinContainerConstraint2];
    [constraints addObjectsFromArray:withinContainerConstraint3];
    [constraints addObjectsFromArray:withinContainerConstraint4];

// Activate the Quadrilateral constraints
    [CPLayoutConstraint activateConstraints:constraints];
    [theWindow orderFront:self];

 //   CPLog.debug([container _layoutEngine]);
}

- (id)installLayoutPointAtLocation:(CPPoint)aLocation inView:(CPView)aView priority:(CPInteger)priority
{
    var layoutPoint = [[LayoutPoint alloc] initAtLocation:aLocation priority:priority owner:aView];
    [layoutPoint setDelegate:self];
    [[aView layoutPoints] addObject:layoutPoint];

    var stayConstraints = [layoutPoint constraints];
    [CPLayoutConstraint activateConstraints:stayConstraints];

    return layoutPoint;
}


- (void)engine:(CPLayoutConstraintEngine)anEngine didChangeAnchor:(CPLayoutAnchor)anAnchor
{
    //var p = [container layoutPointContainingAnchor:anAnchor];
    //[p setMoving:[[container mouseTracker] isTracking]];
    [container setNeedsDisplay:YES];
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
    var cst1 = [[self xAxisAnchor] constraintGreaterThanOrEqualToConstant:25];
    var cst2 = [[self yAxisAnchor] constraintGreaterThanOrEqualToConstant:25];
    var maxXAnchor = [[aView widthAnchor] anchorByAddingConstant:-25];
    var cst3 = [[self xAxisAnchor] constraintLessThanOrEqualToAnchor:maxXAnchor];
    var maxYAnchor = [[aView heightAnchor] anchorByAddingConstant:-25];
    var cst4 = [[self yAxisAnchor] constraintLessThanOrEqualToAnchor:maxYAnchor];

    return @[cst1, cst2, cst3, cst4];
}

@end

var pNum;
@implementation LayoutPoint : CPLayoutPoint
{
    CPArray   xConstraint;
    CPArray   yConstraint;
    CPInteger initialPriority @accessors;
//    BOOL      moving          @accessors;
}

+ (void)initialize
{
    pNum = 0;
}

- (id)initAtLocation:(CGPoint)aLocation priority:(CPInteger)aPriority owner:(id)owner
{
    var idx = pNum++;
    var anchorX = [CPLayoutXAxisAnchor anchorNamed:(@"x"+idx) inItem:owner];
    var anchorY = [CPLayoutYAxisAnchor anchorNamed:(@"y"+idx) inItem:owner];

    self = [super initWithXAxisAnchor:anchorX yAxisAnchor:anchorY];

    xConstraint = [anchorX constraintEqualToConstant:aLocation.x];
    yConstraint = [anchorY constraintEqualToConstant:aLocation.y];
    [xConstraint setPriority:aPriority];
    [yConstraint setPriority:aPriority];

    initialPriority = aPriority;
//    moving = NO;

    return self;
}

- (void)setInitialPriority:(CPInteger)p
{
    if (initialPriority !== p)
    {
        initialPriority = p;
        [self setPriority:p];
    }
}

- (CGPoint)location
{
    return [self valueInEngine:nil];
}

- (CPArray)constraints
{
    return @[xConstraint, yConstraint];
}

- (void)resetStayConstraints
{
    var location = [self location];
    [xConstraint setConstant:location.x];
    [yConstraint setConstant:location.y];
}

- (void)suggestLocation:(CGPoint)aLocation
{
    [xConstraint setConstant:aLocation.x];
    [yConstraint setConstant:aLocation.y];
}

- (void)moveByOffset:(CGPoint)anOffset
{
    [xConstraint setConstant:[xConstraint constant] + anOffset.x];
    [yConstraint setConstant:[yConstraint constant] + anOffset.y];
}

- (void)resetPriority
{
    [xConstraint setPriority:initialPriority];
    [yConstraint setPriority:initialPriority];
}

- (void)setPriority:(CPInteger)aPriority
{
    [xConstraint setPriority:aPriority];
    [yConstraint setPriority:aPriority];
}

@end

@implementation ColorView : CPView
{
    CPColor         fillColor;
    CPArray         layoutPoints @accessors(readonly);
    CPMouseTracker  mouseTracker;
    CPLayoutPoint   trackingPoint;
    CGPoint         currentLocation;

    CPPopover       popover;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    fillColor = [CPColor randomColor];
    mouseTracker = [[CPMouseTracker alloc] init];
    layoutPoints = [CPArray array];

    currentLocation = CGPointMakeZero();
    trackingPoint = nil;
    popover = nil;

    return self;
}

- (void)drawString:(CPString)aString inRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];

    CGContextSelectFont(ctx, [CPFont boldSystemFontOfSize:20]);
    var metrics = ctx.measureText(aString);
    CGContextShowTextAtPoint(ctx, CGRectGetMinX(aRect) + (CGRectGetWidth(aRect) - metrics.width)/2, CGRectGetMaxY(aRect) -  (CGRectGetHeight(aRect))/2, aString);
}
/*
- (CPLayoutPoint)layoutPointContainingAnchor:(CPLayoutAnchor)anAnchor
{
    var idx = [layoutPoints indexOfObjectPassingTest:function(point, idx)
    {
        return [point xAxisAnchor] == anAnchor || [point yAxisAnchor] == anAnchor;
    }];

    if (idx !== CPNotFound)
        return [layoutPoints objectAtIndex:idx];

    return nil;
}
*/
- (void)drawGridInRect:(CGRect)aRect context:(CGContext)aContext
{
    var x = 0;
    var y = 0;
    var maxY = CGRectGetHeight(aRect);
    var maxX = CGRectGetWidth(aRect);
    var p = [CPBezierPath bezierPath];
    while(x < maxX)
    {
        [p moveToPoint:CGPointMake(x, 0)];
        [p lineToPoint:CGPointMake(x, maxY)];
        x += 100;
    }

    while(y < maxY)
    {
        [p moveToPoint:CGPointMake(0, y)];
        [p lineToPoint:CGPointMake(maxX, y)];
        y += 100;
    }

    [[CPColor grayColor] setStroke];
    [p stroke];
}

- (void)drawRect:(CGRect)aRect
{
    // Please, do not look at the drawing code, it's really quick & dirty.
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [fillColor set];
    CGContextFillRect(ctx, [self bounds]);

    [self drawGridInRect:[self bounds] context:ctx];

    var normal = [CPColor blackColor],
        selected = [CPColor blueColor];
//        moving = [CPColor lightGrayColor];

    var path = [CPBezierPath bezierPath];
    var rectanglePath = [CPBezierPath bezierPath];
    [path setLineWidth:3];
    [rectanglePath setLineWidth:2];

    [layoutPoints enumerateObjectsUsingBlock:function(point, idx, stop)
    {
        var p = [point location];

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

    [normal setStroke];

    [[CPColor colorWithWhite:0.5 alpha:0.2] setFill];
    [rectanglePath fill];

    [rectanglePath stroke];
    [path stroke];

    [layoutPoints enumerateObjectsUsingBlock:function(point, idx, stop)
    {
        var isSelected = (point == trackingPoint);
        //var color =  isSelected ? selected : (([point moving]) ? moving : normal);
        var color =  isSelected ? selected : normal;

        var p = [point location];
        var rect = CGRectMake(p.x - 25, p.y - 25, 50, 50);
        var ovalPath = [CPBezierPath bezierPathWithOvalInRect:rect];

        [color setFill];
        [ovalPath fill];

        var priority = isSelected ? EDIT_PRIORITY : [point initialPriority];
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

    [currentLayoutPoint setInitialPriority:priority];
    [controller setLayoutPoint:nil];
    [self setNeedsDisplay:YES];
    // FIXME/ Why is this necessary ? Is it a problem with CPPopover ?
    [[CPRunLoop currentRunLoop] performSelectors];
}

- (void)popoverWillShow:(CPPopover)aPopover
{
    var controller = [aPopover contentViewController],
        currentLayoutPoint = [controller layoutPoint],
        priority = [currentLayoutPoint initialPriority];

    [controller setPriority:priority];
}

- (void)rightMouseDown:(CPEvent)theEvent
{
    if ([theEvent type] !== CPRightMouseDown)
        return;

    var clickedPoint = [self layoutPointAtLocation:[self convertPointFromBase:[theEvent locationInWindow]]];

    if (clickedPoint)
    {
        [[[self popover] contentViewController] setLayoutPoint:clickedPoint];

        var p = [clickedPoint location];
        [[self popover] showRelativeToRect:CGRectMake(p.x-25, p.y-25, 50, 50) ofView:self preferredEdge:1];
    }
}

- (void)mouseDown:(CPEvent)theEvent
{
    if ([theEvent type] !== CPLeftMouseDown)
        return;

    if ([theEvent modifierFlags] & CPControlKeyMask)
    {
        [self rightMouseDown:theEvent];
    }
    else if ([theEvent modifierFlags] & CPCommandKeyMask)
    {
        CPLog.debug("ContentView\n" + [[[self superview] constraints] description]);
        CPLog.debug("\n\nContainer\n" + [[self constraints] description]);
        CPLog.debug("\n\nContainer\n" + [[[self constraints] arrayByApplyingBlock:function(cst){ return [cst _engineConstraints].toString();}] componentsJoinedByString:@"\n"]);
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

    [trackingPoint setPriority:EDIT_PRIORITY];
    currentLocation = locationInWindow;

    return YES;
}

- (BOOL)mouseTracker:(CPMouseTracker)tracker shouldContinueTrackingWithEvent:(CPEvent)anEvent
{
    if (trackingPoint == nil)
        return NO;

    var locationInWindow = [anEvent locationInWindow],
        moveOffset = CGPointMake(locationInWindow.x - currentLocation.x, locationInWindow.y - currentLocation.y);

    [trackingPoint moveByOffset:moveOffset];
    currentLocation = locationInWindow;

    [[self window] setNeedsLayout];
    //[self setNeedsDisplay:YES];

    return YES;
}

- (void)mouseTracker:(CPMouseTracker)tracker didStopTrackingWithEvent:(CPEvent)anEvent
{
    [layoutPoints enumerateObjectsUsingBlock:function(point, idx, stop)
    {
        [point resetStayConstraints];
        //[point setMoving:NO];
    }];

    if (trackingPoint)
    {
        [trackingPoint resetPriority];
        trackingPoint = nil;
    }

    [[self window] setNeedsLayout];
    [self setNeedsDisplay:YES];

    currentLocation = CGPointMakeZero();
}

- (CPLayoutPoint)layoutPointAtLocation:(CGPoint)localEventPoint
{
    var idx = [layoutPoints indexOfObjectPassingTest:function(point, idx, stop)
    {
        var location = [point location],
            grabrect = CGRectMake(location.x - 25, location.y - 25, 50, 50);

        return CGRectContainsPoint(grabrect, localEventPoint);
    }];

    return (idx !== CPNotFound) ? [layoutPoints objectAtIndex:idx] : nil;
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
