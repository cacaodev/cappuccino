@import <AppKit/AppKit.j>
@import <AppKit/CPLayoutConstraintEngine.j>
@import <Foundation/Foundation.j>

#define XCTAssertEqual(a,b) [self assert:b equals:a]
#define XCTAssertTrue(a) [self assertTrue:a]
#define XCTAssertFalse(a) [self assertFalse:a]

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
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 200, 200) styleMask:CPResizableWindowMask];
    [theWindow setAutolayoutEnabled:YES];

    contentView = [theWindow contentView];

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

- (void)testNeedsUpdateConstraintsDefaultValue
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    XCTAssertTrue([view needsUpdateConstraints]);
}

- (void)testNeedsUpdateConstraintsWithNoTranslateAutoresizingMask
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    XCTAssertFalse([view needsUpdateConstraints]);
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

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change                        context:(void)context
{
    _didReceiveKVONotification = YES;
}

@end
