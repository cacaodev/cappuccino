//
//  Cocoa_Tests.m
//  Cocoa Tests
//
//  Created by x on 07/04/14.
//
//

#import <XCTest/XCTest.h>
#import <cocoa/Cocoa.h>

@interface IntrinsicView : NSView
    @property (readwrite, assign) CGFloat intrinsicContentWidth;
@end

@implementation IntrinsicView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.intrinsicContentWidth = 100.0;
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(self.intrinsicContentWidth, [super intrinsicContentSize].height);
}

@end

@interface IntrinsicContentSize : XCTestCase
{
    NSWindow *window;
    NSView *mainView;
    IntrinsicView *intrinsicView;
}
@end

@implementation IntrinsicContentSize

- (void)setUp
{
    window = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, 1000, 1000) styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:YES];
    
    mainView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    window.contentView = mainView;
    
    intrinsicView = [[IntrinsicView alloc] initWithFrame:CGRectZero];
    intrinsicView.translatesAutoresizingMaskIntoConstraints = NO;
    [mainView addSubview:intrinsicView];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAntiCompression
{
    [self doTestIntrinsicContentSize:@[@1000,@1000,@1000,@1 ,@100,@100,@100,@50,@100]];
    [self doTestIntrinsicContentSize:@[@1000,@500,@1000,@1  ,@100,@100,@100,@50,@100]];
    [self doTestIntrinsicContentSize:@[@1000,@498,@1000,@499,@100,@100,@100,@50,@50 ]];
    [self doTestIntrinsicContentSize:@[@1000,@499,@1000,@498,@100,@100,@100,@50,@100]];
    [self doTestIntrinsicContentSize:@[@1000,@502,@1000,@501,@100,@100,@100,@50,@50 ]];
    [self doTestIntrinsicContentSize:@[@1000,@501,@1000,@502,@100,@100,@100,@50,@50 ]];
    [self doTestIntrinsicContentSize:@[@1000,@499,@1000,@501,@100,@100,@100,@50,@50 ]];
    [self doTestIntrinsicContentSize:@[@1000,@501,@1000,@499,@100,@100,@100,@50,@100]];
}

- (void)testHugging
{
    [self doTestIntrinsicContentSize:@[@1000,@1000,@1  ,@1000,@50,@50,@50,@100,@50 ]];
    [self doTestIntrinsicContentSize:@[@1000,@500 ,@1  ,@1000,@50,@50,@50,@100,@50 ]];
    [self doTestIntrinsicContentSize:@[@1000,@498 ,@499,@1000,@50,@50,@50,@100,@100]];
    [self doTestIntrinsicContentSize:@[@1000,@499 ,@498,@1000,@50,@50,@50,@100,@50 ]];
    [self doTestIntrinsicContentSize:@[@1000,@502 ,@501,@1000,@50,@50,@50,@100,@100]];
    [self doTestIntrinsicContentSize:@[@1000,@501 ,@502,@1000,@50,@50,@50,@100,@100]];
    [self doTestIntrinsicContentSize:@[@1000,@499 ,@501,@1000,@50,@50,@50,@100,@100]];
    [self doTestIntrinsicContentSize:@[@1000,@501 ,@499,@1000,@50,@50,@50,@100,@50 ]];
}

- (void)doTestIntrinsicContentSize:(NSArray*)params/*leftPriority,rightPriority,compressionResistancePriority,huggingPriority,initialIntrinsicWidth,initialWidth,excpectedWidth,newIntrinsicWidth,excpectedNewWidth*/
{
    float leftPriority = [[params objectAtIndex:0] floatValue];
    float rightPriority = [[params objectAtIndex:1] floatValue];
    float compressionResistancePriority = [[params objectAtIndex:2] floatValue];
    float huggingPriority = [[params objectAtIndex:3] floatValue];
    float initialIntrinsicWidth = [[params objectAtIndex:4] floatValue];
    float initialWidth = [[params objectAtIndex:5] floatValue];
    float excpectedWidth = [[params objectAtIndex:6] floatValue];
    float newIntrinsicWidth = [[params objectAtIndex:7] floatValue];
    float excpectedNewWidth = [[params objectAtIndex:8] floatValue];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:intrinsicView
                                                            attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
    [left setPriority:leftPriority];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:intrinsicView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeRight multiplier:1 constant:(-990 + initialWidth)];
    [right setPriority:rightPriority];
    
    intrinsicView.intrinsicContentWidth = initialIntrinsicWidth;
    [intrinsicView setContentCompressionResistancePriority:compressionResistancePriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [mainView removeConstraints:mainView.constraints];
    [mainView addConstraints:@[left,right]];
    [window layoutIfNeeded];
    
    float minX = intrinsicView.frame.origin.x;
    float w = intrinsicView.frame.size.width;
    
    float intrinsicWidth = intrinsicView.intrinsicContentSize.width;
    
        //XCTAssertFalse(mainView.hasAmbiguousLayout, @"Ambiguous layout for %@", mainView);
    XCTAssertEqual(minX, 10, @"minX = %f", minX);
    XCTAssertTrue(w == excpectedWidth, @"w = %f ics=%f", w, intrinsicWidth);
    
    intrinsicView.intrinsicContentWidth = newIntrinsicWidth;
    [intrinsicView invalidateIntrinsicContentSize];
    
    intrinsicWidth = intrinsicView.intrinsicContentSize.width;
    
    [window layoutIfNeeded];
    w = intrinsicView.frame.size.width;
    
        //XCTAssertFalse(mainView.hasAmbiguousLayout, @"Ambiguous layout for %@", mainView);
        //XCTAssertTrue(intrinsicWidth = );
    XCTAssertTrue(w == excpectedNewWidth, @"width:%f intrinsic:%f", w, intrinsicWidth);
}

@end
