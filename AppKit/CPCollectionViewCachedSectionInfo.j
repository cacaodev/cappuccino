@implementation CPCollectionViewCachedSectionInfo : CPObject
{
    CPInteger   _itemCount @accessors(property=itemsCount);
    CPMapTable  _indexToModelObjectMap;
    id          _representedObject @accessors(property=representedObject);
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

- (id)objectAtIndex:(int)arg1
{
    return [_indexToModelObjectMap objectForKey:[CPNumber numberWithInteger:arg1]];
}

- (id)objectAtIndexValue:(id)arg1
{
    return [_indexToModelObjectMap objectForKey:arg1];
}

- (void)setObject:(id)arg1 atIndex:(int)arg2
{
    [_indexToModelObjectMap setObject:arg1 forKey:[CPNumber numberWithInteger:arg2]];
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

- (void)insertItemsAtIndexes:(id)arg1
{
    [arg1 enumerateRangesUsingBlock:function(indexes, stop)
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

    _itemCount += [arg1 count];
}

- (void)reloadItemsAtIndexes:(id)arg1
{
    [arg1 enumerateIndexesUsingBlock:function(idx, stop)
    {
        [_indexToModelObjectMap removeObjectForKey:[CPNumber numberWithInteger:idx]];
    }];
}

@end
