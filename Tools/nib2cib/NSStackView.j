/*
 * NSStackView.j
 * nib2cib
 *
 * Created by cacaodev.
 * Copyright 2016.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import <AppKit/CPStackView.j>

@implementation CPStackView (NSCoding)

- (id)NS_initWithCoder:(CPCoder)aCoder
{
    self = [super NS_initWithCoder:aCoder];

    _detachesHiddenViews = [aCoder decodeBoolForKey:@"NSStackViewDetachesHiddenViews"];
    //_flags = [aCoder decodeIntForKey:@"NSvFlags"];
    if ([aCoder containsValueForKey:@"NSStackViewEdgeInsets.top"])
    {
        var left = [aCoder decodeIntForKey:@"NSStackViewEdgeInsets.left"],
            right = [aCoder decodeIntForKey:@"NSStackViewEdgeInsets.right"],
            top = [aCoder decodeIntForKey:@"NSStackViewEdgeInsets.top"],
            bottom = [aCoder decodeIntForKey:@"NSStackViewEdgeInsets.bottom"];

        _edgeInsets = CGInsetMake(top, right, bottom, left);
    }
    else
    {
        _edgeInsets = CGInsetMakeZero();
    }

    _distribution =  [aCoder decodeIntForKey:@"NSStackViewdistribution"];
    _orientation = [aCoder decodeIntForKey:@"NSStackViewOrientation"];
    _alignment = [aCoder decodeIntForKey:@"NSStackViewAlignment"];
    _alignmentPriority = [aCoder decodeIntForKey:@"NSStackViewAlignmentPriority"];
    _spacing = [aCoder decodeFloatForKey:@"NSStackViewSpacing"];
    _horizontalClippingResistancePriority = [aCoder decodeIntForKey:@"NSStackViewHorizontalClippingResistance"];
    _verticalClippingResistancePriority = [aCoder decodeIntForKey:@"NSStackViewVerticalClippingResistance"];
    _horizontalHuggingPriority = [aCoder decodeIntForKey:@"NSStackViewHorizontalHugging"];
    _verticalHuggingPriority = [aCoder decodeIntForKey:@"NSStackViewVerticalHugging"];

    // = [aCoder decodeIntForKey:@"NSStackViewSecondaryAlignment"];
    // = [aCoder decodeIntForKey:@"NSStackViewHasFlatViewHierarchy"];

    return self;
}

@end

@implementation NSStackView : CPStackView
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
    return [self NS_initWithCoder:aCoder];
}

- (Class)classForKeyedArchiver
{
    return [CPStackView class];
}

@end
