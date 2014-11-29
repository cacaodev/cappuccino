/*
 * AppController.j
 * ControlIntrinsicContentSize
 *
 * Created by You on November 16, 2014.
 * Copyright 2014, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

CPLogRegister(CPLogConsole);

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
    CPArray urls @accessors;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    [self setUrls:@[@{"name":"Regular", "url":"Resources/cappuccino.png"}, @{"name":"Regular (same size)", "url":"Resources/cappuccino2.png"}, @{"name":"Small", "url":"Resources/cappuccino-small.png"}, @{"name":"Big", "url":"Resources/cappuccino-big.png"}]];
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
