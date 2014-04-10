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
    NSArray *antiCompressionTestData;
    NSArray *huggingTestData;
}
@end

@implementation IntrinsicContentSize

- (void)setUp
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"AntiCompression" ofType:@"plist"];
    antiCompressionTestData = [[NSArray alloc] initWithContentsOfFile:path];

    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"Hugging" ofType:@"plist"];
    huggingTestData = [[NSArray alloc] initWithContentsOfFile:path];

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
    for (NSDictionary *test in antiCompressionTestData)
        [self doTestIntrinsicContentSize:test];
}

- (void)testHugging
{
    for (NSDictionary *test in huggingTestData)
        [self doTestIntrinsicContentSize:test];
}

- (void)doTestIntrinsicContentSize:(NSDictionary*)params
{
    float leftPriority = [[params objectForKey:@"leftPriority"] floatValue];
    float rightPriority = [[params objectForKey:@"rightPriority"] floatValue];
    float compressionResistancePriority = [[params objectForKey:@"compressionResistancePriority"] floatValue];
    float huggingPriority = [[params objectForKey:@"huggingPriority"] floatValue];
    float initialIntrinsicWidth = [[params objectForKey:@"initialIntrinsicWidth"] floatValue];
    float initialWidth = [[params objectForKey:@"initialWidth"] floatValue];
    float excpectedWidth = [[params objectForKey:@"excpectedWidth"] floatValue];
    float newIntrinsicWidth = [[params objectForKey:@"newIntrinsicWidth"] floatValue];
    float excpectedNewWidth = [[params objectForKey:@"excpectedNewWidth"] floatValue];
    
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
    XCTAssertEqual(w , excpectedWidth, @"params=%@", [params description]);
    
    intrinsicView.intrinsicContentWidth = newIntrinsicWidth;
    [intrinsicView invalidateIntrinsicContentSize];
    
    intrinsicWidth = intrinsicView.intrinsicContentSize.width;
    
    [window layoutIfNeeded];
    w = intrinsicView.frame.size.width;
    
    //XCTAssertFalse(mainView.hasAmbiguousLayout, @"Ambiguous layout for %@", mainView);
    //XCTAssertTrue(intrinsicWidth = );
    XCTAssertEqual(w , excpectedNewWidth, @"params=%@", [params description]);
}

@end
