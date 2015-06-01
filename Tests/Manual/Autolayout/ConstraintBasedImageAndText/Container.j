//
//  Container.m
//  ConstraintBasedImageAndText
//
//  Created by x on 29/05/15.
//  Copyright (c) 2015 x. All rights reserved.
//

@import <AppKit/CPView.j>

#define CGRectZero CGRectMakeZero()
#define CPRectFill(aRect) var ctx = [[CPGraphicsContext currentContext] graphicsPort];\
                          CGContextFillRect(ctx, aRect);\

#define CPRectStroke(aRect) var ctx = [[CPGraphicsContext currentContext] graphicsPort];\
                            CGContextSetLineDash (ctx, 0, [2,2], 2);\
                            CGContextStrokeRect(ctx, aRect);\

@implementation Container : CPView
{
    CGSize          m_intrinsicContentSize @accessors(property=_intrinsicContentSize);
    CGSize          defaultIntrinsicSize @accessors;
    CPMutableArray  subviewsConstraints    @accessors;
    BOOL            hasSubviews;
}

+ (Container)containerWithIntrinsicSize:(CGSize)intrinsicSize
{
    var container = [[Container alloc] initWithFrame:CGRectMakeZero()];

    [container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [container _setIntrinsicContentSize:intrinsicSize];
    [container setDefaultIntrinsicSize:intrinsicSize];

    [container setContentCompressionResistancePriority:CPLayoutPriorityDefaultLow forOrientation:CPLayoutConstraintOrientationHorizontal];

    [container setContentHuggingPriority:CPLayoutPriorityRequired forOrientation:CPLayoutConstraintOrientationHorizontal];

    [container setNeedsUpdateConstraints:YES];

    return container;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    m_intrinsicContentSize = CGRectMake(-1, -1);
    subviewsConstraints = [CPMutableArray array];
    hasSubviews = NO;

    return self;
}

- (void)setViews:(CPArray)views
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    var count = [views count];
    hasSubviews = (count > 0);

    if (count == 0)
    {
        [self setContentCompressionResistancePriority:CPLayoutPriorityDefaultLow forOrientation:CPLayoutConstraintOrientationHorizontal];

        [self setIntrinsicContentWidth:defaultIntrinsicSize.width];

        return;
    }

    var maxPriority = 0;

    [views enumerateObjectsUsingBlock:function(view, idx, stop)
     {
         [view setTranslatesAutoresizingMaskIntoConstraints:NO];
         [view setContentHuggingPriority:CPLayoutPriorityRequired forOrientation:CPLayoutConstraintOrientationVertical];

         [view setContentHuggingPriority:CPLayoutPriorityDefaultLow  forOrientation:CPLayoutConstraintOrientationHorizontal];

         var p = [view contentCompressionResistancePriorityForOrientation:CPLayoutConstraintOrientationHorizontal];

         maxPriority = MAX(maxPriority, p);

         [self addSubview:view];
         [view setNeedsUpdateConstraints:YES];
     }];

    var sorted = [views sortedArrayUsingFunction:sortIntrinsicWidth context:NULL];
    var maxWidthView = [sorted lastObject];

    [maxWidthView setContentHuggingPriority:CPLayoutPriorityRequired forOrientation:CPLayoutConstraintOrientationHorizontal];

    [self setContentCompressionResistancePriority:maxPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    var maxWidth = [maxWidthView intrinsicContentSize].width;
    [self setIntrinsicContentWidth:maxWidth];
}

- (void)updateConstraints
{
    [super updateConstraints];

    [CPLayoutConstraint deactivateConstraints:subviewsConstraints];
    [subviewsConstraints removeAllObjects];

    [[self subviews] enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        var leftconstraint = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationGreaterThanOrEqual toItem:self attribute:CPLayoutAttributeLeft multiplier:1 constant:0];

        var rightconstraint = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeRight relatedBy:CPLayoutRelationGreaterThanOrEqual toItem:self attribute:CPLayoutAttributeRight multiplier:1 constant:0];

        var centerXConstraint = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeCenterX relatedBy:CPLayoutRelationEqual toItem:self attribute:CPLayoutAttributeCenterX multiplier:1 constant:0];

        var bottomconstraint = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeBottom relatedBy:CPLayoutRelationGreaterThanOrEqual toItem:self attribute:CPLayoutAttributeBottom multiplier:1 constant:0];

        var topconstraint = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeTop relatedBy:CPLayoutRelationGreaterThanOrEqual toItem:self attribute:CPLayoutAttributeTop multiplier:1 constant:0];

        var centerYConstraint = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeCenterY relatedBy:CPLayoutRelationEqual toItem:self attribute:CPLayoutAttributeCenterY multiplier:1 constant:0];

        [subviewsConstraints addObjectsFromArray:@[leftconstraint, rightconstraint, centerXConstraint, bottomconstraint, topconstraint, centerYConstraint]];
    }];

    [CPLayoutConstraint activateConstraints:subviewsConstraints];
}

- (void)drawRect:(CGRect)dirtyRect
{
    [[CPColor lightGrayColor] set];

    if (hasSubviews)
    {
        CPRectStroke([self bounds]);
    }
    else
    {
        CPRectFill([self bounds]);
    }
}

- (void)setIntrinsicContentWidth:(float)aWidth
{
    m_intrinsicContentSize = CGSizeMake(aWidth, m_intrinsicContentSize.height);

    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize
{
    return m_intrinsicContentSize;
}

@end

var sortIntrinsicWidth = function(view1, view2, context)
{
    var intrinsic1 = [view1 intrinsicContentSize].width;
    var intrinsic2 = [view2 intrinsicContentSize].width;

    if (intrinsic1 > intrinsic2)
        return 1;
    else if (intrinsic1 < intrinsic2)
        return -1;
    else
        return 0;
};

