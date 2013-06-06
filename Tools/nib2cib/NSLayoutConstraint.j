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
        _firstItem = [aCoder decodeObjectForKey:@"NSFirstItem"];
        _firstAttribute = [aCoder decodeIntForKey:@"NSFirstAttribute"];

        var hasKey = [aCoder containsValueForKey:@"NSRelation"];
        _relation = hasKey ? [aCoder decodeIntForKey:@"NSRelation"] : 0 ;// TODO: relation when not in xib;

        _secondItem = [aCoder decodeObjectForKey:@"NSSecondItem"];
        _secondAttribute = [aCoder decodeIntForKey:@"NSSecondAttribute"];

        var hasKey = [aCoder containsValueForKey:@"NSMultiplier"];
        _coefficient = (hasKey) ? [aCoder decodeDoubleForKey:@"NSMultiplier"] : 1 ;// TODO: multiplier when not in xib;

        var symbolicConstant = [aCoder decodeObjectForKey:"NSSymbolicConstant"];
        _constant = (symbolicConstant == "NSSpace") ? 20 : [aCoder decodeDoubleForKey:@"NSConstant"];

        //_shouldBeArchived = [aCoder decodeBoolForKey:@"NSShouldBeArchived"];
        //[self _setIdentifier:[aCoder decodeObjectForKey:CPLayoutIdentifier]];

        var hasKey = [aCoder containsValueForKey:@"NSPriority"];
        _priority = (hasKey) ? [aCoder decodeIntForKey:@"NSPriority"] : CPLayoutPriorityRequired; // TODO: _priority when not in xib;
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
