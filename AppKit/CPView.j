/*
 * CPView.j
 * AppKit
 *
 * Created by Francisco Tolmasky.
 * Copyright 2008, 280 North, Inc.
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
@import <Foundation/CPObjJRuntime.j>
@import <Foundation/CPSet.j>
@import <Foundation/CPIndexSet.j>

@import "_CPObject+Theme.j"
@import "CGAffineTransform.j"
@import "CGGeometry.j"
@import "CPAppearance.j"
@import "CPColor.j"
@import "CPGraphicsContext.j"
@import "CPResponder.j"
@import "CPTheme.j"
@import "CPTrackingArea.j"
@import "CPWindow_Constants.j"
@import "_CPDisplayServer.j"

@import "CPLayoutConstraint.j"
@import "CPContentSizeLayoutConstraint.j"
@import "CPAutoresizingMaskLayoutConstraint.j"
@import "CPLayoutAnchor.j"

@class _CPToolTip
@class CPWindow
@class _CPMenuItemView
@class CPPlatformWindow
@class CPMenu
@class CPClipView
@class CPScrollView
@class CALayer
@class CPLayoutConstraintEngine
@class _CPCibCustomView

@global appkit_tag_dom_elements

@typedef _CPViewFullScreenModeState

#if PLATFORM(DOM)

if (typeof(appkit_tag_dom_elements) !== "undefined" && appkit_tag_dom_elements)
{
    AppKitTagDOMElement = function(owner, element)
    {
        element.setAttribute("data-cappuccino-view", [owner className]);
        element.setAttribute("data-cappuccino-uid", [owner UID]);
    }
}
else
{
    AppKitTagDOMElement = function(owner, element)
    {
       // By default, do nothing.
    }
}

#endif

/*
    @global
    @group CPViewAutoresizingMasks
    The default resizingMask, the view will not resize or reposition itself.
*/
CPViewNotSizable    = 0;
/*
    @global
    @group CPViewAutoresizingMasks
    Allow for flexible space on the left hand side of the view.
*/
CPViewMinXMargin    = 1;
/*
    @global
    @group CPViewAutoresizingMasks
    The view should grow and shrink horizontally with its parent view.
*/
CPViewWidthSizable  = 2;
/*
    @global
    @group CPViewAutoresizingMasks
    Allow for flexible space to the right hand side of the view.
*/
CPViewMaxXMargin    = 4;
/*
    @global
    @group CPViewAutoresizingMasks
    Allow for flexible space above the view.
*/
CPViewMinYMargin    = 8;
/*
    @global
    @group CPViewAutoresizingMasks
    The view should grow and shrink vertically with its parent view.
*/
CPViewHeightSizable = 16;
/*
    @global
    @group CPViewAutoresizingMasks
    Allow for flexible space below the view.
*/
CPViewMaxYMargin    = 32;

_CPViewWillAppearNotification        = @"CPViewWillAppearNotification";
_CPViewDidAppearNotification         = @"CPViewDidAppearNotification";
_CPViewWillDisappearNotification     = @"CPViewWillDisappearNotification";
_CPViewDidDisappearNotification      = @"CPViewDidDisappearNotification";

CPViewBoundsDidChangeNotification   = @"CPViewBoundsDidChangeNotification";
CPViewFrameDidChangeNotification    = @"CPViewFrameDidChangeNotification";

CPViewNoInstrinsicMetric = -1;

var CachedNotificationCenter    = nil;

#if PLATFORM(DOM)
var DOMElementPrototype         = nil,

    BackgroundTrivialColor              = 0,
    BackgroundVerticalThreePartImage    = 1,
    BackgroundHorizontalThreePartImage  = 2,
    BackgroundNinePartImage             = 3,
    BackgroundTransparentColor          = 4;
#endif

var CPViewFlags                     = { },
    CPViewHasCustomDrawRect         = 1 << 0,
    CPViewHasCustomLayoutSubviews   = 1 << 1,
    CPViewHasCustomViewWillLayout   = 1 << 2;

var CPViewHighDPIDrawingEnabled = YES;

/*!
    @ingroup appkit
    @class CPView

    <p>CPView is a class which provides facilities for drawing
    in a window and receiving events. It is the superclass of many of the visual
    elements of the GUI.</p>

    <p>In order to display itself, a view must be placed in a window (represented by an
    CPWindow object). Within the window is a hierarchy of CPViews,
    headed by the window's content view. Every other view in a window is a descendant
    of this view.</p>

    <p>Subclasses can override \c -drawRect: in order to implement their
    appearance. Other methods of CPView and CPResponder can
    also be overridden to handle user generated events.
*/
@implementation CPView : CPResponder <CPTheme>
{
    CPWindow            _window;

    CPView              _superview;
    CPArray             _subviews;

    CPGraphicsContext   _graphicsContext;

    int                 _tag;
    CPString            _identifier @accessors(property=identifier);

    CGRect              _frame;
    CGRect              _bounds;
    CGAffineTransform   _boundsTransform;
    CGAffineTransform   _inverseBoundsTransform;

    CPSet               _registeredDraggedTypes;
    CPArray             _registeredDraggedTypesArray;

    BOOL                _isHidden;
    BOOL                _isHiddenOrHasHiddenAncestor;
    BOOL                _hitTests;
    BOOL                _clipsToBounds;

    BOOL                _postsFrameChangedNotifications;
    BOOL                _postsBoundsChangedNotifications;
    BOOL                _inhibitFrameAndBoundsChangedNotifications;
    BOOL                _inLiveResize;
    BOOL                _isSuperviewAClipView;

#if PLATFORM(DOM)
    DOMElement          _DOMElement;
    DOMElement          _DOMContentsElement;

    CPArray             _DOMImageParts;
    CPArray             _DOMImageSizes;

    unsigned            _backgroundType;
#endif

    CGRect              _dirtyRect;

    float               _opacity;
    CPColor             _backgroundColor;

    BOOL                _autoresizesSubviews;
    unsigned            _autoresizingMask;

    CALayer             _layer;
    BOOL                _wantsLayer;

    // Full Screen State
    BOOL                _isInFullScreenMode;

    _CPViewFullScreenModeState  _fullScreenModeState;

    // Zoom Support
    BOOL                _isScaled;
    CGSize              _hierarchyScaleSize;
    CGSize              _scaleSize;

    // Drawing high DPI
    BOOL                _needToSetTransformMatrix;
    float               _highDPIRatio;

    // Layout Support
    BOOL                _needsLayout;
    JSObject            _ephemeralSubviews;

    JSObject            _ephemeralSubviewsForNames;
    CPSet               _ephereralSubviews;

    // Key View Support
    CPView              _nextKeyView;
    CPView              _previousKeyView;

    unsigned            _viewClassFlags;

    // ToolTips
    CPString            _toolTip    @accessors(getter=toolTip);
    Function            _toolTipFunctionIn;
    Function            _toolTipFunctionOut;
    BOOL                _toolTipInstalled;

    BOOL                _isObserving;

    BOOL                _allowsVibrancy         @accessors(property=allowsVibrancy);
    CPAppearance        _appearance             @accessors(getter=appearance);
    CPAppearance        _effectiveAppearance;

    CPMutableArray      _trackingAreas          @accessors(getter=trackingAreas, copy);
    BOOL                _inhibitUpdateTrackingAreas;

    id                  _animator;
    CPDictionary        _animationsDictionary;
    BOOL                _inhibitDOMUpdates      @accessors(setter=_setInhibitDOMUpdates);
    BOOL                _forceUpdates           @accessors(setter=_setForceUpdates);

    // ConstraintBasedLayout support
    CPLayoutConstraintEngine _localEngine       @accessors(getter=_localEngineIvar);
    CPArray  _constraintsArray                  @accessors(property=_constraintsArray);
    CPArray  _autoresizingConstraints           @accessors;
    CPArray  _internalConstraints               @accessors(property=_internalConstraints);
    CPArray  _contentSizeConstraints            @accessors(property=_contentSizeConstraints);

    CGSize   _huggingPriorities                 @accessors;
    CGSize   _compressionPriorities             @accessors;
    BOOL     _translatesAutoresizingMaskIntoConstraints @accessors(property=translatesAutoresizingMaskIntoConstraints);

    CGSize   _storedIntrinsicContentSize                @accessors(property=storedIntrinsicContentSize);

    BOOL     _needsUpdateConstraints                    @accessors(property=needsUpdateConstraints);
    // A regular contraint owned by a subview was added to the engine. The engine needs to solve.
    BOOL     _subviewsNeedSolvingInEngine;
    // Is the view geometry dirty and does it need to set its frame from the current engine variables ?
    unsigned int _geometryDirtyMask;

    BOOL     _isSettingFrameFromEngine;
    BOOL     _viewIsConstraintBased;
    BOOL     _viewHasConstraintBasedSubviews;
    BOOL     _topLevelViewExtraConstraintsAdded;

    CPLayoutAnchor _leftAnchor;
    CPLayoutAnchor _rightAnchor;
    CPLayoutAnchor _topAnchor;
    CPLayoutAnchor _bottomAnchor;
    CPLayoutAnchor _lastBaselineAnchor;
    CPLayoutAnchor _firstBaselineAnchor;
    CPLayoutAnchor _leadingAnchor;
    CPLayoutAnchor _trailingAnchor;
    CPLayoutAnchor _widthAnchor;
    CPLayoutAnchor _heightAnchor;
    CPLayoutAnchor _centerXAnchor;
    CPLayoutAnchor _centerYAnchor;

    Variable       _variableMinX;
    Variable       _variableMinY;
    Variable       _variableWidth;
    Variable       _variableHeight;
}

/*
    Private method for Objective-J.
    @ignore
*/
+ (void)initialize
{
    if (self !== [CPView class])
        return;

#if PLATFORM(DOM)
    DOMElementPrototype =  document.createElement("div");

    var style = DOMElementPrototype.style;

    style.overflow = "hidden";
    style.position = "absolute";
    style.visibility = "visible";
    style.zIndex = 0;
#endif

    CachedNotificationCenter = [CPNotificationCenter defaultCenter];
}

+ (Class)_binderClassForBinding:(CPString)aBinding
{
    if ([aBinding hasPrefix:CPHiddenBinding])
        return [CPMultipleValueOrBinding class];

    return [super _binderClassForBinding:aBinding];
}

/*!
    Controls whether high DPI drawing is activated or not. Defaults to YES.
    @param isEnabled YES to enable high DPI drawing
*/
+ (void)setHighDPIDrawingEnabled:(BOOL)isEnabled
{
    CPViewHighDPIDrawingEnabled = isEnabled;
}

/*!
    Returns whether high DPI drawing is enabled.
    @return BOOL - YES if high DPI drawing is activated, otherwise NO.
*/
+ (BOOL)isHighDPIDrawingEnabled
{
    return CPViewHighDPIDrawingEnabled;
}

+ (CPSet)keyPathsForValuesAffectingFrame
{
    return [CPSet setWithObjects:@"frameOrigin", @"frameSize"];
}

+ (CPSet)keyPathsForValuesAffectingBounds
{
    return [CPSet setWithObjects:@"boundsOrigin", @"boundsSize"];
}

+ (CPMenu)defaultMenu
{
    return nil;
}

- (void)_setupViewFlags
{
    var theClass = [self class],
        classUID = [theClass UID];

    if (CPViewFlags[classUID] === undefined)
    {
        var flags = 0;

        if ([theClass instanceMethodForSelector:@selector(drawRect:)] !== [CPView instanceMethodForSelector:@selector(drawRect:)]
            || [theClass instanceMethodForSelector:@selector(viewWillDraw)] !== [CPView instanceMethodForSelector:@selector(viewWillDraw)])
            flags |= CPViewHasCustomDrawRect;

        if ([theClass instanceMethodForSelector:@selector(viewWillLayout)] !== [CPView instanceMethodForSelector:@selector(viewWillLayout)])
            flags |= CPViewHasCustomViewWillLayout;

        if ([theClass instanceMethodForSelector:@selector(layoutSubviews)] !== [CPView instanceMethodForSelector:@selector(layoutSubviews)])
            flags |= CPViewHasCustomLayoutSubviews;

        CPViewFlags[classUID] = flags;
    }

    _viewClassFlags = CPViewFlags[classUID];
}

- (void)_setNeedsConstraintBasedLayout
{
    _viewIsConstraintBased = YES;
}

- (BOOL)_needsConstraintBasedLayout
{
    return _viewIsConstraintBased;
}

- (void)_setHasConstraintBasedLayoutSubviews
{
    _viewHasConstraintBasedSubviews = YES;
}

