/*
 * CPStackView.j
 * AppKit
 *
 * Created by cacaodev.
 * Copyright 2016.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import <Foundation/CPArray.j>
@import "CPApplication.j"
@import "CPLayoutConstraint.j"
@import "CPView.j"
@import "CPLayoutRect.j"

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

/* Distribution the layout along the stacking axis.
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
    id                                  _delegate       @accessors(getter=delegate);
    CPDictionary                        _viewsInGravity;
//    CPArray                             _detachedViews @accessors(readonly, copy);
    long long                           _distribution   @accessors(getter=distribution);
    CPLayoutConstraintOrientation       _orientation    @accessors(getter=orientation);
    CPLayoutAttribute                   _alignment      @accessors(getter=alignment);
    CGInset                             _edgeInsets     @accessors(property=edgeInsets);
    float                               _spacing        @accessors(getter=spacing);
//    BOOL                                _detachesHiddenViews @accessors(getter=detachesHiddenViews);

    CPLayoutPriority     _verticalClippingResistancePriority;
    CPLayoutPriority     _horizontalClippingResistancePriority;
    CPLayoutPriority     _verticalHuggingPriority;
    CPLayoutPriority     _horizontalHuggingPriority;
//    CPMutableArray       _viewsDetachedWithDeferredNotifications;
//    CPMutableArray       _viewsReattachedWithDeferredNotifications;
    CPDictionary         _gravityLayoutRects;
//    CPMutableDictionary  _stackConstraintsDictionary;
    CPArray              _stackConstraints;
    CPDictionary         _idealSizeForGravity;
    float                _alignmentPriority;
    unsigned int         _gravitiesMask;
//    CPMapTable           _overriddenHoldingPriorities;
//    BOOL                 _baselineRelativeArrangement;
//    BOOL                 _stackViewShouldNotAddConstraints;
//    BOOL                 _stackViewFinishedDecoding;
    BOOL                 _stackViewDecodedWantingFlatHierarchy;
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
    [stackView setViews:views inGravity:CPStackViewGravityLeading];
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
        _idealSizeForGravity = @{};
        _alignment = _orientation ? CPLayoutAttributeTop : CPLayoutAttributeLeading;
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
    if (dist < -1 || dist > 4)
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
    return [self views];
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
    // FIXME
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
    if (![[self arrangedSubviews] containsObjectIdenticalTo:view])
        [CPException raise:CPInvalidArgumentException format:@"View %@ is not (and has to be) in stack view %@.", view, self];

    [self willChangeValueForKey:@"views"];

    // FIXME
    //[_views removeObjectIdenticalTo:view];
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

@end

/* API that is intended for use when the `distribution` of the receiver is set to `CPStackViewDistributionGravityAreas`. */
@implementation CPStackView (CPStackViewGravityAreas)

/*!
 Adds the view to the given gravity area at the end of that gravity area.
 This method will update the StackView's layout, and could result in the StackView changing its size or views being detached / clipped.
 */
- (void)addView:(CPView)view inGravity:(CPStackViewGravity)aGravity
{
    var count = [[self viewsInGravity:aGravity] count];
    [self insertView:view atIndex:count inGravity:aGravity];
}

/*!
 Adds the view to the given gravity area at the index within that gravity area.
 Index numbers & counts are specific to each gravity area, and are indexed based on the set userInterfaceLayoutDirection.
 (For a L2R layout, index 0 in the leading gravity is the furthest left index; for a R2L layout index 0 in the leading gravity is the furthest right index)
 This method will update the StackView's layout, and could result in the StackView changing its size or views being detached / clipped.
 An CPRangeException will be raised if the index is out of bounds
 */
