@import <Foundation/CPObject.j>

@implementation CPCollectionViewDataSourceAdapter : CPObject
{
    CPCollectionView _collectionView    @accessors(property=collectionView);
    id               _dataSource        @accessors(getter=dataSource);
    BOOL             _dataSourceImplementsObjectMethods;
    CPInteger        _sectionCount      @accessors(property=sectionCount);
    CPMapTable       _indexToSectionInfoMap;
    CPMapTable       _representedObjectToIndexPathMap;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        _sectionCount = -1;
        _indexToSectionInfoMap = [CPMapTable strongToStrongObjectsMapTable];
        _representedObjectToIndexPathMap = [CPMapTable strongToStrongObjectsMapTable];
        _collectionView = nil;
        _dataSource = nil;
        _dataSourceImplementsObjectMethods = NO;
    }

    return self;
}

- (void)deleteSections:(CPIndexSet)anIndexSet
{
    var count = [anIndexSet count];

    if (count && [anIndexSet firstIndex] < _sectionCount)
    {
        [_representedObjectToIndexPathMap removeAllObjects];
    }

    [anIndexSet enumerateIndexesWithOptions:2 usingBlock:function(sectionIdx, stop)
    {
        [_indexToSectionInfoMap removeObjectForKey:[CPNumber numberWithInteger:sectionIdx]];

        if (sectionIdx < _sectionCount - 1)
        {
            var nextIdx = sectionIdx + 1;

            while (nextIdx < _sectionCount)
            {
                var nextKey = [CPNumber numberWithInteger:nextIdx];
                var nextSection = [_indexToSectionInfoMap objectForKey:nextKey];

                if (section)
                {
                    [_indexToSectionInfoMap removeObjectForKey:nextKey];
                    [_indexToSectionInfoMap setObject:nextSection forKey:[CPNumber numberWithInteger:nextIdx - 1]];
                }

                nextIdx++;
            }
        }
    }];

    _sectionCount -= count;
}

- (void)reloadSections:(CPIndexSet)indexes
{
    if ([indexes count] && [indexes firstIndex] < _sectionCount)
    {
        [_representedObjectToIndexPathMap removeAllObjects];
    }

    [indexes enumerateIndexesUsingBlock:function(idx, stop)
    {
        [_indexToSectionInfoMap removeObjectForKey:[CPNumber numberWithInteger:idx]];
    }];
}

- (void)insertSections:(id)indexes
{
    var count = [indexes count];

    if (count && [indexes firstIndex] < _sectionCount)
    {
        [_representedObjectToIndexPathMap removeAllObjects];
    }

    [indexes enumerateIndexesUsingBlock:function(insertIdx, stop)
    {
        if (insertIdx < _sectionCount)
        {
            var sectionIdx = [_indexToSectionInfoMap count] - 1;

            while (sectionIdx > insertIdx)
            {
                var sectionKey = [CPNumber numberWithInteger:sectionIdx - 1];
                var section = [_indexToSectionInfoMap objectForKey:sectionKey];
                if (section)
                {
                    [_indexToSectionInfoMap removeObjectForKey:sectionKey];
                    [_indexToSectionInfoMap setObject:section forKey:[CPNumber numberWithInteger:sectionIdx]];
                }

                --sectionIdx;
            }
        }
    }];

    _sectionCount += count;
}

- (id)_indexPathForRepresentedObject:(id)repObject
{
    if (_sectionCount > 0 && ![_representedObjectToIndexPathMap count])
        [self _rebuildRepresentedObjectToIndexPathMap];

    return [_representedObjectToIndexPathMap objectForKey:repObject];
}

