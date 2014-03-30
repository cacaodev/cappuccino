/*
 * AppController.j
 * InvalidateIntrinsicContentSizeTest
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
        CPLog.debug([[self window] _layoutEngine]);
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow compressionWindow;
    @outlet CPWindow huggingWindow;
    @outlet CPWindow sizeToFitButtonWindow;
    @outlet CPWindow sizeToFitLabelWindow;
}

- (void)awakeFromCib
{
    //CPTrace("CPWindow", "setFrameSize:");
    [CPLayoutConstraint setAllowsWebWorker:YES];

    [compressionWindow layout];
    [huggingWindow layout];
    [sizeToFitButtonWindow layout];
    [sizeToFitLabelWindow layout];

}

- (IBAction)changeButtonTitle:(id)sender
{
    var text = [sender stringValue],
        button = [[[sender window] contentView] viewWithTag:1000];

    [button setTitle:text];
}

- (IBAction)changeLabelText:(id)sender
{
    var text = [sender stringValue],
        textField = [[[sender window] contentView] viewWithTag:1000];

    [textField setStringValue:text];
    [textField invalidateIntrinsicContentSize];
}

@end