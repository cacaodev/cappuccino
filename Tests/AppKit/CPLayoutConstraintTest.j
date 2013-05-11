@import <AppKit/AppKit.j>
@import <Foundation/Foundation.j>

[CPApplication sharedApplication];

@implementation CPLayoutConstraintTest : OJTestCase
{
}

- (void)setUp
{
}

- (void)testConstraintBasedLayoutPerf
{
    [self _testConstraintBasedLayoutPerfWithMask:CPViewNotSizable];
    [self _testConstraintBasedLayoutPerfWithMask:CPViewMinXMargin];
    [self _testConstraintBasedLayoutPerfWithMask:CPViewMaxXMargin];
//    [self _testConstraintBasedLayoutPerfWithMask:CPViewMinXMargin|CPViewMaxXMargin];

    [self _testConstraintBasedLayoutPerfWithMask:CPViewWidthSizable];
    [self _testConstraintBasedLayoutPerfWithMask:CPViewWidthSizable|CPViewMinXMargin];
    [self _testConstraintBasedLayoutPerfWithMask:CPViewWidthSizable|CPViewMaxXMargin];
//    [self _testConstraintBasedLayoutPerfWithMask:CPViewWidthSizable|CPViewMinXMargin|CPViewMaxXMargin];

//    [self _testConstraintBasedLayoutPerfWithMask:CPViewMinXMargin|CPViewMaxXMargin|CPViewMinYMargin|CPViewMaxYMargin];
}

- (void)_testConstraintBasedLayoutPerfWithMask:(CPInteger)aMask
{
    var windowRect = CGRectMake(0, 0, 500, 500);
    var _autoSizeWindow = [[CPWindow alloc] initWithContentRect:windowRect styleMask:CPResizableWindowMask];
    var _constraintsWindow = [[CPWindow alloc] initWithContentRect:windowRect styleMask:CPResizableWindowMask];

    var NUMBER_OF_VIEWS = 100,
        RESIZES_COUNT = 500;

    for (var i = 0; i < NUMBER_OF_VIEWS; i++)
    {
        var x = (i % 10) * 50,
            y = FLOOR(i / 10) * 50,
            rect = CGRectMake(x, y, 50, 50);

        var autosizeView = [[CPView alloc] initWithFrame:rect];
        [autosizeView setAutoresizingMask:aMask];
        [[_autoSizeWindow contentView] addSubview:autosizeView];

        var constraintView = [[CPView alloc] initWithFrame:rect];
        [constraintView setIdentifier:@"View"];
        [constraintView setAutoresizingMask:aMask];

        [[_constraintsWindow contentView] setIdentifier:@"ContentView"];
        [[_constraintsWindow contentView] addSubview:constraintView];

        var constraints = [constraintView _constraintsEquivalentToAutoresizingMask];
        [[_constraintsWindow contentView] addConstraints:constraints];
    }

    var start = new Date();

    [_autoSizeWindow setFrame:CGRectMake(0,0, 600, 600)];

    var dd = new Date();

    for (var k = 1; k <= RESIZES_COUNT; k++)
    {
        var size = 600 + k;
        [_autoSizeWindow setFrame:CGRectMake(0, 0, size, size)];
    }

    var end = new Date();
    var total1 = end - dd;
    CPLog.warn("Subviews autoresize mask is " + aMask);
    CPLog.warn("Autosize setFrame: " + (end - dd)/ RESIZES_COUNT + " ms. Total " + total1 + " ms.");

    start = new Date();

    [_constraintsWindow setFrame:CGRectMake(0,0, 600, 600)];

    dd = new Date();

    for (var k = 1; k <= RESIZES_COUNT; k++)
    {
        var size = 600 + k;
        [_constraintsWindow setFrame:CGRectMake(0, 0, size, size)];
    }

    end = new Date();
    var total2 = end - dd;
    CPLog.warn("Constraints setFrame: " + (end - dd)/ RESIZES_COUNT + " ms. Total " + total2 + " ms (" + ROUND(10* total2/total1)/10 + "x times slower).");

// Check constraints/autoresizingmask equivalence correctness based on resulting frames.

    var autosizeSubviews = [[_autoSizeWindow contentView] subviews],
        constraintSubviews = [[_constraintsWindow contentView] subviews];

    [autosizeSubviews enumerateObjectsUsingBlock:function(aView, idx, stop)
    {
        // CGRectEqualToRect .dd
        var autoViewFrame = [aView frame],
            constViewFrame = [constraintSubviews[idx] frame];

        var equalRects = CGRectEqualToRectRounding(autoViewFrame, constViewFrame, 2);
        var message = "View " + idx + ": constraint Rect should be " + CPStringFromRect(autoViewFrame) + " but was " + CPStringFromRect(constViewFrame);
        try
        {
            [self assertTrue:equalRects message:message];
        }
        finally
        {
        }
    }];

    CPLog.warn("\n");
}

@end

var CGRectEqualToRectRounding = function(aRect, otherRect, rounding)
{
    var k = POW(10, rounding);

    return (ROUND(aRect.origin.x * k) / k    === ROUND(otherRect.origin.x * k) / k   ) &&
           (ROUND(aRect.origin.y * k) / k    === ROUND(otherRect.origin.y * k) / k   ) &&
           (ROUND(aRect.size.width * k) / k  === ROUND(otherRect.size.width * k) / k ) &&
           (ROUND(aRect.size.height * k) / k === ROUND(otherRect.size.height * k) / k);
};