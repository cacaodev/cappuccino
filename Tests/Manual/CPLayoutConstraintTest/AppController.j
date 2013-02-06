/*
 * AppController.j
 * CPLayoutConstraintTest
 *
 * Created by You on January 23, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <AppKit/CPView.j>

@import "../CPTrace.j"

CPLogRegister(CPLogConsole);

@implementation ColorView : CPView
{
    CPColor color;
}

- (id)awakeFromCib
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

@end

var ID = 1;

@implementation Constraint : CPObject
{
    CPString  name @accessors;
    CPInteger firstItem @accessors;
    CPInteger firstAttribute @accessors;
    CPInteger relation @accessors;
    CPInteger secondItem @accessors;
    CPInteger secondAttribute @accessors;
    float     multiplier @accessors;
    float     constant @accessors;
    CPInteger priority @accessors;
}

- (id)init
{
    self = [super init];

    name = "Constraint " + ID++;
    firstItem = 1;
    firstAttribute = CPLayoutAttributeWidth;
    relation = CPLayoutRelationEqual;
    secondItem = 0;
    secondAttribute = CPLayoutAttributeWidth;
    multiplier = 0.5;
    constant = 0.0;
    priority = 500;

    return self;
}

- (float)constant
{
    return [constant floatValue];
}

- (float)multiplier
{
    return [multiplier floatValue];
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow theWindow;

    @outlet ColorView mainView;
    @outlet ColorView view1;
    @outlet ColorView view2;
    CPArray views;

    CPInteger firstItemIndex;
    CPInteger secondItemIndex;

    CPArray constraints @accessors;
}

- (id)init
{
    self = [super init];

    constraints = [];

    //CPTrace("CPView", "layoutSubtreeWithOldSize:");
    //CPTrace("CPView", "resizeWithOldSuperviewSize:");

    return self;
}

- (IBAction)addConstraints:(id)sender
{
    [constraints enumerateObjectsUsingBlock:function(wrapper, idx, stop)
    {
        var constraint = [self constraintFromWrapper:wrapper];
        [mainView addConstraint:constraint];
    }];

    [mainView setNeedsLayout];
    CPLogConsole("Added Constraints " + [mainView constraints]);
    [sender setEnabled:NO];
}

- (IBAction)addDemoConstraints:(id)sender
{
    var wrapper1 = [[Constraint alloc] init];
    [wrapper1 setPriority:0];
    [wrapper1 setName:@"H:(View1:width) = 0.5x(superview)"];

    var wrapper2 = [[Constraint alloc] init];
    [wrapper2 setFirstItem:1];
    [wrapper2 setFirstAttribute:CPLayoutAttributeWidth];
    [wrapper2 setRelation:CPLayoutRelationLessThanOrEqual];
    [wrapper2 setSecondItem:0];
    [wrapper2 setSecondAttribute:CPLayoutAttributeNotAnAttribute];
    [wrapper2 setMultiplier:1];
    [wrapper2 setConstant:500];
    [wrapper2 setPriority:500];
    [wrapper2 setName:@"H:(View1:width) < 500"];

    var wrapper3 = [[Constraint alloc] init];
    [wrapper3 setFirstItem:2];
    [wrapper3 setFirstAttribute:CPLayoutAttributeLeft];
    [wrapper3 setRelation:CPLayoutRelationEqual];
    [wrapper3 setSecondItem:1];
    [wrapper3 setSecondAttribute:CPLayoutAttributeRight];
    [wrapper3 setMultiplier:1];
    [wrapper3 setConstant:100];
    [wrapper3 setPriority:500];
    [wrapper3 setName:@"H:(view1) - 100 - (view2)"];

    var wrapper4 = [[Constraint alloc] init];
    [wrapper4 setFirstItem:0];
    [wrapper4 setFirstAttribute:CPLayoutAttributeBottom];
    [wrapper4 setRelation:CPLayoutRelationEqual];
    [wrapper4 setSecondItem:1];
    [wrapper4 setSecondAttribute:CPLayoutAttributeBottom];
    [wrapper4 setMultiplier:1];
    [wrapper4 setConstant:100];
    [wrapper4 setPriority:500];
    [wrapper4 setName:@"V:(view1) - 100"];

    var wrapper5 = [[Constraint alloc] init];
    [wrapper5 setFirstItem:0];
    [wrapper5 setFirstAttribute:CPLayoutAttributeBottom];
    [wrapper5 setRelation:CPLayoutRelationEqual];
    [wrapper5 setSecondItem:2];
    [wrapper5 setSecondAttribute:CPLayoutAttributeBottom];
    [wrapper5 setMultiplier:1];
    [wrapper5 setConstant:100];
    [wrapper5 setPriority:500];
    [wrapper5 setName:@"V:(view2) - 100"];

    var wrapper6 = [[Constraint alloc] init];
    [wrapper6 setFirstItem:2];
    [wrapper6 setFirstAttribute:CPLayoutAttributeWidth];
    [wrapper6 setRelation:CPLayoutRelationEqual];
    //[wrapper6 setSecondItem:0];
    [wrapper6 setSecondAttribute:CPLayoutAttributeNotAnAttribute];
    [wrapper6 setMultiplier:1];
    [wrapper6 setConstant:200];
    [wrapper6 setPriority:1000];
    [wrapper6 setName:@"H:(view2:width) = 200"];

    [self willChangeValueForKey:@"constraints"];
    [constraints addObjectsFromArray:[wrapper4, wrapper5, wrapper3, wrapper6, wrapper1, wrapper2]];
    [self didChangeValueForKey:@"constraints"];

    //[mainView setNeedsLayout];
}

- (IBAction)logMetrics:(id)sender
{
    CPLog.debug("mainView " + CGStringFromRect([mainView frame]) + "\nleftView " + CGStringFromRect([view1 frame]) + "\nrightView " + CGStringFromRect([view2 frame]));
}

- (CPLayoutConstraint)constraintFromWrapper:(Constraint)aConstraint
{
    var firstItem = [views objectAtIndex:[aConstraint firstItem]];
    var secondItem = [views objectAtIndex:[aConstraint secondItem]];

    var constraint =  [CPLayoutConstraint constraintWithItem:firstItem attribute:[aConstraint firstAttribute] relatedBy:[aConstraint relation] toItem:secondItem attribute:[aConstraint secondAttribute] multiplier:[aConstraint multiplier] constant:[aConstraint constant]];

    [constraint setPriority:[aConstraint priority]];

    return constraint;
}

- (void)awakeFromCib
{
    views = [mainView, view1, view2];

    [theWindow setFullPlatformWindow:YES];
}

@end