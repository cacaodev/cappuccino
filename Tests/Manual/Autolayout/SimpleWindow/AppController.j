/*
 * AppController.j
 * SimpleWindow
 *
 * Created by You on June 11, 2018.
 * Copyright 2018, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(200,200,500,500) styleMask:CPTitledWindowMask|CPResizableWindowMask],
        contentView = [theWindow contentView];

    [contentView setBackgroundColor:[CPColor redColor]];

    [theWindow setTitle:@"SimpleWindow"];
    [contentView setIdentifier:@"contentView"];
    // Enable Autolayout in this window.
    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];

    var label = [[ColorView alloc] initWithFrame:CGRectMake(200,200,200,200)];
    [label setIdentifier:@"blueColor"];
    [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    [label setCenter:[contentView center]];
    //[label setNeedsLayout];

    [contentView addSubview:label];

    [theWindow orderFront:self];
    //[theWindow setNeedsLayout];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

@end

@implementation ColorView : CPView
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
