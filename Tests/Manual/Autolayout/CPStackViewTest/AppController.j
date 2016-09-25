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
    theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(50, 50,1200,400) styleMask:CPResizableWindowMask|CPTitledWindowMask];
    [theWindow setAutolayoutEnabled:YES];

    priorities = @[@{"label" : "Required", "value" : CPLayoutPriorityRequired},
                   @{"label" : "High", "value"  : CPLayoutPriorityDefaultHigh},
                   @{"label" : "Low", "value"  : CPLayoutPriorityDefaultLow}];

    var contentView = [theWindow contentView];

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

    var combo = [[CPComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX([slider frame]) + 10 ,10,100,28)];
    [combo setControlSize:CPSmallControlSize];
    [combo setCompletes:NO];
    [combo setHasVerticalScroller:NO];
    [combo setButtonBordered:NO];

    [combo bind:@"content" toObject:prioritiesController withKeyPath:@"arrangedObjects" options:nil];
    [combo bind:@"contentValues" toObject:prioritiesController withKeyPath:@"arrangedObjects.label" options:nil];
    [combo bind:@"value" toObject:prioritiesController withKeyPath:@"selection.value" options:nil];
    [contentView addSubview:combo];
    [combo setTarget:self];
    [combo setAction:@selector(setHugging:)];
    [combo setDelegate:self];

    var alignPopup = [[CPPopUpButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX([combo frame]) + 10 ,10,100,32)];
    [alignPopup addItemsWithTitles:[@"top",@"centerY",@"bottom"]];
    [alignPopup selectItemAtIndex:1];
    [alignPopup setTarget:self];
    [alignPopup setAction:@selector(setAlignment:)];
    [alignPopup setTag:2];
    [contentView addSubview:alignPopup];

    var testButton = [[CPButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX([alignPopup frame]) + 10, 10, 100, 32)];
    [testButton setTitle:@"Add View"];
    [testButton setTarget:self];
    [testButton setAction:@selector(test:)];
    [contentView addSubview:testButton];

    var testButton2 = [[CPButton alloc] initWithFrame:CGRectMakeZero()];
    [testButton2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [testButton2 setTitle:@"Remove Last View"];
    [testButton2 setTarget:self];
    [testButton2 setAction:@selector(test2:)];
    [contentView addSubview:testButton2];
    [[[testButton2 topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:10] setActive:YES];
    [[[testButton2 leftAnchor] constraintEqualToAnchor:[testButton rightAnchor] constant:10] setActive:YES];
    [[[testButton2 heightAnchor] constraintEqualToAnchor:[testButton heightAnchor]] setActive:YES];

    var views = @[],
        i = 1,
        p = 253;

    for (; i <= 3; i++)
    {
        var view = [[ColorView alloc] initWithInstrinsicSize:CGSizeMake(50 * i, 200)];
        [view setContentHuggingPriority:(p - i) forOrientation:0];
        [view setContentHuggingPriority:(p - i) forOrientation:1];
        [view setIdentifier:(@"View" + i)];
        [views addObject:view];
    }

    stackView = [StackView stackViewWithViews:views];
    [stackView setAlignment:CPLayoutAttributeCenterY];
    [stackView setEdgeInsets:CGInsetMake(10, 10, 10, 10)];
    [stackView setHuggingPriority:255 forOrientation:0];
    [stackView setHuggingPriority:255 forOrientation:1];
    [contentView addSubview:stackView];

    var stack1 = [[stackView leftAnchor] constraintEqualToAnchor:[contentView leftAnchor] constant:100],
        stack2 = [[stackView topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:100],
        stack3 = [[stackView rightAnchor] constraintEqualToAnchor:[contentView rightAnchor] constant:-100],
        stack4 = [[stackView bottomAnchor] constraintEqualToAnchor:[contentView bottomAnchor] constant:-100];

//    [stack3 setPriority:490];
    [CPLayoutConstraint activateConstraints:[stack1, stack2, stack3, stack4]];

    [theWindow orderFront:self];
    [theWindow layout];
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
}

- (void)comboBoxWillDismiss:(CPNotification)aNotification
{
    var combo = [aNotification object];
    var idx = [combo indexOfSelectedItem];
    if (idx !== CPNotFound)
    {
        var value = [[priorities objectAtIndex:idx] objectForKey:@"value"];
        [combo setObjectValue:value];
        [self setHugging:combo];
        CPLog.debug(_cmd + " " + value);
    }
}

- (void)comboBoxSelectionDidChange:(CPNotification)aNotification
{
    var combo = [aNotification object];
    var idx = [combo indexOfSelectedItem];
    if (idx !== CPNotFound)
    {
        var value = [[priorities objectAtIndex:idx] objectForKey:@"value"];
        [combo setObjectValue:value];
        CPLog.debug(_cmd + " " + value);
    }
}

- (void)test2:(id)sender
{
    var as = [stackView arrangedSubviews];
    var view = [as objectAtIndex:([as count] - 1)];
    [stackView removeView:view];
    [theWindow setNeedsLayout];
}

- (void)test:(id)sender
{
    var n = [[stackView arrangedSubviews] count];
    var view = [[ColorView alloc] initWithInstrinsicSize:CGSizeMake(50 * (n + 1), 200)];
    [view setOrientation:[stackView orientation]];
    [view setContentHuggingPriority:(252 - n) forOrientation:0];
    [view setContentHuggingPriority:(252 - n) forOrientation:1];
    [view setIdentifier:("View" + [[stackView arrangedSubviews] count])];
    [stackView addArrangedSubview:view];
    [theWindow setNeedsLayout];
}

- (void)setHugging:(id)sender
{
    var k = [sender objectValue];
    [stackView setHuggingPriority:k forOrientation:[stackView orientation]];
    [theWindow setNeedsLayout];
}

- (void)distribute:(id)sender
{
    var d = [sender selectedSegment];
    [stackView setDistribution:d];
    [theWindow setNeedsLayout];
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

    [[stackView views] enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        [view setOrientation:o];
    }];

    [stackView setOrientation:o];
    [theWindow setNeedsLayout];
}

- (void)setSpacing:(id)sender
{
    var k = [sender intValue];
    [stackView setSpacing:k];
    [theWindow setNeedsLayout];
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

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [[CPColor blackColor] set];
    CGContextSetLineWidth(ctx, 3);
    CGContextStrokeRect(ctx, [self bounds]);
}

- (void)mouseDown:(CPEvent)anEvent
{
    CPLog.debug("StackView\n" + [[self constraints] description]);
    CPLog.debug("WindowView\ı" + [[[[self window] _windowView] constraints] description]);
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
