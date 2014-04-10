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
}

- (void)setUp
{
    window = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 1002, 1002) styleMask:CPTitledWindowMask];

    mainView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    [window setContentView:mainView];

    intrinsicView = [[IntrinsicView alloc] initWithFrame:CGRectMakeZero()];
    //[intrinsicView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [mainView addSubview:intrinsicView];
}

- (void)testAntiCompression1
{
    [self doTestIntrinsicContentSize:@[1000,1000,1000,1  ,100,100,100,50,100]];
}

- (void)testAntiCompression2
{
    [self doTestIntrinsicContentSize:@[1000,500 ,1000,1  ,100,100,100,50,100]];
}

- (void)testAntiCompression3
{
    [self doTestIntrinsicContentSize:@[1000,498 ,1000,499,100,100,100,50,50]];
}

- (void)testAntiCompression4
{
    [self doTestIntrinsicContentSize:@[1000,499 ,1000,498,100,100,100,50,100]];
}

- (void)testAntiCompression5
{
    [self doTestIntrinsicContentSize:@[1000,502 ,1000,501,100,100,100,50,50]];
}

- (void)testAntiCompression6
{
    [self doTestIntrinsicContentSize:@[1000,501 ,1000,502,100,100,100,50,50]];
}

- (void)testAntiCompression7
{
    [self doTestIntrinsicContentSize:@[1000,499 ,1000,501,100,100,100,50,50]];
}

- (void)testAntiCompression8
{
    [self doTestIntrinsicContentSize:@[1000,501 ,1000,499,100,100,100,50,100]];
}

- (void)testHugging1
{
    [self doTestIntrinsicContentSize:@[1000,1000,1  ,1000,50,50,50,100,50 ]];
}

- (void)testHugging2
{
    [self doTestIntrinsicContentSize:@[1000,500 ,1  ,1000,50,50,50,100,50 ]];
}

- (void)testHugging3
{
    [self doTestIntrinsicContentSize:@[1000,498 ,499,1000,50,50,50,100,100 ]];
}

- (void)testHugging4
{
    [self doTestIntrinsicContentSize:@[1000,499 ,498,1000,50,50,50,100,50 ]];
}

- (void)testHugging5
{
    [self doTestIntrinsicContentSize:@[1000,502 ,501,1000,50,50,50,100,100]];
}

- (void)testHugging6
{
    [self doTestIntrinsicContentSize:@[1000,501 ,502,1000,50,50,50,100,100]];
}

- (void)testHugging7
{
    [self doTestIntrinsicContentSize:@[1000,499 ,501,1000,50,50,50,100,100]];
}

- (void)testHugging8
{
    [self doTestIntrinsicContentSize:@[1000,501 ,499,1000,50,50,50,100,50 ]];
}

- (void)doTestIntrinsicContentSize:(CPArray)params/*leftPriority,rightPriority,compressionResistancePriority,huggingPriority,initialIntrinsicWidth,initialWidth,excpectedInitialWidth,newIntrinsicWidth,excpectedNewWidth*/
{
    var leftPriority          = params[0];
    var rightPriority         = params[1];
    var antiComprPriority     = params[2];
    var huggingPriority       = params[3];
    var initialIntrinsicWidth = params[4];
    var initialWidth          = params[5];
    var excpectedInitialWidth = params[6];
    var newIntrinsicWidth     = params[7];
    var excpectedNewWidth     = params[8];

    var left = [CPLayoutConstraint constraintWithItem:intrinsicView
                                                            attribute:CPLayoutAttributeLeft relatedBy:CPLayoutRelationEqual toItem:mainView attribute:CPLayoutAttributeLeft multiplier:1 constant:10];
    [left setPriority:leftPriority];

    var right = [CPLayoutConstraint constraintWithItem:intrinsicView
                                                             attribute:CPLayoutAttributeRight
                                                             relatedBy:CPLayoutRelationEqual toItem:mainView attribute:CPLayoutAttributeRight multiplier:1 constant:(-990 + initialWidth)];
    [right setPriority:rightPriority];

    intrinsicView.intrinsicContentWidth = initialIntrinsicWidth;
    [intrinsicView setContentCompressionResistancePriority:antiComprPriority  forOrientation:CPLayoutConstraintOrientationHorizontal];
    [intrinsicView setContentHuggingPriority:huggingPriority forOrientation:CPLayoutConstraintOrientationHorizontal];

    [mainView removeConstraints:[mainView constraints]];
    [mainView addConstraints:@[left,right]];
    [window layout];

    var frame = [intrinsicView frame],
        minX = frame.origin.x,
           w = frame.size.width;

    var intrinsicWidth = [intrinsicView intrinsicContentSize].width;

    [self assert:minX equals:10 message:@"minX should be %d", 10];
    [self assert:excpectedInitialWidth equals:w message:@"Initial width wrong. Params:\n" + [params description]];

    [intrinsicView setIntrinsicContentWidth:newIntrinsicWidth];
    [intrinsicView invalidateIntrinsicContentSize];

    intrinsicWidth = [intrinsicView intrinsicContentSize].width;

    //[window layout];
    w = [intrinsicView frame].size.width;

    [self assert:excpectedNewWidth equals:w /*message:@"New width wrong. Params:\n" + [params description]*/];
}

@end
