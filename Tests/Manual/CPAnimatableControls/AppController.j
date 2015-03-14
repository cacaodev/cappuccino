/*
 * AppController.j
 * CPAnimatableControls
 *
 * Created by You on March 4, 2015.
 * Copyright 2015, Your Company All rights reserved.
 */
CPLogRegister(CPLogConsole);
@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
@class CPAnimationContext

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
    @outlet CPSegmentedControl segmentedControl;
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

- (@action)select:(id)sender
{
    var segment = [sender intValue];

    [[CPAnimationContext currentContext] setDuration:0.3];
    [[segmentedControl animator] setSelected:YES forSegment:segment];
}

@end