- (void)insertView:(CPView)aView atIndex:(CPInteger)anIndex inGravity:(CPStackViewGravity)aGravity
{
    var views = [self _mutableViewsInGravity:aGravity],
        count = [views count];

    if (anIndex < 0 || anIndex > count)
        [CPException raise:CPInvalidArgumentException format:@"anIndex (%ld) is out of bounds [%ld-%ld]", anIndex, 0, count];

    _gravitiesMask |= (1 << aGravity);

    var viewIdx = [views indexOfObjectIdenticalTo:aView];

    if (anIndex == viewIdx)
        return;

    [aView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self willChangeValueForKey:@"views"];

    if (viewIdx !== CPNotFound)
    {
        [self removeView:aView];

        if (anIndex < viewIdx)
            anIndex--;
    }

    [views insertObject:aView atIndex:anIndex];

    if (![aView isDescendantOf:self])
    {
        if ([aView superview])
            [aView removeFromSuperview];

        [self addSubview:aView];
    }

    [self didChangeValueForKey:@"views"];

    [self setNeedsUpdateConstraints:YES];
}

/*!
 Will remove view from the StackView.
 [view removeFromSuperview] will have the same behavior in the case that view is visible (not detached) from the StackView.
 In the case that view had been detached, this method must be used to remove it from the StackView.
 view must be managed by the StackView, an exception will be raised if not.
 */
- (void)removeView:(CPView)view
{
    var allviews = [self views];

    if (![allviews containsObjectIdenticalTo:view])
        [CPException raise:CPInvalidArgumentException format:@"The view %@ is not present in arrangedSubviews", view];

    [self willChangeValueForKey:@"views"];

    [_viewsInGravity enumerateKeysAndObjectsUsingBlock:function(key, views, stop)
    {
        if ([views containsObjectIdenticalTo:view])
        {
            [views removeObjectIdenticalTo:view];

            if ([views count] == 0)
            {
                var gravity = [self _gravityForName:key];
                _gravitiesMask &= (~ (1 << gravity));
            }

            stop(YES);
        }
    }];

    [view removeFromSuperview];
    [self setNeedsUpdateConstraints:YES];

    [self didChangeValueForKey:@"views"];
}

 // Getters will return the views that are contained by the corresponding gravity area, regardless of detach-status.
- (CPArray)viewsInGravity:(CPStackViewGravity)aGravity
 {
     var result = @[];

     var gravity_key = [self _nameForGravity:aGravity],
         views = [_viewsInGravity objectForKey:gravity_key];

     if (views !== nil)
         [result addObjectsFromArray:views];

     return result;
 }

// Setters will update the views and the layout for that gravity area.
- (void)setViews:(CPArray)newViews inGravity:(CPStackViewGravity)aGravity
{
    _gravitiesMask |= (1 << aGravity);

    var oldViews = [self viewsInGravity:aGravity],
        viewsToRemove = [oldViews arrayByExcludingObjectsInArray:newViews],
        viewsToAdd = [newViews arrayByExcludingObjectsInArray:oldViews];

    [self willChangeValueForKey:@"views"];

    [_viewsInGravity setObject:newViews forKey:[self _nameForGravity:aGravity]];

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

/*
 Returns an array of all the views managed by this StackView, regardless of detach-status or gravity area.
 This is indexed in the order of indexing within the StackView. Detached views are indexed at the positions they would have been if they were still attached.
 */
- (CPArray)views
{
    var result = @[];

    [_viewsInGravity enumerateKeysAndObjectsUsingBlock:function(key, views, stop)
    {
        [result addObjectsFromArray:views];
    }];

    return result;
}

// PRIVATE METHODS
- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    if (self)
    {
        _orientation = CPLayoutConstraintOrientationHorizontal;
        _distribution = CPStackViewDistributionGravityAreas;
        _alignment = CPLayoutAttributeCenterY;
        _spacing = 8.0;
        _alignmentPriority = CPStackViewDistributionPriority;
        _edgeInsets = CGInsetMake(0, 0, 0, 0);
        _verticalClippingResistancePriority = CPLayoutPriorityRequired;
        _horizontalClippingResistancePriority = CPLayoutPriorityRequired;
        _verticalHuggingPriority = CPLayoutPriorityDefaultLow;
        _horizontalHuggingPriority = CPLayoutPriorityDefaultLow;
        _stackViewDecodedWantingFlatHierarchy = NO;
        _viewsInGravity = @{};

        [self _init];
    }

    return self;
}

