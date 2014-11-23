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
    var r = 0,
        ms = 0,
        me = 63,
        autolayout = 0,
        autosize = 0;


    for (var m = ms; m < me; m++)
    {
        var res = [self _testConstraintBasedLayoutPerfWithMask:m];
        autolayout += res[0];
        autosize += res[1];
    }

    CPLog.warn("Autolayout=" + autolayout + " ms. Autosize=" + autosize + " ms. AVG = x" + ROUND(1000*autolayout/autosize)/1000 + " times slower");

/*
    [self _testConstraintBasedLayoutPerfWithMask:CPViewNotSizable];
    [self _testConstraintBasedLayoutPerfWithMask:CPViewMinXMargin];
    [self _testConstraintBasedLayoutPerfWithMask:CPViewMaxXMargin];
    [self _testConstraintBasedLayoutPerfWithMask:CPViewMinXMargin|CPViewMaxXMargin];

    [self _testConstraintBasedLayoutPerfWithMask:CPViewWidthSizable];
    [self _testConstraintBasedLayoutPerfWithMask:CPViewWidthSizable|CPViewMinXMargin];
    [self _testConstraintBasedLayoutPerfWithMask:CPViewWidthSizable|CPViewMaxXMargin];
    [self _testConstraintBasedLayoutPerfWithMask:CPViewWidthSizable|CPViewMinXMargin|CPViewMaxXMargin];
*/
}

