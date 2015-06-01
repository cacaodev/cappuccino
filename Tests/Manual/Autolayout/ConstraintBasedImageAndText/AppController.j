/*
 * AppController.j
 * ConstraintBasedImageAndText
 *
 * Created by You on May 31, 2015.
 * Copyright 2015, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@import "StackView.j"

#define CGRectZero CGRectMakeZero()

CPLogRegister(CPLogConsole);

@implementation CustomView : CPView
{
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(50, 50);
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow theWindow;
    @outlet StackView stackView;

    CPImageView imageView;
    CPTextField textField;
    CPView customView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    imageView = [[CPImageView alloc] initWithFrame:CGRectZero];
    [imageView setContentCompressionResistancePriority:CPLayoutPriorityDefaultLow-2 forOrientation:CPLayoutConstraintOrientationHorizontal];
    [imageView setImage:[CPImage imageNamed:CPImageNameColorPanel]];
    [imageView setImageScaling:CPImageScaleProportionallyDown];

    textField = [[CPTextField alloc] initWithFrame:CGRectZero];
    [textField setContentCompressionResistancePriority:CPLayoutPriorityDefaultLow-1 forOrientation:CPLayoutConstraintOrientationHorizontal];
    [textField setStringValue:@"Hugging content"];
    [textField setFont:[CPFont boldSystemFontOfSize:24]];
    [textField setLineBreakMode:CPLineBreakByWordWrapping];
    [textField setEditable:NO];
    [textField setBezeled:NO];

    customView = [[CustomView alloc] initWithFrame:CGRectZero];
    [customView setContentCompressionResistancePriority:CPLayoutPriorityDefaultLow-1 forOrientation:CPLayoutConstraintOrientationHorizontal];
    [customView setBackgroundColor:[CPColor yellowColor]];
}

- (void)awakeFromCib
{
    [theWindow setAutolayoutEnabled:YES];
    [theWindow setFullPlatformWindow:NO];
    [theWindow layout];
}

- (IBAction)setPosition:(id)sender
{
    var tag = [[sender selectedItem] tag];
    var leftViews   = [CPMutableArray array];
    var middleViews = [CPMutableArray array];
    var rightViews  = [CPMutableArray array];

    switch (tag)
    {
        case CPNoImage:
            [middleViews addObject:textField];
            break;
        case CPImageOnly:
            [middleViews addObject:imageView];
            break;
        case CPImageLeft:
            [leftViews addObject:imageView];
            [rightViews addObject:textField];
            break;
        case CPImageRight:
            [leftViews addObject:textField];
            [rightViews addObject:imageView];
            break;
        case CPImageOverlaps:
            [middleViews addObjectsFromArray:@[textField, imageView]];
            break;

        default:
            break;
    }

    [stackView setViews:leftViews inGravity:0];
    [stackView setViews:middleViews inGravity:1];
    [stackView setViews:rightViews inGravity:2];
}

@end
