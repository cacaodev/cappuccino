//
//  Cocoa_Tests.m
//  Cocoa Tests
//
//  Created by x on 07/04/14.
//
//

#import <XCTest/XCTest.h>
#import <cocoa/Cocoa.h>

@interface FlippedView : NSView
@end

@implementation FlippedView

-(BOOL)isFlipped
{
    return YES;
}

@end

@interface IntrinsicView : FlippedView
    @property (readwrite, assign) CGFloat intrinsicContentWidth;
@end

@implementation IntrinsicView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.intrinsicContentWidth = -1;
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(self.intrinsicContentWidth, 100);
}

@end

@interface IntrinsicContentSize : XCTestCase
{
    NSWindow           *window;
    IntrinsicView      *intrinsicView;
    NSLayoutConstraint *left;
    NSLayoutConstraint *right;
    
    float leftPriority;
    float rightPriority;
    float compressionPriority;
    float huggingPriority;
    float oldIntrinsicSize;
    float newIntrinsicSize;
}
@end

@implementation IntrinsicContentSize

- (void)setUp
{
    window = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:YES];

    intrinsicView = [[IntrinsicView alloc] initWithFrame:CGRectZero];
    [intrinsicView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[window contentView] addSubview:intrinsicView];
    
    left = [NSLayoutConstraint constraintWithItem:intrinsicView
                                                            attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[window contentView] attribute:NSLayoutAttributeLeft multiplier:1 constant:100];
    
    right = [NSLayoutConstraint constraintWithItem:[window contentView]
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual toItem:intrinsicView attribute:NSLayoutAttributeRight multiplier:1 constant:100];

    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:intrinsicView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual toItem:[window contentView] attribute:NSLayoutAttributeTop multiplier:1 constant:100];
    
    top.active = YES;
}

- (void)testAntiCompression1
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = NSLayoutPriorityRequired;
    compressionPriority = 1;
    huggingPriority = NSLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];

    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];

    [NSLayoutConstraint activateConstraints:@[left, right]];

    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];

    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];


    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testAntiCompression2
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = 1;
    huggingPriority = NSLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testAntiCompression3
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 498;
    compressionPriority = 499;
    huggingPriority = NSLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testAntiCompression4
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 499;
    compressionPriority = 498;
    huggingPriority = NSLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testAntiCompression5
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 502;
    compressionPriority = 501;
    huggingPriority = NSLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 400);
}

- (void)testAntiCompression6
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = 502;
    huggingPriority = NSLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 400);
}

- (void)testAntiCompression7
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 499;
    compressionPriority = 501;
    huggingPriority = NSLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testAntiCompression8
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = 499;
    huggingPriority = NSLayoutPriorityRequired;
    oldIntrinsicSize = 100;
    newIntrinsicSize = 200;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testHugging1
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = NSLayoutPriorityRequired;
    compressionPriority = NSLayoutPriorityRequired;
    huggingPriority = 1;
    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;
    
    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 400);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 400);
}

- (void)testHugging2
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = NSLayoutPriorityRequired;
    huggingPriority = 1;
    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 400);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 400);
}

- (void)testHugging3
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 498;
    compressionPriority = NSLayoutPriorityRequired;
    huggingPriority = 499;
    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testHugging4
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 499;
    compressionPriority = NSLayoutPriorityRequired;
    huggingPriority = 498;
    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testHugging5
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 502;
    compressionPriority = NSLayoutPriorityRequired;
    huggingPriority = 501;
    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 400);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testHugging6
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = NSLayoutPriorityRequired;
    huggingPriority = 502;

    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 400);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testHugging7
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 499;
    compressionPriority = NSLayoutPriorityRequired;
    huggingPriority = 501;

    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

- (void)testHugging8
{
    leftPriority = NSLayoutPriorityRequired;
    rightPriority = 501;
    compressionPriority = NSLayoutPriorityRequired;
    huggingPriority = 499;

    oldIntrinsicSize = 200;
    newIntrinsicSize = 100;

    [intrinsicView setIntrinsicContentWidth:oldIntrinsicSize];
    
    [left setPriority:leftPriority];
    [right setPriority:rightPriority];
    
    [intrinsicView setContentCompressionResistancePriority:compressionPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [NSLayoutConstraint activateConstraints:@[left, right]];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 200);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 400);
    
    [intrinsicView setIntrinsicContentWidth:newIntrinsicSize];
    [intrinsicView invalidateIntrinsicContentSize];
    
    [[window contentView] layoutSubtreeIfNeeded];
    [[NSRunLoop mainRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    
    XCTAssertEqual(CGRectGetMinX([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([intrinsicView frame]), 100);
    XCTAssertEqual(CGRectGetWidth([[window contentView] frame]), 300);
}

@end
