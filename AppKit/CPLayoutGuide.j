@import "CPLayoutAnchor.j"
@import <Foundation/_CGGeometry.j>

@class CPLayoutConstraint
@class CPLayoutConstraintEngine

@implementation CPLayoutGuide : CPObject
{
    CPView         _owningView     @accessors(property=owningView);
    CPString       _identifier     @accessors(property=identifier);
    CGRect         _frame          @accessors(getter=frame);

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
    CPLayoutAnchor _firstBaselineAnchor;
    CPLayoutAnchor _lastBaselineAnchor;

    BOOL           _shouldBeArchived;
    BOOL           _geometryNeedsUpdate;
}

- (id)init
{
    self = [super init];

    _owningView = nil;
    _identifier = @"";

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
    _firstBaselineAnchor = nil;
    _lastBaselineAnchor = nil;

    _frame = CGRectMakeZero();

    _shouldBeArchived = NO;
    _geometryNeedsUpdate = NO;

    return self;
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
        _rightAnchor = [CPCompositeLayoutXAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeRight];

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
        _bottomAnchor = [CPCompositeLayoutYAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeBottom];

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
        _centerXAnchor = [CPCompositeLayoutXAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeCenterX];

    return _centerXAnchor;
}

- (id)centerYAnchor
{
    if (!_centerYAnchor)
        _centerYAnchor = [CPCompositeLayoutYAxisAnchor anchorWithItem:self attribute:CPLayoutAttributeCenterY];

    return _centerYAnchor;
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

- (void)_engineDidChangeVariableOfType:(int)originOrSize
{
    _geometryNeedsUpdate = YES;
    [_owningView setNeedsLayout];
}

- (CPView)_is_superitem
{
    return _owningView;
}

- (void)_updateGeometryIfNeeded
{
    if (_geometryNeedsUpdate)
    {
        [self _updateGeometry];
        _geometryNeedsUpdate = NO;
    }
}

- (void)_updateGeometry
{
    var engine = [_owningView _layoutEngine];

    [self willChangeValueForKey:@"frame"];

    _frame = CGRectMake([_leftAnchor valueInEngine:engine], [_topAnchor valueInEngine:engine], [_widthAnchor valueInEngine:engine], [_heightAnchor valueInEngine:engine]);

    [self didChangeValueForKey:@"frame"];
}

@end
