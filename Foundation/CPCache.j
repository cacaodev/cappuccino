/*
 * CPCache.j
 * Foundation
 *
 * Created by William Mura.
 * Copyright 2015, William Mura.
 * Copyright 2017, cacaodev.
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


@import "CPObject.j"
@import "CPDictionary.j"
@import "CPString.j"

@class _CPCacheEntry;


/*
 * Delegate CPCacheDelegate
 *
 * - cache:willEvictObject: is called when a object is going to be removed
 * When the total cost or the count exceeds the total cost limit or the count limit
 * And also when removeObjectForKey or removeAllObjects are called
 */
@protocol CPCacheDelegate <CPObject>

@optional
- (void)cache:(CPCache)cache willEvictObject:(id)obj;

@end

var CPCacheDelegate_cache_willEvictObject_ = 1 << 1;


/*!
    @class CPCache
    @ingroup foundation
    @brief A collection-like container with discardable objects

    https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSCache_Class/index.html#//apple_ref/occ/instp/NSCache/delegate

    A CPCache object is a collection-like container, or cache, that stores key-value pairs,
    similar to the CPDictionary class. Developers often incorporate caches to temporarily
    store objects with transient data that are expensive to create.

    Reusing these objects can provide performance benefits, because their values do not have to be recalculated.
    However, the objects are not critical to the application and can be discarded if memory is tight.
    If discarded, their values will have to be recomputed again when needed.
 */
@implementation CPCache : CPObject
{
    CPDictionary         _entries;
    CPInteger            _totalCost      @accessors(readonly);
    BOOL                 _evictsObjectsWithDiscardedContent;
    _CPCacheEntry         _byCost;
    unsigned             _implementedDelegateMethods;

    CPString             _name           @accessors(property=name);
    CPInteger            _totalCostLimit @accessors(property=totalCostLimit);
    CPInteger            _countLimit     @accessors(property=countLimit);
    id <CPCacheDelegate> _delegate       @accessors(property=delegate);
}


#pragma mark -
#pragma mark Initialization

/*!
    Initializes the cache with default values
    @return the initialized cache
*/
- (id)init
{
    if (self = [super init])
    {
        _entries = [CPDictionary dictionary];
        _totalCost = 0;
        _evictsObjectsWithDiscardedContent = NO;
        _byCost = nil;

        _name = @"";
        _totalCostLimit = 0; // limits are imprecise/not strict
        _countLimit = 0; // limits are imprecise/not strict
        _delegate = nil;
        _implementedDelegateMethods = 0;
    }

    return self;
}

#pragma mark -
#pragma mark Managing cache

/*!
    Returns the object which correspond to the given key
    @param aKey the key for the object's entry
    @return the object for the entry
*/
- (id)objectForKey:(id)aKey
{
    var entry = [_entries objectForKey:aKey];

    if (entry !== nil)
        return [entry value];

    return nil;
}

/*!
    Adds an object with default cost into the cache.
    @param anObject the object to add in the cache
    @param aKey the object's key
*/
- (void)setObject:(id)obj forKey:(CPString)aKey
{
    [self setObject:obj forKey:aKey cost:0];
}

/*!
    Adds an object with a cost into the cache.
    @param anObject the object to add in the cache
    @param aKey the object's key
    @param aCost the object's cost
*/
- (void)setObject:(id)obj forKey:(CPString)aKey cost:(CPInteger)g
{
    _totalCost += g;

    var purgeAmount = 0;
    if (_totalCostLimit > 0)
    {
        purgeAmount = (_totalCost + g) - _totalCostLimit;
    }

    var purgeCount = 0;
    if (_countLimit > 0)
    {
        purgeCount = ([_entries count] + 1) - _countLimit;
    }

    var entry1 = [_entries objectForKey:aKey];

    if (entry1 !== nil)
    {
        [self _sendDelegateWillEvictEntry:entry1];

        [entry1 setValue:obj];

        if ([entry1 cost] != g)
        {
            [entry1 setCost:g];
            [self _remove:entry1];
            [self _insert:entry1];
        }
    }
    else
    {
        var nEntry = [[_CPCacheEntry alloc] initWithKey:aKey value:obj cost:g];
        [_entries setObject:nEntry forKey:aKey];
        [self _insert:nEntry];
    }

    var toRemove = @[];

    if (purgeAmount > 0)
    {
        while (_totalCost - _totalCostLimit > 0)
        {
            var entry2 = _byCost;

            if (entry2 !== nil)
            {
                _totalCost -= [entry2 cost];
                [toRemove addObject:entry2];
                [self _remove:entry2];
            }
            else
            {
                break;
            }
        }

        if (_countLimit > 0)
        {
            purgeCount = [_entries count] - [toRemove count] - _countLimit;
        }
    }

    if (purgeCount > 0)
    {
        while ([_entries count] - [toRemove count] - _countLimit > 0)
        {
            var entry3 = _byCost;
            if (entry3 !== nil)
            {
                _totalCost -= [entry3 cost];
                [toRemove addObject:entry3];
                [self _remove:entry3];
            }
            else
            {
                break;
            }
        }
    }

    [toRemove enumerateObjectsUsingBlock:function(anEntry, idx, stop)
    {
        [self _sendDelegateWillEvictEntry:anEntry];
    }];

    [toRemove enumerateObjectsUsingBlock:function(anEntry, idx, stop)
    {
        [_entries removeObjectForKey:[anEntry key]]; // the cost list is already fixed up in the purge routines
    }];
}

