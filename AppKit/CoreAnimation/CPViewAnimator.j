
@import "_CPObjectAnimator.j"
@import "CPView.j"

 @import "CPSegmentedControl.j"
@import "CPTabView.j"
@import "_CPImageAndTextView.j"

@import "_CPObjectAnimator.j"

@class CPAnimationContext
@class CAPropertyAnimation

@implementation CPViewAnimator : _CPObjectAnimator
{
}

- (void)viewWillMoveToSuperview:(CPView)aSuperview
{
    var orderInAnim = [self animationForKey:@"CPAnimationTriggerOrderIn"];

    if (orderInAnim && [orderInAnim isKindOfClass:[CAPropertyAnimation class]])
    {
        [_target setValue:[orderInAnim fromValue] forKeyPath:[orderInAnim keyPath]];
    }

    [_target viewWillMoveToSuperview:aSuperview];
}

- (void)viewDidMoveToSuperview
{
    var orderInAnim = [self animationForKey:@"CPAnimationTriggerOrderIn"];

    if (orderInAnim && [orderInAnim isKindOfClass:[CAPropertyAnimation class]])
    {
        [self _setTargetValue:YES withKeyPath:@"CPAnimationTriggerOrderIn" fallback:nil completion:function()
        {
            [_target setValue:[orderInAnim toValue] forKeyPath:[orderInAnim keyPath]];
        }];
    }
    else
    {
        [_target viewDidMoveToSuperview];
    }
}

- (void)removeFromSuperview
{
    [self _setTargetValue:nil withKeyPath:@"CPAnimationTriggerOrderOut" setter:_cmd];
}

- (void)setHidden:(BOOL)shouldHide
{
    if ([_target isHidden] == shouldHide)
        return;

    if (shouldHide == NO)
        return [_target setHidden:NO];

    [self _setTargetValue:YES withKeyPath:@"CPAnimationTriggerOrderOut" setter:_cmd];
}

- (void)setAlphaValue:(CGPoint)alphaValue
{
    [self _setTargetValue:alphaValue withKeyPath:@"alphaValue" setter:_cmd];
}

- (void)setBackgroundColor:(CPColor)aColor
{
    [self _setTargetValue:aColor withKeyPath:@"backgroundColor" setter:_cmd];
}

- (void)setFrameOrigin:(CGPoint)aFrameOrigin
{
    [self _setTargetValue:aFrameOrigin withKeyPath:@"frameOrigin" setter:_cmd];
}

- (void)setFrame:(CGRect)aFrame
{
    [self _setTargetValue:aFrame withKeyPath:@"frame" setter:_cmd];
}

- (void)setFrameSize:(CGSize)aFrameSize
{
    [self _setTargetValue:aFrameSize withKeyPath:@"frameSize" setter:_cmd];
}

// Convenience method for the common case where the setter has zero or one argument
- (void)_setTargetValue:(id)aTargetValue withKeyPath:(CPString)aKeyPath setter:(SEL)aSelector
{
    var handler = function()
    {
        [_target performSelector:aSelector withObject:aTargetValue];
    };

    [self _setTargetValue:aTargetValue withKeyPath:aKeyPath fallback:handler completion:handler];
}

- (void)_setTargetValue:(id)aTargetValue withKeyPath:(CPString)aKeyPath fallback:(Function)fallback completion:(Function)completion
{
    [self _setTargetValue:aTargetValue withKeyPath:aKeyPath fallback:fallback completion:completion context:nil];
}

- (void)_setTargetValue:(id)aTargetValue withKeyPath:(CPString)aKeyPath fallback:(Function)fallback completion:(Function)completion context:(id)aContext
{
    var animation = [_target animationForKey:aKeyPath],
        context = [CPAnimationContext currentContext];

    if (!animation || ![animation isKindOfClass:[CAAnimation class]] || (![context duration] && ![animation duration]) || ![_CPObjectAnimator supportsCSSAnimations])
    {
        if (fallback)
            fallback();
    }
    else
    {
        [context _enqueueActionForObject:_target keyPath:aKeyPath targetValue:aTargetValue animationCompletion:completion context:aContext];
    }
}

@end

var transformOrigin = function(start, current)
{
    return "translate(" + (current.x - start.x) + "px," + (current.y - start.y) + "px)";
};

var transformFrameToTranslate = function(start, current)
{
    return transformOrigin(start.origin, current.origin);
};

var transformFrameToWidth = function(start, current)
{
    return current.size.width + "px";
};

var transformFrameToHeight = function(start, current)
{
    return current.size.height + "px";
};

var transformSizeToWidth = function(start, current)
{
    return current.width + "px";
};

var transformSizeToHeight = function(start, current)
{
    return current.height + "px";
};

var DEFAULT_CSS_PROPERTIES = nil;

@implementation CPView (CPAnimatablePropertyContainer)

