/*
 */

@import <Foundation/CPArray.j>
@import "CPApplication.j"
@import "CPLayoutConstraint.j"
@import "CPView.j"

//@protocol CPStackViewDelegate;

/*
 The gravity area describes the area within a StackView that a view will be placed.
 This placement is also highly related to the set orientation and layoutDirection.

 Gravity areas will align to a specific direction in the StackView, which are described through these enum values.
 Each gravity area is a distinct portion of the StackView, and the constraints for spacing between gravities is described further in the documentation for the spacing property.
 In addition to the gravity spacing constraints, the center gravity area also has a constraint tying it to the center of the StackView with a layout priority of CPLayoutPriorityDefaultLow.

 For horizontally-oriented StackViews, CPStackViewGravityLeading, CPStackViewGravityCenter, and CPStackViewGravityTrailing should be used. Leading and trailing are described by the userInterfaceLayoutDirection of the StackView, (leading = left for CPUserInterfaceLayoutDirectionLeftToRight vs leading = right for CPUserInterfaceLayoutDirectionRightToLeft).

 For a vertically-oriented StackView, CPStackViewGravityTop, CPStackViewGravityCenter, and CPStackViewGravityBottom should be used.

 See also:
 - insertView:atIndex:inGravity:
 - viewsInGravity:
 - setViews:inGravity:
 - CPLayoutConstraintOrientation
 - CPUserInterfaceLayoutDirection
 */

@typedef CPStackViewGravity;

CPStackViewGravityTop = 1; // The top-most gravity area, should only be used when orientation = CPLayoutConstraintOrientationVertical
CPStackViewGravityLeading = 1; // The leading gravity area (as described by userInterfaceLayoutDirection), should only be used when orientation = CPLayoutConstraintOrientationHorizontal
CPStackViewGravityCenter = 2; // The center gravity area, this is the center regardless of orientation
CPStackViewGravityBottom = 3; // The bottom-most gravity area, should only be used when orientation = CPLayoutConstraintOrientationVertical
CPStackViewGravityTrailing = 3; // The trailing gravity area (as described by userInterfaceLayoutDirection), should only be used when orientation = CPLayoutConstraintOrientationHorizontal

/* Distribution—the layout along the stacking axis.
 All CPStackViewDistribution enum values fit first and last stacked views tightly to the container, except for CPStackViewDistributionGravityAreas.
 */

@typedef CPStackViewDistribution;

/// Default value. CPStackView will not have any special distribution behavior, relying on behavior described by gravity areas and set hugging priorities along the stacking axis.
CPStackViewDistributionGravityAreas = -1;

/// The effective hugging priority in the stacking axis is CPLayoutPriorityRequired, causing the stacked views to tightly fill the container along the stacking axis.
CPStackViewDistributionFill = 0;

/// Stacked views will have sizes maintained to be equal as much as possible along the stacking axis. The effective hugging priority in the stacking axis is CPLayoutPriorityRequired.
CPStackViewDistributionFillEqually = 1;

/// Stacked views will have sizes maintained to be equal, proportionally to their intrinsicContentSizes, as much as possible. The effective hugging priority in the stacking axis is CPLayoutPriorityRequired.
CPStackViewDistributionFillProportionally = 2;

/// The space separating stacked views along the stacking axis are maintained to be equal as much as possible while still maintaining the minimum spacing.
CPStackViewDistributionEqualSpacing = 3;

/// Equal center-to-center spacing of the items is maintained as much as possible while still maintaining the minimum spacing between each view.
CPStackViewDistributionEqualCentering = 4;

/*
 Visibility Priority describes the priority at which a view should be held (aka, not be detached).
 In the case that clippingResistancePriority is optional (< CPLayoutPriorityRequired) and there's not enough space to display all of StackView's subviews, views are able to be detached from the StackView.
 Views will be detached in order (from lowest to highest) of their visibility priority, and reattached in the reverse order (FILO).
 If multiple views share the lowest visibility priority, all those views will be dropped when one needs to be. Likewise, groups of views with equal visibility priorities will wait to be reattached until they can all be readded.

 A view with a higher visibility priority will never be detached while a lower priority view remains visible

 See also:
 - visibilityPriorityForView:
 - setVisibilityPriority:ForView:
 - clippingResistancePriority
 - detachedViews
 */

