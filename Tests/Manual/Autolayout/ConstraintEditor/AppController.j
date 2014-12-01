/*
 * AppController.j
 * ConstraintEditor
 *
 * Created by You on January 23, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <Foundation/CPValueTransformer.j>
@import <AppKit/CPWindow.j>
@import <AppKit/CPView.j>
@import <AppKit/CPArrayController.j>
@import <AppKit/CPBezierPath.j>
@import <AppKit/CPApplication.j>

CPLogRegister(CPLogConsole);

@implementation CPStringToFloatTransformer : CPValueTransformer
{
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)aValue
{
    return [aValue stringValue];
}

- (id)reverseTransformedValue:(id)aValue
{
    return [aValue floatValue];
}

@end

@implementation CPFloatToIntegerTransformer : CPValueTransformer
{
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)aValue
{
    return aValue;
}

- (id)reverseTransformedValue:(id)aValue
{
    return ROUND(aValue);
}

@end

@implementation CPBoolToColorTransformer : CPValueTransformer
{
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)aValue
{
    return aValue ? [CPColor redColor] : [CPColor greenColor];
}

@end

@implementation ConstraintsController : CPArrayController
{
}

- (id)newObject
{
    var delegate = [CPApp delegate];

    return LayoutConstraint([delegate view1], CPLayoutAttributeLeft, CPLayoutRelationEqual, nil, CPLayoutAttributeNotAnAttribute, 1, 50, 1000);
}

@end

@implementation CPNonKeyWindow : CPWindow
{
}

- (BOOL)canBecomeKeyWindow
{
    return NO;
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow theWindow;
    @outlet CPPopover popover;

    @outlet CPWindow       constraintWindow @accessors;
    @outlet ConstraintView mainView         @accessors;
    @outlet ConstraintView view1            @accessors;
    @outlet ConstraintView view2            @accessors;

    BOOL windowLoaded;
    ConstraintView selectedView @accessors;
}

- (id)init
{
    self = [super init];

    selectedView = nil;
    windowLoaded = NO;

    return self;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    [CPBundle loadCibNamed:@"Autolayout" owner:self];

    [constraintWindow setAutolayoutEnabled:YES];
    [self setSelectedView:mainView];

    [constraintWindow orderFront:nil];
}

- (void)awakeFromCib
{
    [theWindow setFullPlatformWindow:YES];
}

- (IBAction)priorityAction:(id)sender
{
    var text = "",
        priority = [sender intValue];

    if (![popover isShown])
        [popover showRelativeToRect:nil ofView:sender preferredEdge:CPMaxYEdge];

    if (priority < CPLayoutPriorityDefaultLow)
        text = "Weaker than default weak priority at witch a control holds to its intrinsic content size.";
    else if (priority < CPLayoutPriorityDragThatCannotResizeWindow)
        text = "Weaker than the user resizing the window.";
    else if (priority < CPLayoutPriorityWindowSizeStayPut)
        text = "Weaker than the window staying same size.";
    else if (priority < CPLayoutPriorityDragThatCanResizeWindow)
        text = "Stronger than the window staying same size.";
    else if (priority < CPLayoutPriorityDefaultHigh)
        text = "Stronger than the user resizing the window.";
    else if (priority < CPLayoutPriorityRequired)
        text = "Not required but stronger than the priority at witch controls maintain their intrinsic content size.";
    else if (priority == CPLayoutPriorityRequired)
        text = "Required";

    var view = [[popover contentViewController] view],
        valueField = [view viewWithTag:1001],
        summaryField = [view viewWithTag:1000];

    [valueField setStringValue:priority];
    [summaryField setStringValue:text];
}

- (void)popoverShouldClose:(CPPopover)aPopover
{
    return YES;
}

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
    var table = [aNotification object],
        selectedRow = [table selectedRow];

    if (selectedRow !== CPNotFound)
    {
        [[self selectedView] setNeedsDisplay:YES];
    }
}

- (CPView)tableView:(CPTableView)tableView viewForTableColumn:(CPTableColumn)tableColumn row:(CPInteger)row
{
    var constraintsView = [self selectedView],
        cellView = nil;

    if (constraintsView)
    {
        var constraint = [[constraintsView constraints] objectAtIndex:row];
        cellView = [tableView makeViewWithIdentifier:[constraint _constraintType] owner:self];
    }

    return cellView;
}

- (IBAction)layout:(id)sender
{
    [constraintWindow layoutIfNeeded];
}

- (IBAction)visualizeConstraints:(id)sender
{
    [mainView setShowConstraints:[sender state]];
}

- (void)logMetrics:(id)sender
{
    CPLog.debug("mainView " + CGStringFromRect([mainView frame]) + "\nleftView " + CGStringFromRect([view1 frame]) + "\nrightView " + CGStringFromRect([view2 frame]));
}

- (void)selectView:(id)aView
{
    [mainView setSelected:NO];
    [view1 setSelected:NO];
    [view2 setSelected:NO];
    [aView setSelected:YES];

    [self setSelectedView:aView];
}

@end

@implementation ConstraintView : CPView
{
    BOOL _selected        @accessors(getter=selected);
    BOOL _showConstraints @accessors(property=showConstraints);
    CPIndexSet    selectedConstraintIndexes @accessors;
    CGSize intrinsicContentSize;
}

+ (CPSet)keyPathsForValuesAffectingNeedsDisplay
{
    return [CPSet setWithObjects:@"constraints"];
}

+ (CPSet)keyPathsForValuesAffectingConstraints
{
    return [CPSet setWithObjects:@"constraints.constant", @"constraints.priority", @"intrinsicContentWidth", @"intrinsicContentHeight", @"horizontalContentHuggingPriority", @"verticalContentHuggingPriority", @"horizontalContentCompressionResistancePriority", @"verticalContentCompressionResistancePriority"];
}

- (BOOL)acceptsFirstMouse:(CPEvent)anEvent
{
    return YES;
}

- (void)awakeFromCib
{
    CPLog.debug([self class] + _cmd);

    _selected  = NO;
    _showConstraints = YES;
    intrinsicContentSize = [super intrinsicContentSize];
    selectedConstraintIndexes = [CPIndexSet indexSet];
}

- (void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent type] !== CPLeftMouseDown)
        return;

    [[CPApp delegate] selectView:self];
}

- (void)setSelected:(BOOL)flag
{
    if (_selected !== flag)
    {
        _selected = flag;
        showConstraints = YES;
        [self setNeedsDisplay:YES];
    }
}

- (CPBezierPath)pathForContentSizeConstraint:(CPLayoutConstraint)aConstraint
{
    var size = [self frameSize],
        orientation = [aConstraint orientation];

    var startx = orientation ? 20 : 0,
        starty = orientation ? 0 : size.height - 20,
        endx = orientation ? 20 : size.width,
        endy = orientation ? size.height : size.height - 20;

    var path = [CPBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startx, starty)];
    [path lineToPoint:CGPointMake(endx, endy)];

    [path setLineWidth:3];

    return path;
}

- (CPBezierPath)pathForConstraint:(CPLayoutConstraint)aConstraint
{
    var container       = [aConstraint container];

    if (container == nil)
        return;

    var firstItem       = [aConstraint firstItem] || container,
        secondItem      = [aConstraint secondItem] || container,
        firstAttribute  = [aConstraint firstAttribute],
        secondAttribute = [aConstraint secondAttribute],
        relation        = [aConstraint relation],
        multiplier      = [aConstraint multiplier],
        constant        = [aConstraint constant],
        priority        = [aConstraint priority],
        angle = 0;

    if (secondAttribute === CPLayoutAttributeNotAnAttribute && firstAttribute !== CPLayoutAttributeWidth && firstAttribute !== CPLayoutAttributeHeight)
        secondAttribute = firstAttribute;

    var startPoint = CGPointMakeZero(),
        endPoint = CGPointMakeZero();

    if (firstAttribute == CPLayoutAttributeLeft || firstAttribute == CPLayoutAttributeLeading)
    {
        startPoint.x = (firstItem !== container) ? CGRectGetMinX([firstItem frame]) : 0;
        startPoint.y = (firstItem !== container) ? CGRectGetMidY([firstItem frame]) : CGRectGetMidY([secondItem frame]);
        angle = 0;
    }
    else if (firstAttribute == CPLayoutAttributeRight  || firstAttribute == CPLayoutAttributeTrailing)
    {
        startPoint.x = (firstItem !== container) ? CGRectGetMaxX([firstItem frame]) : CGRectGetWidth([container frame]);
        startPoint.y = (firstItem !== container) ? CGRectGetMidY([firstItem frame]) : CGRectGetMidY([secondItem frame]);
        angle = 180;
    }
    else if (firstAttribute == CPLayoutAttributeTop)
    {
        startPoint.y = (firstItem !== container) ? CGRectGetMinY([firstItem frame]) : 0;
        startPoint.x = (firstItem !== container) ? CGRectGetMidX([firstItem frame]) : CGRectGetMidX([secondItem frame]);
        angle = 90;
    }
    else if (firstAttribute == CPLayoutAttributeBottom)
    {
        startPoint.y = (firstItem !== container) ? CGRectGetMaxY([firstItem frame]) : CGRectGetHeight([container frame]);
        startPoint.x = (firstItem !== container) ? CGRectGetMidX([firstItem frame]) : CGRectGetMidX([secondItem frame]);
        angle = -90;
    }
    else if (firstAttribute == CPLayoutAttributeWidth && secondAttribute == 0)
    {
        startPoint.x = 0;
        startPoint.y = CGRectGetHeight([firstItem frame]) - 10;
        endPoint.x   = CGRectGetWidth([firstItem frame]);
        endPoint.y   = CGRectGetHeight([firstItem frame]) - 10;
        angle = -180;
    }
    else if (firstAttribute == CPLayoutAttributeHeight && secondAttribute == 0)
    {
        startPoint.x = 10;
        startPoint.y = 0;
        endPoint.x   = 10;
        endPoint.y   = CGRectGetHeight([firstItem frame]);
        angle = -90;
    }

    if (secondAttribute == CPLayoutAttributeLeft || secondAttribute == CPLayoutAttributeLeading)
    {
        endPoint.x = (secondItem !== container) ? CGRectGetMinX([secondItem frame]) : 0;
        endPoint.y = startPoint.y;
    }
    else if (secondAttribute == CPLayoutAttributeRight || secondAttribute == CPLayoutAttributeTrailing)
    {
        endPoint.x = (secondItem !== container) ? CGRectGetMaxX([secondItem frame]) : CGRectGetWidth([container frame]);
        endPoint.y = startPoint.y;
    }
    else if (secondAttribute == CPLayoutAttributeTop)
    {
        endPoint.y = (secondItem !== container) ? CGRectGetMinY([secondItem frame]) : 0;
        endPoint.x = (secondItem !== container) ? CGRectGetMidX([secondItem frame]) : startPoint.x;
    }
    else if (secondAttribute == CPLayoutAttributeBottom)
    {
        endPoint.y = (secondItem !== container) ? CGRectGetMaxY([secondItem frame]) : CGRectGetHeight([container frame]);
        endPoint.x = (secondItem !== container) ? CGRectGetMidX([secondItem frame]) : CGRectGetHeight([container frame]);
    }

    var path = [CPBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path lineToPoint:endPoint];

    [path setLineDash:((priority < 1000) ? [5,5]:[]) phase:1];
    [path setLineWidth:2];

    return path;
}

- (void)drawRect:(CGRect)aRect
{
    var color = _selected ? [CPColor orangeColor] : [CPColor grayColor];
    [color setStroke];
    [CPBezierPath strokeRect:[self bounds]];

    if (!_showConstraints)
        return;

    [[CPColor blueColor] setStroke];

    [[self constraints] enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        var type = [aConstraint _constraintType],
            path, color;

        if (type == @"Constraint" || type == @"AutoresizingConstraint")
        {
            path = [self pathForConstraint:aConstraint];
            color = [CPColor blueColor];
        }
        else if (type == @"SizeConstraint")
        {
            path = [self pathForContentSizeConstraint:aConstraint];
            color = [CPColor purpleColor];
        }

        if (_selected && [selectedConstraintIndexes containsIndex:idx])
            color = [CPColor redColor];

        [color setStroke];
        [path stroke];
    }];

    _showConstraints = NO;
}

- (CGSize)intrinsicContentSize
{
    return intrinsicContentSize;
}

- (float)horizontalContentHuggingPriority
{
    return [self contentHuggingPriorityForOrientation:CPLayoutConstraintOrientationHorizontal];
}

- (void)setHorizontalContentHuggingPriority:(float)aPriority
{
    return [self setContentHuggingPriority:aPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [self invalidateIntrinsicContentSize];
}

- (float)verticalContentHuggingPriority
{
    return [self contentHuggingPriorityForOrientation:CPLayoutConstraintOrientationVertical];
}

- (void)setVerticalContentHuggingPriority:(float)aPriority
{
    return [self setContentHuggingPriority:aPriority forOrientation:CPLayoutConstraintOrientationVertical];
    [self invalidateIntrinsicContentSize];
}

- (float)horizontalContentCompressionResistancePriority
{
    return [self contentCompressionResistancePriorityForOrientation:CPLayoutConstraintOrientationHorizontal];
}

- (void)setHorizontalContentCompressionResistancePriority:(float)aPriority
{
    return [self setContentCompressionResistancePriority:aPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [self invalidateIntrinsicContentSize];
}

- (float)verticalContentCompressionResistancePriority
{
    return [self contentCompressionResistancePriorityForOrientation:CPLayoutConstraintOrientationVertical];
}

- (void)setVerticalContentCompressionResistancePriority:(float)aPriority
{
    return [self setContentCompressionResistancePriority:aPriority forOrientation:CPLayoutConstraintOrientationVertical];
    [self invalidateIntrinsicContentSize];
}

- (float)intrinsicContentWidth
{
    return intrinsicContentSize.width;
}

- (void)setIntrinsicContentWidth:(float)aWidth
{
    [self willChangeValueForKey:@"constraints"];
    intrinsicContentSize.width = aWidth;
    [self invalidateIntrinsicContentSize];
    [self didChangeValueForKey:@"constraints"];
}

- (float)intrinsicContentHeight
{
    return intrinsicContentSize.height;
}

- (void)setIntrinsicContentHeight:(float)aHeight
{
    intrinsicContentSize.height = aHeight;
    [self invalidateIntrinsicContentSize];
}

@end

var LayoutConstraint = function(firstItem, firstAttr, relation, secondItem, secondAttr, multiplier, constant, priority)
{
    var constraint = [[CPLayoutConstraint alloc] initWithItem:firstItem attribute:firstAttr relatedBy:relation toItem:secondItem attribute:secondAttr multiplier:multiplier constant:constant];
    [constraint setPriority:priority];

    return constraint;
};
