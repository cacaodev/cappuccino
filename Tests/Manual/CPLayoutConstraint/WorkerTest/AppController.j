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

@implementation ConstraintView : CPView

- (void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent type] !== CPLeftMouseDown)
        return;
    var flags = [anEvent modifierFlags];

    if (flags & CPCommandKeyMask)
    {
        CPLog.debug([self identifier] + " " + CPStringFromRect([self frame]));
        CPLog.debug([[[self window] _layoutEngine] getInfo]);
    }

    if (flags & CPShiftKeyMask)
    {
        CPLog.debug([[[self window] _layoutEngine] sendCommand:"getconstraints" withArguments:null]);
    }
}


@end

@implementation ColorView : ConstraintView

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
    return 4.0;
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // Uncomment to disable Web Worker
    //[CPLayoutConstraintEngine setAllowsWebWorker:NO];
    [theWindow layout];
}

@end
