/*
 * AppController.j
 * WorkerTest
 *
 * Created by You on May 13, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

#define ALLOW_CLASS_OVERRIDE

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
//@import "CPLayoutConstraintEngine.j"

CPLogRegister(CPLogConsole);

@implementation ConstraintView : CPView

- (void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent type] !== CPLeftMouseDown)
        return;
    var flags = [anEvent modifierFlags];

    if (flags & CPAlternateKeyMask)
    {
        CPLog.debug([self identifier] + "\n" + [[self constraints] description]);
    }

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

@implementation ColorView : ConstraintView
{
    CPColor color;
}

- (void)viewDidMoveToSuperview
{
    var identifier = [self identifier];
CPLog.debug(identifier);
    if (identifier)
    {
        var selColor = CPSelectorFromString(identifier);

        if ([CPColor respondsToSelector:selColor])
            color = [CPColor performSelector:selColor];
    }

    [self setNeedsDisplay:YES];
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [color set];

    CGContextFillRect(ctx, [self bounds]);
}

@end

@implementation CPPopUpButtonBaseline : CPPopUpButton

- (float)baselineOffsetFromBottom
{
    return 4.0;
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
    @outlet ColorView   greenView;
    @outlet CPTextField maskField;
}

- (IBAction)addView:(id)sender
{
    var view = [[ColorView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [view setIdentifier:@"orangeColor"];
    [view setAutoresizingMask:[maskField intValue]];
    [view setTranslatesAutoresizingMaskIntoConstraints:YES];

    [greenView addSubview:view];
    //[view setNeedsUpdateConstraints:YES];
    [greenView setNeedsUpdateConstraints:YES];
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // Uncomment to disable Web Worker
    //[CPLayoutConstraintEngine setAllowsWebWorker:NO];
    [theWindow layout];
}

@end
