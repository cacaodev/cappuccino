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

-(void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent type] == CPLeftMouseDown && ([anEvent modifierFlags] & CPCommandKeyMask))
        CPLog.debug([[self window] _layoutEngine]);
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow theWindow;
}

- (void)awakeFromCib
{
    //CPTrace("CPWindow", "setFrameSize:");
}

@end