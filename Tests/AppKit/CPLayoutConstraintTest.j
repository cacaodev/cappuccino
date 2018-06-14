@import <AppKit/AppKit.j>
@import <AppKit/CPLayoutConstraintEngine.j>
@import <Foundation/Foundation.j>

#define XCTAssertEqual(a, b) [self assert:b equals:a]
#define XCTAssertTrue(a) [self assertTrue:a]
#define XCTAssertFalse(a) [self assertFalse:a]
#define XCTAssertApprox(a, b, c) [self assertTrue:(ABS(a - b) <= c) message:"Expected " + b + " but was " + a]

[CPApplication sharedApplication];

@implementation CustomIntrinsicView : CPView

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(50, 50);
}

@end

@implementation CPLayoutConstraintTest : OJTestCase
{
    BOOL _didReceiveKVONotification;
    CPView contentView;
}

- (void)setUp
{
    var theWindow = [[ResizingWindow alloc] initWithContentRect:CGRectMake(0, 0, 200, 200) styleMask:CPResizableWindowMask];
    contentView = [theWindow contentView];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];

    [theWindow orderFront:self];

    _didReceiveKVONotification = NO;
}

- (void)testAddConstraint
{
    [contentView addObserver:self forKeyPath:@"constraints" options:CPKeyValueObservingOptionOld | CPKeyValueObservingOptionNew context:@"add"];

    var constraint1 = [CPLayoutConstraint constraintWithItem:contentView attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];
    [contentView addConstraint:constraint1];

    XCTAssertEqual([[contentView constraints] count], 1);

    var constraint2 = [CPLayoutConstraint constraintWithItem:contentView attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    // Add a new constraint object equal to an installed constraint.
    [contentView addConstraint:constraint2];

    XCTAssertEqual([[contentView constraints] count], 2);
    XCTAssertTrue(_didReceiveKVONotification);

    [contentView removeObserver:self forKeyPath:@"constraints"];
}

- (void)testRemoveConstraint
{
    var constraint1 = [CPLayoutConstraint constraintWithItem:contentView attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    var constraint2 = [CPLayoutConstraint constraintWithItem:contentView attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    [contentView addConstraints:[constraint1, constraint2]];

    [contentView addObserver:self forKeyPath:@"constraints" options:CPKeyValueObservingOptionOld | CPKeyValueObservingOptionNew context:@"remove"];

    [contentView removeConstraint:constraint2];

    XCTAssertEqual([[contentView constraints] count], 1);
    XCTAssertTrue(_didReceiveKVONotification);

    [contentView removeObserver:self forKeyPath:@"constraints"];
}

- (void)testTranslatesAutoresizingMaskIntoConstraintsDefaultValue
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    XCTAssertTrue([view translatesAutoresizingMaskIntoConstraints]);
}

- (void)testNeedsUpdateConstraintsWithCustomIntrinsicSize
{
    var view = [[CustomIntrinsicView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    XCTAssertTrue([view needsUpdateConstraints]);
}

- (void)testAddViewInstallsAutoresizingConstraintsOnSuperview
{
    XCTAssertEqual([[contentView constraints] count], 0);

    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [contentView addSubview:view];

    XCTAssertEqual([[contentView constraints] count], 4);
    XCTAssertEqual([[[contentView constraints] firstObject] _constraintType], @"AutoresizingConstraint");
}

- (void)testAddViewInstallsContentSizeConstraints
{
    XCTAssertEqual([[contentView constraints] count], 0);

    var view = [[CustomIntrinsicView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:view];

    [contentView updateConstraintsForSubtreeIfNeeded];

    // Not constraints installed on the superview
    XCTAssertEqual([[contentView constraints] count], 0);

    XCTAssertEqual([[view constraints] count], 2);
    XCTAssertEqual([[[view constraints] firstObject] _constraintType], @"SizeConstraint");
    XCTAssertEqual([[[view constraints] firstObject] constant], 50);
}

- (void)testAddConstraintInDetachedView
{
    var constraintView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
    [constraintView setIdentifier:@"constraintView"];
    [constraintView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[[constraintView leftAnchor] constraintEqualToConstant:10] setActive:YES];
    [[[constraintView topAnchor] constraintEqualToConstant:20] setActive:YES];
    [[[constraintView widthAnchor] constraintEqualToConstant:30] setActive:YES];
    [[[constraintView heightAnchor] constraintEqualToConstant:40] setActive:YES];

    XCTAssertEqual([[constraintView constraints] count], 4);
    // The view has no window but a local engine
    var localEngine = [constraintView _layoutEngineIfExists];
    XCTAssertTrue(localEngine !== nil);

    // Layout the view
    [constraintView layoutSubtreeIfNeeded];

    // The frame have been constrained.
    XCTAssertTrue(CGRectEqualToRect([constraintView frame], CGRectMake(10, 20, 30, 40)));

    // The window does not have any engine yet.
    XCTAssertTrue([contentView _layoutEngineIfExists] == nil);

    // Now we add the view to a window.
    [contentView addSubview:constraintView];

    // Now the view local engine have been promoted to window engine.
    XCTAssertTrue([contentView _layoutEngineIfExists] == localEngine);
    XCTAssertTrue([contentView _layoutEngine] == [constraintView _layoutEngine]);

    //The previous local engine have been nulled.
    XCTAssertTrue([constraintView _localEngineIfExists] == nil);
}

- (void)testMergeLocalEngineIntoWindowEngine
{
    var constraintView = [[CPView alloc] initWithFrame:CGRectMake(10,10,200,200)];
    [constraintView setIdentifier:@"constraintView"];
    [constraintView setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
    [constraintView setTranslatesAutoresizingMaskIntoConstraints:YES];

    [constraintView layoutSubtreeIfNeeded];

    // The view has no window but a local engine
    var localEngine = [constraintView _layoutEngineIfExists];
    XCTAssertTrue(localEngine !== nil);

    // The view have been constrained assuming the Autoresizing Mask is 0.
    XCTAssertTrue(CGRectEqualToRect([constraintView frame], CGRectMake(10, 10, 200, 200)));

    [[contentView window] orderFront:nil];
    // Force layout because we are in the console.
    [[contentView window] setNeedsLayout];
    [[CPRunLoop mainRunLoop] performSelectors];

    var windowEngine = [contentView _layoutEngineIfExists];
    XCTAssertTrue(windowEngine !== nil);

    [contentView addSubview:constraintView];

    XCTAssertTrue([contentView _layoutEngineIfExists] !== localEngine);
    XCTAssertTrue([constraintView _localEngineIfExists] == nil);
    XCTAssertTrue([contentView _layoutEngine] == [constraintView _layoutEngine]);

    // Resize the window
    [[constraintView window] setFrame:CGRectMake(0, 0, 400, 400)];
    [[constraintView window] setNeedsLayout];
    [[CPRunLoop mainRunLoop] performSelectors];

    // layout again the view
    [constraintView layoutSubtreeIfNeeded];

    // The frame have been constrained and resized according to its original AutoresizingMask.
    XCTAssertTrue(CGRectEqualToRect([constraintView frame], CGRectMake(10, 10, 400, 400)));
}

- (void)testLayoutSubtreeIfNeededWithoutWindow
{
    var topView = [[CPView alloc] initWithFrame:CGRectMake(30,30,300,300)];
    //[[[topView widthAnchor] constraintEqualToConstant:300] setActive:YES];
    [topView setIdentifier:@"topView"];

    var subView = [[CPView alloc] initWithFrame:CGRectMake(20,20,200,200)];
    [subView setIdentifier:@"subView"];

    var subsubView = [[CPView alloc] initWithFrame:CGRectMake(10,10,100,100)];
    [subsubView setIdentifier:@"subsubView"];

    [subView addSubview:subsubView];
    [topView addSubview:subView];

    [[[subView widthAnchor] constraintGreaterThanOrEqualToConstant:10] setActive:YES];
    [topView layoutSubtreeIfNeeded];

    // there is one layout engine and it is hosted by the top level view.
    XCTAssertTrue([subView _layoutEngine] == [topView _layoutEngineIfExists]);
    XCTAssertTrue([subsubView _layoutEngine] == [topView _layoutEngineIfExists]);

    // The subviews frames have been constrained.
    XCTAssertTrue(CGRectEqualToRect([topView frame], CGRectMake(30, 30, 300, 300)));
    XCTAssertTrue(CGRectEqualToRect([subView frame], CGRectMake(20, 20, 200, 200)));
    XCTAssertTrue(CGRectEqualToRect([subsubView frame], CGRectMake(10, 10, 100, 100)));
}

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change                        context:(void)context
{
    _didReceiveKVONotification = YES;
}

@end

@implementation ResizingWindow : CPWindow
{
}

- (BOOL)_inLiveResize
{
    return YES;
}

@end
