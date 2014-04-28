#Autolayout

**Autolayout in cappuccino based on [Cassowary.js](https://github.com/slightlyoff/cassowary.js)**

[Original Cassowary from Badros and Borning](http://www.cs.washington.edu/research/constraints/cassowary/)

#Online demos:
[Constraints Editor](http://cacaodev.pagesperso-orange.fr/Tests/Manual/CPLayoutConstraint/CPLayoutConstraintTest/)
[Intrinsic Content Size](http://cacaodev.pagesperso-orange.fr/Tests/Manual/CPLayoutConstraint/InvalidateIntrinsicContentSizeTest/)
[CPAlert with constraints](http://cacaodev.pagesperso-orange.fr/Tests/Manual/CPLayoutConstraint/CPLayoutConstraintCibTest/)

###TODO:

- Call CPWindow -layout at appropriate time in the FMW.
- -layout should be `-layoutIfNeeded` : figure out what "ifNeeded" means: constraints update, frames out of sync.
- Implement `-baselineOffsetFromBottom` in controls where relevant.
- Implement `-alignmentRectInsets` in controls where relevant. Note: what about nib2cib conversion ? when we adjust frames in nib2cib we will need to also adjust constraints constants.
- Decide how autosize and autolayout can live together. Apple: on a view basis, certainly to make adoption easier. On a CPWindow basis is enough for us but ... we still need to handle private views with masks (created in code or in IB). <- done.
- -layoutSubviews is not tested. It should continue to work.
- Default constraints when a view is added to its superview ? currently none.
- Handle addSubview: , removeSubview: , when a view moves from a window to another (different engines) and in general situations where the engine frames and the local frame are out of sync.
- call `-invalidateIntrinsicContentSize` in controls when appropriate (the content changes). Currently done in CPButton & subclasses.
- compute -fittingSize in controls. The computation should take care of constraints and CPLayoutPriorityFittingSize
- ojtest Tests comparing autosize and autolayout.
- In capp, the contentView size is 2px < than the windowView, in cocoa/IB they are ==. Is this a problem ?
- Rewrite CPSplitView with constraints ! CPSplitview drag = user input with a given priority.
- Write a Quadrilatere demo in capp. currently i don't think it can be done with the cocoa API where a constraint can link no more than 2 items. Maybe by abstracting item variables with a protocol ?
- Detect when cassowary variables are mutually exclusive ? And create separate solvers for each independant group of constraints ? In a web worker working in //
- Do not import cassowary files twice when the WebWorker is enabled and imports files itself.

Welcome to Cappuccino!
======================

Introduction
------------
Cappuccino is an open source framework that makes it easy to build
desktop-caliber applications that run in a web browser.

Cappuccino is built on top of standard web technologies like JavaScript, and
it implements most of the familiar APIs from GNUstep and Apple's Cocoa
frameworks. When you program in Cappuccino, you don't need to concern yourself
with the complexities of traditional web technologies like HTML, CSS, or even
the DOM. The unpleasantries of building complex cross browser applications are
abstracted away for you.

For more information, see <http://cappuccino-project.org>.

System Requirements
-------------------
To run Cappuccino applications, all you need is a web browser that understands
JavaScript.

To build Cappuccino itself, please read below. More information is available
here: [Getting and Building the Source](http://wiki.github.com/cappuccino/cappuccino/getting-and-building-the-source>).

If you're using Windows, you'll also need [Cygwin](http://www.cygwin.com/).

Finally, if you want to easily stay up to date with the latest developments
and contribute your work back to the Cappuccino community, you'll want to
[install Git](http://git-scm.com/).

Getting Started
---------------
To get started, download and install the current release version of Cappuccino:

    $ curl https://raw.github.com/cappuccino/cappuccino/v0.9.7/bootstrap.sh >/tmp/cappuccino_bootstrap.sh && bash /tmp/cappuccino_bootstrap.sh

If you'd just like to get started using Cappuccino for your web apps, you are done.

The rest of these instructions are for building a development copy of Cappuccino.
To build Cappuccino from source, check out the most recent stable version from GitHub:

    $ git clone git://github.com/cappuccino/cappuccino.git (git)

or download the zipball of the most recent source code:

  <http://github.com/cappuccino/cappuccino/zipball/master> (zip)

Then, simply type `jake` from within the root of the Cappuccino directory. If you
get an error like `jake: command not found`, you forgot to run the bootstrap script
as described above.

Jake will build a "release" copy of the frameworks. Typing `jake debug` will
build a debug version.

`jake install` will build Cappuccino and associated tools and install them for general use.

Editors
-------
The Cappuccino TextMate Bundle: <http://github.com/malkomalko/Cappuccino.tmbundle>.

The Cappuccino Xcode Plugin: <http://github.com/rbartolome/xcode-cappuccino>.

Getting Help
------------
If you need help with Cappuccino, you can get help from the following sources:

  - [FAQ](http://cappuccino-project.org/support/faq.html)
  - [Documentation](http://cappuccino-project.org/learn/)
  - [Wiki](http://github.com/cappuccino/cappuccino/wikis)
  - Mailing Lists:
    - [Objective-J](http://groups.google.com/group/objectivej)
    - [Objective-J Developers](http://groups.google.com/group/objectivej-dev)
  - IRC: irc://irc.freenode.net#cappuccino

If you discover any bugs, please file a ticket at:

  <http://github.com/cappuccino/cappuccino/issues>

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
