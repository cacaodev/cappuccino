@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

#define XCTAssertEqual(a,b) [self assert:b equals:a]

[CPApplication sharedApplication];

@implementation FlippedView : CPView
{
    CGInset m_alignmentRectInsets @accessors(property=_alignmentRectInsets);
    float   m_baselineFromBottom @accessors(property=_baselineFromBottom);
}

- (CGInset)alignmentRectInsets
{
    return m_alignmentRectInsets;
}

@end

@implementation CPLayoutConstraintAlignmentTest : OJTestCase
{
    CPView contentView @accessors;
    FlippedView leftView @accessors;
    FlippedView rightView @accessors;
}

- (void)setUp
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 1000, 1000) styleMask:CPResizableWindowMask];

    [theWindow setAutolayoutEnabled:YES];

    contentView = [theWindow contentView];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];

    leftView = [[FlippedView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [leftView _setAlignmentRectInsets:CGInsetMake(10, 10, 10, 10)];
    [leftView _setBaselineFromBottom:8.0];
    [leftView setTranslatesAutoresizingMaskIntoConstraints:NO];

    rightView = [[FlippedView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [rightView _setAlignmentRectInsets:CGInsetMake(20, 20, 20, 20)];
    [rightView _setBaselineFromBottom:12.0];
    [rightView setTranslatesAutoresizingMaskIntoConstraints:NO];

    var leftConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:contentView attribute:CPLayoutAttributeLeft multiplier:1 constant:10];

    var widthConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    var heightConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeHeight relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    var rightToLeftConstraint = [CPLayoutConstraint constraintWithItem:rightView attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:leftView attribute:CPLayoutAttributeRight multiplier:1 constant:50];

    var widthRightConstraint = [CPLayoutConstraint constraintWithItem:rightView attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    var heightRightConstraint = [CPLayoutConstraint constraintWithItem:rightView attribute:CPLayoutAttributeHeight relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    // Put setup code here. This method is called before the invocation of each test method in the class.
    [contentView addSubview:leftView];
    [contentView addSubview:rightView];

    [CPLayoutConstraint activateConstraints:@[leftConstraint,widthConstraint,heightConstraint,rightToLeftConstraint,widthRightConstraint,heightRightConstraint]];
}

- (void)testAlignmentRect
{
    var topConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeTop relatedBy:CPLayoutRelationEqual toItem:contentView attribute:CPLayoutAttributeTop multiplier:1 constant:50];
    var topLeftRightConstraint = [CPLayoutConstraint constraintWithItem:rightView attribute:CPLayoutAttributeTop relatedBy:CPLayoutRelationEqual toItem:leftView attribute:CPLayoutAttributeTop multiplier:1 constant:0];

    [CPLayoutConstraint activateConstraints:@[topConstraint, topLeftRightConstraint]];
    [[contentView window] layout];

    var leftFrame = [leftView frame];
    var rightFrame = [rightView frame];

    XCTAssertEqual(leftFrame.origin.y,  50 - [leftView _alignmentRectInsets].top);
    XCTAssertEqual(rightFrame.origin.y, 50 - [rightView _alignmentRectInsets].top);
    XCTAssertEqual(leftFrame.origin.y  + [leftView _alignmentRectInsets].top,
                   rightFrame.origin.y + [rightView _alignmentRectInsets].top);
}

- (void)testBaselineAlignment
{
    var bottomConstraint = [CPLayoutConstraint constraintWithItem:leftView attribute:CPLayoutAttributeBottom relatedBy:CPLayoutRelationEqual toItem:contentView attribute:CPLayoutAttributeBottom multiplier:1 constant:50];

    var baselineLeftRightConstraint = [CPLayoutConstraint constraintWithItem:rightView attribute:CPLayoutAttributeBaseline relatedBy:CPLayoutRelationEqual toItem:leftView attribute:CPLayoutAttributeBaseline multiplier:1 constant:0];

    [CPLayoutConstraint activateConstraints:@[bottomConstraint, baselineLeftRightConstraint]];
    [[contentView window] layout];

    var leftFrame = [leftView frame];
    var rightFrame = [rightView frame];

    XCTAssertEqual(CGRectGetMaxY(leftFrame)  - [leftView _alignmentRectInsets].bottom  - [rightView _baselineFromBottom],
                   CGRectGetMaxY(rightFrame) - [rightView _alignmentRectInsets].bottom - [rightView _baselineFromBottom]);
}

@end
