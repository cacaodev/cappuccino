
@import <AppKit/AppKit.j>
@import <Foundation/Foundation.j>

#define XCTAssertEqual(a, b) [self assert:b equals:a]
#define XCTAssertTrue(a) [self assertTrue:a]
#define XCTAssertFalse(a) [self assertFalse:a]
#define XCTAssertApprox(a, b, c) [self assertTrue:(ABS(a - b) <= c) message:"Expected " + b + " but was " + a]

@implementation CPLayoutConstraintCompatibilityTest : OJTestCase
{
    CPView contentView;
}

- (void)setUp
{
     contentView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
     [contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
}


- (void)testSetFrameConflictsWithExplicitConstraint
{
    var sub = [[CPView alloc] initWithFrame:CGRectMakeZero()];
    [sub setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:sub];

    [[[sub leftAnchor] constraintEqualToAnchor:[contentView leftAnchor] constant:10] setActive:YES];
    [[[sub topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:10] setActive:YES];
    [[[sub heightAnchor] constraintEqualToConstant:50] setActive:YES];
    var widthConstraint = [[sub widthAnchor] constraintEqualToConstant:50];
    [widthConstraint setActive:YES];

    [contentView layoutSubtreeIfNeeded];

    XCTAssertEqual([[contentView constraints] count], 2);
    XCTAssertEqual([[sub constraints] count], 2);
    XCTAssertEqual(CGRectGetWidth([sub frame]), 50);

    var newFrame = CGRectMakeCopy([sub frame]);
    newFrame.size.width = 20;
    [sub setFrame:newFrame];

    // The effective width changed accordingly.
    XCTAssertEqual(CGRectGetWidth([sub frame]), 20);
    // The constraint managing the width did not change.
    XCTAssertEqual([widthConstraint constant], 50);

    [contentView layoutSubtreeIfNeeded];

    // The width have been restaured with the constraint value.
    XCTAssertEqual(CGRectGetWidth([sub frame]), 50);
}

- (void)testSetFrameConflictsWithAutoresizingConstraint
{
    for (var m = 0; m < 64; m++)
    {
        var sub = [[CPView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [sub setAutoresizingMask:m];
        [sub setTranslatesAutoresizingMaskIntoConstraints:YES];
        [contentView addSubview:sub];

        [contentView layoutSubtreeIfNeeded];

        XCTAssertTrue(CGRectEqualToRect([sub frame], CGRectMake(10, 10, 50, 50)));

        // Explicitely set the frame
        [sub setFrame:CGRectMake(5, 5, 20, 20)];

        // The effective frame changed accordingly.
        XCTAssertTrue(CGRectEqualToRect([sub frame], CGRectMake(5, 5, 20, 20)));

        [contentView layoutSubtreeIfNeeded];

        // The frame stays with the explicitely modified value after an Autolayout layout pass.
        var f = [sub frame];
        XCTAssertApprox(CGRectGetMinX(f), 5, POW(10, -2));
        XCTAssertApprox(CGRectGetMinY(f), 5, POW(10, -2));
        XCTAssertApprox(CGRectGetWidth(f), 20, POW(10, -2));
        XCTAssertApprox(CGRectGetHeight(f), 20, POW(10, -2));
    }
}

@end

/*
// Playground test
import Cocoa
import PlaygroundSupport
import XCTest

class ConstraintTest : XCTestCase {

    var contentView : NSView?

    override func setUp() {
        contentView = NSView(frame:CGRect(x:0, y:0, width:100, height:100))
        contentView?.translatesAutoresizingMaskIntoConstraints = true
    }

    func testSetFrameConflictsWithExplicitConstraint() -> Void {
        let sub = NSView(frame:.zero)
        sub.translatesAutoresizingMaskIntoConstraints = false
        contentView?.addSubview(sub)

        sub.leftAnchor.constraint(equalTo: (contentView?.leftAnchor)!, constant:10).isActive = true
        sub.topAnchor.constraint(equalTo: (contentView?.topAnchor)!, constant:10).isActive = true
        sub.widthAnchor.constraint(equalToConstant:20).isActive = true
        sub.heightAnchor.constraint(equalToConstant:20).isActive = true

        contentView?.layoutSubtreeIfNeeded()

        XCTAssertEqual(contentView?.constraints.count, 2)
        XCTAssertEqual(sub.constraints.count, 2)
        XCTAssertEqual(sub.frame, CGRect(x: 10, y: 10, width: 20, height: 20))

        let originalConstraints:NSArray = (sub.constraints as NSArray).copy() as! NSArray

        sub.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        XCTAssertEqual(sub.frame, CGRect(x: 10, y: 10, width: 50, height: 50))

        contentView?.layoutSubtreeIfNeeded()
        XCTAssertEqual(sub.frame, CGRect(x: 10, y: 10, width: 20, height: 20))

        XCTAssertEqual(sub.constraints as NSArray, originalConstraints)
     }

     func testSetFrameConflictsWithAutoresizingConstraint() -> Void {
          let sub = NSView(frame:CGRect(x:10, y:10, width:50, height:50))
          sub.translatesAutoresizingMaskIntoConstraints = true

          XCTAssertEqual(contentView?.constraints.count, 0)

          contentView?.addSubview(sub)
          contentView?.layoutSubtreeIfNeeded()

          let cst1:NSLayoutConstraint = (contentView?.constraints.filter({ (cst:NSLayoutConstraint) -> Bool in
              return cst.firstItem == sub && cst.firstAttribute == .width
          }).last)!

          XCTAssertEqual(cst1.constant, 50)
          XCTAssertEqual(contentView?.constraints.count, 4)
          XCTAssertEqual(sub.frame, CGRect(x: 10, y: 10, width: 50, height: 50))

          sub.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
          XCTAssertEqual(sub.frame, CGRect(x: 10, y: 10, width: 20, height: 20))

          contentView?.layoutSubtreeIfNeeded()
          XCTAssertEqual(sub.frame, CGRect(x: 10, y: 10, width: 20, height: 20))

          XCTAssertEqual(cst1.constant, 20)
      }
}

let suite = XCTestSuite(forTestCaseClass: ConstraintTest.self)
suite.run()
*/
