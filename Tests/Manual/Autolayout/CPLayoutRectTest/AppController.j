/*
 * AppController.j
 * CPLayoutRectTest
 *
 * Created by You on September 10, 2016.
 * Copyright 2016, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

CPLogRegister(CPLogConsole);

@implementation AppController : CPObject
{
    @outlet CPWindow theWindow;
    CPView contentView;
    CPLayoutRect drawingRectangle @accessors;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    drawingRectangle = [CPLayoutRect layoutRectWithName:@"rectangle" inItem:contentView];
    [drawingRectangle setDelegate:self];

    var constraints = [[contentView layoutRect] constraintsEqualToLayoutRect:[drawingRectangle layoutRectByInsettingWithConstant:-100]];
    [CPLayoutConstraint activateConstraints:constraints];
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    contentView = [theWindow contentView];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [theWindow setFullPlatformWindow:NO];
}

- (void)engine:(CPLayoutConstraintEngine)anEngine didChangeAnchor:(CPLayoutAnchor)anAnchor
{
    CPLog.debug([anAnchor name]);
}

@end

@implementation ColorView : CPView
{
    CPColor color;
}

- (id)viewDidMoveToWindow
{
    color = [CPColor randomColor];
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [color set];
    CGContextFillRect(ctx, [self bounds]);

    [[CPColor blackColor] set];
    CGContextSetLineWidth(ctx, 3);
    var rect = [[[CPApp delegate] drawingRectangle] valueInEngine:nil];

    [[CPBezierPath bezierPathWithOvalInRect:rect] stroke];
    [[CPBezierPath bezierPathWithRect:rect] stroke];
/*
    var wpath = [CPBezierPath bezierPath];
    [wpath moveToPoint:rect.origin];
    [wpath lineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    [wpath moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    [wpath lineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [wpath stroke];

    var hpath = [CPBezierPath bezierPath];
    [hpath moveToPoint:rect.origin];
    [hpath lineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    [hpath moveToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    [hpath lineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [hpath stroke];
*/
}

- (void)mouseDown:(CPEvent)anEvent
{
    CPLog.debug("ContentView\n" + [[[[self window] contentView] constraints] description]);
}

@end