@typedef CPStackViewVisibilityPriority;

CPStackViewVisibilityPriorityMustHold = 1000; //Maximum, default - the view will never be detached
CPStackViewVisibilityPriorityDetachOnlyIfNecessary = 900;
CPStackViewVisibilityPriorityNotVisible = 0; //Minimum - will force a view to be detached

/*
 A value of CPStackViewSpacingUseDefault signifies that the spacing is the default spacing set with the StackView property.

 See also:
 - setCustomSpacing:afterView:
 - customSpacingAfterView:
 */

var CPStackViewDistributionPriority = CPLayoutPriorityDefaultLow + 10;

#pragma mark - CPStackViewLayout

@implementation CPStackView : CPView
{
    id                                  _delegate @accessors(getter=delegate);
    CPArray                             _views @accessors(property=views);
//    CPArray                             _detachedViews @accessors(readonly, copy);
    long long                           _distribution @accessors(getter=distribution);
    CPLayoutConstraintOrientation       _orientation @accessors(getter=orientation);
    CPLayoutAttribute                   _alignment @accessors(getter=alignment);
    CGInset                             _edgeInsets @accessors(property=edgeInsets);
    float                               _spacing @accessors(getter=spacing);
//    BOOL                                _detachesHiddenViews @accessors(getter=detachesHiddenViews);

    CPLayoutPriority     _verticalClippingResistancePriority;
    CPLayoutPriority     _horizontalClippingResistancePriority;
    CPLayoutPriority     _verticalHuggingPriority;
    CPLayoutPriority     _horizontalHuggingPriority;
//    CPMutableArray       _viewsDetachedWithDeferredNotifications;
//    CPMutableArray       _viewsReattachedWithDeferredNotifications;
//    CPStackViewContainer _leadingOrTopViewsManager;
//    CPStackViewContainer _centerViewsManager;
//    CPStackViewContainer _trailingOrBottomViewsManager;
    CPMutableDictionary  _stackConstraintsDictionary;
    CPArray              _stackConstraints;
    CPLayoutDimension    _idealSizeLayoutDimension;
    float                _alignmentPriority;
//    CPMapTable           _overriddenHoldingPriorities;
//    BOOL                 _baselineRelativeArrangement;
//    BOOL                 _stackViewShouldNotAddConstraints;
//    BOOL                 _stackViewFinishedDecoding;
//    BOOL                 _stackViewDecodedWantingFlatHierarchy;
//    BOOL                 _finishedFirstUpdateConstraintsPass;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

+ (id)keyPathsForValuesAffectingArrangedSubviews
{
    return [CPSet setWithObjects:@"views"];
}

+ (id)keyPathsForValuesAffectingAlignment
{
    return [CPSet setWithObjects:@"orientation"];
}

/*!
    Returns an autoreleased horizontal StackView with the provided views set as the leading views, and has translatesAutoresizingMaskIntoConstraints set to NO.
*/
+ (CPStackView)stackViewWithViews:(CPArray)views
{
    var stackView = [[self alloc] initWithFrame:CGRectMakeZero()];
//    [stackView setViews:views inGravity:CPStackViewGravityTop];
    [stackView _setViews:views];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];

    return stackView;
}

#pragma mark General StackView Properties

/*!
    Orientation of the StackView, defaults to CPLayoutConstraintOrientationHorizontal
*/
- (void)setOrientation:(CPLayoutConstraintOrientation)orientation
{
    if (orientation !== _orientation)
    {
        _orientation = orientation;
        _idealSizeLayoutDimension = nil;
        _alignment = _orientation ? CPLayoutAttributeCenterX : CPLayoutAttributeCenterY;
        [self setNeedsUpdateConstraints:YES];
        [self setNeedsLayout];
    }
}

/*!
    Describes how subviews are aligned within the StackView, defaults to `CPLayoutAttributeCenterY` for horizontal stacks, `CPLayoutAttributeCenterX` for vertical stacks. Setting `CPLayoutAttributeNotAnAttribute` will cause the internal alignment constraints to not be created, and could result in an ambiguous layout. Setting an inapplicable attribute for the set orientation will result in the alignment being ignored (similar to its handling with CPLayoutAttributeNotAnAttribute). The alignment constraints are established at a priority of `CPLayoutPriorityDefaultLow` and are overridable for individual views using external constraints.
*/
- (void)setAlignment:(CPLayoutAttribute)alignment
{
    if (alignment !== _alignment)
    {
        _alignment = alignment;
        [self setNeedsUpdateConstraints:YES];
    }
}

