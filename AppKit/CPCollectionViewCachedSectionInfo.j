@implementation CPCollectionViewCachedSectionInfo : CPObject
{
    CPInteger   _itemCount          @accessors(property=itemsCount);
    id          _representedObject  @accessors(property=representedObject);
    CPMapTable  _indexToModelObjectMap;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        _itemCount = -1;
        _representedObject = nil;
        _indexToModelObjectMap = [CPMapTable strongToStrongObjectsMapTable];
    }

    return self;
}

- (id)representedObjectEnumerator
{
    return [_indexToModelObjectMap objectEnumerator];
}

- (id)objectAtIndex:(int)anIndex
{
    return [_indexToModelObjectMap objectForKey:[CPNumber numberWithInteger:anIndex]];
}

- (id)objectAtIndexValue:(id)aKey
{
    return [_indexToModelObjectMap objectForKey:aKey];
}

- (void)setObject:(id)anObject atIndex:(int)anIndex
{
    [_indexToModelObjectMap setObject:anObject forKey:[CPNumber numberWithInteger:anIndex]];
}

- (id)itemIndexEnumerator
{
    return [_indexToModelObjectMap keyEnumerator];
}

- (void)deleteItemsAtIndexes:(id)itemIndexes
{
    [itemIndexes enumerateRangesWithOptions:2 usingBlock:function(indexes, stop)
    {
        var mapTable = [CPMapTable strongToStrongObjectsMapTable];
        var keyEnumerator = [_indexToModelObjectMap keyEnumerator];
        var indexKey;

        while (indexKey = [keyEnumerator nextObject])
        {
            var section = [_indexToModelObjectMap objectForKey:indexKey];

            if (section)
            {
                var key;
                var idx = [indexKey integerValue];

                if (idx >= indexes.location + indexes.length)
                {
                    key = [CPNumber numberWithInteger: idx - indexes.length];
                }
                else
                {
                    key = indexKey;
                }

                [mapTable setObject:section forKey:key];
            }
        }

        _indexToModelObjectMap = mapTable;
    }];

    _itemCount -= [itemIndexes count];
}

- (void)insertItemsAtIndexes:(id)anIndexSet
{
    [anIndexSet enumerateRangesUsingBlock:function(indexes, stop)
    {
        var mapTable = [CPMapTable strongToStrongObjectsMapTable];
        var keyEnumerator = [_indexToModelObjectMap keyEnumerator];
        var indexKey;

        while (indexKey = [keyEnumerator nextObject])
        {
            var section = [_indexToModelObjectMap objectForKey:indexKey];

            if (section)
            {
                var key;
                var idx = [indexKey integerValue];

                if (idx >= indexes.location)
                {
                    key = [CPNumber numberWithInteger: idx + indexes.length];
                }
                else
                {
                    key = indexKey;
                }

                [mapTable setObject:section forKey:key];
            }
        }

        _indexToModelObjectMap = mapTable;
    }];

    _itemCount += [anIndexSet count];
}

- (void)reloadItemsAtIndexes:(id)anIndexSet
{
    [anIndexSet enumerateIndexesUsingBlock:function(idx, stop)
    {
        [_indexToModelObjectMap removeObjectForKey:[CPNumber numberWithInteger:idx]];
    }];
}

@end