+ (CPDictionary)defaultCSSProperties
{
    if (DEFAULT_CSS_PROPERTIES == nil)
    {
        var transformProperty = CPBrowserCSSProperty("transform");

        DEFAULT_CSS_PROPERTIES =  @{
            "backgroundColor"  : [@{"property":"background", "value":function(sv, val){return [val cssString];}}],
            "alphaValue"       : [@{"property":"opacity"}],
            "frame"            : [@{"property":transformProperty, "value":transformFrameToTranslate},
                                  @{"property":"width", "value":transformFrameToWidth},
                                  @{"property":"height", "value":transformFrameToHeight}],
            "frameOrigin"      : [@{"property":transformProperty, "value":transformOrigin}],
            "frameSize"        : [@{"property":"width", "value":transformSizeToWidth},
                                  @{"property":"height", "value":transformSizeToHeight}]
        };
    }

    return DEFAULT_CSS_PROPERTIES;
}

+ (CPArray)cssPropertiesForKeyPath:(CPString)aKeyPath
{
    return [[self defaultCSSProperties] objectForKey:aKeyPath];
}

+ (Class)animatorClass
{
    var anim_class = CPClassFromString(CPStringFromClass(self) + "Animator");

    if (anim_class)
        return anim_class;

    return [super animatorClass];
}

- (id)animator
{
    if (!_animator)
        _animator = [[[[self class] animatorClass] alloc] initWithTarget:self];

    return _animator;
}

- (id)DOMElementForKeyPath:(CPString)aKeyPath context:(id)aContext
{
    return self._DOMElement;
}

+ (CAAnimation)defaultAnimationForKey:(CPString)aKey
{
    if ([self cssPropertiesForKeyPath:aKey] !== nil)
        return [CAAnimation animation];

    return nil;
}

- (CAAnimation)animationForKey:(CPString)aKey
{
    var animations = [self animations],
        animation = nil;

    if (!animations || !(animation = [animations objectForKey:aKey]))
    {
        animation = [[self class] defaultAnimationForKey:aKey];
    }

    return animation;
}

- (CPDictionary)animations
{
    return _animationsDictionary;
}

- (void)setAnimations:(CPDictionary)animationsDict
{
    _animationsDictionary = [animationsDict copy];
}

@end

@implementation CPButtonAnimator : CPViewAnimator
{
}

- (void)setTextColor:(CPColor)aColor
{
    var contentView = [_target ephemeralSubviewNamed:@"content-view"];

    [[contentView animator] _setTargetValue:aColor withKeyPath:@"textColor" fallback:nil completion:function()
    {
        [_target setTextColor:aColor];
        [[CPRunLoop currentRunLoop] performSelectors];
    }];
}

- (void)setFont:(CPFont)aFont
{
    var contentView = [_target ephemeralSubviewNamed:@"content-view"];

    [[contentView animator] _setTargetValue:aFont withKeyPath:@"font" fallback:nil completion:function()
    {
        [_target setFont:aFont];
        [[CPRunLoop currentRunLoop] performSelectors];
    }];
}

- (void)setFontSize:(CPInteger)aFontSize
{
    var contentView = [_target ephemeralSubviewNamed:@"content-view"],
        font = [[_target font] fontOfSize:aFontSize];

    [[contentView animator] _setTargetValue:aFontSize withKeyPath:@"fontSize" fallback:nil completion:function()
    {
        [_target setFont:font];
        [[CPRunLoop currentRunLoop] performSelectors];
    }];
}

@end

@implementation CPSegmentedControlAnimator : CPViewAnimator
{
}

- (void)setSelectedSegment:(unsigned)aSegment
{
    // setSelected:forSegment throws the exception for us (if necessary)
    if ([_target selectedSegment] == aSegment)
        return;

    if (aSegment == -1)
    {
        var count = [_target segmentCount];

        while (count--)
            [self setSelected:NO forSegment:count];

        [_target _setSelectedSegment:-1];
    }
    else
        [self setSelected:YES forSegment:aSegment];
}

- (void)setSelected:(BOOL)selected forSegment:(CPInteger)aSegment
{
    [self _setSelected:!selected forSegment:[_target selectedSegment] withCompletion:NO];
    [self _setSelected:selected forSegment:aSegment withCompletion:YES];
}