/*!
    Default padding inside the StackView, around all of the subviews.
*/
- (void)setEdgeInsets:(CGInset)insets
{
    if (!CGInsetEqualToInset(insets, _edgeInsets))
    {
        _edgeInsets = insets;
        [self setNeedsUpdateConstraints:YES];
    }
}

/*
    The spacing and sizing distribution of stacked views along the primary axis. Defaults to GravityAreas.
*/
- (void)setDistribution:(CPInteger)dist
{
    if (dist < 0 || dist > 4)
        [CPException raise:CPInvalidArgumentException format:@"Unknown distribution %d", dist];

    if (dist !== _distribution)
    {
        _distribution = dist;
        [self setNeedsUpdateConstraints:YES];
        [self setNeedsLayout];
    }
}

/*!
    Default (minimum) spacing between each view
*/
- (void)setSpacing:(float)aSpacing
{
    if (aSpacing !== _spacing)
    {
        _spacing = aSpacing;
        [self setNeedsUpdateConstraints:YES];
    }
}

/*!
 Set and get custom spacing after a view. This custom spacing is used instead of the default spacing set with the spacing property.
 This is saved across layout updates, until the view is removed from the StackView or the custom spacing is changed.
 A value of CPStackViewSpacingUseDefault signifies that the spacing is the default spacing set with the StackView property.
 `view` must be managed by the StackView, an exception will be raised if not.
*/
- (void)setCustomSpacing:(CGFloat)spacing afterView:(CPView)view
{

}

- (CGFloat)customSpacingAfterView:(CPView)view
{

}

/// If YES, when a stacked view's `hidden` property is set to YES, the view will be detached from the stack and reattached when set to NO. Similarly, if the view has a lowered visibility priority and is detached from the stack view, it will be set as `hidden` rather than removed from the view hierarchy. Defaults to YES for apps linked on the 10.11 SDK or later.
//BOOL detachesHiddenViews @accessors;

#pragma mark Arranged Subviews

/*!
    The list of views that are arranged in a stack by the receiver. They are a subset of \c -subviews, with potential difference in ordering.
*/
- (CPArray)arrangedSubviews
{
    return _views;
}

/*!
 Adds a view to the end of the arrangedSubviews list. If the view is not a subview of the receiver, it will be added as one.
 */
- (void)addArrangedSubview:(CPView)view
{
    [self insertArrangedSubview:view atIndex:[[self arrangedSubviews] count]];
}

/*!
 Adds a view to the arrangedSubviews list at a specific index.
 If the view is already in the arrangedSubviews list, it will move the view to the specified index (but not change the subview index).
 If the view is not a subview of the receiver, it will be added as one (not necessarily at the same index).
 */
- (void)insertArrangedSubview:(CPView)view atIndex:(CPInteger)anIndex
{
    var arrangedSubviews = [self arrangedSubviews],
        count = [arrangedSubviews count];

    if (anIndex < 0 || anIndex > count)
        [CPException raise:CPInvalidArgumentException format:@"anIndex (%ld) is out of bounds [%ld-%ld]", anIndex, 0, count];

    var viewIdx = [arrangedSubviews indexOfObjectIdenticalTo:view];

    if (anIndex == viewIdx)
        return;

    [view setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self willChangeValueForKey:@"views"];

    if (viewIdx !== CPNotFound)
    {
        [self removeView:view];

        if (anIndex < viewIdx)
            anIndex--;
    }

    [arrangedSubviews insertObject:view atIndex:anIndex];

    if (![view isDescendantOf:self])
    {
        if ([view superview])
            [view removeFromSuperview];

        [self addSubview:view];
    }

    [self didChangeValueForKey:@"views"];

    [self setNeedsUpdateConstraints:YES];
}

/*!
 Removes a subview from the list of arranged subviews without removing it as a subview of the receiver.
 Removing the view as a subview (either by -[view removeFromSuperview] or setting the receiver's subviews) will automatically remove it as an arranged subview.
 */
