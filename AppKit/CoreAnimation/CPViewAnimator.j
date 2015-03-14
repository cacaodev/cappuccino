
@import "_CPObjectAnimator.j"
@import "CPView.j"
@import "CPSegmentedControl.j"
@import "_CPImageAndTextView.j"

@class CPAnimationContext

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

- (void)_setTargetValue:(id)aTargetValue withKeyPath:(CPString)aKeyPath fallback:(Function)fallback  completion:(Function)completion
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
        [context _enqueueActionForObject:_target keyPath:aKeyPath targetValue:aTargetValue animationCompletion:completion];
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

var CPVIEW_PROPERTIES_DESCRIPTOR = @{
    "backgroundColor"  : [@{"property":"background", "value":function(sv, val){return [val cssString];}}],
    "alphaValue"       : [@{"property":"opacity"}],
    "frame"            : [@{"property":CPBrowserCSSProperty("transform"), "value":transformFrameToTranslate},
                          @{"property":"width", "value":transformFrameToWidth},
                          @{"property":"height", "value":transformFrameToHeight}],
    "frameOrigin"      : [@{"property":CPBrowserCSSProperty("transform"), "value":transformOrigin}],
    "frameSize"        : [@{"property":"width", "value":transformSizeToWidth},
                          @{"property":"height", "value":transformSizeToHeight}]
};

@implementation CPView (CPAnimatablePropertyContainer)

+ (CPArray)cssPropertiesForKeyPath:(CPString)aKeyPath
{
    return [CPVIEW_PROPERTIES_DESCRIPTOR objectForKey:aKeyPath];
}

- (id)DOMElementForKeyPath:(CPString)aKeyPath
{
    return _DOMElement;
}

- (id)animator
{
    if (!_animator)
        _animator = [[CPViewAnimator alloc] initWithTarget:self];

    return _animator;
}

+ (CAAnimation)defaultAnimationForKey:(CPString)aKey
{
    if ([[self class] cssPropertiesForKeyPath:aKey] !== nil)
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

@implementation CPSegmentedControlAnimator : CPViewAnimator
{
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

- (id)animator
{
    if (!_animator)
        _animator = [[CPSegmentedControlAnimator alloc] initWithTarget:self];

    return _animator;
}

@end

@implementation _CPImageAndTextViewAnimator : CPViewAnimator
{
}

- (void)setTextColor:(CPColor)aColor
{
    [self _setTargetValue:aColor withKeyPath:@"textColor" setter:_cmd];
}

@end

@implementation _CPImageAndTextView (CPAnimatablePropertyContainer)

+ (CPArray)cssPropertiesForKeyPath:(CPString)aKeyPath
{
    if (aKeyPath == @"textColor")
        return @[@{"property":"color", "value":function(s,v){return [v cssString];}}];

    return [super cssPropertiesForKeyPath:aKeyPath];
}

- (id)DOMElementForKeyPath:(CPString)aKeyPath
{
    if (aKeyPath == @"textColor")
        return _DOMElement;

    return nil;
}

- (id)animator
{
    if (!_animator)
        _animator = [[_CPImageAndTextViewAnimator alloc] initWithTarget:self];

    return _animator;
}

@end
