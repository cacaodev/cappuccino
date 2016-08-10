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

@implementation AppController : CPObject
{
    CPInteger pNum;
    ColorView container;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    [theWindow setAutolayoutEnabled:YES];
    [theWindow orderFront:self];

    pNum = 0;

    container = [[ColorView alloc] initWithFrame:CGRectMakeZero()];
    [container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:container];

    var left = [[container leftAnchor] constraintEqualToAnchor:[contentView leftAnchor] constant:100],
        top  = [[container topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:100],
        right = [[container rightAnchor] constraintEqualToAnchor:[contentView rightAnchor] constant:-100],
        bottom = [[container bottomAnchor] constraintEqualToAnchor:[contentView bottomAnchor] constant:-100];

    [CPLayoutConstraint activateConstraints:@[left, top, right, bottom]];

// Install edges points
    var p1 = [self installLayoutPointEqualToXAnchor:[container leftAnchor] yAnchor:[container topAnchor] inView:container priority:900];
    var p2 = [self installLayoutPointEqualToXAnchor:[container rightAnchor] yAnchor:[container topAnchor] inView:container priority:900];
    var p3 = [self installLayoutPointEqualToXAnchor:[container rightAnchor] yAnchor:[container bottomAnchor] inView:container priority:900];
    var p4 = [self installLayoutPointEqualToXAnchor:[container leftAnchor] yAnchor:[container bottomAnchor] inView:container priority:900];

// Install mid points
    var p5 = [self installLayoutPointEqualToXAnchor:[container centerXAnchor] yAnchor:[container topAnchor] inView:container priority:800];
    var p6 = [self installLayoutPointEqualToXAnchor:[container rightAnchor] yAnchor:[container centerYAnchor] inView:container priority:800];
    var p7 = [self installLayoutPointEqualToXAnchor:[container centerXAnchor] yAnchor:[container bottomAnchor] inView:container priority:800];
    var p8 = [self installLayoutPointEqualToXAnchor:[container leftAnchor] yAnchor:[container centerYAnchor] inView:container priority:800];

// Constrain mid points
    var constraints = @[];
    var midConstraints1 = [p5 constraintsBetweenPoint:p1 andPoint:p2];
    var midConstraints2 = [p6 constraintsBetweenPoint:p2 andPoint:p3];
    var midConstraints3 = [p7 constraintsBetweenPoint:p3 andPoint:p4];
    var midConstraints4 = [p8 constraintsBetweenPoint:p4 andPoint:p1];

    [constraints addObjectsFromArray:midConstraints1];
    [constraints addObjectsFromArray:midConstraints2];
    [constraints addObjectsFromArray:midConstraints3];
    [constraints addObjectsFromArray:midConstraints4];

// Avoid negative distances in quadrilateral
    var cst1 = [[p1 xAxisAnchor] constraintLessThanOrEqualToAnchor:[p2 xAxisAnchor]];
    var cst2 = [[p1 xAxisAnchor] constraintLessThanOrEqualToAnchor:[p3 xAxisAnchor]];
    var cst3 = [[p4 xAxisAnchor] constraintLessThanOrEqualToAnchor:[p2 xAxisAnchor]];
    var cst4 = [[p4 xAxisAnchor] constraintLessThanOrEqualToAnchor:[p3 xAxisAnchor]];

    var cst5 = [[p1 yAxisAnchor] constraintLessThanOrEqualToAnchor:[p3 yAxisAnchor]];
    var cst6 = [[p1 yAxisAnchor] constraintLessThanOrEqualToAnchor:[p4 yAxisAnchor]];
    var cst7 = [[p2 yAxisAnchor] constraintLessThanOrEqualToAnchor:[p3 yAxisAnchor]];
    var cst8 = [[p2 yAxisAnchor] constraintLessThanOrEqualToAnchor:[p4 yAxisAnchor]];

    [constraints addObjectsFromArray:@[cst1, cst2, cst3, cst4, cst5, cst6, cst7, cst8]];

    [CPLayoutConstraint activateConstraints:constraints];

    [theWindow layout];

    CPLog.debug([container _layoutEngine]);
    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

- (id)installLayoutPointEqualToXAnchor:(id)anXAnchor yAnchor:(id)anYAnchor inView:(CPView)aView
{
    return [self installLayoutPointEqualToXAnchor:anXAnchor yAnchor:anYAnchor inView:aView priority:CPLayoutPriorityRequired];
}

- (id)installLayoutPointEqualToXAnchor:(id)anXAnchor yAnchor:(id)anYAnchor inView:(CPView)aView priority:(CPInteger)priority
{
    var idx = pNum++;
    var constantX = [anXAnchor name] == @"left" ? 100 : -100;
    var constantY = [anYAnchor name] == @"top" ? 100 : -100;

    var anchorX = [CPLayoutXAxisAnchor anchorNamed:(@"x"+idx) inItem:aView];
    var anchorY = [CPLayoutYAxisAnchor anchorNamed:(@"y"+idx) inItem:aView];

    var p = [CPLayoutPoint layoutPointWithXAxisAnchor:anchorX yAxisAnchor:anchorY];

    var xConstraint = [anchorX constraintEqualToAnchor:anXAnchor constant:constantX];
    var yConstraint = [anchorY constraintEqualToAnchor:anYAnchor constant:constantY];

    [xConstraint setPriority:priority];
    [yConstraint setPriority:priority];

    var constraints = @[xConstraint, yConstraint];
    [aView setConstraints:constraints forLayoutPoint:p];
    [CPLayoutConstraint activateConstraints:constraints];

    return p;
}

@end

@implementation CPLayoutPoint (Additions)

- (CPArray)constraintsBetweenPoint:(id)p1 andPoint:(id)p2
{
    var distanceX = [CPDistanceLayoutDimension distanceFromAnchor:[p1 xAxisAnchor] toAnchor:[p2 xAxisAnchor]];
    var midAnchorX = [[CPCompositeLayoutXAxisAnchor alloc] initWithAnchor:[p1 xAxisAnchor] plusDimension:distanceX times:0.5 plus:0 name:@"midAnchor"];

    var distanceY = [CPDistanceLayoutDimension distanceFromAnchor:[p1 yAxisAnchor] toAnchor:[p2 yAxisAnchor]];
    var midAnchorY = [[CPCompositeLayoutYAxisAnchor alloc] initWithAnchor:[p1 yAxisAnchor] plusDimension:distanceY times:0.5 plus:0 name:@"midAnchor"];

    var cstX = [[self xAxisAnchor] constraintEqualToAnchor:midAnchorX];
    var cstY = [[self yAxisAnchor] constraintEqualToAnchor:midAnchorY];

    return @[cstX, cstY];
}

@end

@implementation ColorView : CPView
{
    Map layoutPointToConstraints;
    CPMouseTracker mouseTracker;
    CPLayoutPoint trackingPoint;
    CGPoint currentLocation;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    mouseTracker = [[CPMouseTracker alloc] init];
    trackingPoint = nil;
    layoutPointToConstraints = new Map();
    currentLocation = CGPointMakeZero();

    return self;
}

- (void)setConstraints:(CPArray)constraints forLayoutPoint:(id)aLayoutPoint
{
    layoutPointToConstraints.set(aLayoutPoint, constraints);
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [[CPColor redColor] set];

    CGContextFillRect(ctx, [self bounds]);

    var blue = [CPColor blackColor],
        orange = [CPColor blueColor];

    [blue setStroke];
    var path = [CPBezierPath bezierPath];
    [path setLineWidth:3];

    var points = Array.from(layoutPointToConstraints.keys());

    [points enumerateObjectsUsingBlock:function(point, idx, stop)
    {
        var p = [point valueInItem:self];
        var color = (point == trackingPoint) ? orange : blue;
        [color setFill];

        [[CPBezierPath bezierPathWithOvalInRect:CGRectMake(p.x - 25, p.y - 25, 50, 50)] fill];

        if (idx % 4 == 0)
            [path moveToPoint:p];

        if (idx % 4 == 3)
        {
            [path lineToPoint:p];
            [path closePath];
            [path stroke];
        }
        else
            [path lineToPoint:p];
    }];
}

- (void)mouseDown:(CPEvent)theEvent
{
    if ([theEvent type] == CPLeftMouseDown)
        [mouseTracker trackWithEvent:theEvent inView:self withDelegate:self];
}

- (BOOL)mouseTracker:(CPMouseTracker)tracker shouldStartTrackingWithEvent:(CPEvent)anEvent
{
    var locationInWindow = [anEvent locationInWindow];
    trackingPoint = [self layoutPointAtLocation:locationInWindow];

    if (trackingPoint == nil)
        return NO;

    currentLocation = locationInWindow;

    return YES;
}

- (BOOL)mouseTracker:(CPMouseTracker)tracker shouldContinueTrackingWithEvent:(CPEvent)anEvent
{
    if (trackingPoint == nil)
        return NO;

    var constraints = layoutPointToConstraints.get(trackingPoint);

    var locationInWindow = [anEvent locationInWindow],
        deltaX = locationInWindow.x - currentLocation.x,
        deltaY = locationInWindow.y - currentLocation.y;

    var xcst = [constraints objectAtIndex:0],
        ycst = [constraints objectAtIndex:1];

// CPLog.debug("delta x=" + deltaX + " y=" + deltaY);
    [constraints makeObjectsPerformSelector:@selector(setPriority:) withObject:990];
    [xcst setConstant:[xcst constant] + deltaX];
    [ycst setConstant:[ycst constant] + deltaY];

    currentLocation = locationInWindow;

    //[[self _layoutEngine] solve];
    [[self window] setNeedsLayout];
    [self setNeedsDisplay:YES];

    return YES;
}

- (void)mouseTracker:(CPMouseTracker)tracker didStopTrackingWithEvent:(CPEvent)anEvent
{
    if (trackingPoint)
    {
        var constraints = layoutPointToConstraints.get(trackingPoint);
        [constraints makeObjectsPerformSelector:@selector(setPriority:) withObject:900];
        trackingPoint = nil;
    }

    currentLocation = CGPointMakeZero();
    [self setNeedsDisplay:YES];
}

- (CPLayoutPoint)layoutPointAtLocation:(CGPoint)eventPoint
{
    var result = nil;
    var localEventPoint = [self convertPointFromBase:eventPoint];
    var points = Array.from(layoutPointToConstraints.keys());

    [points enumerateObjectsUsingBlock:function(point, idx, stop)
    {
        var cgpoint = [point valueInItem:self];
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