- (void)removeArrangedSubview:(CPView)view
{
    if (![_views containsObjectIdenticalTo:view])
        [CPException raise:CPInvalidArgumentException format:@"View %@ is not (and has to be) in stack view %@.", view, self];

    [self willChangeValueForKey:@"views"];

    [_views removeObjectIdenticalTo:view];
    [self setNeedsUpdateConstraints:YES];

    [self didChangeValueForKey:@"views"];
}


- (void)_setViews:(CPArray)newViews
{
    var viewsToRemove = [_views arrayByExcludingObjectsInArray:newViews],
        viewsToAdd = [newViews arrayByExcludingObjectsInArray:_views];

    [self willChangeValueForKey:@"views"];

    _views = newViews;

    [viewsToRemove enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        [view removeFromSuperview];
    }];

    [viewsToAdd enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];

        if ([view superview])
            [view removeFromSuperview];

        [self addSubview:view];
    }];

    [self setNeedsUpdateConstraints:YES];
    [self didChangeValueForKey:@"views"];
}

/// The arrangedSubviews that are currently detached/hidden.
//CPArray<__kindof CPView> detachedViews @accessors(readonly, copy);

#pragma mark Custom Priorities

/*!
 Sets and gets the visibility priorities for views in the StackView.
 When detaching a view, it will first detach views with the lowest visibility priority.
 If multiple views share the same lowest visibility priority, all of them will be dropped.

 Defaults to `CPStackViewVisibilityPriorityMustHold`.
 Setting the visibility priority to CPStackViewVisibilityPriorityNotVisible will force that view to be detached (regardless of available space), and will set the view to be hidden if `detachesHiddenViews` is set to `YES`.

 `view` must be managed by the StackView, an exception will be raised if not.
 */

- (void)setVisibilityPriority:(CPStackViewVisibilityPriority)priority forView:(CPView)view
{

}

- (CPStackViewVisibilityPriority)visibilityPriorityForView:(CPView)view
{

}

/*!
 Priority at which the StackView will not clip its views, defaults to CPLayoutPriorityRequired
 Clipping begins from the trailing and bottom sides of the StackView.
 */
- (CPLayoutPriority)clippingResistancePriorityForOrientation:(CPLayoutConstraintOrientation)orientation
{
    return orientation ? _verticalClippingResistancePriority : _horizontalClippingResistancePriority;
}

- (void)setClippingResistancePriority:(CPLayoutPriority)clippingResistancePriority forOrientation:(CPLayoutConstraintOrientation)orientation
{
    if (orientation)
        [self setVerticalClippingResistancePriority:clippingResistancePriority];
    else
        [self setHorizontalClippingResistancePriority:clippingResistancePriority];
}

- (void)setVerticalClippingResistancePriority:(CPLayoutPriority)aPriority
{
    if (_verticalClippingResistancePriority !== aPriority)
    {
        _verticalClippingResistancePriority = aPriority;
        [self setNeedsUpdateConstraints:YES];
        [self setNeedsLayout];
    }
}

- (void)setHorizontalClippingResistancePriority:(CPLayoutPriority)aPriority
{
    if (_horizontalClippingResistancePriority !== aPriority)
    {
        _horizontalClippingResistancePriority = aPriority;
        [self setNeedsUpdateConstraints:YES];
        [self setNeedsLayout];
    }
}

/*!
 Priority at which the StackView wants its internal spacing to be as small as possible, defaults to CPLayoutPriorityDefaultLow
 Spacing within a StackView is managed completely by the StackView.
 However, extra layout constraints can be added in conjunction with the StackView to create a more customized layout.
 Below describes the constraints the StackView uses to space its internal views.
 Spacing between view gravities have constraints with the following constraints:
 - Length >= spacing @ CPLayoutPriorityRequired
 - Length == spacing @ huggingPriority
 Spacing between views (within a gravity) have the following constraints:
 - Length >= spacing @ CPLayoutPriorityRequired
 - Length == spacing @ MAX(CPLayoutPriorityDefaultHigh, huggingPriority)
 */
- (CPLayoutPriority)huggingPriorityForOrientation:(CPLayoutConstraintOrientation)orientation
{
    return orientation ? _verticalHuggingPriority : _horizontalHuggingPriority;
}

