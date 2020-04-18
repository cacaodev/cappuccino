/*
 * AppController.j
 * CPSplitView
 *
 * Created by You on April 12, 2017.
 * Copyright 2017, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

CPLogRegister(CPLogConsole);

@class SplitView

@implementation AppController : CPObject
{
    SplitView splitView @accessors;
    CPLayoutConstraint splitViewRight;
    CPPopover priorityPopover;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(100,100,1000,500) styleMask:CPTitledWindowMask|CPResizableWindowMask|CPClosableWindowMask],
        contentView = [theWindow contentView];
    [theWindow setTitle:[CPDate date]];
    [contentView setIdentifier:@"contentView"];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];

    var slider = [[CPSlider alloc] initWithFrame:CGRectMake(10, 10, 100, 32)];
    [slider setDoubleValue:5];
    [slider setTarget:self];
    [slider setAction:@selector(_setDividerThickness:)];
    [contentView addSubview:slider];

    var segmented = [[CPSegmentedControl alloc] initWithFrame:CGRectMake(120, 10, 100, 32)];
    [segmented setSegmentCount:2];
    [segmented setSelectedSegment:1];
    [segmented setLabel:@"Horizontal" forSegment:0];
    [segmented setLabel:@"Vertical" forSegment:1];
    [segmented setTarget:self];
    [segmented setAction:@selector(_setvertical:)];
    [contentView addSubview:segmented];

    var button = [[CPButton alloc] initWithFrame:CGRectMake(250, 10, 150, 26)];
    [button setTitle:"Set Divider Position:"];
    [button setTarget:self];
    [button setAction:@selector(setPosition:)];
    [contentView addSubview:button];

    var addSubview = [[CPButton alloc] initWithFrame:CGRectMake(410, 10, 120, 26)];
    [addSubview setTitle:"Add Subview"];
    [addSubview setTarget:self];
    [addSubview setAction:@selector(addSubview:)];
    [contentView addSubview:addSubview];

    var removeSubview = [[CPButton alloc] initWithFrame:CGRectMake(540, 10, 150, 26)];
    [removeSubview setTitle:"Remove Last Subview"];
    [removeSubview setTarget:self];
    [removeSubview setAction:@selector(removeSubview:)];
    [contentView addSubview:removeSubview];

    var wider = [[CPButton alloc] initWithFrame:CGRectMake(700, 10, 150, 26)];
    [wider setButtonType:CPOnOffButton];
    [wider setTitle:"Change SplitView width"];
    [wider setTarget:self];
    [wider setAction:@selector(wider:)];
    [contentView addSubview:wider];

    splitView = [[SplitView alloc] initWithFrame:CGRectMakeZero()];
    [splitView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [splitView setValue:5 forThemeAttribute:@"divider-thickness"];
    [splitView setIsPaneSplitter:YES];
    [splitView setDelegate:self];
    [splitView setIdentifier:@"SplitView"];
    [splitView setNeedsDisplay:YES];

    var left = [[splitView leftAnchor] constraintEqualToAnchor:[contentView leftAnchor] constant:50];
    splitViewRight = [[splitView rightAnchor] constraintEqualToAnchor:[contentView rightAnchor] constant:-200];
    var top = [[splitView topAnchor] constraintEqualToAnchor:[slider bottomAnchor] constant:10];
    var bottom = [[splitView bottomAnchor] constraintEqualToAnchor:[contentView bottomAnchor] constant:-50];

    [contentView addSubview:splitView];
    [CPLayoutConstraint activateConstraints:@[left, splitViewRight, top, bottom]];

    [theWindow orderFront:self];
}

- (void)priorityPopover
{
    if (!priorityPopover)
    {
        priorityPopover = [[CPPopover alloc] init];
        [priorityPopover setDelegate:self];
        var controller = [[PopoverController alloc] init];
        [priorityPopover setContentViewController:controller];
    }

    return priorityPopover;
}

- (void)wider:(id)sender
{
    [splitViewRight setConstant:[sender state]?-50:-200];
    [[splitView window] setNeedsLayout];
}

- (void)addSubview:(id)sender
{
    var aView = [[ColorView alloc] initWithFrame:CGRectMakeZero()];
    [aView setIntrinsicSize:CGSizeMake(100, -1)];
    //[aView setContentCompressionResistancePriority:1 forOrientation:0];
    //[aView setContentHuggingPriority:1 forOrientation:0];
    [aView setIdentifier:@"view" + [[splitView subviews] count]];

    var antiCompLabel = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    [antiCompLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [antiCompLabel setStringValue:@"Anti Compression"];

    var antiCompSlider = [[CPSlider alloc] initWithFrame:CGRectMakeZero()];
    [antiCompSlider setIdentifier:@"Anti Compression"];
    [antiCompSlider setTag:1];
    [antiCompSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [antiCompSlider setMinValue:0];
    [antiCompSlider setMaxValue:1000];
    [antiCompSlider setDoubleValue:1];
    [antiCompSlider setContinuous:YES];
    [antiCompSlider setTarget:self];
    [antiCompSlider setAction:@selector(priorityAction:)];

    var huggingLabel = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    [huggingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [huggingLabel setStringValue:@"Hugging"];

    var huggingSlider = [[CPSlider alloc] initWithFrame:CGRectMakeZero()];
    [huggingSlider setIdentifier:@"Hugging"];
    [huggingSlider setTag:2];
    [huggingSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [huggingSlider setMinValue:0];
    [huggingSlider setMaxValue:1000];
    [huggingSlider setDoubleValue:1];
    [huggingSlider setContinuous:YES];
    [huggingSlider setTarget:self];
    [huggingSlider setAction:@selector(priorityAction:)];

    var holdingLabel = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    [holdingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [holdingLabel setStringValue:@"Holding"];

    var holdingSlider = [[CPSlider alloc] initWithFrame:CGRectMakeZero()];
    [holdingSlider setIdentifier:@"Holding"];
    [holdingSlider setTag:3];
    [holdingSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [holdingSlider setMinValue:0];
    [holdingSlider setMaxValue:1000];
    [holdingSlider setDoubleValue:1];
    [holdingSlider setContinuous:YES];
    [holdingSlider setTarget:self];
    [holdingSlider setAction:@selector(priorityAction:)];

    [aView addSubview:antiCompLabel];
    [aView addSubview:huggingLabel];
    [aView addSubview:holdingLabel];

    [aView addSubview:antiCompSlider];
    [aView addSubview:huggingSlider];
    [aView addSubview:holdingSlider];

    var label1CenterX = [[antiCompSlider centerXAnchor] constraintEqualToAnchor:[antiCompLabel centerXAnchor]];
    var label1BottomY = [[antiCompLabel bottomAnchor] constraintEqualToAnchor:[antiCompSlider topAnchor] constant:5];
    var label2CenterX = [[huggingSlider centerXAnchor] constraintEqualToAnchor:[huggingLabel centerXAnchor]];
    var label2BottomY = [[huggingLabel bottomAnchor] constraintEqualToAnchor:[huggingSlider topAnchor] constant:5];
    var label3CenterX = [[holdingSlider centerXAnchor] constraintEqualToAnchor:[holdingLabel centerXAnchor]];
    var label3BottomY = [[holdingLabel bottomAnchor] constraintEqualToAnchor:[holdingSlider topAnchor] constant:5];

    var center = [[antiCompSlider centerLayoutPoint] constraintsEqualToLayoutPoint:[aView centerLayoutPoint]];

    var width = [[antiCompSlider widthAnchor] constraintEqualToConstant:100];

    var bellow = [[huggingSlider topAnchor] constraintEqualToAnchor:[antiCompSlider bottomAnchor] constant:10];
    var centerX = [[huggingSlider centerXAnchor] constraintEqualToAnchor:[aView centerXAnchor]];
    var width2 = [[huggingSlider widthAnchor] constraintEqualToConstant:100];

    var bellow2 = [[holdingSlider topAnchor] constraintEqualToAnchor:[huggingSlider bottomAnchor] constant:10];
    var centerX2 = [[holdingSlider centerXAnchor] constraintEqualToAnchor:[aView centerXAnchor]];
    var width22 = [[holdingSlider widthAnchor] constraintEqualToConstant:100];

    var constraints = @[];
    [constraints addObjectsFromArray:center];
    [constraints addObjectsFromArray:@[width, centerX, width2, bellow, bellow2, centerX2, width22, label1CenterX, label1BottomY, label2CenterX, label2BottomY, label3CenterX, label3BottomY]];

    [CPLayoutConstraint activateConstraints:constraints];

    [splitView addArrangedSubview:aView];
    var last = [[splitView arrangedSubviews] count] - 1;
    [splitView setHoldingPriority:(250 - last) forSubviewAtIndex:last];
    [aView updateLayout];
}

- (void)removeSubview:(id)sender
{
    var view = [[splitView arrangedSubviews] lastObject];
    if (view)
        [splitView removeArrangedSubview:view];
}

- (void)setPosition:(id)sender
{
    [splitView setPosition:100 ofDividerAtIndex:0];
}

- (void)_setvertical:(id)sender
{
    var value = [sender selectedSegment];
    [splitView setVertical:value];
}

- (void)_setDividerThickness:(id)sender
{
    var value = [sender intValue];
    [splitView setDividerThickness:value];
}

- (IBAction)priorityAction:(id)sender
{
    var popover = [self priorityPopover],
        controller = [popover contentViewController];

    if (![popover isShown])
    {
        [controller setSender:sender];
        [popover showRelativeToRect:nil ofView:sender preferredEdge:CPMaxYEdge];
    }

    if ([sender isHighlighted])
    {
        [controller _updateLayout];
    }
    else
    {
        [popover performClose:sender];
    }
}

- (BOOL)popoverShouldClose:(CPPopover)aPopover
{
    CPLog.info("popover " + aPopover + " should close");
    return YES;
}

- (void)popoverDidClose:(CPPopover)aPopover
{
    var sender = [[aPopover contentViewController] sender],
        value = [sender intValue],
        arrangedSubview = [sender superview];

    switch ([sender tag])
    {
        case 1: [arrangedSubview setContentCompressionResistancePriority:value forOrientation:0];
                [arrangedSubview setNeedsUpdateConstraints:YES];
                [[splitView window] setNeedsLayout];
            break;
        case 2: [arrangedSubview setContentHuggingPriority:value forOrientation:0];
                [arrangedSubview setNeedsUpdateConstraints:YES];
                [[splitView window] setNeedsLayout];
            break;
        case 3: var idx = [[splitView arrangedSubviews] indexOfObjectIdenticalTo:arrangedSubview];
                [splitView setHoldingPriority:value forSubviewAtIndex:idx];
            break;
        default:
    }

    [[aPopover contentViewController] setSender:nil];

    CPLog.info("popover " + aPopover + " did close tag:" + [sender tag]);
}

@end

@implementation PopoverController : CPViewController
{
    id sender @accessors;
    CPTextField valueField;
    CPTextField summaryField;
}

- (void)loadView
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 200, 110)];
    [view setBackgroundColor:[CPColor colorWithWhite:1 alpha:0.2]];

    valueField = [[CPTextField alloc] initWithFrame:CGRectMake(0, 4, 200, 28)];
    [valueField setFont:[CPFont boldSystemFontOfSize:16]];
    [valueField setAlignment:CPCenterTextAlignment];
    [valueField setAutoresizingMask:CPViewWidthSizable];
    [view addSubview:valueField];

    summaryField = [[CPTextField alloc] initWithFrame:CGRectMake(10, 32, 180, 80)];
    [summaryField setFont:[CPFont systemFontOfSize:16]];
    [summaryField setLineBreakMode:CPLineBreakByWordWrapping];
    [summaryField setAlignment:CPCenterTextAlignment];
    [view addSubview:summaryField];

    [self setView:view];
}

- (void)_updateLayout
{
    var priority = [sender intValue],
        text = "";

    if (priority < CPLayoutPriorityDefaultLow)
        text = "Weaker than default weak priority at witch a control holds to its intrinsic content size.";
    else if (priority < CPLayoutPriorityDragThatCannotResizeWindow)
        text = "Weaker than the user resizing the window.";
    else if (priority < CPLayoutPriorityWindowSizeStayPut)
        text = "Weaker than the window staying same size.";
    else if (priority < CPLayoutPriorityDragThatCanResizeWindow)
        text = "Stronger than the window staying same size.";
    else if (priority < CPLayoutPriorityDefaultHigh)
        text = "Stronger than the user resizing the window.";
    else if (priority < CPLayoutPriorityRequired)
        text = "Not required but stronger than the priority at witch controls maintain their intrinsic content size.";
    else if (priority == CPLayoutPriorityRequired)
        text = "Required";

    [valueField setStringValue:[sender identifier] + " :" + priority];
    [summaryField setStringValue:text];
}

@end

@implementation AppController (Delegate)

- (BOOL)splitView:(CPSplitView)splitView canCollapseSubview:(CPView)subview
{
    return [subview identifier] != @"view2";
}
/*
- (BOOL)splitView:(CPSplitView)splitView shouldAdjustSizeOfSubview:(CPView)subview
{
    return NO;
}
*/
- (BOOL)splitView:(CPSplitView)splitView shouldCollapseSubview:(CPView)subview forDoubleClickOnDividerAtIndex:(CPInteger)dividerIndex
{
    return [subview identifier] != @"view2";
}
/*
- (CGRect)splitView:(CPSplitView)splitView additionalEffectiveRectOfDividerAtIndex:(CPInteger)dividerIndex
{
    return CGRectMakeZero();
}

- (CGRect)splitView:(CPSplitView)splitView effectiveRect:(CGRect)proposedEffectiveRect forDrawnRect:(CGRect)drawnRect ofDividerAtIndex:(CPInteger)dividerIndex
{
    return proposedEffectiveRect;
}

- (float)splitView:(CPSplitView)splitView constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(CPInteger)dividerIndex
{
    return proposedMax - 100;
}

- (float)splitView:(CPSplitView)splitView constrainMinCoordinate:(float)proposedMin ofSubviewAt:(CPInteger)dividerIndex
{
    return proposedMin + 100;
}

- (float)splitView:(CPSplitView)splitView constrainSplitPosition:(float)proposedPosition ofSubviewAt:(CPInteger)dividerIndex
{
    return proposedPosition;
}
*/
- (void)splitViewDidResizeSubviews:(CPNotification)aNotification
{

}