- (BOOL)_hasConstraintBasedLayoutSubviews
{
    return _viewHasConstraintBasedSubviews;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(CPString)theKey
{
    if ([theKey isEqualToString:@"constraints"])
        return NO;

    return [super automaticallyNotifiesObserversForKey:theKey];
}

- (id)init
{
    return [self initWithFrame:CGRectMakeZero()];
}

/*!
    Initializes the receiver for usage with the specified bounding rectangle
    @return the initialized view
*/
- (id)initWithFrame:(CGRect)aFrame
{
    self = [super init];

    if (self)
    {
        var width = CGRectGetWidth(aFrame),
            height = CGRectGetHeight(aFrame);

        _subviews = [];
        _registeredDraggedTypes = [CPSet set];
        _registeredDraggedTypesArray = [];

        _trackingAreas = [];

        _tag = -1;

        _frame = CGRectMakeCopy(aFrame);
        _bounds = CGRectMake(0.0, 0.0, width, height);

        _autoresizingMask = CPViewNotSizable;
        _autoresizesSubviews = YES;
        _clipsToBounds = YES;

        _opacity = 1.0;
        _isHidden = NO;
        _isHiddenOrHasHiddenAncestor = NO;
        _hitTests = YES;

        _hierarchyScaleSize = CGSizeMake(1.0 , 1.0);
        _scaleSize = CGSizeMake(1.0, 1.0);
        _isScaled = NO;

        _theme = [CPTheme defaultTheme];
        _themeState = CPThemeStateNormal;

#if PLATFORM(DOM)
        _DOMElement = DOMElementPrototype.cloneNode(false);
        AppKitTagDOMElement(self, _DOMElement);

        CPDOMDisplayServerSetStyleLeftTop(_DOMElement, NULL, CGRectGetMinX(aFrame), CGRectGetMinY(aFrame));
        CPDOMDisplayServerSetStyleSize(_DOMElement, width, height);

        _DOMImageParts = [];
        _DOMImageSizes = [];
#endif

        _animator = nil;
        _animationsDictionary = @{};

        [self _setupViewFlags];
        [self _loadThemeAttributes];

        _inhibitDOMUpdates = NO;
        _forceUpdates = NO;

        [self _initAutolayoutIvars];

        _translatesAutoresizingMaskIntoConstraints = YES;
        _huggingPriorities = nil;
        _compressionPriorities = nil;
    }

    return self;
}

/*!
    Sets the tooltip for the receiver.

    @param aToolTip the tooltip
*/
- (void)setToolTip:(CPString)aToolTip
{
    if (_toolTip === aToolTip)
        return;

    if (aToolTip && ![aToolTip isKindOfClass:CPString])
        aToolTip = [aToolTip description];

    _toolTip = aToolTip;

    [self _manageToolTipInstallation];
}

- (void)_manageToolTipInstallation
{
    if ([self window] && _toolTip)
        [self _installToolTipEventHandlers];
    else
        [self _uninstallToolTipEventHandlers];
}
/*! @ignore

    Install the handlers for the tooltip
*/
- (void)_installToolTipEventHandlers
{
    if (_toolTipInstalled)
        return;

    if (!_toolTipFunctionIn)
        _toolTipFunctionIn = function(e) { [_CPToolTip scheduleToolTipForView:self]; }

    if (!_toolTipFunctionOut)
        _toolTipFunctionOut = function(e) { [_CPToolTip invalidateCurrentToolTipIfNeeded]; };

#if PLATFORM(DOM)
    if (_DOMElement.addEventListener)
    {
        _DOMElement.addEventListener("mouseover", _toolTipFunctionIn, YES);
        _DOMElement.addEventListener("keypress", _toolTipFunctionOut, YES);
        _DOMElement.addEventListener("mouseout", _toolTipFunctionOut, YES);
    }
    else if (_DOMElement.attachEvent)
    {
        _DOMElement.attachEvent("onmouseover", _toolTipFunctionIn);
        _DOMElement.attachEvent("onkeypress", _toolTipFunctionOut);
        _DOMElement.attachEvent("onmouseout", _toolTipFunctionOut);
    }
#endif

    _toolTipInstalled = YES;
}

/*! @ignore

    Uninstall the handlers for the tooltip
*/
- (void)_uninstallToolTipEventHandlers
{
    if (!_toolTipInstalled)
        return;

#if PLATFORM(DOM)
    if (_DOMElement.removeEventListener)
    {
        _DOMElement.removeEventListener("mouseover", _toolTipFunctionIn, YES);
        _DOMElement.removeEventListener("keypress", _toolTipFunctionOut, YES);
        _DOMElement.removeEventListener("mouseout", _toolTipFunctionOut, YES);
    }
    else if (_DOMElement.detachEvent)
    {
        _DOMElement.detachEvent("onmouseover", _toolTipFunctionIn);
        _DOMElement.detachEvent("onkeypress", _toolTipFunctionOut);
        _DOMElement.detachEvent("onmouseout", _toolTipFunctionOut);
    }
#endif

    _toolTipFunctionIn = nil;
    _toolTipFunctionOut = nil;

    _toolTipInstalled = NO;
}

/*!
    Returns the container view of the receiver
    @return the receiver's containing view
*/
- (CPView)superview
{
    return _superview;
}

/*!
    Returns an array of all the views contained as direct children of the receiver
    @return an array of CPViews
*/
- (CPArray)subviews
{
    return [_subviews copy];
}

/*!
    Returns the window containing this receiver
*/
- (CPWindow)window
{
    return _window;
}

/*!
    Makes the argument a subview of the receiver.
    @param aSubview the CPView to make a subview
*/
- (void)addSubview:(CPView)aSubview
{
    [self _insertSubview:aSubview atIndex:CPNotFound];
}

/*!
    Makes \c aSubview a subview of the receiver. It is positioned relative to \c anotherView
    @param aSubview the view to add as a subview
    @param anOrderingMode specifies \c aSubview's ordering relative to \c anotherView
    @param anotherView \c aSubview will be positioned relative to this argument
*/
- (void)addSubview:(CPView)aSubview positioned:(CPWindowOrderingMode)anOrderingMode relativeTo:(CPView)anotherView
{
    var index = anotherView ? [_subviews indexOfObjectIdenticalTo:anotherView] : CPNotFound;

    // In other words, if no view, then either all the way at the bottom or all the way at the top.
    if (index === CPNotFound)
        index = (anOrderingMode === CPWindowAbove) ? [_subviews count] : 0;

    // else, if we have a view, above if above.
    else if (anOrderingMode === CPWindowAbove)
        ++index;

    [self _insertSubview:aSubview atIndex:index];
}

/* @ignore */
- (void)_insertSubview:(CPView)aSubview atIndex:(int)anIndex
{
    if (aSubview === self)
        [CPException raise:CPInvalidArgumentException reason:"can't add a view as a subview of itself"];
#if DEBUG
    if (!aSubview._superview && _subviews.indexOf(aSubview) !== CPNotFound)
        [CPException raise:CPInvalidArgumentException reason:"can't insert a subview in duplicate (probably partially decoded)"];
#endif

    // Notify the subview that it will be moving.
    [aSubview viewWillMoveToSuperview:self];

    // We will have to adjust the z-index of all views starting at this index.
    var count = _subviews.length,
        lastWindow;

    // Dirty the key view loop, in case the window wants to auto recalculate it
    [[self window] _dirtyKeyViewLoop];

    // If this is already one of our subviews, remove it.
    if (aSubview._superview === self)
    {
        var index = [_subviews indexOfObjectIdenticalTo:aSubview];

        // FIXME: should this be anIndex >= count? (last one)
        if (index === anIndex || index === count - 1 && anIndex === count)
            return;

        [_subviews removeObjectAtIndex:index];

#if PLATFORM(DOM)
        CPDOMDisplayServerRemoveChild(_DOMElement, aSubview._DOMElement);
#endif

        if (anIndex > index)
            --anIndex;

        //We've effectively made the subviews array shorter, so represent that.
        --count;
    }
    else
    {
        var superview = aSubview._superview;

        lastWindow = [superview window];

        // Remove the view from its previous superview.
        [aSubview _removeFromSuperview];

        [aSubview _postViewWillAppearNotification];
        // Set ourselves as the superview.
        [aSubview _setSuperview:self];
    }

    if (anIndex === CPNotFound || anIndex >= count)
    {
        _subviews.push(aSubview);

#if PLATFORM(DOM)
        // Attach the actual node.
        CPDOMDisplayServerAppendChild(_DOMElement, aSubview._DOMElement);
#endif
    }
    else
    {
        _subviews.splice(anIndex, 0, aSubview);

#if PLATFORM(DOM)
        // Attach the actual node.
        CPDOMDisplayServerInsertBefore(_DOMElement, aSubview._DOMElement, _subviews[anIndex + 1]._DOMElement);
#endif
    }

    [aSubview setNextResponder:self];
    [aSubview _scaleSizeUnitSquareToSize:[self _hierarchyScaleSize]];

    [aSubview viewDidMoveToSuperview];

    // Set the subview's window to our own.
    if (_window)
        [aSubview _setWindow:_window];

    if (!_window && lastWindow)
        [aSubview _setWindow:nil];

    // This method might be called before we are fully unarchived, in which case the theme state isn't set up yet
    // and none of the below matters anyhow.
    if (_themeState)
    {
        if ([self hasThemeState:CPThemeStateFirstResponder])
            [aSubview _notifyViewDidBecomeFirstResponder];
        else
            [aSubview _notifyViewDidResignFirstResponder];

        if ([self hasThemeState:CPThemeStateKeyWindow])
            [aSubview _notifyWindowDidBecomeKey];
        else
            [aSubview _notifyWindowDidResignKey];
    }

    [self didAddSubview:aSubview];
/*
    //ConstraintBasedLayout
    if ([self _subtreeNeedsUpdateConstraint])
        [self _informSuperviewThatSubviewsNeedUpdateConstraints];
*/
}

/*!
    Called when the receiver has added \c aSubview to it's child views.
    @param aSubview the view that was added
*/
- (void)didAddSubview:(CPView)aSubview
{
}

/*!
    Removes the receiver from it's container view and window.
    Does nothing if there's no container view.
*/
- (void)removeFromSuperview
{
    var superview = _superview;

    [self viewWillMoveToSuperview:nil];
    [self _removeFromSuperview];
    [self viewDidMoveToSuperview];

    if (superview)
        [self _setWindow:nil];
}

- (void)_removeFromSuperview
{
    if (!_superview)
        return;

    // Dirty the key view loop, in case the window wants to auto recalculate it
    [[self window] _dirtyKeyViewLoop];

    [_superview willRemoveSubview:self];
    [self _postViewWillDisappearNotification];

    [_superview._subviews removeObjectIdenticalTo:self];

#if PLATFORM(DOM)
    CPDOMDisplayServerRemoveChild(_superview._DOMElement, _DOMElement);
#endif

    // If the view is not hidden and one of its ancestors is hidden,
    // notify the view that it is now unhidden.
    [self _setSuperview:nil];

    [self _notifyWindowDidResignKey];
    [self _notifyViewDidResignFirstResponder];
}

/*!
    Replaces the specified child view with another view
    @param aSubview the view to replace
    @param aView the replacement view
*/
- (void)replaceSubview:(CPView)aSubview with:(CPView)aView
{
    if (aSubview._superview !== self || aSubview === aView)
        return;

    var index = [_subviews indexOfObjectIdenticalTo:aSubview];

    [self _insertSubview:aView atIndex:index];

    [aSubview removeFromSuperview];
}

- (void)setSubviews:(CPArray)newSubviews
{
    if (!newSubviews)
        [CPException raise:CPInvalidArgumentException reason:"newSubviews cannot be nil in -[CPView setSubviews:]"];

    // Trivial Case 0: Same array somehow
    if ([_subviews isEqual:newSubviews])
        return;

    // Trivial Case 1: No current subviews, simply add all new subviews.
    if ([_subviews count] === 0)
    {
        var index = 0,
            count = [newSubviews count];

        for (; index < count; ++index)
            [self addSubview:newSubviews[index]];

        return;
    }

    // Trivial Case 2: No new subviews, simply remove all current subviews.
    if ([newSubviews count] === 0)
    {
        var count = [_subviews count];

        while (count--)
            [_subviews[count] removeFromSuperview];

        return;
    }

    // Find out the views that were removed.
    var removedSubviews = [CPMutableSet setWithArray:_subviews];

    [removedSubviews removeObjectsInArray:newSubviews];
    [removedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // Find out which views need to be added.
    var addedSubviews = [CPMutableSet setWithArray:newSubviews];

    [addedSubviews removeObjectsInArray:_subviews];

    var addedSubview = nil,
        addedSubviewEnumerator = [addedSubviews objectEnumerator];

    while ((addedSubview = [addedSubviewEnumerator nextObject]) !== nil)
        [self addSubview:addedSubview];

    // If the order is fine, no need to reorder.
    if ([_subviews isEqual:newSubviews])
        return;

    _subviews = [newSubviews copy];

#if PLATFORM(DOM)
    var index = 0,
        count = [_subviews count];

    for (; index < count; ++index)
    {
        var subview = _subviews[index];

        CPDOMDisplayServerRemoveChild(_DOMElement, subview._DOMElement);
        CPDOMDisplayServerAppendChild(_DOMElement, subview._DOMElement);
    }
#endif
}

/* @ignore */
- (void)_setWindow:(CPWindow)aWindow
{
    [[self window] _dirtyKeyViewLoop];

    // Clear out first responder if we're the first responder and leaving.
    if ([_window firstResponder] === self && _window != aWindow)
        [_window makeFirstResponder:nil];

    // Notify the view and its subviews
    [self viewWillMoveToWindow:aWindow];

    // Unregister the drag events from the current window and register
    // them in the new window.
    if (_registeredDraggedTypes)
    {
        [_window _noteUnregisteredDraggedTypes:_registeredDraggedTypes];
        [aWindow _noteRegisteredDraggedTypes:_registeredDraggedTypes];
    }

    // View must be removed from the current window viewsWithTrackingAreas
    if (_window && (_trackingAreas.length > 0))
        [_window _removeTrackingAreaView:self];

    _window = aWindow;

    if (_window)
    {
        var owners;

        if (_trackingAreas.length > 0)
        {
            // View must be added to the new window viewsWithTrackingAreas
            [_window _addTrackingAreaView:self];
            owners = [self _calcTrackingAreaOwners];
        }
        else
            owners = [self];

        // Notify that view tracking areas should be updated
        // Cocoa doesn't notify on leaving a window
        [self _updateTrackingAreasForOwners:owners];
    }

    var count = [_subviews count];

    while (count--)
        [_subviews[count] _setWindow:aWindow];

    if ([_window isKeyWindow])
        [self setThemeState:CPThemeStateKeyWindow];
    else
        [self unsetThemeState:CPThemeStateKeyWindow];

    [self viewDidMoveToWindow];

    [self _manageToolTipInstallation];

    [[self window] _dirtyKeyViewLoop];

    if (_window && _needsUpdateConstraints)
    {
        [_window _setSubviewsNeedUpdateConstraints];
    }

    // The local engine is created on the top level view only.
    if (_localEngine !== nil)
    {
        if ([_window _shouldEngageAutolayout])
            [self _promoteLocalEngineToWindowEngine];

        // TODO: if we don't enable autolayout, local engine variables should be reseted.
        _localEngine = nil;
    }
}

/*!
    Returns \c YES if the receiver is, or is a descendant of, \c aView.
    @param aView the view to test for ancestry
*/
- (BOOL)isDescendantOf:(CPView)aView
{
    var view = self;

    do
    {
        if (view === aView)
            return YES;
    } while(view = [view superview])

    return NO;
}

/*!
    Called when the receiver's superview has changed.
*/
- (void)viewDidMoveToSuperview
{
    [self setNeedsLayout:YES];
    [self setNeedsDisplay:YES];
}

/*!
    Called when the receiver has been moved to a new CPWindow.
*/
- (void)viewDidMoveToWindow
{

}

/*!
    Called when the receiver is about to be moved to a new view.
    @param aView the view to which the receiver will be moved
*/
- (void)viewWillMoveToSuperview:(CPView)aView
{
    _isSuperviewAClipView = [aView isKindOfClass:[CPClipView class]];

    [self _removeObservers];

    if (aView)
        [self _addObservers];
}

/*!
    Called when the receiver is about to be moved to a new window.
    @param aWindow the window to which the receiver will be moved.
*/
- (void)viewWillMoveToWindow:(CPWindow)aWindow
{
}

/*!
    Called when the receiver is about to remove one of its subviews.
    @param aView the view that will be removed
*/
- (void)willRemoveSubview:(CPView)aView
{
}

- (void)_removeObservers
{
    if (!_isObserving)
        return;

    var count = [_subviews count];

    while (count--)
        [_subviews[count] _removeObservers];

    _isObserving = NO;
}

- (void)_addObservers
{
    if (_isObserving)
        return;

    var count = [_subviews count];

    while (count--)
        [_subviews[count] _addObservers];

    _isObserving = YES;
}

/*!
    Returns the menu item containing the receiver or one of its ancestor views.
    @return a menu item, or \c nil if the view or one of its ancestors wasn't found
*/
- (CPMenuItem)enclosingMenuItem
{
    var view = self;

    while (view && ![view isKindOfClass:[_CPMenuItemView class]])
        view = [view superview];

    if (view)
        return view._menuItem;

    return nil;
/*    var view = self,
        enclosingMenuItem = _enclosingMenuItem;

    while (!enclosingMenuItem && (view = view._enclosingMenuItem))
        view = [view superview];

    return enclosingMenuItem;*/
}

- (void)setTag:(CPInteger)aTag
{
    _tag = aTag;
}

- (CPInteger)tag
{
    return _tag;
}

- (CPView)viewWithTag:(CPInteger)aTag
{
    if ([self tag] === aTag)
        return self;

    var index = 0,
        count = _subviews.length;

    for (; index < count; ++index)
    {
        var view = [_subviews[index] viewWithTag:aTag];

        if (view)
            return view;
    }

    return nil;
}

/*!
    Returns whether the view is flipped.
    @return \c YES if the view is flipped. \c NO, otherwise.
*/
- (BOOL)isFlipped
{
    return YES;
}

/*!
    Sets the frame size of the receiver to the dimensions and origin of the provided rectangle in the coordinate system
    of the superview. The method also posts a CPViewFrameDidChangeNotification to the notification
    center if the receiver is configured to do so. If the frame is the same as the current frame, the method simply
    returns (and no notification is posted).
    @param aFrame the rectangle specifying the new origin and size  of the receiver
*/
- (void)setFrame:(CGRect)aFrame
{
    if (CGRectEqualToRect(_frame, aFrame) && !_forceUpdates)
        return;

    _inhibitFrameAndBoundsChangedNotifications = YES;

    [self setFrameOrigin:aFrame.origin];
    [self setFrameSize:aFrame.size];

    _inhibitFrameAndBoundsChangedNotifications = NO;

    if (_postsFrameChangedNotifications)
        [CachedNotificationCenter postNotificationName:CPViewFrameDidChangeNotification object:self];

    if (_isSuperviewAClipView)
        [[self superview] viewFrameChanged:[[CPNotification alloc] initWithName:CPViewFrameDidChangeNotification object:self userInfo:nil]];

    if (!_inhibitUpdateTrackingAreas)
        [self _updateTrackingAreasWithRecursion:YES];
}

/*!
    Returns the receiver's frame.
    @return a copy of the receiver's frame
*/
- (CGRect)frame
{
    return CGRectMakeCopy(_frame);
}

- (CGPoint)frameOrigin
{
    return CGPointMakeCopy(_frame.origin);
}

- (CGSize)frameSize
{
    return CGSizeMakeCopy(_frame.size);
}

/*!
    Moves the center of the receiver's frame to the provided point. The point is defined in the superview's coordinate system.
    The method posts a CPViewFrameDidChangeNotification to the default notification center if the receiver
    is configured to do so. If the specified origin is the same as the frame's current origin, the method will
    simply return (and no notification will be posted).
    @param aPoint the new origin point
*/
- (void)setCenter:(CGPoint)aPoint
{
    [self setFrameOrigin:CGPointMake(aPoint.x - _frame.size.width / 2.0, aPoint.y - _frame.size.height / 2.0)];
}

/*!
    Returns the center of the receiver's frame in the superview's coordinate system.
    @return CGPoint the center point of the receiver's frame
*/
- (CGPoint)center
{
    return CGPointMake(_frame.size.width / 2.0 + _frame.origin.x, _frame.size.height / 2.0 + _frame.origin.y);
}

/*!
    Sets the receiver's frame origin to the provided point. The point is defined in the superview's coordinate system.
    The method posts a CPViewFrameDidChangeNotification to the default notification center if the receiver
    is configured to do so. If the specified origin is the same as the frame's current origin, the method will
    simply return (and no notification will be posted).
    @param aPoint the new origin point
*/
- (void)setFrameOrigin:(CGPoint)aPoint
{
    var origin = _frame.origin;

    if (!aPoint || (CGPointEqualToPoint(origin, aPoint) && !_forceUpdates))
        return;

    origin.x = aPoint.x;
    origin.y = aPoint.y;

    if (_postsFrameChangedNotifications && !_inhibitFrameAndBoundsChangedNotifications)
        [CachedNotificationCenter postNotificationName:CPViewFrameDidChangeNotification object:self];

    if (_isSuperviewAClipView && !_inhibitFrameAndBoundsChangedNotifications)
        [[self superview] viewFrameChanged:[[CPNotification alloc] initWithName:CPViewFrameDidChangeNotification object:self userInfo:nil]];

#if PLATFORM(DOM)
    if (!_inhibitDOMUpdates)
    {
        var transform = _superview ? _superview._boundsTransform : NULL;

        CPDOMDisplayServerSetStyleLeftTop(_DOMElement, transform, origin.x, origin.y);
    }
#endif

    if (!_inhibitUpdateTrackingAreas && !_inhibitFrameAndBoundsChangedNotifications)
        [self _updateTrackingAreasWithRecursion:YES];

    if (!_isSettingFrameFromEngine && _viewIsConstraintBased)
        _FrameDidExplicitChangeInConstraintBasedLayout(self, _autoresizingConstraints, YES, NO);
}

/*!
    Sets the receiver's frame size. If \c aSize is the same as the frame's current dimensions, this
    method simply returns. The method posts a CPViewFrameDidChangeNotification to the
    default notification center if the receiver is configured to do so.
    @param aSize the new size for the frame
*/
- (void)setFrameSize:(CGSize)aSize
{
    var size = _frame.size;

    if (!aSize || (CGSizeEqualToSize(size, aSize) && !_forceUpdates))
        return;

    var oldSize = CGSizeMakeCopy(size);

    size.width = aSize.width;
    size.height = aSize.height;

    if (YES)
    {
        _bounds.size.width = aSize.width * 1 / _scaleSize.width;
        _bounds.size.height = aSize.height * 1 / _scaleSize.height;
    }

    if (_layer)
        [_layer _owningViewBoundsChanged];

    if (_autoresizesSubviews)
        [self resizeSubviewsWithOldSize:oldSize];

    if (!_isSettingFrameFromEngine || _viewClassFlags & CPViewHasCustomLayoutSubviews)
        [self setNeedsLayout];

    [self setNeedsDisplay:YES];

#if PLATFORM(DOM)
    [self _setDisplayServerSetStyleSize:size];

    if (_backgroundType !== BackgroundTrivialColor)
    {
        if (_backgroundType === BackgroundTransparentColor)
        {
            CPDOMDisplayServerSetStyleSize(_DOMImageParts[0], size.width, size.height);
        }
        else
        {
            var images = [[_backgroundColor patternImage] imageSlices],
                partIndex = 0,
                frameSize = aSize;

            if (_backgroundType === BackgroundVerticalThreePartImage)
            {
                var top = _DOMImageSizes[0] ? _DOMImageSizes[0].height : 0,
                    bottom = _DOMImageSizes[2] ? _DOMImageSizes[2].height : 0;

                // Make sure to repeat the top and bottom pieces horizontally if they're not the exact width needed.
                if (top)
                {
                    CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], frameSize.width + "px", top + "px");
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], size.width, top);
                    partIndex++;
                }
                if (_DOMImageSizes[1])
                {
                    var height = frameSize.height - top - bottom;

                    CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], frameSize.width + "px", height + "px");
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], size.width, size.height - top - bottom);
                    partIndex++;
                }
                if (bottom)
                {
                    CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], frameSize.width + "px", bottom + "px");
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], size.width, bottom);
                }
            }
            else if (_backgroundType === BackgroundHorizontalThreePartImage)
            {
                var left = _DOMImageSizes[0] ? _DOMImageSizes[0].width : 0,
                    right = _DOMImageSizes[2] ? _DOMImageSizes[2].width : 0;

                // Make sure to repeat the left and right pieces vertically if they're not the exact height needed.
                if (left)
                {
                    CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], left + "px", frameSize.height + "px");
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], left, size.height);
                    partIndex++;
                }
                if (_DOMImageSizes[1])
                {
                    var width = (frameSize.width - left - right);

                    CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], width + "px", frameSize.height + "px");
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], size.width - left - right, size.height);
                    partIndex++;
                }
                if (right)
                {
                    CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], right + "px", frameSize.height + "px");
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], right, size.height);
                }
            }
            else if (_backgroundType === BackgroundNinePartImage)
            {
                var left = _DOMImageSizes[0] ? _DOMImageSizes[0].width : 0,
                    right = _DOMImageSizes[2] ? _DOMImageSizes[2].width : 0,
                    top = _DOMImageSizes[0] ? _DOMImageSizes[0].height : 0,
                    bottom = _DOMImageSizes[6] ? _DOMImageSizes[6].height : 0,
                    width = size.width - left - right,
                    height = size.height - top - bottom;

                if (_DOMImageSizes[0])
                    partIndex++;
                if (_DOMImageSizes[1])
                {
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], width, top);
                    partIndex++;
                }
                if (_DOMImageSizes[2])
                    partIndex++;
                if (_DOMImageSizes[3])
                {
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], _DOMImageSizes[3].width, height);
                    partIndex++;
                }
                if (_DOMImageSizes[4])
                {
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], width, height);
                    partIndex++;
                }
                if (_DOMImageSizes[5])
                {
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], _DOMImageSizes[5].width, height);
                    partIndex++;
                }
                if (_DOMImageSizes[6])
                    partIndex++;
                if (_DOMImageSizes[7])
                {
                    CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], width, _DOMImageSizes[7].height);
                }
            }
        }
    }
#endif

    if (_postsFrameChangedNotifications && !_inhibitFrameAndBoundsChangedNotifications)
        [CachedNotificationCenter postNotificationName:CPViewFrameDidChangeNotification object:self];

    if (_isSuperviewAClipView && !_inhibitFrameAndBoundsChangedNotifications)
        [[self superview] viewFrameChanged:[[CPNotification alloc] initWithName:CPViewFrameDidChangeNotification object:self userInfo:nil]];

    if (!_inhibitUpdateTrackingAreas && !_inhibitFrameAndBoundsChangedNotifications)
        [self _updateTrackingAreasWithRecursion:!_autoresizesSubviews];

    if (!_isSettingFrameFromEngine && _viewIsConstraintBased)
        _FrameDidExplicitChangeInConstraintBasedLayout(self, _autoresizingConstraints, NO, YES);
}

/*!
    This method is used to set the width and height of the _DOMElement. It cares about the scale of the view.
    When scaling, for instance with a size (0.5, 0.5), the bounds of the view will be multiply by 2. It's why we multiply by the inverse of the scaling.
    The view will finally keep the same proportion for the user on the screen.
*/
- (void)_setDisplayServerSetStyleSize:(CGSize)aSize
{
#if PLATFORM(DOM)
    var scale = [self scaleSize];

    if (!_inhibitDOMUpdates)
        CPDOMDisplayServerSetStyleSize(_DOMElement, aSize.width * 1 / scale.width, aSize.height * 1 / scale.height);

    if (_DOMContentsElement)
    {
        CPDOMDisplayServerSetSize(_DOMContentsElement, aSize.width * _highDPIRatio * 1 / scale.width, aSize.height * _highDPIRatio * 1 / scale.height);
        CPDOMDisplayServerSetStyleSize(_DOMContentsElement, aSize.width * 1 / scale.width, aSize.height * 1 / scale.height);

        _needToSetTransformMatrix = YES;
    }
#endif
}

/*!
    Sets the receiver's bounds. The bounds define the size and location of the receiver inside it's frame. Posts a
    CPViewBoundsDidChangeNotification to the default notification center if the receiver is configured to do so.
    @param bounds the new bounds
*/
- (void)setBounds:(CGRect)bounds
{
    if (CGRectEqualToRect(_bounds, bounds))
        return;

    _inhibitFrameAndBoundsChangedNotifications = YES;

    [self setBoundsOrigin:bounds.origin];
    [self setBoundsSize:bounds.size];

    _inhibitFrameAndBoundsChangedNotifications = NO;

    if (_postsBoundsChangedNotifications)
        [CachedNotificationCenter postNotificationName:CPViewBoundsDidChangeNotification object:self];

    if (_isSuperviewAClipView)
        [[self superview] viewBoundsChanged:[[CPNotification alloc] initWithName:CPViewBoundsDidChangeNotification object:self userInfo:nil]];

    if (!_inhibitUpdateTrackingAreas)
        [self _updateTrackingAreasWithRecursion:YES];
}

/*!
    Returns the receiver's bounds. The bounds define the size
    and location of the receiver inside its frame.
*/
- (CGRect)bounds
{
    return CGRectMakeCopy(_bounds);
}

- (CGPoint)boundsOrigin
{
    return CGPointMakeCopy(_bounds.origin);
}

- (CGSize)boundsSize
{
    return CGSizeMakeCopy(_bounds.size);
}