- (void)_init
{
    _stackConstraints = @[];
//    _stackConstraintsDictionary = @{};
    _gravityLayoutRects = @{};
    _idealSizeForGravity = @{};
    _gravitiesMask = 0;
}

#if (DEBUG)
- (void)drawRect:(CGRect)dirtyRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort],
        colors = @[[CPColor redColor], [CPColor blueColor], [CPColor greenColor]];

    CGContextSetLineWidth(ctx, 3);

    [self _enumerateGravitiesUsingBlock:function(aGravity, idx)
    {
        var layoutRect = [self _layoutRectForGravity:aGravity];
        [[colors objectAtIndex:(aGravity - 1)] setStroke];
        CGContextStrokeRect(ctx, [layoutRect valueInEngine:self]);
    }];

    [[CPColor blackColor] set];
    CGContextStrokeRect(ctx, [self bounds]);
}
#endif

// CONSTRAINTS MANAGEMENT
- (void)updateConstraints
{
    var newConstraints = [self _generateGravityConstraints];

    var constraintsToAdd = [newConstraints arrayByExcludingObjectsInArray:_stackConstraints],
        constraintsToRemove = [_stackConstraints arrayByExcludingObjectsInArray:newConstraints];

    [CPLayoutConstraint deactivateConstraints:constraintsToRemove];
    [_stackConstraints removeObjectsInArray:constraintsToRemove];

    [CPLayoutConstraint activateConstraints:constraintsToAdd];
    [_stackConstraints addObjectsFromArray:constraintsToAdd];
#if (DEBUG)
    CPLog.debug("Added " + [constraintsToAdd description] + " constraints.\nRemoved " + [constraintsToRemove description] + " constraints.")
#endif
}

