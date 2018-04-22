/*
 * AppController.j
 * CPLayoutAnchorTest
 *
 * Created by You on August 10, 2016.
 * Copyright 2016, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(200,200,800,400) styleMask:CPResizableWindowMask|CPTitledWindowMask],
        contentView = [theWindow contentView];
    [contentView setIdentifier:@"contentView"];
// Enable Autolayout in this window.
    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];

// Create left, middle and right views.
    var leftView = [[ColorView alloc] initWithFrame:CGRectMakeZero()];
    [leftView setIdentifier:@"leftView"];
    [leftView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:leftView];

    var middleView = [[ColorView alloc] initWithFrame:CGRectMakeZero()];
    [middleView setIdentifier:@"middleView"];
    [middleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:middleView];

    var rightView = [[ColorView alloc] initWithFrame:CGRectMakeZero()];
    [rightView setIdentifier:@"rightView"];
    [rightView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:rightView];

// Anchor the left and right views in the window and give them a default dimension.
    var left1 = [[leftView leftAnchor] constraintEqualToAnchor:[contentView leftAnchor] constant:100],
        top1  = [[leftView topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:100],
        width1 = [[leftView widthAnchor] constraintEqualToConstant:200],
        height1 = [[leftView heightAnchor] constraintEqualToConstant:200];

    var left2 = [[rightView rightAnchor] constraintEqualToAnchor:[contentView rightAnchor] constant:-100],
        top2  = [[rightView topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:100],
        width2 = [[rightView widthAnchor] constraintEqualToConstant:200],
        height2 = [[rightView heightAnchor] constraintEqualToConstant:200];

// constrain the middle view to be centered between the two other views.
    var midXAnchor = [[leftView rightAnchor] anchorAtMidpointToAnchor:[rightView leftAnchor]]; // Creates a CPCompositeLayoutAxisAnchor.
    var middleConstraintX = [midXAnchor constraintEqualToAnchor:[middleView centerXAnchor]];
// Center vertically
    var middleConstraintY = [[leftView centerYAnchor] constraintEqualToAnchor:[middleView centerYAnchor]];
// Give a fixed dimension to this view.
    var middleConstraintW = [[middleView widthAnchor] constraintEqualToConstant:200];
    var middleConstraintH = [[middleView heightAnchor] constraintEqualToConstant:200];

// Views are horizontally ordered and do not overlap.
    [[[leftView rightAnchor] constraintLessThanOrEqualToAnchor:[middleView leftAnchor] constant:-10] setActive:YES];
    [[[middleView rightAnchor] constraintLessThanOrEqualToAnchor:[rightView leftAnchor] constant:-10] setActive:YES];
    [[[leftView leftAnchor] constraintLessThanOrEqualToAnchor:[middleView leftAnchor] constant:-10] setActive:YES];

// Views cannot be compressed less than a minimum width.
    var minLeftWidth = [[leftView widthAnchor] constraintGreaterThanOrEqualToConstant:50];
    var minMiddleWidth = [[middleView widthAnchor] constraintGreaterThanOrEqualToConstant:50];
    var minRightWidth = [[rightView widthAnchor] constraintGreaterThanOrEqualToConstant:50];

    [width1 setPriority:200];
    [width2 setPriority:400];
    [middleConstraintW setPriority:300];

    [CPLayoutConstraint activateConstraints:@[left1, top1, width1, height1, left2, top2, width2, height2]];
    [CPLayoutConstraint activateConstraints:@[middleConstraintX, middleConstraintY, middleConstraintW, middleConstraintH]];
    [CPLayoutConstraint activateConstraints:@[minLeftWidth, minMiddleWidth, minRightWidth]];

    [theWindow orderFront:self];
}

@end

@implementation ColorView : CPView
{
    CPColor color;
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    color = [CPColor randomColor];

    return self;
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [color set];
    CGContextFillRect(ctx, [self bounds]);

    [[CPColor blackColor] set];
    var path = [CPBezierPath bezierPathWithOvalInRect:[self bounds]];
    [path stroke];
}

@end