/*!
    Sets the location of the receiver inside its frame. The method
    posts a CPViewBoundsDidChangeNotification to the
    default notification center if the receiver is configured to do so.
    @param aPoint the new location for the receiver
*/
- (void)setBoundsOrigin:(CGPoint)aPoint
{
    var origin = _bounds.origin;

    if (CGPointEqualToPoint(origin, aPoint))
        return;

    origin.x = aPoint.x;
    origin.y = aPoint.y;

    if (origin.x != 0 || origin.y != 0)
    {
        _boundsTransform = CGAffineTransformMakeTranslation(-origin.x, -origin.y);
        _inverseBoundsTransform = CGAffineTransformInvert(_boundsTransform);
    }
    else
    {
        _boundsTransform = nil;
        _inverseBoundsTransform = nil;
    }

#if PLATFORM(DOM)
    var index = _subviews.length;

    while (index--)
    {
        var view = _subviews[index],
            origin = view._frame.origin;

        CPDOMDisplayServerSetStyleLeftTop(view._DOMElement, _boundsTransform, origin.x, origin.y);
    }
#endif

    if (_postsBoundsChangedNotifications && !_inhibitFrameAndBoundsChangedNotifications)
        [CachedNotificationCenter postNotificationName:CPViewBoundsDidChangeNotification object:self];

    if (_isSuperviewAClipView && !_inhibitFrameAndBoundsChangedNotifications)
        [[self superview] viewBoundsChanged:[[CPNotification alloc] initWithName:CPViewBoundsDidChangeNotification object:self userInfo:nil]];

    if (!_inhibitUpdateTrackingAreas && !_inhibitFrameAndBoundsChangedNotifications)
        [self _updateTrackingAreasWithRecursion:YES];
}

/*!
    Sets the receiver's size inside its frame. The method posts a
    CPViewBoundsDidChangeNotification to the default
    notification center if the receiver is configured to do so.
    @param aSize the new size for the receiver
*/
- (void)setBoundsSize:(CGSize)aSize
{
    var size = _bounds.size;

    if (CGSizeEqualToSize(size, aSize))
        return;

    var frameSize = _frame.size;

    if (!CGSizeEqualToSize(size, frameSize))
    {
        var origin = _bounds.origin;

        origin.x /= size.width / frameSize.width;
        origin.y /= size.height / frameSize.height;
    }

    size.width = aSize.width;
    size.height = aSize.height;

    if (!CGSizeEqualToSize(size, frameSize))
    {
        var origin = _bounds.origin;

        origin.x *= size.width / frameSize.width;
        origin.y *= size.height / frameSize.height;
    }

    if (_postsBoundsChangedNotifications && !_inhibitFrameAndBoundsChangedNotifications)
        [CachedNotificationCenter postNotificationName:CPViewBoundsDidChangeNotification object:self];

    if (_isSuperviewAClipView && !_inhibitFrameAndBoundsChangedNotifications)
        [[self superview] viewBoundsChanged:[[CPNotification alloc] initWithName:CPViewBoundsDidChangeNotification object:self userInfo:nil]];

    if (!_inhibitUpdateTrackingAreas && !_inhibitFrameAndBoundsChangedNotifications)
        [self _updateTrackingAreasWithRecursion:YES];
}


/*!
    Notifies subviews that the superview changed size.
    @param aSize the size of the old superview
*/
- (void)resizeWithOldSuperviewSize:(CGSize)aSize
{
    var mask = [self autoresizingMask];

    if (mask === CPViewNotSizable)
        return;

    var frame = _superview._frame,
        newFrame = CGRectMakeCopy(_frame),
        dX = frame.size.width - aSize.width,
        dY = frame.size.height - aSize.height,
        evenFractionX = 1.0 / ((mask & CPViewMinXMargin ? 1 : 0) + (mask & CPViewWidthSizable ? 1 : 0) + (mask & CPViewMaxXMargin ? 1 : 0)),
        evenFractionY = 1.0 / ((mask & CPViewMinYMargin ? 1 : 0) + (mask & CPViewHeightSizable ? 1 : 0) + (mask & CPViewMaxYMargin ? 1 : 0)),
        baseX = (mask & CPViewMinXMargin    ? _frame.origin.x : 0) +
                (mask & CPViewWidthSizable  ? _frame.size.width : 0) +
                (mask & CPViewMaxXMargin    ? aSize.width - _frame.size.width - _frame.origin.x : 0),
        baseY = (mask & CPViewMinYMargin    ? _frame.origin.y : 0) +
                (mask & CPViewHeightSizable ? _frame.size.height : 0) +
                (mask & CPViewMaxYMargin    ? aSize.height - _frame.size.height - _frame.origin.y : 0);

    if (mask & CPViewMinXMargin)
        newFrame.origin.x += dX * (baseX > 0 ? _frame.origin.x / baseX : evenFractionX);

    if (mask & CPViewWidthSizable)
        newFrame.size.width += dX * (baseX > 0 ? _frame.size.width / baseX : evenFractionX);

    if (mask & CPViewMinYMargin)
        newFrame.origin.y += dY * (baseY > 0 ? _frame.origin.y / baseY : evenFractionY);

    if (mask & CPViewHeightSizable)
        newFrame.size.height += dY * (baseY > 0 ? _frame.size.height / baseY : evenFractionY);

    [self setFrame:newFrame];
}

/*!
    Initiates \c -superviewSizeChanged: messages to subviews.
    @param aSize the size for the subviews
*/
- (void)resizeSubviewsWithOldSize:(CGSize)aSize
{
    var count = _subviews.length;

    while (count--)
    {
        var subview = _subviews[count];
        if (![subview _needsConstraintBasedLayout])
            [subview resizeWithOldSuperviewSize:aSize];
}
}

/*!
    Specifies whether the receiver view should automatically resize its
    subviews when its \c -setFrameSize: method receives a change.
    @param aFlag If \c YES, then subviews will automatically be resized
    when this view is resized. \c NO means the views will not
    be resized automatically.
*/
- (void)setAutoresizesSubviews:(BOOL)aFlag
{
    _autoresizesSubviews = !!aFlag;
}

/*!
    Reports whether the receiver automatically resizes its subviews when its frame size changes.
    @return \c YES means it resizes its subviews on a frame size change.
*/
- (BOOL)autoresizesSubviews
{
    return _autoresizesSubviews;
}

/*!
    Determines automatic resizing behavior.
    @param aMask a bit mask with options
*/
- (void)setAutoresizingMask:(unsigned)aMask
{
    _autoresizingMask = aMask;
}

/*!
    Returns the bit mask options for resizing behavior
*/
- (unsigned)autoresizingMask
{
    return _autoresizingMask;
}

// Fullscreen Mode

/*!
    Puts the receiver into full screen mode.
*/
- (BOOL)enterFullScreenMode
{
    return [self enterFullScreenMode:nil withOptions:nil];
}

/*!
    Puts the receiver into full screen mode.
    @param aScreen the that should be used
    @param options configuration options
*/
- (BOOL)enterFullScreenMode:(CPScreen)aScreen withOptions:(CPDictionary)options
{
    _fullScreenModeState = _CPViewFullScreenModeStateMake(self);

    var fullScreenWindow = [[CPWindow alloc] initWithContentRect:[[CPPlatformWindow primaryPlatformWindow] contentBounds] styleMask:CPBorderlessWindowMask];

    [fullScreenWindow setLevel:CPScreenSaverWindowLevel];
    [fullScreenWindow setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

    var contentView = [fullScreenWindow contentView];

    [contentView setBackgroundColor:[CPColor blackColor]];
    [contentView addSubview:self];

    [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [self setFrame:CGRectMakeCopy([contentView bounds])];

    [fullScreenWindow makeKeyAndOrderFront:self];

    [fullScreenWindow makeFirstResponder:self];

    _isInFullScreenMode = YES;

    return YES;
}

/*!
    The receiver should exit full screen mode.
*/
- (void)exitFullScreenMode
{
    [self exitFullScreenModeWithOptions:nil];
}

/*!
    The receiver should exit full screen mode.
    @param options configurations options
*/
- (void)exitFullScreenModeWithOptions:(CPDictionary)options
{
    if (!_isInFullScreenMode)
        return;

    _isInFullScreenMode = NO;

    [self setFrame:_fullScreenModeState.frame];
    [self setAutoresizingMask:_fullScreenModeState.autoresizingMask];
    [_fullScreenModeState.superview _insertSubview:self atIndex:_fullScreenModeState.index];

    [[self window] orderOut:self];
}

/*!
    Returns \c YES if the receiver is currently in full screen mode.
*/
- (BOOL)isInFullScreenMode
{
    return _isInFullScreenMode;
}

/*!
    Sets whether the receiver should be hidden.
    @param aFlag \c YES makes the receiver hidden.
*/
- (void)setHidden:(BOOL)aFlag
{
    aFlag = !!aFlag;

    if (_isHidden === aFlag)
        return;

//  FIXME: Should we return to visibility?  This breaks in FireFox, Opera, and IE.
//    _DOMElement.style.visibility = (_isHidden = aFlag) ? "hidden" : "visible";
#if PLATFORM(DOM)
    _DOMElement.style.display = aFlag ? "none" : "block";
#endif

    if (aFlag)
    {
        var view = [_window firstResponder];

        if ([view isKindOfClass:[CPView class]])
        {
            do
            {
               if (self === view)
               {
                  [_window makeFirstResponder:[self nextValidKeyView]];
                  break;
               }
            }
            while (view = [view superview]);
        }

        [self _postViewWillDisappearNotification];
        [self _recursiveGainedHiddenAncestor];
    }
    else
    {
        [self setNeedsDisplay:YES];

        [self _postViewWillAppearNotification];
        [self _recursiveLostHiddenAncestor];
    }

    _isHidden = aFlag;
}

- (void)_postViewWillAppearNotification
{
    [[CPNotificationCenter defaultCenter] postNotificationName:_CPViewWillAppearNotification object:self userInfo:nil];
}

- (void)_postViewDidAppearNotification
{
    [[CPNotificationCenter defaultCenter] postNotificationName:_CPViewDidAppearNotification object:self userInfo:nil];
}

- (void)_postViewWillDisappearNotification
{
    [[CPNotificationCenter defaultCenter] postNotificationName:_CPViewWillDisappearNotification object:self userInfo:nil];
}

- (void)_postViewDidDisappearNotification
{
    [[CPNotificationCenter defaultCenter] postNotificationName:_CPViewDidDisappearNotification object:self userInfo:nil];
}

- (void)_setSuperview:(CPView)aSuperview
{
    var hasOldSuperview = (_superview !== nil),
        hasNewSuperview = (aSuperview !== nil),
        oldSuperviewIsHidden = hasOldSuperview && [_superview isHiddenOrHasHiddenAncestor],
        newSuperviewIsHidden = hasNewSuperview && [aSuperview isHiddenOrHasHiddenAncestor];

    if (!newSuperviewIsHidden && oldSuperviewIsHidden)
        [self _recursiveLostHiddenAncestor];

    if (newSuperviewIsHidden && !oldSuperviewIsHidden)
        [self _recursiveGainedHiddenAncestor];

    _superview = aSuperview;

    if (hasOldSuperview)
        [self _postViewDidDisappearNotification];

    if (hasNewSuperview)
        [self _postViewDidAppearNotification];
}

- (void)_recursiveLostHiddenAncestor
{
    if (_isHiddenOrHasHiddenAncestor)
    {
        _isHiddenOrHasHiddenAncestor = NO;
        [self viewDidUnhide];
    }

    [_subviews enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        [view _recursiveLostHiddenAncestor];
    }];
}

- (void)_recursiveGainedHiddenAncestor
{
    if (!_isHidden)
    {
        [self viewDidHide];
    }

    _isHiddenOrHasHiddenAncestor = YES;

    [_subviews enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        [view _recursiveGainedHiddenAncestor];
    }];
}

/*!
    Returns \c YES if the receiver is hidden.
*/
- (BOOL)isHidden
{
    return _isHidden;
}

- (void)setClipsToBounds:(BOOL)shouldClip
{
    if (_clipsToBounds === shouldClip)
        return;

    _clipsToBounds = shouldClip;

#if PLATFORM(DOM)
    _DOMElement.style.overflow = _clipsToBounds ? "hidden" :  "visible";
#endif
}

- (BOOL)clipsToBounds
{
    return _clipsToBounds;
}

/*!
    Sets the opacity of the receiver. The value must be in the range of 0.0 to 1.0, where 0.0 is
    completely transparent and 1.0 is completely opaque.
    @param anAlphaValue an alpha value ranging from 0.0 to 1.0.
*/
- (void)setAlphaValue:(float)anAlphaValue
{
    if (_opacity === anAlphaValue)
        return;

    _opacity = anAlphaValue;

#if PLATFORM(DOM)

    if (CPFeatureIsCompatible(CPOpacityRequiresFilterFeature))
    {
        if (anAlphaValue === 1.0)
            try { _DOMElement.style.removeAttribute("filter") } catch (anException) { }
        else
            _DOMElement.style.filter = "alpha(opacity=" + anAlphaValue * 100 + ")";
    }
    else
        _DOMElement.style.opacity = anAlphaValue;

#endif
}

/*!
    Returns the alpha value of the receiver. Ranges from 0.0 to
    1.0, where 0.0 is completely transparent and 1.0 is completely opaque.
*/
- (float)alphaValue
{
    return _opacity;
}

/*!
    Returns \c YES if the receiver is hidden, or one
    of it's ancestor views is hidden. \c NO, otherwise.
*/
- (BOOL)isHiddenOrHasHiddenAncestor
{
    return _isHiddenOrHasHiddenAncestor;
}

/*!
    Returns the closest ancestor shared by the receiver and a given view.
    @param aView The view to test (along with the receiver) for closest shared ancestor.
    @returns The closest ancestor or nil if there’s no such object. Returns self if aView is identical to the receiver.
*/
- (CPView)ancestorSharedWithView:(CPView)aView
{
    if (self == aView)                  // Are they the same view?
      return self;

    if ([self isDescendantOf:aView])    // Is self a descendant of view?
      return aView;

    if ([aView isDescendantOf:self])    // Is view a descendant of self?
      return self;

    // If neither are descendants of each other and either does not have a
    // superview then they cannot have a common ancestor

    if (![self superview] || ![aView superview])
      return nil;

    // Find the common ancestor of superviews
    return [[self superview] ancestorSharedWithView:[aView superview]];
}

/*!
    Returns YES if the view is not hidden, has no hidden ancestor and doesn't belong to a hidden window.
*/
- (BOOL)_isVisible
{
    return ![self isHiddenOrHasHiddenAncestor] && [[self window] isVisible];
}

/*!
    Called when the return value of isHiddenOrHasHiddenAncestor becomes YES,
    e.g. when this view becomes hidden due to a setHidden:YES message to
    itself or to one of its superviews.

    Note: in the current implementation, viewDidHide may be called multiple
    times if additional superviews are hidden, even if
    isHiddenOrHasHiddenAncestor was already YES.
*/
- (void)viewDidHide
{

}

/*!
    Called when the return value of isHiddenOrHasHiddenAncestor becomes NO,
    e.g. when this view stops being hidden due to a setHidden:NO message to
    itself or to one of its superviews.

    Note: in the current implementation, viewDidUnhide may be called multiple
    times if additional superviews are unhidden, even if
    isHiddenOrHasHiddenAncestor was already NO.
*/
- (void)viewDidUnhide
{

}

/*!
    Returns whether the receiver should be sent a \c -mouseDown: message for \c anEvent.<br/>
    Returns \c NO by default.
    @return \c YES, if the view object accepts first mouse-down event. \c NO, otherwise.
*/
- (BOOL)acceptsFirstMouse:(CPEvent)anEvent
{
    return NO;
}

/*!
    Returns whether or not the view responds to hit tests.
    @return \c YES if this view listens to \c -hitTest messages, \c NO otherwise.
*/
- (BOOL)hitTests
{
    return _hitTests;
}

/*!
    Set whether or not the view should respond to hit tests.
    @param shouldHitTest should be \c YES if this view should respond to hit tests, \c NO otherwise.
*/
- (void)setHitTests:(BOOL)shouldHitTest
{
    _hitTests = !!shouldHitTest;
}

/*!
    Tests whether a point is contained within this view, or one of its subviews.
    @param aPoint the point to test
    @return returns the containing view, or nil if the point is not contained
*/
- (CPView)hitTest:(CGPoint)aPoint
{
    if (_isHidden || !_hitTests)
        return nil;

    var frame = _frame,
        sizeScale = [self _hierarchyScaleSize];

    if (_isScaled)
        frame = CGRectApplyAffineTransform(_frame, CGAffineTransformMakeScale([_superview _hierarchyScaleSize].width, [_superview _hierarchyScaleSize].height));
    else
        frame = CGRectApplyAffineTransform(_frame, CGAffineTransformMakeScale(sizeScale.width, sizeScale.height));

    if (!CGRectContainsPoint(frame, aPoint))
        return nil;

    var view = nil,
        i = _subviews.length,
        adjustedPoint = CGPointMake(aPoint.x - CGRectGetMinX(frame), aPoint.y - CGRectGetMinY(frame));

    if (_inverseBoundsTransform)
    {
        var affineTransform = CGAffineTransformMakeCopy(_inverseBoundsTransform);

        if (_isScaled)
        {
            affineTransform.tx *= [_superview _hierarchyScaleSize].width;
            affineTransform.ty *= [_superview _hierarchyScaleSize].height;
        }
        else
        {
            affineTransform.tx *= sizeScale.width;
            affineTransform.ty *= sizeScale.height;
        }

        adjustedPoint = CGPointApplyAffineTransform(adjustedPoint, affineTransform);
    }


    while (i--)
        if (view = [_subviews[i] hitTest:adjustedPoint])
            return view;

    return self;
}

/*!
    Returns \c YES if this view requires a panel to become key. Normally only text fields, so this returns \c NO.
*/
- (BOOL)needsPanelToBecomeKey
{
    return NO;
}

/*!
    Returns \c YES if mouse events aren't needed by the receiver and can be sent to the superview. The
    default implementation returns \c NO if the view is opaque.
*/
- (BOOL)mouseDownCanMoveWindow
{
    return ![self isOpaque];
}

- (void)mouseDown:(CPEvent)anEvent
{
    if ([self mouseDownCanMoveWindow])
        [super mouseDown:anEvent];
}

- (void)rightMouseDown:(CPEvent)anEvent
{
    var menu = [self menuForEvent:anEvent];

    if (menu)
        [CPMenu popUpContextMenu:menu withEvent:anEvent forView:self];
    else if ([[self nextResponder] isKindOfClass:CPView])
        [super rightMouseDown:anEvent];
    else
        [[[anEvent window] platformWindow] _propagateContextMenuDOMEvent:NO];
}

- (CPMenu)menuForEvent:(CPEvent)anEvent
{
    return [self menu] || [[self class] defaultMenu];
}