- (CPArray)_generateGravityConstraints
{
    var result = @[],
        count = [self countOfGravities],
        previousTrailingAnchor = nil,
        isFillDistribution = (_distribution <= CPStackViewDistributionFillProportionally);

    var leading_attr = CPLayoutAttributeLeading - 2 * _orientation,
        leading_perp_attr = CPLayoutAttributeTop + 2 * _orientation,
        trailing_attr = CPLayoutAttributeTrailing - 2 * _orientation,
        trailing_perp_attr = CPLayoutAttributeBottom + 2 * _orientation,
        dimension_attr = CPLayoutAttributeWidth + _orientation,
        center_attr = CPLayoutAttributeCenterX + _orientation;

    var stackLeadingAnchor = [self layoutAnchorForAttribute:leading_attr],
        stackTrailingAnchor = [self layoutAnchorForAttribute:trailing_attr],
        stackAlignmentLeadingAnchor = [self layoutAnchorForAttribute:leading_perp_attr],
        stackAlignmentTrailingAnchor = [self layoutAnchorForAttribute:trailing_perp_attr];

    var leadingInset = [self _leadingInsetForOrientation:_orientation],
        trailingInset = [self _trailingInsetForOrientation:_orientation],
        alignmentLeadingInset = [self _leadingInsetForOrientation:(1 - _orientation)],
        alignmentTrailingInset = [self _trailingInsetForOrientation:(1 - _orientation)];

    var huggingPriority = [self huggingPriorityForOrientation:_orientation],
        alignmentHuggingPriority = [self huggingPriorityForOrientation:(1 - _orientation)],
        clippingPriority = [self clippingResistancePriorityForOrientation:_orientation],
        alignmentClippingPriority = [self clippingResistancePriorityForOrientation:(1 - _orientation)];

    [self _enumerateGravitiesUsingBlock:function(aGravity, idx, stop)
    {
        var gravityRect = [self _layoutRectForGravity:aGravity];

        var gravityLeadingAnchor = [gravityRect layoutAnchorForAttribute:leading_attr],
            gravityTrailingAnchor = [gravityRect layoutAnchorForAttribute:trailing_attr],
            gravityAlignmentLeadingAnchor = [gravityRect layoutAnchorForAttribute:leading_perp_attr],
            gravityAlignmentTrailingAnchor = [gravityRect layoutAnchorForAttribute:trailing_perp_attr];

        if (idx == 0)
        {
            if (isFillDistribution)
            {
                var leadingMin = [gravityLeadingAnchor constraintGreaterThanOrEqualToAnchor:stackLeadingAnchor];
                [result addObject:leadingMin];
            }

            var leadingEqual = [gravityLeadingAnchor constraintEqualToAnchor:stackLeadingAnchor constant:leadingInset],
                priority = isFillDistribution ? CPLayoutPriorityDefaultHigh : CPLayoutPriorityRequired;

            [leadingEqual setPriority:priority];
            [result addObject:leadingEqual];
        }
        else
        {
            var min_spacing = [gravityLeadingAnchor constraintGreaterThanOrEqualToAnchor:previousTrailingAnchor constant:_spacing],
                spacing = [gravityLeadingAnchor constraintEqualToAnchor:previousTrailingAnchor constant:_spacing];

            [spacing setPriority:huggingPriority];
            [result addObjectsFromArray:@[min_spacing, spacing]];
        }

        var alignment = [CPLayoutConstraint constraintWithItem:self attribute:_alignment relatedBy:CPLayoutRelationEqual toItem:gravityRect attribute:_alignment multiplier:1 constant:0];
        [alignment setPriority:_alignmentPriority];
        [result addObject:alignment];

        var topMin = [gravityAlignmentLeadingAnchor constraintGreaterThanOrEqualToAnchor:stackAlignmentLeadingAnchor],
            top = [gravityAlignmentLeadingAnchor constraintEqualToAnchor:stackAlignmentLeadingAnchor constant:alignmentLeadingInset],
            bottomMin = [stackAlignmentTrailingAnchor constraintGreaterThanOrEqualToAnchor:gravityAlignmentTrailingAnchor],
            bottom = [stackAlignmentTrailingAnchor constraintEqualToAnchor:gravityAlignmentTrailingAnchor constant:alignmentTrailingInset];

        [topMin setPriority:CPLayoutPriorityRequired];
        [top setPriority:alignmentHuggingPriority];
        [bottomMin setPriority:alignmentClippingPriority];
        [bottom setPriority:alignmentHuggingPriority];

        [result addObjectsFromArray:@[topMin, top, bottomMin, bottom]];

        if (idx == count - 1)
        {
            var trailingMin = [stackTrailingAnchor constraintGreaterThanOrEqualToAnchor:gravityTrailingAnchor constant:trailingInset];
            [trailingMin setPriority:clippingPriority];

            var trailingMax = [stackTrailingAnchor constraintLessThanOrEqualToAnchor:gravityTrailingAnchor constant:trailingInset],
                priority = isFillDistribution ? CPLayoutPriorityRequired : CPLayoutPriorityDefaultHigh;
            [trailingMax setPriority:priority];

            [result addObjectsFromArray:@[trailingMin, trailingMax]];
        }

        if (aGravity == CPStackViewGravityCenter && count == 3)
        {
            var gravityCenterAnchor = [gravityRect layoutAnchorForAttribute:center_attr],
                stackCenterAnchor = [self layoutAnchorForAttribute:center_attr],
                center = [gravityCenterAnchor constraintEqualToAnchor:stackCenterAnchor];

            [center setPriority:CPLayoutPriorityDefaultLow];
            [result addObject:center];
        }

        previousTrailingAnchor = gravityTrailingAnchor;

        var viewConstraints = [self _generateViewsConstraintsInGravity:aGravity];
        [result addObjectsFromArray:viewConstraints];
    }];

    return result;
}

