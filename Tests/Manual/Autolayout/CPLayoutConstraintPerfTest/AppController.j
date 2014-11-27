/*
 * AppController.j
 * CPLayoutConstraintPerfTest
 *
 * Created by You on January 23, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */
@import <AppKit/CPView.j>
@import <Foundation/CPObject.j>
@import "../../CPTrace.j"

CPLogRegister(CPLogConsole);

@implementation ColorView : CPView
{
    CPColor color;
}

- (void)viewDidMoveToSuperview
{
    [self setColor:[CPColor randomColor]];
}

- (void)setColor:(CPColor)aColor
{
    color = aColor;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [color set];

    CGContextFillRect(ctx, [self bounds]);
}

@end

@implementation NoConstraintWindow : CPWindow
{
}

- (void)_setFrame:(CGRect)aRect display:(BOOL)display animate:(BOOL)animate constrainWidth:(BOOL)width constrainHeight:(BOOL)height
{
    [self __setFrame:aRect display:display animate:animate constrainWidth:width constrainHeight:height];
}

- (void)__setFrame:(CGRect)aRect display:(BOOL)display animate:(BOOL)animate constrainWidth:(BOOL)width constrainHeight:(BOOL)height
{
    [super _setFrame:aRect display:display animate:animate constrainWidth:width constrainHeight:height];
}

@end

@implementation ConstraintWindow : CPWindow
{
}

- (void)_setFrame:(CGRect)aRect display:(BOOL)display animate:(BOOL)animate constrainWidth:(BOOL)width constrainHeight:(BOOL)height
{
    [self __setFrame:aRect display:display animate:animate constrainWidth:width constrainHeight:height];
}

- (void)__setFrame:(CGRect)aRect display:(BOOL)display animate:(BOOL)animate constrainWidth:(BOOL)width constrainHeight:(BOOL)height
{
    [super _setFrame:aRect display:display animate:animate constrainWidth:width constrainHeight:height];
}

@end

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    [theWindow orderFront:self];

    var autoSizeWindow = [[NoConstraintWindow alloc] initWithContentRect:CGRectMake(0, 20, 600, 600) styleMask:CPResizableWindowMask],
        autosizeContentView = [autoSizeWindow contentView];

    var constraintsWindow = [[ConstraintWindow alloc] initWithContentRect:CGRectMake(610, 20, 600, 600) styleMask:CPResizableWindowMask],
        constraintContentView = [constraintsWindow contentView];
    [constraintsWindow setAutolayoutEnabled:YES];
    [constraintContentView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [constraintContentView setIdentifier:@"ContentView"];

    var xmasks = [CPViewMaxXMargin, CPViewMinXMargin | CPViewMaxXMargin, CPViewMinXMargin],
        ymasks = [CPViewMaxYMargin, CPViewMinYMargin | CPViewMaxYMargin, CPViewMinYMargin],
        maxDepth = 3,
        num = 3;

    var autoSizeBlock = function(num, rect, level, idx)
    {
        var xmask = xmasks[(idx % num)],
            ymask = ymasks[FLOOR(idx/num)];

        var mask = xmask | ymask | CPViewWidthSizable | CPViewHeightSizable;

        var view = [[ColorView alloc] initWithFrame:rect];
        [view setAutoresizingMask:mask];
        [view setIdentifier:[CPString stringWithFormat:@"view_%d_%d" , (maxDepth - level), idx]];

        return view;
    };

    var autoSizeSubviews = [self recursivelyAddNumViews:num toSuperview:autosizeContentView maxDepth:maxDepth withBlock:autoSizeBlock];

    var constraintSubviews = [self recursivelyAddNumViews:num toSuperview:constraintContentView maxDepth:maxDepth withBlock:function(num, rect, level, idx)
    {
        var view = autoSizeBlock(num, rect, level, idx);
        // The default is currently NO, but YES in cocoa.
        [view setTranslatesAutoresizingMaskIntoConstraints:YES];

        return view;
    }];

    [autoSizeWindow setTitle:"Autosize"];
    [constraintsWindow setTitle:"Autolayout"];

    [autoSizeWindow orderFront:self];
    [constraintsWindow orderFront:self];
/*
    var avg = moving_averager(10),
        avg2 = moving_averager(10);

    CPTrace("ConstraintWindow", "_setFrame:display:animate:constrainWidth:constrainHeight:", function(receiver, selector, args, duration)
    {
        console.log("%c Autolayout: setFrame: = " + duration + "(ms), average(20) =" + avg(duration) + "(ms)", 'color:green; font-weight:bold');
    });

    CPTrace("NoConstraintWindow", "_setFrame:display:animate:constrainWidth:constrainHeight:", function(receiver, selector, args, duration)
    {
        console.log("%c Autosize: setFrame: = " + duration + " average(20) =" + avg2(duration) + "(ms)", 'color:gray; font-weight:bold');
    });
*/
}

- (void)recursivelyAddNumViews:(CPInteger)num toSuperview:(CPView)aSuperview maxDepth:(int)maxDepth withBlock:(Function)aBlock
{
    if (maxDepth == 0)
        return;

    var size = CGRectGetWidth([aSuperview frame]) / num;

    for (var i = 0; i < (num*num); i++)
    {
        var x = (i % num) * size,
            y = FLOOR(i / num) * size,
            rect = CGRectMake(x, y, size, size);

        var subview = aBlock(num, rect, maxDepth, i);

        [aSuperview addSubview:subview];

        [self recursivelyAddNumViews:num toSuperview:subview maxDepth:(maxDepth-1) withBlock:aBlock];
    }
}

@end