- (void)_setSelected:(BOOL)selected forSegment:(CPInteger)aSegment withCompletion:(BOOL)isLast
{
    if (aSegment == -1)
        return;

    var completion = nil;
    var state = selected ? CPThemeStateSelected : CPThemeStateNormal;

    if (aSegment == 0)
    {
        var leftColor = [_target valueForThemeAttribute:@"left-segment-bezel-color" inState:state];
        var leftBezel = [_target ephemeralSubviewNamed:@"left-segment-bezel"];

        [[leftBezel animator] _setTargetValue:leftColor withKeyPath:@"backgroundColor" fallback:nil completion:completion];
    }

    if (aSegment == [self segmentCount] - 1)
    {
        var rightColor = [_target valueForThemeAttribute:@"right-segment-bezel-color" inState:state];
        var rightBezel = [_target ephemeralSubviewNamed:@"right-segment-bezel"];

        [[rightBezel animator] _setTargetValue:rightColor withKeyPath:@"backgroundColor" fallback:nil completion:completion];
    }

    var centerColor = [_target valueForThemeAttribute:@"center-segment-bezel-color" inState:state];
    var centerBezel = [_target ephemeralSubviewNamed:@"segment-bezel-" + aSegment];

    if (isLast)
    {
        completion = function()
        {
            [_target setSelected:YES forSegment:aSegment];
            [[CPRunLoop currentRunLoop] performSelectors];
        };
    }

    [[centerBezel animator] _setTargetValue:centerColor withKeyPath:@"backgroundColor" fallback:nil completion:completion];

    var contentView = [_target ephemeralSubviewNamed:@"segment-content-" + aSegment],
        color = [_target valueForThemeAttribute:@"text-color" inState:state];

    [[contentView animator] setTextColor:color];
}

@end

@implementation CPSegmentedControl (CPAnimatablePropertyContainer)

@end

@implementation CPTabViewAnimator : CPViewAnimator
{
}

- (BOOL)selectTabViewItemAtIndex:(CPUInteger)anIndex
{
    var aTabViewItem = [self tabViewItemAtIndex:anIndex];

    if (aTabViewItem == [self selectedTabViewItem])
        return NO;

    if (![self _sendDelegateShouldSelectTabViewItem:aTabViewItem])
        return NO;

    [self _sendDelegateWillSelectTabViewItem:aTabViewItem];

    [[[_target _tabs] animator] setSelectedSegment:anIndex];

    [self _setSelectedTabViewItem:aTabViewItem];

    [self _displayItemView:[[aTabViewItem view] animator]];

    [self _sendDelegateDidSelectTabViewItem:aTabViewItem];

    return YES;
}

@end

@implementation CPTabView (CPAnimatablePropertyContainer)

@end

@implementation _CPImageAndTextViewAnimator : CPViewAnimator
{
}

- (void)setTextColor:(CPColor)aColor
{
    [self _setTargetValue:aColor withKeyPath:@"textColor" fallback:nil completion:function()
    {
        [_target setTextColor:aColor];
        [[CPRunLoop currentRunLoop] performSelectors];
    }];
}

- (void)setFont:(CPFont)aFont
{
    [self _setTargetValue:aFont withKeyPath:@"font" fallback:nil completion:function()
    {
        [_target setFont:aFont];
        [[CPRunLoop currentRunLoop] performSelectors];
    }];
}

- (void)addItem:(Object)anImageItem
{
    anImageItem.element.style.opacity = 0;
    [_target addItem:anImageItem];
    var container = [_target _imageContainer];
    container.setAnimating(true);
    [self _setTargetValue:1 withKeyPath:@"imageOpacity" fallback:nil completion:function ()
    {
        container.setAnimating(false);
    } context:anImageItem.element];
}

- (void)removeItem:(Object)anImageItem atIndex:(CPInteger)anIndex
{
    var container = [_target _imageContainer];
    container.setAnimating(true);

    [self _setTargetValue:0 withKeyPath:@"imageOpacity" fallback:nil completion:function()
    {
        [_target removeItem:anImageItem atIndex:anIndex];
        container.setAnimating(false);
    } context:anImageItem.element];
}

- (void)hideItem:(Object)anImageItem
{
    var container = [_target _imageContainer];
    container.setAnimating(true);

    [self _setTargetValue:0 withKeyPath:@"imageOpacity" fallback:nil completion:function()
    {
        [_target hideItem:anImageItem];
        container.setAnimating(false);
    } context:anImageItem.element];
}

@end

@implementation _CPImageAndTextView (CPAnimatablePropertyContainer)

+ (CPArray)cssPropertiesForKeyPath:(CPString)aKeyPath
{
    if (aKeyPath == @"textColor")
        return @[@{"property":"color", "value":function(s,v){return [v cssString];}}];
    else if (aKeyPath == @"font")
        return @[@{"property":"font", "value":function(s,v){return [v cssString];}}];
    else if (aKeyPath == @"fontSize")
        return @[@{"property":"font-size", "value":function(s,v){return v + "px";}}];
    else if (aKeyPath == @"imageOpacity")
        return @[@{"property":"opacity"}];

    return [super cssPropertiesForKeyPath:aKeyPath];
}

- (Object)DOMElementForKeyPath:(CPString)aKeyPath context:(id)aContext
{
    if (aKeyPath == @"textColor" || aKeyPath == @"font" || aKeyPath == @"fontSize")
        return self._DOMTextElement;
    else if (aKeyPath == @"imageOpacity")
        return aContext;

    return [super DOMElementForKeyPath:aKeyPath context:aContext];
}

- (float)fontSize
{
    return [[self font] size];
}

@end

@implementation CPFont (CPViewAnimator)

- (CPFont)fontOfSize:(CPInteger)aSize
{
    return [CPFont _fontWithName:_name size:aSize bold:_isBold italic:_isItalic];
}

@end
