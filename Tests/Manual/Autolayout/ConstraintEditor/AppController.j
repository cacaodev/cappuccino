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
    @outlet CPWindow  theWindow;
    @outlet CPPopover priorityPopover;
    @outlet CPPopover addPopover;
    @outlet CPTableView tableView;

    @outlet CPWindow  constraintWindow @accessors;

    BOOL    windowLoaded;
    CPArray _selectedViews;
}

+ (CPSet)keyPathsForValuesAffectingIsMultiSelection
{
    return [CPSet setWithObjects:@"selectedViews"];
}

+ (CPSet)keyPathsForValuesAffectingSelectedView
{
    return [CPSet setWithObjects:@"selectedViews"];
}

- (id)init
{
    self = [super init];

    _selectedViews = @[];
    
    windowLoaded = NO;

    return self;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    [theWindow setFullPlatformWindow:YES];

    [CPBundle loadCibNamed:@"Autolayout" owner:self];

    [constraintWindow setAutolayoutEnabled:YES];
    [[constraintWindow contentView] addObserver:self forKeyPath:@"constraints" options:CPKeyValueObservingOptionNew context:nil];
    [constraintWindow orderFront:nil];
}

- (void)observeValueForKeyPath:(CPString)keyPath
                      ofObject:(id)object
                        change:(CPDictionary)change
                       context:(void)context
{
    if (keyPath == @"constraints")
    {
        [[constraintWindow contentView] setNeedsDisplay:YES];
    }
}

- (IBAction)constantAction:(id)sender
{
    [constraintWindow setNeedsLayout];
    [[self selectedView] setNeedsDisplay:YES];
}

- (IBAction)priorityAction:(id)sender
{
    var text = "",
        priority = [sender intValue];

    if (![priorityPopover isShown])
        [priorityPopover showRelativeToRect:nil ofView:sender preferredEdge:CPMaxYEdge];

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

    var view = [[priorityPopover contentViewController] view],
        valueField = [view viewWithTag:1001],
        summaryField = [view viewWithTag:1000];

    [valueField setStringValue:priority];
    [summaryField setStringValue:text];

    if (![sender isHighlighted])
    {
        var selectedView = [self selectedView];
        var row = [tableView rowForView:sender];
        var constraint = [[selectedView constraints] objectAtIndex:row];
        [constraint setPriority:priority];

        [constraintWindow setNeedsLayout];
        [selectedView setNeedsDisplay:YES];

        [priorityPopover performClose:sender];
    }
}

- (void)popoverShouldClose:(CPPopover)aPopover
{
    return YES;
}

- (IBAction)showConstraintsPopover:(id)sender
{
    if (![addPopover isShown])
        [addPopover showRelativeToRect:nil ofView:sender preferredEdge:CPMaxYEdge];

    var selectedView = [self selectedView];

    if (selectedView == nil)
        return;

    var rect = [selectedView frame],
        srect = [[selectedView superview] frame],
        popView = [[addPopover contentViewController] view];

    [[popView viewWithTag:1000] setStringValue:CGRectGetWidth(rect)];
    [[popView viewWithTag:1001] setStringValue:CGRectGetHeight(rect)];
    [[popView viewWithTag:1203] setStringValue:CGRectGetMinY(rect)];
    [[popView viewWithTag:1201] setStringValue:CGRectGetMinX(rect)];
    [[popView viewWithTag:1204] setStringValue:CGRectGetHeight(srect) - CGRectGetMaxY(rect)];
    [[popView viewWithTag:1202] setStringValue:CGRectGetWidth(srect) - CGRectGetMaxX(rect)];
}

