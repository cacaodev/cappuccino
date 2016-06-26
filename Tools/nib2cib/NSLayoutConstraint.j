/*
 * CPLayoutConstraint.j
 * nib2cib
 *
 * Created by cacaodev.
 * Copyright 2013.
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

@import <AppKit/CPLayoutConstraint.j>


@implementation CPLayoutConstraint (NSCoding)

- (id)NS_initWithCoder:(CPCoder)aCoder
{
    self = [super init];

    if (self)
    {
        if ([aCoder containsValueForKey:@"NSFirstAnchor"])
            _firstAnchor = [aCoder decodeObjectForKey:@"NSFirstAnchor"];
        else
        {
            var item = [aCoder decodeObjectForKey:@"NSFirstItem"],
                attr = [aCoder decodeIntForKey:@"NSFirstAttribute"];
            _firstAnchor = [CPLayoutAnchor layoutAnchorWithItem:item attribute:attr];
        }

        if ([aCoder containsValueForKey:@"NSSecondAnchor"])
            _secondAnchor = [aCoder decodeObjectForKey:@"NSSecondAnchor"];
        else
        {
            var item = [aCoder decodeObjectForKey:@"NSSecondItem"],
                attr = [aCoder decodeIntForKey:@"NSSecondAttribute"];
            _secondAnchor = [CPLayoutAnchor layoutAnchorWithItem:item attribute:attr];
        }

        var hasKey = [aCoder containsValueForKey:@"NSRelation"];
        _relation = hasKey ? [aCoder decodeIntForKey:@"NSRelation"] : CPLayoutRelationEqual ;// TODO: check relation when not in xib;

        var hasKey = [aCoder containsValueForKey:@"NSMultiplier"];
        _coefficient = (hasKey) ? [aCoder decodeDoubleForKey:@"NSMultiplier"] : 1 ;// TODO: check multiplier when not in xib;

        if ([aCoder containsValueForKey:@"NSConstantV2"])
            _constant = [aCoder decodeDoubleForKey:@"NSConstantV2"];
        else
            _constant = [aCoder decodeDoubleForKey:@"NSConstant"];

        _symbolicConstant = [aCoder decodeObjectForKey:"NSSymbolicConstant"];

        var hasKey = [aCoder containsValueForKey:@"NSPriority"];
        _priority = (hasKey) ? [aCoder decodeIntForKey:@"NSPriority"] : CPLayoutPriorityRequired; // TODO: check _priority when not in xib;

        _identifier = [aCoder decodeObjectForKey:@"NSLayoutIdentifier"];
        _shouldBeArchived = YES;
    }

    return self;
}

@end

@implementation NSLayoutConstraint : CPLayoutConstraint
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
    return [self NS_initWithCoder:aCoder];
}

- (Class)classForKeyedArchiver
{
    return [CPLayoutConstraint class];
}

@end

@implementation NSIBPrototypingLayoutConstraint : NSLayoutConstraint
@end
