@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

#define XCTAssertEqual(a, b) [self assert:b equals:a];
#define XCTAssertTrue(a) [self assertTrue:a]
#define XCTAssertFalse(a) [self assertFalse:a]
#define XCTAssertApprox(a, b, c) [self assertTrue:(ABS(a - b) <= c) message:"Expected " + b + " but was " + a];

[CPApplication sharedApplication];

@implementation CPLayoutConstraintWindowTest : OJTestCase
{
    CPView contentView;
    CPView leftView;
    CPLayoutConstraint rightConstraint;
    CPLayoutConstraint minWidthConstraint;
}

- (void)setUp
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 200, 200) styleMask:CPResizableWindowMask];
    [theWindow setAutolayoutEnabled:YES];

    contentView = [theWindow contentView];
    [contentView setIdentifier:@"contentView"];

    leftView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [leftView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [leftView setIdentifier:@"leftView"];

    var leftConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:contentView attribute:CPLayoutAttributeLeft multiplier:1 constant:10];

    rightConstraint = [CPLayoutConstraint constraintWithItem:contentView attribute:CPLayoutAttributeRight relatedBy:CPLayoutRelationEqual toItem:leftView attribute:CPLayoutAttributeRight multiplier:1 constant:10];

    minWidthConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeWidth  relatedBy:CPLayoutRelationGreaterThanOrEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:180];

    var heightConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeHeight relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    var topConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeTop relatedBy:CPLayoutRelationEqual toItem:contentView attribute:CPLayoutAttributeTop multiplier:1 constant:10];

    // Put setup code here. This method is called before the invocation of each test method in the class.
    [contentView addSubview:leftView];

    [CPLayoutConstraint activateConstraints:@[leftConstraint, minWidthConstraint, rightConstraint, heightConstraint, topConstraint]];
}

- (void)testWindowResizingAfterRightConstraintConstantChange
{
    [[contentView window] setNeedsLayout];
    [[CPRunLoop mainRunLoop] performSelectors];

    XCTAssertEqual(CGRectGetMaxX([leftView frame]),  190);

    [rightConstraint setConstant:50];
    [[contentView window] setNeedsLayout];
    [[CPRunLoop mainRunLoop] performSelectors];

    XCTAssertEqual(CGRectGetWidth([leftView frame]), 180); // required min width constraint set.
    XCTAssertEqual(CGRectGetMaxX([leftView frame]), 10 + 180);
    XCTAssertEqual(CGRectGetWidth([contentView frame]), 10 + 180 + 50);
}

- (void)testWindowNotResizingAfterRightConstraintConstantChange
{
    [[contentView window] setNeedsLayout];
    [[CPRunLoop mainRunLoop] performSelectors];

    XCTAssertEqual(CGRectGetMaxX([leftView frame]),  190);

    [minWidthConstraint setPriority:450];
    [rightConstraint setConstant:50];

    [[contentView window] setNeedsLayout];
    [[CPRunLoop mainRunLoop] performSelectors];

    XCTAssertEqual(CGRectGetMinX([leftView frame]), 10);
    XCTAssertEqual(CGRectGetWidth([leftView frame]), 140); // required min width constraint set.
    XCTAssertEqual(CGRectGetMaxX([leftView frame]), 10 + 140);
    XCTAssertEqual(CGRectGetWidth([contentView frame]), 10 + 140 + 50);
}

@end
