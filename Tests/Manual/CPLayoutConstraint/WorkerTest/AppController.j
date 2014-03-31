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

@implementation CPPopUpButtonBaseline : CPPopUpButton

- (float)baselineOffsetFromBottom
{
    return 4;
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // Uncomment to disable Web Worker
    //[CPLayoutConstraint setAllowsWebWorker:NO];
}

@end