/*!
    Sets the background color of the receiver.
    @param aColor the new color for the receiver's background
*/
- (void)setBackgroundColor:(CPColor)aColor
{
    if (_backgroundColor === aColor)
        return;

    if (aColor === [CPNull null])
        aColor = nil;

    _backgroundColor = aColor;

#if PLATFORM(DOM)
    var patternImage = [_backgroundColor patternImage],
        colorExists = _backgroundColor && ([_backgroundColor patternImage] || [_backgroundColor alphaComponent] > 0.0),
        colorHasAlpha = colorExists && [_backgroundColor alphaComponent] < 1.0,
        supportsRGBA = CPFeatureIsCompatible(CPCSSRGBAFeature),
        colorNeedsDOMElement = colorHasAlpha && !supportsRGBA,
        amount = 0,
        slices;

    if ([patternImage isThreePartImage])
    {
        _backgroundType = [patternImage isVertical] ? BackgroundVerticalThreePartImage : BackgroundHorizontalThreePartImage;
        amount = 3;
    }
    else if ([patternImage isNinePartImage])
    {
        _backgroundType = BackgroundNinePartImage;
        amount = 9;
    }
    else
    {
        _backgroundType = colorNeedsDOMElement ? BackgroundTransparentColor : BackgroundTrivialColor;
        amount = (colorNeedsDOMElement ? 1 : 0) - _DOMImageParts.length;
    }

    // Prepare multipart image data and reduce number of required DOM parts by number of empty slices in the multipart image to save needless DOM elements.
    if (_backgroundType === BackgroundVerticalThreePartImage || _backgroundType === BackgroundHorizontalThreePartImage || _backgroundType === BackgroundNinePartImage)
    {
        slices = [patternImage imageSlices];

        // We won't need more divs than there are slices.
        amount = MIN(amount, slices.length);

        for (var i = 0, count = slices.length; i < count; i++)
        {
            var image = slices[i],
                size = [image size];

            if (!size || (size.width === 0 && size.height === 0))
                size = nil;

            _DOMImageSizes[i] = size;

            // If there's a nil slice or a slice with no size, it won't need a div.
            if (!size)
                amount--;
        }

        // Now that we know how many divs we really need, compare that to number we actually have.
        amount -= _DOMImageParts.length;
    }

    // Make sure the number of divs we have match our needs.
    if (amount > 0)
    {
        while (amount--)
        {
            var DOMElement = DOMElementPrototype.cloneNode(false);

            DOMElement.style.zIndex = -1000;

            _DOMImageParts.push(DOMElement);
            _DOMElement.appendChild(DOMElement);
        }
    }
    else
    {
        amount = -amount;
        while (amount--)
            _DOMElement.removeChild(_DOMImageParts.pop());
    }

    if (_backgroundType === BackgroundTrivialColor || _backgroundType === BackgroundTransparentColor)
    {
        var colorCSS = colorExists ? [_backgroundColor cssString] : "";

        if (colorNeedsDOMElement)
        {
            _DOMElement.style.background = "";
            _DOMImageParts[0].style.background = [_backgroundColor cssString];

            if (patternImage)
                CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[0], [patternImage size].width + "px", [patternImage size].height + "px");

            if (CPFeatureIsCompatible(CPOpacityRequiresFilterFeature))
                _DOMImageParts[0].style.filter = "alpha(opacity=" + [_backgroundColor alphaComponent] * 100 + ")";
            else
                _DOMImageParts[0].style.opacity = [_backgroundColor alphaComponent];

            var size = [self bounds].size;
            CPDOMDisplayServerSetStyleSize(_DOMImageParts[0], size.width, size.height);
        }
        else
        {
            _DOMElement.style.background = colorCSS;

            if (patternImage)
                CPDOMDisplayServerSetStyleBackgroundSize(_DOMElement, [patternImage size].width + "px", [patternImage size].height + "px");
    }
    }
    else
    {
        var frameSize = _frame.size,
            partIndex = 0;

        for (var i = 0; i < slices.length; i++)
        {
            var size = _DOMImageSizes[i];

            if (!size)
                continue;

            var image = slices[i];

            // // If image was nil, size should have been nil too.
            // assert(image != nil);

            CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], size.width, size.height);

            _DOMImageParts[partIndex].style.background = "url(\"" + [image filename] + "\")";

            if (!supportsRGBA)
            {
                if (CPFeatureIsCompatible(CPOpacityRequiresFilterFeature))
                    try { _DOMImageParts[partIndex].style.removeAttribute("filter") } catch (anException) { }
                else
                    _DOMImageParts[partIndex].style.opacity = 1.0;
            }

            partIndex++;
        }

        if (_backgroundType === BackgroundNinePartImage)
        {
            var left = _DOMImageSizes[0] ? _DOMImageSizes[0].width : 0,
                right = _DOMImageSizes[2] ? _DOMImageSizes[2].width : 0,
                top = _DOMImageSizes[0] ? _DOMImageSizes[0].height : 0,
                bottom = _DOMImageSizes[6] ? _DOMImageSizes[6].height : 0,
                width = frameSize.width - left - right,
                height = frameSize.height - top - bottom;

            partIndex = 0;

            if (_DOMImageSizes[0])
            {
                CPDOMDisplayServerSetStyleLeftTop(_DOMImageParts[partIndex], NULL, 0.0, 0.0);
                partIndex++;
            }
            if (_DOMImageSizes[1])
            {
                CPDOMDisplayServerSetStyleLeftTop(_DOMImageParts[partIndex], NULL, left, 0.0);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], width, _DOMImageSizes[1].height);
                partIndex++;
            }
            if (_DOMImageSizes[2])
            {
                CPDOMDisplayServerSetStyleRightTop(_DOMImageParts[partIndex], NULL, 0.0, 0.0);
                partIndex++;
            }
            if (_DOMImageSizes[3])
            {
                CPDOMDisplayServerSetStyleLeftTop(_DOMImageParts[partIndex], NULL, 0.0, top);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], _DOMImageSizes[3].width, height);
                partIndex++;
            }
            if (_DOMImageSizes[4])
            {
                CPDOMDisplayServerSetStyleLeftTop(_DOMImageParts[partIndex], NULL, left, top);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], width, height);
                partIndex++;
            }
            if (_DOMImageSizes[5])
            {
                CPDOMDisplayServerSetStyleRightTop(_DOMImageParts[partIndex], NULL, 0.0, top);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], _DOMImageSizes[5].width, height);
                partIndex++;
            }
            if (_DOMImageSizes[6])
            {
                CPDOMDisplayServerSetStyleLeftBottom(_DOMImageParts[partIndex], NULL, 0.0, 0.0);
                partIndex++;
            }
            if (_DOMImageSizes[7])
            {
                CPDOMDisplayServerSetStyleLeftBottom(_DOMImageParts[partIndex], NULL, left, 0.0);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], width, _DOMImageSizes[7].height);
                partIndex++;
            }
            if (_DOMImageSizes[8])
            {
                CPDOMDisplayServerSetStyleRightBottom(_DOMImageParts[partIndex], NULL, 0.0, 0.0);
            }
        }
        else if (_backgroundType === BackgroundVerticalThreePartImage)
        {
            var top = _DOMImageSizes[0] ? _DOMImageSizes[0].height : 0,
                bottom = _DOMImageSizes[2] ? _DOMImageSizes[2].height : 0;

            partIndex = 0;

            // Make sure to repeat the top and bottom pieces horizontally if they're not the exact width needed.
            if (top)
            {
                CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], frameSize.width + "px", top + "px");
                CPDOMDisplayServerSetStyleLeftTop(_DOMImageParts[partIndex], NULL, 0.0, 0.0);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], frameSize.width, top);
                partIndex++;
            }
            if (_DOMImageSizes[1])
            {
                var height = frameSize.height - top - bottom;

                //_DOMImageParts[partIndex].style.backgroundSize =  frameSize.width + "px " + height + "px";
                CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], frameSize.width + "px", height + "px");
                CPDOMDisplayServerSetStyleLeftTop(_DOMImageParts[partIndex], NULL, 0.0, top);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], frameSize.width, height);
                partIndex++;
            }
            if (bottom)
            {
                CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], frameSize.width + "px", bottom + "px");
                CPDOMDisplayServerSetStyleLeftBottom(_DOMImageParts[partIndex], NULL, 0.0, 0.0);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], frameSize.width, bottom);
            }
        }
        else if (_backgroundType === BackgroundHorizontalThreePartImage)
        {
            var left = _DOMImageSizes[0] ? _DOMImageSizes[0].width : 0,
                right = _DOMImageSizes[2] ? _DOMImageSizes[2].width : 0;

            partIndex = 0;

            // Make sure to repeat the left and right pieces vertically if they're not the exact height needed.
            if (left)
            {
                CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], left + "px", frameSize.height + "px");
                CPDOMDisplayServerSetStyleLeftTop(_DOMImageParts[partIndex], NULL, 0.0, 0.0);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], left, frameSize.height);
                partIndex++;
            }
            if (_DOMImageSizes[1])
            {
                var width = (frameSize.width - left - right);

                CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], width + "px", frameSize.height + "px");
                CPDOMDisplayServerSetStyleLeftTop(_DOMImageParts[partIndex], NULL, left, 0.0);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], width, frameSize.height);
                partIndex++;
            }
            if (right)
            {
                CPDOMDisplayServerSetStyleBackgroundSize(_DOMImageParts[partIndex], right + "px", frameSize.height + "px");
                CPDOMDisplayServerSetStyleRightTop(_DOMImageParts[partIndex], NULL, 0.0, 0.0);
                CPDOMDisplayServerSetStyleSize(_DOMImageParts[partIndex], right, frameSize.height);
            }
        }
    }
#endif
}

/*!
    Returns the background color of the receiver
*/
- (CPColor)backgroundColor
{
    return _backgroundColor;
}

// Converting Coordinates
/*!
    Converts \c aPoint from the coordinate space of \c aView to the coordinate space of the receiver.
    @param aPoint the point to convert
    @param aView the view space to convert from
    @return the converted point
*/
- (CGPoint)convertPoint:(CGPoint)aPoint fromView:(CPView)aView
{
    if (aView === self)
        return aPoint;

    return CGPointApplyAffineTransform(aPoint, _CPViewGetTransform(aView, self));
}

/*!
    Converts the point from the base coordinate system to the receiver’s coordinate system.
    @param aPoint A point specifying a location in the base coordinate system
    @return The point converted to the receiver’s base coordinate system
*/
- (CGPoint)convertPointFromBase:(CGPoint)aPoint
{
    return [self convertPoint:aPoint fromView:nil];
}

/*!
    Converts \c aPoint from the receiver's coordinate space to the coordinate space of \c aView.
    @param aPoint the point to convert
    @param aView the coordinate space to which the point will be converted
    @return the converted point
*/
- (CGPoint)convertPoint:(CGPoint)aPoint toView:(CPView)aView
{
    if (aView === self)
        return aPoint;

    return CGPointApplyAffineTransform(aPoint, _CPViewGetTransform(self, aView));
}


/*!
    Converts the point from the receiver’s coordinate system to the base coordinate system.
    @param aPoint A point specifying a location in the coordinate system of the receiver
    @return The point converted to the base coordinate system
*/
- (CGPoint)convertPointToBase:(CGPoint)aPoint
{
    return [self convertPoint:aPoint toView:nil];
}

/*!
    Convert's \c aSize from \c aView's coordinate space to the receiver's coordinate space.
    @param aSize the size to convert
    @param aView the coordinate space to convert from
    @return the converted size
*/
- (CGSize)convertSize:(CGSize)aSize fromView:(CPView)aView
{
    if (aView === self)
        return aSize;

    return CGSizeApplyAffineTransform(aSize, _CPViewGetTransform(aView, self));
}

/*!
    Convert's \c aSize from the receiver's coordinate space to \c aView's coordinate space.
    @param aSize the size to convert
    @param the coordinate space to which the size will be converted
    @return the converted size
*/
- (CGSize)convertSize:(CGSize)aSize toView:(CPView)aView
{
    if (aView === self)
        return aSize;

    return CGSizeApplyAffineTransform(aSize, _CPViewGetTransform(self, aView));
}

/*!
    Converts \c aRect from \c aView's coordinate space to the receiver's space.
    @param aRect the rectangle to convert
    @param aView the coordinate space from which to convert
    @return the converted rectangle
*/
- (CGRect)convertRect:(CGRect)aRect fromView:(CPView)aView
{
    if (self === aView)
        return aRect;

    return CGRectApplyAffineTransform(aRect, _CPViewGetTransform(aView, self));
}

/*!
    Converts the rectangle from the base coordinate system to the receiver’s coordinate system.
    @param aRect A rectangle specifying a location in the base coordinate system
    @return The rectangle converted to the receiver’s base coordinate system
*/
- (CGRect)convertRectFromBase:(CGRect)aRect
{
    return [self convertRect:aRect fromView:nil];
}

/*!
    Converts \c aRect from the receiver's coordinate space to \c aView's coordinate space.
    @param aRect the rectangle to convert
    @param aView the coordinate space to which the rectangle will be converted
    @return the converted rectangle
*/
- (CGRect)convertRect:(CGRect)aRect toView:(CPView)aView
{
    if (self === aView)
        return aRect;

    return CGRectApplyAffineTransform(aRect, _CPViewGetTransform(self, aView));
}

/*!
    Converts the rectangle from the receiver’s coordinate system to the base coordinate system.
    @param aRect  A rectangle specifying a location in the coordinate system of the receiver
    @return The rectangle converted to the base coordinate system
*/
- (CGRect)convertRectToBase:(CGRect)aRect
{
    return [self convertRect:aRect toView:nil];
}

/*!
    Sets whether the receiver posts a CPViewFrameDidChangeNotification notification
    to the default notification center when its frame is changed. The default is \c NO.
    Methods that could cause a frame change notification are:
<pre>
setFrame:
setFrameSize:
setFrameOrigin:
</pre>
    @param shouldPostFrameChangedNotifications \c YES makes the receiver post
    notifications on frame changes (size or origin)
*/
- (void)setPostsFrameChangedNotifications:(BOOL)shouldPostFrameChangedNotifications
{
    shouldPostFrameChangedNotifications = !!shouldPostFrameChangedNotifications;

    if (_postsFrameChangedNotifications === shouldPostFrameChangedNotifications)
        return;

    _postsFrameChangedNotifications = shouldPostFrameChangedNotifications;
}

/*!
    Returns \c YES if the receiver posts a CPViewFrameDidChangeNotification if its frame is changed.
*/
- (BOOL)postsFrameChangedNotifications
{
    return _postsFrameChangedNotifications;
}

/*!
    Sets whether the receiver posts a CPViewBoundsDidChangeNotification notification
    to the default notification center when its bounds is changed. The default is \c NO.
    Methods that could cause a bounds change notification are:
<pre>
setBounds:
setBoundsSize:
setBoundsOrigin:
</pre>
    @param shouldPostBoundsChangedNotifications \c YES makes the receiver post
    notifications on bounds changes
*/
- (void)setPostsBoundsChangedNotifications:(BOOL)shouldPostBoundsChangedNotifications
{
    shouldPostBoundsChangedNotifications = !!shouldPostBoundsChangedNotifications;

    if (_postsBoundsChangedNotifications === shouldPostBoundsChangedNotifications)
        return;

    _postsBoundsChangedNotifications = shouldPostBoundsChangedNotifications;
}

/*!
    Returns \c YES if the receiver posts a
    CPViewBoundsDidChangeNotification when its
    bounds is changed.
*/
- (BOOL)postsBoundsChangedNotifications
{
    return _postsBoundsChangedNotifications;
}

/*!
    Initiates a drag operation from the receiver to another view that accepts dragged data.
    @param anImage the image to be dragged
    @param aLocation the lower-left corner coordinate of \c anImage
    @param mouseOffset the distance from the \c -mouseDown: location and the current location
    @param anEvent the \c -mouseDown: that triggered the drag
    @param aPasteboard the pasteboard that holds the drag data
    @param aSourceObject the drag operation controller
    @param slideBack Whether the image should 'slide back' if the drag is rejected
*/
- (void)dragImage:(CPImage)anImage at:(CGPoint)aLocation offset:(CGSize)mouseOffset event:(CPEvent)anEvent pasteboard:(CPPasteboard)aPasteboard source:(id)aSourceObject slideBack:(BOOL)slideBack
{
    [_window dragImage:anImage at:[self convertPoint:aLocation toView:nil] offset:mouseOffset event:anEvent pasteboard:aPasteboard source:aSourceObject slideBack:slideBack];
}

/*!
    Initiates a drag operation from the receiver to another view that accepts dragged data.
    @param aView the view to be dragged
    @param aLocation the top-left corner coordinate of \c aView
    @param mouseOffset the distance from the \c -mouseDown: location and the current location
    @param anEvent the \c -mouseDown: that triggered the drag
    @param aPasteboard the pasteboard that holds the drag data
    @param aSourceObject the drag operation controller
    @param slideBack Whether the view should 'slide back' if the drag is rejected
*/
- (void)dragView:(CPView)aView at:(CGPoint)aLocation offset:(CGSize)mouseOffset event:(CPEvent)anEvent pasteboard:(CPPasteboard)aPasteboard source:(id)aSourceObject slideBack:(BOOL)slideBack
{
    [_window dragView:aView at:[self convertPoint:aLocation toView:nil] offset:mouseOffset event:anEvent pasteboard:aPasteboard source:aSourceObject slideBack:slideBack];
}

/*!
    Sets the receiver's list of acceptable data types for a dragging operation.
    @param pasteboardTypes an array of CPPasteboards
*/
- (void)registerForDraggedTypes:(CPArray)pasteboardTypes
{
    if (!pasteboardTypes || ![pasteboardTypes count])
        return;

    var theWindow = [self window];

    [theWindow _noteUnregisteredDraggedTypes:_registeredDraggedTypes];
    [_registeredDraggedTypes addObjectsFromArray:pasteboardTypes];
    [theWindow _noteRegisteredDraggedTypes:_registeredDraggedTypes];

    _registeredDraggedTypesArray = nil;
}

/*!
    Returns an array of all types the receiver accepts for dragging operations.
    @return an array of CPPasteBoards
*/
- (CPArray)registeredDraggedTypes
{
    if (!_registeredDraggedTypesArray)
        _registeredDraggedTypesArray = [_registeredDraggedTypes allObjects];

    return _registeredDraggedTypesArray;
}

/*!
    Resets the array of acceptable data types for a dragging operation.
*/
- (void)unregisterDraggedTypes
{
    [[self window] _noteUnregisteredDraggedTypes:_registeredDraggedTypes];

    _registeredDraggedTypes = [CPSet set];
    _registeredDraggedTypesArray = [];
}

/*!
    Draws the receiver into \c aRect. This method should be overridden by subclasses.
    @param aRect the area that should be drawn into
*/
- (void)drawRect:(CGRect)aRect
{

}

// Scaling

/*!
    Scales the receiver’s coordinate system so that the unit square scales to the specified dimensions.
    The bounds of the receiver will change, for instance if the given size is (0.5, 0.5) the width and height of the bounds will be multiply by 2.
    You must call setNeedsDisplay: to redraw the view.
    @param aSize, the size corresponding the new unit scales
*/
- (void)scaleUnitSquareToSize:(CGSize)aSize
{
    if (!aSize)
        return;

    // Reset the bounds
    var bounds = CGRectMakeCopy([self bounds]);
    bounds.size.width *= _scaleSize.width;
    bounds.size.height *= _scaleSize.height;

    [self willChangeValueForKey:@"scaleSize"];
    _scaleSize = CGSizeMakeCopy([self scaleSize]);
    _scaleSize.height *= aSize.height;
    _scaleSize.width *= aSize.width;
    [self didChangeValueForKey:@"scaleSize"];
    _isScaled = YES;

    _hierarchyScaleSize = CGSizeMakeCopy([self _hierarchyScaleSize]);
    _hierarchyScaleSize.height *= aSize.height;
    _hierarchyScaleSize.width *= aSize.width;

    var scaleAffine = CGAffineTransformMakeScale(1.0 / _scaleSize.width, 1.0 / _scaleSize.height),
        newBounds = CGRectApplyAffineTransform(CGRectMakeCopy(bounds), scaleAffine);

    [self setBounds:newBounds];

    [_subviews makeObjectsPerformSelector:@selector(_scaleSizeUnitSquareToSize:) withObject:aSize];
}

/*!
    @ignore
    Set the _hierarchyScaleSize and call all of the subviews to set their _hierarchyScaleSize
*/
- (void)_scaleSizeUnitSquareToSize:(CGSize)aSize
{
    _hierarchyScaleSize = CGSizeMakeCopy([_superview _hierarchyScaleSize]);

    if (_isScaled)
    {
         _hierarchyScaleSize.width *= _scaleSize.width;
         _hierarchyScaleSize.height *= _scaleSize.height;
    }

    [_subviews makeObjectsPerformSelector:@selector(_scaleSizeUnitSquareToSize:) withObject:aSize];
}

/*!
    Return the _hierarchyScaleSize, this is a CGSize with the real zoom of the view (depending with his parents)
*/
- (CGSize)_hierarchyScaleSize
{
    return _hierarchyScaleSize || CGSizeMake(1.0, 1.0);
}

/*!
    Make a zoom in css
*/
- (void)_applyCSSScalingTranformations
{
#if PLATFORM(DOM)
    if (_isScaled)
    {
        var scale = [self scaleSize],
            browserPropertyTransform = CPBrowserStyleProperty(@"transform"),
            browserPropertyTransformOrigin = CPBrowserStyleProperty(@"transformOrigin");

        self._DOMElement.style[browserPropertyTransform] = 'scale(' + scale.width + ', ' + scale.height + ')';
        self._DOMElement.style[browserPropertyTransformOrigin] = '0 0';

        [self _setDisplayServerSetStyleSize:[self frameSize]];
    }
#endif
}

// Displaying

/*!
    Marks the entire view as dirty, and needing a redraw.
*/
- (void)setNeedsDisplay:(BOOL)aFlag
{
    if (aFlag)
    {
        [self _applyCSSScalingTranformations];
        [self setNeedsDisplayInRect:[self bounds]];
    }
}

/*!
    Marks the area denoted by \c aRect as dirty, and initiates a redraw on it.
    @param aRect the area that needs to be redrawn
*/
- (void)setNeedsDisplayInRect:(CGRect)aRect
{
    if (!(_viewClassFlags & CPViewHasCustomDrawRect))
        return;

    if (CGRectIsEmpty(aRect))
        return;

    if (_dirtyRect && !CGRectIsEmpty(_dirtyRect))
        _dirtyRect = CGRectUnion(aRect, _dirtyRect);
    else
        _dirtyRect = CGRectMakeCopy(aRect);

    _CPDisplayServerAddDisplayObject(self);
}

- (BOOL)needsDisplay
{
    return _dirtyRect && !CGRectIsEmpty(_dirtyRect);
}

/*!
    Displays the receiver and any of its subviews that need to be displayed.
*/
- (void)displayIfNeeded
{
    if ([self needsDisplay])
        [self displayRect:_dirtyRect];
}

/*!
    Draws the entire area of the receiver as defined by its \c -bounds.
*/
- (void)display
{
    [self displayRect:[self visibleRect]];
}

- (void)displayIfNeededInRect:(CGRect)aRect
{
    if ([self needsDisplay])
        [self displayRect:aRect];
}

/*!
    Draws the receiver into the area defined by \c aRect.
    @param aRect the area to be drawn
*/
- (void)displayRect:(CGRect)aRect
{
    [self viewWillDraw];

    [self displayRectIgnoringOpacity:aRect inContext:nil];

    _dirtyRect = NULL;
}

- (void)displayRectIgnoringOpacity:(CGRect)aRect inContext:(CPGraphicsContext)aGraphicsContext
{
    if ([self isHidden])
        return;

#if PLATFORM(DOM)
    [self lockFocus];

    CGContextClearRect([[CPGraphicsContext currentContext] graphicsPort], aRect);

    [self drawRect:aRect];
    [self unlockFocus];
#endif
}

- (void)viewWillDraw
{
}

