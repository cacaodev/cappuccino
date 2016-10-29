
@import <AppKit/AppKit.j>
@import <Foundation/Foundation.j>

#define XCTAssertEqual(a, b) [self assert:b equals:a];
#define XCTAssertTrue(a) [self assertTrue:a]
#define XCTAssertFalse(a) [self assertFalse:a]
#define XCTAssertApprox(a, b, c) [self assertTrue:(ABS(a - b) <= c) message:"Expected " + b + " but was " + a];

[CPApplication sharedApplication];

@implementation IntrinsicView2 : CPView
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
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
    [[theWindow contentView] setTranslatesAutoresizingMaskIntoConstraints:YES];

    [theWindow orderFront:YES];
    [theWindow _engageAutolayoutIfNeeded];
    XCTAssertTrue([theWindow isAutolayoutEnabled]);

    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [[theWindow contentView] addSubview:view];
    [theWindow layout];
    XCTAssertFalse([view needsUpdateConstraints]);

    [view invalidateIntrinsicContentSize];
    XCTAssertTrue([view needsUpdateConstraints]);
}

- (void)testNeedsUpdateConstraintsAfterLayout
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
    [[theWindow contentView] setTranslatesAutoresizingMaskIntoConstraints:YES];

    [theWindow orderFront:YES];
    [theWindow _engageAutolayoutIfNeeded];
    XCTAssertTrue([theWindow isAutolayoutEnabled]);

    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [[theWindow contentView] addSubview:view];
    XCTAssertTrue([view needsUpdateConstraints]);
    [theWindow layout];
    XCTAssertFalse([view needsUpdateConstraints]);
}

- (void)testNeedsUpdateConstraintsAfterLayoutAfterInvalidateIntrinsicSize
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
    [[theWindow contentView] setTranslatesAutoresizingMaskIntoConstraints:YES];

    [theWindow orderFront:YES];
    [theWindow _engageAutolayoutIfNeeded];
    XCTAssertTrue([theWindow isAutolayoutEnabled]);

    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [[theWindow contentView] addSubview:view];
    XCTAssertTrue([view needsUpdateConstraints]);
    [theWindow layout];
    XCTAssertFalse([view needsUpdateConstraints]);
    [view invalidateIntrinsicContentSize];
    XCTAssertTrue([view needsUpdateConstraints]);
}

@end
