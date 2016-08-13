/*
 * AppController.j
 * IBGeneratedConstraints
 *
 * Created by You on November 3, 2014.
 * Copyright 2014, Your Company All rights reserved.
 *
 * This test application has 2 purposes:
 * 1- Test that the missing constraints for a view are correctly autogenerated and nib2cibed (no errors in nib2cib).
 * This seems to be a new feauture in Xcode 6
 * 2 - Test the active property. A constraint is activated / desactivated when clicking a button. This way of adding constraints is easier and does not require to specify who will own the constraint.
   After a constraint is added/removed, you can hit the Layout button to update the window and contentView subtree.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

CPLogRegister(CPLogConsole);

@implementation ColorView : CPView
{
    CPColor color;
}

- (void)viewDidMoveToSuperview
{
    var identifier = [self identifier];

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

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
    @outlet ColorView   view;
    CPLayoutConstraint  constraint @accessors;
}

- (void)awakeFromCib
{
    var cst = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationLessThanOrEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:400];

    [self setConstraint:cst];
    // In this case, we want the window from Cib to become our full browser window
    [theWindow setAutolayoutEnabled:YES];
    [theWindow setFullPlatformWindow:NO];
}

- (@action)activate:(id)sender
{
    [constraint setActive:[sender state]];
}

- (@action)setConstant:(id)sender
{
    var constant = [sender intValue];
    [constraint setConstant:constant];
}

- (@action)layout:(id)sender
{
    [theWindow setNeedsLayout];
}

@end