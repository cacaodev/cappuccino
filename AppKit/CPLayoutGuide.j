@import "CPLayoutAnchor.j"
@import <Foundation/_CGGeometry.j>

@class CPLayoutConstraint
@class CPLayoutConstraintEngine

@implementation CPLayoutGuide : CPObject
{
    CPView         _owningView     @accessors(property=owningView);
    CPString       _identifier     @accessors(property=identifier);
    CGRect         _frame          @accessors(getter=frame);
    
    Variable       _variableMinX;
    Variable       _variableMinY;
    Variable       _variableWidth;
    Variable       _variableHeight;

    CPLayoutAnchor _centerYAnchor;
    CPLayoutAnchor _centerXAnchor;
    CPLayoutAnchor _heightAnchor;
    CPLayoutAnchor _widthAnchor;
    CPLayoutAnchor _bottomAnchor;
    CPLayoutAnchor _topAnchor;
    CPLayoutAnchor _rightAnchor;
    CPLayoutAnchor _leftAnchor;
    CPLayoutAnchor _trailingAnchor;
    CPLayoutAnchor _leadingAnchor;

    BOOL           _shouldBeArchived;
    BOOL           _frameNeedsUpdate;
}

- (id)init
{
    self = [super init];
    
    _owningView = nil;
    _identifier = @"";
    _variableMinX = nil;
    _variableMinY = nil;
    _variableWidth = nil;
    _variableHeight = nil;

    _centerYAnchor = nil;
    _centerXAnchor = nil;
    _heightAnchor = nil;
    _widthAnchor = nil;
    _bottomAnchor = nil;
    _topAnchor = nil;
    _rightAnchor = nil;
    _leftAnchor = nil;
    _trailingAnchor = nil;
    _leadingAnchor = nil;

    _frame = CGRectMakeZero();

    _shouldBeArchived = NO;
    _frameNeedsUpdate = NO;
    
    return self;
}

- (id)topAnchor
{
    if (!_topAnchor)
        _topAnchor = [CPLayoutAnchor layoutAnchorWithItem:self attribute:CPLayoutAttributeTop];

    return _topAnchor;
}

- (id)bottomAnchor
{
    if (!_bottomAnchor)
        _bottomAnchor = [CPLayoutAnchor layoutAnchorWithItem:self attribute:CPLayoutAttributeBottom];

    return _bottomAnchor;
}

- (id)centerYAnchor
{
    if (!_centerYAnchor)
        _centerYAnchor = [CPLayoutAnchor layoutAnchorWithItem:self attribute:CPLayoutAttributeCenterY];

    return _centerYAnchor;
}

- (id)centerXAnchor
{
    if (!_centerXAnchor)
        _centerXAnchor = [CPLayoutAnchor layoutAnchorWithItem:self attribute:CPLayoutAttributeCenterX];

    return _centerXAnchor;
}

- (id)leftAnchor
{
    if (!_leftAnchor)
        _leftAnchor = [CPLayoutAnchor layoutAnchorWithItem:self attribute:CPLayoutAttributeLeft];

    return _leftAnchor;
}

- (id)leadingAnchor
{
    return [self leftAnchor];
}

- (id)rightAnchor
{
    if (!_rightAnchor)
        _rightAnchor = [CPLayoutAnchor layoutAnchorWithItem:self attribute:CPLayoutAttributeRight];

    return _rightAnchor;
}

- (id)trailingAnchor
{
    return [self rightAnchor];
}

- (id)widthAnchor
{
    if (!_widthAnchor)
        _widthAnchor = [CPLayoutAnchor layoutAnchorWithItem:self attribute:CPLayoutAttributeWidth];

    return _widthAnchor;
}

- (id)heightAnchor
{
    if (!_heightAnchor)
        _heightAnchor = [CPLayoutAnchor layoutAnchorWithItem:self attribute:CPLayoutAttributeHeight];

    return _heightAnchor;
}

- (Variable)_variableMinX
{
    if (!_variableMinX)
        _variableMinX = [self newVariableWithName:"minX" value:CGRectGetMinX([self frame])];

    return _variableMinX;
}

- (Variable)_variableMinY
{
    if (!_variableMinY)
        _variableMinY = [self newVariableWithName:"minY" value:CGRectGetMinY([self frame])];

    return _variableMinY;
}

- (Variable)_variableWidth
{
    if (!_variableWidth)
        _variableWidth = [self newVariableWithName:"width" value:CGRectGetWidth([self frame])];

    return _variableWidth;
}

- (Variable)_variableHeight
{
    if (!_variableHeight)
        _variableHeight = [self newVariableWithName:"height" value:CGRectGetHeight([self frame])];

    return _variableHeight;
}

- (Variable)newVariableWithName:(CPString)aName value:(float)aValue
{
    return [[self _layoutEngine] variableWithPrefix:_identifier name:aName value:aValue owner:self];
}

- (CPLayoutConstraintEngine)_layoutEngine
{
    return [_owningView _layoutEngine];
}

- (void)addConstraint:(CPLayoutConstraint)aConstraint
{
    [_owningView addConstraint:aConstraint];
}

- (void)removeConstraint:(CPLayoutConstraint)aConstraint
{
    [_owningView removeConstraint:aConstraint];
}

- (void)_setNeedsConstraintBasedLayout
{
}

- (void)_setHasConstraintBasedLayoutSubviews
{
}

- (CGInset)alignmentRectInsets
{
    return CGInsetMakeZero();
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(CPViewNoInstrinsicMetric, CPViewNoInstrinsicMetric);
}

- (float)baselineOffsetFromBottom
{
    return 0.0;
}

// DEBUG
- (CPString)debugID
{
    return ([self identifier] || [self className]);
}

- (void)valueOfVariable:(Variable)aVariable didChangeInEngine:(CPLayoutConstraintEngine)anEngine
{
    _frameNeedsUpdate = YES;

    [_owningView setNeedsLayout];
}

- (CPView)_is_superitem
{
    return _owningView;
}

- (id)ancestorSharedWithView:(CPView)aView
{
    return [_owningView ancestorSharedWithView:aView];
}

- (BOOL)isDescendantOf:(CPView)aView
{
    var view = _owningView;

    while (view = [view superview])
    {
        if (view == aView)
            return YES;
    }

    return NO;
}

- (void)_updateGeometryIfNeeded
{
    if (_frameNeedsUpdate)
    {
        [self _updateGeometry];
        _frameNeedsUpdate = NO;
    }
}

- (void)_updateGeometry
{
    [self willChangeValueForKey:@"frame"];

    _frame = CGRectMake(_variableMinX.valueOf(), _variableMinY.valueOf(), _variableWidth.valueOf(), _variableHeight.valueOf());
        
    [self didChangeValueForKey:@"frame"];
}

@end