- (CPArray)_generateViewsConstraintsInGravity:(CPStackViewGravity)aGravity
{
    var result = @[],
        previousView = nil;

    var views = [self viewsInGravity:aGravity],
        last = [views count] - 1,
        gravityRect = [self _layoutRectForGravity:aGravity];

    var leading_attr = CPLayoutAttributeLeading - 2 * _orientation,
        leading_perp_attr = CPLayoutAttributeTop + 2 * _orientation,
        trailing_attr = CPLayoutAttributeTrailing - 2 * _orientation,
        trailing_perp_attr = CPLayoutAttributeBottom + 2 * _orientation,
        dimension_attr = CPLayoutAttributeWidth + _orientation,
        center_attr = CPLayoutAttributeCenterX + _orientation;

    var gravityLeadingAnchor = [gravityRect layoutAnchorForAttribute:leading_attr],
        gravityTrailingAnchor = [gravityRect layoutAnchorForAttribute:trailing_attr],
        gravityAlignmentLeadingAnchor = [gravityRect layoutAnchorForAttribute:leading_perp_attr],
        gravityAlignmentTrailingAnchor = [gravityRect layoutAnchorForAttribute:trailing_perp_attr];

    [views enumerateObjectsUsingBlock:function(aView, idx, stop)
    {
        var leadingAnchor = [aView layoutAnchorForAttribute:leading_attr],
            trailingAnchor = [aView layoutAnchorForAttribute:trailing_attr],
            alignmentLeadingAnchor = [aView layoutAnchorForAttribute:leading_perp_attr],
            alignmentTrailingAnchor = [aView layoutAnchorForAttribute:trailing_perp_attr];

        var alignmentLeading = [alignmentLeadingAnchor constraintEqualToAnchor:gravityAlignmentLeadingAnchor];
        [result addObject:alignmentLeading];

        var alignmentTrailing = [alignmentTrailingAnchor constraintEqualToAnchor:gravityAlignmentTrailingAnchor];
        [result addObject:alignmentTrailing];

        if (idx == 0)
        {
            var leading = [leadingAnchor constraintEqualToAnchor:gravityLeadingAnchor];
            [result addObject:leading];
        }
        else
        {
            var previousViewTrailingAnchor = [previousView layoutAnchorForAttribute:trailing_attr],
                distance = [CPDistanceLayoutDimension distanceFromAnchor:previousViewTrailingAnchor toAnchor:leadingAnchor];

            var minSpacing = [distance constraintGreaterThanOrEqualToConstant:_spacing];
            [result addObject:minSpacing];

            if (_distribution == CPStackViewDistributionEqualSpacing)
            {
                var spacing = [distance constraintEqualToAnchor:[self _idealSizeLayoutDimensionInGravity:aGravity]];
                [spacing setPriority:CPStackViewDistributionPriority];
                [result addObject:spacing];
            }
            else
            {
                var spacing = [distance constraintEqualToConstant:_spacing],
                    priority = (_distribution == CPStackViewDistributionEqualCentering) ? CPStackViewDistributionPriority - 1 : CPLayoutPriorityRequired;
                [spacing setPriority:priority];
                [result addObject:spacing];
            }
        }

        if (idx == last)
        {
            var trailing = [trailingAnchor constraintEqualToAnchor:gravityTrailingAnchor];
            [result addObject:trailing];
        }

        if (_distribution == CPStackViewDistributionFillEqually)
        {
            var anchor = [aView layoutAnchorForAttribute:dimension_attr],
                idealSize = [self _idealSizeLayoutDimensionInGravity:aGravity],
                sizeConstraint = [anchor constraintEqualToAnchor:idealSize];

            [sizeConstraint setPriority:CPStackViewDistributionPriority];
            [result addObject:sizeConstraint];
        }
        else if (_distribution == CPStackViewDistributionFillProportionally)
        {
            var intrinsicSize = [aView intrinsicContentSize],
                coeff = _orientation ? intrinsicSize.height : intrinsicSize.width;

            if (coeff !== -1)
            {
                var anchor = [aView layoutAnchorForAttribute:dimension_attr],
                    idealAnchor = [self _idealSizeLayoutDimensionInGravity:aGravity];

                var sizeConstraint = [anchor constraintEqualToAnchor:idealAnchor multiplier:coeff constant:0];
                [sizeConstraint setPriority:CPStackViewDistributionPriority];
                [result addObject:sizeConstraint];
            }
        }

        previousView = aView;
    }];

    if (_distribution == CPStackViewDistributionEqualCentering)
    {
        var centeringConstraints = [self _equalCenteringConstraintsInGravity:aGravity];
        [result addObjectsFromArray:centeringConstraints];
    }

    return result;
}

