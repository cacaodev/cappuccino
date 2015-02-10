@import <AppKit/AppKit.j>
@import <AppKit/CPLayoutConstraintEngine.j>
@import <Foundation/Foundation.j>

[CPApplication sharedApplication];

@implementation CPLayoutConstraintTest : OJTestCase
{
}

- (void)setUp
{
}

- (CPInteger)testAutolayoutSpeed
{
    var RESIZES_COUNT = 500;

    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    [theWindow orderFront:self];

    var autoSizeWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 600, 600) styleMask:CPResizableWindowMask],
        autosizeContentView = [autoSizeWindow contentView];

    var constraintsWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0, 0, 600, 600) styleMask:CPResizableWindowMask],
        constraintContentView = [constraintsWindow contentView];
    [constraintsWindow setAutolayoutEnabled:YES];
    [constraintContentView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [constraintContentView setIdentifier:@"ContentView"];

    var xmasks = [CPViewMaxXMargin, CPViewMinXMargin | CPViewMaxXMargin, CPViewMinXMargin],
        ymasks = [CPViewMaxYMargin, CPViewMinYMargin | CPViewMaxYMargin, CPViewMinYMargin],
        maxDepth = 3,
        num = 3;

    var autoSizeBlock = function(num, rect, level, idx)
    {
        var xmask = xmasks[(idx % num)],
            ymask = ymasks[FLOOR(idx/num)];

        var mask = xmask | ymask | CPViewWidthSizable | CPViewHeightSizable;

        var view = [[CPView alloc] initWithFrame:rect];
        [view setAutoresizingMask:mask];
        [view setIdentifier:[CPString stringWithFormat:@"view_%d_%d" , (maxDepth - level), idx]];

        return view;
    };

    var autoSizeSubviews = [self recursivelyAddNumViews:num toSuperview:autosizeContentView maxDepth:maxDepth withBlock:autoSizeBlock];

    var constraintSubviews = [self recursivelyAddNumViews:num toSuperview:constraintContentView maxDepth:maxDepth withBlock:function(num, rect, level, idx)
    {
        var view = autoSizeBlock(num, rect, level, idx);
        // The default is currently NO, but YES in cocoa.
        [view setTranslatesAutoresizingMaskIntoConstraints:YES];

        return view;
    }];

    [autoSizeWindow orderFront:self];
    [constraintsWindow orderFront:self];

    var start = new Date();

    var k = 1;

    for (; k <= RESIZES_COUNT; k++)
    {
        var size = 600 + k;
        [autoSizeWindow setFrame:CGRectMake(0, 0, size, size)];
        [[CPRunLoop mainRunLoop] performSelectors];
    }

    var end = new Date();
    var total1 = end - start;
    CPLog.warn("   Autosize setFrame: " + (total1/ RESIZES_COUNT) + " ms. Total " + total1 + " ms.");

    start = new Date();

    k = 1;

    for (; k <= RESIZES_COUNT; k++)
    {
        var size = 600 + k;
        [constraintsWindow setFrame:CGRectMake(0, 0, size, size)];
        [[CPRunLoop mainRunLoop] performSelectors];
    }

    end = new Date();
    var total2 = end - start;
    var r = total2/total1;
    var isSlower = (r > 1);
    CPLog.warn("Auto-layout setFrame: " + (total2/ RESIZES_COUNT) + " ms. Total " + total2 + " ms (" + ROUND(100* (isSlower ? r : 1/r))/100 + "x times " + (isSlower ? "slower":"faster") + ").");

// Check constraints/autoresizingmask equivalence correctness based on resulting frames.

    for (var n = 0; n < constraintSubviews.length; n++)
    {
        var autoSizeView = autoSizeSubviews[n],
            autoLayoutView = constraintSubviews[n];

        // CGRectEqualToRect rounding 2 digits after decimal
        var equalRects = CGRectEqualToRectRounding([autoSizeView frame], [autoLayoutView frame], 2);

        if (!equalRects)
        {
            var mess = "View " + [autoLayoutView identifier] + ": constraint Rect should be " + CPStringFromRect([autoSizeView frame]) + " but was " + CPStringFromRect([autoLayoutView frame]) + "\nConstraints:" + [[[autoLayoutView superview] constraints] description];
            [self assertTrue:equalRects message:mess];
        }
    }

    CPLog.warn("\n");

    return [total2, total1];
}

- (CPArray)recursivelyAddNumViews:(CPInteger)num toSuperview:(CPView)aSuperview maxDepth:(int)max withBlock:(Function)aBlock
{
    var buffer = @[];

    [self _recursivelyAddNumViews:num toSuperview:aSuperview maxDepth:max withBlock:aBlock buffer:buffer];

    return buffer;
}

- (void)_recursivelyAddNumViews:(CPInteger)num toSuperview:(CPView)aSuperview maxDepth:(int)maxDepth withBlock:(Function)aBlock buffer:(CPArray)buffer
{
    if (maxDepth == 0)
        return;

    var size = CGRectGetWidth([aSuperview frame]) / num;

    for (var i = 0; i < (num*num); i++)
    {
        var x = (i % num) * size,
            y = FLOOR(i / num) * size,
            rect = CGRectMake(x, y, size, size);

        var subview = aBlock(num, rect, maxDepth, i);
        [aSuperview addSubview:subview];
        [buffer addObject:subview];

        [self _recursivelyAddNumViews:num toSuperview:subview maxDepth:(maxDepth-1) withBlock:aBlock buffer:buffer];
    }
}

- (void)testAddOrRemoveConstraint
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

    var constraint1 = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];
    [view addConstraint:constraint1];

    [self assert:1 equals:[[view constraints] count]];

    var constraint2 = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    // Add a new constraint object equal to an installed constraint.
    [view addConstraint:constraint2];

    [self assert:2 equals:[[view constraints] count]];

    [view removeConstraint:constraint1];

    [self assert:1 equals:[[view constraints] count]];

    [self assert:constraint2 equals:[[view constraints] firstObject]];
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

/*
    RESULTS

    commit SHA b48d8eae3cad4d0d4f6edb98ff49333649fb54ea
    Autosize setFrame: 5.62 ms. Total 2810 ms.
    Auto-layout setFrame: 5.324 ms. Total 2662 ms (1.06x times faster).

    commit SHA 2c2c369ae8b7c99c9c059197c04fa5c807a19f74
    Autosize setFrame: 5.362 ms. Total 2681 ms.
    Auto-layout setFrame: 5.286 ms. Total 2643 ms (1.01x times faster).

*/