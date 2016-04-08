@import <AppKit/CPViewController.j>
@import <AppKit/CPApplication.j>

var methodsCalled;

@implementation CPViewControllerTest : OJTestCase
{
    CPBundle bundle;
}

- (void)setUp
{
    bundle = [CPBundle bundleWithPath:@"Tests/AppKit/BundleTest"];
    [bundle loadWithDelegate:self];
}

- (void)bundleDidFinishLoading:(CPBundle)aBundle
{

}

- (void)testViewControllerCallbacks
{
    methodsCalled = @[];

    var expectedResult = @[@"viewDidLoad",
        @"viewWillAppear",
        @"viewDidAppear",
        @"viewWillDisappear",
        @"viewDidDisappear"
    ];

    [self assertTrue:[bundle isLoaded]];
    var viewController = [[ViewController alloc] initWithCibName:@"NSViewController.cib" bundle:bundle];
    [self assertNotNull:viewController];

    var superview = [[CPView  alloc] initWithFrame:CGRectMakeZero()];
    var view = [viewController view];

    [superview addSubview:view];
    [view removeFromSuperview];
    [self assert:expectedResult equals:methodsCalled];
}

@end

@implementation ViewController : CPViewController
{
}

- (void)viewDidLoad
{
    [methodsCalled addObject:_cmd];
}

- (void)viewDidAppear
{
    [methodsCalled addObject:_cmd];
}

- (void)viewWillAppear
{
    [methodsCalled addObject:_cmd];
}

- (void)viewDidDisappear
{
    [methodsCalled addObject:_cmd];
}

- (void)viewWillDisappear
{
    [methodsCalled addObject:_cmd];
}
@end