- (void)setHuggingPriority:(CPLayoutPriority)huggingPriority forOrientation:(CPLayoutConstraintOrientation)orientation
{
    if (orientation)
        [self setVerticalHuggingPriority:huggingPriority];
    else
        [self setHorizontalHuggingPriority:huggingPriority];
}

- (void)setVerticalHuggingPriority:(CPLayoutPriority)aPriority
{
    if (_verticalHuggingPriority !== aPriority)
    {
        _verticalHuggingPriority = aPriority;
        [self setNeedsUpdateConstraints:YES];
        [self setNeedsLayout];
    }
}

- (void)setHorizontalHuggingPriority:(CPLayoutPriority)aPriority
{
    if (_horizontalHuggingPriority !== aPriority)
    {
        _horizontalHuggingPriority = aPriority;
        [self setNeedsUpdateConstraints:YES];
        [self setNeedsLayout];
    }
}
#pragma mark - CPStackViewDelegate
//@protocol CPStackViewDelegate <CPObject>
//@optional
/*
 These are called when the StackView detaches or readds a view (or multiple views) after it was detached.
 This is not called when a view is explicitly added or removed from the StackView
 */
- (void)stackView:(CPStackView)stackView willDetachViews:(CPArray)views
{

}

- (void)stackView:(CPStackView)stackView didReattachViews:(CPArray)views
{

}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    _views = @[];
    _orientation = CPLayoutConstraintOrientationHorizontal;
    _distribution = CPStackViewDistributionFill;
    _alignment = CPLayoutAttributeCenterY;
    _spacing = 8.0;
    _alignmentPriority = CPStackViewDistributionPriority;
    _edgeInsets = CGInsetMake(0, 0, 0, 0);
    _verticalClippingResistancePriority = CPLayoutPriorityRequired;
    _horizontalClippingResistancePriority = CPLayoutPriorityRequired;
    _verticalHuggingPriority = CPLayoutPriorityDefaultLow;
    _horizontalHuggingPriority = CPLayoutPriorityDefaultLow;

    [self _init];

    return self;
}

- (void)_init
{
    _stackConstraints = @[];
    _stackConstraintsDictionary = @{};
    _idealSizeLayoutDimension = nil;
}

- (void)updateConstraints
{
    var newConstraints = [self _generateStackViewConstraints];

    var constraintsToAdd = [newConstraints arrayByExcludingObjectsInArray:_stackConstraints],
        constraintsToRemove = [_stackConstraints arrayByExcludingObjectsInArray:newConstraints];

    [CPLayoutConstraint deactivateConstraints:constraintsToRemove];
    [_stackConstraints removeObjectsInArray:constraintsToRemove];

    [CPLayoutConstraint activateConstraints:constraintsToAdd];
    [_stackConstraints addObjectsFromArray:constraintsToAdd];

    CPLog.debug("Added " + [constraintsToAdd count] + " constraints.\nRemoved " + [constraintsToRemove count]+ " constraints.")
}