- (CPInteger)_testConstraintBasedLayoutPerfWithMask:(CPInteger)aMask
{
    var windowRect = CGRectMake(0, 0, 500, 500);
    var _autoSizeWindow = [[CPWindow alloc] initWithContentRect:windowRect styleMask:CPResizableWindowMask];
    var _constraintsWindow = [[CPWindow alloc] initWithContentRect:windowRect styleMask:CPResizableWindowMask];
    [_constraintsWindow setAutolayoutEnabled:YES];
    var autosizeContentView = [_autoSizeWindow contentView];
    var constraintContentView = [_constraintsWindow contentView];
    var autoSizeSubviews = [];
    var constraintSubviews = [];
    
    [constraintContentView setIdentifier:@"ContentView"];
    
    var NUMBER_OF_VIEWS = 100,
        RESIZES_COUNT = 500;

    for (var i = 0; i < NUMBER_OF_VIEWS; i++)
    {
        var x = (i % 10) * 50,
            y = FLOOR(i / 10) * 50,
            rect = CGRectMake(x, y, 50, 50);

        var autosizeView = [[CPView alloc] initWithFrame:rect];
        [autosizeView setAutoresizingMask:aMask];
        [autosizeContentView addSubview:autosizeView];
        autoSizeSubviews.push(autosizeView);

        var constraintView = [[CPView alloc] initWithFrame:rect];
        [constraintView setAutoresizingMask:aMask];
        [constraintView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [constraintView setIdentifier:@"View"];
        [constraintContentView addSubview:constraintView];
        constraintSubviews.push(constraintView);
    }

    var start = new Date();

    [_autoSizeWindow setFrame:CGRectMake(0,0, 600, 600)];

    var dd = new Date();

    var k = 1;

    for (; k <= RESIZES_COUNT; k++)
    {
        var size = 600 + k;
        [_autoSizeWindow setFrame:CGRectMake(0, 0, size, size)];
    }

    var end = new Date();
    var total1 = end - dd;
    CPLog.warn("Subviews autoresize mask is " + aMask);
    CPLog.warn("   Autosize setFrame: " + ((end - dd)/ RESIZES_COUNT) + " ms. Total " + total1 + " ms.");

    start = new Date();

    [_constraintsWindow setFrame:CGRectMake(0,0, 600, 600)];

    dd = new Date();
    k = 1;

    for (; k <= RESIZES_COUNT; k++)
    {
        var size = 600 + k;
        [_constraintsWindow setFrame:CGRectMake(0, 0, size, size)];
    }

    end = new Date();
    var total2 = end - dd;
    var r = total2/total1;
    var isSlower = (r > 1);
    CPLog.warn("Auto-layout setFrame: " + ((end - dd)/ RESIZES_COUNT) + " ms. Total " + total2 + " ms (" + ROUND(100* (isSlower ? r : 1/r))/100 + "x times " + (isSlower ? "slower":"faster") + ").");


// Check constraints/autoresizingmask equivalence correctness based on resulting frames.

    for (var n = 0; n < constraintSubviews.length; n++)
    {
        var autoViewFrame = [autoSizeSubviews[n] frame],
            constViewFrame = [constraintSubviews[n] frame];

        // CGRectEqualToRect rounding 2 digits after decimal
        var equalRects = CGRectEqualToRectRounding(autoViewFrame, constViewFrame, 0);

        [self assertTrue:equalRects message:"View " + n + ": constraint Rect should be " + CPStringFromRect(autoViewFrame) + " but was " + CPStringFromRect(constViewFrame)];
    }

    CPLog.warn("\n");

    return [total2, total1];
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
CPLayoutConstraintWebWorker branch

Tests for synch mode (no Worker):

2013-05-20 10:47:44.616 objj [warn]: Subviews autoresize mask is 0
2013-05-20 10:47:44.617 objj [warn]:    Autosize setFrame: 0.3 ms. Total 150 ms.
2013-05-20 10:47:45.065 objj [warn]: Auto-layout setFrame: 0.604 ms. Total 302 ms (2.01x times slower).
2013-05-20 10:47:45.768 objj [warn]: Subviews autoresize mask is 1
2013-05-20 10:47:45.769 objj [warn]:    Autosize setFrame: 1.014 ms. Total 507 ms.
2013-05-20 10:47:46.668 objj [warn]: Auto-layout setFrame: 1.502 ms. Total 751 ms (1.48x times slower).
2013-05-20 10:47:47.216 objj [warn]: Subviews autoresize mask is 4
2013-05-20 10:47:47.217 objj [warn]:    Autosize setFrame: 0.722 ms. Total 361 ms.
2013-05-20 10:47:47.632 objj [warn]: Auto-layout setFrame: 0.588 ms. Total 294 ms (0.81x times slower).
2013-05-20 10:47:48.315 objj [warn]: Subviews autoresize mask is 5
2013-05-20 10:47:48.315 objj [warn]:    Autosize setFrame: 0.986 ms. Total 493 ms.
2013-05-20 10:47:49.165 objj [warn]: Auto-layout setFrame: 1.454 ms. Total 727 ms (1.47x times slower).
2013-05-20 10:47:50.190 objj [warn]: Subviews autoresize mask is 2
2013-05-20 10:47:50.191 objj [warn]:    Autosize setFrame: 1.666 ms. Total 833 ms.
2013-05-20 10:47:51.367 objj [warn]: Auto-layout setFrame: 2.054 ms. Total 1027 ms (1.23x times slower).
2013-05-20 10:47:52.429 objj [warn]: Subviews autoresize mask is 3
2013-05-20 10:47:52.430 objj [warn]:    Autosize setFrame: 1.688 ms. Total 844 ms.
2013-05-20 10:47:54.335 objj [warn]: Auto-layout setFrame: 2.49 ms. Total 1245 ms (1.48x times slower).
2013-05-20 10:47:55.393 objj [warn]: Subviews autoresize mask is 6
2013-05-20 10:47:55.394 objj [warn]:    Autosize setFrame: 1.68 ms. Total 840 ms.
2013-05-20 10:47:56.560 objj [warn]: Auto-layout setFrame: 2.084 ms. Total 1042 ms (1.24x times slower).
2013-05-20 10:47:57.622 objj [warn]: Subviews autoresize mask is 7
2013-05-20 10:47:57.623 objj [warn]:    Autosize setFrame: 1.748 ms. Total 874 ms.
2013-05-20 10:47:59.001 objj [warn]: Auto-layout setFrame: 2.482 ms. Total 1241 ms (1.42x times slower).

Commit 2a322f3

2014-03-25 12:31:33.268 objj [warn]: Subviews autoresize mask is 0
2014-03-25 12:31:33.270 objj [warn]:    Autosize setFrame: 0.294 ms. Total 147 ms.
2014-03-25 12:31:33.579 objj [warn]: Auto-layout setFrame: 0.292 ms. Total 146 ms (0.99x times slower).
2014-03-25 12:31:33.583 objj [warn]:

2014-03-25 12:31:34.262 objj [warn]: Subviews autoresize mask is 1
2014-03-25 12:31:34.264 objj [warn]:    Autosize setFrame: 0.932 ms. Total 466 ms.
2014-03-25 12:31:35.324 objj [warn]: Auto-layout setFrame: 0.872 ms. Total 436 ms (0.94x times slower).
2014-03-25 12:31:35.327 objj [warn]:

2014-03-25 12:31:35.852 objj [warn]: Subviews autoresize mask is 4
2014-03-25 12:31:35.853 objj [warn]:    Autosize setFrame: 0.642 ms. Total 321 ms.
2014-03-25 12:31:36.146 objj [warn]: Auto-layout setFrame: 0.404 ms. Total 202 ms (0.63x times slower).
2014-03-25 12:31:36.148 objj [warn]:

2014-03-25 12:31:36.773 objj [warn]: Subviews autoresize mask is 5
2014-03-25 12:31:36.775 objj [warn]:    Autosize setFrame: 0.852 ms. Total 426 ms.
2014-03-25 12:31:37.284 objj [warn]: Auto-layout setFrame: 0.812 ms. Total 406 ms (0.95x times slower).
2014-03-25 12:31:37.286 objj [warn]:

2014-03-25 12:31:38.225 objj [warn]: Subviews autoresize mask is 2
2014-03-25 12:31:38.225 objj [warn]:    Autosize setFrame: 1.476 ms. Total 738 ms.
2014-03-25 12:31:39.047 objj [warn]: Auto-layout setFrame: 1.434 ms. Total 717 ms (0.97x times slower).
2014-03-25 12:31:39.050 objj [warn]:

2014-03-25 12:31:40.017 objj [warn]: Subviews autoresize mask is 3
2014-03-25 12:31:40.018 objj [warn]:    Autosize setFrame: 1.484 ms. Total 742 ms.
2014-03-25 12:31:42.311 objj [warn]: Auto-layout setFrame: 1.714 ms. Total 857 ms (1.15x times slower).
2014-03-25 12:31:42.314 objj [warn]:

2014-03-25 12:31:43.278 objj [warn]: Subviews autoresize mask is 6
2014-03-25 12:31:43.279 objj [warn]:    Autosize setFrame: 1.518 ms. Total 759 ms.
2014-03-25 12:31:44.116 objj [warn]: Auto-layout setFrame: 1.482 ms. Total 741 ms (0.98x times slower).
2014-03-25 12:31:44.118 objj [warn]:

2014-03-25 12:31:45.053 objj [warn]: Subviews autoresize mask is 7
2014-03-25 12:31:45.054 objj [warn]:    Autosize setFrame: 1.47 ms. Total 735 ms.
2014-03-25 12:31:46.022 objj [warn]: Auto-layout setFrame: 1.698 ms. Total 849 ms (1.16x times slower).
2014-03-25 12:31:46.023 objj [warn]:

commit 8a084d2b19fba57ce555943b0d404cb8972e1792

*/

/*
CPLayoutConstraint branch (Worker not implemented)

2013-05-11 22:08:30.401 objj [warn]: Subviews autoresize mask is 0
2013-05-11 22:08:30.403 objj [warn]: Autosize setFrame: 0.31 ms. Total 155 ms.
2013-05-11 22:08:30.835 objj [warn]: Constraints setFrame: 0.708 ms. Total 354 ms (2.3x times slower).
2013-05-11 22:08:30.837 objj [warn]:

2013-05-11 22:08:31.559 objj [warn]: Subviews autoresize mask is 1
2013-05-11 22:08:31.560 objj [warn]: Autosize setFrame: 1.104 ms. Total 552 ms.
2013-05-11 22:08:32.264 objj [warn]: Constraints setFrame: 1.166 ms. Total 583 ms (1.1x times slower).
2013-05-11 22:08:32.266 objj [warn]:

2013-05-11 22:08:33.265 objj [warn]: Subviews autoresize mask is 2
2013-05-11 22:08:33.266 objj [warn]: Autosize setFrame: 1.676 ms. Total 838 ms.
2013-05-11 22:08:34.238 objj [warn]: Constraints setFrame: 1.774 ms. Total 887 ms (1.1x times slower).
2013-05-11 22:08:34.240 objj [warn]:

2013-05-11 22:08:35.262 objj [warn]: Subviews autoresize mask is 3
2013-05-11 22:08:35.263 objj [warn]: Autosize setFrame: 1.672 ms. Total 836 ms.
2013-05-11 22:08:36.566 objj [warn]: Constraints setFrame: 2.344 ms. Total 1172 ms (1.4x times slower).
2013-05-11 22:08:36.568 objj [warn]:

2013-05-11 22:08:37.104 objj [warn]: Subviews autoresize mask is 4
2013-05-11 22:08:37.105 objj [warn]: Autosize setFrame: 0.738 ms. Total 369 ms.
2013-05-11 22:08:37.480 objj [warn]: Constraints setFrame: 0.616 ms. Total 308 ms (0.8x times slower).
2013-05-11 22:08:37.482 objj [warn]:

2013-05-11 22:08:38.153 objj [warn]: Subviews autoresize mask is 5
2013-05-11 22:08:38.154 objj [warn]: Autosize setFrame: 1.02 ms. Total 510 ms.
2013-05-11 22:08:38.789 objj [warn]: Constraints setFrame: 1.11 ms. Total 555 ms (1.1x times slower).
2013-05-11 22:08:38.791 objj [warn]:

2013-05-11 22:08:39.829 objj [warn]: Subviews autoresize mask is 6
2013-05-11 22:08:39.830 objj [warn]: Autosize setFrame: 1.76 ms. Total 880 ms.
2013-05-11 22:08:40.879 objj [warn]: Constraints setFrame: 1.926 ms. Total 963 ms (1.1x times slower).
2013-05-11 22:08:40.881 objj [warn]:

2013-05-11 22:08:41.886 objj [warn]: Subviews autoresize mask is 7
2013-05-11 22:08:41.887 objj [warn]: Autosize setFrame: 1.694 ms. Total 847 ms.
2013-05-11 22:08:43.182 objj [warn]: Constraints setFrame: 2.338 ms. Total 1169 ms (1.4x times slower).
2013-05-11 22:08:43.184 objj [warn]:

2013-05-11 22:08:43.880 objj [warn]: Subviews autoresize mask is 8
2013-05-11 22:08:43.881 objj [warn]: Autosize setFrame: 1.066 ms. Total 533 ms.
2013-05-11 22:08:44.591 objj [warn]: Constraints setFrame: 1.216 ms. Total 608 ms (1.1x times slower).
2013-05-11 22:08:44.593 objj [warn]:

2013-05-11 22:08:45.297 objj [warn]: Subviews autoresize mask is 9
2013-05-11 22:08:45.298 objj [warn]: Autosize setFrame: 1.068 ms. Total 534 ms.
2013-05-11 22:08:46.065 objj [warn]: Constraints setFrame: 1.274 ms. Total 637 ms (1.2x times slower).
2013-05-11 22:08:46.068 objj [warn]:

2013-05-11 22:08:47.127 objj [warn]: Subviews autoresize mask is 10
2013-05-11 22:08:47.128 objj [warn]: Autosize setFrame: 1.774 ms. Total 887 ms.
2013-05-11 22:08:48.532 objj [warn]: Constraints setFrame: 2.506 ms. Total 1253 ms (1.4x times slower).
2013-05-11 22:08:48.534 objj [warn]:

2013-05-11 22:08:49.566 objj [warn]: Subviews autoresize mask is 11
2013-05-11 22:08:49.567 objj [warn]: Autosize setFrame: 1.72 ms. Total 860 ms.
2013-05-11 22:08:51.089 objj [warn]: Constraints setFrame: 2.658 ms. Total 1329 ms (1.5x times slower).
2013-05-11 22:08:51.091 objj [warn]:

2013-05-11 22:08:51.753 objj [warn]: Subviews autoresize mask is 12
2013-05-11 22:08:51.754 objj [warn]: Autosize setFrame: 1 ms. Total 500 ms.
2013-05-11 22:08:52.545 objj [warn]: Constraints setFrame: 1.294 ms. Total 647 ms (1.3x times slower).
2013-05-11 22:08:52.548 objj [warn]:

2013-05-11 22:08:53.233 objj [warn]: Subviews autoresize mask is 13
2013-05-11 22:08:53.234 objj [warn]: Autosize setFrame: 1.012 ms. Total 506 ms.
2013-05-11 22:08:54.017 objj [warn]: Constraints setFrame: 1.326 ms. Total 663 ms (1.3x times slower).
2013-05-11 22:08:54.020 objj [warn]:

2013-05-11 22:08:55.064 objj [warn]: Subviews autoresize mask is 14
2013-05-11 22:08:55.065 objj [warn]: Autosize setFrame: 1.764 ms. Total 882 ms.
2013-05-11 22:08:56.529 objj [warn]: Constraints setFrame: 2.596 ms. Total 1298 ms (1.5x times slower).
2013-05-11 22:08:56.531 objj [warn]:

2013-05-11 22:08:57.585 objj [warn]: Subviews autoresize mask is 15
2013-05-11 22:08:57.586 objj [warn]: Autosize setFrame: 1.768 ms. Total 884 ms.
2013-05-11 22:08:59.048 objj [warn]: Constraints setFrame: 2.656 ms. Total 1328 ms (1.5x times slower).
2013-05-11 22:08:59.050 objj [warn]:

2013-05-11 22:09:00.058 objj [warn]: Subviews autoresize mask is 16
2013-05-11 22:09:00.058 objj [warn]: Autosize setFrame: 1.694 ms. Total 847 ms.
2013-05-11 22:09:01.185 objj [warn]: Constraints setFrame: 1.958 ms. Total 979 ms (1.2x times slower).
2013-05-11 22:09:01.188 objj [warn]:

2013-05-11 22:09:02.231 objj [warn]: Subviews autoresize mask is 17
2013-05-11 22:09:02.232 objj [warn]: Autosize setFrame: 1.734 ms. Total 867 ms.
2013-05-11 22:09:03.670 objj [warn]: Constraints setFrame: 2.626 ms. Total 1313 ms (1.5x times slower).
2013-05-11 22:09:03.672 objj [warn]:

2013-05-11 22:09:04.718 objj [warn]: Subviews autoresize mask is 18
2013-05-11 22:09:04.719 objj [warn]: Autosize setFrame: 1.748 ms. Total 874 ms.
2013-05-11 22:09:05.817 objj [warn]: Constraints setFrame: 1.952 ms. Total 976 ms (1.1x times slower).
2013-05-11 22:09:05.819 objj [warn]:

2013-05-11 22:09:06.876 objj [warn]: Subviews autoresize mask is 19
2013-05-11 22:09:06.877 objj [warn]: Autosize setFrame: 1.77 ms. Total 885 ms.
2013-05-11 22:09:08.390 objj [warn]: Constraints setFrame: 2.754 ms. Total 1377 ms (1.6x times slower).
2013-05-11 22:09:08.393 objj [warn]:

2013-05-11 22:09:09.378 objj [warn]: Subviews autoresize mask is 20
2013-05-11 22:09:09.378 objj [warn]: Autosize setFrame: 1.634 ms. Total 817 ms.
2013-05-11 22:09:10.618 objj [warn]: Constraints setFrame: 2.172 ms. Total 1086 ms (1.3x times slower).
2013-05-11 22:09:10.620 objj [warn]:

2013-05-11 22:09:11.604 objj [warn]: Subviews autoresize mask is 21
2013-05-11 22:09:11.605 objj [warn]: Autosize setFrame: 1.636 ms. Total 818 ms.
2013-05-11 22:09:13.069 objj [warn]: Constraints setFrame: 2.598 ms. Total 1299 ms (1.6x times slower).
2013-05-11 22:09:13.072 objj [warn]:

2013-05-11 22:09:14.122 objj [warn]: Subviews autoresize mask is 22
2013-05-11 22:09:14.122 objj [warn]: Autosize setFrame: 1.776 ms. Total 888 ms.
2013-05-11 22:09:15.206 objj [warn]: Constraints setFrame: 1.964 ms. Total 982 ms (1.1x times slower).
2013-05-11 22:09:15.208 objj [warn]:

2013-05-11 22:09:16.267 objj [warn]: Subviews autoresize mask is 23
2013-05-11 22:09:16.267 objj [warn]: Autosize setFrame: 1.79 ms. Total 895 ms.
2013-05-11 22:09:17.763 objj [warn]: Constraints setFrame: 2.748 ms. Total 1374 ms (1.5x times slower).
2013-05-11 22:09:17.765 objj [warn]:

2013-05-11 22:09:18.816 objj [warn]: Subviews autoresize mask is 24
2013-05-11 22:09:18.817 objj [warn]: Autosize setFrame: 1.774 ms. Total 887 ms.
2013-05-11 22:09:20.293 objj [warn]: Constraints setFrame: 2.72 ms. Total 1360 ms (1.5x times slower).
2013-05-11 22:09:20.295 objj [warn]:

2013-05-11 22:09:21.300 objj [warn]: Subviews autoresize mask is 25
2013-05-11 22:09:21.301 objj [warn]: Autosize setFrame: 1.66 ms. Total 830 ms.
2013-05-11 22:09:22.998 objj [warn]: Constraints setFrame: 2.908 ms. Total 1454 ms (1.8x times slower).
2013-05-11 22:09:23.000 objj [warn]:

2013-05-11 22:09:24.073 objj [warn]: Subviews autoresize mask is 26
2013-05-11 22:09:24.074 objj [warn]: Autosize setFrame: 1.802 ms. Total 901 ms.
2013-05-11 22:09:25.538 objj [warn]: Constraints setFrame: 2.63 ms. Total 1315 ms (1.5x times slower).
2013-05-11 22:09:25.540 objj [warn]:

2013-05-11 22:09:26.688 objj [warn]: Subviews autoresize mask is 27
2013-05-11 22:09:26.689 objj [warn]: Autosize setFrame: 1.93 ms. Total 965 ms.
2013-05-11 22:09:28.209 objj [warn]: Constraints setFrame: 2.718 ms. Total 1359 ms (1.4x times slower).
2013-05-11 22:09:28.211 objj [warn]:

2013-05-11 22:09:29.287 objj [warn]: Subviews autoresize mask is 28
2013-05-11 22:09:29.287 objj [warn]: Autosize setFrame: 1.822 ms. Total 911 ms.
2013-05-11 22:09:30.647 objj [warn]: Constraints setFrame: 2.49 ms. Total 1245 ms (1.4x times slower).
2013-05-11 22:09:30.649 objj [warn]:

2013-05-11 22:09:31.742 objj [warn]: Subviews autoresize mask is 29
2013-05-11 22:09:31.743 objj [warn]: Autosize setFrame: 1.862 ms. Total 931 ms.
2013-05-11 22:09:33.206 objj [warn]: Constraints setFrame: 2.664 ms. Total 1332 ms (1.4x times slower).
2013-05-11 22:09:33.208 objj [warn]:

2013-05-11 22:09:34.299 objj [warn]: Subviews autoresize mask is 30
2013-05-11 22:09:34.300 objj [warn]: Autosize setFrame: 1.852 ms. Total 926 ms.
2013-05-11 22:09:35.779 objj [warn]: Constraints setFrame: 2.698 ms. Total 1349 ms (1.5x times slower).
2013-05-11 22:09:35.781 objj [warn]:

2013-05-11 22:09:36.877 objj [warn]: Subviews autoresize mask is 31
2013-05-11 22:09:36.878 objj [warn]: Autosize setFrame: 1.87 ms. Total 935 ms.
2013-05-11 22:09:38.501 objj [warn]: Constraints setFrame: 2.936 ms. Total 1468 ms (1.6x times slower).
2013-05-11 22:09:38.503 objj [warn]:

2013-05-11 22:09:39.008 objj [warn]: Subviews autoresize mask is 32
2013-05-11 22:09:39.009 objj [warn]: Autosize setFrame: 0.692 ms. Total 346 ms.
2013-05-11 22:09:39.457 objj [warn]: Constraints setFrame: 0.776 ms. Total 388 ms (1.1x times slower).
2013-05-11 22:09:39.460 objj [warn]:

2013-05-11 22:09:40.126 objj [warn]: Subviews autoresize mask is 33
2013-05-11 22:09:40.126 objj [warn]: Autosize setFrame: 1.002 ms. Total 501 ms.
2013-05-11 22:09:40.979 objj [warn]: Constraints setFrame: 1.51 ms. Total 755 ms (1.5x times slower).
2013-05-11 22:09:40.981 objj [warn]:

2013-05-11 22:09:41.959 objj [warn]: Subviews autoresize mask is 34
2013-05-11 22:09:41.960 objj [warn]: Autosize setFrame: 1.63 ms. Total 815 ms.
2013-05-11 22:09:43.093 objj [warn]: Constraints setFrame: 2.072 ms. Total 1036 ms (1.3x times slower).
2013-05-11 22:09:43.095 objj [warn]:

2013-05-11 22:09:44.183 objj [warn]: Subviews autoresize mask is 35
2013-05-11 22:09:44.184 objj [warn]: Autosize setFrame: 1.854 ms. Total 927 ms.
2013-05-11 22:09:45.558 objj [warn]: Constraints setFrame: 2.508 ms. Total 1254 ms (1.4x times slower).
2013-05-11 22:09:45.560 objj [warn]:

2013-05-11 22:09:46.065 objj [warn]: Subviews autoresize mask is 36
2013-05-11 22:09:46.066 objj [warn]: Autosize setFrame: 0.69 ms. Total 345 ms.
2013-05-11 22:09:46.525 objj [warn]: Constraints setFrame: 0.784 ms. Total 392 ms (1.1x times slower).
2013-05-11 22:09:46.527 objj [warn]:

2013-05-11 22:09:47.190 objj [warn]: Subviews autoresize mask is 37
2013-05-11 22:09:47.191 objj [warn]: Autosize setFrame: 0.986 ms. Total 493 ms.
2013-05-11 22:09:47.982 objj [warn]: Constraints setFrame: 1.434 ms. Total 717 ms (1.5x times slower).
2013-05-11 22:09:47.985 objj [warn]:

2013-05-11 22:09:48.970 objj [warn]: Subviews autoresize mask is 38
2013-05-11 22:09:48.971 objj [warn]: Autosize setFrame: 1.648 ms. Total 824 ms.
2013-05-11 22:09:50.138 objj [warn]: Constraints setFrame: 2.166 ms. Total 1083 ms (1.3x times slower).
2013-05-11 22:09:50.141 objj [warn]:

2013-05-11 22:09:51.152 objj [warn]: Subviews autoresize mask is 39
2013-05-11 22:09:51.152 objj [warn]: Autosize setFrame: 1.704 ms. Total 852 ms.
2013-05-11 22:09:52.689 objj [warn]: Constraints setFrame: 2.646 ms. Total 1323 ms (1.6x times slower).
2013-05-11 22:09:52.692 objj [warn]:

2013-05-11 22:09:53.350 objj [warn]: Subviews autoresize mask is 40
2013-05-11 22:09:53.351 objj [warn]: Autosize setFrame: 0.982 ms. Total 491 ms.
2013-05-11 22:09:53.976 objj [warn]: Constraints setFrame: 1.092 ms. Total 546 ms (1.1x times slower).
2013-05-11 22:09:53.978 objj [warn]:

2013-05-11 22:09:54.747 objj [warn]: Subviews autoresize mask is 41
2013-05-11 22:09:54.748 objj [warn]: Autosize setFrame: 1.212 ms. Total 606 ms.
2013-05-11 22:09:55.498 objj [warn]: Constraints setFrame: 1.268 ms. Total 634 ms (1x times slower).
2013-05-11 22:09:55.500 objj [warn]:

2013-05-11 22:09:56.494 objj [warn]: Subviews autoresize mask is 42
2013-05-11 22:09:56.495 objj [warn]: Autosize setFrame: 1.652 ms. Total 826 ms.
2013-05-11 22:09:58.004 objj [warn]: Constraints setFrame: 2.59 ms. Total 1295 ms (1.6x times slower).
2013-05-11 22:09:58.006 objj [warn]:

2013-05-11 22:09:59.006 objj [warn]: Subviews autoresize mask is 43
2013-05-11 22:09:59.007 objj [warn]: Autosize setFrame: 1.672 ms. Total 836 ms.
2013-05-11 22:10:00.551 objj [warn]: Constraints setFrame: 2.82 ms. Total 1410 ms (1.7x times slower).
2013-05-11 22:10:00.553 objj [warn]:

2013-05-11 22:10:01.206 objj [warn]: Subviews autoresize mask is 44
2013-05-11 22:10:01.207 objj [warn]: Autosize setFrame: 0.988 ms. Total 494 ms.
2013-05-11 22:10:01.993 objj [warn]: Constraints setFrame: 1.426 ms. Total 713 ms (1.4x times slower).
2013-05-11 22:10:01.995 objj [warn]:

2013-05-11 22:10:02.666 objj [warn]: Subviews autoresize mask is 45
2013-05-11 22:10:02.667 objj [warn]: Autosize setFrame: 1.02 ms. Total 510 ms.
2013-05-11 22:10:03.533 objj [warn]: Constraints setFrame: 1.534 ms. Total 767 ms (1.5x times slower).
2013-05-11 22:10:03.536 objj [warn]:

2013-05-11 22:10:04.537 objj [warn]: Subviews autoresize mask is 46
2013-05-11 22:10:04.537 objj [warn]: Autosize setFrame: 1.678 ms. Total 839 ms.
2013-05-11 22:10:06.009 objj [warn]: Constraints setFrame: 2.75 ms. Total 1375 ms (1.6x times slower).
2013-05-11 22:10:06.011 objj [warn]:

2013-05-11 22:10:07.019 objj [warn]: Subviews autoresize mask is 47
2013-05-11 22:10:07.020 objj [warn]: Autosize setFrame: 1.692 ms. Total 846 ms.
2013-05-11 22:10:08.584 objj [warn]: Constraints setFrame: 2.622 ms. Total 1311 ms (1.5x times slower).
2013-05-11 22:10:08.586 objj [warn]:

2013-05-11 22:10:09.679 objj [warn]: Subviews autoresize mask is 48
2013-05-11 22:10:09.680 objj [warn]: Autosize setFrame: 1.864 ms. Total 932 ms.
2013-05-11 22:10:10.722 objj [warn]: Constraints setFrame: 1.922 ms. Total 961 ms (1x times slower).
2013-05-11 22:10:10.724 objj [warn]:

2013-05-11 22:10:11.853 objj [warn]: Subviews autoresize mask is 49
2013-05-11 22:10:11.854 objj [warn]: Autosize setFrame: 1.924 ms. Total 962 ms.
2013-05-11 22:10:13.356 objj [warn]: Constraints setFrame: 2.77 ms. Total 1385 ms (1.4x times slower).
2013-05-11 22:10:13.358 objj [warn]:

2013-05-11 22:10:14.357 objj [warn]: Subviews autoresize mask is 50
2013-05-11 22:10:14.357 objj [warn]: Autosize setFrame: 1.648 ms. Total 824 ms.
2013-05-11 22:10:15.544 objj [warn]: Constraints setFrame: 2.168 ms. Total 1084 ms (1.3x times slower).
2013-05-11 22:10:15.546 objj [warn]:

2013-05-11 22:10:16.540 objj [warn]: Subviews autoresize mask is 51
2013-05-11 22:10:16.541 objj [warn]: Autosize setFrame: 1.662 ms. Total 831 ms.
2013-05-11 22:10:18.103 objj [warn]: Constraints setFrame: 2.846 ms. Total 1423 ms (1.7x times slower).
2013-05-11 22:10:18.105 objj [warn]:

2013-05-11 22:10:19.209 objj [warn]: Subviews autoresize mask is 52
2013-05-11 22:10:19.210 objj [warn]: Autosize setFrame: 1.888 ms. Total 944 ms.
2013-05-11 22:10:20.264 objj [warn]: Constraints setFrame: 1.94 ms. Total 970 ms (1x times slower).
2013-05-11 22:10:20.266 objj [warn]:

2013-05-11 22:10:21.397 objj [warn]: Subviews autoresize mask is 53
2013-05-11 22:10:21.398 objj [warn]: Autosize setFrame: 1.944 ms. Total 972 ms.
2013-05-11 22:10:22.906 objj [warn]: Constraints setFrame: 2.822 ms. Total 1411 ms (1.5x times slower).
2013-05-11 22:10:22.908 objj [warn]:

2013-05-11 22:10:23.897 objj [warn]: Subviews autoresize mask is 54
2013-05-11 22:10:23.898 objj [warn]: Autosize setFrame: 1.654 ms. Total 827 ms.
2013-05-11 22:10:25.095 objj [warn]: Constraints setFrame: 2.208 ms. Total 1104 ms (1.3x times slower).
2013-05-11 22:10:25.097 objj [warn]:

2013-05-11 22:10:26.106 objj [warn]: Subviews autoresize mask is 55
2013-05-11 22:10:26.107 objj [warn]: Autosize setFrame: 1.698 ms. Total 849 ms.
2013-05-11 22:10:27.666 objj [warn]: Constraints setFrame: 2.888 ms. Total 1444 ms (1.7x times slower).
2013-05-11 22:10:27.668 objj [warn]:

2013-05-11 22:10:28.645 objj [warn]: Subviews autoresize mask is 56
2013-05-11 22:10:28.646 objj [warn]: Autosize setFrame: 1.634 ms. Total 817 ms.
2013-05-11 22:10:30.143 objj [warn]: Constraints setFrame: 2.788 ms. Total 1394 ms (1.7x times slower).
2013-05-11 22:10:30.145 objj [warn]:

2013-05-11 22:10:31.157 objj [warn]: Subviews autoresize mask is 57
2013-05-11 22:10:31.158 objj [warn]: Autosize setFrame: 1.692 ms. Total 846 ms.
2013-05-11 22:10:32.802 objj [warn]: Constraints setFrame: 2.686 ms. Total 1343 ms (1.6x times slower).
2013-05-11 22:10:32.804 objj [warn]:

2013-05-11 22:10:33.944 objj [warn]: Subviews autoresize mask is 58
2013-05-11 22:10:33.945 objj [warn]: Autosize setFrame: 1.952 ms. Total 976 ms.
2013-05-11 22:10:35.391 objj [warn]: Constraints setFrame: 2.646 ms. Total 1323 ms (1.4x times slower).
2013-05-11 22:10:35.393 objj [warn]:

2013-05-11 22:10:36.550 objj [warn]: Subviews autoresize mask is 59
2013-05-11 22:10:36.551 objj [warn]: Autosize setFrame: 1.988 ms. Total 994 ms.
2013-05-11 22:10:38.122 objj [warn]: Constraints setFrame: 2.838 ms. Total 1419 ms (1.4x times slower).
2013-05-11 22:10:38.124 objj [warn]:

2013-05-11 22:10:39.270 objj [warn]: Subviews autoresize mask is 60
2013-05-11 22:10:39.271 objj [warn]: Autosize setFrame: 1.968 ms. Total 984 ms.
2013-05-11 22:10:40.754 objj [warn]: Constraints setFrame: 2.766 ms. Total 1383 ms (1.4x times slower).
2013-05-11 22:10:40.757 objj [warn]:

2013-05-11 22:10:41.772 objj [warn]: Subviews autoresize mask is 61
2013-05-11 22:10:41.773 objj [warn]: Autosize setFrame: 1.702 ms. Total 851 ms.
2013-05-11 22:10:43.368 objj [warn]: Constraints setFrame: 2.966 ms. Total 1483 ms (1.7x times slower).
2013-05-11 22:10:43.370 objj [warn]:

2013-05-11 22:10:44.381 objj [warn]: Subviews autoresize mask is 62
2013-05-11 22:10:44.382 objj [warn]: Autosize setFrame: 1.7 ms. Total 850 ms.
2013-05-11 22:10:45.960 objj [warn]: Constraints setFrame: 2.908 ms. Total 1454 ms (1.7x times slower).
2013-05-11 22:10:45.962 objj [warn]:

2013-05-11 22:10:47.007 objj [warn]: Subviews autoresize mask is 63
2013-05-11 22:10:47.008 objj [warn]: Autosize setFrame: 1.766 ms. Total 883 ms.
2013-05-11 22:10:48.665 objj [warn]: Constraints setFrame: 3.006 ms. Total 1503 ms (1.7x times slower).
2013-05-11 22:10:48.668 objj [warn]:
*/