#Autolayout

**Autolayout in cappuccino based on** [Cassowary.js](https://github.com/slightlyoff/cassowary.js) and 
[Original Cassowary from Badros and Borning](http://www.cs.washington.edu/research/constraints/cassowary/)

**Online demos:**
[Constraints Editor](http://cacaodev.github.io/Autolayout/ConstraintEditor/) | [Quadrilateral Demo](https://cacaodev.github.io/Autolayout/QuadrilateralDemo/)

**Other visual tests are at Tests/Manual/Autolayout/ in the repo**

*TODO:*

- [x] Call CPWindow -layout at appropriate time in the FMW.
- [x] -layout should be `-layoutIfNeeded` : figure out what "ifNeeded" means: constraints update, frames out of sync.
- [ ] Rounding errors (multiplier) and integralization.
- [ ] Implement `-baselineOffsetFromBottom` in all controls.
- [ ] Implement `-alignmentRectInsets` in controls where relevant. Use theme attribute. Note: what about nib2cib conversion ? when we adjust frames in nib2cib we will need to also adjust constraints constants.
- [ ] call `-invalidateIntrinsicContentSize` in controls when appropriate (the content changes). Currently done in CPButton & subclasses.
- [-] Decide how autosize and autolayout can live together. We should explcitely declare CPView subclasses that refuse to be involved in Autolayout and continue to use Autosize or custom layoutSubviews. This should be done in the FMW and we should make sure that all CPView classes created in the FMW are subclasses, not plain CPView.
CPView +(BOOL)requiresAutoSize
- [x] -CPView -layout and layoutSubtree : do we update constraints and frames for the descendants only or all constraints affecting the receiver ?
- [x] translateAutoresizingMask default is NO currently. Should be YES for initWithFrame: views.
- [ ] Handle removeSubview: , when a view moves from a window to another (different engines) and in general situations where the engine frames and the local frame are out of sync.
- [ ] compute -fittingSize in controls. The computation should take care of constraints and CPLayoutPriorityFittingSize
- [x] ojtest comparing autosize and autolayout.
- [ ] In capp, the contentView size is 2px < than the windowView, in cocoa/IB they are ==. Is this a problem ?
- [ ] Rewrite CPSplitView with constraints ! CPSplitview drag = user input with a given priority.
- [x] Write a Quadrilatere demo in capp. currently i don't think it can be done with the cocoa API where a constraint can link no more than 2 items. Maybe by abstracting constraint items with a protocol ?
- [ ] Handle ambiguous layout and solver failures. The Apple way is to lower the priority on a constraint and try to resolve.
- [x] CPLayoutPriorityRequired should be a c.Strength.required. Currently medium with weight 1000. required causes problems when they are stay constraints and edit constraints and you try to remove them.
- [ ] Visual debug support
- [ ] Parser API. Visual language with PEGJS grammar like Angular.js ?
- [ ] Currently, when you resize a window from the left or top edge and the window size is constrained by subviews constraints, the window frameOrigin changes. It should not (add a stay constraint on WindowView x and y ?).

[![Build Status](https://travis-ci.org/cappuccino/cappuccino.svg?branch=master)](https://travis-ci.org/cappuccino/cappuccino) [![Join the chat at https://gitter.im/cappuccino/cappuccino](https://badges.gitter.im/cappuccino/cappuccino.svg)](https://gitter.im/cappuccino/cappuccino?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Welcome to Cappuccino!
======================

Introduction
------------
Cappuccino is an open source framework that makes it easy to build
desktop-caliber applications that run in a web browser.

With Cappuccino, you don't concern yourself with HTML, CSS, or the DOM. You  write applications with the APIs from Apple's Cocoa frameworks and the Objective-J language.

Check out a [live demo of the widgets in Cappuccino](https://cappuccino-testbook.5apps.com/#ThemeKitchenSink)

Check out some [live demos and tutorials](https://cappuccino-cookbook.5apps.com)

For more information, see the
  - [Official website](http://cappuccino-project.org)
  - [Github Wiki](https://github.com/cappuccino/cappuccino/wiki)
  - [FAQ](http://cappuccino-project.org/support/faq.html)
  - [Documentation](http://cappuccino-project.org/learn/)
  - [Mailing list](http://groups.google.com/group/objectivej)
  - [Gitter](https://gitter.im/cappuccino/cappuccino)

Follow [@cappuccino](https://twitter.com/cappuccino) on Twitter for updates on the project.

If you discover any bugs, please [file a ticket](http://github.com/cappuccino/cappuccino/issues).

System Requirements
-------------------
To run Cappuccino applications, all you need is a HTML5 compliant web browser.

Our tight integration with Xcode on MacOS brings the full power of visual Cocoa development to the web.

However, you can also work on other platforms using only a simple text editor.

Getting Started
---------------
To write you first application, [download the starter package](http://www.cappuccino-project.org/#download).

To contribute to Cappuccino, please read here: [Getting and Building the Source](http://wiki.github.com/cappuccino/cappuccino/getting-and-building-the-source).

License
-------
This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option)
any later version.

This library is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 51
Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