- (CPArray)_generateStackViewConstraints
{
    var result = @[],
        previousView = nil,
        last = [_views count] - 1;

    var stackLeadingAnchor = [self leadingAnchorForOrientation:_orientation],
        stackTrailingAnchor = [self trailingAnchorForOrientation:_orientation],
        stackAlignmentLeadingAnchor = [self leadingAnchorForOrientation:(1 - _orientation)],
        stackAlignmentTrailingAnchor = [self trailingAnchorForOrientation:(1 - _orientation)],

        huggingPriority = [self huggingPriorityForOrientation:_orientation],
        alignmentHuggingpriority = [self huggingPriorityForOrientation:(1 - _orientation)],
        clippingPriority = [self clippingResistancePriorityForOrientation:_orientation],

        leadingInset = [self _leadingInsetForOrientation:_orientation],
        trailingInset = [self _trailingInsetForOrientation:_orientation],
        alignmentLeadingInset = [self _leadingInsetForOrientation:(1 - _orientation)],
        alignmentTrailingInset = [self _trailingInsetForOrientation:(1 - _orientation)];

    [_views enumerateObjectsUsingBlock:function(aView, idx, stop)
    {
        var leadingAnchor = [aView leadingAnchorForOrientation:_orientation],
            trailingAnchor = [aView trailingAnchorForOrientation:_orientation],
            alignmentLeadingAnchor = [aView leadingAnchorForOrientation:(1 - _orientation)],
            alignmentTrailingAnchor = [aView trailingAnchorForOrientation:(1 - _orientation)];

        var alignment = [CPLayoutConstraint constraintWithItem:aView attribute:_alignment relatedBy:CPLayoutRelationEqual toItem:self attribute:_alignment multiplier:1 constant:0];
        [alignment setPriority:_alignmentPriority];
        [result addObject:alignment];

        var alignmentLeading = [alignmentLeadingAnchor constraintGreaterThanOrEqualToAnchor:stackAlignmentLeadingAnchor constant:alignmentLeadingInset];
        [result addObject:alignmentLeading];

        var alignmentTrailing = [alignmentTrailingAnchor constraintLessThanOrEqualToAnchor:stackAlignmentTrailingAnchor constant:-alignmentTrailingInset];
        [result addObject:alignmentTrailing];

        if (idx == 0)
        {
            var leading = [leadingAnchor constraintEqualToAnchor:stackLeadingAnchor constant:leadingInset];
            var priority = (_distribution <= 2) ? CPLayoutPriorityRequired : CPLayoutPriorityDefaultHigh;
            [leading setPriority:priority];
            [result addObject:leading];

            var leadingClipping = [leadingAnchor constraintGreaterThanOrEqualToAnchor:stackLeadingAnchor constant:leadingInset];
            [leadingClipping setPriority:clippingPriority];
            [result addObject:leadingClipping];
        }
        else
        {
            var previousViewTrailingAnchor = [previousView trailingAnchorForOrientation:_orientation];
            var distance = [CPDistanceLayoutDimension distanceFromAnchor:previousViewTrailingAnchor toAnchor:leadingAnchor];

            var minSpacing = [distance constraintGreaterThanOrEqualToConstant:_spacing];
            [result addObject:minSpacing];

            if (_distribution == CPStackViewDistributionEqualSpacing)
            {
                var spacing = [distance constraintEqualToAnchor:[self _idealSizeLayoutDimension]];
                [spacing setPriority:CPStackViewDistributionPriority];
                [result addObject:spacing];
            }
            else
            {
                var spacing = [distance constraintEqualToConstant:_spacing];
                var p = (_distribution == CPStackViewDistributionEqualCentering) ? CPStackViewDistributionPriority - 1 : CPLayoutPriorityRequired;
                [spacing setPriority:p];
                [result addObject:spacing];
            }
        }

        if (idx == last)
        {
            var trailingHugg = [trailingAnchor constraintEqualToAnchor:stackTrailingAnchor constant:-trailingInset];
            var priority = (_distribution <= 2) ? CPLayoutPriorityRequired : CPStackViewDistributionPriority;
            [trailingHugg setPriority:priority];
            [result addObject:trailingHugg];

            var trailingClipping = [trailingAnchor constraintLessThanOrEqualToAnchor:stackTrailingAnchor constant:-trailingInset];
            [trailingClipping setPriority:clippingPriority];
            [result addObject:trailingClipping];
        }

        if (_distribution == CPStackViewDistributionFillEqually)
        {
            var anchor = [aView dimensionForOrientation:_orientation];
            var sizeConstraint = [anchor constraintEqualToAnchor:[self _idealSizeLayoutDimension]];
            [sizeConstraint setPriority:CPStackViewDistributionPriority];
            [result addObject:sizeConstraint];
        }
        else if (_distribution == CPStackViewDistributionFillProportionally)
        {
            var intrinsicSize = [aView intrinsicContentSize],
                coeff = _orientation ? intrinsicSize.height : intrinsicSize.width,
                anchor = [aView dimensionForOrientation:_orientation];

            var sizeConstraint = [anchor constraintEqualToAnchor:[self _idealSizeLayoutDimension] multiplier:coeff constant:0];
            [sizeConstraint setPriority:CPStackViewDistributionPriority];
            [result addObject:sizeConstraint];
        }

        previousView = aView;
    }];

    if (_distribution == CPStackViewDistributionEqualCentering)
    {
        var centeringConstraints = [self _equalCenteringConstraints];
        [result addObjectsFromArray:centeringConstraints];
    }

    return result;
}

- (CPLayoutPriority)_maxSubviewsHuggingPriority
{
    var result = 0;

    [_views enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        result = MAX(result, [view contentHuggingPriorityForOrientation:_orientation]);

        if (result == CPLayoutPriorityRequired)
            stop(YES);
    }];

    return result;
}