/*!
    Locks focus on the receiver, so drawing commands apply to it.
*/
- (void)lockFocus
{
    if (!_graphicsContext)
    {
        var graphicsPort = CGBitmapGraphicsContextCreate();

#if PLATFORM(DOM)
        var width = CGRectGetWidth(_frame),
            height = CGRectGetHeight(_frame),
            devicePixelRatio = window.devicePixelRatio || 1,
            backingStoreRatio = CPBrowserBackingStorePixelRatio(graphicsPort);

        _highDPIRatio = CPViewHighDPIDrawingEnabled ? (devicePixelRatio / backingStoreRatio) : 1;

        _DOMContentsElement = graphicsPort.DOMElement;

        _DOMContentsElement.style.zIndex = -100;

        _DOMContentsElement.style.overflow = "hidden";
        _DOMContentsElement.style.position = "absolute";
        _DOMContentsElement.style.visibility = "visible";

        CPDOMDisplayServerSetSize(_DOMContentsElement, width * _highDPIRatio, height * _highDPIRatio);

        CPDOMDisplayServerSetStyleLeftTop(_DOMContentsElement, NULL, 0.0, 0.0);
        CPDOMDisplayServerSetStyleSize(_DOMContentsElement, width, height);

        // The performance implications of this aren't clear, but without this subviews might not be redrawn when this
        // view moves.
        if (CPPlatformHasBug(CPCanvasParentDrawErrorsOnMovementBug))
            _DOMElement.style.webkitTransform = 'translateX(0)';

        CPDOMDisplayServerAppendChild(_DOMElement, _DOMContentsElement);
#endif
        _graphicsContext = [CPGraphicsContext graphicsContextWithGraphicsPort:graphicsPort flipped:YES];
        _needToSetTransformMatrix = YES;
    }

#if PLATFORM(DOM)
    if (_needToSetTransformMatrix && _highDPIRatio !== 1)
        [_graphicsContext graphicsPort].setTransform(_highDPIRatio, 0, 0 , _highDPIRatio, 0, 0);
#endif

    _needToSetTransformMatrix = NO;
    [CPGraphicsContext setCurrentContext:_graphicsContext];

    CGContextSaveGState([_graphicsContext graphicsPort]);
}

/*!
    Takes focus away from the receiver, and restores it to the previous view.
*/
- (void)unlockFocus
{
    CGContextRestoreGState([_graphicsContext graphicsPort]);

    [CPGraphicsContext setCurrentContext:nil];
}

- (void)setNeedsLayout
{
    [self setNeedsLayout:YES];
}

- (void)setNeedsLayout:(BOOL)needsLayout
{
    if (!needsLayout)
    {
        _needsLayout = NO;
        return;
    }

    _needsLayout = YES;

    _CPDisplayServerAddLayoutObject(self);
}

- (BOOL)needsLayout
{
    return _needsLayout;
}

- (void)layoutIfNeeded
{
    if (_needsLayout)
        [self layout];
}

/*!
    @ignore
*/
- (void)viewWillLayout
{

}

/*!
    @ignore
*/
- (void)viewDidLayout
{
    [self _recomputeAppearance];
}

- (void)layoutSubviews
{
    if ([self _layoutEngineIfExists] == nil)
        return;

    [_subviews enumerateObjectsUsingBlock:function(subview, idx, stop)
    {
        [subview _updateGeometryIfNeeded];
    }];
}

/*!
    Returns whether the receiver is completely opaque. By default, returns \c NO.
*/
- (BOOL)isOpaque
{
    return NO;
}

/*!
    Returns the rectangle of the receiver not clipped by its superview.
*/
- (CGRect)visibleRect
{
    if (!_superview)
        return _bounds;

    return CGRectIntersection([self convertRect:[_superview visibleRect] fromView:_superview], _bounds);
}

// Scrolling
/* @ignore */
- (CPScrollView)_enclosingClipView
{
    var superview = _superview,
        clipViewClass = [CPClipView class];

    while (superview && ![superview isKindOfClass:clipViewClass])
        superview = superview._superview;

    return superview;
}

/*!
    Changes the receiver's frame origin to a 'constrained' \c aPoint.
    @param aPoint the proposed frame origin
*/
- (void)scrollPoint:(CGPoint)aPoint
{
    var clipView = [self _enclosingClipView];

    if (!clipView)
        return;

    [clipView scrollToPoint:[self convertPoint:aPoint toView:clipView]];
}

/*!
    Scrolls the nearest ancestor CPClipView a minimum amount so \c aRect can become visible.
    @param aRect the area to become visible
    @return \c YES if any scrolling occurred, \c NO otherwise.
*/
- (BOOL)scrollRectToVisible:(CGRect)aRect
{
    // Make sure we have a rect that exists.
    aRect = CGRectIntersection(aRect, _bounds);

    // If aRect is empty no scrolling required.
    if (CGRectIsEmpty(aRect))
        return NO;

    var enclosingClipView = [self _enclosingClipView];

    // If we're not in a clip view, then there isn't much we can do.
    if (!enclosingClipView)
        return NO;

    var documentView = [enclosingClipView documentView];

    // If the clip view doesn't have a document view, then there isn't much we can do.
    if (!documentView)
        return NO;

    // Get the document view visible rect and convert aRect to the document view's coordinate system
    var documentViewVisibleRect = [documentView visibleRect],
        rectInDocumentView = [self convertRect:aRect toView:documentView];

    // If already visible then no scrolling required.
    if (CGRectContainsRect(documentViewVisibleRect, rectInDocumentView))
        return NO;

    var currentScrollPoint = documentViewVisibleRect.origin,
        scrollPoint = CGPointMakeCopy(currentScrollPoint),
        rectInDocumentViewMinX = CGRectGetMinX(rectInDocumentView),
        documentViewVisibleRectMinX = CGRectGetMinX(documentViewVisibleRect),
        doesItFitForWidth = documentViewVisibleRect.size.width >= rectInDocumentView.size.width;

    // One of the following has to be true since our current visible rect didn't contain aRect.
    if (rectInDocumentViewMinX < documentViewVisibleRectMinX && doesItFitForWidth)
        // Scroll to left edge of aRect as it is to the left of the visible rect and it fit inside
        scrollPoint.x = rectInDocumentViewMinX;
    else if (CGRectGetMaxX(rectInDocumentView) > CGRectGetMaxX(documentViewVisibleRect) && doesItFitForWidth)
        // Scroll to right edge of aRect as it is to the right of the visible rect and it fit inside
        scrollPoint.x = CGRectGetMaxX(rectInDocumentView) - documentViewVisibleRect.size.width;
    else if (rectInDocumentViewMinX > documentViewVisibleRectMinX)
        // Scroll to left edge of aRect as it is to the right of the visible rect and it doesn't fit inside
        scrollPoint.x = rectInDocumentViewMinX;
    else if (CGRectGetMaxX(rectInDocumentView) < CGRectGetMaxX(documentViewVisibleRect))
        // Scroll to right edge of aRect as it is to the left of the visible rect and it doesn't fit inside
        scrollPoint.x = CGRectGetMaxX(rectInDocumentView) - documentViewVisibleRect.size.width;

    var rectInDocumentViewMinY = CGRectGetMinY(rectInDocumentView),
        documentViewVisibleRectMinY = CGRectGetMinY(documentViewVisibleRect),
        doesItFitForHeight = documentViewVisibleRect.size.height >= rectInDocumentView.size.height;

    if (rectInDocumentViewMinY < documentViewVisibleRectMinY && doesItFitForHeight)
        // Scroll to top edge of aRect as it is above the visible rect and it fit inside
        scrollPoint.y = rectInDocumentViewMinY;
    else if (CGRectGetMaxY(rectInDocumentView) > CGRectGetMaxY(documentViewVisibleRect) && doesItFitForHeight)
        // Scroll to bottom edge of aRect as it is below the visible rect and it fit inside
        scrollPoint.y = CGRectGetMaxY(rectInDocumentView) - documentViewVisibleRect.size.height;
    else if (rectInDocumentViewMinY > documentViewVisibleRectMinY)
        // Scroll to top edge of aRect as it is below the visible rect and it doesn't fit inside
        scrollPoint.y = rectInDocumentViewMinY;
    else if (CGRectGetMaxY(rectInDocumentView) < CGRectGetMaxY(documentViewVisibleRect))
        // Scroll to bottom edge of aRect as it is above the visible rect and it doesn't fit inside
        scrollPoint.y = CGRectGetMaxY(rectInDocumentView) - documentViewVisibleRect.size.height;

    // Don't scroll if aRect contains the whole visible rect as it is already as visible as possible.
    // We check this by comparing to new scrollPoint to the current.
    if (CGPointEqualToPoint(scrollPoint, currentScrollPoint))
        return NO;

    [enclosingClipView scrollToPoint:scrollPoint];

    return YES;
}

/*!
    Scrolls the view’s CPClipView in the direction of a mouse event that occurs outside of it.
*/
- (BOOL)autoscroll:(CPEvent)anEvent
{
    return [[self superview] autoscroll:anEvent];
}

/*!
    Subclasses can override this to modify the visible rectangle after a
    scrolling operation. The default implementation simply returns the provided rectangle.
    @param proposedVisibleRect the rectangle to alter
    @return the same adjusted rectangle
*/
- (CGRect)adjustScroll:(CGRect)proposedVisibleRect
{
    return proposedVisibleRect;
}

/*!
    Should be overridden by subclasses.
*/
- (void)scrollRect:(CGRect)aRect by:(float)anAmount
{

}

/*!
    Returns the CPScrollView containing the receiver.
    @return the CPScrollView containing the receiver.
*/
- (CPScrollView)enclosingScrollView
{
    var superview = _superview,
        scrollViewClass = [CPScrollView class];

    while (superview && ![superview isKindOfClass:scrollViewClass])
        superview = superview._superview;

    return superview;
}

/*!
    Scrolls the clip view to a specified point
    @param the clip view to scroll
    @param the point to scroll to
*/
- (void)scrollClipView:(CPClipView)aClipView toPoint:(CGPoint)aPoint
{
    [aClipView scrollToPoint:aPoint];
}

/*!
    Notifies the receiver (superview of a CPClipView)
    that the clip view bounds or the document view bounds have changed.
    @param aClipView the clip view of the superview being notified
*/
- (void)reflectScrolledClipView:(CPClipView)aClipView
{
}

/*!
    Return yes if the receiver is in a live-resize operation.
*/
- (BOOL)inLiveResize
{
    return _inLiveResize;
}

/*!
    Not implemented.

    A view will be sent this message before a window begins a resize operation. The
    receiver might choose to simplify its drawing operations during a live resize
    for speed.

    Subclasses should call super.
*/
- (void)viewWillStartLiveResize
{
    _inLiveResize = YES;
}

/*!
    Not implemented.

    A view will be sent this message after a window finishes a resize operation. The
    receiver which simplified its drawing operations in viewWillStartLiveResize might
    stop doing so now. Note the view might no longer be in a window, so use
    [self setNeedsDisplay:YES] if a final non-simplified redraw is required.

    Subclasses should call super.
*/
- (void)viewDidEndLiveResize
{
    _inLiveResize = NO;
}

@end

@implementation CPView (KeyView)

/*!
    Overridden by subclasses to handle a key equivalent.

    If the receiver’s key equivalent is the same as the characters of the key-down event theEvent,
    as returned by \ref CPEvent::charactersIgnoringModifiers "[anEvent charactersIgnoringModifiers]",
    the receiver should take the appropriate action and return \c YES. Otherwise, it should return
    the result of invoking super’s implementation. The default implementation of this method simply
    passes the message down the view hierarchy (from superviews to subviews)
    and returns \c NO if none of the receiver’s subviews responds \c YES.

    @param anEvent An event object that represents the key equivalent pressed
    @return \c YES if theEvent is a key equivalent that the receiver handled,
            \c NO if it is not a key equivalent that it should handle.
*/
- (BOOL)performKeyEquivalent:(CPEvent)anEvent
{
    var count = [_subviews count];

    // Is reverse iteration correct here? It matches the other (correct) code like hit testing.
    while (count--)
        if ([_subviews[count] performKeyEquivalent:anEvent])
            return YES;

    return NO;
}

- (BOOL)canBecomeKeyView
{
    return [self acceptsFirstResponder] && ![self isHiddenOrHasHiddenAncestor];
}

- (CPView)nextKeyView
{
    return _nextKeyView;
}

- (CPView)nextValidKeyView
{
    var result = [self nextKeyView],
        resultUID = [result UID],
        unsuitableResults = {};

    while (result && ![result canBecomeKeyView])
    {
        unsuitableResults[resultUID] = 1;
        result = [result nextKeyView];

        resultUID = [result UID];

        // Did we get back to a key view we already ruled out due to ![result canBecomeKeyView]?
        if (unsuitableResults[resultUID])
            return nil;
    }

    return result;
}

- (CPView)previousKeyView
{
    return _previousKeyView;
}

- (CPView)previousValidKeyView
{
    var result = [self previousKeyView],
        firstResult = result;

    while (result && ![result canBecomeKeyView])
    {
        result = [result previousKeyView];

        // Cycled.
        if (result === firstResult)
            return nil;
    }

    return result;
}

- (void)_setPreviousKeyView:(CPView)previous
{
    if (![previous isEqual:self])
    {
        var previousWindow = [previous window];

        if (!previousWindow || previousWindow === _window)
        {
            _previousKeyView = previous;
            return;
        }
    }

    _previousKeyView = nil;
}

- (void)setNextKeyView:(CPView)next
{
    if (![next isEqual:self])
    {
        var nextWindow = [next window];

        if (!nextWindow || nextWindow === _window)
        {
            _nextKeyView = next;
            [_nextKeyView _setPreviousKeyView:self];
            return;
        }
    }

    _nextKeyView = nil;
}

@end

@implementation CPView (CoreAnimationAdditions)

/*!
    Sets the core animation layer to be used by this receiver.
*/
- (void)setLayer:(CALayer)aLayer
{
    if (_layer === aLayer)
        return;

    if (_layer)
    {
        _layer._owningView = nil;
#if PLATFORM(DOM)
        _DOMElement.removeChild(_layer._DOMElement);
#endif
    }

    _layer = aLayer;

    if (_layer)
    {
        var bounds = CGRectMakeCopy([self bounds]);

        [_layer _setOwningView:self];

#if PLATFORM(DOM)
        _layer._DOMElement.style.zIndex = 100;

        _DOMElement.appendChild(_layer._DOMElement);
#endif
    }
}

/*!
    Returns the core animation layer used by the receiver.
*/
- (CALayer)layer
{
    return _layer;
}

/*!
    Sets whether the receiver wants a core animation layer.
    @param \c YES means the receiver wants a layer.
*/
- (void)setWantsLayer:(BOOL)aFlag
{
    _wantsLayer = !!aFlag;
}

/*!
    Returns \c YES if the receiver uses a CALayer
    @returns \c YES if the receiver uses a CALayer
*/
- (BOOL)wantsLayer
{
    return _wantsLayer;
}

@end


@implementation CPView (Scaling)

/*!
    Set the zoom of the view. This will call scaleUnitSquareToSize: and setNeedsDisplay:
    This method doesn't care about the last zoom you set in the view
    @param aSize, the size corresponding the new unit scales
*/
- (void)setScaleSize:(CGSize)aSize
{
    if (CGSizeEqualToSize(_scaleSize, aSize))
        return;

    var size = CGSizeMakeZero(),
        scale = CGSizeMakeCopy([self scaleSize]);

    size.height = aSize.height / scale.height;
    size.width = aSize.width / scale.width;

    [self scaleUnitSquareToSize:size];
    [self setNeedsDisplay:YES];
}


/*!
    Return the scaleSize of the view, this scaleSize is used to scale in css
*/
- (CGSize)scaleSize
{
    return _scaleSize || CGSizeMake(1.0, 1.0);
}

@end


@implementation CPView (Theming)

#pragma mark Override

- (BOOL)setThemeState:(ThemeState)aState
{
    var shouldLayout = [super setThemeState:aState];

    if (!shouldLayout)
        return NO;

    [self setNeedsLayout:YES];
    [self setNeedsDisplay:YES];

    return YES;
}

- (BOOL)unsetThemeState:(ThemeState)aState
{
    var shouldLayout = [super unsetThemeState:aState];

    if (!shouldLayout)
        return NO;

    [self setNeedsLayout:YES];
    [self setNeedsDisplay:YES];

    return YES;
}

- (void)setThemeClass:(CPString)theClass
{
    [super setThemeClass:theClass];

    [self setNeedsLayout];
    [self setNeedsDisplay:YES];
}


#pragma mark First responder

- (BOOL)becomeFirstResponder
{
    var r = [super becomeFirstResponder];

    if (r)
        [self _notifyViewDidBecomeFirstResponder];

    return r;
}

