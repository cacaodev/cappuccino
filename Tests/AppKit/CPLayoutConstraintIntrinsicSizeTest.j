
@import <AppKit/AppKit.j>
@import <Foundation/Foundation.j>

#define XCTAssertEqual(a, b) [self assert:b equals:a];
#define XCTAssertTrue(a) [self assertTrue:a]
#define XCTAssertFalse(a) [self assertFalse:a]
#define XCTAssertApprox(a, b, c) [self assertTrue:(ABS(a - b) <= c) message:"Expected " + b + " but was " + a];

[CPApplication sharedApplication];

@implementation IntrinsicView : CPView
{
    float intrinsicContentWidth @accessors;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        intrinsicContentWidth = -1;
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(intrinsicContentWidth, 100);
}

@end

@implementation CPLayoutConstraintIntrinsicSizeTest : OJTestCase
{
    CPWindow           window;
    IntrinsicView      intrinsicView;
    CPLayoutConstraint left;
    CPLayoutConstraint right;

    float leftPriority;
    float rightPriority;
    float compressionPriority;
    float huggingPriority;
    float oldIntrinsicSize;
    float newIntrinsicSize;
}

- (void)setUp
{
    window = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
    [window setAutolayoutEnabled:YES];
    [[window contentView] setIdentifier:@"ContentView"];

    intrinsicView = [[IntrinsicView alloc] initWithFrame:CGRectMakeZero()];
    [intrinsicView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[window contentView] addSubview:intrinsicView];

    left = [CPLayoutConstraint constraintWithItem:intrinsicView
                                                            attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:[window contentView] attribute:CPLayoutAttributeLeft multiplier:1 constant:100];

    right = [CPLayoutConstraint constraintWithItem:[window contentView]
                                                             attribute:CPLayoutAttributeRight
                                                             relatedBy:CPLayoutRelationEqual toItem:intrinsicView attribute:CPLayoutAttributeRight multiplier:1 constant:100];

     var top = [CPLayoutConstraint constraintWithItem:intrinsicView
                                                             attribute:CPLayoutAttributeTop
                                                             relatedBy:CPLayoutRelationEqual toItem:[window contentView] attribute:CPLayoutAttributeTop multiplier:1 constant:100];

    [top setActive:YES];
}

- (void)testAntiCompression1
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = CPLayoutPriorityRequired;
    compressionPriority = 1;
    huggingPriority = CPLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);
}

- (void)testAntiCompression2
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = 1;
    huggingPriority = CPLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);
}

- (void)testAntiCompression3
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 498;
    compressionPriority = 499;
    huggingPriority = CPLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

}

- (void)testAntiCompression4
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 499;
    compressionPriority = 498;
    huggingPriority = CPLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);
}

- (void)testAntiCompression5
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 502;
    compressionPriority = 501;
    huggingPriority = CPLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 400, 2);
}

- (void)testAntiCompression6
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = 502;
    huggingPriority = CPLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 400, 2);
}

- (void)testAntiCompression7
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 499;
    compressionPriority = 501;
    huggingPriority = CPLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);
}

- (void)testAntiCompression8
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = 499;
    huggingPriority = CPLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);
}

- (void)testHugging1
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = CPLayoutPriorityRequired;
    compressionPriority = CPLayoutPriorityRequired;
    huggingPriority = 1;
    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 400, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 400, 2);
}

- (void)testHugging2
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = CPLayoutPriorityRequired;
    huggingPriority = 1;
    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 400, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 400, 2);
}

- (void)testHugging3
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 498;
    compressionPriority = CPLayoutPriorityRequired;
    huggingPriority = 499;
    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);
}

- (void)testHugging4
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 499;
    compressionPriority = CPLayoutPriorityRequired;
    huggingPriority = 498;
    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);
}

- (void)testHugging5
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 502;
    compressionPriority = CPLayoutPriorityRequired;
    huggingPriority = 501;
    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 400, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);
}

- (void)testHugging6
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = CPLayoutPriorityRequired;
    huggingPriority = 502;

    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 400, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);
}

- (void)testHugging7
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 499;
    compressionPriority = CPLayoutPriorityRequired;
    huggingPriority = 501;

    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 300, 2);
}

- (void)testHugging8
{
    leftPriority = CPLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = CPLayoutPriorityRequired;
    huggingPriority = 499;

    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];

    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [CPLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 400, 2);

    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[CPRunLoop mainRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    XCTAssertApprox(CGRectGetMinX([intrinsicView frame]), 100, 2);
    XCTAssertApprox(CGRectGetWidth([intrinsicView frame]), 200, 2);
    XCTAssertApprox(CGRectGetWidth([[window contentView] frame]), 400, 2);
}

@end
