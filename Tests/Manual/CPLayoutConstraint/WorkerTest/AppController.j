/*
 * AppController.j
 * WorkerTest
 *
 * Created by You on May 13, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

#define ALLOW_CLASS_OVERRIDE

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
//@import "CPLayoutConstraintEngine.j"

CPLogRegister(CPLogConsole);

@implementation ColorView : CPView

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [[CPColor redColor] set];

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
}

@end
