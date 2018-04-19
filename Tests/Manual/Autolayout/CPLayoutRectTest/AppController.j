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
    @outlet CPWindow    theWindow;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var contentView = [theWindow contentView];

    var contentViewLayoutRect = [contentView layoutRect],
        visibleLayoutRect = [[contentView layoutRectangle] layoutRectByInsettingWithConstant:-100],
        constraints = [contentViewLayoutRect constraintsEqualToLayoutRect:visibleLayoutRect];

    [CPLayoutConstraint activateConstraints:constraints];
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [[theWindow contentView] setTranslatesAutoresizingMaskIntoConstraints:YES];
    [theWindow setFullPlatformWindow:NO];
}

@end

@implementation ColorView : CPView
{
    CPColor color;
    CPLayoutRect layoutRectangle @accessors;
}

- (id)viewDidMoveToWindow
{
    color = [CPColor randomColor];
    layoutRectangle = [CPLayoutRect layoutRectWithName:@"rectangle" inItem:self];
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [color set];
    CGContextFillRect(ctx, [self bounds]);

    [[CPColor grayColor] set];
    CGContextSetLineWidth(ctx, 2);
    var constrainedRect = [layoutRectangle valueInEngine:nil];

    [[CPBezierPath bezierPathWithOvalInRect:constrainedRect] stroke];
    [[CPBezierPath bezierPathWithRect:constrainedRect] stroke];
}

- (void)mouseDown:(CPEvent)anEvent
{
    CPLog.debug("ContentView\n" + [[[[self window] contentView] constraints] description]);
}

@end
