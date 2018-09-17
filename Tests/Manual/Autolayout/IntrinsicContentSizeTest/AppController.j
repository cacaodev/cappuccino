/*
 * AppController.j
 * IntrinsicSizes
 *
 * Created by You on November 6, 2016.
 * Copyright 2016, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
}

- (IBAction)showAlignRects:(id)sender
{
    var showAlignRects = [sender state];
    [[theWindow contentView] setShowAlignRects:showAlignRects];
}

- (IBAction)fitAll:(id)sender
{
    var contentView = [theWindow contentView];
    var p = [sender state] ? CPLayoutPriorityDefaultLow : CPLayoutPriorityRequired;

    [[contentView subviews] enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        [[view constraints] enumerateObjectsUsingBlock:function(cst, idx, stop)
        {
            if ([cst _constraintType] == @"Constraint" && ([cst firstAnchor] == [view widthAnchor]
                 && [view intrinsicContentSize].width != CPViewNoInstrinsicMetric) || ([cst firstAnchor] == [view heightAnchor]
                      && [view intrinsicContentSize].height != CPViewNoInstrinsicMetric))
            {
                [cst setPriority:p];
            }
        }];
    }];

    [contentView layoutSubtreeIfNeeded];
    [contentView setNeedsDisplay:YES];
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
}

@end

@implementation ContentView : CPView
{
    BOOL showAlignRects;
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    showAlignRects = NO;

    return self;
}

- (void)setShowAlignRects:(BOOL)show
{
    showAlignRects = show;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(CGRect)aRect
{
    if (!showAlignRects)
        return;

    var context = [[CPGraphicsContext currentContext] graphicsPort];

    [[self subviews] enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        if ([view tag] !== 999)
            [self drawAlignmentRectForView:view inContext:context];
    }];
}

- (void)drawAlignmentRectForView:(CPView)aView inContext:(id)aContext
{
    var frameRect = [aView frame],
        bounds = [self bounds],
        alignmentRect = [aView alignmentRectForFrame:frameRect],
        offset = 15,
        lw = aContext.lineWidth;

    CGContextSetFillColor(aContext, [CPColor colorWithRed:0.8 green:0.8 blue:1 alpha: 0.3]);
    CGContextFillRect(aContext, frameRect);

    var minx = CGRectGetMinX(alignmentRect),
        maxx = CGRectGetMaxX(alignmentRect),
        miny = CGRectGetMinY(alignmentRect),
        maxy = CGRectGetMaxY(alignmentRect);

    CGContextSetStrokeColor(aContext, [CPColor redColor]);
    CGContextStrokeLineSegments(aContext, [CGPointMake(minx - offset, miny - lw), CGPointMake(maxx + offset, miny - lw),
                                           CGPointMake(minx - offset, maxy), CGPointMake(maxx + offset, maxy),
                                           CGPointMake(minx - lw, miny - offset), CGPointMake(minx - lw, maxy + offset),
                                           CGPointMake(maxx, miny - offset), CGPointMake(maxx, maxy + offset)], 8);

    CGContextBeginPath(aContext);
    CGContextMoveToPoint(aContext, minx - offset, (miny + maxy) / 2);
    CGContextAddLineToPoint(aContext, maxx + offset, (miny + maxy) / 2);
    CGContextClosePath(aContext);
    CGContextSetStrokeColor(aContext, [CPColor greenColor]);
    CGContextStrokePath(aContext);
}

@end
