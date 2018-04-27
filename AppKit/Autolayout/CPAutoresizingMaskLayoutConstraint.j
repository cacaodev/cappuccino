/*
 * CPAutoresizingMaskLayoutConstraint.j
 * AppKit
 *
 * Created by cacaodev on April 26, 2018.
 * Copyright 2018, cacaodev. All rights reserved.
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

@import "CPLayoutConstraint.j"

@implementation CPAutoresizingMaskLayoutConstraint : CPLayoutConstraint
{
}

- (BOOL)isEqual:(id)anObject
{
    if (anObject === self)
        return YES;

    if (!anObject || [anObject class] !== [self class] || [anObject firstAttribute] !== [self firstAttribute] || [anObject viewForAutoresizingMask] !== [self viewForAutoresizingMask])
        return NO;

    return YES;
}

- (CPView)viewForAutoresizingMask
{
    return ([self firstItem] !== _container) ? [self firstItem] : [self secondItem];
}

- (CPString)_constraintType
{
    return @"AutoresizingConstraint";
}

+ (CPArray)constraintsWithAutoresizingMask:(unsigned)aMask subitem:(id)subItem frame:(CGRect)aFrame superitem:(id)superItem bounds:(CGRect)bounds
{
    var hconstraints = [CPAutoresizingMaskLayoutConstraint _constraintsWithAutoresizingMask:aMask subitem:subItem frame:aFrame superitem:superItem bounds:bounds orientation:CPLayoutConstraintOrientationHorizontal];

    var vconstraints = [CPAutoresizingMaskLayoutConstraint _constraintsWithAutoresizingMask:aMask subitem:subItem frame:aFrame superitem:superItem bounds:bounds orientation:CPLayoutConstraintOrientationVertical];

    return [hconstraints arrayByAddingObjectsFromArray:vconstraints];
}

+ (CPArray)_constraintsWithAutoresizingMask:(unsigned)aMask subitem:(id)subItem frame:(CGRect)aFrame superitem:(id)superItem bounds:(CGRect)bounds orientation:(CPLayoutConstraintOrientation)orientation
{
    if (!superItem)
        return [CPArray array];

    var min                   = orientation ? CGRectGetMinY(aFrame) : CGRectGetMinX(aFrame),
        max                   = orientation ? CGRectGetMaxY(aFrame) : CGRectGetMaxX(aFrame),
        size                  = orientation ? CGRectGetHeight(aFrame) : CGRectGetWidth(aFrame),
        ssize                 = orientation ? CGRectGetHeight(bounds) : CGRectGetWidth(bounds),
        CPViewMinMargin       = orientation ? CPViewMinYMargin : CPViewMinXMargin,
        CPViewMaxMargin       = orientation ? CPViewMaxYMargin : CPViewMaxXMargin,
        CPViewSizable         = orientation ? CPViewHeightSizable : CPViewWidthSizable,
        CPLayoutAttributeMin  = orientation ? CPLayoutAttributeTop : CPLayoutAttributeLeft,
        CPLayoutAttributeMax  = orientation ? CPLayoutAttributeBottom : CPLayoutAttributeRight,
        CPLayoutAttributeSize = orientation ? CPLayoutAttributeHeight : CPLayoutAttributeWidth;

    var pconstraint,
        sconstaint;

    if (!(aMask & CPViewSizable))
    {
        var sconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeSize relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:0 constant:size];

        if ((aMask & CPViewMinMargin) && (aMask & CPViewMaxMargin))
        {
            var m = min / (ssize - size),
                k = - min * size / (ssize - size);

            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMin relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeSize multiplier:m constant:k];
        }
        else if (aMask & CPViewMinMargin)
        {
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMax relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeMax multiplier:1 constant:(max - ssize)];
        }
        else // CPViewMaxMargin or 0
        {
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMin relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:0 constant:min];
        }
    }
    else
    {
        var pconstraint,
            sconstaint;

        if ((aMask & CPViewMinMargin) && (aMask & CPViewMaxMargin))
        {
            var m = min / ssize;
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMin relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeSize multiplier:m constant:0];

            m = size / ssize;
            sconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeSize relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeSize multiplier:m constant:0];
        }
        else if (aMask & CPViewMinMargin)
        {
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMax relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeMax multiplier:1 constant:(max - ssize)];

            var m = size / max,
                k = size - m * ssize;

            sconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeSize relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeSize multiplier:m constant:k];

        }
        else if (aMask & CPViewMaxMargin)
        {
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMin relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:0 constant:min];

            var m = size / (ssize - min),
                k = - m * min;

            sconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeSize relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeSize multiplier:m constant:k];
        }
        else
        {
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMin relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:0 constant:min];

            sconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMax relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeMax multiplier:1 constant:(max - ssize)];
        }
    }

    [pconstraint _setContainer:superItem];
    [sconstraint _setContainer:superItem];

    return @[pconstraint, sconstraint];
}

@end