- (IBAction)addConstraints:(id)sender
{
    var selectedView = [self selectedView],
        selectedSuperview = [selectedView superview];

    var popView = [[addPopover contentViewController] view],
        widthCheck = [popView viewWithTag:100],
        heightCheck = [popView viewWithTag:101],
        equalWidthsCheck = [popView viewWithTag:102],
        equalHeightsCheck = [popView viewWithTag:103],
        ratioCheck = [popView viewWithTag:104],
        alignCheck = [popView viewWithTag:105];

    if ([widthCheck state])
    {
        var width = [[popView viewWithTag:1000] floatValue];

        var constraint = LayoutConstraint(selectedView, CPLayoutAttributeWidth, CPLayoutRelationEqual, nil, CPLayoutAttributeNotAnAttribute, 1, width, CPLayoutPriorityRequired);

        [widthCheck setState:CPOffState];
        [constraint setActive:YES];
    }

    if ([heightCheck state])
    {
        var height = [[popView viewWithTag:1001] floatValue];

        var constraint = LayoutConstraint(selectedView, CPLayoutAttributeHeight, CPLayoutRelationEqual, nil, CPLayoutAttributeNotAnAttribute, 1, height, CPLayoutPriorityRequired);

        [heightCheck setState:CPOffState];
        [constraint setActive:YES];
    }

    if ([equalWidthsCheck state])
    {
        var view1 = [_selectedViews objectAtIndex:0],
            view2 = [_selectedViews objectAtIndex:1];

        var constraint = LayoutConstraint(view1, CPLayoutAttributeWidth, CPLayoutRelationEqual, view2, CPLayoutAttributeWidth, 1, 0, CPLayoutPriorityRequired);

        [equalWidthsCheck setState:CPOffState];
        [constraint setActive:YES];
    }

    if ([equalHeightsCheck state])
    {
        var view1 = [_selectedViews objectAtIndex:0],
            view2 = [_selectedViews objectAtIndex:1];

        var constraint = LayoutConstraint(view1, CPLayoutAttributeHeight, CPLayoutRelationEqual, view2, CPLayoutAttributeHeight, 1, 0, CPLayoutPriorityRequired);

        [equalHeightsCheck setState:CPOffState];
        [constraint setActive:YES];
    }

    if ([ratioCheck state])
    {
        var rect = [selectedView frame],
            ratio = CGRectGetWidth(rect) / CGRectGetHeight(rect);

        var constraint = LayoutConstraint(selectedView, CPLayoutAttributeWidth, CPLayoutRelationEqual, selectedView, CPLayoutAttributeHeight, ratio, 0, CPLayoutPriorityRequired);

        [ratioCheck setState:CPOffState];
        [constraint setActive:YES];
    }

    if ([alignCheck state])
    {
        var view1 = [_selectedViews objectAtIndex:0],
            view2 = [_selectedViews objectAtIndex:1],
            attr  = [[[popView viewWithTag:106] selectedItem] tag];

        var constraint = LayoutConstraint(view1, attr, CPLayoutRelationEqual, view2, attr, 1, 0, CPLayoutPriorityRequired);

        [alignCheck setState:CPOffState];
        [constraint setActive:YES];
    }

    for (var attribute = 1; attribute <= 4; attribute++)
    {
        var check = [popView viewWithTag:(200 + attribute)];

        if ([check state])
        {
            var constant = [[popView viewWithTag:(1200 + attribute)] floatValue];

            if (attribute == CPLayoutAttributeBottom || attribute == CPLayoutAttributeRight)
                constant = -constant;

            var constraint = LayoutConstraint(selectedView, attribute, CPLayoutRelationEqual, selectedSuperview, attribute, 1, constant, CPLayoutPriorityRequired);

            [check setState:CPOffState];
            [constraint setActive:YES];
        }
    }

    [addPopover performClose:sender];
    [constraintWindow setNeedsLayout];
}

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
    [[self selectedView] setNeedsDisplay:YES];
}

- (void)updatePrioritySlider
{
    var constraints = [[self selectedView] constraints];
    
    [tableView enumerateAvailableViewsUsingBlock:function(aCellView, row, column, stop)
    {
        if ([aCellView identifier] == "Constraint")
        {
            var priority = [[constraints objectAtIndex:row] priority];
            [[aCellView viewWithTag:1000] setFloatValue:priority];
        }
    }];
}

