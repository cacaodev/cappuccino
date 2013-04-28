/*
 * AppController.j
 * CPLayoutConstraintPerfTest
 *
 * Created by You on January 23, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

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

- (void)resizeWithOldSuperviewSize:(CGSize)aSize
{
    [self _resizeWithOldSuperviewSize:aSize];
}

- (void)_resizeWithOldSuperviewSize:(CGSize)aSize
{
    [super resizeWithOldSuperviewSize:aSize];
}

@end

@implementation NoConstraintView : ColorView
{
}

- (void)resizeWithOldSuperviewSize:(CGSize)aSize
{
    [self _resizeWithOldSuperviewSize:aSize];
}

- (void)_resizeWithOldSuperviewSize:(CGSize)aSize
{
    [super resizeWithOldSuperviewSize:aSize];
}

@end

@implementation WindowController : CPWindowController
{
}

- (void)loadWindow
{
    if (_window)
        return;

    var owner = _cibOwner || self;

    [[CPBundle mainBundle] loadCibFile:[self windowCibPath] externalNameTable:@{ CPCibOwner: owner }];
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

    CPTrace("ConstraintView", "_resizeWithOldSuperviewSize:");
    CPTrace("NoConstraintView", "_resizeWithOldSuperviewSize:");
}

- (void)_showWindowCibName:(CPString)aWindowCibName
{
    var currentController = [[WindowController alloc] initWithWindowCibName:aWindowCibName owner:nil];

    [currentController showWindow:nil];

    var window = [currentController window];
    [window center];
    [window setTitle:aWindowCibName];
}

@end