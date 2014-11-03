/*
 * AppController.j
 * null
 *
 * Created by You on November 3, 2014.
 * Copyright 2014, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation ColorView : CPView
{
    CPColor color;
}

- (void)viewDidMoveToSuperview
{
    var identifier = [self identifier];

    if (identifier)
    {
        var selColor = CPSelectorFromString(identifier);

        if ([CPColor respondsToSelector:selColor])
            color = [CPColor performSelector:selColor];
    }

    [self setNeedsDisplay:YES];
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [color set];

    CGContextFillRect(ctx, [self bounds]);
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:NO];
}

@end