- (CPView)tableView:(CPTableView)aTableView viewForTableColumn:(CPTableColumn)tableColumn row:(CPInteger)row
{
    var constraintsView = [self selectedView],
        cellView = nil;

    if (constraintsView)
    {
        var constraint = [[constraintsView constraints] objectAtIndex:row];
        cellView = [aTableView makeViewWithIdentifier:[constraint _constraintType] owner:self];
    }

    return cellView;
}

- (void)tableViewDeleteKeyPressed:(CPTableView)aTableView
{
    var row = [aTableView selectedRow];

    if (row !== CPNotFound)
    {
        var view = [self selectedView];

        if (view)
        {
            var constraint = [[view constraints] objectAtIndex:row];
            [constraint setActive:NO];
            [constraintWindow setNeedsLayout];
        }
    }
}

- (CPView)tableView:(CPTableView)tableView shouldSelectRow:(CPInteger)row
{
    var view = [self selectedView],
        constraint = [[view constraints] objectAtIndex:row];

    return [constraint _constraintType] == "Constraint";
}

- (IBAction)layout:(id)sender
{
    [constraintWindow layoutIfNeeded];
}

- (IBAction)visualizeConstraints:(id)sender
{
}

- (void)_selectView:(id)aView byExtendingSelection:(BOOL)extend
{
    var current_selection = [CPArray arrayWithArray:_selectedViews];

    if (extend)
    {
        if ([current_selection containsObjectIdenticalTo:aView])
            [current_selection removeObject:aView];
        else
            [current_selection addObject:aView];
    }
    else
    {
        current_selection = @[aView];
    }

    [self setSelectedViews:current_selection];
    [self updatePrioritySlider];
}

- (CPView)selectedView
{
    return [_selectedViews lastObject];
}

- (void)setSelectedViews:(CPArray)theSelectedViews
{
    if (![theSelectedViews isEqual:_selectedViews])
    {
        [_selectedViews makeObjectsPerformSelector:@selector(setSelected:) withObject:NO];

        _selectedViews = theSelectedViews;

        [_selectedViews makeObjectsPerformSelector:@selector(setSelected:) withObject:YES];
    }
}

- (BOOL)isMultiSelection
{
    return [_selectedViews count] > 1;
}

@end

@implementation ConstraintView : CPView
{
    BOOL _selected        @accessors(getter=selected);
    BOOL _showConstraints @accessors(property=showConstraints);
    CPIndexSet    selectedConstraintIndexes @accessors;
    CGSize m_intrinsicContentSize;
}

+ (CPSet)keyPathsForValuesAffectingConstraints
{
    return [CPSet setWithObjects:@"intrinsicContentWidth", @"intrinsicContentHeight", @"horizontalContentHuggingPriority", @"verticalContentHuggingPriority", @"horizontalContentCompressionResistancePriority", @"verticalContentCompressionResistancePriority"];
}

- (BOOL)acceptsFirstMouse:(CPEvent)anEvent
{
    return YES;
}

- (id)initWithFrame:(CGRect)aFrame
{
    CPLog.debug([self class] + _cmd);
    self = [super initWithFrame:aFrame];

    _selected  = NO;
    _showConstraints = YES;
    m_intrinsicContentSize = CGSizeMake(-1,-1);
    selectedConstraintIndexes = [CPIndexSet indexSet];

    return self;
}

- (id)initWithCoder:(CPCoder)aCoder
{
    CPLog.debug([self class] + _cmd);
    self = [super initWithCoder:aCoder];

    _selected  = NO;
    _showConstraints = YES;
    m_intrinsicContentSize = CGSizeMake(-1,-1);
    selectedConstraintIndexes = [CPIndexSet indexSet];

    return self;
}

