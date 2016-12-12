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

    //_detachesHiddenViews = [aCoder decodeBoolForKey:@"NSStackViewDetachesHiddenViews"];
    //_flags = [aCoder decodeIntForKey:@"NSvFlags"];
    if ([aCoder containsValueForKey:@"NSStackViewEdgeInsets.top"])
    {
        var left   = [aCoder decodeFloatForKey:@"NSStackViewEdgeInsets.left"],
            right  = [aCoder decodeFloatForKey:@"NSStackViewEdgeInsets.right"],
            top    = [aCoder decodeFloatForKey:@"NSStackViewEdgeInsets.top"],
            bottom = [aCoder decodeFloatForKey:@"NSStackViewEdgeInsets.bottom"];

        _edgeInsets = CGInsetMake(top, right, bottom, left);
    }
    else
    {
        _edgeInsets = CGInsetMakeZero();
    }

    if ([aCoder containsValueForKey:@"NSStackViewAlignment"])
        _alignment = [aCoder decodeIntForKey:@"NSStackViewAlignment"];
    else
        _alignment = 3;

    _orientation                          = [aCoder decodeIntForKey:@"NSStackViewOrientation"];
    _alignmentPriority                    = [aCoder decodeIntForKey:@"NSStackViewAlignmentPriority"];
    _spacing                              = [aCoder decodeFloatForKey:@"NSStackViewSpacing"];
    _horizontalClippingResistancePriority = [aCoder decodeIntForKey:@"NSStackViewHorizontalClippingResistance"];
    _verticalClippingResistancePriority   = [aCoder decodeIntForKey:@"NSStackViewVerticalClippingResistance"];
    _horizontalHuggingPriority            = [aCoder decodeIntForKey:@"NSStackViewHorizontalHugging"];
    _verticalHuggingPriority              = [aCoder decodeIntForKey:@"NSStackViewVerticalHugging"];
    _stackViewDecodedWantingFlatHierarchy = [aCoder decodeBoolForKey:@"NSStackViewHasFlatViewHierarchy"];

    // The typo in the key is written in cocoa stone.
    if (![aCoder containsValueForKey:@"NSStackViewdistribution"])
    {
        _distribution = -1;
        _viewsInGravity = @{};

        if ([aCoder containsValueForKey:@"NSStackViewBeginningContainer"])
        {
            var container = [aCoder decodeObjectForKey:@"NSStackViewBeginningContainer"];
            [_viewsInGravity setObject:[container views] forKey:@"gravity-1"];
        }

        if ([aCoder containsValueForKey:@"NSStackViewMiddleContainer"])
        {
            var container = [aCoder decodeObjectForKey:@"NSStackViewMiddleContainer"];
            [_viewsInGravity setObject:[container views] forKey:@"gravity-2"];
        }

        if ([aCoder containsValueForKey:@"NSStackViewEndContainer"])
        {
            var container = [aCoder decodeObjectForKey:@"NSStackViewEndContainer"];
            [_viewsInGravity setObject:[container views] forKey:@"gravity-3"];
        }
    }
    else
    {
        _distribution = [aCoder decodeIntForKey:@"NSStackViewdistribution"];
        _viewsInGravity = @{@"gravity-1" : [self subviews]};
    }

    // = [aCoder decodeIntForKey:@"NSStackViewSecondaryAlignment"];

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

@implementation CPStackViewContainer : CPView
{
    CPArray      _views @accessors(getter=views);
    unsigned int _flags;
}

- (id)NS_initWithCoder:(CPCoder)aCoder
{
    self = [super NS_initWithCoder:aCoder];

    _views = [aCoder decodeObjectForKey:@"NSStackViewContainerNonDroppedViews"];

    return self;
}

@end

@implementation NSStackViewContainer : CPStackViewContainer
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
    return [self NS_initWithCoder:aCoder];;
}

- (Class)classForKeyedArchiver
{
    return [CPStackViewContainer class];
}

@end