- (void)_notifyViewDidBecomeFirstResponder
{
    [self setThemeState:CPThemeStateFirstResponder];

    var count = [_subviews count];

    while (count--)
        [_subviews[count] _notifyViewDidBecomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    var r = [super resignFirstResponder];

    if (r)
        [self _notifyViewDidResignFirstResponder];

    return r;
}

- (void)_notifyViewDidResignFirstResponder
{
    [self unsetThemeState:CPThemeStateFirstResponder];

    var count = [_subviews count];

    while (count--)
        [_subviews[count] _notifyViewDidResignFirstResponder];
}

- (void)_notifyWindowDidBecomeKey
{
    [self setThemeState:CPThemeStateKeyWindow];

    var count = [_subviews count];

    while (count--)
        [_subviews[count] _notifyWindowDidBecomeKey];
}

- (void)_notifyWindowDidResignKey
{
    [self unsetThemeState:CPThemeStateKeyWindow];

    var count = [_subviews count];

    while (count--)
        [_subviews[count] _notifyWindowDidResignKey];
}

#pragma mark Theme Attributes

- (void)_setThemeIncludingDescendants:(CPTheme)aTheme
{
    [self setTheme:aTheme];
    [[self subviews] makeObjectsPerformSelector:@selector(_setThemeIncludingDescendants:) withObject:aTheme];
}

- (void)objectDidChangeTheme
{
    if (!_themeAttributes)
        return;

    [super objectDidChangeTheme];

    [self setNeedsLayout];
    [self setNeedsDisplay:YES];
}

- (void)setValue:(id)aValue forThemeAttribute:(CPString)aName inState:(ThemeState)aState
{
    var currentValue = [self currentValueForThemeAttribute:aName];

    [super setValue:aValue forThemeAttribute:aName inState:aState];

    if ([self currentValueForThemeAttribute:aName] === currentValue)
        return;

    [self setNeedsDisplay:YES];
    [self setNeedsLayout];
}

- (void)setValue:(id)aValue forThemeAttribute:(CPString)aName
{
    var currentValue = [self currentValueForThemeAttribute:aName];

    [super setValue:aValue forThemeAttribute:aName ];

    if ([self currentValueForThemeAttribute:aName] === currentValue)
        return;

    [self setNeedsDisplay:YES];
    [self setNeedsLayout];
}

- (CPView)createEphemeralSubviewNamed:(CPString)aViewName
{
    return nil;
}

- (CGRect)rectForEphemeralSubviewNamed:(CPString)aViewName
{
    return CGRectMakeZero();
}

- (CPView)layoutEphemeralSubviewNamed:(CPString)aViewName
                           positioned:(CPWindowOrderingMode)anOrderingMode
      relativeToEphemeralSubviewNamed:(CPString)relativeToViewName
{
    if (!_ephemeralSubviewsForNames)
    {
        _ephemeralSubviewsForNames = {};
        _ephemeralSubviews = [CPSet set];
    }

    var frame = [self rectForEphemeralSubviewNamed:aViewName];

    if (frame)
    {
        if (!_ephemeralSubviewsForNames[aViewName])
        {
            _ephemeralSubviewsForNames[aViewName] = [self createEphemeralSubviewNamed:aViewName];

            [_ephemeralSubviews addObject:_ephemeralSubviewsForNames[aViewName]];

            if (_ephemeralSubviewsForNames[aViewName])
                [self addSubview:_ephemeralSubviewsForNames[aViewName] positioned:anOrderingMode relativeTo:_ephemeralSubviewsForNames[relativeToViewName]];
        }

        if (_ephemeralSubviewsForNames[aViewName])
            [_ephemeralSubviewsForNames[aViewName] setFrame:frame];
    }
    else if (_ephemeralSubviewsForNames[aViewName])
    {
        [_ephemeralSubviewsForNames[aViewName] removeFromSuperview];

        [_ephemeralSubviews removeObject:_ephemeralSubviewsForNames[aViewName]];
        delete _ephemeralSubviewsForNames[aViewName];
    }

    return _ephemeralSubviewsForNames[aViewName];
}

- (CPView)ephemeralSubviewNamed:(CPString)aViewName
{
    if (!_ephemeralSubviewsForNames)
        return nil;

    return (_ephemeralSubviewsForNames[aViewName] || nil);
}

@end


@implementation CPView (Appearance)

/*! Returns the receiver's appearance if any, or ask the superview and returns it.
*/
- (CPAppearance)effectiveAppearance
{
    if (_appearance)
        return _appearance;

    return [_superview effectiveAppearance];
}

- (void)setAppearance:(CPAppearance)anAppearance
{
    if ([_appearance isEqual:anAppearance])
        return;

    [self willChangeValueForKey:@"appearance"];
    _appearance = anAppearance;
    [self didChangeValueForKey:@"appearance"];

    [self setNeedsLayout:YES];
}

/*! @ignore
*/
- (void)_recomputeAppearance
{
    var effectiveAppearance = [self effectiveAppearance];

    if ([effectiveAppearance isEqual:[CPAppearance appearanceNamed:CPAppearanceNameAqua]])
    {
        [self setThemeState:CPThemeStateAppearanceAqua];
        [self unsetThemeState:CPThemeStateAppearanceLightContent];
        [self unsetThemeState:CPThemeStateAppearanceVibrantLight];
        [self unsetThemeState:CPThemeStateAppearanceVibrantDark];
    }
    else if ([effectiveAppearance isEqual:[CPAppearance appearanceNamed:CPAppearanceNameLightContent]])
    {
        [self unsetThemeState:CPThemeStateAppearanceAqua];
        [self setThemeState:CPThemeStateAppearanceLightContent];
        [self unsetThemeState:CPThemeStateAppearanceVibrantLight];
        [self unsetThemeState:CPThemeStateAppearanceVibrantDark];
    }
    else if ([effectiveAppearance isEqual:[CPAppearance appearanceNamed:CPAppearanceNameVibrantLight]])
    {
        [self unsetThemeState:CPThemeStateAppearanceAqua];
        [self unsetThemeState:CPThemeStateAppearanceLightContent];
        [self setThemeState:CPThemeStateAppearanceVibrantLight];
        [self unsetThemeState:CPThemeStateAppearanceVibrantDark];
    }
    else if ([effectiveAppearance isEqual:[CPAppearance appearanceNamed:CPAppearanceNameVibrantDark]])
    {
        [self unsetThemeState:CPThemeStateAppearanceAqua];
        [self unsetThemeState:CPThemeStateAppearanceLightContent];
        [self unsetThemeState:CPThemeStateAppearanceVibrantLight];
        [self setThemeState:CPThemeStateAppearanceVibrantDark];
    }
    else
    {
        [self unsetThemeState:CPThemeStateAppearanceAqua];
        [self unsetThemeState:CPThemeStateAppearanceLightContent];
        [self unsetThemeState:CPThemeStateAppearanceVibrantLight];
        [self unsetThemeState:CPThemeStateAppearanceVibrantDark];
    }

//    var start = [CPDate new];

    for (var i = 0, size = [_subviews count]; i < size; i++)
    {
        [[_subviews objectAtIndex:i] _recomputeAppearance];
    }
//    [_subviews makeObjectsPerformSelector:@selector(_recomputeAppearance)];

/*    var now = [CPDate new];
    var elapsedSeconds = [now timeIntervalSinceReferenceDate] - [start timeIntervalSinceReferenceDate];

    CPLog.trace(@"_recomputeAppearance " + [_subviews count] + " subviews in " + elapsedSeconds + @" seconds");
*/}


@end

@implementation CPView (TrackingAreaAdditions)

- (void)addTrackingArea:(CPTrackingArea)trackingArea
{
    // Consistency check
    if (!trackingArea || [_trackingAreas containsObjectIdenticalTo:trackingArea])
        return;

    if ([trackingArea view])
        [CPException raise:CPInternalInconsistencyException reason:"Tracking area has already been added to another view."];

    [_trackingAreas addObject:trackingArea];
    [trackingArea setView:self];

    if (_window)
        [_window _addTrackingArea:trackingArea];

    [trackingArea _updateWindowRect];
}

- (void)removeTrackingArea:(CPTrackingArea)trackingArea
{
    // Consistency check
    if (!trackingArea)
        return;

    if (![_trackingAreas containsObjectIdenticalTo:trackingArea])
        [CPException raise:CPInternalInconsistencyException reason:"Trying to remove unreferenced trackingArea"];

    [self _removeTrackingArea:trackingArea];
}

/*!
 Invoked automatically when the view’s geometry changes such that its tracking areas need to be recalculated.

 You should override this method to remove out of date tracking areas and add recomputed tracking areas;

 Cocoa calls this on every view, whereas they have tracking area(s) or not.
 Cappuccino behaves differently :
 - updateTrackingAreas is called when placing a view in the view hierarchy (that is in a window)
 - if you have only CPTrackingInVisibleRect tracking areas attached to a view, it will not be called again (until you move the view in the hierarchy)
 - if you have at least one non-CPTrackingInVisibleRect tracking area attached, it will be called every time the view geometry could be modified
   You don't have to touch to CPTrackingInVisibleRect tracking areas, they will be automatically updated

 Please note that it is the owner of a tracking area who is called for updateTrackingAreas.
 But, if a view without any tracking area is inserted in the view hierarchy (that is, in a window), the view is called for updateTrackingAreas.
 This enables you to use updateTrackingArea to initially attach your tracking areas to the view.
*/
- (void)updateTrackingAreas
{

}

/*!
 This utility method is intended for CPView subclasses overriding updateTrackingAreas

 Typical use would be :

 - (void)updateTrackingAreas
 {
      [self removeAllTrackingAreas];

      ... add your specific updated tracking areas ...
  }

*/
- (void)removeAllTrackingAreas
{
    while (_trackingAreas.length > 0)
        [self _removeTrackingArea:_trackingAreas[0]];
}

// Internal methods

- (void)_removeTrackingArea:(CPTrackingArea)trackingArea
{
    if (_window)
        [_window _removeTrackingArea:trackingArea];

    [trackingArea setView:nil];
    [_trackingAreas removeObjectIdenticalTo:trackingArea];
}

- (void)_updateTrackingAreasWithRecursion:(BOOL)shouldCallRecursively
{
    _inhibitUpdateTrackingAreas = YES;

    [self _updateTrackingAreasForOwners:[self _calcTrackingAreaOwners]];

    if (shouldCallRecursively)
{
        // Now, call _updateTrackingAreasWithRecursion on subviews

    for (var i = 0; i < _subviews.length; i++)
            [_subviews[i] _updateTrackingAreasWithRecursion:YES];
}

    _inhibitUpdateTrackingAreas = NO;
}

- (CPArray)_calcTrackingAreaOwners
{
    // First search all owners that must be notified
    // Remark: 99.99% of time, the only owner will be the view itself
    // In the same time, update the rects of InVisibleRect tracking areas

    var owners = [];

    for (var i = 0; i < _trackingAreas.length; i++)
    {
        var trackingArea = _trackingAreas[i];

        if ([trackingArea options] & CPTrackingInVisibleRect)
            [trackingArea _updateWindowRect];

        else
        {
            var owner = [trackingArea owner];

            if (![owners containsObjectIdenticalTo:owner])
                [owners addObject:owner];
        }
    }

    return owners;
}

- (void)_updateTrackingAreasForOwners:(CPArray)owners
{
    for (var i = 0; i < owners.length; i++)
        [owners[i] updateTrackingAreas];
}

@end

var CPViewAutoresizingMaskKey       = @"CPViewAutoresizingMask",
    CPViewAutoresizesSubviewsKey    = @"CPViewAutoresizesSubviews",
    CPViewBackgroundColorKey        = @"CPViewBackgroundColor",
    CPViewBoundsKey                 = @"CPViewBoundsKey",
    CPViewFrameKey                  = @"CPViewFrameKey",
    CPViewHitTestsKey               = @"CPViewHitTestsKey",
    CPViewToolTipKey                = @"CPViewToolTipKey",
    CPViewIsHiddenKey               = @"CPViewIsHiddenKey",
    CPViewOpacityKey                = @"CPViewOpacityKey",
    CPViewSubviewsKey               = @"CPViewSubviewsKey",
    CPViewSuperviewKey              = @"CPViewSuperviewKey",
    CPViewTagKey                    = @"CPViewTagKey",
    CPViewWindowKey                 = @"CPViewWindowKey",
    CPViewNextKeyViewKey            = @"CPViewNextKeyViewKey",
    CPViewPreviousKeyViewKey        = @"CPViewPreviousKeyViewKey",
    CPReuseIdentifierKey            = @"CPReuseIdentifierKey",
    CPViewScaleKey                  = @"CPViewScaleKey",
    CPViewSizeScaleKey              = @"CPViewSizeScaleKey",
    CPViewIsScaledKey               = @"CPViewIsScaledKey",
    CPViewAppearanceKey             = @"CPViewAppearanceKey",
    CPViewTrackingAreasKey          = @"CPViewTrackingAreasKey",
    CPViewConstraints               = @"CPViewConstraints",
    CPHuggingPriority               = @"CPHuggingPriority",
    CPAntiCompressionPriority       = @"CPAntiCompressionPriority",
    CPDoNotTranslateAutoresizingMask = @"CPDoNotTranslateAutoresizingMask";

@implementation CPView (CPCoding)

/*!
    Initializes the view from an archive.
    @param aCoder the coder from which to initialize
    @return the initialized view
*/
- (id)initWithCoder:(CPCoder)aCoder
{
    // We create the DOMElement "early" because there is a chance that we
    // will decode our superview before we are done decoding, at which point
    // we have to have an element to place in the tree.  Perhaps there is
    // a more "elegant" way to do this...?
#if PLATFORM(DOM)
    _DOMElement = DOMElementPrototype.cloneNode(false);
    AppKitTagDOMElement(self, _DOMElement);
#endif

    // Also decode these "early".
    _frame = [aCoder decodeRectForKey:CPViewFrameKey];
    _bounds = [aCoder decodeRectForKey:CPViewBoundsKey];

    self = [super initWithCoder:aCoder];

    if (self)
    {
        _trackingAreas = [aCoder decodeObjectForKey:CPViewTrackingAreasKey];

        if (!_trackingAreas)
            _trackingAreas = [];

        // We have to manually check because it may be 0, so we can't use ||
        _tag = [aCoder containsValueForKey:CPViewTagKey] ? [aCoder decodeIntForKey:CPViewTagKey] : -1;
        _identifier = [aCoder decodeObjectForKey:CPReuseIdentifierKey];
        _window = [aCoder decodeObjectForKey:CPViewWindowKey];
        _superview = [aCoder decodeObjectForKey:CPViewSuperviewKey];
        // We have to manually add the subviews so that they will receive
        // viewWillMoveToSuperview: and viewDidMoveToSuperview:
        _subviews = [];

        var subviews = [aCoder decodeObjectForKey:CPViewSubviewsKey] || [];

        for (var i = 0, count = [subviews count]; i < count; ++i)
        {
            // addSubview won't do anything if the superview is already self, so clear it
            subviews[i]._superview = nil;
            [self addSubview:subviews[i]];
        }

        // FIXME: Should we encode/decode this?
        _registeredDraggedTypes = [CPSet set];
        _registeredDraggedTypesArray = [];

        // Other views (CPBox) might set an autoresizes mask on their subviews before it is actually decoded.
        // We make sure we don't override the value by checking if it was already set.
        if (_autoresizingMask === nil)
            _autoresizingMask = [aCoder decodeIntForKey:CPViewAutoresizingMaskKey] || CPViewNotSizable;

        _autoresizesSubviews = ![aCoder containsValueForKey:CPViewAutoresizesSubviewsKey] || [aCoder decodeBoolForKey:CPViewAutoresizesSubviewsKey];

        _hitTests = ![aCoder containsValueForKey:CPViewHitTestsKey] || [aCoder decodeBoolForKey:CPViewHitTestsKey];

        _toolTip = [aCoder decodeObjectForKey:CPViewToolTipKey];

        if (_toolTip)
            [self _installToolTipEventHandlers];

        _scaleSize = [aCoder containsValueForKey:CPViewScaleKey] ? [aCoder decodeSizeForKey:CPViewScaleKey] : CGSizeMake(1.0, 1.0);
        _hierarchyScaleSize = [aCoder containsValueForKey:CPViewSizeScaleKey] ? [aCoder decodeSizeForKey:CPViewSizeScaleKey] : CGSizeMake(1.0, 1.0);
        _isScaled = [aCoder containsValueForKey:CPViewIsScaledKey] ? [aCoder decodeBoolForKey:CPViewIsScaledKey] : NO;

        // DOM SETUP
#if PLATFORM(DOM)
        _DOMImageParts = [];
        _DOMImageSizes = [];

        CPDOMDisplayServerSetStyleLeftTop(_DOMElement, NULL, CGRectGetMinX(_frame), CGRectGetMinY(_frame));
        [self _setDisplayServerSetStyleSize:_frame.size];

        var index = 0,
            count = _subviews.length;

        for (; index < count; ++index)
        {
            CPDOMDisplayServerAppendChild(_DOMElement, _subviews[index]._DOMElement);
            //_subviews[index]._superview = self;
        }
#endif

        [self setHidden:[aCoder decodeBoolForKey:CPViewIsHiddenKey]];
        _isHiddenOrHasHiddenAncestor = NO;

        if ([aCoder containsValueForKey:CPViewOpacityKey])
            [self setAlphaValue:[aCoder decodeIntForKey:CPViewOpacityKey]];
        else
            _opacity = 1.0;

        [self setBackgroundColor:[aCoder decodeObjectForKey:CPViewBackgroundColorKey]];
        [self _setupViewFlags];
        [self _decodeThemeObjectsWithCoder:aCoder];

        [self setAppearance:[aCoder decodeObjectForKey:CPViewAppearanceKey]];

        //ConstraintBasedLayout
        [self _initAutolayoutIvars];

        if ([aCoder containsValueForKey:CPViewConstraints])
            _internalConstraints = [aCoder decodeObjectForKey:CPViewConstraints];

        _translatesAutoresizingMaskIntoConstraints = ![aCoder decodeBoolForKey:CPDoNotTranslateAutoresizingMask];

        if ([aCoder containsValueForKey:CPHuggingPriority])
            _huggingPriorities = [aCoder decodeSizeForKey:CPHuggingPriority];

        if ([aCoder containsValueForKey:CPAntiCompressionPriority])
            _compressionPriorities = [aCoder decodeSizeForKey:CPAntiCompressionPriority];

        [self setNeedsDisplay:YES];
        [self setNeedsLayout];
    }

    return self;
}

/*!
    Archives the view to a coder.
    @param aCoder the object into which the view's data will be archived.
*/
- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    if (_tag !== -1)
        [aCoder encodeInt:_tag forKey:CPViewTagKey];

    [aCoder encodeRect:_frame forKey:CPViewFrameKey];
    [aCoder encodeRect:_bounds forKey:CPViewBoundsKey];

    // This will come out nil on the other side with decodeObjectForKey:
    if (_window !== nil)
        [aCoder encodeConditionalObject:_window forKey:CPViewWindowKey];

    var count = [_subviews count],
        encodedSubviews = _subviews;

    if (count > 0 && [_ephemeralSubviews count] > 0)
    {
        encodedSubviews = [encodedSubviews copy];

        while (count--)
            if ([_ephemeralSubviews containsObject:encodedSubviews[count]])
                encodedSubviews.splice(count, 1);
    }

    if (encodedSubviews.length > 0)
        [aCoder encodeObject:encodedSubviews forKey:CPViewSubviewsKey];

    // This will come out nil on the other side with decodeObjectForKey:
    if (_superview !== nil)
        [aCoder encodeConditionalObject:_superview forKey:CPViewSuperviewKey];

    if (_autoresizingMask !== CPViewNotSizable)
        [aCoder encodeInt:_autoresizingMask forKey:CPViewAutoresizingMaskKey];

    if (!_autoresizesSubviews)
        [aCoder encodeBool:_autoresizesSubviews forKey:CPViewAutoresizesSubviewsKey];

    if (_backgroundColor !== nil)
        [aCoder encodeObject:_backgroundColor forKey:CPViewBackgroundColorKey];

    if (_hitTests !== YES)
        [aCoder encodeBool:_hitTests forKey:CPViewHitTestsKey];

    if (_opacity !== 1.0)
        [aCoder encodeFloat:_opacity forKey:CPViewOpacityKey];

    if (_isHidden)
        [aCoder encodeBool:_isHidden forKey:CPViewIsHiddenKey];

    if (_toolTip)
        [aCoder encodeObject:_toolTip forKey:CPViewToolTipKey];

    var nextKeyView = [self nextKeyView];

    if (nextKeyView !== nil && ![nextKeyView isEqual:self])
        [aCoder encodeConditionalObject:nextKeyView forKey:CPViewNextKeyViewKey];

    var previousKeyView = [self previousKeyView];

    if (previousKeyView !== nil && ![previousKeyView isEqual:self])
        [aCoder encodeConditionalObject:previousKeyView forKey:CPViewPreviousKeyViewKey];

    [self _encodeThemeObjectsWithCoder:aCoder];

    if (_identifier)
        [aCoder encodeObject:_identifier forKey:CPReuseIdentifierKey];

    [aCoder encodeSize:[self scaleSize] forKey:CPViewScaleKey];
    [aCoder encodeSize:[self _hierarchyScaleSize] forKey:CPViewSizeScaleKey];
    [aCoder encodeBool:_isScaled forKey:CPViewIsScaledKey];
    [aCoder encodeObject:_appearance forKey:CPViewAppearanceKey];
    [aCoder encodeObject:_trackingAreas forKey:CPViewTrackingAreasKey];

    var constraints = [_internalConstraints filteredArrayUsingBlock:_CPLayoutConstraintNeedArchivingBlock];

    if ([constraints count])
        [aCoder encodeObject:constraints forKey:CPViewConstraints];

    if (_huggingPriorities)
        [aCoder encodeSize:_huggingPriorities forKey:CPHuggingPriority];

    if (_compressionPriorities)
        [aCoder encodeSize:_compressionPriorities forKey:CPAntiCompressionPriority];

    [aCoder encodeBool:!_translatesAutoresizingMaskIntoConstraints forKey:CPDoNotTranslateAutoresizingMask];
}

@end

@implementation CPView (ConstraintBasedLayout)

/*!
Returns whether the receiver depends on the constraint-based layout system.
+ (BOOL)requiresConstraintBasedLayout
@returns YES if the view must be in a window using constraint-based layout to function properly, NO otherwise.

@discussion Custom views should override this to return YES if they can not layout correctly using autoresizing.
*/
+ (BOOL)requiresConstraintBasedLayout
{
//    return [self instancesImplementSelector:@selector(updateConstraints)];
    return NO;
}

/*!
    Tells the Autolayout system to stop constraint updating in the subtree.

    @discussion Subclasses should return YES when subviews honor the autoresizingMask and need to be managed by the Autosize layout system.
    Defaults to NO.
*/
+ (BOOL)refusesConstraintBasedLayout
{
    return NO;
}

- (void)_initAutolayoutIvars
{
    _localEngine = nil;
    _viewIsConstraintBased = NO;
    _viewHasConstraintBasedSubviews = NO;
    _isSettingFrameFromEngine = NO;
    _subviewsNeedSolvingInEngine = NO;
    _needsUpdateConstraints = YES;
    _topLevelViewExtraConstraintsAdded = NO;
    _geometryDirtyMask = 0;
    _autoresizingConstraints = nil;
    _contentSizeConstraints = @[];
    _internalConstraints = nil;
    _constraintsArray = @[];
    _storedIntrinsicContentSize = CGSizeMake(CPViewNoInstrinsicMetric, CPViewNoInstrinsicMetric);

    _centerYAnchor = nil;
    _centerXAnchor = nil;
    _heightAnchor = nil;
    _widthAnchor = nil;
    _bottomAnchor = nil;
    _lastBaselineAnchor = nil;
    _firstBaselineAnchor = nil;
    _topAnchor = nil;
    _rightAnchor = nil;
    _leftAnchor = nil;
    _trailingAnchor = nil;
    _leadingAnchor = nil;

    _variableMinX = nil;
    _variableMinY = nil;
    _variableWidth = nil;
    _variableHeight = nil;
}

- (void)_cibDidFinishLoadingWithOwner:(id)anOwner
{
    if (_internalConstraints)
    {
        [_internalConstraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
        {
            [aConstraint _replaceCustomViewsIfNeeded];
        }];

        [self addConstraints:_internalConstraints];
        _internalConstraints = nil;
    }
}

- (CPLayoutConstraintEngine)_layoutEngine
{
    var engine = nil;

    if (_window !== nil)
        // Lazilly create a window engine if needed.
        engine = [_window _layoutEngine];
    else
        // Lazilly creates a local engine if needed on the top level view.
        engine = [[self topLevelView] _localEngine];

    return engine;
}

- (CPLayoutConstraintEngine)_localEngine
{
    if (_superview !== nil)
    {
        [CPException raise:CPInternalInconsistencyException format:@"The local engine exists only for detached views."];
    }

    if (_localEngine == nil)
    {
        _localEngine = [[CPLayoutConstraintEngine alloc] initWithDelegate:self];
    }

    return _localEngine;
}

- (CPView)topLevelView
{
    var result = self,
        superview;

    while ((superview = [result superview]) !== nil)
    {
        result = superview;
    }

    return result;
}

- (CPLayoutConstraintEngine)_localEngineIfExists
{
    return [[self topLevelView] _localEngineIvar];
}

- (BOOL)_hasLocalEngine
{
    var result = (_localEngine !== nil);

    if (result && _superview !== nil)
        [CPException raise:CPInternalInconsistencyException format:@"The view %@ has a local engine but is not a top level view. This should never happen.", self];

    return result;
}

- (CPLayoutConstraintEngine)_layoutEngineIfExists
{
    if (_window !== nil)
        return [_window _layoutEngineIfExists];
    else
        return [self _localEngineIfExists];
}

