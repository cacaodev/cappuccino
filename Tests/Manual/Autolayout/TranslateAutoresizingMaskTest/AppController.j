/*
 * AppController.j
 * TranslateAutoresizingMaskTest
 *
 * Created by You on May 13, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

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
        CPLog.debug([[[self window] _layoutEngine] description]);
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

    if (identifier && [identifier length] > 0)
    {
        var selColor = CPSelectorFromString(identifier);

        if ([CPColor respondsToSelector:selColor])
            color = [CPColor performSelector:selColor];
    }

    [super viewDidMoveToSuperview];
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
    var view = [[CPView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [view setIdentifier:@"autoresizingMaskView"];
    [view setBackgroundColor:[CPColor randomColor]];
    [view setAutoresizingMask:[maskField intValue]];

    [greenView addSubview:view];
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
}

@end
