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

@implementation ConstraintView : ColorView
{
}

@end

@implementation NoConstraintView : ColorView
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

@implementation NoConstraintWindow : CPWindow
{
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

    [self _showWindowCibName:@"Constraints"];
    [self _showWindowCibName:@"NoConstraints"];

    var avg = moving_averager(20),
        avg2 = moving_averager(10);

    CPTrace("ConstraintWindow", "_setFrame:display:animate:constrainWidth:constrainHeight:", function(receiver, selector, args, duration)
    {
        console.log("%c Autolayout: setFrame: = " + duration + "(ms), average(20) =" + avg(duration) + "(ms)", 'color:green; font-weight:bold');
    });

    CPTrace("NoConstraintWindow", "_setFrame:display:animate:constrainWidth:constrainHeight:", function(receiver, selector, args, duration)
    {
        console.log("%c Autosize: setFrame: = " + duration + " average(20) =" + avg2(duration) + "(ms)", 'color:gray; font-weight:bold');
    });
}

- (void)_showWindowCibName:(CPString)aWindowCibName
{
    var currentController = [[CPWindowController alloc] initWithWindowCibName:aWindowCibName];

    [currentController showWindow:nil];

    var window = [currentController window];
    [window setTitle:aWindowCibName];

    [window setAutolayoutEnabled:(aWindowCibName == @"Constraints")];
}

@end