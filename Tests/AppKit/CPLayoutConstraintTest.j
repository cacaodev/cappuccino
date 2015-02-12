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
- (void)testAddConstraint
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

    [view addObserver:self forKeyPath:@"constraints" options:CPKeyValueObservingOptionOld | CPKeyValueObservingOptionNew context:@"add"];

    var constraint1 = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];
    [view addConstraint:constraint1];

    [self assert:1 equals:[[view constraints] count]];

    var constraint2 = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    // Add a new constraint object equal to an installed constraint.
    [view addConstraint:constraint2];

    [self assert:2 equals:[[view constraints] count]];

    [view removeObserver:self forKeyPath:@"constraints"];
}

- (void)testRemoveConstraint
{
    var view = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

    var constraint1 = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    var constraint2 = [CPLayoutConstraint constraintWithItem:view attribute:CPLayoutAttributeWidth relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:1 constant:100];

    [view addConstraints:[constraint1, constraint2]];

    [view addObserver:self forKeyPath:@"constraints" options:CPKeyValueObservingOptionOld | CPKeyValueObservingOptionNew context:@"remove"];

    [view removeConstraint:constraint2];

    [self assert:1 equals:[[view constraints] count]];
    [self assert:constraint1 equals:[[view constraints] firstObject]];

    [view removeObserver:self forKeyPath:@"constraints"];
}

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change                        context:(void)context
{
    [self assert:@"constraints" equals:keyPath];

    if (context == @"add")
        [self assert:CPKeyValueChangeInsertion equals:[change objectForKey:CPKeyValueChangeKindKey]];

    if (context == @"remove")
        [self assert:CPKeyValueChangeRemoval equals:[change objectForKey:CPKeyValueChangeKindKey]];
}

@end