- (void)_promoteLocalEngineToWindowEngine
{
    var windowEngine = [_window _layoutEngineIfExists];

    if (windowEngine)
    {
        [windowEngine _addConstraintsFromEngine:_localEngine passingTest:function(engine_constraint, type, owner)
        {
            // Do not add the extra Autoresizing Constraints we added previously.
            return !(owner == self && _topLevelViewExtraConstraintsAdded && type == "AutoresizingConstraint");
        }];

        [_localEngine _discard];
        // TODO: We may need to solve if there was a change in engine constraints.
    }
    else
    {
        [_window _setLayoutEngine:_localEngine];
        [_localEngine _setDelegate:_window];
    }
}

// DEBUG
- (CPString)debugID
{
    if ([self className] == "_CPCibCustomView")
        return ("(CPCibCustomView)" + ([self identifier] || ""));

    return ([self identifier] || [self className]);
}

// Content Size Constraints
+ (CGSize)_defaultHuggingPriorities
{
    return CGSizeMake(CPLayoutPriorityDefaultLow, CPLayoutPriorityDefaultLow);
}

+ (CGSize)_defaultCompressionPriorities
{
    return CGSizeMake(CPLayoutPriorityDefaultHigh, CPLayoutPriorityDefaultHigh);
}

- (CGSize)_contentHuggingPriorities
{
    if (!_huggingPriorities)
        _huggingPriorities = [[self class] _defaultHuggingPriorities];

    return _huggingPriorities;
}

- (CGSize)_contentCompressionResistancePriorities
{
    if (!_compressionPriorities)
        _compressionPriorities = [[self class] _defaultCompressionPriorities];

    return _compressionPriorities;
}

/*!
    Returns the minimum size of the view that satisfies the constraints it holds.
    @return The minimum size of the view that satisfies the constraints it holds.
    @discussion Determines the best size of the view considering all constraints it holds and those of its subviews, together with a preference(*) for the view itself to be as small as possible.
    (*) This preference's priority of CPLayoutPriorityFittingSizeCompression
*/
- (CGSize)fittingSize
{
    // Subclasses should override.
    return CGSizeMake(CPViewNoInstrinsicMetric, CPViewNoInstrinsicMetric);
}

- (BOOL)intrinsicContentSizeIsNoInstrinsicMetric
{
    var intrinsic = [self intrinsicContentSize];

    return CGSizeEqualToSize(intrinsic, CGSizeMake(CPViewNoInstrinsicMetric, CPViewNoInstrinsicMetric));
}

/*!
    Returns The natural size for the receiving view, considering only properties of the view itself.

    @return A size indicating the natural size for the receiving view based on its intrinsic properties.

    @discussion The default width and height values of this property are set to CPViewNoInstrinsicMetric. For a custom view, you can override this property and use it to communicate what size you would like your view to be based on its content. You might do this in cases where the layout system cannot determine the size of the view based solely on its current constraints. For example, a text field might override this method and return an intrinsic size based on the text it contains. The intrinsic size you supply must be independent of the content frame, because there’s no way to dynamically communicate a changed width to the layout system based on a changed height. If your custom view has no intrinsic size for a given dimension, you can set the corresponding dimension to the CPViewNoInstrinsicMetric.
*/
- (CGSize)intrinsicContentSize
{
    return CGSizeMake(CPViewNoInstrinsicMetric, CPViewNoInstrinsicMetric);
}
/*!
The distance (in points) between the bottom of the view’s alignment rectangle and its baseline.

- (float)baselineOffsetFromBottom

@discussion The default value of this property is 0. For views that contain text or other content whose layout benefits from having a custom baseline, you can override this property and provide the correct distance between the bottom of the view’s alignment rectangle and that baseline.
*/
- (float)baselineOffsetFromBottom
{
    return 0.0;
}

/*!
Returns the view’s alignment rectangle for a given frame.

- (CGRect)alignmentRectForFrame:(CGRect)frame

@param frame The frame whose corresponding alignment rectangle is desired.

@returns The alignment rectangle for the specified frame.

@discussion The constraint-based layout system uses alignment rectangles to align views, rather than their frame. This allows custom views to be aligned based on the location of their content while still having a frame that encompasses any ornamentation they need to draw around their content, such as shadows or reflections.

    The default implementation returns the view’s frame modified by the insets specified by the view’s alignmentRectInsets method. Most custom views can override alignmentRectInsets to specify the location of their content within their frame. Custom views that require arbitrary transformations can override alignmentRectForFrame: and frameForAlignmentRect: to describe the location of their content. These two methods must always be inverses of each other.
*/
- (CGRect)alignmentRectForFrame:(CGRect)frame
{
    return CGRectInsetByInset(frame, [self alignmentRectInsets]);
}

/*!
Returns the view’s frame for a given alignment rectangle.

- (CGRect)frameForAlignmentRect:(CGRect)alignmentRect

@param alignmentRect The alignment rectangle whose corresponding frame is desired.

@returns The frame for the specified alignment rectangle

@discussion The constraint-based layout system uses alignment rectangles to align views, rather than their frame. This allows custom views to be aligned based on the location of their content while still having a frame that encompasses any ornamentation they need to draw around their content, such as shadows or reflections.

    The default implementation returns alignmentRect modified by the insets specified by the view’s alignmentRectInsets method. Most custom views can override alignmentRectInsets to specify the location of their content within their frame. Custom views that require arbitrary transformations can override alignmentRectForFrame: and frameForAlignmentRect: to describe the location of their content. These two methods must always be inverses of each other.
*/
- (CGRect)frameForAlignmentRect:(CGRect)alignmentRect
{
    var invertedInset = CGInsetMakeInvertedCopy([self alignmentRectInsets]);

    return CGRectInsetByInset(alignmentRect, invertedInset);
}

/*!
The insets (in points) from the view’s frame that define its content rectangle.

- (CGInset)alignmentRectInsets

@discussion The default value is an NSEdgeInsets structure with the value 0 for each component. Custom views that draw ornamentation around their content can override this property and return insets that align with the edges of the content, excluding the ornamentation. This allows the constraint-based layout system to align views based on their content, rather than just their frame.

@note Custom views whose content location can’t be expressed by a simple set of insets should override alignmentRectForFrame: and frameForAlignmentRect: to describe their custom transform between alignment rectangle and frame.
*/
- (CGInset)alignmentRectInsets
{
    return CGInsetMakeZero();
}

/*!
Invalidates the view’s intrinsic content size.

- (void)invalidateIntrinsicContentSize

@discussion Call this when something changes in your custom view that invalidates its intrinsic content size. This allows the constraint-based layout system to take the new intrinsic content size into account in its next layout pass.
*/
- (void)invalidateIntrinsicContentSize
{
    if (![[self window] isAutolayoutEnabled])
        return;
//CPLog.debug([self debugID] + " " +  _cmd);
    [self setNeedsUpdateConstraints:YES];
    [[self window] setNeedsLayout];
}

- (void)_setContentSizeConstraints:(CPArray)constraints
{
//CPLog.debug(([self identifier] || [self class]) + _cmd);
    var translate = [self translatesAutoresizingMaskIntoConstraints];
    if (translate)
        CPLog.warn(@"Setting contentSize constraints when autoresizing is on");

    _contentSizeConstraints = constraints;
}
/*
- (CGSize)resolvedIntrinsicContentSize
{
    var intrinsicContentSize = CGSizeMakeCopy([self intrinsicContentSize]),
        isNoIntrinsicWidth = (intrinsicContentSize.width === CPViewNoInstrinsicMetric),
        isNoIntrinsicHeight = (intrinsicContentSize.height === CPViewNoInstrinsicMetric);

    if (isNoIntrinsicWidth || isNoIntrinsicHeight)
    {
        // TODO: Maybe what we need here is the minimumFrameSize (not implemented in all controls).
        // fittingSize is the minimumFrameSize but given all constraints involving the view.
        var fittingSize = [self fittingSize];

        if (isNoIntrinsicWidth)
            intrinsicContentSize.width = fittingSize.width;

        if (isNoIntrinsicHeight)
            intrinsicContentSize.height = fittingSize.height;
    }

    return intrinsicContentSize;
}
*/
- (CPArray)_generateContentSizeConstraints
{
    var constraints = [CPArray array],
        // TODO: intrinsicContentSize = [self resolvedIntrinsicContentSize] when -fittingSize is implemented
        intrinsicContentSize = [self intrinsicContentSize],
        isNoIntrinsicWidth = (intrinsicContentSize.width === CPViewNoInstrinsicMetric),
        isNoIntrinsicHeight = (intrinsicContentSize.height === CPViewNoInstrinsicMetric);

    if (isNoIntrinsicWidth && isNoIntrinsicHeight)
        return constraints;

    var huggingPriorities = [self _contentHuggingPriorities],
        compressionResistancePriorities = [self _contentCompressionResistancePriorities];

    if (!isNoIntrinsicWidth)
    {
        var constraint = [[CPContentSizeLayoutConstraint alloc] initWithLayoutItem:self value:intrinsicContentSize.width huggingPriority:huggingPriorities.width compressionResistancePriority:compressionResistancePriorities.width orientation:CPLayoutConstraintOrientationHorizontal];

        [constraints addObject:constraint];
    }

    if (!isNoIntrinsicHeight)
    {
        var constraint = [[CPContentSizeLayoutConstraint alloc] initWithLayoutItem:self value:intrinsicContentSize.height huggingPriority:huggingPriorities.height compressionResistancePriority:compressionResistancePriorities.height orientation:CPLayoutConstraintOrientationVertical];

        [constraints addObject:constraint];
    }

    return constraints;
}

/*!
Sets the priority with which a view resists being made larger than its intrinsic size.

- (void)setContentHuggingPriority:(CPLayoutPriority)aPriority forOrientation:(CPLayoutConstraintOrientation)orientation

@param aPriority The new priority.

@param orientation The orientation for which the content hugging priority should be set.

@discussion Custom views should set default values for both orientations on creation, based on their content, typically to CPLayoutPriorityDefaultLow or CPLayoutPriorityDefaultHigh. When creating user interfaces, the layout designer can modify these priorities for specific views when the overall layout design requires different tradeoffs than the natural priorities of the views being used in the interface.

@note Subclasses should not override this method.
*/
- (void)setContentHuggingPriority:(CPLayoutPriority)aPriority forOrientation:(CPLayoutConstraintOrientation)orientation
{
    if ([self contentHuggingPriorityForOrientation:orientation] !== aPriority)
    {
        var huggingPriorities = [self _contentHuggingPriorities];

        SetSizeValue(huggingPriorities, aPriority, orientation);
    }
}

/*!
Returns the priority with which a view resists being made larger than its intrinsic size.

- (CPLayoutPriority)contentHuggingPriorityForOrientation:(CPLayoutConstraintOrientation)orientation

@param orientation The orientation of the dimension of the view that might be enlarged.

@returns The priority with which the view should resist being enlarged from its intrinsic size in the specified orientation.

@discussion The constraint-based layout system uses these priorities when determining the best layout for views that are encountering constraints that would require them to be smaller than their intrinsic size.

@note Subclasses should not override this method. Instead, custom views should set default values for their content on creation, typically to CPLayoutPriorityDefaultLow or CPLayoutPriorityDefaultHigh.
*/
- (CPLayoutPriority)contentHuggingPriorityForOrientation:(CPLayoutConstraintOrientation)orientation
{
    var huggingPriorities = [self _contentHuggingPriorities];

    return (orientation == 0) ? huggingPriorities.width : huggingPriorities.height;
}

/*!
Sets the priority with which a view resists being made smaller than its intrinsic size.

- (void)setContentCompressionResistancePriority:(CPLayoutPriority)aPriority forOrientation:(CPLayoutConstraintOrientation)orientation

@param aPriority The new priority.

@param orientation The orientation for which the compression resistance priority should be set.

@discussion Custom views should set default values for both orientations on creation, based on their content, typically to CPLayoutPriorityDefaultLow or CPLayoutPriorityDefaultHigh. When creating user interfaces, the layout designer can modify these priorities for specific views when the overall layout design requires different tradeoffs than the natural priorities of the views being used in the interface.

@note Subclasses should not override this method.
*/
- (void)setContentCompressionResistancePriority:(CPLayoutPriority)aPriority forOrientation:(CPLayoutConstraintOrientation)orientation
{
    if ([self contentCompressionResistancePriorityForOrientation:orientation] !== aPriority)
    {
        var compressionResistancePriorities = [self _contentCompressionResistancePriorities];

        SetSizeValue(compressionResistancePriorities, aPriority, orientation);
    }
}

/*!
Returns the priority with which a view resists being made smaller than its intrinsic size.

- (CPLayoutPriority)contentCompressionResistancePriorityForOrientation:(CPLayoutConstraintOrientation)orientation

@param orientation The orientation of the dimension of the view that might be reduced.

@returns The priority with which the view should resist being compressed from its intrinsic size in the specified orientation.

@discussion The constraint-based layout system uses these priorities when determining the best layout for views that are encountering constraints that would require them to be smaller than their intrinsic size.

@note Subclasses should not override this method. Instead, custom views should set default values for their content on creation, typically to CPLayoutPriorityDefaultLow or CPLayoutPriorityDefaultHigh.
*/
- (CPLayoutPriority)contentCompressionResistancePriorityForOrientation:(CPLayoutConstraintOrientation)orientation
{
    var compressionResistancePriorities = [self _contentCompressionResistancePriorities];

    return (orientation == 0) ? compressionResistancePriorities.width : compressionResistancePriorities.height;
}
/*
- (CPContentSizeLayoutConstraint)_contentSizeConstraintForOrientation:(CPLayoutConstraintOrientation)orientation
{
    [self _updateContentSizeConstraints];

    var contentSizeConstraints = [self _contentSizeConstraints];

    var idx = [contentSizeConstraints indexOfObjectPassingTest:function(aConstraint, idx, stop)
              {
                  return ([aConstraint orientation] == orientation);
              }];

    if (idx !== CPNotFound)
        return [contentSizeConstraints objectAtIndex:idx];

    return nil;
}
*/

/*!
The constraints held by the view.

- (CPArray)constraints

@discussion This property contains an array of CPLayoutConstraint objects representing the constraints applied to the view. If the view does not have any constraints, this property contains an empty array.
*/
- (CPArray)constraints
{
    var constraints = [CPArray arrayWithArray:_constraintsArray];

    [[self subviews] enumerateObjectsUsingBlock:function(aView, idx, stop)
    {
        if ([aView translatesAutoresizingMaskIntoConstraints])
        {
            [aView _updateAutoresizingConstraints];
            [constraints addObjectsFromArray:[aView _autoresizingConstraints]];
        }
    }];

    return constraints;
}

// AutoresizingConstraints, regular constraints active and inactive.
- (CPArray)_constraintsExcludingContentSizeConstraints
{
    var constraints = [self constraints];

    return [constraints filteredArrayUsingBlock:function(aConstraint, idx, stop)
           {
                return ([aConstraint _constraintType] !== @"SizeConstraint");
           }];
}

/*!
Adds a constraint on the layout of the receiving view or its subviews.

- (void)addConstraint:(CPLayoutConstraint)aConstraint

@param aConstraint The constraint to be added to the view. The constraint may only reference the view itself or its subviews.

@discussion The constraint must involve only views that are within scope of the receiving view. Specifically, any views involved must be either the receiving view itself, or a subview of the receiving view. Constraints that are added to a view are said to be held by that view. The coordinate system used when evaluating the constraint is the coordinate system of the view that holds the constraint.
*/
- (void)addConstraint:(CPLayoutConstraint)aConstraint
{
    [self addConstraints:@[aConstraint]];
}

/*!
Adds multiple constraints on the layout of the receiving view or its subviews.

- (void)addConstraints:(CPArray)constraints

@param An array of constraints to be added to the view. All constraints may only reference the view itself or its subviews.

@discussion All constraints must involve only views that are within scope of the receiving view. Specifically, any views involved must be either the receiving view itself, or a subview of the receiving view. Constraints that are added to a view are said to be held by that view. The coordinate system used when evaluating each constraint is the coordinate system of the view that holds the constraint.
*/
- (void)addConstraints:(CPArray)constraints
{
    // We don't want to layout anything, and especially not the window until we finish this.
    [_CPDisplayServer lock];

    var engine = [self _layoutEngine];

    var constraintsIndexes = [CPIndexSet indexSet],
        contentSizeIndexes = [CPIndexSet indexSet];

    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        if ([aConstraint isActive])
            return;

        [aConstraint _setContainer:self];
        [aConstraint resolveConstant];

        var constraintFlags = [aConstraint constraintFlags];

        [self _setHasConstraintBasedLayoutSubviews];

        if (constraintFlags & 8)
            [[aConstraint firstItem] _setNeedsConstraintBasedLayout];

        if (constraintFlags & 64)
            [[aConstraint secondItem] _setNeedsConstraintBasedLayout];

        if ([engine addConstraint:aConstraint])
        {
            [constraintsIndexes addIndex:idx];
            [aConstraint _setActive:YES];

            if ([aConstraint _constraintType] == "SizeConstraint")
                [contentSizeIndexes addIndex:idx];
        }
    }];

    if ([constraintsIndexes count] || [contentSizeIndexes count])
    {
        [self willChangeValueForKey:@"constraints"];
        [_constraintsArray addObjectsFromArray:[constraints objectsAtIndexes:constraintsIndexes]];
        [_contentSizeConstraints addObjectsFromArray:[constraints objectsAtIndexes:contentSizeIndexes]];
        [self didChangeValueForKey:@"constraints"];
    }

    [_CPDisplayServer unlock];
}

- (void)engine:(CPLayoutConstraintEngine)anEngine constraintDidChangeInContainer:(id)aContainer
{
    var superitem = [aContainer _superitem],
        v = superitem || self;

    [v _informContainerThatSubviewsNeedSolvingInEngine];
}

/*!
Removes the specified constraint from the view.

- (void)removeConstraint:(CPLayoutConstraint)aConstraint

@param aConstraint The constraint to remove. Removing a constraint not held by the view has no effect.
*/
- (void)removeConstraint:(CPLayoutConstraint)aConstraint
{
    [self removeConstraints:@[aConstraint]];
}

/*!
Removes the specified constraints from the view.

- (void)removeConstraints:(CPArray)constraints

@param constraints The constraints to remove.
*/
- (void)removeConstraints:(CPArray)constraints
{
    var engine = [self _layoutEngine],
        constraintsIndexes = [CPIndexSet indexSet],
        contentSizeIndexes = [CPIndexSet indexSet];

    [_constraintsArray enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        if (![aConstraint isActive] || [constraints indexOfObjectIdenticalTo:aConstraint] !== CPNotFound)
        {
            if ([engine removeConstraint:aConstraint])
            {
                [constraintsIndexes addIndex:idx];
                [aConstraint _setActive:NO];

                if ([aConstraint _constraintType] == "SizeConstraint")
                    [contentSizeIndexes addIndex:[_contentSizeConstraints indexOfObject:aConstraint]];
            }
        }
    }];

    [self willChangeValueForKey:@"constraints"];
    [_constraintsArray removeObjectsAtIndexes:constraintsIndexes];
    [_contentSizeConstraints removeObjectsAtIndexes:contentSizeIndexes];
    [self didChangeValueForKey:@"constraints"];
}

- (void)_updateConstraint:(id)aConstraint usingBlock:(Function)aFunction
{
    var engine = [self _layoutEngine];

    [engine removeConstraint:aConstraint];
    [aConstraint _resetEngineConstraints];
    aFunction();
    [engine addConstraint:aConstraint];
}

/*!
A Boolean value indicating whether the view’s autoresizing mask is translated into constraints for the constraint-based layout system.

- (void)setTranslatesAutoresizingMaskIntoConstraints:(BOOL)shouldTranslate

@discussion When this property is set to YES, the view’s superview looks at the view’s autoresizing mask, produces constraints that implement it, and adds those constraints to itself (the superview). If your view has flexible constraints that require dynamic adjustment, set this property to NO and apply the constraints yourself.
*/
- (void)setTranslatesAutoresizingMaskIntoConstraints:(BOOL)shouldTranslate
{
    if (shouldTranslate !== _translatesAutoresizingMaskIntoConstraints)
    {
//        CPLog.debug([self debugID] + " " +  _cmd);
        _translatesAutoresizingMaskIntoConstraints = shouldTranslate;
        // TODO: If we switch from YES to NO after a layout, should we remove the autoresizing constraints ?.
        [self setNeedsUpdateConstraints:YES];
    }
}

- (void)_informContainerThatSubviewsNeedSolvingInEngine
{
    // FIXME: RECURSIVE, add a guard.
//CPLog.debug([self debugID] + " " +  _cmd);
    [self _setSubviewsNeedSolvingInEngine];

    if (_superview)
        [_superview _informContainerThatSubviewsNeedSolvingInEngine];
}

- (BOOL)_setSubviewsNeedSolvingInEngine
{
    if (_subviewsNeedSolvingInEngine == NO)
    {
        //CPLog.debug([self debugID] + " " +  _cmd);
        _subviewsNeedSolvingInEngine = YES;
        return YES;
    }

    return NO;
}

/*!
Updates the constraints for the receiving view and its subviews.

- (void)setNeedsUpdateConstraints:(BOOL)needsUpdate

@param needsUpdate A Boolean value indicating whether the view’s constraints need to be updated.

@discussion When a property of your view changes in a way that would impact constraints, set the value of this property to YES to indicate that the constraints need to be updated at some point in the future. The next time the layout process happens, the constraint-based layout system uses the value of this property to determine whether it needs to call updateConstraints on the view.
*/
- (void)setNeedsUpdateConstraints:(BOOL)needsUpdate
{
    if (needsUpdate !== _needsUpdateConstraints)
    {
//CPLog.debug([self debugID] + " " +  _cmd + " " + flag);
        _needsUpdateConstraints = needsUpdate;

        if (needsUpdate)
            [_window _setSubviewsNeedUpdateConstraints];
        // _window may be nil. In this case, the window will be notified in _setWindow:
    }
}

