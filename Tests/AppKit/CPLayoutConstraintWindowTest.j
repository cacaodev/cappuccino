@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

#define XCTAssertEqual(a, b) [self assert:b equals:a];
#define XCTAssertTrue(a) [self assertTrue:a]
#define XCTAssertFalse(a) [self assertFalse:a]
#define XCTAssertApprox(a, b, c) [self assertTrue:(ABS(a - b) <= c) message:"Expected " + b + " but was " + a];

[CPApplication sharedApplication];

@implementation CPLayoutConstraintWindowTest : OJTestCase
{
    CPWindow            theWindow;
    CPView              contentView;
    CPView              leftView;
    CPLayoutConstraint  leftConstraint;
    CPLayoutConstraint  rightConstraint;
    CPLayoutConstraint  minWidthConstraint;
}

- (void)setUp
{
    theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 200, 200) styleMask:CPResizableWindowMask];
    contentView = [theWindow contentView];

    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [contentView setIdentifier:@"contentView"];

    leftView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [leftView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [leftView setIdentifier:@"leftView"];

    leftConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:contentView attribute:CPLayoutAttributeLeft multiplier:1 constant:10];

    rightConstraint = [CPLayoutConstraint constraintWithItem:contentView attribute:CPLayoutAttributeRight relatedBy:CPLayoutRelationEqual toItem:leftView attribute:CPLayoutAttributeRight multiplier:1 constant:10];

    minWidthConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeWidth  relatedBy:CPLayoutRelationGreaterThanOrEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:180];
    [minWidthConstraint setPriority:999];

    var heightConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeHeight relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    var topConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeTop relatedBy:CPLayoutRelationEqual toItem:contentView attribute:CPLayoutAttributeTop multiplier:1 constant:10];

    // Put setup code here. This method is called before the invocation of each test method in the class.
    [contentView addSubview:leftView];

    [CPLayoutConstraint activateConstraints:@[leftConstraint, minWidthConstraint, rightConstraint, heightConstraint, topConstraint]];

    [theWindow orderFront:self];
    [[CPRunLoop mainRunLoop] performSelectors];
}

- (void)testAutolayoutEngaged
{
    XCTAssertTrue([theWindow isAutolayoutEnabled]);
}

- (void)testWindowResizingAfterRightConstraintConstantChange
{
    XCTAssertEqual(CGRectGetMaxX([leftView frame]),  [leftConstraint constant] + [minWidthConstraint constant]);

    [minWidthConstraint setPriority:CPLayoutPriorityWindowSizeStayPut + 50];
    [rightConstraint setConstant:50];

    [[contentView window] setNeedsLayout];
    [[CPRunLoop mainRunLoop] performSelectors];

    XCTAssertEqual(CGRectGetWidth([leftView frame]), [minWidthConstraint constant]); // required min width constraint set.
    XCTAssertEqual(CGRectGetMaxX([leftView frame]), [leftConstraint constant] + [minWidthConstraint constant]);
    XCTAssertEqual(CGRectGetWidth([contentView frame]), [leftConstraint constant] + [minWidthConstraint constant] + [rightConstraint constant]);
}

- (void)testWindowNotResizingAfterRightConstraintConstantChange
{
    XCTAssertEqual(CGRectGetMaxX([leftView frame]),  [leftConstraint constant] + [minWidthConstraint constant]);

    [minWidthConstraint setPriority:CPLayoutPriorityWindowSizeStayPut - 50];
    [rightConstraint setConstant:50];

    [[contentView window] setNeedsLayout];
    [[CPRunLoop mainRunLoop] performSelectors];

    var leftPadding = CGRectGetMinX([leftView frame]);
    var totalWidth = CGRectGetWidth([contentView frame]);

    XCTAssertEqual(leftPadding, [leftConstraint constant]);
    XCTAssertEqual(CGRectGetMaxX([leftView frame]), totalWidth - [rightConstraint constant]);
    XCTAssertEqual(CGRectGetWidth([leftView frame]), totalWidth - [rightConstraint constant] - leftPadding);
}

@end

/*
#import <XCTest/XCTest.h>
#import <Cocoa/cocoa.h>

@interface AutolayoutOJTestsTests : XCTestCase

@end

@implementation AutolayoutOJTestsTests
{
    NSWindow            *theWindow;
    NSView              *contentView;
    NSView              *leftView;
    NSLayoutConstraint  *leftConstraint;
    NSLayoutConstraint  *rightConstraint;
    NSLayoutConstraint  *minWidthConstraint;
}

- (void)setUp
{
    theWindow = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, 200, 200) styleMask:NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
    contentView = [theWindow contentView];

    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [contentView setIdentifier:@"contentView"];

    leftView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [leftView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [leftView setIdentifier:@"leftView"];

    leftConstraint = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10];

    rightConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeRight multiplier:1 constant:10];

    minWidthConstraint = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeWidth  relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:180];
    [minWidthConstraint setPriority:999];

    NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    NSLayoutConstraint * topConstraint = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10];

    [contentView addSubview:leftView];

    [NSLayoutConstraint activateConstraints:@[leftConstraint, minWidthConstraint, rightConstraint, heightConstraint, topConstraint]];

    [theWindow orderFront:self];

}

- (void)testWindowResizingAfterRightConstraintConstantChange
{
    XCTAssertEqual(CGRectGetMaxX([leftView frame]),  [leftConstraint constant] + [minWidthConstraint constant]);

    [minWidthConstraint setPriority:NSLayoutPriorityWindowSizeStayPut + 50];
    [rightConstraint setConstant:50];

    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];

    XCTAssertEqual(CGRectGetWidth([leftView frame]), [minWidthConstraint constant]); // required min width constraint set.
    XCTAssertEqual(CGRectGetMaxX([leftView frame]), [leftConstraint constant] + [minWidthConstraint constant]);
    XCTAssertEqual(CGRectGetWidth([contentView frame]), [leftConstraint constant] + [minWidthConstraint constant] + [rightConstraint constant]);
}

- (void)testWindowNotResizingAfterRightConstraintConstantChange
{
    XCTAssertEqual(CGRectGetMaxX([leftView frame]),  [leftConstraint constant] + [minWidthConstraint constant]);

    [minWidthConstraint setPriority:NSLayoutPriorityWindowSizeStayPut - 50];
    [rightConstraint setConstant:50];

    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];

    float leftPadding = CGRectGetMinX([leftView frame]);
    float totalWidth = CGRectGetWidth([contentView frame]);

    XCTAssertEqual(leftPadding, [leftConstraint constant]);
    XCTAssertEqual(CGRectGetMaxX([leftView frame]), totalWidth - [rightConstraint constant]);
    XCTAssertEqual(CGRectGetWidth([leftView frame]), totalWidth - [rightConstraint constant] - leftPadding);
}
@end
*/
