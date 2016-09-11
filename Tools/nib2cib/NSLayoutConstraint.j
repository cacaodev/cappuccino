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
            var item1 = [aCoder decodeObjectForKey:@"NSFirstItem"],
                attr1 = [aCoder decodeIntForKey:@"NSFirstAttribute"];

            _firstAnchor = [item1 layoutAnchorForAttribute:attr1];
        }

        if ([aCoder containsValueForKey:@"NSSecondAnchor"])
            _secondAnchor = [aCoder decodeObjectForKey:@"NSSecondAnchor"];
        else
        {
            var item2 = [aCoder decodeObjectForKey:@"NSSecondItem"],
                attr2 = [aCoder decodeIntForKey:@"NSSecondAttribute"];

            _secondAnchor = [item2 layoutAnchorForAttribute:attr2];
        }

        var hasKey = [aCoder containsValueForKey:@"NSRelation"];
        _relation = hasKey ? [aCoder decodeIntForKey:@"NSRelation"] : CPLayoutRelationEqual;

        var hasKey = [aCoder containsValueForKey:@"NSMultiplier"];
        _coefficient = (hasKey) ? [aCoder decodeDoubleForKey:@"NSMultiplier"] : 1;

        if ([aCoder containsValueForKey:@"NSConstantV2"])
            _constant = [aCoder decodeDoubleForKey:@"NSConstantV2"];
        else if ([aCoder containsValueForKey:@"NSConstant"])
            _constant = [aCoder decodeDoubleForKey:@"NSConstant"];
        else
            _constant = 0;

        _symbolicConstant = [aCoder decodeObjectForKey:"NSSymbolicConstant"];

        var hasKey = [aCoder containsValueForKey:@"NSPriority"];
        _priority = (hasKey) ? [aCoder decodeIntForKey:@"NSPriority"] : CPLayoutPriorityRequired;

        var hasKey = [aCoder containsValueForKey:"NSShouldBeArchived"];
        _shouldBeArchived = hasKey ? [aCoder decodeBoolForKey:"NSShouldBeArchived"] : NO;

        _identifier = [aCoder decodeObjectForKey:@"NSLayoutIdentifier"];
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
