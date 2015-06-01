//
//  StackView.m
//  ConstraintBasedImageAndText
//
//  Created by x on 29/05/15.
//  Copyright (c) 2015 x. All rights reserved.
//
@import <AppKit/CPView.j>
@import "Container.j"

#define STACK_VIEW_INSET 2.0
#define CGRectZero CGRectMakeZero()
#define CPRectFill(aRect) var ctx = [[CPGraphicsContext currentContext] graphicsPort];\
                          CGContextFillRect(ctx, aRect);\

#define CPRectStroke(aRect) var ctx = [[CPGraphicsContext currentContext] graphicsPort];\
                            CGContextStrokeRect(ctx, aRect);\

@implementation StackView : CPView
{
    float defaultWidth;
    CPMutableArray containers @accessors;
}

- (void)mouseDown:(CPEvent)anEvent
{
    CPLog.debug([self _layoutEngine]);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];

        defaultWidth = 10;
        containers = [CPMutableArray array];

        [self _addContainerWithCompressionPriority:CPLayoutPriorityDefaultLow+1];
        [self _addContainerWithCompressionPriority:CPLayoutPriorityDefaultLow+2];
        [self _addContainerWithCompressionPriority:CPLayoutPriorityDefaultLow];

        [self setNeedsUpdateConstraints:YES];
    }

    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self alignViews:containers orientation:CPLayoutConstraintOrientationHorizontal];
}

- (void)_addContainerWithCompressionPriority:(CPLayoutPriority)aPriority
{
    var container = [Container containerWithIntrinsicSize:CGSizeMake(defaultWidth, 50)];
    [container setContentCompressionResistancePriority:aPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [container setIdentifier:("Container_" + [containers count])];
    [self addSubview:container];
    [containers addObject:container];
}

- (void)drawRect:(CGRect)dirtyRect
{
    [[CPColor lightGrayColor] setStroke];
    CPRectStroke([self bounds]);
}

- (void)setContentCompressionResistancePriority:(CPLayoutPriority)priority inGravity:(CPInteger)aGravity
{
    var container = containers[aGravity];

    [container setContentCompressionResistancePriority:priority forOrientation:CPLayoutConstraintOrientationHorizontal];
}

- (void)setViews:(CPArray)theViews inGravity:(CPInteger)aGravity
{
    var container = containers[aGravity];
    [container setViews:theViews];
}

- (void)alignViews:(CPArray)views orientation:(CPLayoutConstraintOrientation)orientation
{
    var constraints = [CPMutableArray array];
    var count = [views count];

    [views enumerateObjectsUsingBlock:function(container, idx, stop)
     {
        if (![container isKindOfClass:[Container class]])
            return;

         var leftConstraint;

         if (idx == 0)
             leftConstraint = [CPLayoutConstraint constraintWithItem:container attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:self attribute:CPLayoutAttributeLeft multiplier:1 constant:STACK_VIEW_INSET];
         else
             leftConstraint = [CPLayoutConstraint constraintWithItem:container attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:views[idx -1] attribute:CPLayoutAttributeRight multiplier:1 constant:STACK_VIEW_INSET];

         [constraints addObject:leftConstraint];

         if (idx == count - 1)
         {
             var rightConstraint = [CPLayoutConstraint constraintWithItem:self attribute:CPLayoutAttributeRight relatedBy:CPLayoutRelationEqual toItem:container attribute:CPLayoutAttributeRight multiplier:1 constant:STACK_VIEW_INSET];

             [constraints addObject:rightConstraint];
         }

         var widthconstraint = [CPLayoutConstraint constraintWithItem:container attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationGreaterThanOrEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:0];

         var bottomconstraint = [CPLayoutConstraint constraintWithItem:self attribute:CPLayoutAttributeBottom relatedBy:CPLayoutRelationEqual toItem:container attribute:CPLayoutAttributeBottom multiplier:1 constant:STACK_VIEW_INSET];

         var topconstraint = [CPLayoutConstraint constraintWithItem:container attribute:CPLayoutAttributeTop relatedBy:CPLayoutRelationEqual toItem:self attribute:CPLayoutAttributeTop multiplier:1 constant:STACK_VIEW_INSET];

         [constraints addObject:widthconstraint];
         [constraints addObject:bottomconstraint];
         [constraints addObject:topconstraint];
     }];

    [CPLayoutConstraint activateConstraints:constraints];
}

@end