- (void)_rebuildRepresentedObjectToIndexPathMap
{
    var sectionEnumerator = [_indexToSectionInfoMap keyEnumerator];
    var sectionKey;

    while (sectionKey = [sectionEnumerator nextObject])
    {
        var sectionIndex = [sectionKey integerValue];
        var sectionInfo = [_indexToSectionInfoMap objectForKey:sectionKey];

        if (sectionInfo)
        {
            var sectionRepObject = [sectionInfo representedObject];

            if (sectionRepObject)
            {
                var indexPath = [CPIndexPath indexPathWithIndex:sectionIndex];
                [_representedObjectToIndexPathMap setObject:indexPath forKey:sectionRepObject];
            }

            var itemEnumerator = [sectionInfo itemIndexEnumerator];
            var itemKey;

            while (itemKey = [itemEnumerator nextObject])
            {
               var repObject = [sectionInfo objectAtIndexValue:itemKey];

                if (repObject)
                {
                    var itemIndex = [itemKey integerValue];
                    var indexPath = [CPIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
                    [_representedObjectToIndexPathMap setObject:indexPath forKey:repObject];
                }
            }
        }
    }
}

- (id)_representedObjectForIndexPath:(CPIndexPath)anIndexPath
{
    var result;
    var length = [anIndexPath length];

    if (length  >= 3)
    {
        [CPException raise:CPInvalidArgumentException reason:@"CPIndexPath should satisfy the condition length < 3"];
        return nil;
    }

    var sectionIdx = [anIndexPath indexAtPosition:0],
        sectionKey = [CPNumber numberWithInteger:sectionIdx],
        sectionInfo = [_indexToSectionInfoMap objectForKey:sectionKey];

    if (length == 1)
    {
        result = [sectionInfo representedObject];
    }
    else if (length == 2)
    {
        result = [sectionInfo objectAtIndex:[anIndexPath item]];
    }

    return result;
}

- (id)_representedObjectForCurrentDataSourceInvocation
{
    return _representedObjectForCurrentDataSourceInvocation;
}

- (id)collectionView:(id)aCollectionView viewForSupplementaryElementOfKind:(id)arg2 atIndexPath:(id)anIndexPath
{
    if ([_dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
        return [_dataSource collectionView:aCollectionView viewForSupplementaryElementOfKind:arg2 atIndexPath:anIndexPath];

    return nil;
}

- (id)collectionView:(id)aCollectionView itemForRepresentedObjectAtIndexPath:(id)anIndexPath
{
    var result;

    if (_dataSourceImplementsObjectMethods)
    {
        var repObject;
        var section = [anIndexPath section];
        var itemIndex = [anIndexPath item];
        var sectionInfo = [_indexToSectionInfoMap objectForKey:[CPNumber numberWithInteger:itemIndex]];

        if (!sectionInfo || (repObject = [sectionInfo objectAtIndex:itemIndex]) == nil)
        {
            var sectionRepObject = [sectionInfo representedObject];
            repObject = [_dataSource collectionView:aCollectionView child:itemIndex ofRepresentedObject:sectionRepObject];
            [sectionInfo setObject:repObject atIndex:itemIndex];
        }

        _representedObjectForCurrentDataSourceInvocation = repObject;

        result = [_dataSource collectionView:aCollectionView itemForRepresentedObject:repObject atIndexPath:anIndexPath];

        _representedObjectForCurrentDataSourceInvocation = nil;
    }
    else
    {
        result = [_dataSource collectionView:aCollectionView itemForRepresentedObjectAtIndexPath:anIndexPath];
    }

    return result;
}

- (int)collectionView:(id)aCollectionView numberOfItemsInSection:(int)aSection
{
    var sectionInfo;
    var sectionIndex;
    var itemCount;
    var result;

    if (!_dataSourceImplementsObjectMethods)
        return [_dataSource collectionView:aCollectionView numberOfItemsInSection:aSection];

    sectionIndex = [CPNumber numberWithInteger:aSection];
    sectionInfo = [_indexToSectionInfoMap objectForKey:sectionIndex];

    if (!sectionInfo)
    {
        sectionInfo = [[CPCollectionViewCachedSectionInfo alloc] init];

        var repObj = [_dataSource collectionView:aCollectionView child:aSection ofRepresentedObject:nil];
        [sectionInfo setRepresentedObject:repObj];

        var count = [_dataSource collectionView:aCollectionView numberOfChildrenOfRepresentedObject:repObj];
        [sectionInfo setItemCount:count];

        [_indexToSectionInfoMap setObject:sectionInfo forKey:sectionIndex];
    }

    itemCount = [sectionInfo itemCount];
    result = itemCount;

    if (itemCount < 0)
    {
        var repObj = [sectionInfo representedObject];
        result = [_dataSource collectionView:aCollectionView numberOfChildrenOfRepresentedObject:repObj];
        [sectionInfo setItemCount:itemCount];
    }

    return result;
}

- (void)setDataSource:(id)aDataSource
{
    if (_dataSource == aDataSource)
        return;

    _dataSource = aDataSource;

    _dataSourceImplementsObjectMethods = ([_dataSource respondsToSelector:@selector(collectionView:numberOfChildrenOfRepresentedObject:)]
                                          && [_dataSource respondsToSelector:@selector(collectionView:child:ofRepresentedObject:)]
                                          && [_dataSource respondsToSelector: @selector(collectionView:itemForRepresentedObject:atIndexPath:)]);
}

- (int)numberOfSectionsInCollectionView:(id)aCollectionView
{
    var result;

    result = [self sectionCount];

    if (result < 0)
    {
        if (![_dataSource respondsToSelector:@selector(collectionView:numberOfChildrenOfRepresentedObject:)])
        {
            if (![_dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
            {
                result = 1;
            }
            else
            {
                result = [_dataSource numberOfSectionsInCollectionView:aCollectionView];
            }
        }
        else
        {
            result = [_dataSource collectionView:aCollectionView numberOfChildrenOfRepresentedObject:nil];
        }

        [self setSectionCount:result];
    }

    return result;
}

- (int)_indexOfSectionObject:(id)anObject
{
    var indexPath = [self _indexPathForRepresentedObject:anObject];

    if (indexPath && [indexPath length] == 1)
        return [indexPath indexAtPosition:0];

    return -1;
}

- (void)reloadItemsAtIndexPaths:(CPIndexPath)anIndexPaths
{
    if ([anIndexPath count])
        [_representedObjectToIndexPathMap removeAllObjects];

    [anIndexPaths enumerateIndexPathsWithOptions:0 usingBlock:function(indexPath, stop)
    {
        var sectionKey = [CPNumber numberWithUnsignedInteger:[indexPath section]];
        var itemIndexes = [CPIndexSet indexSetWithIndex:[indexPath item]];

        var sectionInfo = [_indexToSectionInfoMap objectForKey:sectionKey];
        [sectionInfo reloadItemsAtIndexes:itemIndexes];
    }];
}

- (void)deleteItemsAtIndexPaths:(id)anIndexPaths
{
    if ([anIndexPaths count])
        [_representedObjectToIndexPathMap removeAllObjects];

    [anIndexPaths enumerateIndexPathsWithOptions:0 usingBlock:function(indexPath)
    {
        var sectionKey = [CPNumber numberWithUnsignedInteger:[indexPath section]];
        var itemIndexes = [CPIndexSet indexSetWithIndex:[indexPath item]];

        var sectionInfo = [_indexToSectionInfoMap objectForKey:sectionKey];
        [sectionInfo deleteItemsAtIndexes:itemIndexes];
    }];
}

- (void)insertItemsAtIndexPaths:(id)anIndexPaths
{
    if ([anIndexPaths count])
        [_representedObjectToIndexPathMap removeAllObjects];

    [anIndexPaths enumerateIndexPathsWithOptions:0 usingBlock:function(indexPath)
    {
        var sectionKey = [CPNumber numberWithUnsignedInteger:[indexPath section]];
        var sectionInfo = [_indexToSectionInfoMap objectForKey:sectionKey];

        var itemIndexes = [CPIndexSet indexSetWithIndex:[indexPath item]];

        [sectionInfo insertItemsAtIndexes:itemIndexes];
    }];
}

- (void)moveSection:(int)arg1 toSection:(int)aSection
{
    [_representedObjectToIndexPathMap removeAllObjects];
    [self _invalidateEverything];
}

- (void)_invalidateEverything
{
    _sectionCount = -1;
    [_indexToSectionInfoMap removeAllObjects];
    [_representedObjectToIndexPathMap removeAllObjects];
}

- (id)_fetchSectionObjectAtIndex:(int)anIndex
{
    var result = nil;
    var indexKey = [CPNumber numberWithInteger:anIndex];

    if ([_indexToSectionInfoMap objectForKey:indexKey] == nil)
    {
        var repObject = [_dataSource collectionView:_collectionView child:anIndex ofRepresentedObject:nil];

        if (repObject)
        {
            var sectionInfo = [[CPCollectionViewCachedSectionInfo alloc] init];
            [sectionInfo setRepresentedObject:repObject];
            [_indexToSectionInfoMap setObject:sectionInfo forKey:indexKey];
            result = repObject;
        }
    }

    return result;
}

- (void)moveItemAtIndexPath:(CPIndexPath)arg1 toIndexPath:(CPIndexPath)arg2
{
    [_representedObjectToIndexPathMap removeAllObjects];
    [self _invalidateEverything];
}

@end
