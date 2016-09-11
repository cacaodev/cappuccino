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
    CPLayoutRect insideLayoutRect @accessors;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var contentView = [theWindow contentView],
        contentLayoutRect = [CPLayoutRect layoutRectWithLeadingAnchor:[contentView leadingAnchor] topAnchor:[contentView topAnchor] widthAnchor:[contentView widthAnchor] heightAnchor:[contentView heightAnchor]],
        insetLayoutRect = [contentLayoutRect layoutRectByInsettingTop:50 leading:100 bottom:-50 trailing:-100];

    insideLayoutRect = [CPLayoutRect layoutRectWithAnchorsNamed:@["x", "y", "w", "h"] inItem:contentView];
    var constraints = [insideLayoutRect constraintsEqualToLayoutRect:insetLayoutRect];

    [CPLayoutConstraint activateConstraints:constraints];
    [theWindow layout];
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setAutolayoutEnabled:YES];
    [theWindow setFullPlatformWindow:NO];
}

@end


@implementation ColorView : CPView
{
    CPColor color;
}

- (void)awakeFromCib
{
    color = [CPColor randomColor];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [color set];
    CGContextFillRect(ctx, [self bounds]);

    [[CPColor blackColor] set];
    var insideLayoutRect = [[CPApp delegate] insideLayoutRect],
        constrainedRect = [insideLayoutRect valueInItem:self];

    [[CPBezierPath bezierPathWithOvalInRect:constrainedRect] stroke];
    [[CPBezierPath bezierPathWithRect:constrainedRect] stroke];
}

@end

@implementation CPLayoutRect (Blurp)

+ (CPLayoutRect)layoutRectWithAnchorsNamed:(CPArray)names inItem:(id)anItem
{
    return [CPLayoutRect layoutRectWithLeadingAnchor:[CPLayoutXAxisAnchor anchorNamed:[names objectAtIndex:0] inItem:anItem] topAnchor:[CPLayoutYAxisAnchor anchorNamed:[names objectAtIndex:1] inItem:anItem] widthAnchor:[CPLayoutDimension anchorNamed:[names objectAtIndex:2] inItem:anItem] heightAnchor:[CPLayoutDimension anchorNamed:[names objectAtIndex:3] inItem:anItem]];
}

@end
