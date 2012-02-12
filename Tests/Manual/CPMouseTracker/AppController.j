/*
 * AppController.j
 * CPMouseTracker
 *
 * Created by You on February 11, 2012.
 * Copyright 2012, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "CPMouseTracker.j"

@implementation AppController : CPObject
{
    CPWindow    theWindow; //this "outlet" is connected automatically by the Cib
    @outlet CPView      aView;
    @outlet CPTextField constraintField;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
}

- (IBAction)setTrackingConstraint:(id)sender
{
    var value = [sender intValue];
    
    [[aView mouseTracker] setTrackingConstraint:value];
    [constraintField setIntValue:value];
}

- (IBAction)setTrackingConstraintKeyMask:(id)sender
{
    var mask = ([sender state] == CPOnState) ? CPCommandKeyMask : 0;
    [[aView mouseTracker] setTrackingConstraintKeyMask:mask];
}

@end

@implementation CustomView : CPView
{
    CPMouseTracker mouseTracker @accessors;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        mouseTracker = [[CPMouseTracker alloc] init];
    }
    
    return self;
}

- (void)mouseDown:(CPEvent)theEvent
{
    [mouseTracker trackWithEvent:theEvent inView:self withDelegate:self];
}

- (BOOL)mouseTracker:(CPMouseTracker)tracker shouldStartTrackingWithEvent:(CPEvent)anEvent
{
    CPLogConsole( _cmd + [anEvent type]);
    
    return YES;
}

- (BOOL)mouseTracker:(CPMouseTracker)tracker shouldContinueTrackingWithEvent:(CPEvent)anEvent
{
    CPLogConsole(_cmd);
    
    [self setNeedsDisplay:YES];
    return CGRectContainsPoint([self frame], [anEvent locationInWindow]);
}

- (void)mouseTracker:(CPMouseTracker)tracker didStopTrackingWithEvent:(CPEvent)anEvent
{
    CPLogConsole(_cmd);
    [self setNeedsDisplay:YES];
}

- (CGPoint)mouseTracker:(CPMouseTracker)tracker constrainPoint:(CGPoint)aPoint withEvent:(CPEvent)anEvent
{
    var maxx = MAX(50, MIN(CGRectGetWidth([self frame]) - 50, aPoint.x));
    
    return CGPointMake(maxx, aPoint.y);
}
/*
- (void)mouseTracker:(CPMouseTracker)tracker handlePeriodicEvent:(CPEvent)anEvent
{
    CPLogConsole( _cmd + [anEvent type]);
}
*/
- (void)drawRect:(CPRect)dirtyRect
{
    var context = [[CPGraphicsContext currentContext] graphicsPort];
    
    [[CPColor redColor] set];
    CGContextFillRect(context, dirtyRect);

    [[CPColor greenColor] set];
    CGContextFillRect(context, CGRectInset(dirtyRect, 50, 0));
    
    [[CPColor blackColor] set];
    
    var current = [mouseTracker currentPoint],
        initial = [mouseTracker initialPoint];
    
    var box = CGRectMake(initial.x, initial.y, current.x - initial.x, current.y - initial.y);
    CGContextStrokeRect(context, box);
}

@end
