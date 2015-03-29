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
    @outlet CPWindow           theWindow;
    @outlet CPSegmentedControl segmentedControl;
    @outlet CPTabView          tabView;
    @outlet CPButton           button;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
    [self insertItem:0];
    [self insertItem:1];
    [self insertItem:2];
    [tabView selectTabViewItemAtIndex:0];
}

- (void)awakeFromCib
{

    [theWindow setFullPlatformWindow:YES];
}

- (void)insertItem:(int)n
{
    var item = [[CPTabViewItem alloc] initWithIdentifier:@"Item" + n];
    [item setLabel:@"Item"+n];

    var view = [[CPView alloc] initWithFrame:[[tabView _box] bounds]];
    [view setBackgroundColor:[CPColor randomColor]];

    var tvbutton = [[CPButton alloc] initWithFrame:CGRectMakeZero()];
    [tvbutton setTitle:@"Item"+n];
    [tvbutton sizeToFit];
    [view addSubview:tvbutton];
    [tvbutton setFrameOrigin:CGPointMake(100 + 50*n, 50)];

    var animIn = [CABasicAnimation animationWithKeyPath:@"alphaValue"];
    [animIn setFromValue:0];
    [animIn setToValue:1];
    [animIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    var animOut = [CABasicAnimation animationWithKeyPath:@"alphaValue"];
    [animOut setFromValue:1];
    [animOut setToValue:0];
    [animOut setDuration:0.5];

    [view setAnimations:@{"CPAnimationTriggerOrderOut":animOut, "CPAnimationTriggerOrderIn":animIn}];

    [item setView:view];

    [tabView addTabViewItem:item];
}

- (@action)selectSegment:(id)sender
{
    var segment = [sender intValue];

    [[CPAnimationContext currentContext] setDuration:0.3];
    [[segmentedControl animator] setSelectedSegment:segment];
}

- (@action)selectTabViewItemIndex:(id)sender
{
    var idx = [sender intValue];

    [[CPAnimationContext currentContext] setDuration:2];
    [[tabView animator] selectTabViewItemAtIndex:idx];
}

- (@action)setButtonTextColor:(id)sender
{
    [[CPAnimationContext currentContext] setDuration:1];
    [[button animator] setTextColor:[sender color]];
}

- (@action)setButtonFont:(id)sender
{
    [[CPAnimationContext currentContext] setDuration:0.5];
    [[button animator] setFontSize:[sender floatValue]];
}

@end