- (CPArray)_equalCenteringConstraints
{
    var result = @[],
        count = [_views count],
        huggingPriority = [self huggingPriorityForOrientation:_orientation];

    [_views enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        var midAnchor = [view centerAnchorForOrientation:_orientation],
            opposite = count - 1 - idx;

        if (idx == opposite)
        {
            stop(YES);
        }
        else
        {
            var opp_view = [_views objectAtIndex:opposite];
            midAnchor = [midAnchor anchorAtMidpointToAnchor:[opp_view centerAnchorForOrientation:_orientation]];
        }

        var centering = [midAnchor constraintEqualToAnchor:[self centerAnchorForOrientation:_orientation]];
        [centering setPriority:CPStackViewDistributionPriority];
        [result addObject:centering];
    }];

    return result;
}

- (CPLayoutDimension)_idealSizeLayoutDimension
{
    if (_idealSizeLayoutDimension == nil)
        _idealSizeLayoutDimension = [CPLayoutDimension anchorNamed:@"Ideal" inItem:self];

    return _idealSizeLayoutDimension;
}

- (CPInteger)_leadingInsetForOrientation:(CPLayoutConstraintOrientation)orientation
{
    return orientation ? _edgeInsets.top : _edgeInsets.left;
}

- (CPInteger)_trailingInsetForOrientation:(CPLayoutConstraintOrientation)orientation
{
    return orientation ? _edgeInsets.bottom : _edgeInsets.right;
}

- (CPLayoutConstraint)stackConstraintWithName:(CPString)aName
{
    var cst = [_stackConstraintsDictionary objectForKey:aName];

    if (cst !== nil)
        return cst;

    [_stackConstraintsDictionary setObject:cst forKey:aName];

    return cst;
}

@end

/* API that is intended for use when the `distribution` of the receiver is set to `CPStackViewDistributionGravityAreas`. */
@implementation CPStackView (CPStackViewGravityAreas)

/*!
 Adds the view to the given gravity area at the end of that gravity area.
 This method will update the StackView's layout, and could result in the StackView changing its size or views being detached / clipped.
 */
- (void)addView:(CPView)view inGravity:(CPStackViewGravity)gravity
{

}

/*!
 Adds the view to the given gravity area at the index within that gravity area.
 Index numbers & counts are specific to each gravity area, and are indexed based on the set userInterfaceLayoutDirection.
 (For a L2R layout, index 0 in the leading gravity is the furthest left index; for a R2L layout index 0 in the leading gravity is the furthest right index)
 This method will update the StackView's layout, and could result in the StackView changing its size or views being detached / clipped.
 An CPRangeException will be raised if the index is out of bounds
 */
- (void)insertView:(CPView)view atIndex:(CPInteger)index inGravity:(CPStackViewGravity)gravity
{

}

/*!
 Will remove view from the StackView.
 [view removeFromSuperview] will have the same behavior in the case that view is visible (not detached) from the StackView.
 In the case that view had been detached, this method must be used to remove it from the StackView.
 view must be managed by the StackView, an exception will be raised if not.
 */
- (void)removeView:(CPView)view
{
    if (![_views containsObjectIdenticalTo:view])
        [CPException raise:CPInvalidArgumentException format:@"The view %@ is not present in arrangedSubviews", view];

    [self willChangeValueForKey:@"views"];

    [_views removeObjectIdenticalTo:view];
    [view removeFromSuperview];
    [self setNeedsUpdateConstraints:YES];

    [self didChangeValueForKey:@"views"];
}

- (CPArray)viewsInGravity:(CPStackViewGravity)gravity
{

}

 // Getters will return the views that are contained by the corresponding gravity area, regardless of detach-status.
- (void)setViews:(CPArray)views inGravity:(CPStackViewGravity)gravity
{

} // Setters will update the views and the layout for that gravity area.

/*
 Returns an array of all the views managed by this StackView, regardless of detach-status or gravity area.
 This is indexed in the order of indexing within the StackView. Detached views are indexed at the positions they would have been if they were still attached.
 */
//CPArray<__kindof CPView> views @accessors(readonly, copy);

@end

