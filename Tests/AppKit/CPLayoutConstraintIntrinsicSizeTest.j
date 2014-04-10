
@import <AppKit/AppKit.j>
@import <Foundation/Foundation.j>

[CPApplication sharedApplication];

@implementation IntrinsicView : CPView
{
    float intrinsicContentWidth @accessors;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        intrinsicContentWidth = 100.0;
    }

    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(intrinsicContentWidth, [super intrinsicContentSize].height);
}

@end

@implementation CPLayoutConstraintIntrinsicSizeTest : OJTestCase
{
    CPWindow      window;
    CPView        mainView;
    IntrinsicView intrinsicView;
    CPArray       antiCompressionTestData;
    CPArray       huggingTestData;
}

- (void)setUp
{
    var path = [[CPBundle bundleForClass:[self class]] pathForResource:@"AntiCompression.plist"];
    antiCompressionTestData = [self arrayWithContentsOfFile:path];

    path = [[CPBundle bundleForClass:[self class]] pathForResource:@"Hugging.plist"];
    huggingTestData = [self arrayWithContentsOfFile:path];

    window = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 1002, 1002) styleMask:CPTitledWindowMask];

    mainView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    [window setContentView:mainView];

    intrinsicView = [[IntrinsicView alloc] initWithFrame:CGRectMakeZero()];
    //[intrinsicView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [mainView addSubview:intrinsicView];
}

- (void)testAntiCompression1
{
    [self doTestIntrinsicContentSize:antiCompressionTestData[0]];
}

- (void)testAntiCompression2
{
    [self doTestIntrinsicContentSize:antiCompressionTestData[1]];
}

- (void)testAntiCompression3
{
    [self doTestIntrinsicContentSize:antiCompressionTestData[2]];
}

- (void)testAntiCompression4
{
    [self doTestIntrinsicContentSize:antiCompressionTestData[3]];
}

- (void)testAntiCompression5
{
    [self doTestIntrinsicContentSize:antiCompressionTestData[4]];
}

- (void)testHugging1
{
    [self doTestIntrinsicContentSize:huggingTestData[0]];
}

- (void)testHugging2
{
    [self doTestIntrinsicContentSize:huggingTestData[1]];
}

- (void)testHugging3
{
    [self doTestIntrinsicContentSize:huggingTestData[2]];
}

- (void)testHugging4
{
    [self doTestIntrinsicContentSize:huggingTestData[3]];
}

- (void)testHugging5
{
    [self doTestIntrinsicContentSize:huggingTestData[4]];
}

- (void)testHugging6
{
    [self doTestIntrinsicContentSize:huggingTestData[5]];
}

- (void)testHugging7
{
    [self doTestIntrinsicContentSize:huggingTestData[6]];
}

- (void)testHugging8
{
    [self doTestIntrinsicContentSize:huggingTestData[7]];
}

- (void)doTestIntrinsicContentSize:(CPDictionary)params
{
    var leftPriority = [params objectForKey:@"leftPriority"];
    var rightPriority = [params objectForKey:@"rightPriority"];
    var compressionResistancePriority = [params objectForKey:@"compressionResistancePriority"];
    var huggingPriority = [params objectForKey:@"huggingPriority"];
    var initialIntrinsicWidth = [params objectForKey:@"initialIntrinsicWidth"];
    var initialWidth = [params objectForKey:@"initialWidth"];
    var excpectedWidth = [params objectForKey:@"excpectedWidth"];
    var newIntrinsicWidth = [params objectForKey:@"newIntrinsicWidth"];
    var excpectedNewWidth = [params objectForKey:@"excpectedNewWidth"];

    var left = [CPLayoutConstraint constraintWithItem:intrinsicView
                                                            attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:mainView attribute:CPLayoutAttributeLeft multiplier:1 constant:10];
    [left setPriority:leftPriority];

    var right = [CPLayoutConstraint constraintWithItem:intrinsicView
                                                             attribute:CPLayoutAttributeRight
                                                             relatedBy:CPLayoutRelationEqual toItem:mainView attribute:CPLayoutAttributeRight multiplier:1 constant:(-990 + initialWidth)];
    [right setPriority:rightPriority];

    [intrinsicView setIntrinsicContentWidth:initialIntrinsicWidth];
    [intrinsicView setContentCompressionResistancePriority:compressionResistancePriority  forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [mainView removeConstraints:[mainView constraints]];
    [mainView addConstraints:@[left,right]];
    [window layout];

    var frame = [intrinsicView frame],
        minX = frame.origin.x,
           w = frame.size.width;

    var intrinsicWidth = [intrinsicView intrinsicContentSize].width;

    [self assert:minX equals:10 message:@"minX should be %d", 10];
    [self assert:w equals:excpectedWidth message:@"Initial width wrong. Params:\n" + [params description]];

    [intrinsicView setIntrinsicContentWidth:newIntrinsicWidth];
    [intrinsicView invalidateIntrinsicContentSize];

    intrinsicWidth = [intrinsicView intrinsicContentSize].width;

    w = [intrinsicView frame].size.width;

    [self assert:w equals:excpectedNewWidth message:@"New width wrong. Params:\n" + [params description]];
}

- (CPArray)arrayWithContentsOfFile:(CPString)aPath
{
    var aURL = [CPURL URLWithString:aPath];

    var data = [CPURLConnection sendSynchronousRequest:[CPURLRequest requestWithURL:aURL] returningResponse:NULL];

    return [CPPropertyListSerialization propertyListFromData:data format:CPPropertyListXMLFormat_v1_0];
}

@end
