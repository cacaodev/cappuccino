
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

@implementation CPLayoutConstraintNeedsUpdateConstraintTest : OJTestCase
{
}

- (void)testNeedsUpdateConstraintsInitialyTrue
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    XCTAssertTrue([view needsUpdateConstraints]);
}

- (void)testNeedsUpdateConstraintsAfterTranslateAutoresizingMask
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setNeedsUpdateConstraints:NO];
    [view setTranslatesAutoresizingMaskIntoConstraints:YES];
    XCTAssertTrue([view needsUpdateConstraints]);
}

- (void)testNeedsUpdateConstraintsAfterInvalidateIntrinsicSize
{
    var window = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
    [window setAutolayoutEnabled:YES];

    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [[window contentView] addSubview:view];
    [window layout];
    XCTAssertFalse([view needsUpdateConstraints]);

    [view invalidateIntrinsicContentSize];
    XCTAssertTrue([view needsUpdateConstraints]);
}

- (void)testNeedsUpdateConstraintsAfterLayout
{
    var window = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
    [window setAutolayoutEnabled:YES];

    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [[window contentView] addSubview:view];
    XCTAssertTrue([view needsUpdateConstraints]);
    [window layout];
    XCTAssertFalse([view needsUpdateConstraints]);
}

- (void)testNeedsUpdateConstraintsAfterLayoutAfterInvalidateIntrinsicSize
{
    var window = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
    [window setAutolayoutEnabled:YES];

    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [[window contentView] addSubview:view];
    XCTAssertTrue([view needsUpdateConstraints]);
    [window layout];
    XCTAssertFalse([view needsUpdateConstraints]);
    [view invalidateIntrinsicContentSize];
    XCTAssertTrue([view needsUpdateConstraints]);
}

@end
