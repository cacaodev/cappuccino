/*
 * AppController.j
 * CPStackViewNibTest
 *
 * Created by You on September 23, 2016.
 * Copyright 2016, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation StackView : CPStackView
{
}

- (void)drawRect:(CGRect)aRect
{
    [super drawRect:aRect];

    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [[CPColor blackColor] set];
    CGContextSetLineWidth(ctx, 3);
    CGContextStrokeRect(ctx, [self bounds]);
}

- (void)mouseDown:(CPEvent)anEvent
{
    CPLog.debug("StackView\n" + [[self constraints] description]);
    CPLog.debug("WindowView\n" + [[[[self window] _windowView] constraints] description]);
    CPLog.debug("ContentView\n" + [[[[self window] contentView] constraints] description]);
    [[self views] enumerateObjectsUsingBlock:function(aView, idx, stop)
    {
        CPLog.debug([aView identifier] + "\n" + [[aView constraints] description]);
    }];
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
    @outlet StackView   stackView;
    @outlet StackView   stackBellow;
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

- (IBAction)setDistribution:(id)sender
{
    var dist = [sender selectedSegment];
    [stackView setDistribution:dist];
    [stackBellow setDistribution:dist];

    [theWindow setNeedsLayout];
}

- (IBAction)setContentHuggingPriority:(id)sender
{
    var view = [[stackView views] objectAtIndex:[sender tag]],
        value = [sender intValue];

    [view setContentHuggingPriority:value forOrientation:[stackView orientation]];
    [view invalidateIntrinsicContentSize];
}

- (IBAction)setContentCompressionResistancePriority:(id)sender
{
    var view = [[stackView views] objectAtIndex:[sender tag]],
        value = [sender intValue];

    [view setContentCompressionResistancePriority:value forOrientation:[stackView orientation]];
    [view invalidateIntrinsicContentSize];
}

@end
