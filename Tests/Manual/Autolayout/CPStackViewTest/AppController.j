/*
 * AppController.j
 * CPStackViewTest
 *
 * Created by You on September 20, 2016.
 * Copyright 2016, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

CPLogRegister(CPLogConsole);

@class StackView;
@implementation AppController : CPObject
{
    StackView stackView;
    CPWindow theWindow;

    CPArray priorities;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(50, 50,1400,400) styleMask:CPResizableWindowMask|CPTitledWindowMask];
    var contentView = [theWindow contentView];
    [contentView setIdentifier:@"ContentView"];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];

    priorities = @[@{"label" : "Required", "value" : CPLayoutPriorityRequired},
                   @{"label" : "High", "value"  : CPLayoutPriorityDefaultHigh},
                   @{"label" : "Low", "value"  : CPLayoutPriorityDefaultLow}];

    var segmented = [[CPSegmentedControl alloc] initWithFrame:CGRectMake(20, 10, 200, 32)];
    [segmented setSegmentCount:5];
    [segmented setLabel:@"Fill" forSegment:0];
    [segmented setLabel:@"Fill Equally" forSegment:1];
    [segmented setLabel:@"Fill Proportionally" forSegment:2];
    [segmented setLabel:@"Equal Spacing" forSegment:3];
    [segmented setLabel:@"Equal Centering" forSegment:4];
    [segmented setTarget:self];
    [segmented setAction:@selector(distribute:)];
    [segmented setSelectedSegment:0];
    [contentView addSubview:segmented];

    var segmentedOrientation = [[CPSegmentedControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX([segmented frame]) + 10,10,200,32)];
    [segmentedOrientation setSegmentCount:2];
    [segmentedOrientation setLabel:@"Horizontal" forSegment:0];
    [segmentedOrientation setLabel:@"Vertical" forSegment:1];
    [segmentedOrientation setTarget:self];
    [segmentedOrientation setAction:@selector(orientate:)];
    [segmentedOrientation setSelectedSegment:0];
    [contentView addSubview:segmentedOrientation];

    var slider = [[CPSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX([segmentedOrientation frame]) + 10 ,10,100,32)];
    [slider setMinValue:0];
    [slider setMaxValue:50];
    [slider setDoubleValue:[stackView spacing]];
    [slider setContinuous:NO];
    [slider setTarget:self];
    [slider setAction:@selector(setSpacing:)];
    [contentView addSubview:slider];

    var spaceLabel = [CPTextField labelWithTitle:@"spacing"];
    [spaceLabel setFont:[CPFont systemFontOfSize:10]];
    var f = [slider frame];
    f.origin.y = f.origin.y - 5;
    [spaceLabel setFrame:f];
    [spaceLabel sizeToFit];
    [contentView addSubview:spaceLabel];

    var prioritiesController = [CPArrayController new];
    [prioritiesController bind:@"contentArray" toObject:self withKeyPath:@"priorities" options:nil];

    var huggingPopup = [[CPPopUpButton alloc] initWithFrame:CGRectMakeZero()];
    [huggingPopup setTranslatesAutoresizingMaskIntoConstraints:NO];
    [huggingPopup addItemsWithTitles:[@"Hugging PriorityLow", @"Priority500", @"PriorityHigh", @"PriorityRequired"]];
    [huggingPopup setTarget:self]
    [huggingPopup setAction:@selector(setHugging:)];
    [contentView addSubview:huggingPopup];
    [[[huggingPopup topAnchor] constraintEqualToAnchor:[segmented bottomAnchor] constant:10] setActive:YES];
    [[[huggingPopup leftAnchor] constraintEqualToAnchor:[segmented leftAnchor] constant:0] setActive:YES];

    var huggingPopupV = [[CPPopUpButton alloc] initWithFrame:CGRectMakeZero()];
    [huggingPopupV setTranslatesAutoresizingMaskIntoConstraints:NO];
    [huggingPopupV addItemsWithTitles:[@"Hugging↺ PriorityLow", @"Priority500", @"PriorityHigh", @"PriorityRequired"]];
    [huggingPopupV setTarget:self]
    [huggingPopupV setAction:@selector(setHuggingV:)];
    [contentView addSubview:huggingPopupV];
    [[[huggingPopupV topAnchor] constraintEqualToAnchor:[huggingPopup topAnchor] constant:0] setActive:YES];
    [[[huggingPopupV leftAnchor] constraintEqualToAnchor:[huggingPopup rightAnchor] constant:10] setActive:YES];

    var clippingPopup = [[CPPopUpButton alloc] initWithFrame:CGRectMakeZero()];
    [clippingPopup setTranslatesAutoresizingMaskIntoConstraints:NO];
    [clippingPopup addItemsWithTitles:[@"Clipping PriorityLow", @"Priority500", @"PriorityHigh", @"PriorityRequired"]];
    [clippingPopup setTarget:self]
    [clippingPopup setAction:@selector(setClipping:)];
    [contentView addSubview:clippingPopup];
    [[[clippingPopup topAnchor] constraintEqualToAnchor:[huggingPopupV topAnchor] constant:0] setActive:YES];
    [[[clippingPopup leftAnchor] constraintEqualToAnchor:[huggingPopupV rightAnchor] constant:10] setActive:YES];

    var clippingPopupV = [[CPPopUpButton alloc] initWithFrame:CGRectMakeZero()];
    [clippingPopupV setTranslatesAutoresizingMaskIntoConstraints:NO];
    [clippingPopupV addItemsWithTitles:[@"Clipping↺ PriorityLow", @"Priority500", @"PriorityHigh", @"PriorityRequired"]];
    [clippingPopupV setTarget:self]
    [clippingPopupV setAction:@selector(setClippingV:)];
    [contentView addSubview:clippingPopupV];
    [[[clippingPopupV topAnchor] constraintEqualToAnchor:[clippingPopup topAnchor] constant:0] setActive:YES];
    [[[clippingPopupV leftAnchor] constraintEqualToAnchor:[clippingPopup rightAnchor] constant:10] setActive:YES];

    var alignPopup = [[CPPopUpButton alloc] initWithFrame:CGRectMakeZero()];
    [alignPopup setTranslatesAutoresizingMaskIntoConstraints:NO];
    [alignPopup addItemsWithTitles:[@"top",@"centerY",@"bottom"]];
    [alignPopup selectItemAtIndex:1];
    [alignPopup setTarget:self];
    [alignPopup setAction:@selector(setAlignment:)];
    [alignPopup setTag:2];
    [contentView addSubview:alignPopup];
    [[[alignPopup topAnchor] constraintEqualToAnchor:[clippingPopupV topAnchor] constant:0] setActive:YES];
    [[[alignPopup leftAnchor] constraintEqualToAnchor:[clippingPopupV rightAnchor] constant:10] setActive:YES];

    var testButton = [[CPButton alloc] initWithFrame:CGRectMakeZero()];
    [testButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [testButton setTitle:@"Add View"];
    [testButton setTarget:self];
    [testButton setAction:@selector(test:)];
    [contentView addSubview:testButton];
    [[[testButton topAnchor] constraintEqualToAnchor:[huggingPopup bottomAnchor] constant:10] setActive:YES];
    [[[testButton leftAnchor] constraintEqualToAnchor:[segmented leftAnchor] constant:0] setActive:YES];

    var testButton2 = [[CPButton alloc] initWithFrame:CGRectMakeZero()];
    [testButton2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [testButton2 setTitle:@"Remove Last View"];
    [testButton2 setTarget:self];
    [testButton2 setAction:@selector(test2:)];
    [contentView addSubview:testButton2];
    [[[testButton2 topAnchor] constraintEqualToAnchor:[testButton topAnchor] constant:0] setActive:YES];
    [[[testButton2 leftAnchor] constraintEqualToAnchor:[testButton rightAnchor] constant:10] setActive:YES];
    [[[testButton2 heightAnchor] constraintEqualToAnchor:[testButton heightAnchor]] setActive:YES];

    var gravityPopup = [[CPPopUpButton alloc] initWithFrame:CGRectMakeZero()];
    [gravityPopup setTranslatesAutoresizingMaskIntoConstraints:NO];
    [gravityPopup addItemsWithTitles:[@"in gravity Leading",@"in gravity Center",@"in gravity Trailing"]];
    [gravityPopup selectItemAtIndex:0];
    [gravityPopup setTag:3];
    [contentView addSubview:gravityPopup];
    [[[gravityPopup topAnchor] constraintEqualToAnchor:[testButton2 topAnchor] constant:0] setActive:YES];
    [[[gravityPopup leftAnchor] constraintEqualToAnchor:[testButton2 rightAnchor] constant:10] setActive:YES];

    var views = @[],
        i = 0,
        p = 253;

    for (; i < 3; i++)
    {
        var view = [[ColorView alloc] initWithInstrinsicSize:CGSizeMake(50 * (i + 1), 200)];
        [view setContentHuggingPriority:(p - i) forOrientation:0];
        [view setContentHuggingPriority:(p - i) forOrientation:1];
        [view setIdentifier:("View_" + CPStackViewGravityLeading + "_" + i)];
        [views addObject:view];
    }

    stackView = [StackView stackViewWithViews:views];
    [stackView setAlignment:CPLayoutAttributeCenterY];
    [stackView setEdgeInsets:CGInsetMake(10, 10, 10, 10)];
    [stackView setHuggingPriority:250 forOrientation:0];
    [stackView setHuggingPriority:250 forOrientation:1];
    [stackView setClippingResistancePriority:250 forOrientation:0];
    [stackView setClippingResistancePriority:250 forOrientation:1];
    [contentView addSubview:stackView];

    var stack1 = [[stackView leftAnchor] constraintEqualToAnchor:[contentView leftAnchor] constant:100],
        stack2 = [[stackView topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:150],
        stack3 = [[stackView rightAnchor] constraintEqualToAnchor:[contentView rightAnchor] constant:-100],
        stack4 = [[stackView bottomAnchor] constraintEqualToAnchor:[contentView bottomAnchor] constant:-100];

    [CPLayoutConstraint activateConstraints:[stack1, stack2, stack3, stack4]];

    [theWindow orderFront:self];
}

- (void)setAlignment:(id)sender
{
    var idx = [sender indexOfSelectedItem],
        orientation = [stackView orientation],
        attr;

    switch (idx) {
        case 0: attr = orientation ? CPLayoutAttributeLeft : CPLayoutAttributeTop;
            break;
        case 1: attr = orientation ? CPLayoutAttributeCenterX : CPLayoutAttributeCenterY;
            break;
        case 2: attr = orientation ? CPLayoutAttributeRight : CPLayoutAttributeBottom;
            break;
        default:
    }

    [stackView setAlignment:attr];
    [stackView setNeedsDisplay:YES];
}

- (void)test2:(id)sender
{
    var gravity = [[[theWindow contentView] viewWithTag:3] indexOfSelectedItem] + 1;
    var views = [stackView viewsInGravity:gravity];
    var lastView = [views lastObject];

    if (lastView !== nil)
    {
        [stackView removeView:lastView];
        [theWindow setNeedsLayout];
        [stackView setNeedsDisplay:YES];
    }
}

- (IBAction)test:(id)sender
{
    var gravity = [[[theWindow contentView] viewWithTag:3] indexOfSelectedItem] + 1;
    var n = [[stackView viewsInGravity:gravity] count];

    var view = [[ColorView alloc] initWithInstrinsicSize:CGSizeMake(50 * (n + 1), 200)];
    [view setOrientation:[stackView orientation]];
    [view setContentHuggingPriority:(252 - n) forOrientation:0];
    [view setContentHuggingPriority:(252 - n) forOrientation:1];
    [view setIdentifier:("View_" + gravity + "_" + n)];
    [stackView addView:view inGravity:gravity];
    [theWindow setNeedsLayout];
    [stackView setNeedsDisplay:YES];
}

- (void)setHugging:(id)sender
{
    var p = ([sender indexOfSelectedItem] + 1) * 250;
    [stackView setHuggingPriority:p forOrientation:[stackView orientation]];
    [theWindow setNeedsLayout];
    [stackView setNeedsDisplay:YES];
}

- (void)setHuggingV:(id)sender
{
    var p = ([sender indexOfSelectedItem] + 1) * 250;
    [stackView setHuggingPriority:p forOrientation:(1 - [stackView orientation])];
    [theWindow setNeedsLayout];
    [stackView setNeedsDisplay:YES];
}

- (void)setClipping:(id)sender
{
    var p = ([sender indexOfSelectedItem] + 1) * 250;
    [stackView setClippingResistancePriority:p forOrientation:[stackView orientation]];
    [theWindow setNeedsLayout];
    [stackView setNeedsDisplay:YES];
}

- (void)setClippingV:(id)sender
{
    var p = ([sender indexOfSelectedItem] + 1) * 250;
    [stackView setClippingResistancePriority:p forOrientation:(1 - [stackView orientation])];
    [theWindow setNeedsLayout];
    [stackView setNeedsDisplay:YES];
}

- (void)distribute:(id)sender
{
    var d = [sender selectedSegment];
    [stackView setDistribution:d];
    [theWindow setNeedsLayout];
    [stackView setNeedsDisplay:YES];
}

- (void)orientate:(id)sender
{
    var o = [sender selectedSegment];

    if (o == [stackView orientation])
        return;

    var items = o ? @["left", "centerX", "right"] : @["top", "centerY", "bottom"];
    var alignPopup = [[theWindow contentView] viewWithTag:2];
    [alignPopup removeAllItems];
    [alignPopup addItemsWithTitles:items];
    [alignPopup selectItemAtIndex:1];
    [self setAlignment:alignPopup];

    [[stackView views] enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        [view setOrientation:o];
    }];

    [stackView setOrientation:o];
    [theWindow setNeedsLayout];
    [stackView setNeedsDisplay:YES];
}

- (void)setSpacing:(id)sender
{
    var k = [sender intValue];
    [stackView setSpacing:k];
    [theWindow setNeedsLayout];
    [stackView setNeedsDisplay:YES];
}

@end

@implementation ColorView : CPView
{
    CPColor     color;
    CGSize      intrinsicSize @accessors(getter=intrinsicSize);
    CPInteger   orientation   @accessors;
}

- (id)initWithInstrinsicSize:(CGSize)aSize
{
    self = [super initWithFrame:CGRectMakeZero()];

    color = [CPColor randomLigthColor];
    intrinsicSize = aSize;
    orientation = 0;

    return self;
}

- (void)setOrientation:(CPInteger)ori
{
    if (ori !== orientation)
    {
        orientation = ori;
        [self invalidateIntrinsicContentSize];
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    var intrinsicRect = [self intrinsicRect];

    [color setFill];
    CGContextFillRect(ctx, [self bounds]);

    [[CPColor colorWithWhite:0.1 alpha:0.15] setFill];
    CGContextFillRect(ctx, intrinsicRect);

    var huggingPriority = [self contentHuggingPriorityForOrientation:orientation];
    var compressionPriority = [self contentCompressionResistancePriorityForOrientation:orientation];

    [self drawString:("<"+ compressionPriority +"> >"+ huggingPriority +"<") inBounds:intrinsicRect];
}

- (void)drawString:(CPString)aString inBounds:(CGRect)bounds
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    ctx.font = [[CPFont boldSystemFontOfSize:12] cssString];
    [[CPColor whiteColor] setFill];
    var metrics = ctx.measureText(aString);
    ctx.fillText(aString, (CGRectGetWidth(bounds) - metrics.width)/2, CGRectGetHeight(bounds)/2);
}

- (void)setIntrinsicSize:(CGSize)aSize
{
    intrinsicSize = aSize;
    [self invalidateIntrinsicContentSize];
}

- (CGRect)intrinsicRect
{
    var intrinsic = [self intrinsicContentSize];
    return CGRectMake(0, 0, intrinsic.width, intrinsic.height);
}

- (CGSize)intrinsicContentSize
{
    return orientation ? CGSizeMake(intrinsicSize.height, intrinsicSize.width) : intrinsicSize;
}

@end

@implementation StackView : CPStackView
{
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

@implementation CPColor (Debugging)

+ (CPColor)randomDarkColor
{
    return [CPColor colorWithRed:(RAND() / 2) green:(RAND() / 2) blue:(RAND() / 2) alpha:1.0];
}

+ (CPColor)randomLigthColor
{
    return [CPColor colorWithRed:(RAND() / 2 + 0.5) green:(RAND() / 2 + 0.5) blue:(RAND() / 2 + 0.5) alpha:1.0];
}

@end

/*
2016-12-15 09:34:05.733 NSStackView2[86403:2146200] stackConstraints Distribution 0 :
stackView.height == + 100 @1000.000000
left.centerY == stackView.centerY @260.000000
middle.centerY == stackView.centerY @260.000000
right.centerY == stackView.centerY @260.000000
left.left == stackView.left + 7 @1000.000000
left.top >= stackView.top @1000.000000
left.top == stackView.top + 8 @verticalHugging
stackView.bottom >= left.bottom @verticalClippingResistance
stackView.bottom == left.bottom + 9 @verticalHugging
middle.top >= stackView.top @1000.000000
middle.top == stackView.top + 8 @verticalHugging
stackView.bottom >= middle.bottom @verticalClippingResistance
stackView.bottom == middle.bottom + 9 @verticalHugging
right.top >= stackView.top @1000.000000
right.top == stackView.top + 8 @verticalHugging
stackView.bottom >= right.bottom @verticalClippingResistance
stackView.bottom == right.bottom + 9 @verticalHugging
stackView.right >= right.right + 10 @horizontalClippingResistance
stackView.right <= right.right + 10 @1000.000000
middle.left == left.right + 11 @1000.000000
right.left == middle.right + 11 @1000.000000

2016-12-15 09:34:11.197 NSStackView2[86403:2146200] stackConstraints Distribution 1 :
stackView.height == + 100 @1000.000000
left.centerY == stackView.centerY @260.000000
middle.centerY == stackView.centerY @260.000000
right.centerY == stackView.centerY @260.000000
left.left == stackView.left + 7 @1000.000000
left.top >= stackView.top @1000.000000
left.top == stackView.top + 8 @verticalHugging
stackView.bottom >= left.bottom @verticalClippingResistance
stackView.bottom == left.bottom + 9 @verticalHugging
middle.top >= stackView.top @1000.000000
middle.top == stackView.top + 8 @verticalHugging
stackView.bottom >= middle.bottom @verticalClippingResistance
stackView.bottom == middle.bottom + 9 @verticalHugging
right.top >= stackView.top @1000.000000
right.top == stackView.top + 8 @verticalHugging
stackView.bottom >= right.bottom @verticalClippingResistance
stackView.bottom == right.bottom + 9 @verticalHugging
stackView.right >= right.right + 10 @horizontalClippingResistance
stackView.right <= right.right + 10 @1000.000000
middle.left == left.right + 11 @1000.000000
right.left == middle.right + 11 @1000.000000
NSStackView.DistributionGuide.Ideal.width == left.width @260.000000
NSStackView.DistributionGuide.Ideal.width == middle.width @260.000000
NSStackView.DistributionGuide.Ideal.width == right.width @260.000000

2016-12-15 09:34:42.900 NSStackView2[86403:2146200] stackConstraints Distribution 2 :
stackView.height == + 100 @1000.000000
left.centerY == stackView.centerY @260.000000
middle.centerY == stackView.centerY @260.000000
right.centerY == stackView.centerY @260.000000
left.left == stackView.left + 7 @1000.000000
left.top >= stackView.top @1000.000000
left.top == stackView.top + 8 @verticalHugging
stackView.bottom >= left.bottom @verticalClippingResistance
stackView.bottom == left.bottom + 9 @verticalHugging
middle.top >= stackView.top @1000.000000
middle.top == stackView.top + 8 @verticalHugging
stackView.bottom >= middle.bottom @verticalClippingResistance
stackView.bottom == middle.bottom + 9 @verticalHugging
right.top >= stackView.top @1000.000000
right.top == stackView.top + 8 @verticalHugging
stackView.bottom >= right.bottom @verticalClippingResistance
stackView.bottom == right.bottom + 9 @verticalHugging
stackView.right >= right.right + 10 @horizontalClippingResistance
stackView.right <= right.right + 10 @1000.000000
middle.left == left.right + 11 @1000.000000
right.left == middle.right + 11 @1000.000000
left.width == 200*NSStackView.DistributionGuide.Ideal.width @260.000000
middle.width == 200*NSStackView.DistributionGuide.Ideal.width @260.000000
right.width == 200*NSStackView.DistributionGuide.Ideal.width @260.000000

2016-12-15 09:34:51.901 NSStackView2[86403:2146200] stackConstraints Distribution 3 :
stackView.height == + 100 @1000.000000
left.centerY == stackView.centerY @260.000000
middle.centerY == stackView.centerY @260.000000
right.centerY == stackView.centerY @260.000000
left.left >= stackView.left @1000.000000
left.left == stackView.left + 7 @750.000000
left.top >= stackView.top @1000.000000
left.top == stackView.top + 8 @verticalHugging
stackView.bottom >= left.bottom @verticalClippingResistance
stackView.bottom == left.bottom + 9 @verticalHugging
middle.top >= stackView.top @1000.000000
middle.top == stackView.top + 8 @verticalHugging
stackView.bottom >= middle.bottom @verticalClippingResistance
stackView.bottom == middle.bottom + 9 @verticalHugging
right.top >= stackView.top @1000.000000
right.top == stackView.top + 8 @verticalHugging
stackView.bottom >= right.bottom @verticalClippingResistance
stackView.bottom == right.bottom + 9 @verticalHugging
stackView.right >= right.right + 10 @horizontalClippingResistance
stackView.right <= right.right + 10 @750.000000
middle.left >= left.right + 11 @1000.000000
middle.left == left.right + 11 @horizontalHugging
right.left >= middle.right + 11 @1000.000000
right.left == middle.right + 11 @horizontalHugging
left.right == NSStackView.DistributionGuide.0x6000001408f0.left @1000.000000
NSStackView.DistributionGuide.0x6000001408f0.right == middle.left @1000.000000
NSStackView.DistributionGuide.Ideal.width == NSStackView.DistributionGuide.0x6000001408f0.width @260.000000
middle.right == NSStackView.DistributionGuide.0x608000140370.left @1000.000000
NSStackView.DistributionGuide.0x608000140370.right == right.left @1000.000000
NSStackView.DistributionGuide.Ideal.width == NSStackView.DistributionGuide.0x608000140370.width @260.000000

2016-12-15 09:34:56.443 NSStackView2[86403:2146200] stackConstraints Distribution 4 :
stackView.height == + 100 @1000.000000
left.centerY == stackView.centerY @260.000000
middle.centerY == stackView.centerY @260.000000
right.centerY == stackView.centerY @260.000000
left.left >= stackView.left @1000.000000
left.left == stackView.left + 7 @750.000000
left.top >= stackView.top @1000.000000
left.top == stackView.top + 8 @verticalHugging
stackView.bottom >= left.bottom @verticalClippingResistance
stackView.bottom == left.bottom + 9 @verticalHugging
middle.top >= stackView.top @1000.000000
middle.top == stackView.top + 8 @verticalHugging
stackView.bottom >= middle.bottom @verticalClippingResistance
stackView.bottom == middle.bottom + 9 @verticalHugging
right.top >= stackView.top @1000.000000
right.top == stackView.top + 8 @verticalHugging
stackView.bottom >= right.bottom @verticalClippingResistance
stackView.bottom == right.bottom + 9 @verticalHugging
stackView.right >= right.right + 10 @horizontalClippingResistance
stackView.right <= right.right + 10 @750.000000
middle.left >= left.right + 11 @1000.000000
middle.left == left.right + 11 @horizontalHugging
right.left >= middle.right + 11 @1000.000000
right.left == middle.right + 11 @horizontalHugging
left.centerX == NSStackView.DistributionGuide.0x6000001408f0.left @1000.000000
NSStackView.DistributionGuide.0x6000001408f0.right == middle.centerX @1000.000000
NSStackView.DistributionGuide.Ideal.width == NSStackView.DistributionGuide.0x6000001408f0.width @260.000000
middle.centerX == NSStackView.DistributionGuide.0x608000140370.left @1000.000000
NSStackView.DistributionGuide.0x608000140370.right == right.centerX @1000.000000
NSStackView.DistributionGuide.Ideal.width == NSStackView.DistributionGuide.0x608000140370.width @260.000000

2016-12-15 10:05:58.415 NSStackView2[86829:2210980] stackConstraints Distribution -1 :
stackView.height == + 100 @1000.000000
left.centerY == stackView.centerY @260.000000
middle.centerY == stackView.centerY @260.000000
right.centerY == stackView.centerY @260.000000
left.left >= stackView.left @1000.000000
left.left == stackView.left + 7 @750.000000
left.top >= stackView.top @1000.000000
left.top == stackView.top + 8 @verticalHugging
stackView.bottom >= left.bottom @verticalClippingResistance
stackView.bottom == left.bottom + 9 @verticalHugging
middle.top >= stackView.top @1000.000000
middle.top == stackView.top + 8 @verticalHugging
stackView.bottom >= middle.bottom @verticalClippingResistance
stackView.bottom == middle.bottom + 9 @verticalHugging
right.top >= stackView.top @1000.000000
right.top == stackView.top + 8 @verticalHugging
stackView.bottom >= right.bottom @verticalClippingResistance
stackView.bottom == right.bottom + 9 @verticalHugging
stackView.right >= right.right + 10 @horizontalClippingResistance
stackView.right <= right.right + 10 @251.000000
middle.left >= left.right + 11 @1000.000000
middle.left == left.right + 11 @749.989990
right.left >= middle.right + 11 @1000.000000
right.left == middle.right + 11 @749.979980

*/