#Autolayout

**Autolayout in cappuccino based on** [Cassowary.js](https://github.com/slightlyoff/cassowary.js) and 
[Original Cassowary from Badros and Borning](http://www.cs.washington.edu/research/constraints/cassowary/)

**Online demos:**
[Constraints Editor](http://cacaodev.github.io/Autolayout/ConstraintEditor/) | [Quadrilateral Demo](https://cacaodev.github.io/Autolayout/QuadrilateralDemo/)

**Other visual tests are at Tests/Manual/Autolayout/ in the repo**

*TODO:*

- [ ] Rounding errors (multiplier) and integralization.
- [ ] Implement `-baselineOffsetFromBottom` in all controls.
- [ ] Implement `-alignmentRectInsets` in controls where relevant. Use theme attribute. Note: what about nib2cib conversion ? when we adjust frames in nib2cib we will need to also adjust constraints constants.
- [ ] call `-invalidateIntrinsicContentSize` in controls when appropriate (the content changes). Currently done in CPButton & subclasses.
- [x] -CPView -layout and layoutSubtree : do we update constraints and frames for the descendants only or all constraints affecting the receiver ?
- [ ] compute -fittingSize in controls. The computation should take care of constraints and CPLayoutPriorityFittingSize
- [ ] In capp, the contentView size is 2px < than the windowView, in cocoa/IB they are ==. Is this a problem ?
- [ ] Rewrite CPSplitView with constraints ! CPSplitview drag = user input with a given priority.
- [ ] Handle ambiguous layout and solver failures. The Apple way is to lower the priority on a constraint and try to resolve.
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