- (CPArray)_equalCenteringConstraintsInGravity:(CPStackViewGravity)aGravity
{
    var result = @[],
        views = [self viewsInGravity:aGravity],
        count = [views count],
        huggingPriority = [self huggingPriorityForOrientation:_orientation],
        center_attr = CPLayoutAttributeCenterX + _orientation;

    [views enumerateObjectsUsingBlock:function(aView, idx, stop)
    {
        var midAnchor = [aView layoutAnchorForAttribute:center_attr],
            opposite = count - 1 - idx;

        if (idx == opposite)
        {
            stop(YES);
        }
        else
        {
            var opp_view = [views objectAtIndex:opposite];
            midAnchor = [midAnchor anchorAtMidpointToAnchor:[opp_view layoutAnchorForAttribute:center_attr]];
        }

        var centering = [midAnchor constraintEqualToAnchor:[self layoutAnchorForAttribute:center_attr]];
        [centering setPriority:CPStackViewDistributionPriority];
        [result addObject:centering];
    }];

    return result;
}

- (CPLayoutDimension)_idealSizeLayoutDimensionInGravity:(CPStackViewGravity)aGravity
{
    var name = [CPString stringWithFormat:@"Ideal.%@", [self _nameForGravity:aGravity]],
        result = [_idealSizeForGravity objectForKey:name];

    if (result == nil)
    {
        result = [CPLayoutDimension anchorNamed:name inItem:self];
        [_idealSizeForGravity setObject:result forKey:name];
    }

    return result;
}

- (CPInteger)_leadingInsetForOrientation:(CPLayoutConstraintOrientation)orientation
{
    return orientation ? _edgeInsets.top : _edgeInsets.left;
}

- (CPInteger)_trailingInsetForOrientation:(CPLayoutConstraintOrientation)orientation
{
    return orientation ? _edgeInsets.bottom : _edgeInsets.right;
}
/*
- (CPLayoutPriority)_maxSubviewsHuggingPriorityInGravity:(CPStackViewGravity)aGravity
{
    var result = 0,
        views = [self viewsInGravity:aGravity];

    [views enumerateObjectsUsingBlock:function(aView, idx, stop)
    {
        result = MAX(result, [aView contentHuggingPriorityForOrientation:_orientation]);

        if (result == CPLayoutPriorityRequired)
            stop(YES);
    }];

    return result;
}
*/
/*
- (CPLayoutConstraint)stackConstraintWithName:(CPString)aName
{
    var cst = [_stackConstraintsDictionary objectForKey:aName];

    if (cst !== nil)
        return cst;

    [_stackConstraintsDictionary setObject:cst forKey:aName];

    return cst;
}
*/

// GRAVITIES
- (CPStackViewGravity)_gravityForName:(CPString)aName
{
    var s = [CPScanner scannerWithString:aName];
    [s scanString:@"gravity-" intoString:NULL];

    return [s scanInt];
}

- (void)_enumerateGravitiesUsingBlock:(Function)aFunction
{
    var idx = 0;

    for (var aGravity = CPStackViewGravityLeading; aGravity <= CPStackViewGravityTrailing; aGravity++)
    {
        if (_gravitiesMask & (1 << aGravity))
        {
            aFunction(aGravity, idx);
            idx++;
        }
    }
}

- (CPInteger)countOfGravities
{
    return (_gravitiesMask & 2) / 2 + (_gravitiesMask & 4) / 4 + (_gravitiesMask & 8) / 8;
}

- (CPString)_nameForGravity:(CPStackViewGravity)aGravity
{
    return [CPString stringWithFormat:@"gravity-%d", aGravity];
}

- (CPArray)_mutableViewsInGravity:(CPStackViewGravity)aGravity
{
    var gravity_key = [self _nameForGravity:aGravity],
        result = [_viewsInGravity objectForKey:gravity_key];

    if (result == nil)
    {
        result = [CPArray array];
        [_viewsInGravity setObject:result forKey:gravity_key];
    }

    return result;
}