/*!
Updates the constraints for the receiving view and its subviews.

- (void)updateConstraintsForSubtreeIfNeeded

@discussion Whenever a new layout pass is triggered for a view, the system invokes this method to ensure that any constraints for the view and its subviews are updated with information from the current view hierarchy and its constraints. This method is called automatically by the system, but may be invoked manually if you need to examine the most up to date constraints.

@note Subclasses should not override this method.
*/
- (BOOL)updateConstraintsForSubtreeIfNeeded
{
//CPLog.debug([self debugID] + " " +  _cmd);
    var result = _needsUpdateConstraints;

    if (![[self class] refusesConstraintBasedLayout])
    {
        [[self subviews] enumerateObjectsUsingBlock:function(aSubview, idx, stop)
        {
            //CPLog.debug([aSubview debugID] + " _subviewsAreConstraintBasedLayout=" + [aSubview _subviewsAreConstraintBasedLayout]);

            result |= [aSubview updateConstraintsForSubtreeIfNeeded];
        }];
    }

    [self _updateConstraintsIfNeeded];

    return result;
}

- (void)_updateConstraintsIfNeeded
{
//CPLog.debug([self debugID] + " " +  _cmd);
    if (_needsUpdateConstraints)
    {
        _needsUpdateConstraints = NO;
        [self updateConstraints];
    }
    //CPLog.debug([self identifier] + ": no need to update constraints");
}

/*!
Update constraints for the view.

- (void)updateConstraints

@discussion Custom views that set up constraints themselves should do so by overriding this method. When your custom view notes that a change has been made to the view that invalidates one of its constraints, it should immediately remove that constraint, and update the needsUpdateConstraints property to note that constraints need to be updated. Before layout is performed, your implementation of updateConstraints will be invoked, allowing you to verify that all necessary constraints for your content are in place at a time when your custom view’s properties are not changing.

@note You may not invalidate any constraints as part of your constraint update phase. You also may not invoke a layout or drawing phase as part of constraint updating.

@note You must call [super updateConstraints] at the end of your implementation.
*/
- (void)updateConstraints
{
    var translate = [self translatesAutoresizingMaskIntoConstraints];

    if (translate)
        return [self _updateAutoresizingConstraints];
    else
        return [self _updateContentSizeConstraints];
}

- (BOOL)_updateAutoresizingConstraints
{
    if ([self superview] == nil)
    {
#if (DEBUG)
        CPLog.debug("Autoresizing Constraints could not be added to the engine because " + [self debugID] + " does not have a superview. Aborting.");
#endif
        return;
    }

    var autoresizingConstraints = [self _autoresizingConstraints];

    if (autoresizingConstraints == nil)
    {
        var constraints = [self _constraintsEquivalentToAutoresizingMask];
        // ! AutoresizingConstraints are NOT added to the _constraintArray
        if ([[self _layoutEngine] addConstraints:constraints])
        {
            [self _setAutoresizingConstraints:constraints];

            [[self superview] _setHasConstraintBasedLayoutSubviews];
            [self _setNeedsConstraintBasedLayout];

            [constraints makeObjectsPerformSelector:@selector(_setActive:) withObject:YES];

            return YES;
        }
        //CPLog.debug([self identifier] + _cmd + [_autoresizingConstraints description]);
    }

    return NO;
}

- (BOOL)_updateContentSizeConstraints
{
    var newContentSizeConstraints = [self _generateContentSizeConstraints],
        oldContentSizeConstraints = [self _contentSizeConstraints],
        oldWidth  = nil,
        oldHeight = nil,
        newWidth  = nil,
        newHeight = nil,
        result = NO;

    [self _extractContentSizeConstraints:oldContentSizeConstraints width:@ref(oldWidth) height:@ref(oldHeight)];
    [self _extractContentSizeConstraints:newContentSizeConstraints width:@ref(newWidth) height:@ref(newHeight)];

    result |= [self _updateContentSizeConstraint:oldWidth toConstraint:newWidth];
    result |= [self _updateContentSizeConstraint:oldHeight toConstraint:newHeight];

    return result;
}

- (BOOL)_updateContentSizeConstraint:(CPContentSizeLayoutConstraint)original toConstraint:(CPContentSizeLayoutConstraint)destination
{
    if ((original == nil && destination == nil) || [original isEqual:destination])
        return NO;

    if (original !== nil && destination !== nil && ![original isActive])
    {
        [original _setConstant:[destination constant]];
        return NO;
    }

    var result = NO;

    if (original !== nil)
        result |= [self removeConstraint:original];

    if (destination !== nil)
        result |= [self addConstraint:destination];

    return result;
}

- (void)_extractContentSizeConstraints:(CPArray)constraints width:(@ref)widthRef height:(@ref)heightRef
{
    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        var orientation = [aConstraint orientation];

        var widthOrHeightRef = (orientation == CPLayoutConstraintOrientationHorizontal) ? widthRef : heightRef;

        widthOrHeightRef(aConstraint);
    }];
}

- (CPArray)_constraintsEquivalentToAutoresizingMask
{
    var superview = [self superview],
        bounds = [superview bounds],
        frame = [self frame],
        mask = [self autoresizingMask];

    return [CPAutoresizingMaskLayoutConstraint constraintsWithAutoresizingMask:mask subitem:self frame:frame superitem:superview bounds:bounds];
}

/*!
    @warning Not Implemented
*/
- (BOOL)hasAmbiguousLayout
{
}

/*!
Perform layout in concert with the constraint-based layout system.

- (void)layout

@discussion Override this method if your custom view needs to perform custom layout not expressible using the constraint-based layout system. In this case you are responsible for calling setNeedsLayout: when something that impacts your custom layout changes.

@note You may not invalidate any constraints as part of your layout phase, nor invalidate the layout of your superview or views outside of your view hierarchy. You also may not invoke a drawing pass as part of layout.

@note You must call [super layout] as part of your implementation.
*/

- (void)layout
{
    _needsLayout = NO;

    if (_viewClassFlags & CPViewHasCustomViewWillLayout)
        [self viewWillLayout];

    if (_viewClassFlags & CPViewHasCustomLayoutSubviews || _viewHasConstraintBasedSubviews)
        [self layoutSubviews];

    [self viewDidLayout];
}

/*!
Updates the layout of the receiving view and its subviews based on the current views and constraints.

- (void)layoutSubtreeIfNeeded

@discussion Before displaying a view that uses constraints-based layout the system invokes this method to ensure that the layout of the view and its subviews is up to date. This method updates the layout if needed, first invoking updateConstraintsForSubtreeIfNeeded to ensure that all constraints are up to date. This method is called automatically by the system, but may be invoked manually if you need to examine the most up to date layout.

@note Subclasses should not override this method.
*/
- (void)layoutSubtreeIfNeeded
{
    // If the view has no window, this will lazilly create an engine on the top level view.
    var engine = [self _layoutEngine];

    if ([self _hasLocalEngine] && _translatesAutoresizingMaskIntoConstraints && !_topLevelViewExtraConstraintsAdded)
    {
        var frame = [self frame],
            left = [CPAutoresizingMaskLayoutConstraint constraintWithItem:self attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:CGRectGetMinX(frame)],
            top = [CPAutoresizingMaskLayoutConstraint constraintWithItem:self attribute:CPLayoutAttributeTop relatedBy:CPLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:CGRectGetMinY(frame)],
            width = [CPAutoresizingMaskLayoutConstraint constraintWithItem:self attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:CGRectGetWidth(frame)],
            height = [CPAutoresizingMaskLayoutConstraint constraintWithItem:self attribute:CPLayoutAttributeHeight relatedBy:CPLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:CGRectGetHeight(frame)];

        var constraints = @[left, top, width, height];
        [constraints makeObjectsPerformSelector:@selector(_setContainer:) withObject:self];
        [engine addConstraints:constraints];
        _topLevelViewExtraConstraintsAdded = YES;
    }

    // Todo: Solve only if needed
    [self updateConstraintsForSubtreeIfNeeded];
    [engine solve];

    if (_superview)
        [self layout];
    else
    // -layout operates on subviews. If we are the top level view, just update directly the frame.
        [self _updateSubtreeGeometryIfNeeded];
}

- (void)layoutSubtreeAtWindowLevelIfNeeded
{
    if ([self _updateConstraintsAtWindowLevelIfNeeded] || _subviewsNeedSolvingInEngine)
        [[self _layoutEngine] solve];

    _subviewsNeedSolvingInEngine = NO;
}

- (BOOL)_updateConstraintsAtWindowLevelIfNeeded
{
    if (_window)
        return [_window updateConstraintsIfNeeded];
    else
        return [self updateConstraintsForSubtreeIfNeeded];
}

- (void)_engineDidChangeVariableOfType:(int)axisOrDimension
{
    _geometryDirtyMask |= axisOrDimension;
//CPLog.debug([self debugID] + " " + _cmd + " mask="+_geometryDirtyMask);
    [_superview setNeedsLayout];
}

- (void)_updateGeometryDirtyMask:(int)aMask
{
    _geometryDirtyMask |= aMask;
}

- (void)_updateGeometryIfNeeded
{
//CPLog.debug([self debugID] + " " + _cmd);
    if (_geometryDirtyMask !== 0)
    {
        [self _updateGeometry];
        _geometryDirtyMask = 0;
    }

    _subviewsNeedSolvingInEngine = NO;
}

// Variable uniqueness is done in the layout engine.
- (Variable)_variableMinX
{
    if (!_variableMinX)
        _variableMinX = [[self leftAnchor] variable];

    return _variableMinX;
}

- (Variable)_variableMinY
{
    if (!_variableMinY)
        _variableMinY = [[self topAnchor] variable];

    return _variableMinY;
}

- (Variable)_variableWidth
{
    if (!_variableWidth)
        _variableWidth = [[self widthAnchor] variable];

    return _variableWidth;
}

- (Variable)_variableHeight
{
    if (!_variableHeight)
        _variableHeight = [[self heightAnchor] variable];

    return _variableHeight;
}

- (void)_updateGeometry
{
    _isSettingFrameFromEngine = YES;
//CPLog.debug([self debugID] + " " + _cmd + " " + [[self leftAnchor] valueInEngine:nil] + " " + [[self topAnchor] valueInEngine:nil]);
    if (_geometryDirtyMask & 2)
        [self setFrameOrigin:CGPointMake([self _variableMinX].valueOf(), [self _variableMinY].valueOf())];

    if (_geometryDirtyMask & 4)
        [self setFrameSize:CGSizeMake([self _variableWidth].valueOf(), [self _variableHeight].valueOf())];

    _isSettingFrameFromEngine = NO;
}

- (void)_updateSubtreeGeometryIfNeeded
{
    [_subviews enumerateObjectsUsingBlock:function(view, idx, stop)
    {
        [view _updateSubtreeGeometryIfNeeded];
    }];

    [self _updateGeometryIfNeeded];
}

// CPLayoutAnchor Support
- (id)leftAnchor
{
    if (!_leftAnchor)
        _leftAnchor = [CPLayoutXAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeLeft];

    return _leftAnchor;
}

- (id)rightAnchor
{
    if (!_rightAnchor)
    {
        _rightAnchor = [CPCompositeLayoutXAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeRight];
#if !(DEBUG)
        [_rightAnchor _setName:@"trailing"];
#endif
    }

    return _rightAnchor;
}

- (id)topAnchor
{
    if (!_topAnchor)
        _topAnchor = [CPLayoutYAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeTop];

    return _topAnchor;
}

- (id)bottomAnchor
{
    if (!_bottomAnchor)
    {
        _bottomAnchor = [CPCompositeLayoutYAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeBottom];
#if !(DEBUG)
        [_bottomAnchor _setName:@"bottom"];
#endif
    }

    return _bottomAnchor;
}

- (id)firstBaselineAnchor
{
    if (!_firstBaselineAnchor)
        _firstBaselineAnchor = [CPCompositeLayoutYAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeFirstBaseline];

    return _firstBaselineAnchor;
}

- (id)lastBaselineAnchor
{
    if (!_lastBaselineAnchor)
        _lastBaselineAnchor = [CPCompositeLayoutYAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeLastBaseline];

    return _lastBaselineAnchor;
}

- (id)baselineAnchor
{
    return [self lastBaselineAnchor];
}

- (id)leadingAnchor
{
    return [self leftAnchor];
}

- (id)trailingAnchor
{
    return [self rightAnchor];
}

- (id)widthAnchor
{
    if (!_widthAnchor)
        _widthAnchor = [CPLayoutDimension anchorWithItem:self attribute:CPLayoutAttributeWidth];

    return _widthAnchor;
}

- (id)heightAnchor
{
    if (!_heightAnchor)
        _heightAnchor = [CPLayoutDimension anchorWithItem:self attribute:CPLayoutAttributeHeight];

    return _heightAnchor;
}

- (id)centerXAnchor
{
    if (!_centerXAnchor)
    {
        _centerXAnchor = [CPCompositeLayoutXAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeCenterX];
#if !(DEBUG)
        [_centerXAnchor _setName:@"centerX"];
#endif
    }

    return _centerXAnchor;
}

- (id)centerYAnchor
{
    if (!_centerYAnchor)
    {
        _centerYAnchor = [CPCompositeLayoutYAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeCenterY];
#if !(DEBUG)
        [_centerYAnchor _setName:@"centerY"];
#endif
    }

    return _centerYAnchor;
}

@end

@implementation CPLayoutConstraint (CPView)

- (void)_replaceCustomViewsIfNeeded
{
    [_firstAnchor _replaceCustomViewsIfNeeded];
    [_secondAnchor _replaceCustomViewsIfNeeded];

    if ([_container isKindOfClass:[_CPCibCustomView class]])
        _container = [_container replacementView];
}

@end

@implementation CPView (CPLayoutItemProtocol)

- (CPLayoutAnchor)layoutAnchorForAttribute:(CPLayoutAttribute)anAttribute
{
    return _CPLayoutItemAnchorForAttribute(self, anAttribute);
}

- (id)_ancestorSharedWithItem:(id)anItem
{
    return _CPLayoutItemSharedAncestor(self, anItem);
}

- (id)_superitem
{
    return [self superview];
}

@end

@implementation CPArray (CPView)

- (CPArray)filteredArrayUsingBlock:(Function)aFunction
{
    var result = @[];

    [self enumerateObjectsUsingBlock:function(obj, idx, stop)
    {
        if (aFunction(obj, idx) == YES)
        {
            [result addObject:obj];
        }
    }];

    return result;
}

@end

var _FrameDidExplicitChangeInConstraintBasedLayout = function(view, autoResizingConstraints, updateOrigin, updateSize)
{
    var mask = (updateOrigin * 2) | (updateSize * 4);
    [view _updateGeometryDirtyMask:mask];

    if (autoResizingConstraints !== nil)
    {
        // regenerate the constraints with the new frame
        // TODO: just update the constants in autoResizingConstraints
        [view _setAutoresizingConstraints:nil];

        var engine = [view _layoutEngineIfExists];

        if (engine)
        {
            [engine removeConstraints:autoResizingConstraints];
            [view _updateAutoresizingConstraints];
        }
    }
};

function _CPLayoutItemAnchorForAttribute(anItem, anAttribute)
{
    switch (anAttribute)
    {
        case CPLayoutAttributeLeading       :
        case CPLayoutAttributeLeft          : return [anItem leadingAnchor];
        break;
        case CPLayoutAttributeTrailing      :
        case CPLayoutAttributeRight         : return [anItem trailingAnchor];
        break;
        case CPLayoutAttributeTop           : return [anItem topAnchor];
        break;
        case CPLayoutAttributeBottom        : return [anItem bottomAnchor];
        break;
        case CPLayoutAttributeLastBaseline  : return [anItem lastBaselineAnchor];
        break;
        case CPLayoutAttributeBaseline      :
        case CPLayoutAttributeFirstBaseline : return [anItem firstBaselineAnchor];
        break;
        case CPLayoutAttributeWidth         : return [anItem widthAnchor];
        break;
        case CPLayoutAttributeHeight        : return [anItem heightAnchor];
        break;
        case CPLayoutAttributeCenterX       : return [anItem centerXAnchor];
        break;
        case CPLayoutAttributeCenterY       : return [anItem centerYAnchor];
        break;
        default                             : [CPException raise:CPInvalidArgumentException format:@"Unknown attribute %@", anAttribute];
        break;
    }
}

function _CPLayoutItemSharedAncestor(anItem, otherItem)
{
    if (anItem == otherItem)                  // Are they the same view?
        return anItem;

    if (_CPLayoutItemIsDescendantOf(anItem, otherItem))    // Is self a descendant of view?
        return otherItem;

    if (_CPLayoutItemIsDescendantOf(otherItem, anItem))    // Is view a descendant of self?
        return anItem;

    // If neither are descendants of each other and either does not have a
    // superview then they cannot have a common ancestor

    if (![anItem _superitem] || ![otherItem _superitem])
        return nil;

    // Find the common ancestor of superviews
    return _CPLayoutItemSharedAncestor([anItem _superitem], [otherItem _superitem]);
};

function _CPLayoutItemIsDescendantOf(anItem, otherItem)
{
    var item = anItem;

    do
    {
        if (item == otherItem)
            return YES;
    } while(item = [item _superitem])

    return NO;
};

var SetSizeValue = function(size, value, orientation)
{
    switch (orientation)
    {
        case 0 : size.width = value;
        break;
        case 1 : size.height = value;
        break;
    }
};

var _CPLayoutConstraintNeedArchivingBlock = function(cst, idx)
{
    return [cst shouldBeArchived];
};

var _CPViewFullScreenModeStateMake = function(aView)
{
    var superview = aView._superview;

    return { autoresizingMask:aView._autoresizingMask, frame:CGRectMakeCopy(aView._frame), index:(superview ? [superview._subviews indexOfObjectIdenticalTo:aView] : 0), superview:superview };
};

var _CPViewGetTransform = function(/*CPView*/ fromView, /*CPView */ toView)
{
    var transform = CGAffineTransformMakeIdentity(),
        sameWindow = YES,
        fromWindow = nil,
        toWindow = nil;

    if (fromView)
    {
        var view = fromView;

        // FIXME: This doesn't handle the case when the outside views are equal.
        // If we have a fromView, "climb up" the view tree until
        // we hit the root node or we hit the toLayer.
        while (view && view != toView)
        {
            var frame = view._frame;

            if (view._isScaled)
            {
                var affineZoom = CGAffineTransformMakeScale(view._scaleSize.width, view._scaleSize.height);
                CGAffineTransformConcatTo(transform, affineZoom, transform);
            }

            transform.tx += CGRectGetMinX(frame);
            transform.ty += CGRectGetMinY(frame);

            if (view._boundsTransform)
            {
                var inverseBoundsTransform = CGAffineTransformMakeCopy(view._boundsTransform);

                if (view._isScaled)
                {
                    var affineZoom = CGAffineTransformMakeScale(view._scaleSize.width, view._scaleSize.height);
                    CGAffineTransformConcatTo(inverseBoundsTransform, affineZoom, inverseBoundsTransform);
                }

                CGAffineTransformConcatTo(transform, inverseBoundsTransform, transform);
            }

            view = view._superview;
        }

        // If we hit toView, then we're done.
        if (view === toView)
        {
            return transform;
        }
        else if (fromView && toView)
        {
            fromWindow = [fromView window];
            toWindow = [toView window];

            if (fromWindow && toWindow && fromWindow !== toWindow)
                sameWindow = NO;
        }
    }

    // FIXME: For now we can do things this way, but eventually we need to do them the "hard" way.
    var view = toView,
        transform2 = CGAffineTransformMakeIdentity();

    while (view && view != fromView)
    {
        var frame = CGRectMakeCopy(view._frame);

        // FIXME : For now we don't care about rotate transform and so on
        if (view._isScaled)
        {
            transform2.a *= 1 / view._scaleSize.width;
            transform2.d *= 1 / view._scaleSize.height;
        }

        transform2.tx += CGRectGetMinX(frame) * transform2.a;
        transform2.ty += CGRectGetMinY(frame) * transform2.d;

        if (view._boundsTransform)
        {
            var inverseBoundsTransform = CGAffineTransformMakeIdentity();
            inverseBoundsTransform.tx -= view._inverseBoundsTransform.tx * transform2.a;
            inverseBoundsTransform.ty -= view._inverseBoundsTransform.ty * transform2.d;

            CGAffineTransformConcatTo(transform2, inverseBoundsTransform, transform2);
        }

        view = view._superview;
    }

    transform2.tx = -transform2.tx;
    transform2.ty = -transform2.ty;

    if (view === fromView)
    {
        // toView is inside of fromView
        return transform2;
    }

    CGAffineTransformConcatTo(transform, transform2, transform);

    return transform;



/*    var views = [],
        view = toView;

    while (view)
    {
        views.push(view);
        view = view._superview;
    }

    var index = views.length;

    while (index--)
    {
        var frame = views[index]._frame;

        transform.tx -= CGRectGetMinX(frame);
        transform.ty -= CGRectGetMinY(frame);
    }*/

    return transform;
};
