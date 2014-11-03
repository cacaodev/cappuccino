/*
 * AppController.j
 * CPLayoutConstraintCibTest
 *
 * Created by You on January 23, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <AppKit/CPView.j>

//@import "../CPTrace.j"

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

- (void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent type] !== CPLeftMouseDown)
        return;
    var flags = [anEvent modifierFlags];

    if (flags & CPCommandKeyMask)
    {
        CPLog.debug([self identifier] + " " + CPStringFromRect([self frame]));
        CPLog.debug([[[self window] _layoutEngine] getInfo]);
    }

    if (flags & CPShiftKeyMask)
    {
        CPLog.debug([[[self window] _layoutEngine] sendCommand:"getconstraints" withArguments:null]);
    }
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow theWindow;
    @outlet CPButton middleButton;
}

- (void)awakeFromCib
{
    [CPLayoutConstraintEngine setAllowsWebWorker:NO];
    [theWindow layout];
    //CPTrace("CPWindow", "setFrameSize:");
}

- (IBAction)changeText:(id)sender
{
    [middleButton setTitle:[sender stringValue]];
}

@end