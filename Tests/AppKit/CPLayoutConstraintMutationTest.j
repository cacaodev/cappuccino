
@import <AppKit/AppKit.j>
@import <Foundation/Foundation.j>

#define XCTAssertEqual(a, b) [self assert:b equals:a];
#define XCTAssertTrue(a) [self assertTrue:a]
#define XCTAssertFalse(a) [self assertFalse:a]
#define XCTAssertApprox(a, b, c) [self assertTrue:(ABS(a - b) <= c) message:"Expected " + b + " but was " + a];

@implementation CPLayoutConstraintMutationTest : OJTestCase
{
    CPView contentView;
}

- (void)setUp
{
     contentView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
     [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
}

- (void)testSetPriorityAndLayout
{
     var sub = [[CPView alloc] initWithFrame:CGRectMakeZero()];
     [sub setTranslatesAutoresizingMaskIntoConstraints:NO];
     [contentView addSubview:sub];

     [[[sub leftAnchor] constraintEqualToAnchor:[contentView leftAnchor] constant:10] setActive:YES];
     [[[sub topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:10] setActive:YES];
     var width = [[sub widthAnchor] constraintEqualToConstant:50];
     [width setPriority:900];
     [width setActive:YES];
     [[[sub heightAnchor] constraintEqualToConstant:50] setActive:YES];

     [contentView layoutSubtreeIfNeeded];
     XCTAssertEqual(CGRectGetWidth([sub frame]), 50);

     var width2 = [[sub widthAnchor] constraintEqualToConstant:70];
     [width2 setPriority:950];
     [width2 setActive:YES];
     [contentView layoutSubtreeIfNeeded];

     XCTAssertEqual(CGRectGetWidth([sub frame]), 70);
     [width2 setPriority:800];
     [contentView layoutSubtreeIfNeeded];

     XCTAssertFalse([sub needsUpdateConstraints]);
     XCTAssertEqual(CGRectGetWidth([sub frame]), 50);
 }


 - (void)testSetConstantAndLayout
 {
      var sub = [[CPView alloc] initWithFrame:CGRectMakeZero()];
      [sub setTranslatesAutoresizingMaskIntoConstraints:NO];
      [contentView addSubview:sub];

      [[[sub leftAnchor] constraintEqualToAnchor:[contentView leftAnchor] constant:10] setActive:YES];
      [[[sub topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:10] setActive:YES];
      var width = [[sub widthAnchor] constraintEqualToConstant:50];
      [width setActive:YES];
      [[[sub heightAnchor] constraintEqualToConstant:50] setActive:YES];

      [contentView layoutSubtreeIfNeeded];
      XCTAssertEqual(CGRectGetWidth([sub frame]), 50);

      [width setConstant:70];
      [contentView layoutSubtreeIfNeeded];

      XCTAssertFalse([sub needsUpdateConstraints]);
      XCTAssertEqual(CGRectGetWidth([sub frame]), 70);
  }

@end

/*
// Playground test
import Cocoa

import Cocoa
import PlaygroundSupport
import XCTest

class ConstraintTest : XCTestCase {

    var contentView : NSView?

    override func setUp() {
        contentView = NSView(frame:CGRect(x:0, y:0, width:100, height:100))
        contentView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func testSetPriorityAndLayout() -> Void {
        let sub = NSView(frame:.zero)
        sub.translatesAutoresizingMaskIntoConstraints = false
        contentView?.addSubview(sub)
        sub.leftAnchor.constraint(equalTo: (contentView?.leftAnchor)!, constant: 10).isActive = true
        sub.topAnchor.constraint(equalTo: (contentView?.topAnchor)!, constant: 10).isActive = true
        let width = sub.widthAnchor.constraint(equalToConstant: 50)
        width.priority = 900
        width.isActive = true
        sub.heightAnchor.constraint(equalToConstant: 50).isActive = true

        contentView?.layoutSubtreeIfNeeded()
        XCTAssertEqual(sub.frame.width, 50)

        let width2 = sub.widthAnchor.constraint(equalToConstant: 70)
        width2.priority = 950
        width2.isActive = true
        contentView?.layoutSubtreeIfNeeded()

        XCTAssertEqual(sub.frame.width, 70)

        width2.priority = 900
        contentView?.layoutSubtreeIfNeeded()

        XCTAssertFalse(sub.needsUpdateConstraints)
        XCTAssertEqual(sub.frame.width, 50)
    }
}

let suite = XCTestSuite(forTestCaseClass: ConstraintTest.self)
suite.run()
*/
