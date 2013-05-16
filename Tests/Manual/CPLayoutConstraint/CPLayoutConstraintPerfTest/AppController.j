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

- (void)mouseDown:(CPEvent)anEvent
{
    [[self _layoutEngine] getInfo];
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

    var avg = moving_averager(20),
        avg2 = moving_averager(10);


    CPTrace("CPWindow", "_setFrame:display:animate:constrainWidth:constrainHeight:", function(receiver, selector, args, duration)
    {
        console.log("CPWindow: setFrame: in " + duration + " average(20) in " + avg(duration));
    });
/*
    CPTrace("NoConstraintView", "_resizeWithOldSuperviewSize:", function(receiver, selector, args, duration)
    {
        if (duration < 10)
        {
            TOTAL_COUNT++;
            TOTAL_DURATION += duration;
        }

        console.log("Autosizing: -resizeWithOldSuperviewSize: in " + duration + " avg = " + avg2(TOTAL_DURATION / TOTAL_COUNT));
    });
*/
}

- (void)_showWindowCibName:(CPString)aWindowCibName
{
    var currentController = [[WindowController alloc] initWithWindowCibName:aWindowCibName owner:nil];

    [currentController showWindow:nil];

    var window = [currentController window];
    [window setTitle:aWindowCibName];
}

@end