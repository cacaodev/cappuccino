/*
 * AppController.j
 * CPLayoutConstraintTest
 *
 * Created by You on January 23, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <AppKit/CPView.j>

// @import "../CPTrace.j"

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

- (void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent type] == CPLeftMouseDown && ([anEvent modifierFlags] & CPCommandKeyMask))
    {
        CPLog.debug([[self window] _layoutEngine]);
    }
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
    secondAttribute = CPLayoutAttributeNotAnAttribute;
    multiplier = 1;
    constant = 100;
    priority = 1000;

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
    [wrapper1 setFirstAttribute:CPLayoutAttributeWidth];
    [wrapper1 setSecondItem:0];
    [wrapper1 setSecondAttribute:CPLayoutAttributeWidth];
    [wrapper1 setMultiplier:0.25];
    [wrapper1 setConstant:0];
    [wrapper1 setPriority:1000];
    [wrapper1 setName:@"H:View1(0.25x(mainView))"];

    var wrapper11 = [[Constraint alloc] init];
    [wrapper11 setFirstAttribute:CPLayoutAttributeWidth];
    [wrapper11 setRelation:CPLayoutRelationLessThanOrEqual];
    [wrapper11 setConstant:150];
    [wrapper11 setPriority:1000];
    [wrapper11 setName:@"H:View1(<=400)"];

    var wrapper2 = [[Constraint alloc] init];
    [wrapper2 setFirstAttribute:CPLayoutAttributeHeight];
    [wrapper2 setName:@"V:View1(100)"];

    var wrapper3 = [[Constraint alloc] init];
    [wrapper3 setFirstAttribute:CPLayoutAttributeLeft];
    [wrapper3 setConstant:50];
    [wrapper3 setName:@"H:100-(view1)"];

    var wrapper4 = [[Constraint alloc] init];
    [wrapper4 setFirstAttribute:CPLayoutAttributeTop];
    [wrapper4 setConstant:50];
    [wrapper4 setName:@"V:100-(view1)"];

    var wrapper5 = [[Constraint alloc] init];
    [wrapper5 setFirstItem:2];
    [wrapper5 setFirstAttribute:CPLayoutAttributeWidth];
    [wrapper5 setName:@"H:View2(100)"];

    var wrapper6 = [[Constraint alloc] init];
    [wrapper6 setFirstItem:2];
    [wrapper6 setFirstAttribute:CPLayoutAttributeHeight];
    [wrapper6 setName:@"V:View2(100)"];

    var wrapper7 = [[Constraint alloc] init];
    [wrapper7 setFirstItem:2];
    [wrapper7 setFirstAttribute:CPLayoutAttributeLeft];
    [wrapper7 setSecondItem:1];
    [wrapper7 setSecondAttribute:CPLayoutAttributeRight];
    [wrapper7 setConstant:0];
    [wrapper7 setName:@"H:(view1)-0-(view2)"];

    var wrapper8 = [[Constraint alloc] init];
    [wrapper8 setFirstItem:2];
    [wrapper8 setFirstAttribute:CPLayoutAttributeTop];
    [wrapper8 setConstant:50];
    [wrapper8 setName:@"V:100-(view1)"];

    [self willChangeValueForKey:@"constraints"];
    [constraints addObjectsFromArray:[wrapper1, wrapper11, wrapper2, wrapper3, wrapper4, wrapper5, wrapper6, wrapper7, wrapper8]];
    [self didChangeValueForKey:@"constraints"];

    //[mainView setNeedsLayout];
}

- (IBAction)_addDemoConstraints:(id)sender
{
    var wrapper2 = [[Constraint alloc] init];
    [wrapper2 setFirstItem:1];
    [wrapper2 setFirstAttribute:CPLayoutAttributeWidth];
    [wrapper2 setRelation:CPLayoutRelationEqual];
    [wrapper2 setSecondItem:0];
    [wrapper2 setSecondAttribute:CPLayoutAttributeNotAnAttribute];
    [wrapper2 setMultiplier:1];
    [wrapper2 setConstant:200];
    [wrapper2 setPriority:500];
    [wrapper2 setName:@"H:(View1:width) = 200"];

    var wrapper3 = [[Constraint alloc] init];
    [wrapper3 setFirstItem:1];
    [wrapper3 setFirstAttribute:CPLayoutAttributeLeft];
    [wrapper3 setRelation:CPLayoutRelationEqual];
    [wrapper3 setSecondItem:0];
    [wrapper3 setSecondAttribute:CPLayoutAttributeNotAnAttribute];
    [wrapper3 setMultiplier:1];
    [wrapper3 setConstant:100];
    [wrapper3 setPriority:500];
    [wrapper3 setName:@"H:50 - (view1)"];

    var wrapper4 = [[Constraint alloc] init];
    [wrapper4 setFirstItem:0];
    [wrapper4 setFirstAttribute:CPLayoutAttributeRight];
    [wrapper4 setRelation:CPLayoutRelationGreaterThanOrEqual];
    [wrapper4 setSecondItem:1];
    [wrapper4 setSecondAttribute:CPLayoutAttributeRight];
    [wrapper4 setMultiplier:1];
    [wrapper4 setConstant:100];
    [wrapper4 setPriority:500];
    [wrapper4 setName:@"H:(view1) - 100"];

    [self willChangeValueForKey:@"constraints"];
    [constraints addObjectsFromArray:[wrapper4, wrapper3, wrapper2]];
    [self didChangeValueForKey:@"constraints"];

    //[mainView setNeedsLayout];
}

- (void)logMetrics:(id)sender
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