var CPStackViewAlignment = "CPStackViewAlignment",
    CPStackViewAlignmentPriority = "CPStackViewAlignmentPriority",
    CPStackViewOrientation = "CPStackViewOrientation",
    CPStackViewDistributionKey = "CPStackViewDistribution",
    CPStackViewSpacing = "CPStackViewSpacing",
    CPStackViewEdgeInsets = "CPStackViewEdgeInsets",
    CPStackViewHorizontalClippingResistance = @"CPStackViewHorizontalClippingResistance",
    CPStackViewVerticalClippingResistance = @"CPStackViewVerticalClippingResistance",
    CPStackViewHorizontalHugging = "CPStackViewHorizontalHugging",
    CPStackViewVerticalHugging = "CPStackViewVerticalHugging";

@implementation CPStackView (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    _views = [self subviews];
    _orientation = [aCoder decodeIntForKey:CPStackViewOrientation];
    _distribution = [aCoder decodeIntForKey:CPStackViewDistributionKey];
    _alignment = [aCoder decodeIntForKey:CPStackViewAlignment];
    _alignmentPriority = [aCoder decodeIntForKey:CPStackViewAlignmentPriority];
    _spacing = [aCoder decodeFloatForKey:CPStackViewSpacing] || 0.0;
    if ([aCoder containsValueForKey:CPStackViewEdgeInsets])
    {
        var ei = [aCoder decodeObjectForKey:CPStackViewEdgeInsets];
        _edgeInsets = CGInsetMake(ei[0], ei[1], ei[2], ei[3]);
    }
    else {
        _edgeInsets = CGInsetMakeZero();
    }

    _horizontalClippingResistancePriority = [aCoder decodeIntForKey:CPStackViewHorizontalClippingResistance];
    _verticalClippingResistancePriority = [aCoder decodeIntForKey:CPStackViewVerticalClippingResistance];
    _horizontalHuggingPriority = [aCoder decodeIntForKey:CPStackViewHorizontalHugging];
    _verticalHuggingPriority = [aCoder decodeIntForKey:CPStackViewVerticalHugging];

    [self _init];

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeInt:_orientation forKey:CPStackViewOrientation];
    [aCoder encodeInt:_distribution forKey:CPStackViewDistributionKey];
    [aCoder encodeInt:_alignment forKey:CPStackViewAlignment];
    [aCoder encodeInt:_alignmentPriority forKey:CPStackViewAlignmentPriority];
    if (_spacing !== 0)
        [aCoder encodeFloat:_spacing forKey:CPStackViewSpacing];
    if (!CGInsetEqualToInset(_edgeInsets, CGInsetMakeZero()))
        [aCoder encodeObject:@[_edgeInsets.top, _edgeInsets.right, _edgeInsets.bottom, _edgeInsets.left] forKey:CPStackViewEdgeInsets];
    [aCoder encodeInt:_horizontalHuggingPriority forKey:CPStackViewHorizontalHugging];
    [aCoder encodeInt:_verticalHuggingPriority forKey:CPStackViewVerticalHugging];
    [aCoder encodeInt:_horizontalClippingResistancePriority forKey:CPStackViewHorizontalClippingResistance];
    [aCoder encodeInt:_verticalClippingResistancePriority forKey:CPStackViewVerticalClippingResistance];
}

@end

@implementation CPView (CPStackView)

- (CPLayoutAnchor)leadingAnchorForOrientation:(CPLayoutConstraintOrientation)orientation
{
    return orientation ? [self topAnchor] : [self leftAnchor];
}

- (CPLayoutAnchor)trailingAnchorForOrientation:(CPLayoutConstraintOrientation)orientation
{
    return orientation ? [self bottomAnchor] : [self rightAnchor];
}

- (CPLayoutAnchor)centerAnchorForOrientation:(CPLayoutConstraintOrientation)orientation
{
    return orientation ? [self centerYAnchor] : [self centerXAnchor];
}

- (CPLayoutAnchor)dimensionForOrientation:(CPLayoutConstraintOrientation)orientation
{
    return orientation ? [self heightAnchor] : [self widthAnchor];
}

@end

@implementation CPArray (arrayByExcludingObjectsInArray)

- (CPArray)arrayByExcludingObjectsInArray:(CPArray)anArray
{
    var result = [CPArray arrayWithArray:self];
    [result removeObjectsInArray:anArray];

    return result;
}

@end