/*!
    Removes the object from the cache for the given key.
    @param aKey the key of the object to be removed
*/
- (void)removeObjectForKey:(id)aKey
{
    var entry = [_entries objectForKey:aKey];

    if (entry !== nil)
    {
        _totalCost -= [entry cost];

        [self _sendDelegateWillEvictEntry:entry];

        [_entries removeObjectForKey:aKey];
        [self _remove:entry];
    }
}

/*!
    Removes all the objects from the cache.
*/
- (void)removeAllObjects
{
    [_entries enumerateKeysAndObjectsUsingBlock:function(key, anEntry, stop)
    {
        [self _sendDelegateWillEvictEntry:anEntry];
    }];

    [_entries removeAllObjects];
    _byCost = nil;
    _totalCost = 0;
}

#pragma mark -
#pragma mark Setters

/*!
    Sets the count limit of the cache.
    Remove objects if not enough place to keep all of them
    @param aCountLimit the new count limit
*/
- (void)setCountLimit:(CPInteger)newCount
{
    if (newCount === _countLimit)
        return;

    _countLimit = newCount;

    while ([self _count] > _countLimit)
    {
        var entry = _byCost;
        if (entry !== nil)
        {
            [self _remove:entry];
            [_entries removeObjectForKey:[entry key]];
            _totalCost -= [entry cost];
            [self _sendDelegateWillEvictEntry:entry];
        }
    }
}


/*!
    Sets the total cost limit of the cache.
    Remove objects if not enough place to keep all of them
    @param aTotalCostLimit the new total cost limit
*/
- (void)setTotalCostLimit:(CPInteger)newCost
{
    if (newCost === _totalCostLimit)
        return;

    _totalCostLimit = newCost;

    while (_totalCost > _totalCostLimit)
    {
        var entry = _byCost;
        if (entry !== nil)
        {
            [self _remove:entry];
            [_entries removeObjectForKey:[entry key]];
            _totalCost -= [entry cost];
            [self _sendDelegateWillEvictEntry:entry];
        }
    }
}

/*!
    Sets the cache's delegate.
    @param aDelegate the new delegate
*/
- (void)setDelegate:(id)aDelegate
{
    if (_delegate === aDelegate)
        return;

    _delegate = aDelegate;
    _implementedDelegateMethods = 0;

    if ([_delegate respondsToSelector:@selector(cache:willEvictObject:)])
        _implementedDelegateMethods |= CPCacheDelegate_cache_willEvictObject_
}

#pragma mark -
#pragma mark Privates

/*
 * This method return the number of objects in the cache
 */
- (int)_count
{
    return [_entries count];
}

- (void)_remove:(_CPCacheEntry)entry
{
    var oldPrev = [entry prevByCost],
        oldNext = [entry nextByCost];

    if (oldPrev)
        [oldPrev setNextByCost:oldNext];
    if (oldNext)
        [oldNext setPrevByCost:oldPrev];

    if (entry === _byCost)
    {
        _byCost = [entry nextByCost];
    }
}

- (void)_insert:(_CPCacheEntry)entry
{
    if (_byCost == nil)
    {
        _byCost = entry
    }
    else
    {
        var element = _byCost,
            e;

        while (e = element)
        {
            if ([e cost] > [entry cost])
            {
                var newPrev = [e prevByCost];
                [entry setPrevByCost:newPrev];
                [entry setNextByCost:e];
                break;
            }

            element = [e nextByCost];
        }
    }
}

- (void)_sendDelegateWillEvictEntry:(_CPCacheEntry)anEntry
{
    if (_delegate)
        [_delegate cache:self willEvictObject:[anEntry value]];
}

@end

@implementation CPCache (CPCacheDelegate)

- (void)_sendDelegateWillEvictEntry:(_CPCacheEntry)anEntry
{
    if (_implementedDelegateMethods & CPCacheDelegate_cache_willEvictObject_)
    {
        [_delegate cache:self willEvictObject:[anEntry value]];
    }
}

@end

@implementation _CPCacheEntry : CPObject
{
    CPString         _key        @accessors(property=key);
    id               _value      @accessors(property=value);
    CPInteger        _cost       @accessors(property=cost);
    _CPCacheEntry    _prevByCost @accessors(property=prevByCost);
    _CPCacheEntry    _nextByCost @accessors(property=nextByCost);
}

- (id)initWithKey:(CPString)aKey value:(id)aValue cost:(CPInteger)aCost
{
    if (self = [super init])
    {
        _key = aKey;
        _value = aValue;
        _cost = aCost;
        _prevByCost = nil;
        _nextByCost = nil;
    }

    return self;
}

@end