- (void)splitViewWillResizeSubviews:(CPNotification)aNotification
{

}

@end

@implementation ColorView : CPView
{
    CPColor color @accessors;
    CGSize  intrinsicSize @accessors;
}

- (id)init
{
    return [self initWithFrame:CGRectMakeZero()];
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    intrinsicSize = CGSizeMake(-1, -1);
    [self invalidateIntrinsicContentSize];
    color = [CPColor randomColor];

    return self;
}

- (void)viewDidMoveToSuperview
{
    [self updateLayout];
}

- (void)updateLayout
{
    [[self viewWithTag:1] setFloatValue:[self contentCompressionResistancePriorityForOrientation:0]];
    [[self viewWithTag:2] setFloatValue:[self contentHuggingPriorityForOrientation:0]];

    var sv = [[CPApp delegate] splitView];
    var idx = [[sv arrangedSubviews] indexOfObjectIdenticalTo:self];
    [[self viewWithTag:3] setFloatValue:[sv holdingPriorityForSubviewAtIndex:idx]];
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [color setFill];
    [[CPColor blackColor] setStroke];
    CGContextFillRect(ctx, [self bounds]);
    [[CPColor colorWithWhite:0 alpha:0.2] setFill];
    var width = (intrinsicSize.width !== -1) ? intrinsicSize.width : CGRectGetWidth([self bounds]);
    var height = (intrinsicSize.height !== -1) ? intrinsicSize.height : CGRectGetHeight([self bounds]);
    CGContextFillRect(ctx, CGRectMake(0, 0, width, height));
    CGContextStrokeRect(ctx, CGRectInsetByInset([self bounds], CGInsetMake(1, 1, 1, 1)));
}

- (CGSize)intrinsicContentSize
{
    return intrinsicSize;
}

@end

@implementation SplitView : CPSplitView
{
}


- (void)drawRect:(CGRect)aRect
{
    [super drawRect:aRect];

    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [[CPColor blackColor] setStroke];
    CGContextSetLineWidth(ctx,2);
    CGContextStrokeRect(ctx, [self bounds]);
}

@end