- (void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent type] !== CPLeftMouseDown)
        return;

    if ([anEvent modifierFlags] & CPShiftKeyMask)
        CPLog.debug([[self _layoutEngine] description]);
    else if ([anEvent modifierFlags] & CPAlternateKeyMask)
        [[self window] layout];
    else
    {
        var extend = [anEvent modifierFlags] & CPCommandKeyMask;
        [[CPApp delegate] _selectView:self byExtendingSelection:extend];
    }
}

- (void)setSelected:(BOOL)flag
{
    if (_selected !== flag)
    {
        _selected = flag;
        _showConstraints = YES;
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
        flags           = [aConstraint constraintFlags];

    if (secondAttribute === CPLayoutAttributeNotAnAttribute && firstAttribute !== CPLayoutAttributeWidth && firstAttribute !== CPLayoutAttributeHeight)
        secondAttribute = firstAttribute;

    var startPoint = CGPointMakeZero(),
        endPoint = CGPointMakeZero();

    if (firstAttribute == CPLayoutAttributeLeft || firstAttribute == CPLayoutAttributeLeading)
    {
        startPoint.x = (flags & 8) ? CGRectGetMinX([firstItem frame]) : 0;
        startPoint.y = (flags & 8) ? CGRectGetMidY([firstItem frame]) : CGRectGetMidY([secondItem frame]);
    }
    else if (firstAttribute == CPLayoutAttributeRight || firstAttribute == CPLayoutAttributeTrailing)
    {
        startPoint.x = (flags & 8) ? CGRectGetMaxX([firstItem frame]) : CGRectGetWidth([container frame]);
        startPoint.y = (flags & 8) ? CGRectGetMidY([firstItem frame]) : CGRectGetMidY([secondItem frame]);
    }
    else if (firstAttribute == CPLayoutAttributeTop)
    {
        startPoint.y = (flags & 8) ? CGRectGetMinY([firstItem frame]) : 0;
        startPoint.x = (flags & 8) ? CGRectGetMidX([firstItem frame]) : CGRectGetMidX([secondItem frame]);
    }
    else if (firstAttribute == CPLayoutAttributeBottom)
    {
        startPoint.y = (flags & 8) ? CGRectGetMaxY([firstItem frame]) : CGRectGetHeight([container frame]);
        startPoint.x = (flags & 8) ? CGRectGetMidX([firstItem frame]) : CGRectGetMidX([secondItem frame]);
    }
    else if (firstAttribute == CPLayoutAttributeWidth && secondAttribute == 0)
    {
        startPoint.x = 0;
        startPoint.y = CGRectGetHeight([firstItem frame]) - 10;
        endPoint.x   = CGRectGetWidth([firstItem frame]);
        endPoint.y   = CGRectGetHeight([firstItem frame]) - 10;
    }
    else if (firstAttribute == CPLayoutAttributeHeight && secondAttribute == 0)
    {
        startPoint.x = 10;
        startPoint.y = 0;
        endPoint.x   = 10;
        endPoint.y   = CGRectGetHeight([firstItem frame]);
    }

    if (secondAttribute == CPLayoutAttributeLeft || secondAttribute == CPLayoutAttributeLeading)
    {
        endPoint.x = (flags & 64) ? CGRectGetMinX([secondItem frame]) : 0;
        endPoint.y = startPoint.y;
    }
    else if (secondAttribute == CPLayoutAttributeRight || secondAttribute == CPLayoutAttributeTrailing)
    {
        endPoint.x = (flags & 64) ? CGRectGetMaxX([secondItem frame]) : CGRectGetWidth([container frame]);
        endPoint.y = startPoint.y;
    }
    else if (secondAttribute == CPLayoutAttributeTop)
    {
        endPoint.y = (flags & 64) ? CGRectGetMinY([secondItem frame]) : 0;
        endPoint.x = (flags & 64) ? CGRectGetMidX([secondItem frame]) : startPoint.x;
    }
    else if (secondAttribute == CPLayoutAttributeBottom)
    {
        endPoint.y = (flags & 64) ? CGRectGetMaxY([secondItem frame]) : CGRectGetHeight([container frame]);
        endPoint.x = (flags & 64) ? CGRectGetMidX([secondItem frame]) : startPoint.x;
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
    [self drawBackgroundInRect:aRect];
    [self drawConstraintsInRect:aRect];
}

- (void)drawBackgroundInRect:(CGRect)aRect
{
    var identifier = [self identifier];

    if (identifier !== @"contentView")
    {
        var fillColor = [CPColor colorWithRed:159/255 green:180/255 blue:210/255 alpha:1],
            bounds = [self bounds];

        [fillColor setFill];
        [CPBezierPath fillRect:bounds];

        [self drawString:identifier inBounds:bounds];
    }

    if (_selected)
    {
        [CPBezierPath setDefaultLineWidth:3];
        [[CPColor orangeColor] setStroke];
        [CPBezierPath strokeRect:[self bounds]];
    }
}

- (void)drawString:(CPString)aString inBounds:(CGRect)bounds
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    ctx.font = [[CPFont boldSystemFontOfSize:20] cssString];
    [[CPColor whiteColor] setFill];
    var metrics = ctx.measureText(aString);
    ctx.fillText(aString, (CGRectGetWidth(bounds) - metrics.width)/2, CGRectGetHeight(bounds)/2);
}

- (void)drawConstraintsInRect:(CGRect)aRect
{
    if (!_showConstraints)
        return;

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
}

- (CGSize)intrinsicContentSize
{
    if (m_intrinsicContentSize)
        return m_intrinsicContentSize;

    return CGSizeMake(-1,-1);
}

- (float)horizontalContentHuggingPriority
{
    return [self contentHuggingPriorityForOrientation:CPLayoutConstraintOrientationHorizontal];
}

- (void)setHorizontalContentHuggingPriority:(float)aPriority
{
    [self setContentHuggingPriority:aPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [self invalidateIntrinsicContentSize];
}

- (float)verticalContentHuggingPriority
{
    return [self contentHuggingPriorityForOrientation:CPLayoutConstraintOrientationVertical];
}

- (void)setVerticalContentHuggingPriority:(float)aPriority
{
    [self setContentHuggingPriority:aPriority forOrientation:CPLayoutConstraintOrientationVertical];
    [self invalidateIntrinsicContentSize];
}

- (float)horizontalContentCompressionResistancePriority
{
    return [self contentCompressionResistancePriorityForOrientation:CPLayoutConstraintOrientationHorizontal];
}

- (void)setHorizontalContentCompressionResistancePriority:(float)aPriority
{
    [self setContentCompressionResistancePriority:aPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [self invalidateIntrinsicContentSize];
}

- (float)verticalContentCompressionResistancePriority
{
    return [self contentCompressionResistancePriorityForOrientation:CPLayoutConstraintOrientationVertical];
}

- (void)setVerticalContentCompressionResistancePriority:(float)aPriority
{
    [self setContentCompressionResistancePriority:aPriority forOrientation:CPLayoutConstraintOrientationVertical];
    [self invalidateIntrinsicContentSize];
}

- (float)intrinsicContentWidth
{
    return m_intrinsicContentSize.width;
}

- (void)setIntrinsicContentWidth:(float)aWidth
{
    m_intrinsicContentSize.width = aWidth;
    [self invalidateIntrinsicContentSize];
}

- (float)intrinsicContentHeight
{
    return m_intrinsicContentSize.height;
}

- (void)setIntrinsicContentHeight:(float)aHeight
{
    m_intrinsicContentSize.height = aHeight;
    [self invalidateIntrinsicContentSize];
}

@end


var LayoutConstraint = function(firstItem, firstAttr, relation, secondItem, secondAttr, multiplier, constant, priority)
{
    var constraint = [[CPLayoutConstraint alloc] initWithItem:firstItem attribute:firstAttr relatedBy:relation toItem:secondItem attribute:secondAttr multiplier:multiplier constant:constant];
    [constraint setPriority:priority];

    return constraint;
};