- (CPLayoutRect)_layoutRectForGravity:(CPStackViewGravity)aGravity
{
    var layoutRectKey = [self _nameForGravity:aGravity],
        result = [_gravityLayoutRects objectForKey:layoutRectKey];

    if (result == nil)
    {
        result = [[CPLayoutRect alloc] initWithName:layoutRectKey inItem:self];
        [_gravityLayoutRects setObject:result forKey:layoutRectKey];
    }

    return result;
}
/*
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
*/

@end

var CPStackViewAlignment                    = @"CPStackViewAlignment",
    CPStackViewAlignmentPriority            = @"CPStackViewAlignmentPriority",
    CPStackViewOrientation                  = @"CPStackViewOrientation",
    CPStackViewDistributionKey              = @"CPStackViewDistribution",
    CPStackViewSpacing                      = @"CPStackViewSpacing",
    CPStackViewEdgeInsets                   = @"CPStackViewEdgeInsets",
    CPStackViewHorizontalClippingResistance = @"CPStackViewHorizontalClippingResistance",
    CPStackViewVerticalClippingResistance   = @"CPStackViewVerticalClippingResistance",
    CPStackViewHorizontalHugging            = @"CPStackViewHorizontalHugging",
    CPStackViewVerticalHugging              = @"CPStackViewVerticalHugging",
    CPStackViewGravityViews                 = @"CPStackViewGravityViews",
    CPStackViewHasFlatViewHierarchy         = @"CPStackViewHasFlatViewHierarchy";

@implementation CPStackView (CPCoding)

- (void)_cibDidFinishLoadingWithOwner:(id)anOwner
{
    [_viewsInGravity enumerateKeysAndObjectsUsingBlock:function(key, views, stop)
    {
        var gravity = [self _gravityForName:key];
        [self setViews:views inGravity:gravity];
    }];
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    _orientation = [aCoder decodeIntForKey:CPStackViewOrientation];

    if ([aCoder containsValueForKey:CPStackViewDistributionKey])
        _distribution = [aCoder decodeIntForKey:CPStackViewDistributionKey];
    else
        _distribution = CPStackViewDistributionGravityAreas;

    if ([aCoder containsValueForKey:CPStackViewAlignment])
        _alignment = [aCoder decodeIntForKey:CPStackViewAlignment];
    else
        _alignment = CPLayoutAttributeTop;

    _alignmentPriority = [aCoder decodeIntForKey:CPStackViewAlignmentPriority] || CPStackViewDistributionPriority;

    _spacing = [aCoder decodeFloatForKey:CPStackViewSpacing];

    if ([aCoder containsValueForKey:CPStackViewEdgeInsets])
    {
        var insets = [aCoder decodeObjectForKey:CPStackViewEdgeInsets];
        _edgeInsets = CGInsetMake(insets[0], insets[1], insets[2], insets[3]);
    }
    else
    {
        _edgeInsets = CGInsetMakeZero();
    }

    _horizontalClippingResistancePriority = [aCoder decodeIntForKey:CPStackViewHorizontalClippingResistance];
    _verticalClippingResistancePriority = [aCoder decodeIntForKey:CPStackViewVerticalClippingResistance];
    _horizontalHuggingPriority = [aCoder decodeIntForKey:CPStackViewHorizontalHugging];
    _verticalHuggingPriority = [aCoder decodeIntForKey:CPStackViewVerticalHugging];
    _stackViewDecodedWantingFlatHierarchy = [aCoder decodeBoolForKey:CPStackViewHasFlatViewHierarchy];

    [self _init];

    _viewsInGravity = [aCoder decodeObjectForKey:CPStackViewGravityViews];

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeInt:_orientation forKey:CPStackViewOrientation];

    if (_distribution !== CPStackViewDistributionGravityAreas)
        [aCoder encodeInt:_distribution forKey:CPStackViewDistributionKey];

    if (_alignment !== CPLayoutAttributeTop)
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

    [aCoder encodeObject:_viewsInGravity forKey:CPStackViewGravityViews];
    [aCoder encodeBool:_stackViewDecodedWantingFlatHierarchy forKey:CPStackViewHasFlatViewHierarchy];
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
