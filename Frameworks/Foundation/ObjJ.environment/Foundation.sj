@STATIC;1.0;p;13;_CGGeometry.jt;10250;@STATIC;1.0;t;10230;CGPointMake = function(x, y) { return { x:x, y:y }; }
CGPointMakeZero = function() { return { x:0.0, y:0.0 }; }
CGPointMakeCopy = function(aPoint) { return { x:aPoint.x, y:aPoint.y }; }
CGPointCreateCopy = function(aPoint) { return { x:aPoint.x, y:aPoint.y }; }
CGPointEqualToPoint = function(lhsPoint, rhsPoint) { return (lhsPoint.x == rhsPoint.x && lhsPoint.y == rhsPoint.y); }
CGStringFromPoint = function(aPoint) { return ("{" + aPoint.x + ", " + aPoint.y + "}"); }
CGSizeMake = function(width, height) { return { width:width, height:height }; }
CGSizeMakeZero = function() { return { width:0.0, height:0.0 }; }
CGSizeMakeCopy = function(aSize) { return { width:aSize.width, height:aSize.height }; }
CGSizeCreateCopy = function(aSize) { return { width:aSize.width, height:aSize.height }; }
CGSizeEqualToSize = function(lhsSize, rhsSize) { return (lhsSize.width == rhsSize.width && lhsSize.height == rhsSize.height); }
CGStringFromSize = function(aSize) { return ("{" + aSize.width + ", " + aSize.height + "}"); }
CGRectMake = function(x, y, width, height) { return { origin: { x:x, y:y }, size: { width:width, height:height } }; }
CGRectMakeZero = function() { return { origin: { x:0.0, y:0.0 }, size: { width:0.0, height:0.0 } }; }
CGRectMakeCopy = function(aRect) { return { origin: { x:aRect.origin.x, y:aRect.origin.y }, size: { width:aRect.size.width, height:aRect.size.height } }; }
CGRectCreateCopy = function(aRect) { return { origin: { x:aRect.origin.x, y:aRect.origin.y }, size: { width:aRect.size.width, height:aRect.size.height } }; }
CGRectEqualToRect = function(lhsRect, rhsRect) { return ((lhsRect.origin.x == rhsRect.origin.x && lhsRect.origin.y == rhsRect.origin.y) && (lhsRect.size.width == rhsRect.size.width && lhsRect.size.height == rhsRect.size.height)); }
CGStringFromRect = function(aRect) { return ("{" + ("{" + aRect.origin.x + ", " + aRect.origin.y + "}") + ", " + ("{" + aRect.size.width + ", " + aRect.size.height + "}") + "}"); }
CGRectOffset = function(aRect, dX, dY) { return { origin: { x:aRect.origin.x + dX, y:aRect.origin.y + dY }, size: { width:aRect.size.width, height:aRect.size.height } }; }
CGRectInset = function(aRect, dX, dY) { return { origin: { x:aRect.origin.x + dX, y:aRect.origin.y + dY }, size: { width:aRect.size.width - 2 * dX, height:aRect.size.height - 2 * dY } }; }
CGRectGetHeight = function(aRect) { return (aRect.size.height); }
CGRectGetMaxX = function(aRect) { return (aRect.origin.x + aRect.size.width); }
CGRectGetMaxY = function(aRect) { return (aRect.origin.y + aRect.size.height); }
CGRectGetMidX = function(aRect) { return (aRect.origin.x + (aRect.size.width) / 2.0); }
CGRectGetMidY = function(aRect) { return (aRect.origin.y + (aRect.size.height) / 2.0); }
CGRectGetMinX = function(aRect) { return (aRect.origin.x); }
CGRectGetMinY = function(aRect) { return (aRect.origin.y); }
CGRectGetWidth = function(aRect) { return (aRect.size.width); }
CGRectIsEmpty = function(aRect) { return (aRect.size.width <= 0.0 || aRect.size.height <= 0.0); }
CGRectIsNull = function(aRect) { return (aRect.size.width <= 0.0 || aRect.size.height <= 0.0); }
CGRectContainsPoint = function(aRect, aPoint) { return (aPoint.x >= (aRect.origin.x) && aPoint.y >= (aRect.origin.y) && aPoint.x < (aRect.origin.x + aRect.size.width) && aPoint.y < (aRect.origin.y + aRect.size.height)); }
CGInsetMake = function(top, right, bottom, left) { return { top:(top), right:(right), bottom:(bottom), left:(left) }; }
CGInsetMakeZero = function() { return { top:(0), right:(0), bottom:(0), left:(0) }; }
CGInsetMakeCopy = function(anInset) { return { top:(anInset.top), right:(anInset.right), bottom:(anInset.bottom), left:(anInset.left) }; }
CGInsetMakeInvertedCopy = function(anInset) { return { top:(-anInset.top), right:(-anInset.right), bottom:(-anInset.bottom), left:(-anInset.left) }; }
CGInsetIsEmpty = function(anInset) { return ((anInset).top === 0 && (anInset).right === 0 && (anInset).bottom === 0 && (anInset).left === 0); }
CGInsetEqualToInset = function(lhsInset, rhsInset) { return ((lhsInset).top === (rhsInset).top && (lhsInset).right === (rhsInset).right && (lhsInset).bottom === (rhsInset).bottom && (lhsInset).left === (rhsInset).left); }
CGMinXEdge = 0;
CGMinYEdge = 1;
CGMaxXEdge = 2;
CGMaxYEdge = 3;
CGRectNull = { origin: { x:Infinity, y:Infinity }, size: { width:0.0, height:0.0 } };
CGRectDivide = function(inRect, slice, rem, amount, edge)
{
    slice.origin = { x:inRect.origin.x, y:inRect.origin.y };
    slice.size = { width:inRect.size.width, height:inRect.size.height };
    rem.origin = { x:inRect.origin.x, y:inRect.origin.y };
    rem.size = { width:inRect.size.width, height:inRect.size.height };
    switch (edge)
    {
        case CGMinXEdge:
            slice.size.width = amount;
            rem.origin.x += amount;
            rem.size.width -= amount;
            break;
        case CGMaxXEdge:
            slice.origin.x = (slice.origin.x + slice.size.width) - amount;
            slice.size.width = amount;
            rem.size.width -= amount;
            break;
        case CGMinYEdge:
            slice.size.height = amount;
            rem.origin.y += amount;
            rem.size.height -= amount;
            break;
        case CGMaxYEdge:
            slice.origin.y = (slice.origin.y + slice.size.height) - amount;
            slice.size.height = amount;
            rem.size.height -= amount;
    }
}
CGRectContainsRect = function(lhsRect, rhsRect)
{
    var union = CGRectUnion(lhsRect, rhsRect);
    return ((union.origin.x == lhsRect.origin.x && union.origin.y == lhsRect.origin.y) && (union.size.width == lhsRect.size.width && union.size.height == lhsRect.size.height));
}
CGRectIntersectsRect = function(lhsRect, rhsRect)
{
    var intersection = CGRectIntersection(lhsRect, rhsRect);
    return !(intersection.size.width <= 0.0 || intersection.size.height <= 0.0);
}
CGRectIntegral = function(aRect)
{
    aRect = CGRectStandardize(aRect);
    var x = FLOOR((aRect.origin.x)),
        y = FLOOR((aRect.origin.y));
    aRect.size.width = CEIL((aRect.origin.x + aRect.size.width)) - x;
    aRect.size.height = CEIL((aRect.origin.y + aRect.size.height)) - y;
    aRect.origin.x = x;
    aRect.origin.y = y;
    return aRect;
}
CGRectIntersection = function(lhsRect, rhsRect)
{
    var intersection = { origin: { x:MAX((lhsRect.origin.x), (rhsRect.origin.x)), y:MAX((lhsRect.origin.y), (rhsRect.origin.y)) }, size: { width:0, height:0 } };
    intersection.size.width = MIN((lhsRect.origin.x + lhsRect.size.width), (rhsRect.origin.x + rhsRect.size.width)) - (intersection.origin.x);
    intersection.size.height = MIN((lhsRect.origin.y + lhsRect.size.height), (rhsRect.origin.y + rhsRect.size.height)) - (intersection.origin.y);
    return (intersection.size.width <= 0.0 || intersection.size.height <= 0.0) ? { origin: { x:0.0, y:0.0 }, size: { width:0.0, height:0.0 } } : intersection;
}
CGRectStandardize = function(aRect)
{
    var width = (aRect.size.width),
        height = (aRect.size.height),
        standardized = { origin: { x:aRect.origin.x, y:aRect.origin.y }, size: { width:aRect.size.width, height:aRect.size.height } };
    if (width < 0.0)
    {
        standardized.origin.x += width;
        standardized.size.width = -width;
    }
    if (height < 0.0)
    {
        standardized.origin.y += height;
        standardized.size.height = -height;
    }
    return standardized;
}
CGRectUnion = function(lhsRect, rhsRect)
{
    var lhsRectIsNull = !lhsRect || lhsRect === CGRectNull,
        rhsRectIsNull = !rhsRect || rhsRect === CGRectNull;
    if (lhsRectIsNull)
        return rhsRectIsNull ? CGRectNull : rhsRect;
    if (rhsRectIsNull)
        return lhsRectIsNull ? CGRectNull : lhsRect;
    var minX = MIN((lhsRect.origin.x), (rhsRect.origin.x)),
        minY = MIN((lhsRect.origin.y), (rhsRect.origin.y)),
        maxX = MAX((lhsRect.origin.x + lhsRect.size.width), (rhsRect.origin.x + rhsRect.size.width)),
        maxY = MAX((lhsRect.origin.y + lhsRect.size.height), (rhsRect.origin.y + rhsRect.size.height));
    return { origin: { x:minX, y:minY }, size: { width:maxX - minX, height:maxY - minY } };
}
CGRectInsetByInset = function(aRect, anInset) { return { origin: { x:(aRect).origin.x + (anInset).left, y:(aRect).origin.y + (anInset).top }, size: { width:(aRect).size.width - (anInset).left - (anInset).right, height:(aRect).size.height - (anInset).top - (anInset).bottom } }; };
CGPointFromString = function(aString)
{
    var comma = aString.indexOf(',');
    return { x:parseFloat(aString.substr(1, comma - 1)), y:parseFloat(aString.substring(comma + 1, aString.length)) };
}
CGSizeFromString = function(aString)
{
    var comma = aString.indexOf(',');
    return { width:parseFloat(aString.substr(1, comma - 1)), height:parseFloat(aString.substring(comma + 1, aString.length)) };
}
CGRectFromString = function(aString)
{
    var comma = aString.indexOf(',', aString.indexOf(',') + 1);
    return { origin:CGPointFromString(aString.substr(1, comma - 1)), size:CGSizeFromString(aString.substring(comma + 2, aString.length)) };
}
CGPointFromEvent = function(anEvent)
{
    return { x:anEvent.clientX, y:anEvent.clientY };
}
CGInsetUnion = function(lhsInset, rhsInset)
{
    return { top:(lhsInset.top + rhsInset.top), right:(lhsInset.right + rhsInset.right), bottom:(lhsInset.bottom + rhsInset.bottom), left:(lhsInset.left + rhsInset.left) };
}
CGInsetDifference = function(lhsInset, rhsInset)
{
    return { top:(lhsInset.top - rhsInset.top), right:(lhsInset.right - rhsInset.right), bottom:(lhsInset.bottom - rhsInset.bottom), left:(lhsInset.left - rhsInset.left) };
}
CGInsetFromString = function(aString)
{
    var numbers = aString.substr(1, aString.length - 2).split(',');
    return { top:(parseFloat(numbers[0])), right:(parseFloat(numbers[1])), bottom:(parseFloat(numbers[2])), left:(parseFloat(numbers[3])) };
}
CGInsetFromCPString = CGInsetFromString;
CPStringFromCGInset = function(anInset)
{
    return '{' + anInset.top + ", " + anInset.left + ", " + anInset.bottom + ", " + anInset.right + '}';
}
CGAlignStroke = function(coord, strokeWidth)
{
    return FLOOR(coord) === (coord) ? (coord) + (strokeWidth / 2) : (coord);
}
CGAlignCoordinate = function(coord)
{
    return FLOOR(coord);
}p;27;_CPCollectionKVCOperators.jt;4188;@STATIC;1.0;i;10;CPObject.jt;4154;objj_executeFile("CPObject.j", YES);
var _CPCollectionKVCOperatorSimpleRE = /^@(avg|count|m(ax|in)|sum)(\.|$)/;
{var the_class = objj_allocateClassPair(CPObject, "_CPCollectionKVCOperator"),
meta_class = the_class.isa;





objj_registerClassPair(the_class);
class_addMethods(meta_class, [new objj_method(sel_getUid("isSimpleCollectionOperator:"), function $_CPCollectionKVCOperator__isSimpleCollectionOperator_(self, _cmd, operator)
{
    return _CPCollectionKVCOperatorSimpleRE.test(operator);
}
,["BOOL","CPString"]), new objj_method(sel_getUid("performOperation:withCollection:propertyPath:"), function $_CPCollectionKVCOperator__performOperation_withCollection_propertyPath_(self, _cmd, operator, aCollection, propertyPath)
{
    var selector = CPSelectorFromString(operator + "ForCollection:propertyPath:");
    if (!objj_msgSend(self, "respondsToSelector:", selector))
        return objj_msgSend(aCollection, "valueForUndefinedKey:", "@" + operator);
    return objj_msgSend(self, "performSelector:withObject:withObject:", selector, aCollection, propertyPath);
}
,["id","CPString","id","CPString"]), new objj_method(sel_getUid("avgForCollection:propertyPath:"), function $_CPCollectionKVCOperator__avgForCollection_propertyPath_(self, _cmd, aCollection, propertyPath)
{
    if (!propertyPath)
        return objj_msgSend(aCollection, "valueForUndefinedKey:", "@avg");
    var objects = objj_msgSend(aCollection, "valueForKeyPath:", propertyPath),
        average = 0.0,
        enumerator = objj_msgSend(objects, "objectEnumerator"),
        object;
    while ((object = objj_msgSend(enumerator, "nextObject")) !== nil)
        average += objj_msgSend(object, "doubleValue");
    return average / objj_msgSend(objects, "count");
}
,["double","id","CPString"]), new objj_method(sel_getUid("minForCollection:propertyPath:"), function $_CPCollectionKVCOperator__minForCollection_propertyPath_(self, _cmd, aCollection, propertyPath)
{
    if (!propertyPath)
        return objj_msgSend(aCollection, "valueForUndefinedKey:", "@min");
    var objects = objj_msgSend(aCollection, "valueForKeyPath:", propertyPath);
    if (objj_msgSend(objects, "count") === 0)
        return nil;
    var enumerator = objj_msgSend(objects, "objectEnumerator"),
        min = objj_msgSend(enumerator, "nextObject"),
        object;
    while ((object = objj_msgSend(enumerator, "nextObject")) !== nil)
    {
        if (objj_msgSend(min, "compare:", object) > 0)
            min = object;
    }
    return min;
}
,["double","id","CPString"]), new objj_method(sel_getUid("maxForCollection:propertyPath:"), function $_CPCollectionKVCOperator__maxForCollection_propertyPath_(self, _cmd, aCollection, propertyPath)
{
    if (!propertyPath)
        return objj_msgSend(aCollection, "valueForUndefinedKey:", "@max");
    var objects = objj_msgSend(aCollection, "valueForKeyPath:", propertyPath);
    if (objj_msgSend(objects, "count") === 0)
        return nil;
    var enumerator = objj_msgSend(objects, "objectEnumerator"),
        max = objj_msgSend(enumerator, "nextObject"),
        object;
    while ((object = objj_msgSend(enumerator, "nextObject")) !== nil)
    {
        if (objj_msgSend(max, "compare:", object) < 0)
            max = object;
    }
    return max;
}
,["double","id","CPString"]), new objj_method(sel_getUid("sumForCollection:propertyPath:"), function $_CPCollectionKVCOperator__sumForCollection_propertyPath_(self, _cmd, aCollection, propertyPath)
{
    if (!propertyPath)
        return objj_msgSend(aCollection, "valueForUndefinedKey:", "@sum");
    var objects = objj_msgSend(aCollection, "valueForKeyPath:", propertyPath),
        sum = 0.0,
        enumerator = objj_msgSend(objects, "objectEnumerator"),
        object;
    while ((object = objj_msgSend(enumerator, "nextObject")) !== nil)
        sum += objj_msgSend(object, "doubleValue");
    return sum;
}
,["double","id","CPString"]), new objj_method(sel_getUid("countForCollection:propertyPath:"), function $_CPCollectionKVCOperator__countForCollection_propertyPath_(self, _cmd, aCollection, propertyPath)
{
    return objj_msgSend(aCollection, "count");
}
,["int","id","CPString"])]);
}p;13;CPArray+KVO.jt;21363;@STATIC;1.0;i;9;CPArray.ji;8;CPNull.ji;27;_CPCollectionKVCOperators.jt;21286;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPNull.j", YES);
objj_executeFile("_CPCollectionKVCOperators.j", YES);
//@class CPIndexSet
{
var the_class = objj_getClass("CPObject")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPObject\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("mutableArrayValueForKey:"), function $CPObject__mutableArrayValueForKey_(self, _cmd, aKey)
{
    return objj_msgSend(objj_msgSend(_CPKVCArray, "alloc"), "initWithKey:forProxyObject:", aKey, self);
}
,["id","id"]), new objj_method(sel_getUid("mutableArrayValueForKeyPath:"), function $CPObject__mutableArrayValueForKeyPath_(self, _cmd, aKeyPath)
{
    var dotIndex = aKeyPath.indexOf(".");
    if (dotIndex < 0)
        return objj_msgSend(self, "mutableArrayValueForKey:", aKeyPath);
    var firstPart = aKeyPath.substring(0, dotIndex),
        lastPart = aKeyPath.substring(dotIndex + 1);
    return objj_msgSend(objj_msgSend(self, "valueForKeyPath:", firstPart), "mutableArrayValueForKeyPath:", lastPart);
}
,["id","id"])]);
}
{var the_class = objj_allocateClassPair(CPMutableArray, "_CPKVCArray"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_proxyObject"), new objj_ivar("_key"), new objj_ivar("_insertSEL"), new objj_ivar("_insert"), new objj_ivar("_removeSEL"), new objj_ivar("_remove"), new objj_ivar("_replaceSEL"), new objj_ivar("_replace"), new objj_ivar("_insertManySEL"), new objj_ivar("_insertMany"), new objj_ivar("_removeManySEL"), new objj_ivar("_removeMany"), new objj_ivar("_replaceManySEL"), new objj_ivar("_replaceMany"), new objj_ivar("_objectAtIndexSEL"), new objj_ivar("_objectAtIndex"), new objj_ivar("_objectsAtIndexesSEL"), new objj_ivar("_objectsAtIndexes"), new objj_ivar("_countSEL"), new objj_ivar("_count"), new objj_ivar("_accessSEL"), new objj_ivar("_access"), new objj_ivar("_setSEL"), new objj_ivar("_set")]);






















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithKey:forProxyObject:"), function $_CPKVCArray__initWithKey_forProxyObject_(self, _cmd, aKey, anObject)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPKVCArray").super_class }, "init");
    self._key = aKey;
    self._proxyObject = anObject;
    var capitalizedKey = self._key.charAt(0).toUpperCase() + self._key.substring(1);
    self._insertSEL = sel_getName("insertObject:in" + capitalizedKey + "AtIndex:");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._insertSEL))
        self._insert = objj_msgSend(self._proxyObject, "methodForSelector:", self._insertSEL);
    self._removeSEL = sel_getName("removeObjectFrom" + capitalizedKey + "AtIndex:");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._removeSEL))
        self._remove = objj_msgSend(self._proxyObject, "methodForSelector:", self._removeSEL);
    self._replaceSEL = sel_getName("replaceObjectIn" + capitalizedKey + "AtIndex:withObject:");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._replaceSEL))
        self._replace = objj_msgSend(self._proxyObject, "methodForSelector:", self._replaceSEL);
    self._insertManySEL = sel_getName("insert" + capitalizedKey + ":atIndexes:");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._insertManySEL))
        self._insertMany = objj_msgSend(self._proxyObject, "methodForSelector:", self._insertManySEL);
    self._removeManySEL = sel_getName("remove" + capitalizedKey + "AtIndexes:");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._removeManySEL))
        self._removeMany = objj_msgSend(self._proxyObject, "methodForSelector:", self._removeManySEL);
    self._replaceManySEL = sel_getName("replace" + capitalizedKey + "AtIndexes:with" + capitalizedKey + ":");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._replaceManySEL))
        self._replaceMany = objj_msgSend(self._proxyObject, "methodForSelector:", self._replaceManySEL);
    self._objectAtIndexSEL = sel_getName("objectIn" + capitalizedKey + "AtIndex:");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._objectAtIndexSEL))
        self._objectAtIndex = objj_msgSend(self._proxyObject, "methodForSelector:", self._objectAtIndexSEL);
    self._objectsAtIndexesSEL = sel_getName(self._key + "AtIndexes:");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._objectsAtIndexesSEL))
        self._objectsAtIndexes = objj_msgSend(self._proxyObject, "methodForSelector:", self._objectsAtIndexesSEL);
    self._countSEL = sel_getName("countOf" + capitalizedKey);
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._countSEL))
        self._count = objj_msgSend(self._proxyObject, "methodForSelector:", self._countSEL);
    self._accessSEL = sel_getName(self._key);
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._accessSEL))
        self._access = objj_msgSend(self._proxyObject, "methodForSelector:", self._accessSEL);
    self._setSEL = sel_getName("set" + capitalizedKey + ":");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._setSEL))
        self._set = objj_msgSend(self._proxyObject, "methodForSelector:", self._setSEL);
    return self;
}
,["id","id","id"]), new objj_method(sel_getUid("copy"), function $_CPKVCArray__copy(self, _cmd)
{
    var i = 0,
        theCopy = [],
        count = objj_msgSend(self, "count");
    for (; i < count; i++)
        objj_msgSend(theCopy, "addObject:", objj_msgSend(self, "objectAtIndex:", i));
    return theCopy;
}
,["id"]), new objj_method(sel_getUid("_representedObject"), function $_CPKVCArray___representedObject(self, _cmd)
{
    if (self._access)
        return self._access(self._proxyObject, self._accessSEL);
    return objj_msgSend(self._proxyObject, "valueForKey:", self._key);
}
,["id"]), new objj_method(sel_getUid("_setRepresentedObject:"), function $_CPKVCArray___setRepresentedObject_(self, _cmd, anObject)
{
    if (self._set)
        return self._set(self._proxyObject, self._setSEL, anObject);
    objj_msgSend(self._proxyObject, "setValue:forKey:", anObject, self._key);
}
,["void","id"]), new objj_method(sel_getUid("count"), function $_CPKVCArray__count(self, _cmd)
{
    if (self._count)
        return self._count(self._proxyObject, self._countSEL);
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "count");
}
,["unsigned"]), new objj_method(sel_getUid("indexOfObject:inRange:"), function $_CPKVCArray__indexOfObject_inRange_(self, _cmd, anObject, aRange)
{
    var index = aRange.location,
        count = aRange.length,
        shouldIsEqual = !!anObject.isa;
    for (; index < count; ++index)
    {
        var object = objj_msgSend(self, "objectAtIndex:", index);
        if (anObject === object || shouldIsEqual && !!object.isa && objj_msgSend(anObject, "isEqual:", object))
            return index;
    }
    return CPNotFound;
}
,["int","CPObject","CPRange"]), new objj_method(sel_getUid("indexOfObject:"), function $_CPKVCArray__indexOfObject_(self, _cmd, anObject)
{
    return objj_msgSend(self, "indexOfObject:inRange:", anObject, CPMakeRange(0, objj_msgSend(self, "count")));
}
,["int","CPObject"]), new objj_method(sel_getUid("indexOfObjectIdenticalTo:inRange:"), function $_CPKVCArray__indexOfObjectIdenticalTo_inRange_(self, _cmd, anObject, aRange)
{
    var index = aRange.location,
        count = aRange.length;
    for (; index < count; ++index)
        if (anObject === objj_msgSend(self, "objectAtIndex:", index))
            return index;
    return CPNotFound;
}
,["int","CPObject","CPRange"]), new objj_method(sel_getUid("indexOfObjectIdenticalTo:"), function $_CPKVCArray__indexOfObjectIdenticalTo_(self, _cmd, anObject)
{
    return objj_msgSend(self, "indexOfObjectIdenticalTo:inRange:", anObject, CPMakeRange(0, objj_msgSend(self, "count")));
}
,["int","CPObject"]), new objj_method(sel_getUid("objectAtIndex:"), function $_CPKVCArray__objectAtIndex_(self, _cmd, anIndex)
{
    return objj_msgSend(objj_msgSend(self, "objectsAtIndexes:", objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex)), "firstObject");
}
,["id","unsigned"]), new objj_method(sel_getUid("objectsAtIndexes:"), function $_CPKVCArray__objectsAtIndexes_(self, _cmd, theIndexes)
{
    if (self._objectsAtIndexes)
        return self._objectsAtIndexes(self._proxyObject, self._objectsAtIndexesSEL, theIndexes);
    if (self._objectAtIndex)
    {
        var index = CPNotFound,
            objects = [];
        while ((index = objj_msgSend(theIndexes, "indexGreaterThanIndex:", index)) !== CPNotFound)
            objects.push(self._objectAtIndex(self._proxyObject, self._objectAtIndexSEL, index));
        return objects;
    }
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "objectsAtIndexes:", theIndexes);
}
,["CPArray","CPIndexSet"]), new objj_method(sel_getUid("addObject:"), function $_CPKVCArray__addObject_(self, _cmd, anObject)
{
    objj_msgSend(self, "insertObject:atIndex:", anObject, objj_msgSend(self, "count"));
}
,["void","id"]), new objj_method(sel_getUid("addObjectsFromArray:"), function $_CPKVCArray__addObjectsFromArray_(self, _cmd, anArray)
{
    var index = 0,
        count = objj_msgSend(anArray, "count");
    objj_msgSend(self, "insertObjects:atIndexes:", anArray, objj_msgSend(CPIndexSet, "indexSetWithIndexesInRange:", CPMakeRange(objj_msgSend(self, "count"), count)));
}
,["void","CPArray"]), new objj_method(sel_getUid("insertObject:atIndex:"), function $_CPKVCArray__insertObject_atIndex_(self, _cmd, anObject, anIndex)
{
    objj_msgSend(self, "insertObjects:atIndexes:", [anObject], objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex));
}
,["void","id","unsigned"]), new objj_method(sel_getUid("insertObjects:atIndexes:"), function $_CPKVCArray__insertObjects_atIndexes_(self, _cmd, theObjects, theIndexes)
{
    if (self._insertMany)
        self._insertMany(self._proxyObject, self._insertManySEL, theObjects, theIndexes);
    else if (self._insert)
    {
        var indexesArray = [];
        objj_msgSend(theIndexes, "getIndexes:maxCount:inIndexRange:", indexesArray, -1, nil);
        for (var index = 0; index < objj_msgSend(indexesArray, "count"); index++)
        {
            var objectIndex = objj_msgSend(indexesArray, "objectAtIndex:", index),
                object = objj_msgSend(theObjects, "objectAtIndex:", index);
            self._insert(self._proxyObject, self._insertSEL, object, objectIndex);
        }
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "insertObjects:atIndexes:", theObjects, theIndexes);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","CPArray","CPIndexSet"]), new objj_method(sel_getUid("removeObject:"), function $_CPKVCArray__removeObject_(self, _cmd, anObject)
{
    objj_msgSend(self, "removeObject:inRange:", anObject, CPMakeRange(0, objj_msgSend(self, "count")));
}
,["void","id"]), new objj_method(sel_getUid("removeObjectsInArray:"), function $_CPKVCArray__removeObjectsInArray_(self, _cmd, theObjects)
{
    if (self._removeMany)
    {
        var indexes = objj_msgSend(CPIndexSet, "indexSet"),
            index = objj_msgSend(theObjects, "count"),
            position = 0,
            count = objj_msgSend(self, "count");
        while (index--)
        {
            while ((position = objj_msgSend(self, "indexOfObject:inRange:", objj_msgSend(theObjects, "objectAtIndex:", index), { location:(position + 1), length:count })) !== CPNotFound)
                objj_msgSend(indexes, "addIndex:", position);
        }
        self._removeMany(self._proxyObject, self._removeManySEL, indexes);
    }
    else if (self._remove)
    {
        var index = objj_msgSend(theObjects, "count"),
            position;
        while (index--)
        {
            while ((position = objj_msgSend(self, "indexOfObject:", objj_msgSend(theObjects, "objectAtIndex:", index))) !== CPNotFound)
                self._remove(self._proxyObject, self._removeSEL, position);
        }
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "removeObjectsInArray:", theObjects);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","CPArray"]), new objj_method(sel_getUid("removeObject:inRange:"), function $_CPKVCArray__removeObject_inRange_(self, _cmd, theObject, theRange)
{
    if (self._remove)
        self._remove(self._proxyObject, self._removeSEL, objj_msgSend(self, "indexOfObject:inRange:", theObject, theRange));
    else if (self._removeMany)
    {
        var index = objj_msgSend(self, "indexOfObject:inRange:", theObject, theRange);
        self._removeMany(self._proxyObject, self._removeManySEL, objj_msgSend(CPIndexSet, "indexSetWithIndex:", index));
    }
    else
    {
        var index;
        while ((index = objj_msgSend(self, "indexOfObject:inRange:", theObject, theRange)) !== CPNotFound)
        {
            objj_msgSend(self, "removeObjectAtIndex:", index);
            theRange = CPIntersectionRange(CPMakeRange(index, self.length - index), theRange);
        }
    }
}
,["void","id","CPRange"]), new objj_method(sel_getUid("removeLastObject"), function $_CPKVCArray__removeLastObject(self, _cmd)
{
    objj_msgSend(self, "removeObjectsAtIndexes:", objj_msgSend(CPIndexSet, "indexSetWithIndex:", objj_msgSend(self, "count") - 1));
}
,["void"]), new objj_method(sel_getUid("removeObjectAtIndex:"), function $_CPKVCArray__removeObjectAtIndex_(self, _cmd, anIndex)
{
    objj_msgSend(self, "removeObjectsAtIndexes:", objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex));
}
,["void","unsigned"]), new objj_method(sel_getUid("removeObjectsAtIndexes:"), function $_CPKVCArray__removeObjectsAtIndexes_(self, _cmd, theIndexes)
{
    if (self._removeMany)
        self._removeMany(self._proxyObject, self._removeManySEL, theIndexes);
    else if (self._remove)
    {
        var index = objj_msgSend(theIndexes, "lastIndex");
        while (index !== CPNotFound)
        {
            self._remove(self._proxyObject, self._removeSEL, index)
            index = objj_msgSend(theIndexes, "indexLessThanIndex:", index);
        }
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "removeObjectsAtIndexes:", theIndexes);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","CPIndexSet"]), new objj_method(sel_getUid("replaceObjectAtIndex:withObject:"), function $_CPKVCArray__replaceObjectAtIndex_withObject_(self, _cmd, anIndex, anObject)
{
    objj_msgSend(self, "replaceObjectsAtIndexes:withObjects:", objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex), [anObject])
}
,["void","unsigned","id"]), new objj_method(sel_getUid("replaceObjectsAtIndexes:withObjects:"), function $_CPKVCArray__replaceObjectsAtIndexes_withObjects_(self, _cmd, theIndexes, theObjects)
{
    if (self._replaceMany)
        return self._replaceMany(self._proxyObject, self._replaceManySEL, theIndexes, theObjects);
    else if (self._replace)
    {
        var i = 0,
            index = objj_msgSend(theIndexes, "firstIndex");
        while (index !== CPNotFound)
        {
            self._replace(self._proxyObject, self._replaceSEL, index, objj_msgSend(theObjects, "objectAtIndex:", i++));
            index = objj_msgSend(theIndexes, "indexGreaterThanIndex:", index);
        }
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "replaceObjectsAtIndexes:withObjects:", theIndexes, theObjects);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","CPIndexSet","CPArray"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $_CPKVCArray__alloc(self, _cmd)
{
    var array = [];
    array.isa = self;
    var ivars = class_copyIvarList(self),
        count = ivars.length;
    while (count--)
        array[ivar_getName(ivars[count])] = nil;
    return array;
}
,["id"])]);
}
{
var the_class = objj_getClass("CPArray")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPArray\"");
var meta_class = the_class.isa;


class_addMethods(the_class, [new objj_method(sel_getUid("valueForKey:"), function $CPArray__valueForKey_(self, _cmd, aKey)
{
    if (aKey.charAt(0) === "@")
    {
        if (aKey.indexOf(".") !== -1)
            objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "called valueForKey: on an array with a complex key (" + aKey + "). use valueForKeyPath:");
        if (aKey === "@count")
            return self.length;
        return objj_msgSend(self, "valueForUndefinedKey:", aKey);
    }
    else
    {
        var newArray = [],
            enumerator = objj_msgSend(self, "objectEnumerator"),
            object;
        while ((object = objj_msgSend(enumerator, "nextObject")) !== nil)
        {
            var value = objj_msgSend(object, "valueForKey:", aKey);
            if (value === nil || value === undefined)
                value = objj_msgSend(CPNull, "null");
            newArray.push(value);
        }
        return newArray;
    }
}
,["id","CPString"]), new objj_method(sel_getUid("valueForKeyPath:"), function $CPArray__valueForKeyPath_(self, _cmd, aKeyPath)
{
    if (!aKeyPath)
        objj_msgSend(self, "valueForUndefinedKey:", "<empty path>");
    if (aKeyPath.charAt(0) === "@")
    {
        var dotIndex = aKeyPath.indexOf("."),
            operator,
            parameter;
        if (dotIndex !== -1)
        {
            operator = aKeyPath.substring(1, dotIndex);
            parameter = aKeyPath.substring(dotIndex + 1);
        }
        else
            operator = aKeyPath.substring(1);
        return objj_msgSend(_CPCollectionKVCOperator, "performOperation:withCollection:propertyPath:", operator, self, parameter);
    }
    else
    {
        var newArray = [],
            enumerator = objj_msgSend(self, "objectEnumerator"),
            object;
        while ((object = objj_msgSend(enumerator, "nextObject")) !== nil)
        {
            var value = objj_msgSend(object, "valueForKeyPath:", aKeyPath);
            if (value === nil || value === undefined)
                value = objj_msgSend(CPNull, "null");
            newArray.push(value);
        }
        return newArray;
    }
}
,["id","CPString"]), new objj_method(sel_getUid("setValue:forKey:"), function $CPArray__setValue_forKey_(self, _cmd, aValue, aKey)
{
    var enumerator = objj_msgSend(self, "objectEnumerator"),
        object;
    while ((object = objj_msgSend(enumerator, "nextObject")) !== nil)
        objj_msgSend(object, "setValue:forKey:", aValue, aKey);
}
,["void","id","CPString"]), new objj_method(sel_getUid("setValue:forKeyPath:"), function $CPArray__setValue_forKeyPath_(self, _cmd, aValue, aKeyPath)
{
    var enumerator = objj_msgSend(self, "objectEnumerator"),
        object;
    while ((object = objj_msgSend(enumerator, "nextObject")) !== nil)
        objj_msgSend(object, "setValue:forKeyPath:", aValue, aKeyPath);
}
,["void","id","CPString"])]);
}
{
var the_class = objj_getClass("CPArray")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPArray\"");
var meta_class = the_class.isa;


class_addMethods(the_class, [new objj_method(sel_getUid("addObserver:forKeyPath:options:context:"), function $CPArray__addObserver_forKeyPath_options_context_(self, _cmd, anObserver, aKeyPath, anOptions, aContext)
{
    objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "[CPArray " + CPStringFromSelector(_cmd) + "] is not supported. Key path: " + aKeyPath);
}
,["void","id","CPString","CPKeyValueObservingOptions","id"]), new objj_method(sel_getUid("removeObserver:forKeyPath:"), function $CPArray__removeObserver_forKeyPath_(self, _cmd, anObserver, aKeyPath)
{
    objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "[CPArray " + CPStringFromSelector(_cmd) + "] is not supported. Key path: " + aKeyPath);
}
,["void","id","CPString"]), new objj_method(sel_getUid("addObserver:toObjectsAtIndexes:forKeyPath:options:context:"), function $CPArray__addObserver_toObjectsAtIndexes_forKeyPath_options_context_(self, _cmd, anObserver, indexes, aKeyPath, options, context)
{
    var index = objj_msgSend(indexes, "firstIndex");
    while (index >= 0)
    {
        objj_msgSend(self[index], "addObserver:forKeyPath:options:context:", anObserver, aKeyPath, options, context);
        index = objj_msgSend(indexes, "indexGreaterThanIndex:", index);
    }
}
,["void","id","CPIndexSet","CPString","unsigned","id"]), new objj_method(sel_getUid("removeObserver:fromObjectsAtIndexes:forKeyPath:"), function $CPArray__removeObserver_fromObjectsAtIndexes_forKeyPath_(self, _cmd, anObserver, indexes, aKeyPath)
{
    var index = objj_msgSend(indexes, "firstIndex");
    while (index >= 0)
    {
        objj_msgSend(self[index], "removeObserver:forKeyPath:", anObserver, aKeyPath);
        index = objj_msgSend(indexes, "indexGreaterThanIndex:", index);
    }
}
,["void","id","CPIndexSet","CPString"])]);
}p;20;CPAttributedString.jt;21724;@STATIC;1.0;i;9;CPArray.ji;14;CPDictionary.ji;13;CPException.ji;10;CPObject.ji;9;CPRange.ji;10;CPString.jt;21611;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPRange.j", YES);
objj_executeFile("CPString.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPAttributedString"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_string"), new objj_ivar("_rangeEntries")]);



























objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPAttributedString__init(self, _cmd)
{
    return objj_msgSend(self, "initWithString:attributes:", "", nil);
}
,["id"]), new objj_method(sel_getUid("initWithString:"), function $CPAttributedString__initWithString_(self, _cmd, aString)
{
    return objj_msgSend(self, "initWithString:attributes:", aString, nil);
}
,["id","CPString"]), new objj_method(sel_getUid("initWithAttributedString:"), function $CPAttributedString__initWithAttributedString_(self, _cmd, aString)
{
    var string = objj_msgSend(self, "initWithString:attributes:", "", nil);
    objj_msgSend(string, "setAttributedString:", aString);
    return string;
}
,["id","CPAttributedString"]), new objj_method(sel_getUid("initWithString:attributes:"), function $CPAttributedString__initWithString_attributes_(self, _cmd, aString, attributes)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPAttributedString").super_class }, "init");
    if (self)
    {
        if (!attributes)
            attributes = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        self._string = "" + aString;
        self._rangeEntries = [makeRangeEntry(CPMakeRange(0, self._string.length), attributes)];
    }
    return self;
}
,["id","CPString","CPDictionary"]), new objj_method(sel_getUid("string"), function $CPAttributedString__string(self, _cmd)
{
    return self._string;
}
,["CPString"]), new objj_method(sel_getUid("mutableString"), function $CPAttributedString__mutableString(self, _cmd)
{
    return objj_msgSend(self, "string");
}
,["CPString"]), new objj_method(sel_getUid("length"), function $CPAttributedString__length(self, _cmd)
{
    return self._string.length;
}
,["unsigned"]), new objj_method(sel_getUid("_indexOfEntryWithIndex:"), function $CPAttributedString___indexOfEntryWithIndex_(self, _cmd, anIndex)
{
    if (anIndex < 0 || anIndex > self._string.length || anIndex === undefined)
        return CPNotFound;
    var sortFunction = function(index, entry)
    {
        if (CPLocationInRange(index, entry.range))
            return CPOrderedSame;
        else if (CPMaxRange(entry.range) <= index)
            return CPOrderedDescending;
        else
            return CPOrderedAscending;
    };
    return objj_msgSend(self._rangeEntries, "indexOfObject:inSortedRange:options:usingComparator:", anIndex, nil, 0, sortFunction);
}
,["unsigned","unsigned"]), new objj_method(sel_getUid("attributesAtIndex:effectiveRange:"), function $CPAttributedString__attributesAtIndex_effectiveRange_(self, _cmd, anIndex, aRange)
{
    var entryIndex = objj_msgSend(self, "_indexOfEntryWithIndex:", anIndex);
    if (entryIndex === CPNotFound)
        return objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    var matchingRange = self._rangeEntries[entryIndex];
    if (aRange)
    {
        aRange.location = matchingRange.range.location;
        aRange.length = matchingRange.range.length;
    }
    return matchingRange.attributes;
}
,["CPDictionary","unsigned","CPRangePointer"]), new objj_method(sel_getUid("attributesAtIndex:longestEffectiveRange:inRange:"), function $CPAttributedString__attributesAtIndex_longestEffectiveRange_inRange_(self, _cmd, anIndex, aRange, rangeLimit)
{
    var startingEntryIndex = objj_msgSend(self, "_indexOfEntryWithIndex:", anIndex);
    if (startingEntryIndex === CPNotFound)
        return objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    if (!aRange)
        return self._rangeEntries[startingEntryIndex].attributes;
    if (CPRangeInRange(self._rangeEntries[startingEntryIndex].range, rangeLimit))
    {
        aRange.location = rangeLimit.location;
        aRange.length = rangeLimit.length;
        return self._rangeEntries[startingEntryIndex].attributes;
    }
    var nextRangeIndex = startingEntryIndex - 1,
        currentEntry = self._rangeEntries[startingEntryIndex],
        comparisonDict = currentEntry.attributes;
    while (nextRangeIndex >= 0)
    {
        var nextEntry = self._rangeEntries[nextRangeIndex];
        if (CPMaxRange(nextEntry.range) > rangeLimit.location && objj_msgSend(nextEntry.attributes, "isEqualToDictionary:", comparisonDict))
        {
            currentEntry = nextEntry;
            nextRangeIndex--;
        }
        else
            break;
    }
    aRange.location = MAX(currentEntry.range.location, rangeLimit.location);
    currentEntry = self._rangeEntries[startingEntryIndex];
    nextRangeIndex = startingEntryIndex + 1;
    while (nextRangeIndex < self._rangeEntries.length)
    {
        var nextEntry = self._rangeEntries[nextRangeIndex];
        if (nextEntry.range.location < CPMaxRange(rangeLimit) && objj_msgSend(nextEntry.attributes, "isEqualToDictionary:", comparisonDict))
        {
            currentEntry = nextEntry;
            nextRangeIndex++;
        }
        else
            break;
    }
    aRange.length = MIN(CPMaxRange(currentEntry.range), CPMaxRange(rangeLimit)) - aRange.location;
    return comparisonDict;
}
,["CPDictionary","unsigned","CPRangePointer","CPRange"]), new objj_method(sel_getUid("attribute:atIndex:effectiveRange:"), function $CPAttributedString__attribute_atIndex_effectiveRange_(self, _cmd, attribute, index, aRange)
{
    if (!attribute)
    {
        if (aRange)
        {
            aRange.location = 0;
            aRange.length = self._string.length;
        }
        return nil;
    }
    return objj_msgSend(objj_msgSend(self, "attributesAtIndex:effectiveRange:", index, aRange), "valueForKey:", attribute);
}
,["id","CPString","unsigned","CPRangePointer"]), new objj_method(sel_getUid("attribute:atIndex:longestEffectiveRange:inRange:"), function $CPAttributedString__attribute_atIndex_longestEffectiveRange_inRange_(self, _cmd, attribute, anIndex, aRange, rangeLimit)
{
    var startingEntryIndex = objj_msgSend(self, "_indexOfEntryWithIndex:", anIndex);
    if (startingEntryIndex === CPNotFound || !attribute)
        return nil;
    if (!aRange)
        return objj_msgSend(self._rangeEntries[startingEntryIndex].attributes, "objectForKey:", attribute);
    if (CPRangeInRange(self._rangeEntries[startingEntryIndex].range, rangeLimit))
    {
        aRange.location = rangeLimit.location;
        aRange.length = rangeLimit.length;
        return objj_msgSend(self._rangeEntries[startingEntryIndex].attributes, "objectForKey:", attribute);
    }
    var nextRangeIndex = startingEntryIndex - 1,
        currentEntry = self._rangeEntries[startingEntryIndex],
        comparisonAttribute = objj_msgSend(currentEntry.attributes, "objectForKey:", attribute);
    while (nextRangeIndex >= 0)
    {
        var nextEntry = self._rangeEntries[nextRangeIndex];
        if (CPMaxRange(nextEntry.range) > rangeLimit.location && isEqual(comparisonAttribute, objj_msgSend(nextEntry.attributes, "objectForKey:", attribute)))
        {
            currentEntry = nextEntry;
            nextRangeIndex--;
        }
        else
            break;
    }
    aRange.location = MAX(currentEntry.range.location, rangeLimit.location);
    currentEntry = self._rangeEntries[startingEntryIndex];
    nextRangeIndex = startingEntryIndex + 1;
    while (nextRangeIndex < self._rangeEntries.length)
    {
        var nextEntry = self._rangeEntries[nextRangeIndex];
        if (nextEntry.range.location < CPMaxRange(rangeLimit) && isEqual(comparisonAttribute, objj_msgSend(nextEntry.attributes, "objectForKey:", attribute)))
        {
            currentEntry = nextEntry;
            nextRangeIndex++;
        }
        else
            break;
    }
    aRange.length = MIN(CPMaxRange(currentEntry.range), CPMaxRange(rangeLimit)) - aRange.location;
    return comparisonAttribute;
}
,["id","CPString","unsigned","CPRangePointer","CPRange"]), new objj_method(sel_getUid("isEqualToAttributedString:"), function $CPAttributedString__isEqualToAttributedString_(self, _cmd, aString)
{
    if (!aString)
        return NO;
    if (self._string !== objj_msgSend(aString, "string"))
        return NO;
    var myRange = CPMakeRange(),
        comparisonRange = CPMakeRange(),
        myAttributes = objj_msgSend(self, "attributesAtIndex:effectiveRange:", 0, myRange),
        comparisonAttributes = objj_msgSend(aString, "attributesAtIndex:effectiveRange:", 0, comparisonRange),
        length = self._string.length;
    while (CPMaxRange(CPUnionRange(myRange, comparisonRange)) < length)
    {
        if (CPIntersectionRange(myRange, comparisonRange).length > 0 &&
            !objj_msgSend(myAttributes, "isEqualToDictionary:", comparisonAttributes))
        {
            return NO;
        }
        else if (CPMaxRange(myRange) < CPMaxRange(comparisonRange))
            myAttributes = objj_msgSend(self, "attributesAtIndex:effectiveRange:", CPMaxRange(myRange), myRange);
        else
            comparisonAttributes = objj_msgSend(aString, "attributesAtIndex:effectiveRange:", CPMaxRange(comparisonRange), comparisonRange);
    }
    return YES;
}
,["BOOL","CPAttributedString"]), new objj_method(sel_getUid("isEqual:"), function $CPAttributedString__isEqual_(self, _cmd, anObject)
{
    if (anObject === self)
        return YES;
    if (objj_msgSend(anObject, "isKindOfClass:", objj_msgSend(self, "class")))
        return objj_msgSend(self, "isEqualToAttributedString:", anObject);
    return NO;
}
,["BOOL","id"]), new objj_method(sel_getUid("attributedSubstringFromRange:"), function $CPAttributedString__attributedSubstringFromRange_(self, _cmd, aRange)
{
    if (!aRange || CPMaxRange(aRange) > self._string.length || aRange.location < 0)
        objj_msgSend(CPException, "raise:reason:", CPRangeException, "tried to get attributedSubstring for an invalid range: "+(aRange?CPStringFromRange(aRange):"nil"));
    var newString = objj_msgSend(objj_msgSend(CPAttributedString, "alloc"), "initWithString:", self._string.substring(aRange.location, CPMaxRange(aRange))),
        entryIndex = objj_msgSend(self, "_indexOfEntryWithIndex:", aRange.location);
    if (entryIndex === CPNotFound)
        _CPRaiseRangeException(self, _cmd, aRange.location, self._string.length);
    var currentRangeEntry = self._rangeEntries[entryIndex],
        lastIndex = CPMaxRange(aRange);
    newString._rangeEntries = [];
    while (currentRangeEntry && CPMaxRange(currentRangeEntry.range) < lastIndex)
    {
        var newEntry = copyRangeEntry(currentRangeEntry);
        newEntry.range.location -= aRange.location;
        if (newEntry.range.location < 0)
        {
            newEntry.range.length += newEntry.range.location;
            newEntry.range.location = 0;
        }
        newString._rangeEntries.push(newEntry);
        currentRangeEntry = self._rangeEntries[++entryIndex];
    }
    if (currentRangeEntry)
    {
        var newRangeEntry = copyRangeEntry(currentRangeEntry);
        newRangeEntry.range.length = CPMaxRange(aRange) - newRangeEntry.range.location;
        newRangeEntry.range.location -= aRange.location;
        if (newRangeEntry.range.location < 0)
        {
            newRangeEntry.range.length += newRangeEntry.range.location;
            newRangeEntry.range.location = 0;
        }
        newString._rangeEntries.push(newRangeEntry);
    }
    return newString;
}
,["CPAttributedString","CPRange"]), new objj_method(sel_getUid("replaceCharactersInRange:withString:"), function $CPAttributedString__replaceCharactersInRange_withString_(self, _cmd, aRange, aString)
{
    if (!aString)
        aString = "";
    var startingIndex = objj_msgSend(self, "_indexOfEntryWithIndex:", aRange.location);
    if (startingIndex === CPNotFound)
        _CPRaiseRangeException(self, _cmd, aRange.location, self._string.length);
    var startingRangeEntry = self._rangeEntries[startingIndex],
        endingIndex = objj_msgSend(self, "_indexOfEntryWithIndex:", MAX(CPMaxRange(aRange) - 1, 0));
    if (endingIndex === CPNotFound)
        _CPRaiseRangeException(self, _cmd, MAX(CPMaxRange(aRange) - 1, 0), self._string.length);
    var endingRangeEntry = self._rangeEntries[endingIndex],
        additionalLength = aString.length - aRange.length;
    self._string = self._string.substring(0, aRange.location) + aString + self._string.substring(CPMaxRange(aRange));
    if (startingIndex === endingIndex)
        startingRangeEntry.range.length += additionalLength;
    else
    {
        endingRangeEntry.range.length = CPMaxRange(endingRangeEntry.range) - CPMaxRange(aRange);
        endingRangeEntry.range.location = CPMaxRange(aRange);
        startingRangeEntry.range.length = CPMaxRange(aRange) - startingRangeEntry.range.location;
        self._rangeEntries.splice(startingIndex, endingIndex - startingIndex);
    }
    endingIndex = startingIndex + 1;
    while (endingIndex < self._rangeEntries.length)
        self._rangeEntries[endingIndex++].range.location += additionalLength;
}
,["void","CPRange","CPString"]), new objj_method(sel_getUid("deleteCharactersInRange:"), function $CPAttributedString__deleteCharactersInRange_(self, _cmd, aRange)
{
    objj_msgSend(self, "replaceCharactersInRange:withString:", aRange, nil);
}
,["void","CPRange"]), new objj_method(sel_getUid("setAttributes:range:"), function $CPAttributedString__setAttributes_range_(self, _cmd, aDictionary, aRange)
{
    var startingEntryIndex = objj_msgSend(self, "_indexOfRangeEntryForIndex:splitOnMaxIndex:", aRange.location, YES),
        endingEntryIndex = objj_msgSend(self, "_indexOfRangeEntryForIndex:splitOnMaxIndex:", CPMaxRange(aRange), YES),
        current = startingEntryIndex;
    if (endingEntryIndex === CPNotFound)
        endingEntryIndex = self._rangeEntries.length;
    while (current < endingEntryIndex)
        self._rangeEntries[current++].attributes = objj_msgSend(aDictionary, "copy");
    objj_msgSend(self, "_coalesceRangeEntriesFromIndex:toIndex:", startingEntryIndex, endingEntryIndex);
}
,["void","CPDictionary","CPRange"]), new objj_method(sel_getUid("addAttributes:range:"), function $CPAttributedString__addAttributes_range_(self, _cmd, aDictionary, aRange)
{
    var startingEntryIndex = objj_msgSend(self, "_indexOfRangeEntryForIndex:splitOnMaxIndex:", aRange.location, YES),
        endingEntryIndex = objj_msgSend(self, "_indexOfRangeEntryForIndex:splitOnMaxIndex:", CPMaxRange(aRange), YES),
        current = startingEntryIndex;
    if (endingEntryIndex === CPNotFound)
        endingEntryIndex = self._rangeEntries.length;
    while (current < endingEntryIndex)
    {
        var keys = objj_msgSend(aDictionary, "allKeys"),
            count = objj_msgSend(keys, "count");
        while (count--)
            objj_msgSend(self._rangeEntries[current].attributes, "setObject:forKey:", objj_msgSend(aDictionary, "objectForKey:", keys[count]), keys[count]);
        current++;
    }
    objj_msgSend(self, "_coalesceRangeEntriesFromIndex:toIndex:", startingEntryIndex, endingEntryIndex);
}
,["void","CPDictionary","CPRange"]), new objj_method(sel_getUid("addAttribute:value:range:"), function $CPAttributedString__addAttribute_value_range_(self, _cmd, anAttribute, aValue, aRange)
{
    objj_msgSend(self, "addAttributes:range:", objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", aValue, anAttribute), aRange);
}
,["void","CPString","id","CPRange"]), new objj_method(sel_getUid("removeAttribute:range:"), function $CPAttributedString__removeAttribute_range_(self, _cmd, anAttribute, aRange)
{
    var startingEntryIndex = objj_msgSend(self, "_indexOfRangeEntryForIndex:splitOnMaxIndex:", aRange.location, YES),
        endingEntryIndex = objj_msgSend(self, "_indexOfRangeEntryForIndex:splitOnMaxIndex:", CPMaxRange(aRange), YES),
        current = startingEntryIndex;
    if (endingEntryIndex === CPNotFound)
        endingEntryIndex = self._rangeEntries.length;
    while (current < endingEntryIndex)
        objj_msgSend(self._rangeEntries[current++].attributes, "removeObjectForKey:", anAttribute);
    objj_msgSend(self, "_coalesceRangeEntriesFromIndex:toIndex:", startingEntryIndex, endingEntryIndex);
}
,["void","CPString","CPRange"]), new objj_method(sel_getUid("appendAttributedString:"), function $CPAttributedString__appendAttributedString_(self, _cmd, aString)
{
    objj_msgSend(self, "insertAttributedString:atIndex:", aString, self._string.length);
}
,["void","CPAttributedString"]), new objj_method(sel_getUid("insertAttributedString:atIndex:"), function $CPAttributedString__insertAttributedString_atIndex_(self, _cmd, aString, anIndex)
{
    if (anIndex < 0 || anIndex > objj_msgSend(self, "length"))
        objj_msgSend(CPException, "raise:reason:", CPRangeException, "tried to insert attributed string at an invalid index: "+anIndex);
    var entryIndexOfNextEntry = objj_msgSend(self, "_indexOfRangeEntryForIndex:splitOnMaxIndex:", anIndex, YES),
        otherRangeEntries = aString._rangeEntries,
        length = objj_msgSend(aString, "length");
    if (entryIndexOfNextEntry === CPNotFound)
        entryIndexOfNextEntry = self._rangeEntries.length;
    self._string = self._string.substring(0, anIndex) + aString._string + self._string.substring(anIndex);
    var current = entryIndexOfNextEntry;
    while (current < self._rangeEntries.length)
        self._rangeEntries[current++].range.location += length;
    var newRangeEntryCount = otherRangeEntries.length,
        index = 0;
    while (index < newRangeEntryCount)
    {
        var entryCopy = copyRangeEntry(otherRangeEntries[index++]);
        entryCopy.range.location += anIndex;
        self._rangeEntries.splice(entryIndexOfNextEntry - 1 + index, 0, entryCopy);
    }
}
,["void","CPAttributedString","unsigned"]), new objj_method(sel_getUid("replaceCharactersInRange:withAttributedString:"), function $CPAttributedString__replaceCharactersInRange_withAttributedString_(self, _cmd, aRange, aString)
{
    objj_msgSend(self, "deleteCharactersInRange:", aRange);
    objj_msgSend(self, "insertAttributedString:atIndex:", aString, aRange.location);
}
,["void","CPRange","CPAttributedString"]), new objj_method(sel_getUid("setAttributedString:"), function $CPAttributedString__setAttributedString_(self, _cmd, aString)
{
    self._string = aString._string;
    self._rangeEntries = [];
    var i = 0,
        count = aString._rangeEntries.length;
    for (; i < count; i++)
        self._rangeEntries.push(copyRangeEntry(aString._rangeEntries[i]));
}
,["void","CPAttributedString"]), new objj_method(sel_getUid("_indexOfRangeEntryForIndex:splitOnMaxIndex:"), function $CPAttributedString___indexOfRangeEntryForIndex_splitOnMaxIndex_(self, _cmd, characterIndex, split)
{
    var index = objj_msgSend(self, "_indexOfEntryWithIndex:", characterIndex);
    if (index === CPNotFound)
        return index;
    var rangeEntry = self._rangeEntries[index];
    if (rangeEntry.range.location === characterIndex || (CPMaxRange(rangeEntry.range) - 1 === characterIndex && !split))
        return index;
    var newEntries = splitRangeEntryAtIndex(rangeEntry, characterIndex);
    self._rangeEntries.splice(index, 1, newEntries[0], newEntries[1]);
    index++;
    return index;
}
,["Number","unsigned","BOOL"]), new objj_method(sel_getUid("_coalesceRangeEntriesFromIndex:toIndex:"), function $CPAttributedString___coalesceRangeEntriesFromIndex_toIndex_(self, _cmd, start, end)
{
    var current = start;
    if (end >= self._rangeEntries.length)
        end = self._rangeEntries.length - 1;
    while (current < end)
    {
        var a = self._rangeEntries[current],
            b = self._rangeEntries[current + 1];
        if (objj_msgSend(a.attributes, "isEqualToDictionary:", b.attributes))
        {
            a.range.length = CPMaxRange(b.range) - a.range.location;
            self._rangeEntries.splice(current + 1, 1);
            end--;
        }
        else
            current++;
    }
}
,["void","unsigned","unsigned"]), new objj_method(sel_getUid("beginEditing"), function $CPAttributedString__beginEditing(self, _cmd)
{
}
,["void"]), new objj_method(sel_getUid("endEditing"), function $CPAttributedString__endEditing(self, _cmd)
{
}
,["void"])]);
}
{var the_class = objj_allocateClassPair(CPAttributedString, "CPMutableAttributedString"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
}
var isEqual = function(a, b)
{
    if (a === b)
        return YES;
    if (objj_msgSend(a, "respondsToSelector:", sel_getUid("isEqual:")) && objj_msgSend(a, "isEqual:", b))
        return YES;
    return NO;
};
var makeRangeEntry = function( aRange, attributes)
{
    return {range:aRange, attributes:objj_msgSend(attributes, "copy")};
};
var copyRangeEntry = function( aRangeEntry)
{
    return makeRangeEntry(CPMakeRangeCopy(aRangeEntry.range), objj_msgSend(aRangeEntry.attributes, "copy"));
};
var splitRangeEntryAtIndex = function( aRangeEntry, anIndex)
{
    var newRangeEntry = copyRangeEntry(aRangeEntry),
        cachedIndex = CPMaxRange(aRangeEntry.range);
    aRangeEntry.range.length = anIndex - aRangeEntry.range.location;
    newRangeEntry.range.location = anIndex;
    newRangeEntry.range.length = cachedIndex - anIndex;
    newRangeEntry.attributes = objj_msgSend(newRangeEntry.attributes, "copy");
    return [aRangeEntry, newRangeEntry];
};p;10;CPBundle.jt;5751;@STATIC;1.0;i;14;CPDictionary.ji;16;CPNotification.ji;22;CPNotificationCenter.ji;10;CPObject.jt;5650;objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPNotification.j", YES);
objj_executeFile("CPNotificationCenter.j", YES);
objj_executeFile("CPObject.j", YES);
CPBundleDidLoadNotification = "CPBundleDidLoadNotification";
var CPBundlesForURLStrings = { };
{var the_class = objj_allocateClassPair(CPObject, "CPBundle"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_bundle"), new objj_ivar("_delegate")]);




















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithURL:"), function $CPBundle__initWithURL_(self, _cmd, aURL)
{
    aURL = new CFURL(aURL);
    var URLString = aURL.absoluteString(),
        existingBundle = CPBundlesForURLStrings[URLString];
    if (existingBundle)
        return existingBundle;
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPBundle").super_class }, "init");
    if (self)
    {
        self._bundle = new CFBundle(aURL);
        CPBundlesForURLStrings[URLString] = self;
    }
    return self;
}
,["id","CPURL"]), new objj_method(sel_getUid("initWithPath:"), function $CPBundle__initWithPath_(self, _cmd, aPath)
{
    return objj_msgSend(self, "initWithURL:", aPath);
}
,["id","CPString"]), new objj_method(sel_getUid("classNamed:"), function $CPBundle__classNamed_(self, _cmd, aString)
{
}
,["Class","CPString"]), new objj_method(sel_getUid("bundleURL"), function $CPBundle__bundleURL(self, _cmd)
{
    return self._bundle.bundleURL();
}
,["CPURL"]), new objj_method(sel_getUid("bundlePath"), function $CPBundle__bundlePath(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "bundleURL"), "path");
}
,["CPString"]), new objj_method(sel_getUid("resourcePath"), function $CPBundle__resourcePath(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "resourceURL"), "path");
}
,["CPString"]), new objj_method(sel_getUid("resourceURL"), function $CPBundle__resourceURL(self, _cmd)
{
    return self._bundle.resourcesDirectoryURL();
}
,["CPURL"]), new objj_method(sel_getUid("principalClass"), function $CPBundle__principalClass(self, _cmd)
{
    var className = objj_msgSend(self, "objectForInfoDictionaryKey:", "CPPrincipalClass");
    return className ? CPClassFromString(className) : Nil;
}
,["Class"]), new objj_method(sel_getUid("bundleIdentifier"), function $CPBundle__bundleIdentifier(self, _cmd)
{
    return objj_msgSend(self, "objectForInfoDictionaryKey:", "CPBundleIdentifier");
}
,["CPString"]), new objj_method(sel_getUid("isLoaded"), function $CPBundle__isLoaded(self, _cmd)
{
    return self._bundle.isLoaded();
}
,["BOOL"]), new objj_method(sel_getUid("pathForResource:"), function $CPBundle__pathForResource_(self, _cmd, aFilename)
{
    return self._bundle.pathForResource(aFilename);
}
,["CPString","CPString"]), new objj_method(sel_getUid("infoDictionary"), function $CPBundle__infoDictionary(self, _cmd)
{
    return self._bundle.infoDictionary();
}
,["CPDictionary"]), new objj_method(sel_getUid("objectForInfoDictionaryKey:"), function $CPBundle__objectForInfoDictionaryKey_(self, _cmd, aKey)
{
    return self._bundle.valueForInfoDictionaryKey(aKey);
}
,["id","CPString"]), new objj_method(sel_getUid("loadWithDelegate:"), function $CPBundle__loadWithDelegate_(self, _cmd, aDelegate)
{
    self._delegate = aDelegate;
    self._bundle.addEventListener("load", function()
    {
        objj_msgSend(self._delegate, "bundleDidFinishLoading:", self);
        objj_msgSend(objj_msgSend(CPNotificationCenter, "defaultCenter"), "postNotificationName:object:userInfo:", CPBundleDidLoadNotification, self, nil);
    });
    self._bundle.addEventListener("error", function()
    {
        CPLog.error("Could not find bundle: " + self);
    });
    self._bundle.load(YES);
}
,["void","id"]), new objj_method(sel_getUid("staticResourceURLs"), function $CPBundle__staticResourceURLs(self, _cmd)
{
    var staticResourceURLs = [],
        staticResources = self._bundle.staticResources(),
        index = 0,
        count = objj_msgSend(staticResources, "count");
    for (; index < count; ++index)
        objj_msgSend(staticResourceURLs, "addObject:", staticResources[index].URL());
    return staticResourceURLs;
}
,["CPArray"]), new objj_method(sel_getUid("environments"), function $CPBundle__environments(self, _cmd)
{
    return self._bundle.environments();
}
,["CPArray"]), new objj_method(sel_getUid("mostEligibleEnvironment"), function $CPBundle__mostEligibleEnvironment(self, _cmd)
{
    return self._bundle.mostEligibleEnvironment();
}
,["CPString"]), new objj_method(sel_getUid("description"), function $CPBundle__description(self, _cmd)
{
    return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPBundle").super_class }, "description") + "(" + objj_msgSend(self, "bundlePath") + ")";
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("bundleWithURL:"), function $CPBundle__bundleWithURL_(self, _cmd, aURL)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithURL:", aURL);
}
,["CPBundle","CPURL"]), new objj_method(sel_getUid("bundleWithPath:"), function $CPBundle__bundleWithPath_(self, _cmd, aPath)
{
    return objj_msgSend(self, "bundleWithURL:", aPath);
}
,["CPBundle","CPString"]), new objj_method(sel_getUid("bundleForClass:"), function $CPBundle__bundleForClass_(self, _cmd, aClass)
{
    return objj_msgSend(self, "bundleWithURL:", CFBundle.bundleForClass(aClass).bundleURL());
}
,["CPBundle","Class"]), new objj_method(sel_getUid("mainBundle"), function $CPBundle__mainBundle(self, _cmd)
{
    return objj_msgSend(CPBundle, "bundleWithPath:", CFBundle.mainBundle().bundleURL());
}
,["CPBundle"])]);
}p;22;CPByteCountFormatter.jt;12313;@STATIC;1.0;i;19;CPNumberFormatter.ji;10;CPString.jt;12254;objj_executeFile("CPNumberFormatter.j", YES);
objj_executeFile("CPString.j", YES);
CPByteCountFormatterUseDefault = 0;
CPByteCountFormatterUseBytes = 1 << 0;
CPByteCountFormatterUseKB = 1 << 1;
CPByteCountFormatterUseMB = 1 << 2;
CPByteCountFormatterUseGB = 1 << 3;
CPByteCountFormatterUseTB = 1 << 4;
CPByteCountFormatterUsePB = 1 << 5;
CPByteCountFormatterUseAll = 0xFFFF;
CPByteCountFormatterCountStyleFile = 0;
CPByteCountFormatterCountStyleMemory = 1;
CPByteCountFormatterCountStyleDecimal = 2;
CPByteCountFormatterCountStyleBinary = 3;
var CPByteCountFormatterUnits = [ "bytes", "KB", "MB", "GB", "TB", "PB" ];
{var the_class = objj_allocateClassPair(CPFormatter, "CPByteCountFormatter"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_countStyle"), new objj_ivar("_allowsNonnumericFormatting"), new objj_ivar("_includesActualByteCount"), new objj_ivar("_includesCount"), new objj_ivar("_includesUnit"), new objj_ivar("_adaptive"), new objj_ivar("_zeroPadsFractionDigits"), new objj_ivar("_allowedUnits"), new objj_ivar("_numberFormatter")]);



















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPByteCountFormatter__init(self, _cmd)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPByteCountFormatter").super_class }, "init"))
    {
        self._adaptive = YES;
        self._allowedUnits = CPByteCountFormatterUseDefault;
        self._allowsNonnumericFormatting = YES;
        self._countStyle = CPByteCountFormatterCountStyleFile;
        self._includesActualByteCount = NO;
        self._includesCount = YES;
        self._includesUnit = YES;
        self._zeroPadsFractionDigits = NO;
        self._numberFormatter = objj_msgSend(CPNumberFormatter, "new");
        objj_msgSend(self._numberFormatter, "setNumberStyle:", CPNumberFormatterDecimalStyle);
        objj_msgSend(self._numberFormatter, "setMinimumFractionDigits:", 0);
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("stringFromByteCount:"), function $CPByteCountFormatter__stringFromByteCount_(self, _cmd, byteCount)
{
    var divisor,
        exponent = 0,
        unitIndex = ((self._allowedUnits === 0) || (self._allowedUnits & CPByteCountFormatterUseBytes)) ? 0 : -1,
        bytes = byteCount,
        unitBytes = bytes,
        unitCount = objj_msgSend(CPByteCountFormatterUnits, "count");
    if (self._countStyle === CPByteCountFormatterCountStyleFile ||
        self._countStyle === CPByteCountFormatterCountStyleDecimal)
        divisor = 1000;
    else
        divisor = 1024;
    while ((bytes >= divisor) && (exponent < unitCount))
    {
        bytes /= divisor;
        ++exponent;
        if (self._allowedUnits === 0 || (self._allowedUnits & (1 << exponent)))
        {
            unitIndex = exponent;
            unitBytes = bytes;
        }
    }
    if (unitIndex === -1)
        for (var i = 1; i < unitCount; ++i)
        {
            unitBytes /= divisor;
            if ((self._allowedUnits === 0) || (self._allowedUnits & (1 << i)))
            {
                unitIndex = i;
                break;
            }
        }
    var minDigits = 0,
        maxDigits = CPDecimalNoScale;
    if (unitBytes >= 1.0)
    {
        if (self._adaptive)
        {
            var digits;
            if (exponent <= 1)
                digits = 0;
            else if (exponent == 2)
                digits = 1;
            else
                digits = 2;
            maxDigits = digits;
            if (self._zeroPadsFractionDigits)
                minDigits = digits;
        }
        else
        {
            if (self._zeroPadsFractionDigits)
                minDigits = 2;
            if (bytes >= 1)
                maxDigits = 2;
        }
    }
    objj_msgSend(self._numberFormatter, "setMinimumFractionDigits:", minDigits);
    objj_msgSend(self._numberFormatter, "setMaximumFractionDigits:", maxDigits);
    var parts = [];
    if (self._includesCount)
    {
        if (self._allowsNonnumericFormatting && bytes === 0)
            objj_msgSend(parts, "addObject:", "Zero");
        else
            objj_msgSend(parts, "addObject:", objj_msgSend(self._numberFormatter, "stringFromNumber:", unitBytes));
    }
    if (self._includesUnit)
        objj_msgSend(parts, "addObject:", CPByteCountFormatterUnits[unitIndex]);
    if ((unitIndex > 0) && self._includesCount && self._includesUnit && self._includesActualByteCount)
    {
        objj_msgSend(self._numberFormatter, "setMaximumFractionDigits:", 0);
        objj_msgSend(parts, "addObject:", objj_msgSend(CPString, "stringWithFormat:", "(%s bytes)", objj_msgSend(self._numberFormatter, "stringFromNumber:", byteCount)));
    }
    var result = objj_msgSend(parts, "componentsJoinedByString:", " ");
    if (byteCount === 1)
        return objj_msgSend(result, "stringByReplacingOccurrencesOfString:withString:", "bytes", "byte");
    else
        return result;
}
,["CPString","int"]), new objj_method(sel_getUid("stringForObjectValue:"), function $CPByteCountFormatter__stringForObjectValue_(self, _cmd, anObject)
{
    if (objj_msgSend(anObject, "isKindOfClass:", CPNumber))
        return objj_msgSend(self, "stringFromByteCount:", anObject);
    else
        return nil;
}
,["CPString","id"]), new objj_method(sel_getUid("getObjectValue:forString:errorDescription:"), function $CPByteCountFormatter__getObjectValue_forString_errorDescription_(self, _cmd, anObject, aString, anError)
{
    return NO;
}
,["BOOL","id","CPString","CPString"]), new objj_method(sel_getUid("countStyle"), function $CPByteCountFormatter__countStyle(self, _cmd)
{
    return self._countStyle;
}
,["int"]), new objj_method(sel_getUid("setCountStyle:"), function $CPByteCountFormatter__setCountStyle_(self, _cmd, style)
{
    self._countStyle = style;
}
,["void","int"]), new objj_method(sel_getUid("allowsNonnumericFormatting"), function $CPByteCountFormatter__allowsNonnumericFormatting(self, _cmd)
{
    return self._allowsNonnumericFormatting;
}
,["BOOL"]), new objj_method(sel_getUid("setAllowsNonnumericFormatting:"), function $CPByteCountFormatter__setAllowsNonnumericFormatting_(self, _cmd, shouldAllowNonnumericFormatting)
{
    self._allowsNonnumericFormatting = shouldAllowNonnumericFormatting;
}
,["void","BOOL"]), new objj_method(sel_getUid("includesActualByteCount"), function $CPByteCountFormatter__includesActualByteCount(self, _cmd)
{
    return self._includesActualByteCount;
}
,["BOOL"]), new objj_method(sel_getUid("setIncludesActualByteCount:"), function $CPByteCountFormatter__setIncludesActualByteCount_(self, _cmd, shouldIncludeActualByteCount)
{
    self._includesActualByteCount = shouldIncludeActualByteCount;
}
,["void","BOOL"]), new objj_method(sel_getUid("isAdaptive"), function $CPByteCountFormatter__isAdaptive(self, _cmd)
{
    return self._adaptive;
}
,["BOOL"]), new objj_method(sel_getUid("setAdaptive:"), function $CPByteCountFormatter__setAdaptive_(self, _cmd, shouldBeAdaptive)
{
    self._adaptive = shouldBeAdaptive;
}
,["void","BOOL"]), new objj_method(sel_getUid("allowedUnits"), function $CPByteCountFormatter__allowedUnits(self, _cmd)
{
    return self._allowedUnits;
}
,["int"]), new objj_method(sel_getUid("setAllowedUnits:"), function $CPByteCountFormatter__setAllowedUnits_(self, _cmd, allowed)
{
    self._allowedUnits = allowed;
}
,["void","int"]), new objj_method(sel_getUid("includesCount"), function $CPByteCountFormatter__includesCount(self, _cmd)
{
    return self._includesCount;
}
,["BOOL"]), new objj_method(sel_getUid("setIncludesCount:"), function $CPByteCountFormatter__setIncludesCount_(self, _cmd, shouldIncludeCount)
{
    self._includesCount = shouldIncludeCount;
}
,["void","BOOL"]), new objj_method(sel_getUid("includesUnit"), function $CPByteCountFormatter__includesUnit(self, _cmd)
{
    return self._includesUnit;
}
,["BOOL"]), new objj_method(sel_getUid("setIncludesUnit:"), function $CPByteCountFormatter__setIncludesUnit_(self, _cmd, shouldIncludeUnit)
{
    self._includesUnit = shouldIncludeUnit;
}
,["void","BOOL"]), new objj_method(sel_getUid("zeroPadsFractionDigits"), function $CPByteCountFormatter__zeroPadsFractionDigits(self, _cmd)
{
    return self._zeroPadsFractionDigits;
}
,["BOOL"]), new objj_method(sel_getUid("setZeroPadsFractionDigits:"), function $CPByteCountFormatter__setZeroPadsFractionDigits_(self, _cmd, shouldZeroPad)
{
    self._zeroPadsFractionDigits = shouldZeroPad;
}
,["void","BOOL"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("stringFromByteCount:countStyle:"), function $CPByteCountFormatter__stringFromByteCount_countStyle_(self, _cmd, byteCount, countStyle)
{
    var formatter = objj_msgSend(CPByteCountFormatter, "new");
    objj_msgSend(formatter, "setCountStyle:", countStyle);
    return objj_msgSend(formatter, "stringFromByteCount:", byteCount);
}
,["CPString","int","int"])]);
}
var CPByteCountFormatterCountStyleKey = "CPByteCountFormatterCountStyleKey",
    CPByteCountFormatterAllowsNonnumericFormattingKey = "CPByteCountFormatterAllowsNonnumericFormattingKey",
    CPByteCountFormatterIncludesActualByteCountKey = "CPByteCountFormatterIncludesActualByteCountKey",
    CPByteCountFormatterIncludesCountKey = "CPByteCountFormatterIncludesCountKey",
    CPByteCountFormatterIncludesUnitKey = "CPByteCountFormatterIncludesUnitKey",
    CPByteCountFormatterAdaptiveKey = "CPByteCountFormatterAdaptiveKey",
    CPByteCountFormatterZeroPadsFractionDigitsKey = "CPByteCountFormatterZeroPadsFractionDigitsKey",
    CPByteCountFormatterAllowedUnitsKey = "CPByteCountFormatterAllowedUnitsKey";
{
var the_class = objj_getClass("CPByteCountFormatter")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPByteCountFormatter\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPByteCountFormatter__initWithCoder_(self, _cmd, aCoder)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPByteCountFormatter").super_class }, "initWithCoder:", aCoder);
    if (self)
    {
        self._countStyle = objj_msgSend(aCoder, "decodeIntForKey:", CPByteCountFormatterCountStyleKey);
        self._allowsNonnumericFormatting = objj_msgSend(aCoder, "decodeBoolForKey:", CPByteCountFormatterAllowsNonnumericFormattingKey);
        self._includesActualByteCount = objj_msgSend(aCoder, "decodeBoolForKey:", CPByteCountFormatterIncludesActualByteCountKey);
        self._includesCount = objj_msgSend(aCoder, "decodeBoolForKey:", CPByteCountFormatterIncludesCountKey);
        self._includesUnit = objj_msgSend(aCoder, "decodeBoolForKey:", CPByteCountFormatterIncludesUnitKey);
        self._adaptive = objj_msgSend(aCoder, "decodeBoolForKey:", CPByteCountFormatterAdaptiveKey);
        self._zeroPadsFractionDigits = objj_msgSend(aCoder, "decodeBoolForKey:", CPByteCountFormatterZeroPadsFractionDigitsKey);
        self._allowedUnits = objj_msgSend(aCoder, "decodeIntForKey:", CPByteCountFormatterAllowedUnitsKey);
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPByteCountFormatter__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPByteCountFormatter").super_class }, "encodeWithCoder:", aCoder);
    objj_msgSend(aCoder, "encodeInt:forKey:", self._countStyle, CPByteCountFormatterCountStyleKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._allowsNonnumericFormatting, CPByteCountFormatterAllowsNonnumericFormattingKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._includesActualByteCount, CPByteCountFormatterIncludesActualByteCountKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._includesCount, CPByteCountFormatterIncludesCountKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._includesUnit, CPByteCountFormatterIncludesUnitKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._adaptive, CPByteCountFormatterAdaptiveKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._zeroPadsFractionDigits, CPByteCountFormatterZeroPadsFractionDigitsKey);
    objj_msgSend(aCoder, "encodeInt:forKey:", self._allowedUnits, CPByteCountFormatterAllowedUnitsKey);
}
,["void","CPCoder"])]);
}p;16;CPCharacterSet.jt;37038;@STATIC;1.0;i;9;CPArray.ji;13;CPException.ji;10;CPObject.ji;10;CPString.ji;7;CPURL.jt;36946;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("CPURL.j", YES);
var _builtInCharacterSets = {};
{var the_class = objj_allocateClassPair(CPObject, "CPCharacterSet"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_inverted")]);


















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPCharacterSet__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPCharacterSet").super_class }, "init");
    if (self)
        self._inverted = NO;
    return self;
}
,["id"]), new objj_method(sel_getUid("invert"), function $CPCharacterSet__invert(self, _cmd)
{
    self._inverted = !self._inverted;
}
,["void"]), new objj_method(sel_getUid("characterIsMember:"), function $CPCharacterSet__characterIsMember_(self, _cmd, aCharacter)
{
}
,["BOOL","CPString"]), new objj_method(sel_getUid("hasMemberInPlane:"), function $CPCharacterSet__hasMemberInPlane_(self, _cmd, aPlane)
{
}
,["BOOL","int"]), new objj_method(sel_getUid("_setInverted:"), function $CPCharacterSet___setInverted_(self, _cmd, flag)
{
    self._inverted = flag;
}
,["void",null])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("characterSetWithCharactersInString:"), function $CPCharacterSet__characterSetWithCharactersInString_(self, _cmd, aString)
{
    return objj_msgSend(objj_msgSend(_CPStringContentCharacterSet, "alloc"), "initWithString:", aString);
}
,["id","CPString"]), new objj_method(sel_getUid("characterSetWithRange:"), function $CPCharacterSet__characterSetWithRange_(self, _cmd, aRange)
{
    return objj_msgSend(objj_msgSend(_CPRangeCharacterSet, "alloc"), "initWithRange:", aRange);
}
,["id","CPRange"]), new objj_method(sel_getUid("alphanumericCharacterSet"), function $CPCharacterSet__alphanumericCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("controlCharacterSet"), function $CPCharacterSet__controlCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("decimalDigitCharacterSet"), function $CPCharacterSet__decimalDigitCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("decomposableCharacterSet"), function $CPCharacterSet__decomposableCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("illegalCharacterSet"), function $CPCharacterSet__illegalCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("letterCharacterSet"), function $CPCharacterSet__letterCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("lowercaseLetterCharacterSet"), function $CPCharacterSet__lowercaseLetterCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("nonBaseCharacterSet"), function $CPCharacterSet__nonBaseCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("punctuationCharacterSet"), function $CPCharacterSet__punctuationCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("uppercaseLetterCharacterSet"), function $CPCharacterSet__uppercaseLetterCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("whitespaceAndNewlineCharacterSet"), function $CPCharacterSet__whitespaceAndNewlineCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("whitespaceCharacterSet"), function $CPCharacterSet__whitespaceCharacterSet(self, _cmd)
{
    return objj_msgSend(CPCharacterSet, "_sharedCharacterSetWithName:", _cmd);
}
,["id"]), new objj_method(sel_getUid("_sharedCharacterSetWithName:"), function $CPCharacterSet___sharedCharacterSetWithName_(self, _cmd, csname)
{
    var cs = _builtInCharacterSets[csname];
    if (!cs)
    {
        var i = 0,
            ranges = objj_msgSend(CPArray, "array"),
            rangeArray = eval(csname);
        for (; i < rangeArray.length; i+= 2)
        {
            var loc = rangeArray[i],
                length = rangeArray[i + 1],
                range = CPMakeRange(loc,length);
            objj_msgSend(ranges, "addObject:", range);
        }
        cs = objj_msgSend(objj_msgSend(_CPRangeCharacterSet, "alloc"), "initWithRanges:", ranges);
        _builtInCharacterSets[csname] = cs;
    }
    return cs;
}
,["id","id"])]);
}
var CPCharacterSetInvertedKey = "CPCharacterSetInvertedKey";
{
var the_class = objj_getClass("CPCharacterSet")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPCharacterSet\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPCharacterSet__initWithCoder_(self, _cmd, aCoder)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPCharacterSet").super_class }, "init"))
    {
        self._inverted = objj_msgSend(aCoder, "decodeBoolForKey:", CPCharacterSetInvertedKey);
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPCharacterSet__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeBool:forKey:", self._inverted, CPCharacterSetInvertedKey);
}
,["void","CPCoder"])]);
}
{var the_class = objj_allocateClassPair(CPCharacterSet, "_CPRangeCharacterSet"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_ranges")]);






objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithRange:"), function $_CPRangeCharacterSet__initWithRange_(self, _cmd, r)
{
    return objj_msgSend(self, "initWithRanges:", objj_msgSend(CPArray, "arrayWithObject:", r));
}
,["id","CPRange"]), new objj_method(sel_getUid("initWithRanges:"), function $_CPRangeCharacterSet__initWithRanges_(self, _cmd, ranges)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPRangeCharacterSet").super_class }, "init");
    if (self)
    {
        self._ranges = ranges;
    }
    return self;
}
,["id","CPArray"]), new objj_method(sel_getUid("copy"), function $_CPRangeCharacterSet__copy(self, _cmd)
{
    var set = objj_msgSend(objj_msgSend(_CPRangeCharacterSet, "alloc"), "initWithRanges:", self._ranges);
    objj_msgSend(set, "_setInverted:", self._inverted);
    return set;
}
,["id"]), new objj_method(sel_getUid("invertedSet"), function $_CPRangeCharacterSet__invertedSet(self, _cmd)
{
    var set = objj_msgSend(objj_msgSend(_CPRangeCharacterSet, "alloc"), "initWithRanges:", self._ranges);
    objj_msgSend(set, "invert");
    return set;
}
,["id"]), new objj_method(sel_getUid("characterIsMember:"), function $_CPRangeCharacterSet__characterIsMember_(self, _cmd, aCharacter)
{
    var c = aCharacter.charCodeAt(0),
        enu = objj_msgSend(self._ranges, "objectEnumerator"),
        range;
    while ((range = objj_msgSend(enu, "nextObject")) !== nil)
    {
        if (CPLocationInRange(c, range))
            return !self._inverted;
    }
    return self._inverted;
}
,["BOOL","CPString"]), new objj_method(sel_getUid("hasMemberInPlane:"), function $_CPRangeCharacterSet__hasMemberInPlane_(self, _cmd, plane)
{
    if (plane !== 0)
        return NO;
    var enu = objj_msgSend(self._ranges, "objectEnumerator"),
        range;
    while ((range = objj_msgSend(enu, "nextObject")) !== nil)
    {
        if (!CPEmptyRange(range))
            return YES;
    }
    return NO;
}
,["BOOL","int"]), new objj_method(sel_getUid("addCharactersInRange:"), function $_CPRangeCharacterSet__addCharactersInRange_(self, _cmd, aRange)
{
    objj_msgSend(self._ranges, "addObject:", aRange);
}
,["void","CPRange"]), new objj_method(sel_getUid("addCharactersInString:"), function $_CPRangeCharacterSet__addCharactersInString_(self, _cmd, aString)
{
    var i = 0;
    for (; i < aString.length; i++)
    {
        var code = aString.charCodeAt(i),
            range = CPMakeRange(code,1);
        objj_msgSend(self._ranges, "addObject:", range);
    }
}
,["void","CPString"])]);
}
{var the_class = objj_allocateClassPair(CPCharacterSet, "_CPStringContentCharacterSet"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_string")]);








objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithString:"), function $_CPStringContentCharacterSet__initWithString_(self, _cmd, s)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPStringContentCharacterSet").super_class }, "init");
    if (self)
    {
        self._string = s;
    }
    return self;
}
,["id","CPString"]), new objj_method(sel_getUid("copy"), function $_CPStringContentCharacterSet__copy(self, _cmd)
{
    var set = objj_msgSend(objj_msgSend(_CPStringContentCharacterSet, "alloc"), "initWithString:", self._string);
    objj_msgSend(set, "_setInverted:", self._inverted);
    return set;
}
,["id"]), new objj_method(sel_getUid("invertedSet"), function $_CPStringContentCharacterSet__invertedSet(self, _cmd)
{
    var set = objj_msgSend(objj_msgSend(_CPStringContentCharacterSet, "alloc"), "initWithString:", self._string);
    objj_msgSend(set, "invert");
    return set;
}
,["id"]), new objj_method(sel_getUid("characterIsMember:"), function $_CPStringContentCharacterSet__characterIsMember_(self, _cmd, c)
{
    return (self._string.indexOf(c.charAt(0)) !== -1) === !self._inverted;
}
,["BOOL","CPString"]), new objj_method(sel_getUid("description"), function $_CPStringContentCharacterSet__description(self, _cmd)
{
    return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPStringContentCharacterSet").super_class }, "description") + " { string = '" + self._string + "'}";
}
,["CPString"]), new objj_method(sel_getUid("hasMemberInPlane:"), function $_CPStringContentCharacterSet__hasMemberInPlane_(self, _cmd, plane)
{
    return self._string.length && plane === 0;
}
,["BOOL","int"]), new objj_method(sel_getUid("addCharactersInRange:"), function $_CPStringContentCharacterSet__addCharactersInRange_(self, _cmd, aRange)
{
    var i = aRange.location,
        count = aRange.location + aRange.length;
    for (; i < count; i++)
    {
        var s = String.fromCharCode(i);
        if (!objj_msgSend(self, "characterIsMember:", s))
            self._string = objj_msgSend(self._string, "stringByAppendingString:", s);
    }
}
,["void","CPRange"]), new objj_method(sel_getUid("addCharactersInString:"), function $_CPStringContentCharacterSet__addCharactersInString_(self, _cmd, aString)
{
    var i = 0;
    for (; i < aString.length; i++)
    {
        var s = aString.charAt(i);
        if (!objj_msgSend(self, "characterIsMember:", s))
            self._string = objj_msgSend(self._string, "stringByAppendingString:", s);
    }
}
,["void","CPString"]), new objj_method(sel_getUid("isEqual:"), function $_CPStringContentCharacterSet__isEqual_(self, _cmd, aCharacterSet)
{
    if (self === aCharacterSet)
        return YES;
    if (!aCharacterSet || !objj_msgSend(aCharacterSet, "isKindOfClass:", objj_msgSend(self, "class")))
        return NO;
    return objj_msgSend(self, "_isEqualToStringContentCharacterSet:", aCharacterSet);
}
,["BOOL","CPCharacterSet"]), new objj_method(sel_getUid("_isEqualToStringContentCharacterSet:"), function $_CPStringContentCharacterSet___isEqualToStringContentCharacterSet_(self, _cmd, aCharacterSet)
{
    if (!aCharacterSet)
        return NO;
    return self._string === aCharacterSet._string && self._inverted === aCharacterSet._inverted;
}
,["BOOL","_CPStringContentCharacterSet"])]);
}
var _CPStringContentCharacterSetStringKey = "_CPStringContentCharacterSetStringKey";
{
var the_class = objj_getClass("_CPStringContentCharacterSet")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"_CPStringContentCharacterSet\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $_CPStringContentCharacterSet__initWithCoder_(self, _cmd, aCoder)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPStringContentCharacterSet").super_class }, "initWithCoder:", aCoder))
    {
        self._string = objj_msgSend(aCoder, "decodeObjectForKey:", _CPStringContentCharacterSetStringKey)
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $_CPStringContentCharacterSet__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPStringContentCharacterSet").super_class }, "encodeWithCoder:", aCoder);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._string, _CPStringContentCharacterSetStringKey);
}
,["void","CPCoder"])]);
}
_CPCharacterSetTrimAtBeginning = 1 << 1;
_CPCharacterSetTrimAtEnd = 1 << 2;
{
var the_class = objj_getClass("CPString")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPString\"");
var meta_class = the_class.isa;

class_addMethods(the_class, [new objj_method(sel_getUid("componentsSeparatedByCharactersInSet:"), function $CPString__componentsSeparatedByCharactersInSet_(self, _cmd, separator)
{
    if (!separator)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "componentsSeparatedByCharactersInSet: the separator can't be 'nil'");
    var components = objj_msgSend(CPMutableArray, "array"),
        componentRange = CPMakeRange(0, 0),
        i = 0;
    for (; i < self.length; i++)
    {
        if (objj_msgSend(separator, "characterIsMember:", self.charAt(i)))
        {
            componentRange.length = i - componentRange.location;
            objj_msgSend(components, "addObject:", objj_msgSend(self, "substringWithRange:", componentRange));
            componentRange.location += componentRange.length + 1;
        }
    }
    componentRange.length = self.length - componentRange.location;
    objj_msgSend(components, "addObject:", objj_msgSend(self, "substringWithRange:", componentRange));
    return components;
}
,["CPArray","CPCharacterSet"]), new objj_method(sel_getUid("stringByTrimmingCharactersInSet:"), function $CPString__stringByTrimmingCharactersInSet_(self, _cmd, set)
{
    return objj_msgSend(self, "_stringByTrimmingCharactersInSet:options:", set, _CPCharacterSetTrimAtBeginning | _CPCharacterSetTrimAtEnd);
}
,["id","CPCharacterSet"]), new objj_method(sel_getUid("_stringByTrimmingCharactersInSet:options:"), function $CPString___stringByTrimmingCharactersInSet_options_(self, _cmd, set, options)
{
    var str = self;
    if (options & _CPCharacterSetTrimAtBeginning)
    {
        var cutEdgeBeginning = 0;
        while (cutEdgeBeginning < self.length && objj_msgSend(set, "characterIsMember:", self.charAt(cutEdgeBeginning)))
            cutEdgeBeginning++;
        str = str.substr(cutEdgeBeginning);
    }
    if (options & _CPCharacterSetTrimAtEnd)
    {
        var cutEdgeEnd = str.length;
        while (cutEdgeEnd > 0 && objj_msgSend(set, "characterIsMember:", self.charAt(cutEdgeEnd)))
            cutEdgeEnd--;
        str = str.substr(0, cutEdgeEnd + 1);
    }
    return str;
}
,["id","CPCharacterSet","int"])]);
}
alphanumericCharacterSet = [
48,10,
65,26,
97,26,
170,1,
178,2,
181,1,
185,2,
188,3,
192,23,
216,31,
248,458,
710,12,
736,5,
750,1,
768,112,
890,4,
902,1,
904,3,
908,1,
910,20,
931,44,
976,38,
1015,139,
1155,4,
1160,140,
1329,38,
1369,1,
1377,39,
1425,45,
1471,1,
1473,2,
1476,2,
1479,1,
1488,27,
1520,3,
1552,6,
1569,26,
1600,31,
1632,10,
1646,102,
1749,8,
1758,11,
1770,19,
1791,1,
1808,59,
1869,33,
1920,50,
1984,54,
2042,1,
2305,57,
2364,18,
2384,5,
2392,12,
2406,10,
2427,5,
2433,3,
2437,8,
2447,2,
2451,22,
2474,7,
2482,1,
2486,4,
2492,9,
2503,2,
2507,4,
2519,1,
2524,2,
2527,5,
2534,12,
2548,6,
2561,3,
2565,6,
2575,2,
2579,22,
2602,7,
2610,2,
2613,2,
2616,2,
2620,1,
2622,5,
2631,2,
2635,3,
2649,4,
2654,1,
2662,15,
2689,3,
2693,9,
2703,3,
2707,22,
2730,7,
2738,2,
2741,5,
2748,10,
2759,3,
2763,3,
2768,1,
2784,4,
2790,10,
2817,3,
2821,8,
2831,2,
2835,22,
2858,7,
2866,2,
2869,5,
2876,8,
2887,2,
2891,3,
2902,2,
2908,2,
2911,3,
2918,10,
2929,1,
2946,2,
2949,6,
2958,3,
2962,4,
2969,2,
2972,1,
2974,2,
2979,2,
2984,3,
2990,12,
3006,5,
3014,3,
3018,4,
3031,1,
3046,13,
3073,3,
3077,8,
3086,3,
3090,23,
3114,10,
3125,5,
3134,7,
3142,3,
3146,4,
3157,2,
3168,2,
3174,10,
3202,2,
3205,8,
3214,3,
3218,23,
3242,10,
3253,5,
3260,9,
3270,3,
3274,4,
3285,2,
3294,1,
3296,4,
3302,10,
3330,2,
3333,8,
3342,3,
3346,23,
3370,16,
3390,6,
3398,3,
3402,4,
3415,1,
3424,2,
3430,10,
3458,2,
3461,18,
3482,24,
3507,9,
3517,1,
3520,7,
3530,1,
3535,6,
3542,1,
3544,8,
3570,2,
3585,58,
3648,15,
3664,10,
3713,2,
3716,1,
3719,2,
3722,1,
3725,1,
3732,4,
3737,7,
3745,3,
3749,1,
3751,1,
3754,2,
3757,13,
3771,3,
3776,5,
3782,1,
3784,6,
3792,10,
3804,2,
3840,1,
3864,2,
3872,20,
3893,1,
3895,1,
3897,1,
3902,10,
3913,34,
3953,20,
3974,6,
3984,8,
3993,36,
4038,1,
4096,34,
4131,5,
4137,2,
4140,7,
4150,4,
4160,10,
4176,10,
4256,38,
4304,43,
4348,1,
4352,90,
4447,68,
4520,82,
4608,73,
4682,4,
4688,7,
4696,1,
4698,4,
4704,41,
4746,4,
4752,33,
4786,4,
4792,7,
4800,1,
4802,4,
4808,15,
4824,57,
4882,4,
4888,67,
4959,1,
4969,20,
4992,16,
5024,85,
5121,620,
5743,8,
5761,26,
5792,75,
5870,3,
5888,13,
5902,7,
5920,21,
5952,20,
5984,13,
5998,3,
6002,2,
6016,52,
6070,30,
6103,1,
6108,2,
6112,10,
6128,10,
6155,3,
6160,10,
6176,88,
6272,42,
6400,29,
6432,12,
6448,12,
6470,40,
6512,5,
6528,42,
6576,26,
6608,10,
6656,28,
6912,76,
6992,10,
7019,9,
7424,203,
7678,158,
7840,90,
7936,22,
7960,6,
7968,38,
8008,6,
8016,8,
8025,1,
8027,1,
8029,1,
8031,31,
8064,53,
8118,7,
8126,1,
8130,3,
8134,7,
8144,4,
8150,6,
8160,13,
8178,3,
8182,7,
8304,2,
8308,6,
8319,11,
8336,5,
8400,32,
8450,1,
8455,1,
8458,10,
8469,1,
8473,5,
8484,1,
8486,1,
8488,1,
8490,4,
8495,11,
8508,4,
8517,5,
8526,1,
8531,50,
9312,60,
9450,22,
10102,30,
11264,47,
11312,47,
11360,13,
11380,4,
11392,101,
11517,1,
11520,38,
11568,54,
11631,1,
11648,23,
11680,7,
11688,7,
11696,7,
11704,7,
11712,7,
11720,7,
11728,7,
11736,7,
12293,3,
12321,15,
12337,5,
12344,5,
12353,86,
12441,2,
12445,3,
12449,90,
12540,4,
12549,40,
12593,94,
12690,4,
12704,24,
12784,16,
12832,10,
12881,15,
12928,10,
12977,15,
13312,6582,
19968,20924,
40960,1165,
42775,4,
43008,40,
43072,52,
44032,11172,
63744,302,
64048,59,
64112,106,
64256,7,
64275,5,
64285,12,
64298,13,
64312,5,
64318,1,
64320,2,
64323,2,
64326,108,
64467,363,
64848,64,
64914,54,
65008,12,
65024,16,
65056,4,
65136,5,
65142,135,
65296,10,
65313,26,
65345,26,
65382,89,
65474,6,
65482,6,
65490,6
];
controlCharacterSet = [
0,32,
127,33,
173,1,
1536,4,
1757,1,
1807,1,
6068,2,
8203,5,
8234,5,
8288,4,
8298,6,
65279,1
];
decimalDigitCharacterSet = [
48,10,
1632,10,
1776,10,
1984,10,
2406,10,
2534,10,
2662,10,
2790,10,
2918,10,
3046,10,
3174,10,
3302,10,
3430,10,
3664,10,
3792,10,
3872,10,
4160,10,
6112,10,
6160,10,
6470,10,
6608,10,
6992,10
];
decomposableCharacterSet = [
192,6,
199,9,
209,6,
217,5,
224,6,
231,9,
241,6,
249,5,
255,17,
274,20,
296,9,
308,4,
313,6,
323,6,
332,6,
340,18,
360,23,
416,2,
431,2,
461,16,
478,6,
486,11,
500,2,
504,36,
542,2,
550,14,
832,2,
835,2,
884,1,
894,1,
901,6,
908,1,
910,3,
938,7,
970,5,
979,2,
1024,2,
1027,1,
1031,1,
1036,3,
1049,1,
1081,1,
1104,2,
1107,1,
1111,1,
1116,3,
1142,2,
1217,2,
1232,4,
1238,2,
1242,6,
1250,6,
1258,12,
1272,2,
1570,5,
1728,1,
1730,1,
1747,1,
2345,1,
2353,1,
2356,1,
2392,8,
2507,2,
2524,2,
2527,1,
2611,1,
2614,1,
2649,3,
2654,1,
2888,1,
2891,2,
2908,2,
2964,1,
3018,3,
3144,1,
3264,1,
3271,2,
3274,2,
3402,3,
3546,1,
3548,3,
3907,1,
3917,1,
3922,1,
3927,1,
3932,1,
3945,1,
3955,1,
3957,2,
3960,1,
3969,1,
3987,1,
3997,1,
4002,1,
4007,1,
4012,1,
4025,1,
4134,1,
6918,1,
6920,1,
6922,1,
6924,1,
6926,1,
6930,1,
6971,1,
6973,1,
6976,2,
6979,1,
7680,154,
7835,1,
7840,90,
7936,22,
7960,6,
7968,38,
8008,6,
8016,8,
8025,1,
8027,1,
8029,1,
8031,31,
8064,53,
8118,7,
8126,1,
8129,4,
8134,14,
8150,6,
8157,19,
8178,3,
8182,8,
8192,2,
8486,1,
8490,2,
8602,2,
8622,1,
8653,3,
8708,1,
8713,1,
8716,1,
8740,1,
8742,1,
8769,1,
8772,1,
8775,1,
8777,1,
8800,1,
8802,1,
8813,5,
8820,2,
8824,2,
8832,2,
8836,2,
8840,2,
8876,4,
8928,4,
8938,4,
9001,2,
10972,1,
12364,1,
12366,1,
12368,1,
12370,1,
12372,1,
12374,1,
12376,1,
12378,1,
12380,1,
12382,1,
12384,1,
12386,1,
12389,1,
12391,1,
12393,1,
12400,2,
12403,2,
12406,2,
12409,2,
12412,2,
12436,1,
12446,1,
12460,1,
12462,1,
12464,1,
12466,1,
12468,1,
12470,1,
12472,1,
12474,1,
12476,1,
12478,1,
12480,1,
12482,1,
12485,1,
12487,1,
12489,1,
12496,2,
12499,2,
12502,2,
12505,2,
12508,2,
12532,1,
12535,4,
12542,1,
44032,11172,
63744,270,
64016,1,
64018,1,
64021,10,
64032,1,
64034,1,
64037,2,
64042,4,
64048,59,
64112,106,
64285,1,
64287,1,
64298,13,
64312,5,
64318,1,
64320,2,
64323,2
];
illegalCharacterSet = [
880,4,
886,4,
895,5,
907,1,
909,1,
930,1,
975,1,
1159,1,
1300,29,
1367,2,
1376,1,
1416,1,
1419,6,
1480,8,
1515,5,
1525,11,
1540,7,
1558,5,
1564,2,
1568,1,
1595,5,
1631,1,
1806,1,
1867,2,
1902,18,
1970,14,
2043,262,
2362,2,
2382,2,
2389,3,
2417,10,
2432,1,
2436,1,
2445,2,
2449,2,
2473,1,
2481,1,
2483,3,
2490,2,
2501,2,
2505,2,
2511,8,
2520,4,
2526,1,
2532,2,
2555,6,
2564,1,
2571,4,
2577,2,
2601,1,
2609,1,
2612,1,
2615,1,
2618,2,
2621,1,
2627,4,
2633,2,
2638,11,
2653,1,
2655,7,
2677,12,
2692,1,
2702,1,
2706,1,
2729,1,
2737,1,
2740,1,
2746,2,
2758,1,
2762,1,
2766,2,
2769,15,
2788,2,
2800,1,
2802,15,
2820,1,
2829,2,
2833,2,
2857,1,
2865,1,
2868,1,
2874,2,
2884,3,
2889,2,
2894,8,
2904,4,
2910,1,
2914,4,
2930,16,
2948,1,
2955,3,
2961,1,
2966,3,
2971,1,
2973,1,
2976,3,
2981,3,
2987,3,
3002,4,
3011,3,
3017,1,
3022,9,
3032,14,
3067,6,
3076,1,
3085,1,
3089,1,
3113,1,
3124,1,
3130,4,
3141,1,
3145,1,
3150,7,
3159,9,
3170,4,
3184,18,
3204,1,
3213,1,
3217,1,
3241,1,
3252,1,
3258,2,
3269,1,
3273,1,
3278,7,
3287,7,
3295,1,
3300,2,
3312,1,
3315,15,
3332,1,
3341,1,
3345,1,
3369,1,
3386,4,
3396,2,
3401,1,
3406,9,
3416,8,
3426,4,
3440,18,
3460,1,
3479,3,
3506,1,
3516,1,
3518,2,
3527,3,
3531,4,
3541,1,
3543,1,
3552,18,
3573,12,
3643,4,
3676,37,
3715,1,
3717,2,
3721,1,
3723,2,
3726,6,
3736,1,
3744,1,
3748,1,
3750,1,
3752,2,
3756,1,
3770,1,
3774,2,
3781,1,
3783,1,
3790,2,
3802,2,
3806,34,
3912,1,
3947,6,
3980,4,
3992,1,
4029,1,
4045,2,
4050,46,
4130,1,
4136,1,
4139,1,
4147,3,
4154,6,
4186,70,
4294,10,
4349,3,
4442,5,
4515,5,
4602,6,
4681,1,
4686,2,
4695,1,
4697,1,
4702,2,
4745,1,
4750,2,
4785,1,
4790,2,
4799,1,
4801,1,
4806,2,
4823,1,
4881,1,
4886,2,
4955,4,
4989,3,
5018,6,
5109,12,
5751,9,
5789,3,
5873,15,
5901,1,
5909,11,
5943,9,
5972,12,
5997,1,
6001,1,
6004,12,
6110,2,
6122,6,
6138,6,
6159,1,
6170,6,
6264,8,
6314,86,
6429,3,
6444,4,
6460,4,
6465,3,
6510,2,
6517,11,
6570,6,
6602,6,
6618,4,
6684,2,
6688,224,
6988,4,
7037,387,
7627,51,
7836,4,
7930,6,
7958,2,
7966,2,
8006,2,
8014,2,
8024,1,
8026,1,
8028,1,
8030,1,
8062,2,
8117,1,
8133,1,
8148,2,
8156,1,
8176,2,
8181,1,
8191,1,
8292,6,
8306,2,
8335,1,
8341,11,
8374,26,
8432,16,
8527,4,
8581,11,
9192,24,
9255,25,
9291,21,
9885,3,
9907,78,
9989,1,
9994,2,
10024,1,
10060,1,
10062,1,
10067,3,
10071,1,
10079,2,
10133,3,
10160,1,
10175,1,
10187,5,
10220,4,
11035,5,
11044,220,
11311,1,
11359,1,
11373,7,
11384,8,
11499,14,
11558,10,
11622,9,
11632,16,
11671,9,
11687,1,
11695,1,
11703,1,
11711,1,
11719,1,
11727,1,
11735,1,
11743,33,
11800,4,
11806,98,
11930,1,
12020,12,
12246,26,
12284,4,
12352,1,
12439,2,
12544,5,
12589,4,
12687,1,
12728,8,
12752,32,
12831,1,
12868,12,
13055,1,
19894,10,
40892,68,
42125,3,
42183,569,
42779,5,
42786,222,
43052,20,
43128,904,
55204,92,
64046,2,
64107,5,
64218,38,
64263,12,
64280,5,
64311,1,
64317,1,
64319,1,
64322,1,
64325,1,
64434,33,
64832,16,
64912,2,
64968,40,
65022,2,
65050,6,
65060,12,
65107,1,
65127,1,
65132,4,
65141,1,
65277,2,
65280,1,
65471,3,
65480,2,
65488,2,
65496,2,
65501,3,
65511,1,
65519,10
];
letterCharacterSet = [
65,26,
97,26,
170,1,
181,1,
186,1,
192,23,
216,31,
248,458,
710,12,
736,5,
750,1,
768,112,
890,4,
902,1,
904,3,
908,1,
910,20,
931,44,
976,38,
1015,139,
1155,4,
1160,140,
1329,38,
1369,1,
1377,39,
1425,45,
1471,1,
1473,2,
1476,2,
1479,1,
1488,27,
1520,3,
1552,6,
1569,26,
1600,31,
1646,102,
1749,8,
1758,11,
1770,6,
1786,3,
1791,1,
1808,59,
1869,33,
1920,50,
1994,44,
2042,1,
2305,57,
2364,18,
2384,5,
2392,12,
2427,5,
2433,3,
2437,8,
2447,2,
2451,22,
2474,7,
2482,1,
2486,4,
2492,9,
2503,2,
2507,4,
2519,1,
2524,2,
2527,5,
2544,2,
2561,3,
2565,6,
2575,2,
2579,22,
2602,7,
2610,2,
2613,2,
2616,2,
2620,1,
2622,5,
2631,2,
2635,3,
2649,4,
2654,1,
2672,5,
2689,3,
2693,9,
2703,3,
2707,22,
2730,7,
2738,2,
2741,5,
2748,10,
2759,3,
2763,3,
2768,1,
2784,4,
2817,3,
2821,8,
2831,2,
2835,22,
2858,7,
2866,2,
2869,5,
2876,8,
2887,2,
2891,3,
2902,2,
2908,2,
2911,3,
2929,1,
2946,2,
2949,6,
2958,3,
2962,4,
2969,2,
2972,1,
2974,2,
2979,2,
2984,3,
2990,12,
3006,5,
3014,3,
3018,4,
3031,1,
3073,3,
3077,8,
3086,3,
3090,23,
3114,10,
3125,5,
3134,7,
3142,3,
3146,4,
3157,2,
3168,2,
3202,2,
3205,8,
3214,3,
3218,23,
3242,10,
3253,5,
3260,9,
3270,3,
3274,4,
3285,2,
3294,1,
3296,4,
3330,2,
3333,8,
3342,3,
3346,23,
3370,16,
3390,6,
3398,3,
3402,4,
3415,1,
3424,2,
3458,2,
3461,18,
3482,24,
3507,9,
3517,1,
3520,7,
3530,1,
3535,6,
3542,1,
3544,8,
3570,2,
3585,58,
3648,15,
3713,2,
3716,1,
3719,2,
3722,1,
3725,1,
3732,4,
3737,7,
3745,3,
3749,1,
3751,1,
3754,2,
3757,13,
3771,3,
3776,5,
3782,1,
3784,6,
3804,2,
3840,1,
3864,2,
3893,1,
3895,1,
3897,1,
3902,10,
3913,34,
3953,20,
3974,6,
3984,8,
3993,36,
4038,1,
4096,34,
4131,5,
4137,2,
4140,7,
4150,4,
4176,10,
4256,38,
4304,43,
4348,1,
4352,90,
4447,68,
4520,82,
4608,73,
4682,4,
4688,7,
4696,1,
4698,4,
4704,41,
4746,4,
4752,33,
4786,4,
4792,7,
4800,1,
4802,4,
4808,15,
4824,57,
4882,4,
4888,67,
4959,1,
4992,16,
5024,85,
5121,620,
5743,8,
5761,26,
5792,75,
5888,13,
5902,7,
5920,21,
5952,20,
5984,13,
5998,3,
6002,2,
6016,52,
6070,30,
6103,1,
6108,2,
6155,3,
6176,88,
6272,42,
6400,29,
6432,12,
6448,12,
6480,30,
6512,5,
6528,42,
6576,26,
6656,28,
6912,76,
7019,9,
7424,203,
7678,158,
7840,90,
7936,22,
7960,6,
7968,38,
8008,6,
8016,8,
8025,1,
8027,1,
8029,1,
8031,31,
8064,53,
8118,7,
8126,1,
8130,3,
8134,7,
8144,4,
8150,6,
8160,13,
8178,3,
8182,7,
8305,1,
8319,1,
8336,5,
8400,32,
8450,1,
8455,1,
8458,10,
8469,1,
8473,5,
8484,1,
8486,1,
8488,1,
8490,4,
8495,11,
8508,4,
8517,5,
8526,1,
8579,2,
11264,47,
11312,47,
11360,13,
11380,4,
11392,101,
11520,38,
11568,54,
11631,1,
11648,23,
11680,7,
11688,7,
11696,7,
11704,7,
11712,7,
11720,7,
11728,7,
11736,7,
12293,2,
12330,6,
12337,5,
12347,2,
12353,86,
12441,2,
12445,3,
12449,90,
12540,4,
12549,40,
12593,94,
12704,24,
12784,16,
13312,6582,
19968,20924,
40960,1165,
42775,4,
43008,40,
43072,52,
44032,11172,
63744,302,
64048,59,
64112,106,
64256,7,
64275,5,
64285,12,
64298,13,
64312,5,
64318,1,
64320,2,
64323,2,
64326,108,
64467,363,
64848,64,
64914,54,
65008,12,
65024,16,
65056,4,
65136,5,
65142,135,
65313,26,
65345,26,
65382,89,
65474,6,
65482,6,
65490,6
];
lowercaseLetterCharacterSet = [
97,26,
170,1,
181,1,
186,1,
223,24,
248,8,
257,1,
259,1,
261,1,
263,1,
265,1,
267,1,
269,1,
271,1,
273,1,
275,1,
277,1,
279,1,
281,1,
283,1,
285,1,
287,1,
289,1,
291,1,
293,1,
295,1,
297,1,
299,1,
301,1,
303,1,
305,1,
307,1,
309,1,
311,2,
314,1,
316,1,
318,1,
320,1,
322,1,
324,1,
326,1,
328,2,
331,1,
333,1,
335,1,
337,1,
339,1,
341,1,
343,1,
345,1,
347,1,
349,1,
351,1,
353,1,
355,1,
357,1,
359,1,
361,1,
363,1,
365,1,
367,1,
369,1,
371,1,
373,1,
375,1,
378,1,
380,1,
382,3,
387,1,
389,1,
392,1,
396,2,
402,1,
405,1,
409,3,
414,1,
417,1,
419,1,
421,1,
424,1,
426,2,
429,1,
432,1,
436,1,
438,1,
441,2,
445,3,
454,1,
457,1,
460,1,
462,1,
464,1,
466,1,
468,1,
470,1,
472,1,
474,1,
476,2,
479,1,
481,1,
483,1,
485,1,
487,1,
489,1,
491,1,
493,1,
495,2,
499,1,
501,1,
505,1,
507,1,
509,1,
511,1,
513,1,
515,1,
517,1,
519,1,
521,1,
523,1,
525,1,
527,1,
529,1,
531,1,
533,1,
535,1,
537,1,
539,1,
541,1,
543,1,
545,1,
547,1,
549,1,
551,1,
553,1,
555,1,
557,1,
559,1,
561,1,
563,7,
572,1,
575,2,
578,1,
583,1,
585,1,
587,1,
589,1,
591,69,
661,27,
891,3,
912,1,
940,35,
976,2,
981,3,
985,1,
987,1,
989,1,
991,1,
993,1,
995,1,
997,1,
999,1,
1001,1,
1003,1,
1005,1,
1007,5,
1013,1,
1016,1,
1019,2,
1072,48,
1121,1,
1123,1,
1125,1,
1127,1,
1129,1,
1131,1,
1133,1,
1135,1,
1137,1,
1139,1,
1141,1,
1143,1,
1145,1,
1147,1,
1149,1,
1151,1,
1153,1,
1163,1,
1165,1,
1167,1,
1169,1,
1171,1,
1173,1,
1175,1,
1177,1,
1179,1,
1181,1,
1183,1,
1185,1,
1187,1,
1189,1,
1191,1,
1193,1,
1195,1,
1197,1,
1199,1,
1201,1,
1203,1,
1205,1,
1207,1,
1209,1,
1211,1,
1213,1,
1215,1,
1218,1,
1220,1,
1222,1,
1224,1,
1226,1,
1228,1,
1230,2,
1233,1,
1235,1,
1237,1,
1239,1,
1241,1,
1243,1,
1245,1,
1247,1,
1249,1,
1251,1,
1253,1,
1255,1,
1257,1,
1259,1,
1261,1,
1263,1,
1265,1,
1267,1,
1269,1,
1271,1,
1273,1,
1275,1,
1277,1,
1279,1,
1281,1,
1283,1,
1285,1,
1287,1,
1289,1,
1291,1,
1293,1,
1295,1,
1297,1,
1299,1,
1377,39,
7424,44,
7522,22,
7545,34,
7681,1,
7683,1,
7685,1,
7687,1,
7689,1,
7691,1,
7693,1,
7695,1,
7697,1,
7699,1,
7701,1,
7703,1,
7705,1,
7707,1,
7709,1,
7711,1,
7713,1,
7715,1,
7717,1,
7719,1,
7721,1,
7723,1,
7725,1,
7727,1,
7729,1,
7731,1,
7733,1,
7735,1,
7737,1,
7739,1,
7741,1,
7743,1,
7745,1,
7747,1,
7749,1,
7751,1,
7753,1,
7755,1,
7757,1,
7759,1,
7761,1,
7763,1,
7765,1,
7767,1,
7769,1,
7771,1,
7773,1,
7775,1,
7777,1,
7779,1,
7781,1,
7783,1,
7785,1,
7787,1,
7789,1,
7791,1,
7793,1,
7795,1,
7797,1,
7799,1,
7801,1,
7803,1,
7805,1,
7807,1,
7809,1,
7811,1,
7813,1,
7815,1,
7817,1,
7819,1,
7821,1,
7823,1,
7825,1,
7827,1,
7829,7,
7841,1,
7843,1,
7845,1,
7847,1,
7849,1,
7851,1,
7853,1,
7855,1,
7857,1,
7859,1,
7861,1,
7863,1,
7865,1,
7867,1,
7869,1,
7871,1,
7873,1,
7875,1,
7877,1,
7879,1,
7881,1,
7883,1,
7885,1,
7887,1,
7889,1,
7891,1,
7893,1,
7895,1,
7897,1,
7899,1,
7901,1,
7903,1,
7905,1,
7907,1,
7909,1,
7911,1,
7913,1,
7915,1,
7917,1,
7919,1,
7921,1,
7923,1,
7925,1,
7927,1,
7929,1,
7936,8,
7952,6,
7968,8,
7984,8,
8000,6,
8016,8,
8032,8,
8048,14,
8064,8,
8080,8,
8096,8,
8112,5,
8118,2,
8126,1,
8130,3,
8134,2,
8144,4,
8150,2,
8160,8,
8178,3,
8182,2,
8305,1,
8319,1,
8458,1,
8462,2,
8467,1,
8495,1,
8500,1,
8505,1,
8508,2,
8518,4,
8526,1,
8580,1,
11312,47,
11361,1,
11365,2,
11368,1,
11370,1,
11372,1,
11380,1,
11382,2,
11393,1,
11395,1,
11397,1,
11399,1,
11401,1,
11403,1,
11405,1,
11407,1,
11409,1,
11411,1,
11413,1,
11415,1,
11417,1,
11419,1,
11421,1,
11423,1,
11425,1,
11427,1,
11429,1,
11431,1,
11433,1,
11435,1,
11437,1,
11439,1,
11441,1,
11443,1,
11445,1,
11447,1,
11449,1,
11451,1,
11453,1,
11455,1,
11457,1,
11459,1,
11461,1,
11463,1,
11465,1,
11467,1,
11469,1,
11471,1,
11473,1,
11475,1,
11477,1,
11479,1,
11481,1,
11483,1,
11485,1,
11487,1,
11489,1,
11491,2,
11520,38,
64256,7,
64275,5
];
nonBaseCharacterSet = [
768,112,
1155,4,
1160,2,
1425,45,
1471,1,
1473,2,
1476,2,
1479,1,
1552,6,
1611,20,
1648,1,
1750,7,
1758,7,
1767,2,
1770,4,
1809,1,
1840,27,
1958,11,
2027,9,
2305,3,
2364,1,
2366,16,
2385,4,
2402,2,
2433,3,
2492,1,
2494,7,
2503,2,
2507,3,
2519,1,
2530,2,
2561,3,
2620,1,
2622,5,
2631,2,
2635,3,
2672,2,
2689,3,
2748,1,
2750,8,
2759,3,
2763,3,
2786,2,
2817,3,
2876,1,
2878,6,
2887,2,
2891,3,
2902,2,
2946,1,
3006,5,
3014,3,
3018,4,
3031,1,
3073,3,
3134,7,
3142,3,
3146,4,
3157,2,
3202,2,
3260,1,
3262,7,
3270,3,
3274,4,
3285,2,
3298,2,
3330,2,
3390,6,
3398,3,
3402,4,
3415,1,
3458,2,
3530,1,
3535,6,
3542,1,
3544,8,
3570,2,
3633,1,
3636,7,
3655,8,
3761,1,
3764,6,
3771,2,
3784,6,
3864,2,
3893,1,
3895,1,
3897,1,
3902,2,
3953,20,
3974,2,
3984,8,
3993,36,
4038,1,
4140,7,
4150,4,
4182,4,
4959,1,
5906,3,
5938,3,
5970,2,
6002,2,
6070,30,
6109,1,
6155,3,
6313,1,
6432,12,
6448,12,
6576,17,
6600,2,
6679,5,
6912,5,
6964,17,
7019,9,
7616,11,
7678,2,
8400,32,
12330,6,
12441,2,
43010,1,
43014,1,
43019,1,
43043,5,
64286,1,
65024,16
];
punctuationCharacterSet = [
33,3,
37,6,
44,4,
58,2,
63,2,
91,3,
95,1,
123,1,
125,1,
161,1,
171,1,
183,1,
187,1,
191,1,
894,1,
903,1,
1370,6,
1417,2,
1470,1,
1472,1,
1475,1,
1478,1,
1523,2,
1548,2,
1563,1,
1566,2,
1642,4,
1748,1,
1792,14,
2039,3,
2404,2,
2416,1,
3572,1,
3663,1,
3674,2,
3844,15,
3898,4,
3973,1,
4048,2,
4170,6,
4347,1,
4961,8,
5741,2,
5787,2,
5867,3,
5941,2,
6100,3,
6104,3,
6144,11,
6468,2,
6622,2,
6686,2,
7002,7,
8208,24,
8240,20,
8261,13,
8275,12,
8317,2,
8333,2,
9001,2,
10088,14,
10181,2,
10214,6,
10627,22,
10712,4,
10748,2,
11513,4,
11518,2,
11776,24,
11804,2,
12289,3,
12296,10,
12308,12,
12336,1,
12349,1,
12448,1,
12539,1,
43124,4,
64830,2,
65040,10,
65072,35,
65108,14,
65123,1,
65128,1,
65130,2,
65281,3,
65285,6,
65292,4,
65306,2,
65311,2,
65339,3,
65343,1,
65371,1,
65373,1
];
uppercaseLetterCharacterSet = [
65,26,
192,23,
216,7,
256,1,
258,1,
260,1,
262,1,
264,1,
266,1,
268,1,
270,1,
272,1,
274,1,
276,1,
278,1,
280,1,
282,1,
284,1,
286,1,
288,1,
290,1,
292,1,
294,1,
296,1,
298,1,
300,1,
302,1,
304,1,
306,1,
308,1,
310,1,
313,1,
315,1,
317,1,
319,1,
321,1,
323,1,
325,1,
327,1,
330,1,
332,1,
334,1,
336,1,
338,1,
340,1,
342,1,
344,1,
346,1,
348,1,
350,1,
352,1,
354,1,
356,1,
358,1,
360,1,
362,1,
364,1,
366,1,
368,1,
370,1,
372,1,
374,1,
376,2,
379,1,
381,1,
385,2,
388,1,
390,2,
393,3,
398,4,
403,2,
406,3,
412,2,
415,2,
418,1,
420,1,
422,2,
425,1,
428,1,
430,2,
433,3,
437,1,
439,2,
444,1,
452,2,
455,2,
458,2,
461,1,
463,1,
465,1,
467,1,
469,1,
471,1,
473,1,
475,1,
478,1,
480,1,
482,1,
484,1,
486,1,
488,1,
490,1,
492,1,
494,1,
497,2,
500,1,
502,3,
506,1,
508,1,
510,1,
512,1,
514,1,
516,1,
518,1,
520,1,
522,1,
524,1,
526,1,
528,1,
530,1,
532,1,
534,1,
536,1,
538,1,
540,1,
542,1,
544,1,
546,1,
548,1,
550,1,
552,1,
554,1,
556,1,
558,1,
560,1,
562,1,
570,2,
573,2,
577,1,
579,4,
584,1,
586,1,
588,1,
590,1,
902,1,
904,3,
908,1,
910,2,
913,17,
931,9,
978,3,
984,1,
986,1,
988,1,
990,1,
992,1,
994,1,
996,1,
998,1,
1000,1,
1002,1,
1004,1,
1006,1,
1012,1,
1015,1,
1017,2,
1021,51,
1120,1,
1122,1,
1124,1,
1126,1,
1128,1,
1130,1,
1132,1,
1134,1,
1136,1,
1138,1,
1140,1,
1142,1,
1144,1,
1146,1,
1148,1,
1150,1,
1152,1,
1162,1,
1164,1,
1166,1,
1168,1,
1170,1,
1172,1,
1174,1,
1176,1,
1178,1,
1180,1,
1182,1,
1184,1,
1186,1,
1188,1,
1190,1,
1192,1,
1194,1,
1196,1,
1198,1,
1200,1,
1202,1,
1204,1,
1206,1,
1208,1,
1210,1,
1212,1,
1214,1,
1216,2,
1219,1,
1221,1,
1223,1,
1225,1,
1227,1,
1229,1,
1232,1,
1234,1,
1236,1,
1238,1,
1240,1,
1242,1,
1244,1,
1246,1,
1248,1,
1250,1,
1252,1,
1254,1,
1256,1,
1258,1,
1260,1,
1262,1,
1264,1,
1266,1,
1268,1,
1270,1,
1272,1,
1274,1,
1276,1,
1278,1,
1280,1,
1282,1,
1284,1,
1286,1,
1288,1,
1290,1,
1292,1,
1294,1,
1296,1,
1298,1,
1329,38,
4256,38,
7680,1,
7682,1,
7684,1,
7686,1,
7688,1,
7690,1,
7692,1,
7694,1,
7696,1,
7698,1,
7700,1,
7702,1,
7704,1,
7706,1,
7708,1,
7710,1,
7712,1,
7714,1,
7716,1,
7718,1,
7720,1,
7722,1,
7724,1,
7726,1,
7728,1,
7730,1,
7732,1,
7734,1,
7736,1,
7738,1,
7740,1,
7742,1,
7744,1,
7746,1,
7748,1,
7750,1,
7752,1,
7754,1,
7756,1,
7758,1,
7760,1,
7762,1,
7764,1,
7766,1,
7768,1,
7770,1,
7772,1,
7774,1,
7776,1,
7778,1,
7780,1,
7782,1,
7784,1,
7786,1,
7788,1,
7790,1,
7792,1,
7794,1,
7796,1,
7798,1,
7800,1,
7802,1,
7804,1,
7806,1,
7808,1,
7810,1,
7812,1,
7814,1,
7816,1,
7818,1,
7820,1,
7822,1,
7824,1,
7826,1,
7828,1,
7840,1,
7842,1,
7844,1,
7846,1,
7848,1,
7850,1,
7852,1,
7854,1,
7856,1,
7858,1,
7860,1,
7862,1,
7864,1,
7866,1,
7868,1,
7870,1,
7872,1,
7874,1,
7876,1,
7878,1,
7880,1,
7882,1,
7884,1,
7886,1,
7888,1,
7890,1,
7892,1,
7894,1,
7896,1,
7898,1,
7900,1,
7902,1,
7904,1,
7906,1,
7908,1,
7910,1,
7912,1,
7914,1,
7916,1,
7918,1,
7920,1,
7922,1,
7924,1,
7926,1,
7928,1,
7944,8,
7960,6,
7976,8,
7992,8,
8008,6,
8025,1,
8027,1,
8029,1,
8031,1,
8040,8,
8072,8,
8088,8,
8104,8,
8120,5,
8136,5,
8152,4,
8168,5,
8184,5,
8450,1,
8455,1,
8459,3,
8464,3,
8469,1,
8473,5,
8484,1,
8486,1,
8488,1,
8490,4,
8496,4,
8510,2,
8517,1,
8579,1,
11264,47,
11360,1,
11362,3,
11367,1,
11369,1,
11371,1,
11381,1,
11392,1,
11394,1,
11396,1,
11398,1,
11400,1,
11402,1,
11404,1,
11406,1,
11408,1,
11410,1,
11412,1,
11414,1,
11416,1,
11418,1,
11420,1,
11422,1,
11424,1,
11426,1,
11428,1,
11430,1,
11432,1,
11434,1,
11436,1,
11438,1,
11440,1,
11442,1,
11444,1,
11446,1,
11448,1,
11450,1,
11452,1,
11454,1,
11456,1,
11458,1,
11460,1,
11462,1,
11464,1,
11466,1,
11468,1,
11470,1,
11472,1,
11474,1,
11476,1,
11478,1,
11480,1,
11482,1,
11484,1,
11486,1,
11488,1,
11490,1
];
whitespaceAndNewlineCharacterSet = [
9,5,
32,1,
133,1,
160,1,
5760,1,
8192,12,
8232,2,
8239,1,
8287,1
];
whitespaceCharacterSet = [
9,1,
32,1,
160,1,
5760,1,
8192,12,
8239,1,
8287,1
];p;9;CPCoder.jt;2709;@STATIC;1.0;i;13;CPException.ji;10;CPObject.jt;2657;objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
//@global _CPRaiseInvalidAbstractInvocation;
{var the_class = objj_allocateClassPair(CPObject, "CPCoder"),
meta_class = the_class.isa;









objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("allowsKeyedCoding"), function $CPCoder__allowsKeyedCoding(self, _cmd)
{
   return NO;
}
,["BOOL"]), new objj_method(sel_getUid("encodeValueOfObjCType:at:"), function $CPCoder__encodeValueOfObjCType_at_(self, _cmd, aType, anObject)
{
   _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["void","CPString","id"]), new objj_method(sel_getUid("encodeDataObject:"), function $CPCoder__encodeDataObject_(self, _cmd, aData)
{
   _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["void","CPData"]), new objj_method(sel_getUid("encodeObject:"), function $CPCoder__encodeObject_(self, _cmd, anObject)
{
}
,["void","id"]), new objj_method(sel_getUid("encodePoint:"), function $CPCoder__encodePoint_(self, _cmd, aPoint)
{
    objj_msgSend(self, "encodeNumber:", aPoint.x);
    objj_msgSend(self, "encodeNumber:", aPoint.y);
}
,["void","CGPoint"]), new objj_method(sel_getUid("encodeRect:"), function $CPCoder__encodeRect_(self, _cmd, aRect)
{
    objj_msgSend(self, "encodePoint:", aRect.origin);
    objj_msgSend(self, "encodeSize:", aRect.size);
}
,["void","CGRect"]), new objj_method(sel_getUid("encodeSize:"), function $CPCoder__encodeSize_(self, _cmd, aSize)
{
    objj_msgSend(self, "encodeNumber:", aSize.width);
    objj_msgSend(self, "encodeNumber:", aSize.height);
}
,["void","CGSize"]), new objj_method(sel_getUid("encodePropertyList:"), function $CPCoder__encodePropertyList_(self, _cmd, aPropertyList)
{
}
,["void","id"]), new objj_method(sel_getUid("encodeRootObject:"), function $CPCoder__encodeRootObject_(self, _cmd, anObject)
{
   objj_msgSend(self, "encodeObject:", anObject);
}
,["void","id"]), new objj_method(sel_getUid("encodeBycopyObject:"), function $CPCoder__encodeBycopyObject_(self, _cmd, anObject)
{
   objj_msgSend(self, "encodeObject:", anObject);
}
,["void","id"]), new objj_method(sel_getUid("encodeConditionalObject:"), function $CPCoder__encodeConditionalObject_(self, _cmd, anObject)
{
   objj_msgSend(self, "encodeObject:", anObject);
}
,["void","id"])]);
}
{
var the_class = objj_getClass("CPObject")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPObject\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("awakeAfterUsingCoder:"), function $CPObject__awakeAfterUsingCoder_(self, _cmd, aDecoder)
{
    return self;
}
,["id","CPCoder"])]);
}p;14;CPCountedSet.jt;1945;@STATIC;1.0;i;10;CPObject.ji;23;_CPConcreteMutableSet.jt;1883;objj_executeFile("CPObject.j", YES);
objj_executeFile("_CPConcreteMutableSet.j", YES);
{var the_class = objj_allocateClassPair(_CPConcreteMutableSet, "CPCountedSet"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_counts")]);


objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("addObject:"), function $CPCountedSet__addObject_(self, _cmd, anObject)
{
    if (!self._counts)
        self._counts = {};
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPCountedSet").super_class }, "addObject:", anObject);
    var UID = objj_msgSend(anObject, "UID");
    if (self._counts[UID] === undefined)
        self._counts[UID] = 1;
    else
        ++self._counts[UID];
}
,["void","id"]), new objj_method(sel_getUid("removeObject:"), function $CPCountedSet__removeObject_(self, _cmd, anObject)
{
    if (!self._counts)
        return;
    var UID = objj_msgSend(anObject, "UID");
    if (self._counts[UID] === undefined)
        return;
    else
    {
        --self._counts[UID];
        if (self._counts[UID] === 0)
        {
            delete self._counts[UID];
            objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPCountedSet").super_class }, "removeObject:", anObject);
        }
    }
}
,["void","id"]), new objj_method(sel_getUid("removeAllObjects"), function $CPCountedSet__removeAllObjects(self, _cmd)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPCountedSet").super_class }, "removeAllObjects");
    self._counts = {};
}
,["void"]), new objj_method(sel_getUid("countForObject:"), function $CPCountedSet__countForObject_(self, _cmd, anObject)
{
    if (!self._counts)
        self._counts = {};
    var UID = objj_msgSend(anObject, "UID");
    if (self._counts[UID] === undefined)
        return 0;
    return self._counts[UID];
}
,["unsigned","id"])]);
}p;8;CPData.jt;6619;@STATIC;1.0;i;10;CPObject.ji;10;CPString.jt;6570;objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPData"),
meta_class = the_class.isa;

















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithRawString:"), function $CPData__initWithRawString_(self, _cmd, aString)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPData").super_class }, "init");
    if (self)
        objj_msgSend(self, "setRawString:", aString);
    return self;
}
,["id","CPString"]), new objj_method(sel_getUid("initWithPlistObject:"), function $CPData__initWithPlistObject_(self, _cmd, aPlistObject)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPData").super_class }, "init");
    if (self)
        objj_msgSend(self, "setPlistObject:", aPlistObject);
    return self;
}
,["id","id"]), new objj_method(sel_getUid("initWithPlistObject:format:"), function $CPData__initWithPlistObject_format_(self, _cmd, aPlistObject, aFormat)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPData").super_class }, "init");
    if (self)
        objj_msgSend(self, "setPlistObject:format:", aPlistObject, aFormat);
    return self;
}
,["id","id",null]), new objj_method(sel_getUid("initWithJSONObject:"), function $CPData__initWithJSONObject_(self, _cmd, anObject)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPData").super_class }, "init");
    if (self)
        objj_msgSend(self, "setJSONObject:", anObject);
    return self;
}
,["id","Object"]), new objj_method(sel_getUid("rawString"), function $CPData__rawString(self, _cmd)
{
    return self.rawString();
}
,["CPString"]), new objj_method(sel_getUid("plistObject"), function $CPData__plistObject(self, _cmd)
{
    return self.propertyList();
}
,["id"]), new objj_method(sel_getUid("JSONObject"), function $CPData__JSONObject(self, _cmd)
{
    return self.JSONObject();
}
,["Object"]), new objj_method(sel_getUid("bytes"), function $CPData__bytes(self, _cmd)
{
    return self.bytes();
}
,["CPArray"]), new objj_method(sel_getUid("base64"), function $CPData__base64(self, _cmd)
{
    return self.base64();
}
,["CPString"]), new objj_method(sel_getUid("length"), function $CPData__length(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "rawString"), "length");
}
,["int"]), new objj_method(sel_getUid("description"), function $CPData__description(self, _cmd)
{
    return self.toString();
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $CPData__alloc(self, _cmd)
{
    var result = new CFMutableData();
    result.isa = objj_msgSend(self, "class");
    return result;
}
,["id"]), new objj_method(sel_getUid("data"), function $CPData__data(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "init");
}
,["CPData"]), new objj_method(sel_getUid("dataWithRawString:"), function $CPData__dataWithRawString_(self, _cmd, aString)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithRawString:", aString);
}
,["CPData","CPString"]), new objj_method(sel_getUid("dataWithPlistObject:"), function $CPData__dataWithPlistObject_(self, _cmd, aPlistObject)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithPlistObject:", aPlistObject);
}
,["CPData","id"]), new objj_method(sel_getUid("dataWithPlistObject:format:"), function $CPData__dataWithPlistObject_format_(self, _cmd, aPlistObject, aFormat)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithPlistObject:format:", aPlistObject, aFormat);
}
,["CPData","id","CPPropertyListFormat"]), new objj_method(sel_getUid("dataWithJSONObject:"), function $CPData__dataWithJSONObject_(self, _cmd, anObject)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithJSONObject:", anObject);
}
,["CPData","Object"]), new objj_method(sel_getUid("dataWithBytes:"), function $CPData__dataWithBytes_(self, _cmd, bytesArray)
{
    var data = objj_msgSend(objj_msgSend(self, "alloc"), "init");
    data.setBytes(bytesArray);
    return data;
}
,["CPData","CPArray"]), new objj_method(sel_getUid("dataWithBase64:"), function $CPData__dataWithBase64_(self, _cmd, aString)
{
    var data = objj_msgSend(objj_msgSend(self, "alloc"), "init");
    data.setBase64String(aString);
    return data;
}
,["CPData","CPString"])]);
}
{
var the_class = objj_getClass("CPData")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPData\"");
var meta_class = the_class.isa;


class_addMethods(the_class, [new objj_method(sel_getUid("setRawString:"), function $CPData__setRawString_(self, _cmd, aString)
{
    self.setRawString(aString);
}
,["void","CPString"]), new objj_method(sel_getUid("setPlistObject:"), function $CPData__setPlistObject_(self, _cmd, aPlistObject)
{
    self.setPropertyList(aPlistObject);
}
,["void","id"]), new objj_method(sel_getUid("setPlistObject:format:"), function $CPData__setPlistObject_format_(self, _cmd, aPlistObject, aFormat)
{
    self.setPropertyList(aPlistObject, aFormat);
}
,["void","id","CPPropertyListFormat"]), new objj_method(sel_getUid("setJSONObject:"), function $CPData__setJSONObject_(self, _cmd, anObject)
{
    self.setJSONObject(anObject);
}
,["void","Object"])]);
}
{
var the_class = objj_getClass("CPData")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPData\"");
var meta_class = the_class.isa;


class_addMethods(the_class, [new objj_method(sel_getUid("initWithString:"), function $CPData__initWithString_(self, _cmd, aString)
{
    _CPReportLenientDeprecation(self, _cmd, sel_getUid("initWithRawString:"));
    return objj_msgSend(self, "initWithRawString:", aString);
}
,["id","CPString"]), new objj_method(sel_getUid("setString:"), function $CPData__setString_(self, _cmd, aString)
{
    _CPReportLenientDeprecation(self, _cmd, sel_getUid("setRawString:"));
    objj_msgSend(self, "setRawString:", aString);
}
,["void","CPString"]), new objj_method(sel_getUid("string"), function $CPData__string(self, _cmd)
{
    _CPReportLenientDeprecation(self, _cmd, sel_getUid("rawString"));
    return objj_msgSend(self, "rawString");
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("dataWithString:"), function $CPData__dataWithString_(self, _cmd, aString)
{
    _CPReportLenientDeprecation(self, _cmd, sel_getUid("dataWithRawString:"));
    return objj_msgSend(self, "dataWithRawString:", aString);
}
,["id","CPString"])]);
}
CFData.prototype.isa = CPData;
CFMutableData.prototype.isa = CPData;p;8;CPDate.jt;8526;@STATIC;1.0;i;10;CPObject.ji;10;CPString.ji;13;CPException.jt;8459;objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("CPException.j", YES);
var CPDateReferenceDate = new Date(Date.UTC(2001, 0, 1, 0, 0, 0, 0));
{var the_class = objj_allocateClassPair(CPObject, "CPDate"),
meta_class = the_class.isa;























objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithTimeIntervalSinceNow:"), function $CPDate__initWithTimeIntervalSinceNow_(self, _cmd, seconds)
{
    self = new Date((new Date()).getTime() + seconds * 1000);
    return self;
}
,["id","CPTimeInterval"]), new objj_method(sel_getUid("initWithTimeIntervalSince1970:"), function $CPDate__initWithTimeIntervalSince1970_(self, _cmd, seconds)
{
    self = new Date(seconds * 1000);
    return self;
}
,["id","CPTimeInterval"]), new objj_method(sel_getUid("initWithTimeIntervalSinceReferenceDate:"), function $CPDate__initWithTimeIntervalSinceReferenceDate_(self, _cmd, seconds)
{
    self = objj_msgSend(self, "initWithTimeInterval:sinceDate:", seconds, CPDateReferenceDate);
    return self;
}
,["id","CPTimeInterval"]), new objj_method(sel_getUid("initWithTimeInterval:sinceDate:"), function $CPDate__initWithTimeInterval_sinceDate_(self, _cmd, seconds, refDate)
{
    self = new Date(refDate.getTime() + seconds * 1000);
    return self;
}
,["id","CPTimeInterval","CPDate"]), new objj_method(sel_getUid("initWithString:"), function $CPDate__initWithString_(self, _cmd, description)
{
    var format = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2}) ([-+])(\d{2})(\d{2})/,
        d = description.match(new RegExp(format));
    if (!d || d.length != 10)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "initWithString: the string must be in YYYY-MM-DD HH:MM:SS ±HHMM format");
    var date = new Date(d[1], d[2] - 1, d[3]),
        timeZoneOffset = (Number(d[8]) * 60 + Number(d[9])) * (d[7] === '-' ? 1 : -1);
    date.setHours(d[4]);
    date.setMinutes(d[5]);
    date.setSeconds(d[6]);
    self = new Date(date.getTime() + (timeZoneOffset - date.getTimezoneOffset()) * 60 * 1000);
    return self;
}
,["id","CPString"]), new objj_method(sel_getUid("timeIntervalSinceDate:"), function $CPDate__timeIntervalSinceDate_(self, _cmd, anotherDate)
{
    return (self.getTime() - anotherDate.getTime()) / 1000.0;
}
,["CPTimeInterval","CPDate"]), new objj_method(sel_getUid("timeIntervalSinceNow"), function $CPDate__timeIntervalSinceNow(self, _cmd)
{
    return objj_msgSend(self, "timeIntervalSinceDate:", objj_msgSend(CPDate, "date"));
}
,["CPTimeInterval"]), new objj_method(sel_getUid("timeIntervalSince1970"), function $CPDate__timeIntervalSince1970(self, _cmd)
{
    return self.getTime() / 1000.0;
}
,["CPTimeInterval"]), new objj_method(sel_getUid("timeIntervalSinceReferenceDate"), function $CPDate__timeIntervalSinceReferenceDate(self, _cmd)
{
    return (self.getTime() - CPDateReferenceDate.getTime()) / 1000.0;
}
,["CPTimeInterval"]), new objj_method(sel_getUid("isEqual:"), function $CPDate__isEqual_(self, _cmd, aDate)
{
    if (self === aDate)
        return YES;
    if (!aDate || !objj_msgSend(aDate, "isKindOfClass:", objj_msgSend(CPDate, "class")))
        return NO;
    return objj_msgSend(self, "isEqualToDate:", aDate);
}
,["BOOL","CPDate"]), new objj_method(sel_getUid("isEqualToDate:"), function $CPDate__isEqualToDate_(self, _cmd, aDate)
{
    if (!aDate)
        return NO;
    return !(self < aDate || self > aDate);
}
,["BOOL","CPDate"]), new objj_method(sel_getUid("compare:"), function $CPDate__compare_(self, _cmd, anotherDate)
{
    return (self > anotherDate) ? CPOrderedDescending : ((self < anotherDate) ? CPOrderedAscending : CPOrderedSame);
}
,["CPComparisonResult","CPDate"]), new objj_method(sel_getUid("earlierDate:"), function $CPDate__earlierDate_(self, _cmd, anotherDate)
{
    return (self < anotherDate) ? self : anotherDate;
}
,["CPDate","CPDate"]), new objj_method(sel_getUid("laterDate:"), function $CPDate__laterDate_(self, _cmd, anotherDate)
{
    return (self > anotherDate) ? self : anotherDate;
}
,["CPDate","CPDate"]), new objj_method(sel_getUid("description"), function $CPDate__description(self, _cmd)
{
    return objj_msgSend(CPString, "stringWithFormat:", "%04d-%02d-%02d %02d:%02d:%02d %s", self.getFullYear(), self.getMonth() + 1, self.getDate(), self.getHours(), self.getMinutes(), self.getSeconds(), objj_msgSend(CPDate, "timezoneOffsetString:", self.getTimezoneOffset()));
}
,["CPString"]), new objj_method(sel_getUid("copy"), function $CPDate__copy(self, _cmd)
{
    return new Date(self.getTime());
}
,["id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $CPDate__alloc(self, _cmd)
{
    var result = new Date;
    result.isa = objj_msgSend(self, "class");
    return result;
}
,["id"]), new objj_method(sel_getUid("date"), function $CPDate__date(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "init");
}
,["id"]), new objj_method(sel_getUid("dateWithTimeIntervalSinceNow:"), function $CPDate__dateWithTimeIntervalSinceNow_(self, _cmd, seconds)
{
    return objj_msgSend(objj_msgSend(CPDate, "alloc"), "initWithTimeIntervalSinceNow:", seconds);
}
,["id","CPTimeInterval"]), new objj_method(sel_getUid("dateWithTimeIntervalSince1970:"), function $CPDate__dateWithTimeIntervalSince1970_(self, _cmd, seconds)
{
    return objj_msgSend(objj_msgSend(CPDate, "alloc"), "initWithTimeIntervalSince1970:", seconds);
}
,["id","CPTimeInterval"]), new objj_method(sel_getUid("dateWithTimeIntervalSinceReferenceDate:"), function $CPDate__dateWithTimeIntervalSinceReferenceDate_(self, _cmd, seconds)
{
    return objj_msgSend(objj_msgSend(CPDate, "alloc"), "initWithTimeIntervalSinceReferenceDate:", seconds);
}
,["id","CPTimeInterval"]), new objj_method(sel_getUid("distantPast"), function $CPDate__distantPast(self, _cmd)
{
    return objj_msgSend(CPDate, "dateWithTimeIntervalSinceReferenceDate:", -63113817600.0);
}
,["id"]), new objj_method(sel_getUid("distantFuture"), function $CPDate__distantFuture(self, _cmd)
{
    return objj_msgSend(CPDate, "dateWithTimeIntervalSinceReferenceDate:", 63113990400.0);
}
,["id"]), new objj_method(sel_getUid("timeIntervalSinceReferenceDate"), function $CPDate__timeIntervalSinceReferenceDate(self, _cmd)
{
    return objj_msgSend(objj_msgSend(CPDate, "date"), "timeIntervalSinceReferenceDate");
}
,["CPTimeInterval"]), new objj_method(sel_getUid("timezoneOffsetString:"), function $CPDate__timezoneOffsetString_(self, _cmd, timezoneOffset)
{
    var offset = -timezoneOffset,
        positive = offset >= 0,
        hours = positive ? FLOOR(offset / 60) : CEIL(offset / 60),
        minutes = offset - hours * 60;
    return objj_msgSend(CPString, "stringWithFormat:", "%s%02d%02d", positive ? "+" : "-", ABS(hours), ABS(minutes));
}
,["CPString","int"])]);
}
var CPDateTimeKey = "CPDateTimeKey";
{
var the_class = objj_getClass("CPDate")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPDate\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPDate__initWithCoder_(self, _cmd, aCoder)
{
    if (self)
    {
        self.setTime(objj_msgSend(aCoder, "decodeIntForKey:", CPDateTimeKey));
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPDate__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeInt:forKey:", self.getTime(), CPDateTimeKey);
}
,["void","CPCoder"])]);
}
var numericKeys = [1, 4, 5, 6, 7, 10, 11];
Date.parseISO8601 = function (date)
{
    var timestamp,
        struct,
        minutesOffset = 0;
    timestamp = Date.parse(date);
    if (isNaN(timestamp) && (struct = /^(\d{4}|[+\-]\d{6})(?:-(\d{2})(?:-(\d{2}))?)?(?:T(\d{2}):(\d{2})(?::(\d{2})(?:\.(\d{3}))?)?(?:(Z)|([+\-])(\d{2})(?::(\d{2}))?)?)?$/.exec(date)))
    {
        for (var i = 0, k; (k = numericKeys[i]); ++i)
            struct[k] = +struct[k] || 0;
        struct[2] = (+struct[2] || 1) - 1;
        struct[3] = +struct[3] || 1;
        if (struct[8] !== 'Z' && struct[9] !== undefined)
        {
            minutesOffset = struct[10] * 60 + struct[11];
            if (struct[9] === '+')
                minutesOffset = 0 - minutesOffset;
        }
        return Date.UTC(struct[1], struct[2], struct[3], struct[4], struct[5] + minutesOffset, struct[6], struct[7]);
    }
    return timestamp;
};
Date.prototype.isa = CPDate;p;17;CPDateFormatter.jt;3890;@STATIC;1.0;i;8;CPDate.ji;10;CPString.ji;13;CPFormatter.jt;3826;objj_executeFile("CPDate.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("CPFormatter.j", YES);
CPDateFormatterNoStyle = 0;
CPDateFormatterShortStyle = 1;
CPDateFormatterMediumStyle = 2;
CPDateFormatterLongStyle = 3;
CPDateFormatterFullStyle = 4;
{var the_class = objj_allocateClassPair(CPFormatter, "CPDateFormatter"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_dateStyle")]);




objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("dateStyle"), function $CPDateFormatter__dateStyle(self, _cmd)
{
return self._dateStyle;
}
,["CPDateFormatterStyle"]), new objj_method(sel_getUid("setDateStyle:"), function $CPDateFormatter__setDateStyle_(self, _cmd, newValue)
{
self._dateStyle = newValue;
}
,["void","CPDateFormatterStyle"]), new objj_method(sel_getUid("init"), function $CPDateFormatter__init(self, _cmd)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPDateFormatter").super_class }, "init"))
    {
        self._dateStyle = CPDateFormatterShortStyle;
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("stringFromDate:"), function $CPDateFormatter__stringFromDate_(self, _cmd, aDate)
{
    switch (self._dateStyle)
    {
        case CPDateFormatterShortStyle:
            var format = "d/m/Y";
            return aDate.dateFormat(format);
        default:
            return objj_msgSend(aDate, "description");
    }
}
,["CPString","CPDate"]), new objj_method(sel_getUid("dateFromString:"), function $CPDateFormatter__dateFromString_(self, _cmd, aString)
{
    if (!aString)
        return nil;
    switch (self._dateStyle)
    {
        case CPDateFormatterShortStyle:
            var format = "d/m/Y";
            return Date.parseDate(aString, format);
        default:
            return Date.parseDate(aString);
    }
}
,["CPDate","CPString"]), new objj_method(sel_getUid("stringForObjectValue:"), function $CPDateFormatter__stringForObjectValue_(self, _cmd, anObject)
{
    if (objj_msgSend(anObject, "isKindOfClass:", objj_msgSend(CPDate, "class")))
        return objj_msgSend(self, "stringFromDate:", anObject);
    else
        return objj_msgSend(anObject, "description");
}
,["CPString","id"]), new objj_method(sel_getUid("editingStringForObjectValue:"), function $CPDateFormatter__editingStringForObjectValue_(self, _cmd, anObject)
{
    return objj_msgSend(self, "stringForObjectValue:", anObject);
}
,["CPString","id"]), new objj_method(sel_getUid("getObjectValue:forString:errorDescription:"), function $CPDateFormatter__getObjectValue_forString_errorDescription_(self, _cmd, anObject, aString, anError)
{
    var value = objj_msgSend(self, "dateFromString:", aString);
    anObject( value);
    return YES;
}
,["BOOL","id","CPString","CPString"])]);
}
var CPDateFormatterStyleKey = "CPDateFormatterStyle";
{
var the_class = objj_getClass("CPDateFormatter")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPDateFormatter\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPDateFormatter__initWithCoder_(self, _cmd, aCoder)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPDateFormatter").super_class }, "initWithCoder:", aCoder);
    if (self)
    {
        self._dateStyle = objj_msgSend(aCoder, "decodeIntForKey:", CPDateFormatterStyleKey);
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPDateFormatter__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPDateFormatter").super_class }, "encodeWithCoder:", aCoder);
    objj_msgSend(aCoder, "encodeInt:forKey:", self._dateStyle, CPDateFormatterStyleKey);
}
,["void","CPCoder"])]);
}p;11;CPDecimal.jt;28717;@STATIC;1.0;i;9;CPArray.ji;10;CPNumber.jt;28669;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPNumber.j", YES);
CPDecimalMaxDigits = 38;
CPDecimalMaxExponent = 127;
CPDecimalMinExponent = -128;
CPDecimalNoScale = 128
CPCalculationNoError = 0;
CPCalculationLossOfPrecision = 1;
CPCalculationOverflow = 2;
CPCalculationUnderflow = 3;
CPCalculationDivideByZero = 4;
CPRoundPlain = 1;
CPRoundDown = 2;
CPRoundUp = 3;
CPRoundBankers = 4;
_CPRoundHalfDown = 5;
CPDecimalNumberOverflowException = "CPDecimalNumberOverflowException";
CPDecimalNumberUnderflowException = "CPDecimalNumberUnderflowException";
CPDecimalNumberExactnessException = "CPDecimalNumberExactnessException";
CPDecimalNumberDivideByZeroException = "CPDecimalNumberDivideByZeroException";
CPDecimalMakeWithString = function(string, locale)
{
    if (!string)
        return CPDecimalMakeNaN();
    var matches = string.match(/^([+\-]?)((?:0|[1-9]\d*)?)(?:\.(\d*))?(?:[eE]([+\-]?)(\d+))?$/);
    if (!matches)
        return CPDecimalMakeNaN();
    var ds = matches[1],
        intpart = matches[2],
        decpart = matches[3],
        es = matches[4],
        exp = matches[5];
    var isNegative = NO;
    if (ds && ds === "-")
        isNegative = YES;
    var exponent = 0;
    if (exp)
        exponent = parseInt(exp) * ((es && es === "-")?-1:1);
    if (decpart)
        exponent -= decpart.length;
    var inputlength = (intpart?intpart.length:0) + (decpart?decpart.length:0);
    if (inputlength > CPDecimalMaxDigits)
    {
        exponent += inputlength - CPDecimalMaxDigits;
    }
    else if (inputlength === 0)
    {
        return CPDecimalMakeNaN();
    }
    if (exponent > CPDecimalMaxExponent || exponent < CPDecimalMinExponent)
        return CPDecimalMakeNaN();
    var m = [],
        i = 0;
    for (; i < (intpart?intpart.length:0); i++)
    {
        if (i >= CPDecimalMaxDigits)
            break;
        Array.prototype.push.call(m, parseInt(intpart.charAt(i)));
    }
    var j = 0;
    for (; j < (decpart?decpart.length:0); j++)
    {
        if ((i + j) >= CPDecimalMaxDigits)
            break;
        Array.prototype.push.call(m, parseInt(decpart.charAt(j)));
    }
    var dcm = {_exponent:exponent, _isNegative:isNegative, _isCompact:NO, _isNaN:NO, _mantissa:m};
    CPDecimalCompact(dcm);
    return dcm;
}
CPDecimalMakeWithParts = function(mantissa, exponent)
{
    var m = [],
        isNegative = NO;
    if (mantissa < 0)
    {
        isNegative = YES;
        mantissa = ABS(mantissa);
    }
    if (mantissa == 0)
        Array.prototype.push.call(m, 0);
    if (exponent > CPDecimalMaxExponent || exponent < CPDecimalMinExponent)
        return CPDecimalMakeNaN();
    while ((mantissa > 0) && (m.length < CPDecimalMaxDigits))
    {
        Array.prototype.unshift.call(m, parseInt(mantissa % 10));
        mantissa = FLOOR(mantissa / 10);
    }
    var dcm = {_exponent:exponent, _isNegative:isNegative, _isCompact:YES, _isNaN:NO, _mantissa:m};
    CPDecimalCompact(dcm);
    return dcm;
}
CPDecimalMakeZero = function()
{
    return CPDecimalMakeWithParts(0, 0);
}
CPDecimalMakeOne = function()
{
    return CPDecimalMakeWithParts(1, 0);
}
CPDecimalMakeNaN = function()
{
    var d = CPDecimalMakeWithParts(0, 0);
    d._isNaN = YES;
    return d;
}
_CPDecimalMakeMaximum = function()
{
    var s = "",
        i = 0;
    for (; i < CPDecimalMaxDigits; i++)
        s += "9";
    s += "e" + CPDecimalMaxExponent;
    return CPDecimalMakeWithString(s);
}
_CPDecimalMakeMinimum = function()
{
    var s = "-",
        i = 0;
    for (; i < CPDecimalMaxDigits; i++)
        s += "9";
    s += "e" + CPDecimalMaxExponent;
    return CPDecimalMakeWithString(s);
}
CPDecimalIsZero = function(dcm)
{
    if (!dcm._isNaN)
    {
        for (var i = 0; i < dcm._mantissa.length; i++)
            if (dcm._mantissa[i] !== 0)
                return NO;
        return YES;
    }
    return NO;
}
CPDecimalIsOne = function(dcm)
{
    CPDecimalCompact(dcm);
    if (!dcm._isNaN)
    {
        if (dcm._mantissa && (dcm._mantissa.length == 1) && (dcm._mantissa[0] == 1))
            return YES;
    }
    return NO;
}
_CPDecimalSet = function(t, s)
{
    t._exponent = s._exponent;
    t._isNegative = s._isNegative;
    t._isCompact = s._isCompact;
    t._isNaN = s._isNaN;
    t._mantissa = Array.prototype.slice.call(s._mantissa, 0);
}
_CPDecimalSetZero = function(result)
{
    result._mantissa = [0];
    result._exponent = 0;
    result._isNegative = NO;
    result._isCompact = YES;
    result._isNaN = NO;
}
_CPDecimalSetOne = function(result)
{
    result._mantissa = [1];
    result._exponent = 0;
    result._isNegative = NO;
    result._isCompact = YES;
    result._isNaN = NO;
}
CPDecimalIsNotANumber = function(dcm)
{
    return (dcm._isNaN)?YES:NO;
}
CPDecimalCopy = function(dcm)
{
    return {_exponent:dcm._exponent,
            _isNegative:dcm._isNegative,
            _isCompact:dcm._isCompact,
            _isNaN:dcm._isNaN,
            _mantissa:Array.prototype.slice.call(dcm._mantissa, 0)
            };
}
CPDecimalCompare = function(leftOperand, rightOperand)
{
    if (leftOperand._isNaN && rightOperand._isNaN)
        return CPOrderedSame;
    if (leftOperand._isNegative != rightOperand._isNegative)
    {
        if (rightOperand._isNegative)
            return CPOrderedDescending;
        else
            return CPOrderedAscending;
    }
    var leftIsZero = (leftOperand._mantissa.length == 1 && leftOperand._mantissa[0] == 0),
        rightIsZero = (rightOperand._mantissa.length == 1 && rightOperand._mantissa[0] == 0),
        s1 = leftOperand._exponent + leftOperand._mantissa.length,
        s2 = rightOperand._exponent + rightOperand._mantissa.length;
    if (leftIsZero && rightIsZero)
        return CPOrderedSame;
    if (leftIsZero || (s1 < s2 && !rightIsZero))
    {
        if (rightOperand._isNegative)
            return CPOrderedDescending;
        else
            return CPOrderedAscending;
    }
    if (rightIsZero || (s1 > s2 && !leftIsZero))
    {
        if (leftOperand._isNegative)
            return CPOrderedAscending;
        else
            return CPOrderedDescending;
    }
    var l = MIN(leftOperand._mantissa.length, rightOperand._mantissa.length),
        i = 0;
    for (; i < l; i++)
    {
        var d = rightOperand._mantissa[i] - leftOperand._mantissa[i];
        if (d > 0)
        {
            if (rightOperand._isNegative)
                return CPOrderedDescending;
            else
                return CPOrderedAscending;
        }
        if (d < 0)
        {
            if (rightOperand._isNegative)
                return CPOrderedAscending;
            else
                return CPOrderedDescending;
        }
    }
    if (leftOperand._mantissa.length > rightOperand._mantissa.length)
    {
        if (rightOperand._isNegative)
            return CPOrderedAscending;
        else
            return CPOrderedDescending;
    }
    if (leftOperand._mantissa.length < rightOperand._mantissa.length)
    {
        if (rightOperand._isNegative)
            return CPOrderedDescending;
        else
            return CPOrderedAscending;
    }
    return CPOrderedSame;
}
_SimpleAdd = function(result, leftOperand, rightOperand, roundingMode, longMode)
{
    var factor = (longMode)?2:1;
    _CPDecimalSet(result, leftOperand);
    var j = leftOperand._mantissa.length - rightOperand._mantissa.length,
        l = rightOperand._mantissa.length,
        i = l - 1,
        carry = 0,
        error = CPCalculationNoError;
    for (; i >= 0; i--)
    {
        var d = rightOperand._mantissa[i] + result._mantissa[i + j] + carry;
        if (d >= 10)
        {
            d = d % 10;
            carry = 1;
        }
        else
            carry = 0;
        result._mantissa[i + j] = d;
    }
    if (carry)
    {
        for (i = j - 1; i >= 0; i--)
        {
            if (result._mantissa[i] != 9)
            {
                result._mantissa[i]++;
                carry = 0;
                break;
            }
            result._mantissa[i] = 0;
        }
        if (carry)
        {
            Array.prototype.splice.call(result._mantissa, 0, 0, 1);
            if ((CPDecimalMaxDigits * factor) == leftOperand._mantissa.length)
            {
                var scale = - result._exponent - 1;
                CPDecimalRound(result, result, scale, roundingMode);
            }
            if (CPDecimalMaxExponent < result._exponent)
            {
                result._isNaN = YES;
                error = CPCalculationOverflow;
                result._exponent = CPDecimalMaxExponent;
            }
        }
    }
    return error;
}
CPDecimalAdd = function(result, leftOperand, rightOperand, roundingMode, longMode)
{
    if (leftOperand._isNaN || rightOperand._isNaN)
    {
        result._isNaN = YES;
        return CPCalculationNoError;
    }
    if (CPDecimalIsZero(leftOperand))
    {
        _CPDecimalSet(result, rightOperand);
        return CPCalculationNoError;
    }
    if (CPDecimalIsZero(rightOperand))
    {
        _CPDecimalSet(result, leftOperand);
        return CPCalculationNoError;
    }
    var n1 = CPDecimalCopy(leftOperand),
        n2 = CPDecimalCopy(rightOperand);
    if (leftOperand._isNegative != rightOperand._isNegative)
    {
        if (leftOperand._isNegative)
        {
            n1._isNegative = NO;
            return CPDecimalSubtract(result, rightOperand, n1, roundingMode);
        }
        else
        {
            n2._isNegative = NO;
            return CPDecimalSubtract(result, leftOperand, n2, roundingMode);
        }
    }
    var normerror = CPDecimalNormalize(n1, n2, roundingMode, longMode);
    var comp = 0,
        ll = n1._mantissa.length,
        lr = n2._mantissa.length;
    if (ll == lr)
        comp = CPOrderedSame;
    else if (ll > lr)
        comp = CPOrderedDescending;
    else
        comp = CPOrderedAscending;
    if (leftOperand._isNegative)
    {
        n1._isNegative = NO;
        n2._isNegative = NO;
        if (comp == CPOrderedDescending)
        {
            adderror = _SimpleAdd(result, n1, n2, roundingMode, longMode);
        }
        else
        {
            adderror = _SimpleAdd(result, n2, n1, roundingMode, longMode);
        }
        result._isNegative = YES;
        if (CPCalculationUnderflow == adderror)
            adderror = CPCalculationOverflow;
        else if (CPCalculationUnderflow == adderror)
            adderror = CPCalculationUnderflow;
    }
    else
    {
        if (comp == CPOrderedAscending)
        {
            adderror = _SimpleAdd(result, n2, n1, roundingMode, longMode);
        }
        else
        {
            adderror = _SimpleAdd(result, n1, n2, roundingMode, longMode);
        }
    }
    CPDecimalCompact(result);
    if (adderror == CPCalculationNoError)
        return normerror;
    else
        return adderror;
}
_SimpleSubtract = function(result, leftOperand, rightOperand, roundingMode)
{
    var error = CPCalculationNoError,
        borrow = 0,
        l = rightOperand._mantissa.length,
        j = leftOperand._mantissa.length - l,
        i = l - 1;
    _CPDecimalSet(result, leftOperand);
    for (; i >= 0; i--)
    {
        var d = result._mantissa[i + j] - rightOperand._mantissa[i] - borrow;
        if (d < 0)
        {
            d = d + 10;
            borrow = 1;
        }
        else
            borrow = 0;
        result._mantissa[i + j] = d;
    }
    if (borrow)
    {
        for (i = j - 1; i >= 0; i--)
        {
            if (result._mantissa[i] != 0)
            {
                result._mantissa[i]--;
                break;
            }
            result._mantissa[i] = 9;
        }
        if (-1 == i)
        {
            error = nil;
        }
    }
    return error;
}
CPDecimalSubtract = function(result, leftOperand, rightOperand, roundingMode)
{
    if (leftOperand._isNaN || rightOperand._isNaN)
    {
        result._isNaN = YES;
        return CPCalculationNoError;
    }
    if (CPDecimalIsZero(leftOperand))
    {
        _CPDecimalSet(result, rightOperand);
        result._isNegative = !result._isNegative;
        return CPCalculationNoError;
    }
    if (CPDecimalIsZero(rightOperand))
    {
        _CPDecimalSet(result, leftOperand);
        return CPCalculationNoError;
    }
    var n1 = CPDecimalCopy(leftOperand),
        n2 = CPDecimalCopy(rightOperand),
        error1 = CPCalculationNoError;
    if (leftOperand._isNegative != rightOperand._isNegative)
    {
        if (leftOperand._isNegative)
        {
            n1._isNegative = NO;
            error1 = CPDecimalAdd(result, n1, rightOperand, roundingMode);
            result._isNegative = YES;
            if (error1 == CPCalculationUnderflow)
                error1 = CPCalculationOverflow;
            else if (error1 == CPCalculationOverflow)
                error1 = CPCalculationUnderflow;
            return error1;
        }
        else
        {
            n2._isNegative = NO;
            return CPDecimalAdd(result, leftOperand, n2, roundingMode);
        }
    }
    var error = CPDecimalNormalize(n1, n2, roundingMode),
        comp = CPDecimalCompare(leftOperand, rightOperand);
    if (comp == CPOrderedSame)
    {
        _CPDecimalSetZero(result);
        return CPCalculationNoError;
    }
    if (leftOperand._isNegative)
    {
        n1._isNegative = NO;
        n2._isNegative = NO;
        if (comp == CPOrderedAscending)
        {
            error1 = _SimpleSubtract(result, n1, n2, roundingMode);
            result._isNegative = YES;
        }
        else
        {
            error1 = _SimpleSubtract(result, n2, n1, roundingMode);
        }
    }
    else
    {
        if (comp == CPOrderedAscending)
        {
            error1 = _SimpleSubtract(result, n2, n1, roundingMode);
            result._isNegative = YES;
        }
        else
        {
            error1 = _SimpleSubtract(result, n1, n2, roundingMode);
        }
    }
    CPDecimalCompact(result);
    if (error1 == CPCalculationNoError)
        return error;
    else
        return error1;
}
_SimpleDivide = function(result, leftOperand, rightOperand, roundingMode)
{
    var error = CPCalculationNoError,
        n1 = CPDecimalMakeZero(),
        k = 0,
        firsttime = YES,
        stopk = CPDecimalMaxDigits + 1,
        used = 0;
    _CPDecimalSetZero(result);
    n1._mantissa = [];
    while ((used < leftOperand._mantissa.length) || (n1._mantissa.length
                                                    && !((n1._mantissa.length == 1) && (n1._mantissa[0] == 0))))
    {
        while (CPOrderedAscending == CPDecimalCompare(n1, rightOperand))
        {
            if (stopk == k)
                break;
            if (n1._exponent)
            {
                Array.prototype.push.call(n1._mantissa, 0);
                n1._exponent--;
                n1._isCompact = NO;
            }
            else
            {
                if (used < leftOperand._mantissa.length)
                {
                    if (n1._mantissa.length || leftOperand._mantissa[used])
                    {
                        Array.prototype.push.call(n1._mantissa, (leftOperand._mantissa[used]));
                        n1._isCompact = NO;
                    }
                    used++;
                }
                else
                {
                    if (result._exponent == CPDecimalMinExponent)
                    {
                        k = stopk;
                        break;
                    }
                    Array.prototype.push.call(n1._mantissa, 0);
                    result._exponent--;
                }
                if (!firsttime)
                {
                    k++;
                    result._mantissa[k - 1] = 0;
                }
            }
        }
        if (stopk == k)
        {
            error = CPCalculationLossOfPrecision;
            break;
        }
        if (firsttime)
        {
            firsttime = NO;
            k++;
        }
        error1 = CPDecimalSubtract(n1, n1, rightOperand, roundingMode);
        if (error1 != CPCalculationNoError)
            error = error1;
        result._mantissa[k - 1]++;
    }
    return error;
}
CPDecimalDivide = function(result, leftOperand, rightOperand, roundingMode)
{
    var error = CPCalculationNoError,
        exp = leftOperand._exponent - rightOperand._exponent,
        neg = (leftOperand._isNegative != rightOperand._isNegative);
    if (leftOperand._isNaN || rightOperand._isNaN)
    {
        result._isNaN = YES;
        return CPCalculationNoError;
    }
    if (CPDecimalIsZero(rightOperand))
    {
        result._isNaN = YES;
        return CPCalculationDivideByZero;
    }
    if (CPDecimalIsZero(leftOperand))
    {
        _CPDecimalSetZero(result);
        return CPCalculationNoError;
    }
    var n1 = CPDecimalCopy(leftOperand),
        n2 = CPDecimalCopy(rightOperand);
    n1._exponent = 0;
    n1._isNegative = NO;
    n2._exponent = 0;
    n2._isNegative = NO;
    error = _SimpleDivide(result, n1, n2, roundingMode);
    CPDecimalCompact(result);
    if (result._exponent + exp > CPDecimalMaxExponent)
    {
        result._isNaN = YES;
        if (neg)
            return CPCalculationUnderflow;
        else
            return CPCalculationOverflow;
    }
    else if (result._exponent + exp < CPDecimalMinExponent)
    {
        CPDecimalRound(result, result, exp + CPDecimalMaxExponent + 1, roundingMode);
        error = CPCalculationLossOfPrecision;
        if (result._exponent + exp < CPDecimalMinExponent)
        {
            CPDecimalSetZero(result);
            return error;
        }
    }
    result._exponent += exp;
    result._isNegative = neg;
    return error;
}
_SimpleMultiply = function(result, leftOperand, rightOperand, roundingMode, powerMode)
{
    var error = CPCalculationNoError,
        carry = 0,
        exp = 0,
        n = CPDecimalMakeZero();
    _CPDecimalSetZero(result);
    for (var i = 0; i < rightOperand._mantissa.length; i++)
    {
        _CPDecimalSetZero(n);
        n._exponent = rightOperand._mantissa.length - i - 1;
        carry = 0;
        d = rightOperand._mantissa[i];
        if (d == 0)
            continue;
        for (var j = leftOperand._mantissa.length - 1; j >= 0; j--)
        {
            e = leftOperand._mantissa[j] * d + carry;
            if (e >= 10)
            {
                carry = FLOOR(e / 10);
                e = e % 10;
            }
            else
                carry = 0;
            n._mantissa[j + 1] = e;
        }
        n._mantissa[0] = carry;
        CPDecimalCompact(n);
        error1 = CPDecimalAdd(result, result, n, roundingMode, YES);
        if (error1 != CPCalculationNoError)
            error = error1;
    }
    if (result._exponent + exp > CPDecimalMaxExponent)
    {
        result._isNaN = YES;
        return CPCalculationOverflow;
    }
    result._exponent += exp;
    if (result._mantissa.length > CPDecimalMaxDigits && !powerMode)
    {
        result._isCompact = NO;
        var scale = CPDecimalMaxDigits - (result._mantissa.length + result._exponent);
        CPDecimalRound(result, result, scale, roundingMode);
        error = CPCalculationLossOfPrecision;
    }
    return error;
}
CPDecimalMultiply = function(result, leftOperand, rightOperand, roundingMode, powerMode)
{
    var error = CPCalculationNoError,
        exp = leftOperand._exponent + rightOperand._exponent,
        neg = (leftOperand._isNegative != rightOperand._isNegative);
    if (leftOperand._isNaN || rightOperand._isNaN)
    {
        result._isNaN = YES;
        return CPCalculationNoError;
    }
    if (CPDecimalIsZero(rightOperand) || CPDecimalIsZero(leftOperand))
    {
        _CPDecimalSetZero(result);
        return CPCalculationNoError;
    }
    if (exp > CPDecimalMaxExponent)
    {
        result._isNaN = YES;
        if (neg)
            return CPCalculationUnderflow;
        else
            return CPCalculationOverflow;
    }
    var n1 = CPDecimalCopy(leftOperand),
        n2 = CPDecimalCopy(rightOperand);
    n1._exponent = 0;
    n2._exponent = 0;
    n1._isNegative = NO;
    n2._isNegative = NO;
    var comp = 0,
        ll = n1._mantissa.length,
        lr = n2._mantissa.length;
    if (ll == lr)
        comp = CPOrderedSame;
    else if (ll > lr)
        comp = CPOrderedDescending;
    else
        comp = CPOrderedAscending;
    if (comp == CPOrderedDescending)
    {
        error = _SimpleMultiply(result, n1, n2, roundingMode, powerMode);
    }
    else
    {
        error = _SimpleMultiply(result, n2, n1, roundingMode, powerMode);
    }
    CPDecimalCompact(result);
    if (result._exponent + exp > CPDecimalMaxExponent)
    {
        result._isNaN = YES;
        if (neg)
            return CPCalculationUnderflow;
        else
            return CPCalculationOverflow;
    }
    else if (result._exponent + exp < CPDecimalMinExponent)
    {
        CPDecimalRound(result, result, exp + CPDecimalMaxExponent + 1, roundingMode);
        error = CPCalculationLossOfPrecision;
        if (result._exponent + exp < CPDecimalMinExponent)
        {
            _CPDecimalSetZero(result);
            return error;
        }
    }
    result._exponent += exp;
    result._isNegative = neg;
    return error;
}
CPDecimalMultiplyByPowerOf10 = function(result, dcm, power, roundingMode)
{
    _CPDecimalSet(result, dcm);
    var p = result._exponent + power;
    if (p > CPDecimalMaxExponent)
    {
        result._isNaN = YES;
        return CPCalculationOverflow;
    }
    if (p < CPDecimalMinExponent)
    {
        result._isNaN = YES;
        return CPCalculationUnderflow;
    }
    result._exponent += power;
    return CPCalculationNoError;
}
CPDecimalPower = function(result, dcm, power, roundingMode)
{
    var error = CPCalculationNoError,
        neg = (dcm._isNegative && (power % 2)),
        n1 = CPDecimalCopy(dcm);
    n1._isNegative = NO;
    _CPDecimalSetOne(result);
    var e = power;
    while (e)
    {
        if (e & 1)
        {
            error = CPDecimalMultiply(result, result, n1, roundingMode);
        }
        error = CPDecimalMultiply(n1, n1, n1, roundingMode);
        e >>= 1;
        if (error > CPCalculationLossOfPrecision)
            break;
    }
    result._isNegative = neg;
    CPDecimalCompact(result);
    return error;
}
CPDecimalNormalize = function(dcm1, dcm2, roundingMode, longMode)
{
    var factor = (longMode) ? 2 : 1;
    if (dcm1._isNaN || dcm2._isNaN)
        return CPCalculationNoError;
    if (!dcm1._isCompact)
        CPDecimalCompact(dcm1);
    if (!dcm2._isCompact)
        CPDecimalCompact(dcm2);
    if (dcm1._exponent == dcm2._exponent)
        return CPCalculationNoError;
    var e1 = dcm1._exponent,
        e2 = dcm2._exponent;
    var l2 = dcm2._mantissa.length,
        l1 = dcm1._mantissa.length,
        l = 0;
    var e = 0;
    if (e2 > e1 && e1 >= 0 && e2 >= 0)
        e = e2 - e1;
    else if (e2 > e1 && e1 < 0 && e2 >= 0)
        e = e2 - e1;
    else if (e2 > e1 && e1 < 0 && e2 < 0)
        e = e2 - e1;
    else if (e2 < e1 && e1 >= 0 && e2 >= 0)
        e = e1 - e2;
    else if (e2 < e1 && e1 >= 0 && e2 < 0)
        e = e1 - e2;
    else if (e2 < e1 && e1 < 0 && e2 < 0)
        e = e1 - e2;
    if (e2 > e1)
        l = MIN((CPDecimalMaxDigits * factor) - l2, e);
    else
        l = MIN((CPDecimalMaxDigits * factor) - l1, e);
    for (var i = 0; i < l; i++)
    {
        if (e2 > e1)
            Array.prototype.push.call(dcm2._mantissa, 0);
        else
            Array.prototype.push.call(dcm1._mantissa, 0);
    }
    if (e2 > e1)
    {
        dcm2._exponent -= l;
        dcm2._isCompact = NO;
    }
    else
    {
        dcm1._exponent -= l;
        dcm1._isCompact = NO;
    }
    if (l != ABS(e2 - e1))
    {
        if (e2 > e1)
        {
            CPDecimalRound(dcm1, dcm1, -dcm2._exponent, roundingMode);
            l1 = CPDecimalIsZero(dcm1);
        }
        else
        {
            CPDecimalRound(dcm2, dcm2, -dcm1._exponent, roundingMode);
            l2 = CPDecimalIsZero(dcm2);
        }
        if ((dcm1._exponent != dcm2._exponent) && ((!l1) || (!l2)))
        {
            if (e2 > e1)
            {
                l1 = dcm1._mantissa.length;
                l = MIN((CPDecimalMaxDigits * factor) - l1, ABS(dcm1._exponent - dcm2._exponent));
                for (var i = 0; i < l; i++)
                {
                    dcm1._mantissa[i + l1] = 0;
                }
                dcm1._isCompact = NO;
                dcm1._exponent = dcm2._exponent;
            }
            else
            {
                l2 = dcm2._mantissa.length;
                l = MIN((CPDecimalMaxDigits * factor) - l2, ABS(dcm2._exponent - dcm1._exponent));
                for (var i = 0; i < l; i++)
                {
                    dcm2._mantissa[i + l2] = 0;
                }
                dcm2._exponent = dcm1._exponent;
                dcm2._isCompact = NO;
            }
        }
        return CPCalculationLossOfPrecision;
    }
    return CPCalculationNoError;
}
CPDecimalRound = function(result, dcm, scale, roundingMode)
{
    _CPDecimalSet(result, dcm);
    if (dcm._isNaN)
        return;
    if (!dcm._isCompact)
        CPDecimalCompact(dcm);
    if (scale == CPDecimalNoScale)
        return;
    var mc = result._mantissa.length,
        l = mc + scale + result._exponent;
    if (mc <= l)
        return;
    else if (l <= 0)
    {
        _CPDecimalSetZero(result);
        return;
    }
    else
    {
        var c = 0,
            n = 0,
            up = 0;
        result._exponent += mc - l;
        switch (roundingMode)
        {
            case CPRoundDown:
                up = result._isNegative;
                break;
            case CPRoundUp:
                up = !result._isNegative;
                break;
            case CPRoundPlain:
                n = result._mantissa[l];
                up = (n >= 5);
                break;
            case _CPRoundHalfDown:
                n = result._mantissa[l];
                up = (n > 5);
                break;
            case CPRoundBankers:
                n = result._mantissa[l];
                if (n > 5)
                    up = YES;
                else if (n < 5)
                    up = NO;
                else
                {
                    if (l == 0)
                        c = 0;
                    else
                        c = result._mantissa[l - 1];
                    up = ((c % 2) != 0);
                }
                break;
            default:
                up = NO;
                break;
        }
        result._mantissa = Array.prototype.slice.call(result._mantissa, 0, l);
        if (up)
        {
            for (var i = l-1; i >= 0; i--)
            {
                if (result._mantissa[i] != 9)
                {
                    result._mantissa[i]++;
                    break;
                }
                result._mantissa[i] = 0;
            }
            if (i == -1)
            {
                result._mantissa[0] = 1;
                if (result._exponent >= CPDecimalMaxExponent)
                {
                    Array.prototype.push.call(result._mantissa, 0);
                }
                else
                    result._exponent++;
            }
        }
    }
    CPDecimalCompact(result);
}
CPDecimalCompact = function(dcm)
{
    if (!dcm || dcm._mantissa.length == 0 || CPDecimalIsNotANumber(dcm))
        return;
    if (CPDecimalIsZero(dcm))
    {
        _CPDecimalSetZero(dcm);
        return;
    }
    while (dcm._mantissa[0] === 0)
        Array.prototype.shift.call(dcm._mantissa);
    while (dcm._mantissa[dcm._mantissa.length - 1] === 0)
    {
        Array.prototype.pop.call(dcm._mantissa);
        dcm._exponent++;
        if (dcm._exponent + 1 > CPDecimalMaxExponent)
        {
          break;
        }
    }
    dcm._isCompact = YES;
}
CPDecimalString = function(dcm, locale)
{
    if (dcm._isNaN)
        return "NaN";
    var string = "",
        i = 0;
    if (dcm._isNegative)
        string += "-";
    var k = dcm._mantissa.length,
        l = ((dcm._exponent < 0) ? dcm._exponent : 0) + k;
    if (l < 0)
    {
        string += "0.";
        for (i = 0; i < ABS(l); i++)
        {
            string += "0";
        }
        l = k;
    }
    else if (l == 0)
    {
        string += "0";
    }
    for (i = 0; i < l; i++)
    {
        string += dcm._mantissa[i];
    }
    if (l < k)
    {
        string += ".";
        for (i = l; i < k; i++)
        {
            string += dcm._mantissa[i];
        }
    }
    for (i = 0; i < dcm._exponent; i++)
    {
        string += "0";
    }
    return string;
}p;17;CPDecimalNumber.jt;31555;@STATIC;1.0;i;11;CPDecimal.ji;13;CPException.ji;10;CPNumber.ji;10;CPObject.ji;10;CPString.jt;31456;objj_executeFile("CPDecimal.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPNumber.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
var CPDefaultDcmHandler = nil;
{var the_class = objj_allocateClassPair(CPObject, "CPDecimalNumberHandler"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_roundingMode"), new objj_ivar("_scale"), new objj_ivar("_raiseOnExactness"), new objj_ivar("_raiseOnOverflow"), new objj_ivar("_raiseOnUnderflow"), new objj_ivar("_raiseOnDivideByZero")]);


objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPDecimalNumberHandler__init(self, _cmd)
{
    return objj_msgSend(self, "initWithRoundingMode:scale:raiseOnExactness:raiseOnOverflow:raiseOnUnderflow:raiseOnDivideByZero:", CPRoundPlain, 0, NO, YES, YES, YES);
}
,["id"]), new objj_method(sel_getUid("initWithRoundingMode:scale:raiseOnExactness:raiseOnOverflow:raiseOnUnderflow:raiseOnDivideByZero:"), function $CPDecimalNumberHandler__initWithRoundingMode_scale_raiseOnExactness_raiseOnOverflow_raiseOnUnderflow_raiseOnDivideByZero_(self, _cmd, roundingMode, scale, exact, overflow, underflow, divideByZero)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPDecimalNumberHandler").super_class }, "init"))
    {
        self._roundingMode = roundingMode;
        self._scale = scale;
        self._raiseOnExactness = exact;
        self._raiseOnOverflow = overflow;
        self._raiseOnUnderflow = underflow;
        self._raiseOnDivideByZero = divideByZero;
    }
    return self;
}
,["id","CPRoundingMode","short","BOOL","BOOL","BOOL","BOOL"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("decimalNumberHandlerWithRoundingMode:scale:raiseOnExactness:raiseOnOverflow:raiseOnUnderflow:raiseOnDivideByZero:"), function $CPDecimalNumberHandler__decimalNumberHandlerWithRoundingMode_scale_raiseOnExactness_raiseOnOverflow_raiseOnUnderflow_raiseOnDivideByZero_(self, _cmd, roundingMode, scale, exact, overflow, underflow, divideByZero)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithRoundingMode:scale:raiseOnExactness:raiseOnOverflow:raiseOnUnderflow:raiseOnDivideByZero:", roundingMode, scale, exact, overflow, underflow, divideByZero);
}
,["id","CPRoundingMode","short","BOOL","BOOL","BOOL","BOOL"]), new objj_method(sel_getUid("defaultDecimalNumberHandler"), function $CPDecimalNumberHandler__defaultDecimalNumberHandler(self, _cmd)
{
    if (!CPDefaultDcmHandler)
        CPDefaultDcmHandler = objj_msgSend(objj_msgSend(CPDecimalNumberHandler, "alloc"), "init");
    return CPDefaultDcmHandler;
}
,["id"])]);
}
{
var the_class = objj_getClass("CPDecimalNumberHandler")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPDecimalNumberHandler\"");
var meta_class = the_class.isa;

class_addMethods(the_class, [new objj_method(sel_getUid("roundingMode"), function $CPDecimalNumberHandler__roundingMode(self, _cmd)
{
    return self._roundingMode;
}
,["CPRoundingMode"]), new objj_method(sel_getUid("scale"), function $CPDecimalNumberHandler__scale(self, _cmd)
{
    return self._scale;
}
,["short"]), new objj_method(sel_getUid("exceptionDuringOperation:error:leftOperand:rightOperand:"), function $CPDecimalNumberHandler__exceptionDuringOperation_error_leftOperand_rightOperand_(self, _cmd, operation, error, leftOperand, rightOperand)
{
    switch (error)
    {
        case CPCalculationNoError:
            break;
        case CPCalculationOverflow:
            if (self._raiseOnOverflow)
                objj_msgSend(CPException, "raise:reason:", CPDecimalNumberOverflowException, ("A CPDecimalNumber overflow has occurred. (Left operand= '" + objj_msgSend(leftOperand, "descriptionWithLocale:", nil) + "' Right operand= '" + objj_msgSend(rightOperand, "descriptionWithLocale:", nil) + "' Selector= '" + operation + "')"));
            else
                return objj_msgSend(CPDecimalNumber, "notANumber");
            break;
        case CPCalculationUnderflow:
            if (self._raiseOnUnderflow)
                objj_msgSend(CPException, "raise:reason:", CPDecimalNumberUnderflowException, ("A CPDecimalNumber underflow has occurred. (Left operand= '" + objj_msgSend(leftOperand, "descriptionWithLocale:", nil) + "' Right operand= '" + objj_msgSend(rightOperand, "descriptionWithLocale:", nil) + "' Selector= '" + operation + "')"));
            else
                return objj_msgSend(CPDecimalNumber, "notANumber");
            break;
        case CPCalculationLossOfPrecision:
            if (self._raiseOnExactness)
                objj_msgSend(CPException, "raise:reason:", CPDecimalNumberExactnessException, ("A CPDecimalNumber has been rounded off during a calculation. (Left operand= '" + objj_msgSend(leftOperand, "descriptionWithLocale:", nil) + "' Right operand= '" + objj_msgSend(rightOperand, "descriptionWithLocale:", nil) + "' Selector= '" + operation + "')"));
            break;
        case CPCalculationDivideByZero:
            if (self._raiseOnDivideByZero)
                objj_msgSend(CPException, "raise:reason:", CPDecimalNumberDivideByZeroException, ("A CPDecimalNumber divide by zero has occurred. (Left operand= '" + objj_msgSend(leftOperand, "descriptionWithLocale:", nil) + "' Right operand= '" + objj_msgSend(rightOperand, "descriptionWithLocale:", nil) + "' Selector= '" + operation + "')"));
            else
                return objj_msgSend(CPDecimalNumber, "notANumber");
            break;
        default:
            objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, ("An unknown CPDecimalNumber error has occurred. (Left operand= '" + objj_msgSend(leftOperand, "descriptionWithLocale:", nil) + "' Right operand= '" + objj_msgSend(rightOperand, "descriptionWithLocale:", nil) + "' Selector= '" + operation + "')"));
    }
    return nil;
}
,["CPDecimalNumber","SEL","CPCalculationError","CPDecimalNumber","CPDecimalNumber"])]);
}
var CPDecimalNumberHandlerRoundingModeKey = "CPDecimalNumberHandlerRoundingModeKey",
    CPDecimalNumberHandlerScaleKey = "CPDecimalNumberHandlerScaleKey",
    CPDecimalNumberHandlerRaiseOnExactKey = "CPDecimalNumberHandlerRaiseOnExactKey",
    CPDecimalNumberHandlerRaiseOnOverflowKey = "CPDecimalNumberHandlerRaiseOnOverflowKey",
    CPDecimalNumberHandlerRaiseOnUnderflowKey = "CPDecimalNumberHandlerRaiseOnUnderflowKey",
    CPDecimalNumberHandlerDivideByZeroKey = "CPDecimalNumberHandlerDivideByZeroKey";
{
var the_class = objj_getClass("CPDecimalNumberHandler")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPDecimalNumberHandler\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPDecimalNumberHandler__initWithCoder_(self, _cmd, aCoder)
{
    if (self)
    {
        objj_msgSend(self, "initWithRoundingMode:scale:raiseOnExactness:raiseOnOverflow:raiseOnUnderflow:raiseOnDivideByZero:", objj_msgSend(aCoder, "decodeIntForKey:", CPDecimalNumberHandlerRoundingModeKey), objj_msgSend(aCoder, "decodeIntForKey:", CPDecimalNumberHandlerScaleKey), objj_msgSend(aCoder, "decodeBoolForKey:", CPDecimalNumberHandlerRaiseOnExactKey), objj_msgSend(aCoder, "decodeBoolForKey:", CPDecimalNumberHandlerRaiseOnOverflowKey), objj_msgSend(aCoder, "decodeBoolForKey:", CPDecimalNumberHandlerRaiseOnUnderflowKey), objj_msgSend(aCoder, "decodeBoolForKey:", CPDecimalNumberHandlerDivideByZeroKey));
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPDecimalNumberHandler__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeInt:forKey:", objj_msgSend(self, "roundingMode"), CPDecimalNumberHandlerRoundingModeKey);
    objj_msgSend(aCoder, "encodeInt:forKey:", objj_msgSend(self, "scale"), CPDecimalNumberHandlerScaleKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._raiseOnExactness, CPDecimalNumberHandlerRaiseOnExactKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._raiseOnOverflow, CPDecimalNumberHandlerRaiseOnOverflowKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._raiseOnUnderflow, CPDecimalNumberHandlerRaiseOnUnderflowKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._raiseOnDivideByZero, CPDecimalNumberHandlerDivideByZeroKey);
}
,["void","CPCoder"])]);
}
{var the_class = objj_allocateClassPair(CPNumber, "CPDecimalNumber"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_data")]);










































































objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPDecimalNumber__init(self, _cmd)
{
    return objj_msgSend(self, "initWithDecimal:", CPDecimalMakeNaN());
}
,["id"]), new objj_method(sel_getUid("initWithDecimal:"), function $CPDecimalNumber__initWithDecimal_(self, _cmd, dcm)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPDecimalNumber").super_class }, "init"))
        self._data = CPDecimalCopy(dcm);
    return self;
}
,["id","CPDecimal"]), new objj_method(sel_getUid("initWithMantissa:exponent:isNegative:"), function $CPDecimalNumber__initWithMantissa_exponent_isNegative_(self, _cmd, mantissa, exponent, flag)
{
    if (self = objj_msgSend(self, "init"))
    {
        if (flag)
            mantissa *= -1;
        self._data = CPDecimalMakeWithParts(mantissa, exponent);
    }
    return self;
}
,["id","unsigned long long","short","BOOL"]), new objj_method(sel_getUid("initWithString:"), function $CPDecimalNumber__initWithString_(self, _cmd, numberValue)
{
    return objj_msgSend(self, "initWithString:locale:", numberValue, nil);
}
,["id","CPString"]), new objj_method(sel_getUid("initWithString:locale:"), function $CPDecimalNumber__initWithString_locale_(self, _cmd, numberValue, locale)
{
    if (self = objj_msgSend(self, "init"))
    {
        self._data = CPDecimalMakeWithString(numberValue, locale);
    }
    return self;
}
,["id","CPString","CPDictionary"]), new objj_method(sel_getUid("decimalNumberByAdding:"), function $CPDecimalNumber__decimalNumberByAdding_(self, _cmd, decimalNumber)
{
    return objj_msgSend(self, "decimalNumberByAdding:withBehavior:", decimalNumber, objj_msgSend(CPDecimalNumber, "defaultBehavior"));
}
,["CPDecimalNumber","CPDecimalNumber"]), new objj_method(sel_getUid("decimalNumberByAdding:withBehavior:"), function $CPDecimalNumber__decimalNumberByAdding_withBehavior_(self, _cmd, decimalNumber, behavior)
{
    var result = CPDecimalMakeZero(),
        error = CPDecimalAdd(result, objj_msgSend(self, "decimalValue"), objj_msgSend(decimalNumber, "decimalValue"), objj_msgSend(behavior, "roundingMode"));
    if (error > CPCalculationNoError)
    {
        var res = objj_msgSend(behavior, "exceptionDuringOperation:error:leftOperand:rightOperand:", _cmd, error, self, decimalNumber);
        if (res != nil)
            return res;
    }
    return objj_msgSend(CPDecimalNumber, "decimalNumberWithDecimal:", result);
}
,["CPDecimalNumber","CPDecimalNumber","id"]), new objj_method(sel_getUid("decimalNumberBySubtracting:"), function $CPDecimalNumber__decimalNumberBySubtracting_(self, _cmd, decimalNumber)
{
    return objj_msgSend(self, "decimalNumberBySubtracting:withBehavior:", decimalNumber, objj_msgSend(CPDecimalNumber, "defaultBehavior"));
}
,["CPDecimalNumber","CPDecimalNumber"]), new objj_method(sel_getUid("decimalNumberBySubtracting:withBehavior:"), function $CPDecimalNumber__decimalNumberBySubtracting_withBehavior_(self, _cmd, decimalNumber, behavior)
{
    var result = CPDecimalMakeZero(),
        error = CPDecimalSubtract(result, objj_msgSend(self, "decimalValue"), objj_msgSend(decimalNumber, "decimalValue"), objj_msgSend(behavior, "roundingMode"));
    if (error > CPCalculationNoError)
    {
        var res = objj_msgSend(behavior, "exceptionDuringOperation:error:leftOperand:rightOperand:", _cmd, error, self, decimalNumber);
        if (res != nil)
            return res;
    }
    return objj_msgSend(CPDecimalNumber, "decimalNumberWithDecimal:", result);
}
,["CPDecimalNumber","CPDecimalNumber","id"]), new objj_method(sel_getUid("decimalNumberByDividingBy:"), function $CPDecimalNumber__decimalNumberByDividingBy_(self, _cmd, decimalNumber)
{
    return objj_msgSend(self, "decimalNumberByDividingBy:withBehavior:", decimalNumber, objj_msgSend(CPDecimalNumber, "defaultBehavior"));
}
,["CPDecimalNumber","CPDecimalNumber"]), new objj_method(sel_getUid("decimalNumberByDividingBy:withBehavior:"), function $CPDecimalNumber__decimalNumberByDividingBy_withBehavior_(self, _cmd, decimalNumber, behavior)
{
    var result = CPDecimalMakeZero(),
        error = CPDecimalDivide(result, objj_msgSend(self, "decimalValue"), objj_msgSend(decimalNumber, "decimalValue"), objj_msgSend(behavior, "roundingMode"));
    if (error > CPCalculationNoError)
    {
        var res = objj_msgSend(behavior, "exceptionDuringOperation:error:leftOperand:rightOperand:", _cmd, error, self, decimalNumber);
        if (res != nil)
            return res;
    }
    return objj_msgSend(CPDecimalNumber, "decimalNumberWithDecimal:", result);
}
,["CPDecimalNumber","CPDecimalNumber","id"]), new objj_method(sel_getUid("decimalNumberByMultiplyingBy:"), function $CPDecimalNumber__decimalNumberByMultiplyingBy_(self, _cmd, decimalNumber)
{
    return objj_msgSend(self, "decimalNumberByMultiplyingBy:withBehavior:", decimalNumber, objj_msgSend(CPDecimalNumber, "defaultBehavior"));
}
,["CPDecimalNumber","CPDecimalNumber"]), new objj_method(sel_getUid("decimalNumberByMultiplyingBy:withBehavior:"), function $CPDecimalNumber__decimalNumberByMultiplyingBy_withBehavior_(self, _cmd, decimalNumber, behavior)
{
    var result = CPDecimalMakeZero(),
        error = CPDecimalMultiply(result, objj_msgSend(self, "decimalValue"), objj_msgSend(decimalNumber, "decimalValue"), objj_msgSend(behavior, "roundingMode"));
    if (error > CPCalculationNoError)
    {
        var res = objj_msgSend(behavior, "exceptionDuringOperation:error:leftOperand:rightOperand:", _cmd, error, self, decimalNumber);
        if (res != nil)
            return res;
    }
    return objj_msgSend(CPDecimalNumber, "decimalNumberWithDecimal:", result);
}
,["CPDecimalNumber","CPDecimalNumber","id"]), new objj_method(sel_getUid("decimalNumberByMultiplyingByPowerOf10:"), function $CPDecimalNumber__decimalNumberByMultiplyingByPowerOf10_(self, _cmd, power)
{
    return objj_msgSend(self, "decimalNumberByMultiplyingByPowerOf10:withBehavior:", power, objj_msgSend(CPDecimalNumber, "defaultBehavior"));
}
,["CPDecimalNumber","short"]), new objj_method(sel_getUid("decimalNumberByMultiplyingByPowerOf10:withBehavior:"), function $CPDecimalNumber__decimalNumberByMultiplyingByPowerOf10_withBehavior_(self, _cmd, power, behavior)
{
    var result = CPDecimalMakeZero(),
        error = CPDecimalMultiplyByPowerOf10(result, objj_msgSend(self, "decimalValue"), power, objj_msgSend(behavior, "roundingMode"));
    if (error > CPCalculationNoError)
    {
        var res = objj_msgSend(behavior, "exceptionDuringOperation:error:leftOperand:rightOperand:", _cmd, error, self, objj_msgSend(CPDecimalNumber, "decimalNumberWithString:", power.toString()));
        if (res != nil)
            return res;
    }
    return objj_msgSend(CPDecimalNumber, "decimalNumberWithDecimal:", result);
}
,["CPDecimalNumber","short","id"]), new objj_method(sel_getUid("decimalNumberByRaisingToPower:"), function $CPDecimalNumber__decimalNumberByRaisingToPower_(self, _cmd, power)
{
    return objj_msgSend(self, "decimalNumberByRaisingToPower:withBehavior:", power, objj_msgSend(CPDecimalNumber, "defaultBehavior"));
}
,["CPDecimalNumber","unsigned"]), new objj_method(sel_getUid("decimalNumberByRaisingToPower:withBehavior:"), function $CPDecimalNumber__decimalNumberByRaisingToPower_withBehavior_(self, _cmd, power, behavior)
{
    if (power < 0)
        return objj_msgSend(behavior, "exceptionDuringOperation:error:leftOperand:rightOperand:", _cmd, -1, self, objj_msgSend(CPDecimalNumber, "decimalNumberWithString:", power.toString()));
    var result = CPDecimalMakeZero(),
        error = CPDecimalPower(result, objj_msgSend(self, "decimalValue"), power, objj_msgSend(behavior, "roundingMode"));
    if (error > CPCalculationNoError)
    {
        var res = objj_msgSend(behavior, "exceptionDuringOperation:error:leftOperand:rightOperand:", _cmd, error, self, objj_msgSend(CPDecimalNumber, "decimalNumberWithString:", power.toString()));
        if (res != nil)
            return res;
    }
    return objj_msgSend(CPDecimalNumber, "decimalNumberWithDecimal:", result);
}
,["CPDecimalNumber","unsigned","id"]), new objj_method(sel_getUid("decimalNumberByRoundingAccordingToBehavior:"), function $CPDecimalNumber__decimalNumberByRoundingAccordingToBehavior_(self, _cmd, behavior)
{
    var result = CPDecimalMakeZero();
    CPDecimalRound(result, objj_msgSend(self, "decimalValue"), objj_msgSend(behavior, "scale"), objj_msgSend(behavior, "roundingMode"));
    return objj_msgSend(CPDecimalNumber, "decimalNumberWithDecimal:", result);
}
,["CPDecimalNumber","id"]), new objj_method(sel_getUid("compare:"), function $CPDecimalNumber__compare_(self, _cmd, aNumber)
{
    if (!objj_msgSend(aNumber, "isKindOfClass:", objj_msgSend(CPDecimalNumber, "class")))
        aNumber = objj_msgSend(CPDecimalNumber, "decimalNumberWithString:", aNumber.toString());
    return CPDecimalCompare(objj_msgSend(self, "decimalValue"), objj_msgSend(aNumber, "decimalValue"));
}
,["CPComparisonResult","CPNumber"]), new objj_method(sel_getUid("objCType"), function $CPDecimalNumber__objCType(self, _cmd)
{
    return "d";
}
,["CPString"]), new objj_method(sel_getUid("description"), function $CPDecimalNumber__description(self, _cmd)
{
    return objj_msgSend(self, "descriptionWithLocale:", nil)
}
,["CPString"]), new objj_method(sel_getUid("descriptionWithLocale:"), function $CPDecimalNumber__descriptionWithLocale_(self, _cmd, locale)
{
    return CPDecimalString(self._data, locale);
}
,["CPString","CPDictionary"]), new objj_method(sel_getUid("stringValue"), function $CPDecimalNumber__stringValue(self, _cmd)
{
    return objj_msgSend(self, "description");
}
,["CPString"]), new objj_method(sel_getUid("decimalValue"), function $CPDecimalNumber__decimalValue(self, _cmd)
{
    return CPDecimalCopy(self._data);
}
,["CPDecimal"]), new objj_method(sel_getUid("doubleValue"), function $CPDecimalNumber__doubleValue(self, _cmd)
{
    return parseFloat(objj_msgSend(self, "stringValue"));
}
,["double"]), new objj_method(sel_getUid("boolValue"), function $CPDecimalNumber__boolValue(self, _cmd)
{
    return (CPDecimalIsZero(self._data))?NO:YES;
}
,["BOOL"]), new objj_method(sel_getUid("charValue"), function $CPDecimalNumber__charValue(self, _cmd)
{
    return parseInt(objj_msgSend(self, "stringValue"));
}
,["char"]), new objj_method(sel_getUid("floatValue"), function $CPDecimalNumber__floatValue(self, _cmd)
{
    return parseFloat(objj_msgSend(self, "stringValue"));
}
,["float"]), new objj_method(sel_getUid("intValue"), function $CPDecimalNumber__intValue(self, _cmd)
{
    return parseInt(objj_msgSend(self, "stringValue"));
}
,["int"]), new objj_method(sel_getUid("longLongValue"), function $CPDecimalNumber__longLongValue(self, _cmd)
{
    return parseInt(objj_msgSend(self, "stringValue"));
}
,["long long"]), new objj_method(sel_getUid("longValue"), function $CPDecimalNumber__longValue(self, _cmd)
{
    return parseInt(objj_msgSend(self, "stringValue"));
}
,["long"]), new objj_method(sel_getUid("shortValue"), function $CPDecimalNumber__shortValue(self, _cmd)
{
    return parseInt(objj_msgSend(self, "stringValue"));
}
,["short"]), new objj_method(sel_getUid("unsignedCharValue"), function $CPDecimalNumber__unsignedCharValue(self, _cmd)
{
    return parseInt(objj_msgSend(self, "stringValue"));
}
,["unsigned char"]), new objj_method(sel_getUid("unsignedIntValue"), function $CPDecimalNumber__unsignedIntValue(self, _cmd)
{
    return parseInt(objj_msgSend(self, "stringValue"));
}
,["unsigned int"]), new objj_method(sel_getUid("unsignedLongValue"), function $CPDecimalNumber__unsignedLongValue(self, _cmd)
{
    return parseInt(objj_msgSend(self, "stringValue"));
}
,["unsigned long"]), new objj_method(sel_getUid("unsignedShortValue"), function $CPDecimalNumber__unsignedShortValue(self, _cmd)
{
    return parseInt(objj_msgSend(self, "stringValue"));
}
,["unsigned short"]), new objj_method(sel_getUid("isEqualToNumber:"), function $CPDecimalNumber__isEqualToNumber_(self, _cmd, aNumber)
{
    return (CPDecimalCompare(CPDecimalMakeWithString(aNumber.toString(),nil), self._data) == CPOrderedSame)?YES:NO;
}
,["BOOL","CPNumber"]), new objj_method(sel_getUid("initWithBool:"), function $CPDecimalNumber__initWithBool_(self, _cmd, value)
{
    if (self = objj_msgSend(self, "init"))
        self._data = CPDecimalMakeWithParts((value)?1:0, 0);
    return self;
}
,["id","BOOL"]), new objj_method(sel_getUid("initWithChar:"), function $CPDecimalNumber__initWithChar_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","char"]), new objj_method(sel_getUid("initWithDouble:"), function $CPDecimalNumber__initWithDouble_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","double"]), new objj_method(sel_getUid("initWithFloat:"), function $CPDecimalNumber__initWithFloat_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","float"]), new objj_method(sel_getUid("initWithInt:"), function $CPDecimalNumber__initWithInt_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","int"]), new objj_method(sel_getUid("initWithLong:"), function $CPDecimalNumber__initWithLong_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","long"]), new objj_method(sel_getUid("initWithLongLong:"), function $CPDecimalNumber__initWithLongLong_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","long long"]), new objj_method(sel_getUid("initWithShort:"), function $CPDecimalNumber__initWithShort_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","short"]), new objj_method(sel_getUid("initWithUnsignedChar:"), function $CPDecimalNumber__initWithUnsignedChar_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","unsigned char"]), new objj_method(sel_getUid("initWithUnsignedInt:"), function $CPDecimalNumber__initWithUnsignedInt_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","unsigned"]), new objj_method(sel_getUid("initWithUnsignedLong:"), function $CPDecimalNumber__initWithUnsignedLong_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","unsigned long"]), new objj_method(sel_getUid("initWithUnsignedLongLong:"), function $CPDecimalNumber__initWithUnsignedLongLong_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","unsigned long long"]), new objj_method(sel_getUid("initWithUnsignedShort:"), function $CPDecimalNumber__initWithUnsignedShort_(self, _cmd, value)
{
    return objj_msgSend(self, "_initWithJSNumber:", value);
}
,["id","unsigned short"]), new objj_method(sel_getUid("_initWithJSNumber:"), function $CPDecimalNumber___initWithJSNumber_(self, _cmd, value)
{
    if (self = objj_msgSend(self, "init"))
        self._data = CPDecimalMakeWithString(value.toString(), nil);
    return self;
}
,["id",null])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $CPDecimalNumber__alloc(self, _cmd)
{
    return class_createInstance(self);
}
,["id"]), new objj_method(sel_getUid("decimalNumberWithDecimal:"), function $CPDecimalNumber__decimalNumberWithDecimal_(self, _cmd, dcm)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithDecimal:", dcm);
}
,["CPDecimalNumber","CPDecimal"]), new objj_method(sel_getUid("decimalNumberWithMantissa:exponent:isNegative:"), function $CPDecimalNumber__decimalNumberWithMantissa_exponent_isNegative_(self, _cmd, mantissa, exponent, flag)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithMantissa:exponent:isNegative:", mantissa, exponent, flag);
}
,["CPDecimalNumber","unsigned long long","short","BOOL"]), new objj_method(sel_getUid("decimalNumberWithString:"), function $CPDecimalNumber__decimalNumberWithString_(self, _cmd, numberValue)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithString:", numberValue);
}
,["CPDecimalNumber","CPString"]), new objj_method(sel_getUid("decimalNumberWithString:locale:"), function $CPDecimalNumber__decimalNumberWithString_locale_(self, _cmd, numberValue, locale)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithString:locale:", numberValue, locale);
}
,["CPDecimalNumber","CPString","CPDictionary"]), new objj_method(sel_getUid("defaultBehavior"), function $CPDecimalNumber__defaultBehavior(self, _cmd)
{
    return objj_msgSend(CPDecimalNumberHandler, "defaultDecimalNumberHandler");
}
,["id"]), new objj_method(sel_getUid("setDefaultBehavior:"), function $CPDecimalNumber__setDefaultBehavior_(self, _cmd, behavior)
{
    CPDefaultDcmHandler = behavior;
}
,["void","id"]), new objj_method(sel_getUid("maximumDecimalNumber"), function $CPDecimalNumber__maximumDecimalNumber(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithDecimal:", _CPDecimalMakeMaximum());
}
,["CPDecimalNumber"]), new objj_method(sel_getUid("minimumDecimalNumber"), function $CPDecimalNumber__minimumDecimalNumber(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithDecimal:", _CPDecimalMakeMinimum());
}
,["CPDecimalNumber"]), new objj_method(sel_getUid("notANumber"), function $CPDecimalNumber__notANumber(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithDecimal:", CPDecimalMakeNaN());
}
,["CPDecimalNumber"]), new objj_method(sel_getUid("zero"), function $CPDecimalNumber__zero(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithDecimal:", CPDecimalMakeZero());
}
,["CPDecimalNumber"]), new objj_method(sel_getUid("one"), function $CPDecimalNumber__one(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithDecimal:", CPDecimalMakeOne());
}
,["CPDecimalNumber"]), new objj_method(sel_getUid("numberWithBool:"), function $CPDecimalNumber__numberWithBool_(self, _cmd, aBoolean)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithBool:", aBoolean);
}
,["id","BOOL"]), new objj_method(sel_getUid("numberWithChar:"), function $CPDecimalNumber__numberWithChar_(self, _cmd, aChar)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithChar:", aChar);
}
,["id","char"]), new objj_method(sel_getUid("numberWithDouble:"), function $CPDecimalNumber__numberWithDouble_(self, _cmd, aDouble)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithDouble:", aDouble);
}
,["id","double"]), new objj_method(sel_getUid("numberWithFloat:"), function $CPDecimalNumber__numberWithFloat_(self, _cmd, aFloat)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithFloat:", aFloat);
}
,["id","float"]), new objj_method(sel_getUid("numberWithInt:"), function $CPDecimalNumber__numberWithInt_(self, _cmd, anInt)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithInt:", anInt);
}
,["id","int"]), new objj_method(sel_getUid("numberWithLong:"), function $CPDecimalNumber__numberWithLong_(self, _cmd, aLong)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithLong:", aLong);
}
,["id","long"]), new objj_method(sel_getUid("numberWithLongLong:"), function $CPDecimalNumber__numberWithLongLong_(self, _cmd, aLongLong)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithLongLong:", aLongLong);
}
,["id","long long"]), new objj_method(sel_getUid("numberWithShort:"), function $CPDecimalNumber__numberWithShort_(self, _cmd, aShort)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithShort:", aShort);
}
,["id","short"]), new objj_method(sel_getUid("numberWithUnsignedChar:"), function $CPDecimalNumber__numberWithUnsignedChar_(self, _cmd, aChar)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithUnsignedChar:", aChar);
}
,["id","unsigned char"]), new objj_method(sel_getUid("numberWithUnsignedInt:"), function $CPDecimalNumber__numberWithUnsignedInt_(self, _cmd, anUnsignedInt)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithUnsignedInt:", anUnsignedInt);
}
,["id","unsigned"]), new objj_method(sel_getUid("numberWithUnsignedLong:"), function $CPDecimalNumber__numberWithUnsignedLong_(self, _cmd, anUnsignedLong)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithUnsignedLong:", anUnsignedLong);
}
,["id","unsigned long"]), new objj_method(sel_getUid("numberWithUnsignedLongLong:"), function $CPDecimalNumber__numberWithUnsignedLongLong_(self, _cmd, anUnsignedLongLong)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithUnsignedLongLong:", anUnsignedLongLong);
}
,["id","unsigned long"]), new objj_method(sel_getUid("numberWithUnsignedShort:"), function $CPDecimalNumber__numberWithUnsignedShort_(self, _cmd, anUnsignedShort)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithUnsignedShort:", anUnsignedShort);
}
,["id","unsigned short"])]);
}
var CPDecimalNumberDecimalExponent = "CPDecimalNumberDecimalExponent",
    CPDecimalNumberDecimalIsNegative = "CPDecimalNumberDecimalIsNegative",
    CPDecimalNumberDecimalIsCompact = "CPDecimalNumberDecimalIsCompact",
    CPDecimalNumberDecimalIsNaN = "CPDecimalNumberDecimalIsNaN",
    CPDecimalNumberDecimalMantissa = "CPDecimalNumberDecimalMantissa";
{
var the_class = objj_getClass("CPDecimalNumber")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPDecimalNumber\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPDecimalNumber__initWithCoder_(self, _cmd, aCoder)
{
    if (self)
    {
        var dcm = CPDecimalMakeZero();
        dcm._exponent = objj_msgSend(aCoder, "decodeIntForKey:", CPDecimalNumberDecimalExponent);
        dcm._isNegative = objj_msgSend(aCoder, "decodeBoolForKey:", CPDecimalNumberDecimalIsNegative);
        dcm._isCompact = objj_msgSend(aCoder, "decodeBoolForKey:", CPDecimalNumberDecimalIsCompact);
        dcm._isNaN = objj_msgSend(aCoder, "decodeBoolForKey:", CPDecimalNumberDecimalIsNaN);
        dcm._mantissa = objj_msgSend(aCoder, "decodeObjectForKey:", CPDecimalNumberDecimalMantissa);
        objj_msgSend(self, "initWithDecimal:", dcm);
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPDecimalNumber__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeInt:forKey:", self._data._exponent, CPDecimalNumberDecimalExponent);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._data._isNegative, CPDecimalNumberDecimalIsNegative);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._data._isCompact, CPDecimalNumberDecimalIsCompact);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._data._isNaN, CPDecimalNumberDecimalIsNaN);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._data._mantissa, CPDecimalNumberDecimalMantissa);
}
,["void","CPCoder"])]);
}p;14;CPDictionary.jt;16096;@STATIC;1.0;i;9;CPArray.ji;14;CPEnumerator.ji;13;CPException.ji;8;CPNull.ji;10;CPObject.jt;15999;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPEnumerator.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPNull.j", YES);
objj_executeFile("CPObject.j", YES);
{var the_class = objj_allocateClassPair(CPEnumerator, "_CPDictionaryValueEnumerator"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_keyEnumerator"), new objj_ivar("_dictionary")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithDictionary:"), function $_CPDictionaryValueEnumerator__initWithDictionary_(self, _cmd, aDictionary)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPDictionaryValueEnumerator").super_class }, "init");
    if (self)
    {
        self._keyEnumerator = objj_msgSend(aDictionary, "keyEnumerator");
        self._dictionary = aDictionary;
    }
    return self;
}
,["id","CPDictionary"]), new objj_method(sel_getUid("nextObject"), function $_CPDictionaryValueEnumerator__nextObject(self, _cmd)
{
    var key = objj_msgSend(self._keyEnumerator, "nextObject");
    if (key === nil)
        return nil;
    return objj_msgSend(self._dictionary, "objectForKey:", key);
}
,["id"])]);
}
{var the_class = objj_allocateClassPair(CPObject, "CPDictionary"),
meta_class = the_class.isa;
































objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithDictionary:"), function $CPDictionary__initWithDictionary_(self, _cmd, aDictionary)
{
    var key = "",
        dictionary = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    for (key in aDictionary._buckets)
        objj_msgSend(dictionary, "setObject:forKey:", objj_msgSend(aDictionary, "objectForKey:", key), key);
    return dictionary;
}
,["id","CPDictionary"]), new objj_method(sel_getUid("initWithObjects:forKeys:"), function $CPDictionary__initWithObjects_forKeys_(self, _cmd, objects, keyArray)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPDictionary").super_class }, "init");
    if (objj_msgSend(objects, "count") != objj_msgSend(keyArray, "count"))
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "Counts are different.(" + objj_msgSend(objects, "count") + "!=" + objj_msgSend(keyArray, "count") + ")");
    if (self)
    {
        var i = objj_msgSend(keyArray, "count");
        while (i--)
            objj_msgSend(self, "setObject:forKey:", objects[i], keyArray[i]);
    }
    return self;
}
,["id","CPArray","CPArray"]), new objj_method(sel_getUid("initWithObjectsAndKeys:"), function $CPDictionary__initWithObjectsAndKeys_(self, _cmd, firstObject)
{
    var argCount = arguments.length;
    if (argCount % 2 !== 0)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "Key-value count is mismatched. (" + argCount + " arguments passed)");
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPDictionary").super_class }, "init");
    if (self)
    {
        var index = 2;
        for (; index < argCount; index += 2)
        {
            var value = arguments[index];
            if (value === nil)
                continue;
            objj_msgSend(self, "setObject:forKey:", value, arguments[index + 1]);
        }
    }
    return self;
}
,["id","id"]), new objj_method(sel_getUid("copy"), function $CPDictionary__copy(self, _cmd)
{
    return objj_msgSend(CPDictionary, "dictionaryWithDictionary:", self);
}
,["CPDictionary"]), new objj_method(sel_getUid("count"), function $CPDictionary__count(self, _cmd)
{
    return self._count;
}
,["int"]), new objj_method(sel_getUid("allKeys"), function $CPDictionary__allKeys(self, _cmd)
{
    return objj_msgSend(self._keys, "copy");
}
,["CPArray"]), new objj_method(sel_getUid("allValues"), function $CPDictionary__allValues(self, _cmd)
{
    var keys = self._keys,
        index = keys.length,
        values = [];
    while (index--)
        values.push(self.valueForKey(keys[index]));
    return values;
}
,["CPArray"]), new objj_method(sel_getUid("allKeysForObject:"), function $CPDictionary__allKeysForObject_(self, _cmd, anObject)
{
    var keys = self._keys,
        count = keys.length,
        index = 0,
        matchingKeys = [],
        key = nil,
        value = nil;
    for (; index < count; ++index)
    {
        key = keys[index];
        value = self._buckets[key];
        if (value.isa && anObject && anObject.isa && objj_msgSend(value, "respondsToSelector:", sel_getUid("isEqual:")) && objj_msgSend(value, "isEqual:", anObject))
            matchingKeys.push(key);
        else if (value === anObject)
            matchingKeys.push(key);
    }
    return matchingKeys;
}
,["CPArray","id"]), new objj_method(sel_getUid("keysOfEntriesPassingTest:"), function $CPDictionary__keysOfEntriesPassingTest_(self, _cmd, predicate)
{
    return objj_msgSend(self, "keysOfEntriesWithOptions:passingTest:", CPEnumerationNormal, predicate);
}
,["CPArray","Function"]), new objj_method(sel_getUid("keysOfEntriesWithOptions:passingTest:"), function $CPDictionary__keysOfEntriesWithOptions_passingTest_(self, _cmd, options, predicate)
{
    var keys = self._keys;
    if (options & CPEnumerationReverse)
    {
        var index = objj_msgSend(keys, "count") - 1,
            stop = -1,
            increment = -1;
    }
    else
    {
        var index = 0,
            stop = objj_msgSend(keys, "count"),
            increment = 1;
    }
    var matchingKeys = [],
        key = nil,
        value = nil,
        shouldStop = NO,
        stopRef = function(__input) { if (arguments.length) return shouldStop = __input; return shouldStop; };
    for (; index !== stop; index += increment)
    {
        key = keys[index];
        value = self._buckets[key];
        if (predicate(key, value, stopRef))
            matchingKeys.push(key);
        if (shouldStop)
            break;
    }
    return matchingKeys;
}
,["CPArray","CPEnumerationOptions","Function"]), new objj_method(sel_getUid("keysSortedByValueUsingComparator:"), function $CPDictionary__keysSortedByValueUsingComparator_(self, _cmd, comparator)
{
    return objj_msgSend(objj_msgSend(self, "allKeys"), "sortedArrayUsingFunction:", function(a, b)
        {
            a = objj_msgSend(self, "objectForKey:", a);
            b = objj_msgSend(self, "objectForKey:", b);
            return comparator(a, b);
        });
}
,["CPArray","Function"]), new objj_method(sel_getUid("keysSortedByValueUsingSelector:"), function $CPDictionary__keysSortedByValueUsingSelector_(self, _cmd, theSelector)
{
    return objj_msgSend(objj_msgSend(self, "allKeys"), "sortedArrayUsingFunction:", function(a, b)
        {
            a = objj_msgSend(self, "objectForKey:", a);
            b = objj_msgSend(self, "objectForKey:", b);
            return objj_msgSend(a, "performSelector:withObject:", theSelector, b);
        });
}
,["CPArray","SEL"]), new objj_method(sel_getUid("keyEnumerator"), function $CPDictionary__keyEnumerator(self, _cmd)
{
    return objj_msgSend(self._keys, "objectEnumerator");
}
,["CPEnumerator"]), new objj_method(sel_getUid("objectEnumerator"), function $CPDictionary__objectEnumerator(self, _cmd)
{
    return objj_msgSend(objj_msgSend(_CPDictionaryValueEnumerator, "alloc"), "initWithDictionary:", self);
}
,["CPEnumerator"]), new objj_method(sel_getUid("isEqualToDictionary:"), function $CPDictionary__isEqualToDictionary_(self, _cmd, aDictionary)
{
    if (self === aDictionary)
        return YES;
    var count = objj_msgSend(self, "count");
    if (count !== objj_msgSend(aDictionary, "count"))
        return NO;
    var index = count,
        keys = self._keys;
    while (index--)
    {
        var currentKey = keys[index],
            lhsObject = self._buckets[currentKey],
            rhsObject = aDictionary._buckets[currentKey];
        if (lhsObject === rhsObject)
            continue;
        if (lhsObject && lhsObject.isa && rhsObject && rhsObject.isa && objj_msgSend(lhsObject, "respondsToSelector:", sel_getUid("isEqual:")) && objj_msgSend(lhsObject, "isEqual:", rhsObject))
            continue;
        return NO;
    }
    return YES;
}
,["BOOL","CPDictionary"]), new objj_method(sel_getUid("isEqual:"), function $CPDictionary__isEqual_(self, _cmd, anObject)
{
    if (self === anObject)
        return YES;
    if (!objj_msgSend(anObject, "isKindOfClass:", objj_msgSend(CPDictionary, "class")))
        return NO;
    return objj_msgSend(self, "isEqualToDictionary:", anObject);
}
,["BOOL","id"]), new objj_method(sel_getUid("objectForKey:"), function $CPDictionary__objectForKey_(self, _cmd, aKey)
{
    var object = self._buckets[aKey];
    return (object === undefined) ? nil : object;
}
,["id","id"]), new objj_method(sel_getUid("removeAllObjects"), function $CPDictionary__removeAllObjects(self, _cmd)
{
    self.removeAllValues();
}
,["void"]), new objj_method(sel_getUid("removeObjectForKey:"), function $CPDictionary__removeObjectForKey_(self, _cmd, aKey)
{
    self.removeValueForKey(aKey);
}
,["void","id"]), new objj_method(sel_getUid("removeObjectsForKeys:"), function $CPDictionary__removeObjectsForKeys_(self, _cmd, keysForRemoval)
{
    var index = keysForRemoval.length;
    while (index--)
        objj_msgSend(self, "removeObjectForKey:", keysForRemoval[index]);
}
,["void","CPArray"]), new objj_method(sel_getUid("setObject:forKey:"), function $CPDictionary__setObject_forKey_(self, _cmd, anObject, aKey)
{
    self.setValueForKey(aKey, anObject);
}
,["void","id","id"]), new objj_method(sel_getUid("addEntriesFromDictionary:"), function $CPDictionary__addEntriesFromDictionary_(self, _cmd, aDictionary)
{
    if (!aDictionary)
        return;
    var keys = objj_msgSend(aDictionary, "allKeys"),
        index = objj_msgSend(keys, "count");
    while (index--)
    {
        var key = keys[index];
        objj_msgSend(self, "setObject:forKey:", objj_msgSend(aDictionary, "objectForKey:", key), key);
    }
}
,["void","CPDictionary"]), new objj_method(sel_getUid("description"), function $CPDictionary__description(self, _cmd)
{
    var string = "@{",
        keys = self._keys,
        index = 0,
        count = self._count;
    for (; index < count; ++index)
    {
        if (index === 0)
            string += "\n";
        var key = keys[index],
            value = self.valueForKey(key);
        string += "    @\"" + key + "\": " + CPDescriptionOfObject(value).split("\n").join("\n    ") + (index + 1 < count ? "," : "") + "\n";
    }
    return string + "}";
}
,["CPString"]), new objj_method(sel_getUid("containsKey:"), function $CPDictionary__containsKey_(self, _cmd, aKey)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    return ((value !== nil) && (value !== undefined));
}
,["BOOL","id"]), new objj_method(sel_getUid("enumerateKeysAndObjectsUsingBlock:"), function $CPDictionary__enumerateKeysAndObjectsUsingBlock_(self, _cmd, aFunction)
{
    var shouldStop = NO,
        shouldStopRef = function(__input) { if (arguments.length) return shouldStop = __input; return shouldStop; },
        keys = self._keys,
        count = self._count;
    for (var index = 0; index < count; index++)
    {
        var key = keys[index],
            value = self.valueForKey(key);
        aFunction(key, value, shouldStopRef);
        if (shouldStop)
            return;
    }
}
,["void","Function"]), new objj_method(sel_getUid("enumerateKeysAndObjectsWithOptions:usingBlock:"), function $CPDictionary__enumerateKeysAndObjectsWithOptions_usingBlock_(self, _cmd, opts, aFunction)
{
    objj_msgSend(self, "enumerateKeysAndObjectsUsingBlock:", aFunction);
}
,["void","CPEnumerationOptions","Function"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $CPDictionary__alloc(self, _cmd)
{
    var result = new CFMutableDictionary();
    result.isa = objj_msgSend(self, "class");
    return result;
}
,["id"]), new objj_method(sel_getUid("dictionary"), function $CPDictionary__dictionary(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "init");
}
,["id"]), new objj_method(sel_getUid("dictionaryWithDictionary:"), function $CPDictionary__dictionaryWithDictionary_(self, _cmd, aDictionary)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithDictionary:", aDictionary);
}
,["id","CPDictionary"]), new objj_method(sel_getUid("dictionaryWithObject:forKey:"), function $CPDictionary__dictionaryWithObject_forKey_(self, _cmd, anObject, aKey)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithObjects:forKeys:", [anObject], [aKey]);
}
,["id","id","id"]), new objj_method(sel_getUid("dictionaryWithObjects:forKeys:"), function $CPDictionary__dictionaryWithObjects_forKeys_(self, _cmd, objects, keys)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithObjects:forKeys:", objects, keys);
}
,["id","CPArray","CPArray"]), new objj_method(sel_getUid("dictionaryWithJSObject:"), function $CPDictionary__dictionaryWithJSObject_(self, _cmd, object)
{
    return objj_msgSend(self, "dictionaryWithJSObject:recursively:", object, NO);
}
,["id","JSObject"]), new objj_method(sel_getUid("dictionaryWithJSObject:recursively:"), function $CPDictionary__dictionaryWithJSObject_recursively_(self, _cmd, object, recursively)
{
    var key = "",
        dictionary = objj_msgSend(objj_msgSend(self, "alloc"), "init");
    for (key in object)
    {
        if (!object.hasOwnProperty(key))
            continue;
        var value = object[key];
        if (value === null)
        {
            objj_msgSend(dictionary, "setObject:forKey:", objj_msgSend(CPNull, "null"), key);
            continue;
        }
        if (recursively)
        {
            if (value.constructor === Object)
                value = objj_msgSend(CPDictionary, "dictionaryWithJSObject:recursively:", value, YES);
            else if (objj_msgSend(value, "isKindOfClass:", CPArray))
            {
                var newValue = [],
                    i = 0,
                    count = value.length;
                for (; i < count; i++)
                {
                    var thisValue = value[i];
                    if (thisValue === null)
                    {
                        newValue.push(objj_msgSend(CPNull, "null"));
                    }
                    else
                    {
                        if (thisValue.constructor === Object)
                            newValue.push(objj_msgSend(CPDictionary, "dictionaryWithJSObject:recursively:", thisValue, YES));
                        else
                            newValue.push(thisValue);
                    }
                }
                value = newValue;
            }
        }
        objj_msgSend(dictionary, "setObject:forKey:", value, key);
    }
    return dictionary;
}
,["id","JSObject","BOOL"]), new objj_method(sel_getUid("dictionaryWithObjectsAndKeys:"), function $CPDictionary__dictionaryWithObjectsAndKeys_(self, _cmd, firstObject)
{
    arguments[0] = objj_msgSend(self, "alloc");
    arguments[1] = sel_getUid("initWithObjectsAndKeys:");
    return objj_msgSend.apply(this, arguments);
}
,["id","id"])]);
}
{
var the_class = objj_getClass("CPDictionary")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPDictionary\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPDictionary__initWithCoder_(self, _cmd, aCoder)
{
    return objj_msgSend(aCoder, "_decodeDictionaryOfObjectsForKey:", "CP.objects");
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPDictionary__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "_encodeDictionaryOfObjects:forKey:", self, "CP.objects");
}
,["void","CPCoder"])]);
}
{var the_class = objj_allocateClassPair(CPDictionary, "CPMutableDictionary"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
}
CFDictionary.prototype.isa = CPDictionary;
CFMutableDictionary.prototype.isa = CPMutableDictionary;p;14;CPEnumerator.jt;474;@STATIC;1.0;i;10;CPObject.jt;441;objj_executeFile("CPObject.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPEnumerator"),
meta_class = the_class.isa;
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("nextObject"), function $CPEnumerator__nextObject(self, _cmd)
{
    return nil;
}
,["id"]), new objj_method(sel_getUid("allObjects"), function $CPEnumerator__allObjects(self, _cmd)
{
    return [];
}
,["CPArray"])]);
}p;9;CPError.jt;3591;@STATIC;1.0;i;14;CPDictionary.ji;10;CPObject.ji;10;CPString.jt;3523;objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
CPCappuccinoErrorDomain = CPCocoaErrorDomain = "CPCappuccinoErrorDomain";
CPUnderlyingErrorKey = "CPUnderlyingErrorKey";
CPLocalizedDescriptionKey = "CPLocalizedDescriptionKey";
CPLocalizedFailureReasonErrorKey = "CPLocalizedFailureReasonErrorKey";
CPLocalizedRecoverySuggestionErrorKey = "CPLocalizedRecoverySuggestionErrorKey";
CPLocalizedRecoveryOptionsErrorKey = "CPLocalizedRecoveryOptionsErrorKey";
CPRecoveryAttempterErrorKey = "CPRecoveryAttempterErrorKey";
CPHelpAnchorErrorKey = "CPHelpAnchorErrorKey";
CPStringEncodingErrorKey = "CPStringEncodingErrorKey";
CPURLErrorKey = "CPURLErrorKey";
CPFilePathErrorKey = "CPFilePathErrorKey";
{var the_class = objj_allocateClassPair(CPObject, "CPError"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_code"), new objj_ivar("_domain"), new objj_ivar("_userInfo")]);






objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("code"), function $CPError__code(self, _cmd)
{
return self._code;
}
,["CPInteger"]), new objj_method(sel_getUid("domain"), function $CPError__domain(self, _cmd)
{
return self._domain;
}
,["CPString"]), new objj_method(sel_getUid("userInfo"), function $CPError__userInfo(self, _cmd)
{
return self._userInfo;
}
,["CPDictionary"]), new objj_method(sel_getUid("initWithDomain:code:userInfo:"), function $CPError__initWithDomain_code_userInfo_(self, _cmd, aDomain, aCode, aDict)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPError").super_class }, "init"))
    {
        self._domain = aDomain;
        self._code = aCode;
        self._userInfo = aDict;
    }
    return self;
}
,["id","CPString","CPInteger","CPDictionary"]), new objj_method(sel_getUid("localizedDescription"), function $CPError__localizedDescription(self, _cmd)
{
   return objj_msgSend(self._userInfo, "objectForKey:", CPLocalizedDescriptionKey);
}
,["CPString"]), new objj_method(sel_getUid("localizedFailureReason"), function $CPError__localizedFailureReason(self, _cmd)
{
   return objj_msgSend(self._userInfo, "objectForKey:", CPLocalizedFailureReasonErrorKey);
}
,["CPString"]), new objj_method(sel_getUid("localizedRecoveryOptions"), function $CPError__localizedRecoveryOptions(self, _cmd)
{
   return objj_msgSend(self._userInfo, "objectForKey:", CPLocalizedRecoveryOptionsErrorKey);
}
,["CPArray"]), new objj_method(sel_getUid("localizedRecoverySuggestion"), function $CPError__localizedRecoverySuggestion(self, _cmd)
{
   return objj_msgSend(self._userInfo, "objectForKey:", CPLocalizedRecoverySuggestionErrorKey);
}
,["CPString"]), new objj_method(sel_getUid("recoveryAttempter"), function $CPError__recoveryAttempter(self, _cmd)
{
   return objj_msgSend(self._userInfo, "objectForKey:", CPRecoveryAttempterErrorKey);
}
,["id"]), new objj_method(sel_getUid("description"), function $CPError__description(self, _cmd)
{
   return objj_msgSend(CPString, "stringWithFormat:", "Error Domain=%@ Code=%d UserInfo=%p %@", self._domain, self._code, self._userInfo, objj_msgSend(self, "localizedDescription"));
}
,["id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("errorWithDomain:code:userInfo:"), function $CPError__errorWithDomain_code_userInfo_(self, _cmd, aDomain, aCode, aDict)
{
    return objj_msgSend(objj_msgSend(CPError, "alloc"), "initWithDomain:code:userInfo:", aDomain, aCode, aDict);
}
,["id","CPString","CPInteger","CPDictionary"])]);
}p;13;CPException.jt;6108;@STATIC;1.0;i;9;CPCoder.ji;10;CPObject.ji;10;CPString.jt;6046;objj_executeFile("CPCoder.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
CPInvalidArgumentException = "CPInvalidArgumentException";
CPUnsupportedMethodException = "CPUnsupportedMethodException";
CPRangeException = "CPRangeException";
CPInternalInconsistencyException = "CPInternalInconsistencyException";
CPGenericException = "CPGenericException";
{var the_class = objj_allocateClassPair(CPObject, "CPException"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_userInfo"), new objj_ivar("name"), new objj_ivar("message")]);








objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithName:reason:userInfo:"), function $CPException__initWithName_reason_userInfo_(self, _cmd, aName, aReason, aUserInfo)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPException").super_class }, "init");
    if (self)
    {
        self.name = aName;
        self.message = aReason;
        self._userInfo = aUserInfo;
    }
    return self;
}
,["id","CPString","CPString","CPDictionary"]), new objj_method(sel_getUid("name"), function $CPException__name(self, _cmd)
{
    return self.name;
}
,["CPString"]), new objj_method(sel_getUid("reason"), function $CPException__reason(self, _cmd)
{
    return self.message;
}
,["CPString"]), new objj_method(sel_getUid("userInfo"), function $CPException__userInfo(self, _cmd)
{
    return self._userInfo;
}
,["CPDictionary"]), new objj_method(sel_getUid("description"), function $CPException__description(self, _cmd)
{
    return self.message;
}
,["CPString"]), new objj_method(sel_getUid("raise"), function $CPException__raise(self, _cmd)
{
    throw self;
}
,["void"]), new objj_method(sel_getUid("isEqual:"), function $CPException__isEqual_(self, _cmd, anObject)
{
    if (!anObject || !anObject.isa)
        return NO;
    return objj_msgSend(anObject, "isKindOfClass:", CPException) &&
           self.name === objj_msgSend(anObject, "name") &&
           self.message === objj_msgSend(anObject, "message") &&
           (self._userInfo === objj_msgSend(anObject, "userInfo") || objj_msgSend(self._userInfo, "isEqual:", objj_msgSend(anObject, "userInfo")));
}
,["BOOL","id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $CPException__alloc(self, _cmd)
{
    var result = new Error();
    result.isa = objj_msgSend(self, "class");
    return result;
}
,["id"]), new objj_method(sel_getUid("raise:reason:"), function $CPException__raise_reason_(self, _cmd, aName, aReason)
{
    objj_msgSend(objj_msgSend(self, "exceptionWithName:reason:userInfo:", aName, aReason, nil), "raise");
}
,["void","CPString","CPString"]), new objj_method(sel_getUid("exceptionWithName:reason:userInfo:"), function $CPException__exceptionWithName_reason_userInfo_(self, _cmd, aName, aReason, aUserInfo)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithName:reason:userInfo:", aName, aReason, aUserInfo);
}
,["CPException","CPString","CPString","CPDictionary"])]);
}
{
var the_class = objj_getClass("CPException")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPException\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("copy"), function $CPException__copy(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "class"), "exceptionWithName:reason:userInfo:", self.name, self.message, self._userInfo);
}
,["id"])]);
}
var CPExceptionNameKey = "CPExceptionNameKey",
    CPExceptionReasonKey = "CPExceptionReasonKey",
    CPExceptionUserInfoKey = "CPExceptionUserInfoKey";
{
var the_class = objj_getClass("CPException")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPException\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPException__initWithCoder_(self, _cmd, aCoder)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPException").super_class }, "init"))
    {
        self.name = objj_msgSend(aCoder, "decodeObjectForKey:", CPExceptionNameKey);
        self.message = objj_msgSend(aCoder, "decodeObjectForKey:", CPExceptionReasonKey);
        self._userInfo = objj_msgSend(aCoder, "decodeObjectForKey:", CPExceptionUserInfoKey);
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPException__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeObject:forKey:", self.name, CPExceptionNameKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self.message, CPExceptionReasonKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._userInfo, CPExceptionUserInfoKey);
}
,["void","CPCoder"])]);
}
Error.prototype.isa = CPException;
Error.prototype._userInfo = null;
objj_msgSend(CPException, "initialize");
_CPRaiseInvalidAbstractInvocation = function(anObject, aSelector)
{
    objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "*** -" + sel_getName(aSelector) + " cannot be sent to an abstract object of class " + objj_msgSend(anObject, "className") + ": Create a concrete instance!");
}
_CPRaiseInvalidArgumentException = function(anObject, aSelector, aMessage)
{
    objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, ((class_isMetaClass(anObject.isa) ? "+" : "-") + "[" + objj_msgSend(anObject, "className") + " " + aSelector + "]: ") + aMessage);
}
_CPRaiseRangeException = function(anObject, aSelector, anIndex, aCount)
{
    objj_msgSend(CPException, "raise:reason:", CPRangeException, ((class_isMetaClass(anObject.isa) ? "+" : "-") + "[" + objj_msgSend(anObject, "className") + " " + aSelector + "]: ") + "index (" + anIndex + ") beyond bounds (" + aCount + ")");
}
_CPReportLenientDeprecation = function( aClass, oldSelector, newSelector)
{
    CPLog.warn("[" + CPStringFromClass(aClass) + " " + CPStringFromSelector(oldSelector) + "] is deprecated, using " + CPStringFromSelector(newSelector) + " instead.");
}p;13;CPFormatter.jt;2528;@STATIC;1.0;i;13;CPException.ji;10;CPObject.jt;2476;objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPFormatter"),
meta_class = the_class.isa;





objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("stringForObjectValue:"), function $CPFormatter__stringForObjectValue_(self, _cmd, anObject)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["CPString","id"]), new objj_method(sel_getUid("editingStringForObjectValue:"), function $CPFormatter__editingStringForObjectValue_(self, _cmd, anObject)
{
    return objj_msgSend(self, "stringForObjectValue:", anObject);
}
,["CPString","id"]), new objj_method(sel_getUid("getObjectValue:forString:errorDescription:"), function $CPFormatter__getObjectValue_forString_errorDescription_(self, _cmd, anObject, aString, anError)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return NO;
}
,["BOOL","idRef","CPString","CPStringRef"]), new objj_method(sel_getUid("isPartialStringValid:newEditingString:errorDescription:"), function $CPFormatter__isPartialStringValid_newEditingString_errorDescription_(self, _cmd, aPartialString, aNewString, anError)
{
    aPartialString( nil);
    if (anError)
        anError( nil);
    return YES;
}
,["BOOL","CPString","CPStringRef","CPStringRef"]), new objj_method(sel_getUid("isPartialStringValid:proposedSelectedRange:originalString:originalSelectedRange:errorDescription:"), function $CPFormatter__isPartialStringValid_proposedSelectedRange_originalString_originalSelectedRange_errorDescription_(self, _cmd, aPartialString, aProposedSelectedRange, originalString, originalSelectedRange, anError)
{
    var newString = nil,
        valid = objj_msgSend(self, "isPartialStringValid:newEditingString:errorDescription:", aPartialString, function(__input) { if (arguments.length) return newString = __input; return newString; }, anError);
    if (!valid)
    {
        aPartialString( newString);
        if (newString !== nil)
            aProposedSelectedRange( CPMakeRange(newString.length, 0));
    }
    return valid;
}
,["BOOL","CPStringRef","CPRangeRef","CPString","CPRange","CPStringRef"]), new objj_method(sel_getUid("initWithCoder:"), function $CPFormatter__initWithCoder_(self, _cmd, aCoder)
{
    return objj_msgSend(self, "init");
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPFormatter__encodeWithCoder_(self, _cmd, aCoder)
{
}
,["void","CPCoder"])]);
}p;21;CPFunctionOperation.jt;1863;@STATIC;1.0;i;9;CPArray.ji;10;CPObject.ji;13;CPOperation.jt;1798;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPOperation.j", YES);
{var the_class = objj_allocateClassPair(CPOperation, "CPFunctionOperation"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_functions")]);



objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("main"), function $CPFunctionOperation__main(self, _cmd)
{
    if (self._functions && objj_msgSend(self._functions, "count") > 0)
    {
        var i = 0,
            count = objj_msgSend(self._functions, "count");
        for (; i < count; i++)
        {
            var func = objj_msgSend(self._functions, "objectAtIndex:", i);
            func();
        }
    }
}
,["void"]), new objj_method(sel_getUid("init"), function $CPFunctionOperation__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPFunctionOperation").super_class }, "init");
    if (self)
    {
        self._functions = [];
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("addExecutionFunction:"), function $CPFunctionOperation__addExecutionFunction_(self, _cmd, jsFunction)
{
    objj_msgSend(self._functions, "addObject:", jsFunction);
}
,["void","JSObject"]), new objj_method(sel_getUid("executionFunctions"), function $CPFunctionOperation__executionFunctions(self, _cmd)
{
    return self._functions;
}
,["CPArray"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("functionOperationWithFunction:"), function $CPFunctionOperation__functionOperationWithFunction_(self, _cmd, jsFunction)
{
    functionOp = objj_msgSend(objj_msgSend(CPFunctionOperation, "alloc"), "init");
    objj_msgSend(functionOp, "addExecutionFunction:", jsFunction);
    return functionOp;
}
,["id","JSObject"])]);
}p;12;CPGeometry.jt;1649;@STATIC;1.0;i;13;_CGGeometry.jt;1612;objj_executeFile("_CGGeometry.j", YES);
CPMinXEdge = 0;
CPMinYEdge = 1;
CPMaxXEdge = 2;
CPMaxYEdge = 3;
CPMakePoint = CGPointMake;
CPMakeSize = CGSizeMake;
CPMakeRect = CGRectMake;
CPPointCreateCopy = CGPointMakeCopy;
CPPointEqualToPoint = CGPointEqualToPoint;
CPPointInRect = function(aPoint, aRect)
{
    return CGRectContainsPoint(aRect, aPoint)
};
CPRectEqualToRect = CGRectEqualToRect;
CPRectIsEmpty = CGRectIsEmpty;
CPRectContainsRect = CGRectContainsRect;
CPRectIntersection = CGRectIntersection;
CPPointMake = CGPointMake;
CPRectInset = CGRectInset;
CPRectIntegral = CGRectIntegral;
CPRectCreateCopy = CGRectCreateCopy;
CPRectMake = CGRectMake;
CPRectOffset = CGRectOffset;
CPRectStandardize = CGRectStandardize;
CPRectUnion = CGRectUnion;
CPSizeCreateCopy = CGSizeCreateCopy;
CPSizeMake = CGSizeMake;
CPRectContainsPoint = CGRectContainsPoint;
CPRectGetHeight = CGRectGetHeight;
CPRectGetMaxX = CGRectGetMaxX;
CPRectGetMaxY = CGRectGetMaxY;
CPRectGetMidX = CGRectGetMidX;
CPRectGetMidY = CGRectGetMidY;
CPRectGetMinX = CGRectGetMinX;
CPRectGetMinY = CGRectGetMinY;
CPRectGetWidth = CGRectGetWidth;
CPRectIntersectsRect = CGRectIntersectsRect;
CPRectIsNull = CGRectIsNull;
CPDivideRect = CGRectDivide;
CPSizeEqualToSize = CGSizeEqualToSize;
CPStringFromPoint = CGStringFromPoint;
CPStringFromSize = CGStringFromSize;
CPStringFromRect = CGStringFromRect;
CPPointFromString = CGPointFromString;
CPSizeFromString = CGSizeFromString;
CPRectFromString = CGRectFromString;
CPPointFromEvent = CGPointFromEvent;
CPSizeMakeZero = CGSizeMakeZero;
CPRectMakeZero = CGRectMakeZero;
CPPointMakeZero = CGPointMakeZero;p;13;CPIndexPath.jt;5889;@STATIC;1.0;i;9;CPArray.ji;13;CPException.ji;10;CPObject.ji;9;CPRange.ji;18;CPSortDescriptor.jt;5788;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPRange.j", YES);
objj_executeFile("CPSortDescriptor.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPIndexPath"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_indexes")]);





       
       




       
       


       
       

objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("indexes"), function $CPIndexPath__indexes(self, _cmd)
{
return self._indexes;
}
,["CPArray"]), new objj_method(sel_getUid("setIndexes:"), function $CPIndexPath__setIndexes_(self, _cmd, newValue)
{
self._indexes = newValue;
}
,["void","CPArray"]), new objj_method(sel_getUid("initWithIndexes:length:"), function $CPIndexPath__initWithIndexes_length_(self, _cmd, indexes, length)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPIndexPath").super_class }, "init");
    if (self)
        self._indexes = objj_msgSend(indexes, "subarrayWithRange:", CPMakeRange(0, length));
    return self;
}
,["id","CPArray","int"]), new objj_method(sel_getUid("initWithIndexes:"), function $CPIndexPath__initWithIndexes_(self, _cmd, indexes)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPIndexPath").super_class }, "init");
    if (self)
        self._indexes = objj_msgSend(indexes, "copy");
    return self;
}
,["id","CPArray"]), new objj_method(sel_getUid("description"), function $CPIndexPath__description(self, _cmd)
{
    return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPIndexPath").super_class }, "description") + " " + self._indexes;
}
,["CPString"]), new objj_method(sel_getUid("length"), function $CPIndexPath__length(self, _cmd)
{
    return objj_msgSend(self._indexes, "count");
}
,["id"]), new objj_method(sel_getUid("indexAtPosition:"), function $CPIndexPath__indexAtPosition_(self, _cmd, position)
{
    return objj_msgSend(self._indexes, "objectAtIndex:", position);
}
,["int","int"]), new objj_method(sel_getUid("setIndexes:"), function $CPIndexPath__setIndexes_(self, _cmd, theIndexes)
{
    self._indexes = objj_msgSend(theIndexes, "copy");
}
,["void","CPArray"]), new objj_method(sel_getUid("indexes"), function $CPIndexPath__indexes(self, _cmd)
{
    return objj_msgSend(self._indexes, "copy");
}
,["CPArray"]), new objj_method(sel_getUid("indexPathByAddingIndex:"), function $CPIndexPath__indexPathByAddingIndex_(self, _cmd, index)
{
    return objj_msgSend(CPIndexPath, "indexPathWithIndexes:", objj_msgSend(self._indexes, "arrayByAddingObject:", index));
}
,["CPIndexPath","int"]), new objj_method(sel_getUid("indexPathByRemovingLastIndex"), function $CPIndexPath__indexPathByRemovingLastIndex(self, _cmd)
{
    return objj_msgSend(CPIndexPath, "indexPathWithIndexes:length:", self._indexes, objj_msgSend(self, "length") - 1);
}
,["CPIndexPath"]), new objj_method(sel_getUid("isEqual:"), function $CPIndexPath__isEqual_(self, _cmd, anObject)
{
    if (anObject === self)
        return YES;
    if (objj_msgSend(anObject, "class") !== objj_msgSend(CPIndexPath, "class"))
        return NO;
    return objj_msgSend(self._indexes, "isEqualToArray:", objj_msgSend(anObject, "indexes"));
}
,["BOOL","id"]), new objj_method(sel_getUid("compare:"), function $CPIndexPath__compare_(self, _cmd, anIndexPath)
{
    if (!anIndexPath)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "indexPath to " + self + " was nil");
    var lhsIndexes = objj_msgSend(self, "indexes"),
        rhsIndexes = objj_msgSend(anIndexPath, "indexes"),
        lhsCount = objj_msgSend(lhsIndexes, "count"),
        rhsCount = objj_msgSend(rhsIndexes, "count");
    var index = 0,
        count = MIN(lhsCount, rhsCount);
    for (; index < count; ++index)
    {
        var lhs = lhsIndexes[index],
            rhs = rhsIndexes[index];
        if (lhs < rhs)
            return CPOrderedAscending;
        else if (lhs > rhs)
            return CPOrderedDescending;
    }
    if (lhsCount === rhsCount)
        return CPOrderedSame;
    if (lhsCount === count)
        return CPOrderedAscending;
    return CPOrderedDescending;
}
,["CPComparisonResult","CPIndexPath"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("indexPathWithIndex:"), function $CPIndexPath__indexPathWithIndex_(self, _cmd, index)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithIndexes:length:", [index], 1);
}
,["id","int"]), new objj_method(sel_getUid("indexPathWithIndexes:length:"), function $CPIndexPath__indexPathWithIndexes_length_(self, _cmd, indexes, length)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithIndexes:length:", indexes, length);
}
,["id","CPArray","int"]), new objj_method(sel_getUid("indexPathWithIndexes:"), function $CPIndexPath__indexPathWithIndexes_(self, _cmd, indexes)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithIndexes:", indexes);
}
,["id","CPArray"])]);
}
var CPIndexPathIndexesKey = "CPIndexPathIndexes";
{
var the_class = objj_getClass("CPIndexPath")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPIndexPath\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPIndexPath__initWithCoder_(self, _cmd, theCoder)
{
    if (self = objj_msgSend(self, "init"))
    {
        self._indexes = objj_msgSend(theCoder, "decodeObjectForKey:", CPIndexPathIndexesKey);
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPIndexPath__encodeWithCoder_(self, _cmd, theCoder)
{
    objj_msgSend(theCoder, "encodeObject:forKey:", self._indexes, CPIndexPathIndexesKey);
}
,["void","CPCoder"])]);
}p;12;CPIndexSet.jt;29748;@STATIC;1.0;i;9;CPArray.ji;10;CPObject.ji;9;CPRange.jt;29687;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPRange.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPIndexSet"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_count"), new objj_ivar("_ranges")]);






























objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPIndexSet__init(self, _cmd)
{
    return objj_msgSend(self, "initWithIndexesInRange:", { location:(0), length:0 });
}
,["id"]), new objj_method(sel_getUid("initWithIndex:"), function $CPIndexSet__initWithIndex_(self, _cmd, anIndex)
{
    if (!(!isNaN(parseFloat(anIndex)) && isFinite(anIndex)))
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "Invalid index");
    return objj_msgSend(self, "initWithIndexesInRange:", { location:(anIndex), length:1 });
}
,["id","CPInteger"]), new objj_method(sel_getUid("initWithIndexesInRange:"), function $CPIndexSet__initWithIndexesInRange_(self, _cmd, aRange)
{
    if (aRange.location < 0)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "Range " + CPStringFromRange(aRange) + " is out of bounds.");
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPIndexSet").super_class }, "init");
    if (self)
    {
        self._count = MAX(0, aRange.length);
        if (self._count > 0)
            self._ranges = [aRange];
        else
            self._ranges = [];
    }
    return self;
}
,["id","CPRange"]), new objj_method(sel_getUid("initWithIndexSet:"), function $CPIndexSet__initWithIndexSet_(self, _cmd, anIndexSet)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPIndexSet").super_class }, "init");
    if (self)
    {
        self._count = objj_msgSend(anIndexSet, "count");
        self._ranges = [];
        var otherRanges = anIndexSet._ranges,
            otherRangesCount = otherRanges.length;
        while (otherRangesCount--)
            self._ranges[otherRangesCount] = { location:(otherRanges[otherRangesCount]).location, length:(otherRanges[otherRangesCount]).length };
    }
    return self;
}
,["id","CPIndexSet"]), new objj_method(sel_getUid("isEqual:"), function $CPIndexSet__isEqual_(self, _cmd, anObject)
{
    if (self === anObject)
        return YES;
    if (!anObject || !objj_msgSend(anObject, "isKindOfClass:", objj_msgSend(CPIndexSet, "class")))
        return NO;
    return objj_msgSend(self, "isEqualToIndexSet:", anObject);
}
,["BOOL","id"]), new objj_method(sel_getUid("isEqualToIndexSet:"), function $CPIndexSet__isEqualToIndexSet_(self, _cmd, anIndexSet)
{
    if (!anIndexSet)
        return NO;
    if (self === anIndexSet)
       return YES;
    var rangesCount = self._ranges.length,
        otherRanges = anIndexSet._ranges;
    if (rangesCount !== otherRanges.length || self._count !== anIndexSet._count)
        return NO;
    while (rangesCount--)
        if (!CPEqualRanges(self._ranges[rangesCount], otherRanges[rangesCount]))
            return NO;
    return YES;
}
,["BOOL","CPIndexSet"]), new objj_method(sel_getUid("isEqual:"), function $CPIndexSet__isEqual_(self, _cmd, anObject)
{
    return self === anObject ||
            objj_msgSend(anObject, "isKindOfClass:", objj_msgSend(self, "class")) &&
            objj_msgSend(self, "isEqualToIndexSet:", anObject);
}
,["BOOL","id"]), new objj_method(sel_getUid("containsIndex:"), function $CPIndexSet__containsIndex_(self, _cmd, anIndex)
{
    return positionOfIndex(self._ranges, anIndex) !== CPNotFound;
}
,["BOOL","CPInteger"]), new objj_method(sel_getUid("containsIndexesInRange:"), function $CPIndexSet__containsIndexesInRange_(self, _cmd, aRange)
{
    if (aRange.length <= 0)
        return NO;
    if (self._count < aRange.length)
        return NO;
    var rangeIndex = positionOfIndex(self._ranges, aRange.location);
    if (rangeIndex === CPNotFound)
        return NO;
    var range = self._ranges[rangeIndex];
    return CPIntersectionRange(range, aRange).length === aRange.length;
}
,["BOOL","CPRange"]), new objj_method(sel_getUid("containsIndexes:"), function $CPIndexSet__containsIndexes_(self, _cmd, anIndexSet)
{
    var otherCount = anIndexSet._count;
    if (otherCount <= 0)
        return YES;
    if (self._count < otherCount)
        return NO;
    var otherRanges = anIndexSet._ranges,
        otherRangesCount = otherRanges.length;
    while (otherRangesCount--)
        if (!objj_msgSend(self, "containsIndexesInRange:", otherRanges[otherRangesCount]))
            return NO;
    return YES;
}
,["BOOL","CPIndexSet"]), new objj_method(sel_getUid("intersectsIndexesInRange:"), function $CPIndexSet__intersectsIndexesInRange_(self, _cmd, aRange)
{
    if (self._count <= 0)
        return NO;
    var lhsRangeIndex = assumedPositionOfIndex(self._ranges, aRange.location);
    if (FLOOR(lhsRangeIndex) === lhsRangeIndex)
        return YES;
    var rhsRangeIndex = assumedPositionOfIndex(self._ranges, ((aRange).location + (aRange).length) - 1);
    if (FLOOR(rhsRangeIndex) === rhsRangeIndex)
        return YES;
    return lhsRangeIndex !== rhsRangeIndex;
}
,["BOOL","CPRange"]), new objj_method(sel_getUid("count"), function $CPIndexSet__count(self, _cmd)
{
    return self._count;
}
,["int"]), new objj_method(sel_getUid("firstIndex"), function $CPIndexSet__firstIndex(self, _cmd)
{
    if (self._count > 0)
        return self._ranges[0].location;
    return CPNotFound;
}
,["CPInteger"]), new objj_method(sel_getUid("lastIndex"), function $CPIndexSet__lastIndex(self, _cmd)
{
    if (self._count > 0)
        return ((self._ranges[self._ranges.length - 1]).location + (self._ranges[self._ranges.length - 1]).length) - 1;
    return CPNotFound;
}
,["CPInteger"]), new objj_method(sel_getUid("indexGreaterThanIndex:"), function $CPIndexSet__indexGreaterThanIndex_(self, _cmd, anIndex)
{
    ++anIndex;
    var rangeIndex = assumedPositionOfIndex(self._ranges, anIndex);
    if (rangeIndex === CPNotFound)
        return CPNotFound;
    rangeIndex = CEIL(rangeIndex);
    if (rangeIndex >= self._ranges.length)
        return CPNotFound;
    var range = self._ranges[rangeIndex];
    if ((((anIndex) >= (range).location) && ((anIndex) < ((range).location + (range).length))))
        return anIndex;
    return range.location;
}
,["CPInteger","CPInteger"]), new objj_method(sel_getUid("indexLessThanIndex:"), function $CPIndexSet__indexLessThanIndex_(self, _cmd, anIndex)
{
    --anIndex;
    var rangeIndex = assumedPositionOfIndex(self._ranges, anIndex);
    if (rangeIndex === CPNotFound)
        return CPNotFound;
    rangeIndex = FLOOR(rangeIndex);
    if (rangeIndex < 0)
        return CPNotFound;
    var range = self._ranges[rangeIndex];
    if ((((anIndex) >= (range).location) && ((anIndex) < ((range).location + (range).length))))
        return anIndex;
    return ((range).location + (range).length) - 1;
}
,["CPInteger","CPInteger"]), new objj_method(sel_getUid("indexGreaterThanOrEqualToIndex:"), function $CPIndexSet__indexGreaterThanOrEqualToIndex_(self, _cmd, anIndex)
{
    return objj_msgSend(self, "indexGreaterThanIndex:", anIndex - 1);
}
,["CPInteger","CPInteger"]), new objj_method(sel_getUid("indexLessThanOrEqualToIndex:"), function $CPIndexSet__indexLessThanOrEqualToIndex_(self, _cmd, anIndex)
{
    return objj_msgSend(self, "indexLessThanIndex:", anIndex + 1);
}
,["CPInteger","CPInteger"]), new objj_method(sel_getUid("getIndexes:maxCount:inIndexRange:"), function $CPIndexSet__getIndexes_maxCount_inIndexRange_(self, _cmd, anArray, aMaxCount, aRange)
{
    if (!self._count || aMaxCount === 0 || aRange && !aRange.length)
    {
        if (aRange)
            aRange.length = 0;
        return 0;
    }
    var total = 0;
    if (aRange)
    {
        var firstIndex = aRange.location,
            lastIndex = ((aRange).location + (aRange).length) - 1,
            rangeIndex = CEIL(assumedPositionOfIndex(self._ranges, firstIndex)),
            lastRangeIndex = FLOOR(assumedPositionOfIndex(self._ranges, lastIndex));
    }
    else
    {
        var firstIndex = objj_msgSend(self, "firstIndex"),
            lastIndex = objj_msgSend(self, "lastIndex"),
            rangeIndex = 0,
            lastRangeIndex = self._ranges.length - 1;
    }
    while (rangeIndex <= lastRangeIndex)
    {
        var range = self._ranges[rangeIndex],
            index = MAX(firstIndex, range.location),
            maxRange = MIN(lastIndex + 1, ((range).location + (range).length));
        for (; index < maxRange; ++index)
        {
            anArray[total++] = index;
            if (total === aMaxCount)
            {
                if (aRange)
                {
                    aRange.location = index + 1;
                    aRange.length = lastIndex + 1 - index - 1;
                }
                return aMaxCount;
            }
        }
        ++rangeIndex;
    }
    if (aRange)
    {
        aRange.location = CPNotFound;
        aRange.length = 0;
    }
    return total;
}
,["CPInteger","CPArray","CPInteger","CPRange"]), new objj_method(sel_getUid("description"), function $CPIndexSet__description(self, _cmd)
{
    var description = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPIndexSet").super_class }, "description");
    if (self._count)
    {
        var index = 0,
            count = self._ranges.length;
        description += "[number of indexes: " + self._count + " (in " + count;
        if (count === 1)
            description += " range), indexes: (";
        else
            description += " ranges), indexes: (";
        for (; index < count; ++index)
        {
            var range = self._ranges[index];
            description += range.location;
            if (range.length > 1)
                description += "-" + (CPMaxRange(range) - 1);
            if (index + 1 < count)
                description += " ";
        }
        description += ")]";
    }
    else
        description += "(no indexes)";
    return description;
}
,["CPString"]), new objj_method(sel_getUid("enumerateIndexesUsingBlock:"), function $CPIndexSet__enumerateIndexesUsingBlock_(self, _cmd, aFunction)
{
    objj_msgSend(self, "enumerateIndexesWithOptions:usingBlock:", CPEnumerationNormal, aFunction);
}
,["void","Function"]), new objj_method(sel_getUid("enumerateIndexesWithOptions:usingBlock:"), function $CPIndexSet__enumerateIndexesWithOptions_usingBlock_(self, _cmd, options, aFunction)
{
    if (!self._count)
        return;
    objj_msgSend(self, "enumerateIndexesInRange:options:usingBlock:", CPMakeRange(0, ((self._ranges[self._ranges.length - 1]).location + (self._ranges[self._ranges.length - 1]).length)), options, aFunction);
}
,["void","CPEnumerationOptions","Function"]), new objj_method(sel_getUid("enumerateIndexesInRange:options:usingBlock:"), function $CPIndexSet__enumerateIndexesInRange_options_usingBlock_(self, _cmd, enumerationRange, options, aFunction)
{
    if (!self._count || ((enumerationRange).length === 0))
        return;
    var shouldStop = NO,
        index,
        stop,
        increment;
    if (options & CPEnumerationReverse)
    {
        index = self._ranges.length - 1,
        stop = -1,
        increment = -1;
    }
    else
    {
        index = 0;
        stop = self._ranges.length;
        increment = 1;
    }
    for (; index !== stop; index += increment)
    {
        var range = self._ranges[index],
            rangeIndex,
            rangeStop,
            rangeIncrement;
        if (options & CPEnumerationReverse)
        {
            rangeIndex = ((range).location + (range).length) - 1;
            rangeStop = range.location - 1;
            rangeIncrement = -1;
        }
        else
        {
            rangeIndex = range.location;
            rangeStop = ((range).location + (range).length);
            rangeIncrement = 1;
        }
        for (; rangeIndex !== rangeStop; rangeIndex += rangeIncrement)
        {
            if ((((rangeIndex) >= (enumerationRange).location) && ((rangeIndex) < ((enumerationRange).location + (enumerationRange).length))))
            {
                aFunction(rangeIndex, function(__input) { if (arguments.length) return shouldStop = __input; return shouldStop; });
                if (shouldStop)
                    return;
            }
        }
    }
}
,["void","CPRange","CPEnumerationOptions","Function"]), new objj_method(sel_getUid("indexPassingTest:"), function $CPIndexSet__indexPassingTest_(self, _cmd, aPredicate)
{
    return objj_msgSend(self, "indexWithOptions:passingTest:", CPEnumerationNormal, aPredicate);
}
,["unsigned","Function"]), new objj_method(sel_getUid("indexesPassingTest:"), function $CPIndexSet__indexesPassingTest_(self, _cmd, aPredicate)
{
    return objj_msgSend(self, "indexesWithOptions:passingTest:", CPEnumerationNormal, aPredicate);
}
,["CPIndexSet","Function"]), new objj_method(sel_getUid("indexWithOptions:passingTest:"), function $CPIndexSet__indexWithOptions_passingTest_(self, _cmd, anOptions, aPredicate)
{
    if (!self._count)
        return CPNotFound;
    return objj_msgSend(self, "indexInRange:options:passingTest:", { location:(0), length:((self._ranges[self._ranges.length - 1]).location + (self._ranges[self._ranges.length - 1]).length) }, anOptions, aPredicate);
}
,["unsigned","CPEnumerationOptions","Function"]), new objj_method(sel_getUid("indexesWithOptions:passingTest:"), function $CPIndexSet__indexesWithOptions_passingTest_(self, _cmd, anOptions, aPredicate)
{
    if (!self._count)
        return objj_msgSend(CPIndexSet, "indexSet");
    return objj_msgSend(self, "indexesInRange:options:passingTest:", { location:(0), length:((self._ranges[self._ranges.length - 1]).location + (self._ranges[self._ranges.length - 1]).length) }, anOptions, aPredicate);
}
,["CPIndexSet","CPEnumerationOptions","Function"]), new objj_method(sel_getUid("indexInRange:options:passingTest:"), function $CPIndexSet__indexInRange_options_passingTest_(self, _cmd, aRange, anOptions, aPredicate)
{
    if (!self._count || ((aRange).length === 0))
        return CPNotFound;
    var shouldStop = NO,
        index,
        stop,
        increment;
    if (anOptions & CPEnumerationReverse)
    {
        index = self._ranges.length - 1,
        stop = -1,
        increment = -1;
    }
    else
    {
        index = 0;
        stop = self._ranges.length;
        increment = 1;
    }
    for (; index !== stop; index += increment)
    {
        var range = self._ranges[index],
            rangeIndex,
            rangeStop,
            rangeIncrement;
        if (anOptions & CPEnumerationReverse)
        {
            rangeIndex = ((range).location + (range).length) - 1;
            rangeStop = range.location - 1;
            rangeIncrement = -1;
        }
        else
        {
            rangeIndex = range.location;
            rangeStop = ((range).location + (range).length);
            rangeIncrement = 1;
        }
        for (; rangeIndex !== rangeStop; rangeIndex += rangeIncrement)
        {
            if ((((rangeIndex) >= (aRange).location) && ((rangeIndex) < ((aRange).location + (aRange).length))))
            {
                if (aPredicate(rangeIndex, function(__input) { if (arguments.length) return shouldStop = __input; return shouldStop; }))
                    return rangeIndex;
                if (shouldStop)
                    return CPNotFound;
            }
        }
    }
    return CPNotFound;
}
,["unsigned","CPRange","CPEnumerationOptions","Function"]), new objj_method(sel_getUid("indexesInRange:options:passingTest:"), function $CPIndexSet__indexesInRange_options_passingTest_(self, _cmd, aRange, anOptions, aPredicate)
{
    if (!self._count || ((aRange).length === 0))
        return objj_msgSend(CPIndexSet, "indexSet");
    var shouldStop = NO,
        index,
        stop,
        increment;
    if (anOptions & CPEnumerationReverse)
    {
        index = self._ranges.length - 1,
        stop = -1,
        increment = -1;
    }
    else
    {
        index = 0;
        stop = self._ranges.length;
        increment = 1;
    }
    var indexesPassingTest = objj_msgSend(CPMutableIndexSet, "indexSet");
    for (; index !== stop; index += increment)
    {
        var range = self._ranges[index],
            rangeIndex,
            rangeStop,
            rangeIncrement;
        if (anOptions & CPEnumerationReverse)
        {
            rangeIndex = ((range).location + (range).length) - 1;
            rangeStop = range.location - 1;
            rangeIncrement = -1;
        }
        else
        {
            rangeIndex = range.location;
            rangeStop = ((range).location + (range).length);
            rangeIncrement = 1;
        }
        for (; rangeIndex !== rangeStop; rangeIndex += rangeIncrement)
        {
            if ((((rangeIndex) >= (aRange).location) && ((rangeIndex) < ((aRange).location + (aRange).length))))
            {
                if (aPredicate(rangeIndex, function(__input) { if (arguments.length) return shouldStop = __input; return shouldStop; }))
                    objj_msgSend(indexesPassingTest, "addIndex:", rangeIndex);
                if (shouldStop)
                    return indexesPassingTest;
            }
        }
    }
    return indexesPassingTest;
}
,["CPIndexSet","CPRange","CPEnumerationOptions","Function"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("indexSet"), function $CPIndexSet__indexSet(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "init");
}
,["id"]), new objj_method(sel_getUid("indexSetWithIndex:"), function $CPIndexSet__indexSetWithIndex_(self, _cmd, anIndex)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithIndex:", anIndex);
}
,["id","int"]), new objj_method(sel_getUid("indexSetWithIndexesInRange:"), function $CPIndexSet__indexSetWithIndexesInRange_(self, _cmd, aRange)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithIndexesInRange:", aRange);
}
,["id","CPRange"])]);
}
{
var the_class = objj_getClass("CPIndexSet")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPIndexSet\"");
var meta_class = the_class.isa;






class_addMethods(the_class, [new objj_method(sel_getUid("addIndex:"), function $CPIndexSet__addIndex_(self, _cmd, anIndex)
{
    objj_msgSend(self, "addIndexesInRange:", { location:(anIndex), length:1 });
}
,["void","CPInteger"]), new objj_method(sel_getUid("addIndexes:"), function $CPIndexSet__addIndexes_(self, _cmd, anIndexSet)
{
    var otherRanges = anIndexSet._ranges,
        otherRangesCount = otherRanges.length;
    while (otherRangesCount--)
        objj_msgSend(self, "addIndexesInRange:", otherRanges[otherRangesCount]);
}
,["void","CPIndexSet"]), new objj_method(sel_getUid("addIndexesInRange:"), function $CPIndexSet__addIndexesInRange_(self, _cmd, aRange)
{
    if (aRange.location < 0)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "Range " + CPStringFromRange(aRange) + " is out of bounds.");
    if (aRange.length <= 0)
        return;
    if (self._count <= 0)
    {
        self._count = aRange.length;
        self._ranges = [aRange];
        return;
    }
    var rangeCount = self._ranges.length,
        lhsRangeIndex = assumedPositionOfIndex(self._ranges, aRange.location - 1),
        lhsRangeIndexCEIL = CEIL(lhsRangeIndex);
    if (lhsRangeIndexCEIL === lhsRangeIndex && lhsRangeIndexCEIL < rangeCount)
        aRange = CPUnionRange(aRange, self._ranges[lhsRangeIndexCEIL]);
    var rhsRangeIndex = assumedPositionOfIndex(self._ranges, ((aRange).location + (aRange).length)),
        rhsRangeIndexFLOOR = FLOOR(rhsRangeIndex);
    if (rhsRangeIndexFLOOR === rhsRangeIndex && rhsRangeIndexFLOOR >= 0)
        aRange = CPUnionRange(aRange, self._ranges[rhsRangeIndexFLOOR]);
    var removalCount = rhsRangeIndexFLOOR - lhsRangeIndexCEIL + 1;
    if (removalCount === self._ranges.length)
    {
        self._ranges = [aRange];
        self._count = aRange.length;
    }
    else if (removalCount === 1)
    {
        if (lhsRangeIndexCEIL < self._ranges.length)
            self._count -= self._ranges[lhsRangeIndexCEIL].length;
        self._count += aRange.length;
        self._ranges[lhsRangeIndexCEIL] = aRange;
    }
    else
    {
        if (removalCount > 0)
        {
            var removal = lhsRangeIndexCEIL,
                lastRemoval = lhsRangeIndexCEIL + removalCount - 1;
            for (; removal <= lastRemoval; ++removal)
                self._count -= self._ranges[removal].length;
            objj_msgSend(self._ranges, "removeObjectsInRange:", { location:(lhsRangeIndexCEIL), length:removalCount });
        }
        objj_msgSend(self._ranges, "insertObject:atIndex:", aRange, lhsRangeIndexCEIL);
        self._count += aRange.length;
    }
}
,["void","CPRange"]), new objj_method(sel_getUid("removeIndex:"), function $CPIndexSet__removeIndex_(self, _cmd, anIndex)
{
    objj_msgSend(self, "removeIndexesInRange:", { location:(anIndex), length:1 });
}
,["void","CPInteger"]), new objj_method(sel_getUid("removeIndexes:"), function $CPIndexSet__removeIndexes_(self, _cmd, anIndexSet)
{
    var otherRanges = anIndexSet._ranges,
        otherRangesCount = otherRanges.length;
    while (otherRangesCount--)
        objj_msgSend(self, "removeIndexesInRange:", otherRanges[otherRangesCount]);
}
,["void","CPIndexSet"]), new objj_method(sel_getUid("removeAllIndexes"), function $CPIndexSet__removeAllIndexes(self, _cmd)
{
    self._ranges = [];
    self._count = 0;
}
,["void"]), new objj_method(sel_getUid("removeIndexesInRange:"), function $CPIndexSet__removeIndexesInRange_(self, _cmd, aRange)
{
    if (aRange.length <= 0)
        return;
    if (self._count <= 0)
        return;
    var rangeCount = self._ranges.length,
        lhsRangeIndex = assumedPositionOfIndex(self._ranges, aRange.location),
        lhsRangeIndexCEIL = CEIL(lhsRangeIndex);
    if (lhsRangeIndex === lhsRangeIndexCEIL && lhsRangeIndexCEIL < rangeCount)
    {
        var existingRange = self._ranges[lhsRangeIndexCEIL];
        if (aRange.location !== existingRange.location)
        {
            var maxRange = ((aRange).location + (aRange).length),
                existingMaxRange = ((existingRange).location + (existingRange).length);
            existingRange.length = aRange.location - existingRange.location;
            if (maxRange < existingMaxRange)
            {
                self._count -= aRange.length;
                objj_msgSend(self._ranges, "insertObject:atIndex:", { location:(maxRange), length:existingMaxRange - maxRange }, lhsRangeIndexCEIL + 1);
                return;
            }
            else
            {
                self._count -= existingMaxRange - aRange.location;
                lhsRangeIndexCEIL += 1;
            }
        }
    }
    var rhsRangeIndex = assumedPositionOfIndex(self._ranges, ((aRange).location + (aRange).length) - 1),
        rhsRangeIndexFLOOR = FLOOR(rhsRangeIndex);
    if (rhsRangeIndex === rhsRangeIndexFLOOR && rhsRangeIndexFLOOR >= 0)
    {
        var maxRange = ((aRange).location + (aRange).length),
            existingRange = self._ranges[rhsRangeIndexFLOOR],
            existingMaxRange = ((existingRange).location + (existingRange).length);
        if (maxRange !== existingMaxRange)
        {
            self._count -= maxRange - existingRange.location;
            rhsRangeIndexFLOOR -= 1;
            existingRange.location = maxRange;
            existingRange.length = existingMaxRange - maxRange;
        }
    }
    var removalCount = rhsRangeIndexFLOOR - lhsRangeIndexCEIL + 1;
    if (removalCount > 0)
    {
        var removal = lhsRangeIndexCEIL,
            lastRemoval = lhsRangeIndexCEIL + removalCount - 1;
        for (; removal <= lastRemoval; ++removal)
            self._count -= self._ranges[removal].length;
        objj_msgSend(self._ranges, "removeObjectsInRange:", { location:(lhsRangeIndexCEIL), length:removalCount });
    }
}
,["void","CPRange"]), new objj_method(sel_getUid("shiftIndexesStartingAtIndex:by:"), function $CPIndexSet__shiftIndexesStartingAtIndex_by_(self, _cmd, anIndex, aDelta)
{
    if (!self._count || aDelta == 0)
       return;
    var i = self._ranges.length - 1,
        shifted = CPMakeRange(CPNotFound, 0);
    for (; i >= 0; --i)
    {
        var range = self._ranges[i],
            maximum = ((range).location + (range).length);
        if (anIndex >= maximum)
            break;
        if (anIndex > range.location)
        {
            shifted = CPMakeRange(anIndex + aDelta, maximum - anIndex);
            range.length = anIndex - range.location;
            if (aDelta > 0)
                objj_msgSend(self._ranges, "insertObject:atIndex:", shifted, i + 1);
            else if (shifted.location < 0)
            {
                shifted.length = ((shifted).location + (shifted).length);
                shifted.location = 0;
            }
            break;
        }
        if ((range.location += aDelta) < 0)
        {
            self._count -= range.length - ((range).location + (range).length);
            range.length = ((range).location + (range).length);
            range.location = 0;
        }
    }
    if (aDelta < 0)
    {
        var j = i + 1,
            count = self._ranges.length,
            shifts = [];
        for (; j < count; ++j)
        {
            objj_msgSend(shifts, "addObject:", self._ranges[j]);
            self._count -= self._ranges[j].length;
        }
        if ((j = i + 1) < count)
        {
            objj_msgSend(self._ranges, "removeObjectsInRange:", { location:(j), length:count - j });
            for (j = 0, count = shifts.length; j < count; ++j)
                objj_msgSend(self, "addIndexesInRange:", shifts[j]);
        }
        if (shifted.location != CPNotFound)
            objj_msgSend(self, "addIndexesInRange:", shifted);
    }
}
,["void","CPInteger","int"])]);
}
var CPIndexSetCountKey = "CPIndexSetCountKey",
    CPIndexSetRangeStringsKey = "CPIndexSetRangeStringsKey";
{
var the_class = objj_getClass("CPIndexSet")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPIndexSet\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPIndexSet__initWithCoder_(self, _cmd, aCoder)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPIndexSet").super_class }, "init");
    if (self)
    {
        self._count = objj_msgSend(aCoder, "decodeIntForKey:", CPIndexSetCountKey);
        self._ranges = [];
        var rangeStrings = objj_msgSend(aCoder, "decodeObjectForKey:", CPIndexSetRangeStringsKey),
            index = 0,
            count = rangeStrings.length;
        for (; index < count; ++index)
            self._ranges.push(CPRangeFromString(rangeStrings[index]));
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPIndexSet__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeInt:forKey:", self._count, CPIndexSetCountKey);
    var index = 0,
        count = self._ranges.length,
        rangeStrings = [];
    for (; index < count; ++index)
        rangeStrings[index] = CPStringFromRange(self._ranges[index]);
    objj_msgSend(aCoder, "encodeObject:forKey:", rangeStrings, CPIndexSetRangeStringsKey);
}
,["void","CPCoder"])]);
}
{
var the_class = objj_getClass("CPIndexSet")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPIndexSet\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("copy"), function $CPIndexSet__copy(self, _cmd)
{
    return objj_msgSend(objj_msgSend(objj_msgSend(self, "class"), "alloc"), "initWithIndexSet:", self);
}
,["id"]), new objj_method(sel_getUid("mutableCopy"), function $CPIndexSet__mutableCopy(self, _cmd)
{
    return objj_msgSend(objj_msgSend(objj_msgSend(self, "class"), "alloc"), "initWithIndexSet:", self);
}
,["id"])]);
}
{var the_class = objj_allocateClassPair(CPIndexSet, "CPMutableIndexSet"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
}
var positionOfIndex = function(ranges, anIndex)
{
    var low = 0,
        high = ranges.length - 1;
    while (low <= high)
    {
        var middle = FLOOR(low + (high - low) / 2),
            range = ranges[middle];
        if (anIndex < range.location)
            high = middle - 1;
        else if (anIndex >= ((range).location + (range).length))
            low = middle + 1;
        else
            return middle;
   }
   return CPNotFound;
};
var assumedPositionOfIndex = function(ranges, anIndex)
{
    var count = ranges.length;
    if (count <= 0)
        return CPNotFound;
    var low = 0,
        high = count * 2;
    while (low <= high)
    {
        var middle = FLOOR(low + (high - low) / 2),
            position = middle / 2,
            positionFLOOR = FLOOR(position);
        if (position === positionFLOOR)
        {
            if (positionFLOOR - 1 >= 0 && anIndex < ((ranges[positionFLOOR - 1]).location + (ranges[positionFLOOR - 1]).length))
                high = middle - 1;
            else if (positionFLOOR < count && anIndex >= ranges[positionFLOOR].location)
                low = middle + 1;
            else
                return positionFLOOR - 0.5;
        }
        else
        {
            var range = ranges[positionFLOOR];
            if (anIndex < range.location)
                high = middle - 1;
            else if (anIndex >= ((range).location + (range).length))
                low = middle + 1;
            else
                return positionFLOOR;
        }
    }
   return CPNotFound;
};p;14;CPInvocation.jt;3869;@STATIC;1.0;i;10;CPObject.jt;3835;objj_executeFile("CPObject.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPInvocation"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_returnValue"), new objj_ivar("_arguments"), new objj_ivar("_methodSignature")]);










objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithMethodSignature:"), function $CPInvocation__initWithMethodSignature_(self, _cmd, aMethodSignature)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPInvocation").super_class }, "init");
    if (self)
    {
        self._arguments = [];
        self._methodSignature = aMethodSignature;
    }
    return self;
}
,["id","CPMethodSignature"]), new objj_method(sel_getUid("setSelector:"), function $CPInvocation__setSelector_(self, _cmd, aSelector)
{
    self._arguments[1] = aSelector;
}
,["void","SEL"]), new objj_method(sel_getUid("selector"), function $CPInvocation__selector(self, _cmd)
{
    return self._arguments[1];
}
,["SEL"]), new objj_method(sel_getUid("setTarget:"), function $CPInvocation__setTarget_(self, _cmd, aTarget)
{
    self._arguments[0] = aTarget;
}
,["void","id"]), new objj_method(sel_getUid("target"), function $CPInvocation__target(self, _cmd)
{
    return self._arguments[0];
}
,["id"]), new objj_method(sel_getUid("setArgument:atIndex:"), function $CPInvocation__setArgument_atIndex_(self, _cmd, anArgument, anIndex)
{
    self._arguments[anIndex] = anArgument;
}
,["void","id","unsigned"]), new objj_method(sel_getUid("argumentAtIndex:"), function $CPInvocation__argumentAtIndex_(self, _cmd, anIndex)
{
    return self._arguments[anIndex];
}
,["id","unsigned"]), new objj_method(sel_getUid("setReturnValue:"), function $CPInvocation__setReturnValue_(self, _cmd, aReturnValue)
{
    self._returnValue = aReturnValue;
}
,["void","id"]), new objj_method(sel_getUid("returnValue"), function $CPInvocation__returnValue(self, _cmd)
{
    return self._returnValue;
}
,["id"]), new objj_method(sel_getUid("invoke"), function $CPInvocation__invoke(self, _cmd)
{
    self._returnValue = objj_msgSend.apply(objj_msgSend, self._arguments);
}
,["void"]), new objj_method(sel_getUid("invokeWithTarget:"), function $CPInvocation__invokeWithTarget_(self, _cmd, aTarget)
{
    self._arguments[0] = aTarget;
    self._returnValue = objj_msgSend.apply(objj_msgSend, self._arguments);
}
,["void","id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("invocationWithMethodSignature:"), function $CPInvocation__invocationWithMethodSignature_(self, _cmd, aMethodSignature)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithMethodSignature:", aMethodSignature);
}
,["id","CPMethodSignature"])]);
}
var CPInvocationArguments = "CPInvocationArguments",
    CPInvocationReturnValue = "CPInvocationReturnValue";
{
var the_class = objj_getClass("CPInvocation")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPInvocation\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPInvocation__initWithCoder_(self, _cmd, aCoder)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPInvocation").super_class }, "init");
    if (self)
    {
        self._returnValue = objj_msgSend(aCoder, "decodeObjectForKey:", CPInvocationReturnValue);
        self._arguments = objj_msgSend(aCoder, "decodeObjectForKey:", CPInvocationArguments);
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPInvocation__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeObject:forKey:", self._returnValue, CPInvocationReturnValue);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._arguments, CPInvocationArguments);
}
,["void","CPCoder"])]);
}p;23;CPInvocationOperation.jt;2051;@STATIC;1.0;i;14;CPInvocation.ji;10;CPObject.ji;13;CPOperation.jt;1980;objj_executeFile("CPInvocation.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPOperation.j", YES);
{var the_class = objj_allocateClassPair(CPOperation, "CPInvocationOperation"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_invocation")]);




objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("main"), function $CPInvocationOperation__main(self, _cmd)
{
    if (self._invocation)
    {
        objj_msgSend(self._invocation, "invoke");
    }
}
,["void"]), new objj_method(sel_getUid("init"), function $CPInvocationOperation__init(self, _cmd)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPInvocationOperation").super_class }, "init"))
    {
        self._invocation = nil;
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("initWithInvocation:"), function $CPInvocationOperation__initWithInvocation_(self, _cmd, inv)
{
    if (self = objj_msgSend(self, "init"))
    {
        self._invocation = inv;
    }
    return self;
}
,["id","CPInvocation"]), new objj_method(sel_getUid("initWithTarget:selector:object:"), function $CPInvocationOperation__initWithTarget_selector_object_(self, _cmd, target, sel, arg)
{
    var inv = objj_msgSend(objj_msgSend(CPInvocation, "alloc"), "initWithMethodSignature:", nil);
    objj_msgSend(inv, "setTarget:", target);
    objj_msgSend(inv, "setSelector:", sel);
    objj_msgSend(inv, "setArgument:atIndex:", arg, 2);
    return objj_msgSend(self, "initWithInvocation:", inv);
}
,["id","id","SEL","id"]), new objj_method(sel_getUid("invocation"), function $CPInvocationOperation__invocation(self, _cmd)
{
    return self._invocation;
}
,["CPInvocation"]), new objj_method(sel_getUid("result"), function $CPInvocationOperation__result(self, _cmd)
{
    if (objj_msgSend(self, "isFinished") && self._invocation)
    {
        return objj_msgSend(self._invocation, "returnValue");
    }
    return nil;
}
,["id"])]);
}p;19;CPJSONPConnection.jt;5364;@STATIC;1.0;i;13;CPException.ji;10;CPObject.ji;11;CPRunLoop.jt;5296;objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPRunLoop.j", YES);
CPJSONPConnectionCallbacks = {};
CPJSONPCallbackReplacementString = "${JSONP_CALLBACK}";
{var the_class = objj_allocateClassPair(CPObject, "CPJSONPConnection"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_request"), new objj_ivar("_delegate"), new objj_ivar("_callbackParameter"), new objj_ivar("_scriptTag")]);





objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithRequest:callback:delegate:"), function $CPJSONPConnection__initWithRequest_callback_delegate_(self, _cmd, aRequest, aString, aDelegate)
{
    return objj_msgSend(self, "initWithRequest:callback:delegate:startImmediately:", aRequest, aString, aDelegate, NO);
}
,["id","CPURLRequest","CPString","id"]), new objj_method(sel_getUid("initWithRequest:callback:delegate:startImmediately:"), function $CPJSONPConnection__initWithRequest_callback_delegate_startImmediately_(self, _cmd, aRequest, aString, aDelegate, shouldStartImmediately)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPJSONPConnection").super_class }, "init");
    if (self)
    {
        self._request = aRequest;
        self._delegate = aDelegate;
        self._callbackParameter = aString;
        if (!self._callbackParameter && objj_msgSend(objj_msgSend(self._request, "URL"), "absoluteString").indexOf(CPJSONPCallbackReplacementString) < 0)
             objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "JSONP source specified without callback parameter or CPJSONPCallbackReplacementString in URL.");
        if (shouldStartImmediately)
            objj_msgSend(self, "start");
    }
    return self;
}
,["id","CPURLRequest","CPString","id","BOOL"]), new objj_method(sel_getUid("start"), function $CPJSONPConnection__start(self, _cmd)
{
    try
    {
        CPJSONPConnectionCallbacks["callback" + objj_msgSend(self, "UID")] = function(data)
        {
            if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("connection:didReceiveData:")))
                objj_msgSend(self._delegate, "connection:didReceiveData:", self, data);
            if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("connectionDidFinishLoading:")))
                    objj_msgSend(self._delegate, "connectionDidFinishLoading:", self);
            objj_msgSend(self, "removeScriptTag");
            objj_msgSend(objj_msgSend(CPRunLoop, "currentRunLoop"), "limitDateForMode:", CPDefaultRunLoopMode);
        };
        var head = document.getElementsByTagName("head").item(0),
            source = objj_msgSend(objj_msgSend(self._request, "URL"), "absoluteString");
        if (self._callbackParameter)
        {
            source += (source.indexOf('?') < 0) ? "?" : "&";
            source += self._callbackParameter + "=CPJSONPConnectionCallbacks.callback" + objj_msgSend(self, "UID");
        }
        else if (source.indexOf(CPJSONPCallbackReplacementString) >= 0)
        {
            source = objj_msgSend(source, "stringByReplacingOccurrencesOfString:withString:", CPJSONPCallbackReplacementString, "CPJSONPConnectionCallbacks.callback" + objj_msgSend(self, "UID"));
        }
        else
            return;
        self._scriptTag = document.createElement("script");
        self._scriptTag.setAttribute("type", "text/javascript");
        self._scriptTag.setAttribute("charset", "utf-8");
        self._scriptTag.setAttribute("src", source);
        head.appendChild(self._scriptTag);
    }
    catch (exception)
    {
        if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("connection:didFailWithError:")))
            objj_msgSend(self._delegate, "connection:didFailWithError:", self, exception);
        objj_msgSend(self, "removeScriptTag");
    }
}
,["void"]), new objj_method(sel_getUid("removeScriptTag"), function $CPJSONPConnection__removeScriptTag(self, _cmd)
{
    var head = document.getElementsByTagName("head").item(0);
    if (self._scriptTag && self._scriptTag.parentNode == head)
        head.removeChild(self._scriptTag);
    CPJSONPConnectionCallbacks["callback" + objj_msgSend(self, "UID")] = nil;
    delete CPJSONPConnectionCallbacks["callback" + objj_msgSend(self, "UID")];
}
,["void"]), new objj_method(sel_getUid("cancel"), function $CPJSONPConnection__cancel(self, _cmd)
{
    objj_msgSend(self, "removeScriptTag");
}
,["void"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("sendRequest:callback:delegate:"), function $CPJSONPConnection__sendRequest_callback_delegate_(self, _cmd, aRequest, callbackParameter, aDelegate)
{
    return objj_msgSend(self, "connectionWithRequest:callback:delegate:", aRequest, callbackParameter, aDelegate);
}
,["CPJSONPConnection","CPURLRequest","CPString","id"]), new objj_method(sel_getUid("connectionWithRequest:callback:delegate:"), function $CPJSONPConnection__connectionWithRequest_callback_delegate_(self, _cmd, aRequest, callbackParameter, aDelegate)
{
    return objj_msgSend(objj_msgSend(objj_msgSend(self, "class"), "alloc"), "initWithRequest:callback:delegate:startImmediately:", aRequest, callbackParameter, aDelegate, YES);
}
,["CPJSONPConnection","CPURLRequest","CPString","id"])]);
}p;17;CPKeyedArchiver.jt;17073;@STATIC;1.0;i;9;CPArray.ji;9;CPCoder.ji;8;CPData.ji;14;CPDictionary.ji;10;CPNumber.ji;10;CPString.ji;9;CPValue.ji;13;_CGGeometry.jt;16935;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPCoder.j", YES);
objj_executeFile("CPData.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPNumber.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("CPValue.j", YES);
objj_executeFile("_CGGeometry.j", YES);
var CPArchiverReplacementClassNames = nil;
var _CPKeyedArchiverDidEncodeObjectSelector = 1,
    _CPKeyedArchiverWillEncodeObjectSelector = 2,
    _CPKeyedArchiverWillReplaceObjectWithObjectSelector = 4,
    _CPKeyedArchiverDidFinishEncodingSelector = 8,
    _CPKeyedArchiverWillFinishEncodingSelector = 16;
var _CPKeyedArchiverNullString = "$null",
    _CPKeyedArchiverNullReference = nil,
    _CPKeyedArchiverUIDKey = "CP$UID",
    _CPKeyedArchiverTopKey = "$top",
    _CPKeyedArchiverObjectsKey = "$objects",
    _CPKeyedArchiverArchiverKey = "$archiver",
    _CPKeyedArchiverVersionKey = "$version",
    _CPKeyedArchiverClassNameKey = "$classname",
    _CPKeyedArchiverClassesKey = "$classes",
    _CPKeyedArchiverClassKey = "$class";
var _CPKeyedArchiverStringClass = Nil,
    _CPKeyedArchiverNumberClass = Nil;
{var the_class = objj_allocateClassPair(CPValue, "_CPKeyedArchiverValue"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
}
{var the_class = objj_allocateClassPair(CPCoder, "CPKeyedArchiver"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_delegate"), new objj_ivar("_delegateSelectors"), new objj_ivar("_data"), new objj_ivar("_objects"), new objj_ivar("_UIDs"), new objj_ivar("_conditionalUIDs"), new objj_ivar("_replacementObjects"), new objj_ivar("_replacementClassNames"), new objj_ivar("_plistObject"), new objj_ivar("_plistObjects"), new objj_ivar("_outputFormat")]);























objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initForWritingWithMutableData:"), function $CPKeyedArchiver__initForWritingWithMutableData_(self, _cmd, data)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPKeyedArchiver").super_class }, "init");
    if (self)
    {
        self._data = data;
        self._objects = [];
        self._UIDs = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        self._conditionalUIDs = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        self._replacementObjects = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        self._plistObject = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        self._plistObjects = objj_msgSend(CPArray, "arrayWithObject:", _CPKeyedArchiverNullString);
    }
    return self;
}
,["id","CPMutableData"]), new objj_method(sel_getUid("finishEncoding"), function $CPKeyedArchiver__finishEncoding(self, _cmd)
{
    if (self._delegate && self._delegateSelectors & _CPKeyedArchiverDidFinishEncodingSelector)
        objj_msgSend(self._delegate, "archiverWillFinish:", self);
    var i = 0,
        topObject = self._plistObject,
        classes = [];
    for (; i < self._objects.length; ++i)
    {
        var object = self._objects[i];
        self._plistObject = self._plistObjects[objj_msgSend(self._UIDs, "objectForKey:", objj_msgSend(object, "UID"))];
        objj_msgSend(object, "encodeWithCoder:", self);
        if (self._delegate && self._delegateSelectors & _CPKeyedArchiverDidEncodeObjectSelector)
            objj_msgSend(self._delegate, "archiver:didEncodeObject:", self, object);
    }
    self._plistObject = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    objj_msgSend(self._plistObject, "setObject:forKey:", topObject, _CPKeyedArchiverTopKey);
    objj_msgSend(self._plistObject, "setObject:forKey:", self._plistObjects, _CPKeyedArchiverObjectsKey);
    objj_msgSend(self._plistObject, "setObject:forKey:", objj_msgSend(self, "className"), _CPKeyedArchiverArchiverKey);
    objj_msgSend(self._plistObject, "setObject:forKey:", "100000", _CPKeyedArchiverVersionKey);
    objj_msgSend(self._data, "setPlistObject:", self._plistObject);
    if (self._delegate && self._delegateSelectors & _CPKeyedArchiverDidFinishEncodingSelector)
        objj_msgSend(self._delegate, "archiverDidFinish:", self);
}
,["void"]), new objj_method(sel_getUid("outputFormat"), function $CPKeyedArchiver__outputFormat(self, _cmd)
{
    return self._outputFormat;
}
,["CPPropertyListFormat"]), new objj_method(sel_getUid("setOutputFormat:"), function $CPKeyedArchiver__setOutputFormat_(self, _cmd, aPropertyListFormat)
{
    self._outputFormat = aPropertyListFormat;
}
,["void","CPPropertyListFormat"]), new objj_method(sel_getUid("encodeBool:forKey:"), function $CPKeyedArchiver__encodeBool_forKey_(self, _cmd, aBOOL, aKey)
{
    objj_msgSend(self._plistObject, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, aBOOL, NO), aKey);
}
,["void","BOOL","CPString"]), new objj_method(sel_getUid("encodeDouble:forKey:"), function $CPKeyedArchiver__encodeDouble_forKey_(self, _cmd, aDouble, aKey)
{
    objj_msgSend(self._plistObject, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, aDouble, NO), aKey);
}
,["void","double","CPString"]), new objj_method(sel_getUid("encodeFloat:forKey:"), function $CPKeyedArchiver__encodeFloat_forKey_(self, _cmd, aFloat, aKey)
{
    objj_msgSend(self._plistObject, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, aFloat, NO), aKey);
}
,["void","float","CPString"]), new objj_method(sel_getUid("encodeInt:forKey:"), function $CPKeyedArchiver__encodeInt_forKey_(self, _cmd, anInt, aKey)
{
    objj_msgSend(self._plistObject, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, anInt, NO), aKey);
}
,["void","float","CPString"]), new objj_method(sel_getUid("setDelegate:"), function $CPKeyedArchiver__setDelegate_(self, _cmd, aDelegate)
{
    self._delegate = aDelegate;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("archiver:didEncodeObject:")))
        self._delegateSelectors |= _CPKeyedArchiverDidEncodeObjectSelector;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("archiver:willEncodeObject:")))
        self._delegateSelectors |= _CPKeyedArchiverWillEncodeObjectSelector;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("archiver:willReplaceObject:withObject:")))
        self._delegateSelectors |= _CPKeyedArchiverWillReplaceObjectWithObjectSelector;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("archiver:didFinishEncoding:")))
        self._delegateSelectors |= _CPKeyedArchiverDidFinishEncodingSelector;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("archiver:willFinishEncoding:")))
        self._delegateSelectors |= _CPKeyedArchiverWillFinishEncodingSelector;
}
,["void","id"]), new objj_method(sel_getUid("delegate"), function $CPKeyedArchiver__delegate(self, _cmd)
{
    return self._delegate;
}
,["id"]), new objj_method(sel_getUid("encodePoint:forKey:"), function $CPKeyedArchiver__encodePoint_forKey_(self, _cmd, aPoint, aKey)
{
    objj_msgSend(self._plistObject, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, CGStringFromPoint(aPoint), NO), aKey);
}
,["void","CGPoint","CPString"]), new objj_method(sel_getUid("encodeRect:forKey:"), function $CPKeyedArchiver__encodeRect_forKey_(self, _cmd, aRect, aKey)
{
    objj_msgSend(self._plistObject, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, CGStringFromRect(aRect), NO), aKey);
}
,["void","CGRect","CPString"]), new objj_method(sel_getUid("encodeSize:forKey:"), function $CPKeyedArchiver__encodeSize_forKey_(self, _cmd, aSize, aKey)
{
    objj_msgSend(self._plistObject, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, CGStringFromSize(aSize), NO), aKey);
}
,["void","CGSize","CPString"]), new objj_method(sel_getUid("encodeConditionalObject:forKey:"), function $CPKeyedArchiver__encodeConditionalObject_forKey_(self, _cmd, anObject, aKey)
{
    objj_msgSend(self._plistObject, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, anObject, YES), aKey);
}
,["void","id","CPString"]), new objj_method(sel_getUid("encodeNumber:forKey:"), function $CPKeyedArchiver__encodeNumber_forKey_(self, _cmd, aNumber, aKey)
{
    objj_msgSend(self._plistObject, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, aNumber, NO), aKey);
}
,["void","CPNumber","CPString"]), new objj_method(sel_getUid("encodeObject:forKey:"), function $CPKeyedArchiver__encodeObject_forKey_(self, _cmd, anObject, aKey)
{
    objj_msgSend(self._plistObject, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, anObject, NO), aKey);
}
,["void","id","CPString"]), new objj_method(sel_getUid("_encodeArrayOfObjects:forKey:"), function $CPKeyedArchiver___encodeArrayOfObjects_forKey_(self, _cmd, objects, aKey)
{
    var i = 0,
        count = objects.length,
        references = [];
    for (; i < count; ++i)
        objj_msgSend(references, "addObject:", _CPKeyedArchiverEncodeObject(self, objects[i], NO));
    objj_msgSend(self._plistObject, "setObject:forKey:", references, aKey);
}
,["void","CPArray","CPString"]), new objj_method(sel_getUid("_encodeDictionaryOfObjects:forKey:"), function $CPKeyedArchiver___encodeDictionaryOfObjects_forKey_(self, _cmd, aDictionary, aKey)
{
    var key,
        keys = objj_msgSend(aDictionary, "keyEnumerator"),
        references = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    while ((key = objj_msgSend(keys, "nextObject")) !== nil)
        objj_msgSend(references, "setObject:forKey:", _CPKeyedArchiverEncodeObject(self, objj_msgSend(aDictionary, "objectForKey:", key), NO), key);
    objj_msgSend(self._plistObject, "setObject:forKey:", references, aKey);
}
,["void","CPDictionary","CPString"]), new objj_method(sel_getUid("setClassName:forClass:"), function $CPKeyedArchiver__setClassName_forClass_(self, _cmd, aClassName, aClass)
{
    if (!self._replacementClassNames)
        self._replacementClassNames = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    objj_msgSend(self._replacementClassNames, "setObject:forKey:", aClassName, CPStringFromClass(aClass));
}
,["void","CPString","Class"]), new objj_method(sel_getUid("classNameForClass:"), function $CPKeyedArchiver__classNameForClass_(self, _cmd, aClass)
{
    if (!self._replacementClassNames)
        return aClass.name;
    var className = objj_msgSend(self._replacementClassNames, "objectForKey:", CPStringFromClass(aClass));
    return className ? className : aClass.name;
}
,["CPString","Class"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("initialize"), function $CPKeyedArchiver__initialize(self, _cmd)
{
    if (self !== objj_msgSend(CPKeyedArchiver, "class"))
        return;
    _CPKeyedArchiverStringClass = objj_msgSend(CPString, "class");
    _CPKeyedArchiverNumberClass = objj_msgSend(CPNumber, "class");
    _CPKeyedArchiverNullReference = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", 0, _CPKeyedArchiverUIDKey);
}
,["void"]), new objj_method(sel_getUid("allowsKeyedCoding"), function $CPKeyedArchiver__allowsKeyedCoding(self, _cmd)
{
    return YES;
}
,["BOOL"]), new objj_method(sel_getUid("archivedDataWithRootObject:"), function $CPKeyedArchiver__archivedDataWithRootObject_(self, _cmd, anObject)
{
    var data = objj_msgSend(CPData, "dataWithPlistObject:", nil),
        archiver = objj_msgSend(objj_msgSend(self, "alloc"), "initForWritingWithMutableData:", data);
    objj_msgSend(archiver, "encodeObject:forKey:", anObject, "root");
    objj_msgSend(archiver, "finishEncoding");
    return data;
}
,["CPData","id"]), new objj_method(sel_getUid("setClassName:forClass:"), function $CPKeyedArchiver__setClassName_forClass_(self, _cmd, aClassName, aClass)
{
    if (!CPArchiverReplacementClassNames)
        CPArchiverReplacementClassNames = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    objj_msgSend(CPArchiverReplacementClassNames, "setObject:forKey:", aClassName, CPStringFromClass(aClass));
}
,["void","CPString","Class"]), new objj_method(sel_getUid("classNameForClass:"), function $CPKeyedArchiver__classNameForClass_(self, _cmd, aClass)
{
    if (!CPArchiverReplacementClassNames)
        return aClass.name;
    var className = objj_msgSend(CPArchiverReplacementClassNames, "objectForKey:", CPStringFromClass(aClass));
    return className ? className : aClass.name;
}
,["CPString","Class"])]);
}
var _CPKeyedArchiverEncodeObject = function(self, anObject, isConditional)
{
    if (anObject !== nil && anObject !== undefined && !anObject.isa)
        anObject = objj_msgSend(_CPKeyedArchiverValue, "valueWithJSObject:", anObject);
    var GUID = objj_msgSend(anObject, "UID"),
        object = objj_msgSend(self._replacementObjects, "objectForKey:", GUID);
    if (object === nil)
    {
        object = objj_msgSend(anObject, "replacementObjectForKeyedArchiver:", self);
        if (self._delegate)
        {
            if (object !== anObject && self._delegateSelectors & _CPKeyedArchiverWillReplaceObjectWithObjectSelector)
                objj_msgSend(self._delegate, "archiver:willReplaceObject:withObject:", self, anObject, object);
            if (self._delegateSelectors & _CPKeyedArchiverWillEncodeObjectSelector)
            {
                anObject = objj_msgSend(self._delegate, "archiver:willEncodeObject:", self, object);
                if (anObject !== object && self._delegateSelectors & _CPKeyedArchiverWillReplaceObjectWithObjectSelector)
                    objj_msgSend(self._delegate, "archiver:willReplaceObject:withObject:", self, object, anObject);
                object = anObject;
            }
        }
        objj_msgSend(self._replacementObjects, "setObject:forKey:", object, GUID);
    }
    if (object === nil)
        return _CPKeyedArchiverNullReference;
    var UID = objj_msgSend(self._UIDs, "objectForKey:", GUID = objj_msgSend(object, "UID"));
    if (UID === nil)
    {
        if (isConditional)
        {
            if ((UID = objj_msgSend(self._conditionalUIDs, "objectForKey:", GUID)) === nil)
            {
                objj_msgSend(self._conditionalUIDs, "setObject:forKey:", UID = objj_msgSend(self._plistObjects, "count"), GUID);
                objj_msgSend(self._plistObjects, "addObject:", _CPKeyedArchiverNullString);
            }
        }
        else
        {
            var theClass = objj_msgSend(object, "classForKeyedArchiver"),
                plistObject = nil;
            if ((theClass === _CPKeyedArchiverStringClass) || (theClass === _CPKeyedArchiverNumberClass))
                plistObject = object;
            else
            {
                plistObject = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
                objj_msgSend(self._objects, "addObject:", object);
                var className = objj_msgSend(self, "classNameForClass:", theClass);
                if (!className)
                    className = objj_msgSend(objj_msgSend(self, "class"), "classNameForClass:", theClass);
                if (!className)
                    className = theClass.name;
                else
                    theClass = CPClassFromString(className);
                var classUID = objj_msgSend(self._UIDs, "objectForKey:", className);
                if (!classUID)
                {
                    var plistClass = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init"),
                        hierarchy = [];
                    objj_msgSend(plistClass, "setObject:forKey:", className, _CPKeyedArchiverClassNameKey);
                    do
                    {
                        objj_msgSend(hierarchy, "addObject:", CPStringFromClass(theClass));
                    } while (theClass = objj_msgSend(theClass, "superclass"));
                    objj_msgSend(plistClass, "setObject:forKey:", hierarchy, _CPKeyedArchiverClassesKey);
                    classUID = objj_msgSend(self._plistObjects, "count");
                    objj_msgSend(self._plistObjects, "addObject:", plistClass);
                    objj_msgSend(self._UIDs, "setObject:forKey:", classUID, className);
                }
                objj_msgSend(plistObject, "setObject:forKey:", objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", classUID, _CPKeyedArchiverUIDKey), _CPKeyedArchiverClassKey);
            }
            UID = objj_msgSend(self._conditionalUIDs, "objectForKey:", GUID);
            if (UID !== nil)
            {
                objj_msgSend(self._UIDs, "setObject:forKey:", UID, GUID);
                objj_msgSend(self._plistObjects, "replaceObjectAtIndex:withObject:", UID, plistObject);
            }
            else
            {
                objj_msgSend(self._UIDs, "setObject:forKey:", UID = objj_msgSend(self._plistObjects, "count"), GUID);
                objj_msgSend(self._plistObjects, "addObject:", plistObject);
            }
        }
    }
    return objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", UID, _CPKeyedArchiverUIDKey);
};p;19;CPKeyedUnarchiver.jt;14922;@STATIC;1.0;i;9;CPArray.ji;9;CPCoder.ji;8;CPData.ji;14;CPDictionary.ji;13;CPException.ji;17;CPKeyedArchiver.ji;8;CPNull.ji;10;CPNumber.ji;10;CPString.jt;14763;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPCoder.j", YES);
objj_executeFile("CPData.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPKeyedArchiver.j", YES);
objj_executeFile("CPNull.j", YES);
objj_executeFile("CPNumber.j", YES);
objj_executeFile("CPString.j", YES);
CPInvalidUnarchiveOperationException = "CPInvalidUnarchiveOperationException";
var _CPKeyedUnarchiverCannotDecodeObjectOfClassNameOriginalClassesSelector = 1 << 0,
    _CPKeyedUnarchiverDidDecodeObjectSelector = 1 << 1,
    _CPKeyedUnarchiverWillReplaceObjectWithObjectSelector = 1 << 2,
    _CPKeyedUnarchiverWillFinishSelector = 1 << 3,
    _CPKeyedUnarchiverDidFinishSelector = 1 << 4,
    CPKeyedUnarchiverDelegate_unarchiver_cannotDecodeObjectOfClassName_originalClasses_ = 1 << 5;
var _CPKeyedArchiverNullString = "$null",
    _CPKeyedArchiverUIDKey = "CP$UID",
    _CPKeyedArchiverTopKey = "$top",
    _CPKeyedArchiverObjectsKey = "$objects",
    _CPKeyedArchiverArchiverKey = "$archiver",
    _CPKeyedArchiverVersionKey = "$version",
    _CPKeyedArchiverClassNameKey = "$classname",
    _CPKeyedArchiverClassesKey = "$classes",
    _CPKeyedArchiverClassKey = "$class";
var CPArrayClass = Nil,
    CPMutableArrayClass = Nil,
    CPStringClass = Nil,
    CPDictionaryClass = Nil,
    CPMutableDictionaryClass = Nil,
    CPNumberClass = Nil,
    CPDataClass = Nil,
    _CPKeyedArchiverValueClass = Nil;
{var the_class = objj_allocateClassPair(CPCoder, "CPKeyedUnarchiver"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_delegate"), new objj_ivar("_delegateSelectors"), new objj_ivar("_data"), new objj_ivar("_replacementClasses"), new objj_ivar("_objects"), new objj_ivar("_archive"), new objj_ivar("_plistObject"), new objj_ivar("_plistObjects")]);




















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initForReadingWithData:"), function $CPKeyedUnarchiver__initForReadingWithData_(self, _cmd, data)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPKeyedUnarchiver").super_class }, "init");
    if (self)
    {
        self._archive = objj_msgSend(data, "plistObject");
        self._objects = [objj_msgSend(CPNull, "null")];
        self._plistObject = objj_msgSend(self._archive, "objectForKey:", _CPKeyedArchiverTopKey);
        self._plistObjects = objj_msgSend(self._archive, "objectForKey:", _CPKeyedArchiverObjectsKey);
        self._replacementClasses = new CFMutableDictionary();
    }
    return self;
}
,["id","CPData"]), new objj_method(sel_getUid("containsValueForKey:"), function $CPKeyedUnarchiver__containsValueForKey_(self, _cmd, aKey)
{
    return self._plistObject.valueForKey(aKey) != nil;
}
,["BOOL","CPString"]), new objj_method(sel_getUid("_decodeDictionaryOfObjectsForKey:"), function $CPKeyedUnarchiver___decodeDictionaryOfObjectsForKey_(self, _cmd, aKey)
{
    var object = self._plistObject.valueForKey(aKey),
        objectClass = (object != nil) && object.isa;
    if (objectClass === CPDictionaryClass || objectClass === CPMutableDictionaryClass)
    {
        var keys = object.keys(),
            index = 0,
            count = keys.length,
            dictionary = new CFMutableDictionary();
        for (; index < count; ++index)
        {
            var key = keys[index];
            dictionary.setValueForKey(key, _CPKeyedUnarchiverDecodeObjectAtIndex(self, object.valueForKey(key).valueForKey(_CPKeyedArchiverUIDKey)));
        }
        return dictionary;
    }
    return nil;
}
,["CPDictionary","CPString"]), new objj_method(sel_getUid("decodeBoolForKey:"), function $CPKeyedUnarchiver__decodeBoolForKey_(self, _cmd, aKey)
{
    return !!objj_msgSend(self, "decodeObjectForKey:", aKey);
}
,["BOOL","CPString"]), new objj_method(sel_getUid("decodeFloatForKey:"), function $CPKeyedUnarchiver__decodeFloatForKey_(self, _cmd, aKey)
{
    var f = objj_msgSend(self, "decodeObjectForKey:", aKey);
    return f === nil ? 0.0 : f;
}
,["float","CPString"]), new objj_method(sel_getUid("decodeDoubleForKey:"), function $CPKeyedUnarchiver__decodeDoubleForKey_(self, _cmd, aKey)
{
    var d = objj_msgSend(self, "decodeObjectForKey:", aKey);
    return d === nil ? 0.0 : d;
}
,["double","CPString"]), new objj_method(sel_getUid("decodeIntForKey:"), function $CPKeyedUnarchiver__decodeIntForKey_(self, _cmd, aKey)
{
    var i = objj_msgSend(self, "decodeObjectForKey:", aKey);
    return i === nil ? 0 : i;
}
,["int","CPString"]), new objj_method(sel_getUid("decodePointForKey:"), function $CPKeyedUnarchiver__decodePointForKey_(self, _cmd, aKey)
{
    var object = objj_msgSend(self, "decodeObjectForKey:", aKey);
    if (object)
        return CGPointFromString(object);
    else
        return CGPointMakeZero();
}
,["CGPoint","CPString"]), new objj_method(sel_getUid("decodeRectForKey:"), function $CPKeyedUnarchiver__decodeRectForKey_(self, _cmd, aKey)
{
    var object = objj_msgSend(self, "decodeObjectForKey:", aKey);
    if (object)
        return CGRectFromString(object);
    else
        return CGRectMakeZero();
}
,["CGRect","CPString"]), new objj_method(sel_getUid("decodeSizeForKey:"), function $CPKeyedUnarchiver__decodeSizeForKey_(self, _cmd, aKey)
{
    var object = objj_msgSend(self, "decodeObjectForKey:", aKey);
    if (object)
        return CGSizeFromString(object);
    else
        return CGSizeMakeZero();
}
,["CGSize","CPString"]), new objj_method(sel_getUid("decodeObjectForKey:"), function $CPKeyedUnarchiver__decodeObjectForKey_(self, _cmd, aKey)
{
    var object = self._plistObject.valueForKey(aKey),
        objectClass = (object != nil) && object.isa;
    if (objectClass === CPDictionaryClass || objectClass === CPMutableDictionaryClass)
        return _CPKeyedUnarchiverDecodeObjectAtIndex(self, object.valueForKey(_CPKeyedArchiverUIDKey));
    else if (objectClass === CPNumberClass || objectClass === CPDataClass || objectClass === CPStringClass)
        return object;
    else if (objectClass === _CPJavaScriptArray)
    {
        var index = 0,
            count = object.length,
            array = [];
        for (; index < count; ++index)
            array[index] = _CPKeyedUnarchiverDecodeObjectAtIndex(self, object[index].valueForKey(_CPKeyedArchiverUIDKey));
        return array;
    }
    return nil;
}
,["id","CPString"]), new objj_method(sel_getUid("decodeBytesForKey:"), function $CPKeyedUnarchiver__decodeBytesForKey_(self, _cmd, aKey)
{
    var data = objj_msgSend(self, "decodeObjectForKey:", aKey);
    if (!data)
        return nil;
    var objectClass = data.isa;
    if (objectClass === CPDataClass)
        return data.bytes();
    return nil;
}
,["id","CPString"]), new objj_method(sel_getUid("finishDecoding"), function $CPKeyedUnarchiver__finishDecoding(self, _cmd)
{
    if (self._delegateSelectors & _CPKeyedUnarchiverWillFinishSelector)
        objj_msgSend(self._delegate, "unarchiverWillFinish:", self);
    if (self._delegateSelectors & _CPKeyedUnarchiverDidFinishSelector)
        objj_msgSend(self._delegate, "unarchiverDidFinish:", self);
}
,["void"]), new objj_method(sel_getUid("delegate"), function $CPKeyedUnarchiver__delegate(self, _cmd)
{
    return self._delegate;
}
,["id"]), new objj_method(sel_getUid("setDelegate:"), function $CPKeyedUnarchiver__setDelegate_(self, _cmd, aDelegate)
{
    self._delegate = aDelegate;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("unarchiver:cannotDecodeObjectOfClassName:originalClasses:")))
        self._delegateSelectors |= _CPKeyedUnarchiverCannotDecodeObjectOfClassNameOriginalClassesSelector;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("unarchiver:didDecodeObject:")))
        self._delegateSelectors |= _CPKeyedUnarchiverDidDecodeObjectSelector;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("unarchiver:willReplaceObject:withObject:")))
        self._delegateSelectors |= _CPKeyedUnarchiverWillReplaceObjectWithObjectSelector;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("unarchiverWillFinish:")))
        self._delegateSelectors |= _CPKeyedUnarchiverWillFinishSelector;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("unarchiverDidFinish:")))
        self._delegateSelectors |= _CPKeyedUnarchiverDidFinishSelector;
    if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("unarchiver:cannotDecodeObjectOfClassName:originalClasses:")))
        self._delegateSelectors |= CPKeyedUnarchiverDelegate_unarchiver_cannotDecodeObjectOfClassName_originalClasses_;
}
,["void","id"]), new objj_method(sel_getUid("setClass:forClassName:"), function $CPKeyedUnarchiver__setClass_forClassName_(self, _cmd, aClass, aClassName)
{
    self._replacementClasses.setValueForKey(aClassName, aClass);
}
,["void","Class","CPString"]), new objj_method(sel_getUid("classForClassName:"), function $CPKeyedUnarchiver__classForClassName_(self, _cmd, aClassName)
{
    return self._replacementClasses.valueForKey(aClassName);
}
,["Class","CPString"]), new objj_method(sel_getUid("allowsKeyedCoding"), function $CPKeyedUnarchiver__allowsKeyedCoding(self, _cmd)
{
    return YES;
}
,["BOOL"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("initialize"), function $CPKeyedUnarchiver__initialize(self, _cmd)
{
    if (self !== objj_msgSend(CPKeyedUnarchiver, "class"))
        return;
    CPArrayClass = objj_msgSend(CPArray, "class");
    CPMutableArrayClass = objj_msgSend(CPMutableArray, "class");
    CPStringClass = objj_msgSend(CPString, "class");
    CPDictionaryClass = objj_msgSend(CPDictionary, "class");
    CPMutableDictionaryClass = objj_msgSend(CPMutableDictionary, "class");
    CPNumberClass = objj_msgSend(CPNumber, "class");
    CPDataClass = objj_msgSend(CPData, "class");
    _CPKeyedArchiverValueClass = objj_msgSend(_CPKeyedArchiverValue, "class");
}
,["void"]), new objj_method(sel_getUid("unarchiveObjectWithData:"), function $CPKeyedUnarchiver__unarchiveObjectWithData_(self, _cmd, aData)
{
    if (!aData)
    {
        CPLog.error("Null data passed to -[CPKeyedUnarchiver unarchiveObjectWithData:].");
        return nil;
    }
    var unarchiver = objj_msgSend(objj_msgSend(self, "alloc"), "initForReadingWithData:", aData),
        object = objj_msgSend(unarchiver, "decodeObjectForKey:", "root");
    objj_msgSend(unarchiver, "finishDecoding");
    return object;
}
,["id","CPData"]), new objj_method(sel_getUid("unarchiveObjectWithFile:"), function $CPKeyedUnarchiver__unarchiveObjectWithFile_(self, _cmd, aFilePath)
{
}
,["id","CPString"]), new objj_method(sel_getUid("unarchiveObjectWithFile:asynchronously:"), function $CPKeyedUnarchiver__unarchiveObjectWithFile_asynchronously_(self, _cmd, aFilePath, aFlag)
{
}
,["id","CPString","BOOL"])]);
}
var _CPKeyedUnarchiverDecodeObjectAtIndex = function(self, anIndex)
{
    var object = self._objects[anIndex];
    if (object)
    {
        if (object === self._objects[0])
            return nil;
    }
    else
    {
        var plistObject = self._plistObjects[anIndex],
            plistObjectClass = plistObject.isa;
        if (plistObjectClass === CPDictionaryClass || plistObjectClass === CPMutableDictionaryClass)
        {
            var plistClass = self._plistObjects[plistObject.valueForKey(_CPKeyedArchiverClassKey).valueForKey(_CPKeyedArchiverUIDKey)],
                className = plistClass.valueForKey(_CPKeyedArchiverClassNameKey),
                classes = plistClass.valueForKey(_CPKeyedArchiverClassesKey),
                theClass = objj_msgSend(self, "classForClassName:", className);
            if (!theClass)
                theClass = CPClassFromString(className);
            if (!theClass && (self._delegateSelectors & CPKeyedUnarchiverDelegate_unarchiver_cannotDecodeObjectOfClassName_originalClasses_))
                theClass = objj_msgSend(_delegate, "unarchiver:cannotDecodeObjectOfClassName:originalClasses:", self, className, classes);
            if (!theClass)
                objj_msgSend(CPException, "raise:reason:", CPInvalidUnarchiveOperationException, "-[CPKeyedUnarchiver decodeObjectForKey:]: cannot decode object of class (" + className + ")");
            var savedPlistObject = self._plistObject;
            self._plistObject = plistObject;
            object = objj_msgSend(theClass, "allocWithCoder:", self);
            self._objects[anIndex] = object;
            var processedObject = objj_msgSend(object, "initWithCoder:", self);
            self._plistObject = savedPlistObject;
            if (processedObject !== object)
            {
                if (self._delegateSelectors & _CPKeyedUnarchiverWillReplaceObjectWithObjectSelector)
                    objj_msgSend(self._delegate, "unarchiver:willReplaceObject:withObject:", self, object, processedObject);
                object = processedObject;
                self._objects[anIndex] = processedObject;
            }
            processedObject = objj_msgSend(object, "awakeAfterUsingCoder:", self);
            if (processedObject !== object)
            {
                if (self._delegateSelectors & _CPKeyedUnarchiverWillReplaceObjectWithObjectSelector)
                    objj_msgSend(self._delegate, "unarchiver:willReplaceObject:withObject:", self, object, processedObject);
                object = processedObject;
                self._objects[anIndex] = processedObject;
            }
            if (self._delegate)
            {
                if (self._delegateSelectors & _CPKeyedUnarchiverDidDecodeObjectSelector)
                    processedObject = objj_msgSend(self._delegate, "unarchiver:didDecodeObject:", self, object);
                if (processedObject && processedObject != object)
                {
                    if (self._delegateSelectors & _CPKeyedUnarchiverWillReplaceObjectWithObjectSelector)
                        objj_msgSend(self._delegate, "unarchiver:willReplaceObject:withObject:", self, object, processedObject);
                    object = processedObject;
                    self._objects[anIndex] = processedObject;
                }
            }
        }
        else
        {
            self._objects[anIndex] = object = plistObject;
            if (objj_msgSend(object, "class") === CPStringClass)
            {
                if (object === _CPKeyedArchiverNullString)
                {
                    self._objects[anIndex] = self._objects[0];
                    return nil;
                }
                else
                    self._objects[anIndex] = object = plistObject;
            }
        }
    }
    if ((object != nil) && (object.isa === _CPKeyedArchiverValueClass))
        object = objj_msgSend(object, "JSObject");
    return object;
};p;18;CPKeyValueCoding.jt;15765;@STATIC;1.0;i;9;CPArray.ji;14;CPDictionary.ji;13;CPException.ji;12;CPIndexSet.ji;8;CPNull.ji;10;CPObject.ji;7;CPSet.ji;21;CPKeyValueObserving.jt;15614;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPIndexSet.j", YES);
objj_executeFile("CPNull.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPSet.j", YES);
CPUndefinedKeyException = "CPUndefinedKeyException";
CPTargetObjectUserInfoKey = "CPTargetObjectUserInfoKey";
CPUnknownUserInfoKey = "CPUnknownUserInfoKey";
var CPObjectAccessorsForClassKey = "$CPObjectAccessorsForClassKey",
    CPObjectModifiersForClassKey = "$CPObjectModifiersForClassKey";
{
var the_class = objj_getClass("CPObject")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPObject\"");
var meta_class = the_class.isa;








class_addMethods(the_class, [new objj_method(sel_getUid("valueForKey:"), function $CPObject__valueForKey_(self, _cmd, aKey)
{
    var theClass = objj_msgSend(self, "class"),
        accessor = nil,
        accessors = theClass[CPObjectAccessorsForClassKey];
    if (!accessors)
        accessors = theClass[CPObjectAccessorsForClassKey] = { };
    if (accessors.hasOwnProperty(aKey))
        accessor = accessors[aKey];
    else
    {
        var string = nil,
            capitalizedKey = aKey.charAt(0).toUpperCase() + aKey.substr(1),
            underscoreKey = nil,
            isKey = nil;
        if (objj_msgSend(theClass, "instancesRespondToSelector:", string = sel_getUid("get" + capitalizedKey)) ||
            objj_msgSend(theClass, "instancesRespondToSelector:", string = sel_getUid(aKey)) ||
            objj_msgSend(theClass, "instancesRespondToSelector:", string = sel_getUid((isKey = "is" + capitalizedKey))) ||
            objj_msgSend(theClass, "instancesRespondToSelector:", string = sel_getUid("_get" + capitalizedKey)) ||
            objj_msgSend(theClass, "instancesRespondToSelector:", string = sel_getUid((underscoreKey = "_" + aKey))) ||
            objj_msgSend(theClass, "instancesRespondToSelector:", string = sel_getUid("_" + isKey)))
            accessor = accessors[aKey] = [0, string];
        else if (objj_msgSend(theClass, "instancesRespondToSelector:", sel_getUid("countOf" + capitalizedKey)))
        {
            if (objj_msgSend(theClass, "instancesRespondToSelector:", sel_getUid("objectIn" + capitalizedKey + "AtIndex:")) ||
                objj_msgSend(theClass, "instancesRespondToSelector:", sel_getUid(aKey + "AtIndexes:")))
                accessor = accessors[aKey] = [1];
            else if (objj_msgSend(theClass, "instancesRespondToSelector:", sel_getUid("enumeratorOf" + capitalizedKey)) &&
                    objj_msgSend(theClass, "instancesRespondToSelector:", sel_getUid("memberOf" + capitalizedKey + ":")))
                accessor = accessors[aKey] = [2];
        }
        if (!accessor)
        {
            if (class_getInstanceVariable(theClass, string = underscoreKey) ||
                class_getInstanceVariable(theClass, string = "_" + isKey) ||
                class_getInstanceVariable(theClass, string = aKey) ||
                class_getInstanceVariable(theClass, string = isKey))
                accessor = accessors[aKey] = [3, string];
            else
                accessor = accessors[aKey] = [];
        }
    }
    switch (accessor[0])
    {
        case 0:
            return objj_msgSend(self, accessor[1]);
        case 1:
            return objj_msgSend(objj_msgSend(_CPKeyValueCodingArray, "alloc"), "initWithTarget:key:", self, aKey);
        case 2:
            return objj_msgSend(objj_msgSend(_CPKeyValueCodingSet, "alloc"), "initWithTarget:key:", self, aKey);
        case 3:
            if (objj_msgSend(theClass, "accessInstanceVariablesDirectly"))
                return self[accessor[1]];
    }
    return objj_msgSend(self, "valueForUndefinedKey:", aKey);
}
,["id","CPString"]), new objj_method(sel_getUid("valueForKeyPath:"), function $CPObject__valueForKeyPath_(self, _cmd, aKeyPath)
{
    var firstDotIndex = aKeyPath.indexOf(".");
    if (firstDotIndex === CPNotFound)
        return objj_msgSend(self, "valueForKey:", aKeyPath);
    var firstKeyComponent = aKeyPath.substring(0, firstDotIndex),
        remainingKeyPath = aKeyPath.substring(firstDotIndex + 1),
        value = objj_msgSend(self, "valueForKey:", firstKeyComponent);
    return objj_msgSend(value, "valueForKeyPath:", remainingKeyPath);
}
,["id","CPString"]), new objj_method(sel_getUid("dictionaryWithValuesForKeys:"), function $CPObject__dictionaryWithValuesForKeys_(self, _cmd, keys)
{
    var index = 0,
        count = keys.length,
        dictionary = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    for (; index < count; ++index)
    {
        var key = keys[index],
            value = objj_msgSend(self, "valueForKey:", key);
        if (value === nil)
            objj_msgSend(dictionary, "setObject:forKey:", objj_msgSend(CPNull, "null"), key);
        else
            objj_msgSend(dictionary, "setObject:forKey:", value, key);
    }
    return dictionary;
}
,["CPDictionary","CPArray"]), new objj_method(sel_getUid("valueForUndefinedKey:"), function $CPObject__valueForUndefinedKey_(self, _cmd, aKey)
{
    objj_msgSend(objj_msgSend(CPException, "exceptionWithName:reason:userInfo:", CPUndefinedKeyException, objj_msgSend(self, "_objectDescription") + " is not key value coding-compliant for the key " + aKey, objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", self, CPTargetObjectUserInfoKey, aKey, CPUnknownUserInfoKey)), "raise");
}
,["id","CPString"]), new objj_method(sel_getUid("setValue:forKeyPath:"), function $CPObject__setValue_forKeyPath_(self, _cmd, aValue, aKeyPath)
{
    if (!aKeyPath)
        aKeyPath = "self";
    var firstDotIndex = aKeyPath.indexOf(".");
    if (firstDotIndex === CPNotFound)
        return objj_msgSend(self, "setValue:forKey:", aValue, aKeyPath);
    var firstKeyComponent = aKeyPath.substring(0, firstDotIndex),
        remainingKeyPath = aKeyPath.substring(firstDotIndex + 1),
        value = objj_msgSend(self, "valueForKey:", firstKeyComponent);
    return objj_msgSend(value, "setValue:forKeyPath:", aValue, remainingKeyPath);
}
,["void","id","CPString"]), new objj_method(sel_getUid("setValue:forKey:"), function $CPObject__setValue_forKey_(self, _cmd, aValue, aKey)
{
    var theClass = objj_msgSend(self, "class"),
        modifier = nil,
        modifiers = theClass[CPObjectModifiersForClassKey];
    if (!modifiers)
        modifiers = theClass[CPObjectModifiersForClassKey] = { };
    if (modifiers.hasOwnProperty(aKey))
        modifier = modifiers[aKey];
    else
    {
        var string = nil,
            capitalizedKey = aKey.charAt(0).toUpperCase() + aKey.substr(1),
            isKey = nil;
        if (objj_msgSend(theClass, "instancesRespondToSelector:", string = sel_getUid("set" + capitalizedKey + ":")) ||
            objj_msgSend(theClass, "instancesRespondToSelector:", string = sel_getUid("_set" + capitalizedKey + ":")))
            modifier = modifiers[aKey] = [0, string];
        else if (class_getInstanceVariable(theClass, string = "_" + aKey) ||
            class_getInstanceVariable(theClass, string = "_" + (isKey = "is" + capitalizedKey)) ||
            class_getInstanceVariable(theClass, string = aKey) ||
            class_getInstanceVariable(theClass, string = isKey))
            modifier = modifiers[aKey] = [1, string];
        else
            modifier = modifiers[aKey] = [];
    }
    switch (modifier[0])
    {
        case 0: return objj_msgSend(self, modifier[1], aValue);
        case 1: if (objj_msgSend(theClass, "accessInstanceVariablesDirectly"))
                    {
                        objj_msgSend(self, "willChangeValueForKey:", aKey);
                        self[modifier[1]] = aValue;
                        return objj_msgSend(self, "didChangeValueForKey:", aKey);
                    }
    }
    return objj_msgSend(self, "setValue:forUndefinedKey:", aValue, aKey);
}
,["void","id","CPString"]), new objj_method(sel_getUid("setValuesForKeysWithDictionary:"), function $CPObject__setValuesForKeysWithDictionary_(self, _cmd, keyedValues)
{
    var value,
        key,
        keyEnumerator = objj_msgSend(keyedValues, "keyEnumerator");
    while ((key = objj_msgSend(keyEnumerator, "nextObject")) !== nil)
    {
        value = objj_msgSend(keyedValues, "objectForKey:", key);
        if (value === objj_msgSend(CPNull, "null"))
            objj_msgSend(self, "setValue:forKey:", nil, key);
        else
            objj_msgSend(self, "setValue:forKey:", value, key);
    }
}
,["void","CPDictionary"]), new objj_method(sel_getUid("setValue:forUndefinedKey:"), function $CPObject__setValue_forUndefinedKey_(self, _cmd, aValue, aKey)
{
    objj_msgSend(objj_msgSend(CPException, "exceptionWithName:reason:userInfo:", CPUndefinedKeyException, objj_msgSend(self, "_objectDescription") + " is not key value coding-compliant for the key " + aKey, objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", self, CPTargetObjectUserInfoKey, aKey, CPUnknownUserInfoKey)), "raise");
}
,["void","id","CPString"]), new objj_method(sel_getUid("_objectDescription"), function $CPObject___objectDescription(self, _cmd)
{
    return "<" + objj_msgSend(self, "className") + " 0x" + objj_msgSend(CPString, "stringWithHash:", objj_msgSend(self, "UID")) + ">";
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("accessInstanceVariablesDirectly"), function $CPObject__accessInstanceVariablesDirectly(self, _cmd)
{
    return YES;
}
,["BOOL"])]);
}
{
var the_class = objj_getClass("CPDictionary")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPDictionary\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("valueForKey:"), function $CPDictionary__valueForKey_(self, _cmd, aKey)
{
    if (objj_msgSend(aKey, "hasPrefix:", "@"))
        return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPDictionary").super_class }, "valueForKey:", aKey.substr(1));
    return objj_msgSend(self, "objectForKey:", aKey);
}
,["id","CPString"]), new objj_method(sel_getUid("setValue:forKey:"), function $CPDictionary__setValue_forKey_(self, _cmd, aValue, aKey)
{
    if (aValue !== nil)
        objj_msgSend(self, "setObject:forKey:", aValue, aKey);
    else
        objj_msgSend(self, "removeObjectForKey:", aKey);
}
,["void","id","CPString"])]);
}
{
var the_class = objj_getClass("CPNull")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPNull\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("valueForKey:"), function $CPNull__valueForKey_(self, _cmd, aKey)
{
    return self;
}
,["id","CPString"])]);
}
{var the_class = objj_allocateClassPair(CPArray, "_CPKeyValueCodingArray"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_target"), new objj_ivar("_countOfSelector"), new objj_ivar("_objectInAtIndexSelector"), new objj_ivar("_atIndexesSelector")]);




objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithTarget:key:"), function $_CPKeyValueCodingArray__initWithTarget_key_(self, _cmd, aTarget, aKey)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPKeyValueCodingArray").super_class }, "init");
    if (self)
    {
        var capitalizedKey = aKey.charAt(0).toUpperCase() + aKey.substr(1);
        self._target = aTarget;
        self._countOfSelector = CPSelectorFromString("countOf" + capitalizedKey);
        self._objectInAtIndexSelector = CPSelectorFromString("objectIn" + capitalizedKey + "AtIndex:");
        if (!objj_msgSend(self._target, "respondsToSelector:", self._objectInAtIndexSelector))
            self._objectInAtIndexSelector = nil;
        self._atIndexesSelector = CPSelectorFromString(aKey + "AtIndexes:");
        if (!objj_msgSend(self._target, "respondsToSelector:", self._atIndexesSelector))
            self._atIndexesSelector = nil;
    }
    return self;
}
,["id","id","CPString"]), new objj_method(sel_getUid("count"), function $_CPKeyValueCodingArray__count(self, _cmd)
{
    return objj_msgSend(self._target, self._countOfSelector);
}
,["CPUInteger"]), new objj_method(sel_getUid("objectAtIndex:"), function $_CPKeyValueCodingArray__objectAtIndex_(self, _cmd, anIndex)
{
    if (self._objectInAtIndexSelector)
        return objj_msgSend(self._target, self._objectInAtIndexSelector, anIndex);
    return objj_msgSend(self._target, self._atIndexesSelector, objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex))[0];
}
,["id","CPUInteger"]), new objj_method(sel_getUid("objectsAtIndexes:"), function $_CPKeyValueCodingArray__objectsAtIndexes_(self, _cmd, indexes)
{
    if (self._atIndexesSelector)
        return objj_msgSend(self._target, self._atIndexesSelector, indexes);
    return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPKeyValueCodingArray").super_class }, "objectsAtIndexes:", indexes);
}
,["CPArray","CPIndexSet"]), new objj_method(sel_getUid("classForCoder"), function $_CPKeyValueCodingArray__classForCoder(self, _cmd)
{
    return objj_msgSend(CPArray, "class");
}
,["Class"]), new objj_method(sel_getUid("copy"), function $_CPKeyValueCodingArray__copy(self, _cmd)
{
    return objj_msgSend(CPArray, "arrayWithArray:", self);
}
,["id"])]);
}
{var the_class = objj_allocateClassPair(CPSet, "_CPKeyValueCodingSet"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_target"), new objj_ivar("_countOfSelector"), new objj_ivar("_enumeratorOfSelector"), new objj_ivar("_memberOfSelector")]);





objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithObjects:count:"), function $_CPKeyValueCodingSet__initWithObjects_count_(self, _cmd, objects, aCount)
{
    return objj_msgSend(objj_msgSend(CPSet, "alloc"), "initWithObjects:count:", objects, aCount);
}
,["id","CPArray","CPUInteger"]), new objj_method(sel_getUid("initWithTarget:key:"), function $_CPKeyValueCodingSet__initWithTarget_key_(self, _cmd, aTarget, aKey)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPKeyValueCodingSet").super_class }, "initWithObjects:count:", nil, 0);
    if (self)
    {
        var capitalizedKey = aKey.charAt(0).toUpperCase() + aKey.substr(1);
        self._target = aTarget;
        self._countOfSelector = CPSelectorFromString("countOf" + capitalizedKey);
        self._enumeratorOfSelector = CPSelectorFromString("enumeratorOf" + capitalizedKey);
        self._memberOfSelector = CPSelectorFromString("memberOf" + capitalizedKey + ":");
    }
    return self;
}
,["id","id","CPString"]), new objj_method(sel_getUid("count"), function $_CPKeyValueCodingSet__count(self, _cmd)
{
    return objj_msgSend(self._target, self._countOfSelector);
}
,["CPUInteger"]), new objj_method(sel_getUid("objectEnumerator"), function $_CPKeyValueCodingSet__objectEnumerator(self, _cmd)
{
    return objj_msgSend(self._target, self._enumeratorOfSelector);
}
,["CPEnumerator"]), new objj_method(sel_getUid("member:"), function $_CPKeyValueCodingSet__member_(self, _cmd, anObject)
{
    return objj_msgSend(self._target, self._memberOfSelector, anObject);
}
,["id","id"]), new objj_method(sel_getUid("classForCoder"), function $_CPKeyValueCodingSet__classForCoder(self, _cmd)
{
    return objj_msgSend(CPSet, "class");
}
,["Class"]), new objj_method(sel_getUid("copy"), function $_CPKeyValueCodingSet__copy(self, _cmd)
{
    return objj_msgSend(CPSet, "setWithSet:", self);
}
,["id"])]);
}
objj_executeFile("CPKeyValueObserving.j", YES);p;21;CPKeyValueObserving.jt;47545;@STATIC;1.0;i;9;CPArray.ji;14;CPDictionary.ji;13;CPException.ji;12;CPIndexSet.ji;8;CPNull.ji;10;CPObject.ji;7;CPSet.ji;13;CPArray+KVO.ji;11;CPSet+KVO.jt;47386;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPIndexSet.j", YES);
objj_executeFile("CPNull.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPSet.j", YES);
{
var the_class = objj_getClass("CPObject")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPObject\"");
var meta_class = the_class.isa;









class_addMethods(the_class, [new objj_method(sel_getUid("willChangeValueForKey:"), function $CPObject__willChangeValueForKey_(self, _cmd, aKey)
{
    if (!aKey)
        return;
    if (!self[KVOProxyKey])
    {
        if (!self._willChangeMessageCounter)
            self._willChangeMessageCounter = new Object();
        if (!self._willChangeMessageCounter[aKey])
            self._willChangeMessageCounter[aKey] = 1;
        else
            self._willChangeMessageCounter[aKey] += 1;
    }
}
,["void","CPString"]), new objj_method(sel_getUid("didChangeValueForKey:"), function $CPObject__didChangeValueForKey_(self, _cmd, aKey)
{
    if (!aKey)
        return;
    if (!self[KVOProxyKey])
    {
        if (self._willChangeMessageCounter && self._willChangeMessageCounter[aKey])
        {
            self._willChangeMessageCounter[aKey] -= 1;
            if (!self._willChangeMessageCounter[aKey])
                delete self._willChangeMessageCounter[aKey];
        }
        else
            objj_msgSend(CPException, "raise:reason:", "CPKeyValueObservingException", "'didChange...' message called without prior call of 'willChange...'");
    }
}
,["void","CPString"]), new objj_method(sel_getUid("willChange:valuesAtIndexes:forKey:"), function $CPObject__willChange_valuesAtIndexes_forKey_(self, _cmd, aChange, indexes, aKey)
{
    if (!aKey)
        return;
    if (!self[KVOProxyKey])
    {
        if (!self._willChangeMessageCounter)
            self._willChangeMessageCounter = new Object();
        if (!self._willChangeMessageCounter[aKey])
            self._willChangeMessageCounter[aKey] = 1;
        else
            self._willChangeMessageCounter[aKey] += 1;
    }
}
,["void","CPKeyValueChange","CPIndexSet","CPString"]), new objj_method(sel_getUid("didChange:valuesAtIndexes:forKey:"), function $CPObject__didChange_valuesAtIndexes_forKey_(self, _cmd, aChange, indexes, aKey)
{
    if (!aKey)
        return;
    if (!self[KVOProxyKey])
    {
        if (self._willChangeMessageCounter && self._willChangeMessageCounter[aKey])
        {
            self._willChangeMessageCounter[aKey] -= 1;
            if (!self._willChangeMessageCounter[aKey])
                delete self._willChangeMessageCounter[aKey];
        }
        else
            objj_msgSend(CPException, "raise:reason:", "CPKeyValueObservingException", "'didChange...' message called without prior call of 'willChange...'");
    }
}
,["void","CPKeyValueChange","CPIndexSet","CPString"]), new objj_method(sel_getUid("willChangeValueForKey:withSetMutation:usingObjects:"), function $CPObject__willChangeValueForKey_withSetMutation_usingObjects_(self, _cmd, aKey, aMutationKind, objects)
{
    if (!aKey)
        return;
    if (!self[KVOProxyKey])
    {
        if (!self._willChangeMessageCounter)
            self._willChangeMessageCounter = new Object();
        if (!self._willChangeMessageCounter[aKey])
            self._willChangeMessageCounter[aKey] = 1;
        else
            self._willChangeMessageCounter[aKey] += 1;
    }
}
,["void","CPString","CPKeyValueSetMutationKind","CPSet"]), new objj_method(sel_getUid("didChangeValueForKey:withSetMutation:usingObjects:"), function $CPObject__didChangeValueForKey_withSetMutation_usingObjects_(self, _cmd, aKey, aMutationKind, objects)
{
    if (!self[KVOProxyKey])
    {
        if (self._willChangeMessageCounter && self._willChangeMessageCounter[aKey])
        {
            self._willChangeMessageCounter[aKey] -= 1;
            if (!self._willChangeMessageCounter[aKey])
                delete self._willChangeMessageCounter[aKey];
        }
        else
            objj_msgSend(CPException, "raise:reason:", "CPKeyValueObservingException", "'didChange...' message called without prior call of 'willChange...'");
    }
}
,["void","CPString","CPKeyValueSetMutationKind","CPSet"]), new objj_method(sel_getUid("addObserver:forKeyPath:options:context:"), function $CPObject__addObserver_forKeyPath_options_context_(self, _cmd, anObserver, aPath, options, aContext)
{
    if (!anObserver || !aPath)
        return;
    objj_msgSend(objj_msgSend(_CPKVOProxy, "proxyForObject:", self), "_addObserver:forKeyPath:options:context:", anObserver, aPath, options, aContext);
}
,["void","id","CPString","unsigned","id"]), new objj_method(sel_getUid("removeObserver:forKeyPath:"), function $CPObject__removeObserver_forKeyPath_(self, _cmd, anObserver, aPath)
{
    if (!anObserver || !aPath)
        return;
    objj_msgSend(self[KVOProxyKey], "_removeObserver:forKeyPath:", anObserver, aPath);
}
,["void","id","CPString"]), new objj_method(sel_getUid("applyChange:toKeyPath:"), function $CPObject__applyChange_toKeyPath_(self, _cmd, aChange, aKeyPath)
{
    var changeKind = objj_msgSend(aChange, "objectForKey:", CPKeyValueChangeKindKey),
        oldValue = objj_msgSend(aChange, "objectForKey:", CPKeyValueChangeOldKey),
        newValue = objj_msgSend(aChange, "objectForKey:", CPKeyValueChangeNewKey);
    if (newValue === objj_msgSend(CPNull, "null"))
        newValue = nil;
    if (changeKind === CPKeyValueChangeSetting)
        return objj_msgSend(self, "setValue:forKeyPath:", newValue, aKeyPath);
    var indexes = objj_msgSend(aChange, "objectForKey:", CPKeyValueChangeIndexesKey);
    if (indexes)
    {
        if (changeKind === CPKeyValueChangeInsertion)
            objj_msgSend(objj_msgSend(self, "mutableArrayValueForKeyPath:", aKeyPath), "insertObjects:atIndexes:", newValue, indexes);
        else if (changeKind === CPKeyValueChangeRemoval)
            objj_msgSend(objj_msgSend(self, "mutableArrayValueForKeyPath:", aKeyPath), "removeObjectsAtIndexes:", indexes);
        else if (changeKind === CPKeyValueChangeReplacement)
            objj_msgSend(objj_msgSend(self, "mutableArrayValueForKeyPath:", aKeyPath), "replaceObjectAtIndexes:withObjects:", indexes, newValue);
    }
    else
    {
        if (changeKind === CPKeyValueChangeInsertion)
            objj_msgSend(objj_msgSend(self, "mutableSetValueForKeyPath:", aKeyPath), "unionSet:", newValue);
        else if (changeKind === CPKeyValueChangeRemoval)
            objj_msgSend(objj_msgSend(self, "mutableSetValueForKeyPath:", aKeyPath), "minusSet:", oldValue);
        else if (changeKind === CPKeyValueChangeReplacement)
            objj_msgSend(objj_msgSend(self, "mutableSetValueForKeyPath:", aKeyPath), "setSet:", newValue);
    }
}
,["void","CPDictionary","CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("automaticallyNotifiesObserversForKey:"), function $CPObject__automaticallyNotifiesObserversForKey_(self, _cmd, aKey)
{
    var capitalizedKey = aKey.charAt(0).toUpperCase() + aKey.substring(1),
        selector = "automaticallyNotifiesObserversOf" + capitalizedKey;
    if (objj_msgSend(objj_msgSend(self, "class"), "respondsToSelector:", selector))
        return objj_msgSend(objj_msgSend(self, "class"), selector);
    return YES;
}
,["BOOL","CPString"]), new objj_method(sel_getUid("keyPathsForValuesAffectingValueForKey:"), function $CPObject__keyPathsForValuesAffectingValueForKey_(self, _cmd, aKey)
{
    var capitalizedKey = aKey.charAt(0).toUpperCase() + aKey.substring(1),
        selector = "keyPathsForValuesAffecting" + capitalizedKey;
    if (objj_msgSend(objj_msgSend(self, "class"), "respondsToSelector:", selector))
        return objj_msgSend(objj_msgSend(self, "class"), selector);
    return objj_msgSend(CPSet, "set");
}
,["CPSet","CPString"])]);
}
{
var the_class = objj_getClass("CPDictionary")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPDictionary\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("inverseChangeDictionary"), function $CPDictionary__inverseChangeDictionary(self, _cmd)
{
    var inverseChangeDictionary = objj_msgSend(self, "mutableCopy"),
        changeKind = objj_msgSend(self, "objectForKey:", CPKeyValueChangeKindKey);
    if (changeKind === CPKeyValueChangeSetting || changeKind === CPKeyValueChangeReplacement)
    {
        objj_msgSend(inverseChangeDictionary, "setObject:forKey:", objj_msgSend(self, "objectForKey:", CPKeyValueChangeOldKey), CPKeyValueChangeNewKey);
        objj_msgSend(inverseChangeDictionary, "setObject:forKey:", objj_msgSend(self, "objectForKey:", CPKeyValueChangeNewKey), CPKeyValueChangeOldKey);
    }
    else if (changeKind === CPKeyValueChangeInsertion)
    {
        objj_msgSend(inverseChangeDictionary, "setObject:forKey:", CPKeyValueChangeRemoval, CPKeyValueChangeKindKey);
        objj_msgSend(inverseChangeDictionary, "setObject:forKey:", objj_msgSend(self, "objectForKey:", CPKeyValueChangeNewKey), CPKeyValueChangeOldKey);
        objj_msgSend(inverseChangeDictionary, "removeObjectForKey:", CPKeyValueChangeNewKey);
    }
    else if (changeKind === CPKeyValueChangeRemoval)
    {
        objj_msgSend(inverseChangeDictionary, "setObject:forKey:", CPKeyValueChangeInsertion, CPKeyValueChangeKindKey);
        objj_msgSend(inverseChangeDictionary, "setObject:forKey:", objj_msgSend(self, "objectForKey:", CPKeyValueChangeOldKey), CPKeyValueChangeNewKey);
        objj_msgSend(inverseChangeDictionary, "removeObjectForKey:", CPKeyValueChangeOldKey);
    }
    return inverseChangeDictionary;
}
,["CPDictionary"])]);
}
CPKeyValueObservingOptionNew = 1 << 0;
CPKeyValueObservingOptionOld = 1 << 1;
CPKeyValueObservingOptionInitial = 1 << 2;
CPKeyValueObservingOptionPrior = 1 << 3;
CPKeyValueChangeKindKey = "CPKeyValueChangeKindKey";
CPKeyValueChangeNewKey = "CPKeyValueChangeNewKey";
CPKeyValueChangeOldKey = "CPKeyValueChangeOldKey";
CPKeyValueChangeIndexesKey = "CPKeyValueChangeIndexesKey";
CPKeyValueChangeNotificationIsPriorKey = "CPKeyValueChangeNotificationIsPriorKey";
CPKeyValueChangeSetting = 1;
CPKeyValueChangeInsertion = 2;
CPKeyValueChangeRemoval = 3;
CPKeyValueChangeReplacement = 4;
CPKeyValueUnionSetMutation = 1;
CPKeyValueMinusSetMutation = 2;
CPKeyValueIntersectSetMutation = 3;
CPKeyValueSetSetMutation = 4;
_CPKeyValueChangeSetMutationObjectsKey = "_CPKeyValueChangeSetMutationObjectsKey";
_CPKeyValueChangeSetMutationKindKey = "_CPKeyValueChangeSetMutationKindKey";
_CPKeyValueChangeSetMutationNewValueKey = "_CPKeyValueChangeSetMutationNewValueKey";
var _changeKindForSetMutationKind = function(mutationKind)
{
    switch (mutationKind)
    {
        case CPKeyValueUnionSetMutation: return CPKeyValueChangeInsertion;
        case CPKeyValueMinusSetMutation: return CPKeyValueChangeRemoval;
        case CPKeyValueIntersectSetMutation: return CPKeyValueChangeRemoval;
        case CPKeyValueSetSetMutation: return CPKeyValueChangeReplacement;
    }
};
var kvoNewAndOld = CPKeyValueObservingOptionNew | CPKeyValueObservingOptionOld,
    DependentKeysKey = "$KVODEPENDENT",
    KVOProxyKey = "$KVOPROXY";
{var the_class = objj_allocateClassPair(CPObject, "_CPKVOProxy"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_targetObject"), new objj_ivar("_nativeClass"), new objj_ivar("_changesForKey"), new objj_ivar("_nestingForKey"), new objj_ivar("_observersForKey"), new objj_ivar("_observersForKeyLength"), new objj_ivar("_replacedKeys")]);






objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithTarget:"), function $_CPKVOProxy__initWithTarget_(self, _cmd, aTarget)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPKVOProxy").super_class }, "init"))
    {
        self._targetObject = aTarget;
        self._nativeClass = objj_msgSend(aTarget, "class");
        self._observersForKey = {};
        self._changesForKey = {};
        self._nestingForKey = {};
        self._observersForKeyLength = 0;
        objj_msgSend(self, "_replaceClass");
        aTarget[KVOProxyKey] = self;
    }
    return self;
}
,["id","id"]), new objj_method(sel_getUid("_replaceClass"), function $_CPKVOProxy___replaceClass(self, _cmd)
{
    var currentClass = self._nativeClass,
        kvoClassName = "$KVO_" + class_getName(self._nativeClass),
        existingKVOClass = objj_lookUpClass(kvoClassName);
    if (existingKVOClass)
    {
        self._targetObject.isa = existingKVOClass;
        self._replacedKeys = existingKVOClass._replacedKeys;
        return;
    }
    var kvoClass = objj_allocateClassPair(currentClass, kvoClassName);
    objj_registerClassPair(kvoClass);
    self._replacedKeys = objj_msgSend(CPSet, "set");
    kvoClass._replacedKeys = self._replacedKeys;
    var methods = class_copyMethodList(_CPKVOModelSubclass);
    if (objj_msgSend(self._targetObject, "isKindOfClass:", objj_msgSend(CPDictionary, "class")))
        methods = methods.concat(class_copyMethodList(_CPKVOModelDictionarySubclass));
    class_addMethods(kvoClass, methods);
    self._targetObject.isa = kvoClass;
}
,["void"]), new objj_method(sel_getUid("_replaceModifiersForKey:"), function $_CPKVOProxy___replaceModifiersForKey_(self, _cmd, aKey)
{
    if (objj_msgSend(self._replacedKeys, "containsObject:", aKey) || !objj_msgSend(self._nativeClass, "automaticallyNotifiesObserversForKey:", aKey))
        return;
    objj_msgSend(self._replacedKeys, "addObject:", aKey);
    var theClass = self._nativeClass,
        KVOClass = self._targetObject.isa,
        capitalizedKey = aKey.charAt(0).toUpperCase() + aKey.substring(1);
    var setKey_selector = sel_getUid("set" + capitalizedKey + ":"),
        setKey_method = class_getInstanceMethod(theClass, setKey_selector);
    if (setKey_method)
    {
        var setKey_method_imp = setKey_method.method_imp;
        class_addMethod(KVOClass, setKey_selector, function(self, _cmd, anObject)
        {
            objj_msgSend(self, "willChangeValueForKey:", aKey);
            setKey_method_imp(self, _cmd, anObject);
            objj_msgSend(self, "didChangeValueForKey:", aKey);
        }, "");
    }
    var _setKey_selector = sel_getUid("_set" + capitalizedKey + ":"),
        _setKey_method = class_getInstanceMethod(theClass, _setKey_selector);
    if (_setKey_method)
    {
        var _setKey_method_imp = _setKey_method.method_imp;
        class_addMethod(KVOClass, _setKey_selector, function(self, _cmd, anObject)
        {
            objj_msgSend(self, "willChangeValueForKey:", aKey);
            _setKey_method_imp(self, _cmd, anObject);
            objj_msgSend(self, "didChangeValueForKey:", aKey);
        }, "");
    }
    var insertObject_inKeyAtIndex_selector = sel_getUid("insertObject:in" + capitalizedKey + "AtIndex:"),
        insertObject_inKeyAtIndex_method =
            class_getInstanceMethod(theClass, insertObject_inKeyAtIndex_selector),
        insertKey_atIndexes_selector = sel_getUid("insert" + capitalizedKey + ":atIndexes:"),
        insertKey_atIndexes_method =
            class_getInstanceMethod(theClass, insertKey_atIndexes_selector),
        removeObjectFromKeyAtIndex_selector = sel_getUid("removeObjectFrom" + capitalizedKey + "AtIndex:"),
        removeObjectFromKeyAtIndex_method =
            class_getInstanceMethod(theClass, removeObjectFromKeyAtIndex_selector),
        removeKeyAtIndexes_selector = sel_getUid("remove" + capitalizedKey + "AtIndexes:"),
        removeKeyAtIndexes_method = class_getInstanceMethod(theClass, removeKeyAtIndexes_selector);
    if ((insertObject_inKeyAtIndex_method || insertKey_atIndexes_method) &&
        (removeObjectFromKeyAtIndex_method || removeKeyAtIndexes_method))
    {
        if (insertObject_inKeyAtIndex_method)
        {
            var insertObject_inKeyAtIndex_method_imp = insertObject_inKeyAtIndex_method.method_imp;
            class_addMethod(KVOClass, insertObject_inKeyAtIndex_selector, function(self, _cmd, anObject, anIndex)
            {
                objj_msgSend(self, "willChange:valuesAtIndexes:forKey:", CPKeyValueChangeInsertion, objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex), aKey);
                insertObject_inKeyAtIndex_method_imp(self, _cmd, anObject, anIndex);
                objj_msgSend(self, "didChange:valuesAtIndexes:forKey:", CPKeyValueChangeInsertion, objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex), aKey);
            }, "");
        }
        if (insertKey_atIndexes_method)
        {
            var insertKey_atIndexes_method_imp = insertKey_atIndexes_method.method_imp;
            class_addMethod(KVOClass, insertKey_atIndexes_selector, function(self, _cmd, objects, indexes)
            {
                objj_msgSend(self, "willChange:valuesAtIndexes:forKey:", CPKeyValueChangeInsertion, objj_msgSend(indexes, "copy"), aKey);
                insertKey_atIndexes_method_imp(self, _cmd, objects, indexes);
                objj_msgSend(self, "didChange:valuesAtIndexes:forKey:", CPKeyValueChangeInsertion, objj_msgSend(indexes, "copy"), aKey);
            }, "");
        }
        if (removeObjectFromKeyAtIndex_method)
        {
            var removeObjectFromKeyAtIndex_method_imp = removeObjectFromKeyAtIndex_method.method_imp;
            class_addMethod(KVOClass, removeObjectFromKeyAtIndex_selector, function(self, _cmd, anIndex)
            {
                objj_msgSend(self, "willChange:valuesAtIndexes:forKey:", CPKeyValueChangeRemoval, objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex), aKey);
                removeObjectFromKeyAtIndex_method_imp(self, _cmd, anIndex);
                objj_msgSend(self, "didChange:valuesAtIndexes:forKey:", CPKeyValueChangeRemoval, objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex), aKey);
            }, "");
        }
        if (removeKeyAtIndexes_method)
        {
            var removeKeyAtIndexes_method_imp = removeKeyAtIndexes_method.method_imp;
            class_addMethod(KVOClass, removeKeyAtIndexes_selector, function(self, _cmd, indexes)
            {
                objj_msgSend(self, "willChange:valuesAtIndexes:forKey:", CPKeyValueChangeRemoval, objj_msgSend(indexes, "copy"), aKey);
                removeKeyAtIndexes_method_imp(self, _cmd, indexes);
                objj_msgSend(self, "didChange:valuesAtIndexes:forKey:", CPKeyValueChangeRemoval, objj_msgSend(indexes, "copy"), aKey);
            }, "");
        }
        var replaceObjectInKeyAtIndex_withObject_selector =
                sel_getUid("replaceObjectIn" + capitalizedKey + "AtIndex:withObject:"),
            replaceObjectInKeyAtIndex_withObject_method =
                class_getInstanceMethod(theClass, replaceObjectInKeyAtIndex_withObject_selector);
        if (replaceObjectInKeyAtIndex_withObject_method)
        {
            var replaceObjectInKeyAtIndex_withObject_method_imp =
                    replaceObjectInKeyAtIndex_withObject_method.method_imp;
            class_addMethod(KVOClass, replaceObjectInKeyAtIndex_withObject_selector,
            function(self, _cmd, anIndex, anObject)
            {
                objj_msgSend(self, "willChange:valuesAtIndexes:forKey:", CPKeyValueChangeReplacement, objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex), aKey);
                replaceObjectInKeyAtIndex_withObject_method_imp(self, _cmd, anIndex, anObject);
                objj_msgSend(self, "didChange:valuesAtIndexes:forKey:", CPKeyValueChangeReplacement, objj_msgSend(CPIndexSet, "indexSetWithIndex:", anIndex), aKey);
            }, "");
        }
        var replaceKeyAtIndexes_withKey_selector =
                sel_getUid("replace" + capitalizedKey + "AtIndexes:with" + capitalizedKey + ":"),
            replaceKeyAtIndexes_withKey_method =
                class_getInstanceMethod(theClass, replaceKeyAtIndexes_withKey_selector);
        if (replaceKeyAtIndexes_withKey_method)
        {
            var replaceKeyAtIndexes_withKey_method_imp = replaceKeyAtIndexes_withKey_method.method_imp;
            class_addMethod(KVOClass, replaceKeyAtIndexes_withKey_selector, function(self, _cmd, indexes, objects)
            {
                objj_msgSend(self, "willChange:valuesAtIndexes:forKey:", CPKeyValueChangeReplacement, objj_msgSend(indexes, "copy"), aKey);
                replaceObjectInKeyAtIndex_withObject_method_imp(self, _cmd, indexes, objects);
                objj_msgSend(self, "didChange:valuesAtIndexes:forKey:", CPKeyValueChangeReplacement, objj_msgSend(indexes, "copy"), aKey);
            }, "");
        }
    }
    var addKeyObject_selector = sel_getUid("add" + capitalizedKey + "Object:"),
        addKeyObject_method = class_getInstanceMethod(theClass, addKeyObject_selector),
        addKey_selector = sel_getUid("add" + capitalizedKey + ":"),
        addKey_method = class_getInstanceMethod(theClass, addKey_selector),
        removeKeyObject_selector = sel_getUid("remove" + capitalizedKey + "Object:"),
        removeKeyObject_method = class_getInstanceMethod(theClass, removeKeyObject_selector),
        removeKey_selector = sel_getUid("remove" + capitalizedKey + ":"),
        removeKey_method = class_getInstanceMethod(theClass, removeKey_selector);
    if ((addKeyObject_method || addKey_method) && (removeKeyObject_method || removeKey_method))
    {
        if (addKeyObject_method)
        {
            var addKeyObject_method_imp = addKeyObject_method.method_imp;
            class_addMethod(KVOClass, addKeyObject_selector, function(self, _cmd, anObject)
            {
                objj_msgSend(self, "willChangeValueForKey:withSetMutation:usingObjects:", aKey, CPKeyValueUnionSetMutation, objj_msgSend(CPSet, "setWithObject:", anObject));
                addKeyObject_method_imp(self, _cmd, anObject);
                objj_msgSend(self, "didChangeValueForKey:withSetMutation:usingObjects:", aKey, CPKeyValueUnionSetMutation, objj_msgSend(CPSet, "setWithObject:", anObject));
            }, "");
        }
        if (addKey_method)
        {
            var addKey_method_imp = addKey_method.method_imp;
            class_addMethod(KVOClass, addKey_selector, function(self, _cmd, objects)
            {
                objj_msgSend(self, "willChangeValueForKey:withSetMutation:usingObjects:", aKey, CPKeyValueUnionSetMutation, objj_msgSend(objects, "copy"));
                addKey_method_imp(self, _cmd, objects);
                objj_msgSend(self, "didChangeValueForKey:withSetMutation:usingObjects:", aKey, CPKeyValueUnionSetMutation, objj_msgSend(objects, "copy"));
            }, "");
        }
        if (removeKeyObject_method)
        {
            var removeKeyObject_method_imp = removeKeyObject_method.method_imp;
            class_addMethod(KVOClass, removeKeyObject_selector, function(self, _cmd, anObject)
            {
                objj_msgSend(self, "willChangeValueForKey:withSetMutation:usingObjects:", aKey, CPKeyValueMinusSetMutation, objj_msgSend(CPSet, "setWithObject:", anObject));
                removeKeyObject_method_imp(self, _cmd, anObject);
                objj_msgSend(self, "didChangeValueForKey:withSetMutation:usingObjects:", aKey, CPKeyValueMinusSetMutation, objj_msgSend(CPSet, "setWithObject:", anObject));
            }, "");
        }
        if (removeKey_method)
        {
            var removeKey_method_imp = removeKey_method.method_imp;
            class_addMethod(KVOClass, removeKey_selector, function(self, _cmd, objects)
            {
                objj_msgSend(self, "willChangeValueForKey:withSetMutation:usingObjects:", aKey, CPKeyValueMinusSetMutation, objj_msgSend(objects, "copy"));
                removeKey_method_imp(self, _cmd, objects);
                objj_msgSend(self, "didChangeValueForKey:withSetMutation:usingObjects:", aKey, CPKeyValueMinusSetMutation, objj_msgSend(objects, "copy"));
            }, "");
        }
        var intersectKey_selector = sel_getUid("intersect" + capitalizedKey + ":"),
            intersectKey_method = class_getInstanceMethod(theClass, intersectKey_selector);
        if (intersectKey_method)
        {
            var intersectKey_method_imp = intersectKey_method.method_imp;
            class_addMethod(KVOClass, intersectKey_selector, function(self, _cmd, aSet)
            {
                objj_msgSend(self, "willChangeValueForKey:withSetMutation:usingObjects:", aKey, CPKeyValueIntersectSetMutation, objj_msgSend(aSet, "copy"));
                intersectKey_method_imp(self, _cmd, aSet);
                objj_msgSend(self, "didChangeValueForKey:withSetMutation:usingObjects:", aKey, CPKeyValueIntersectSetMutation, objj_msgSend(aSet, "copy"));
            }, "");
        }
    }
    var affectingKeys = objj_msgSend(objj_msgSend(self._nativeClass, "keyPathsForValuesAffectingValueForKey:", aKey), "allObjects"),
        affectingKeysCount = affectingKeys ? affectingKeys.length : 0;
    if (!affectingKeysCount)
        return;
    var dependentKeysForClass = self._nativeClass[DependentKeysKey];
    if (!dependentKeysForClass)
    {
        dependentKeysForClass = {};
        self._nativeClass[DependentKeysKey] = dependentKeysForClass;
    }
    while (affectingKeysCount--)
    {
        var affectingKey = affectingKeys[affectingKeysCount],
            affectedKeys = dependentKeysForClass[affectingKey];
        if (!affectedKeys)
        {
            affectedKeys = objj_msgSend(CPSet, "new");
            dependentKeysForClass[affectingKey] = affectedKeys;
        }
        objj_msgSend(affectedKeys, "addObject:", aKey);
        if (affectingKey.indexOf(".") !== -1)
            objj_msgSend(self._targetObject, "addObserver:forKeyPath:options:context:", self, affectingKey, CPKeyValueObservingOptionPrior | kvoNewAndOld, nil);
        else
            objj_msgSend(self, "_replaceModifiersForKey:", affectingKey);
    }
}
,["void","CPString"]), new objj_method(sel_getUid("observeValueForKeyPath:ofObject:change:context:"), function $_CPKVOProxy__observeValueForKeyPath_ofObject_change_context_(self, _cmd, theKeyPath, theObject, theChanges, theContext)
{
    var dependentKeysForClass = self._nativeClass[DependentKeysKey],
        dependantKeys = objj_msgSend(dependentKeysForClass[theKeyPath], "allObjects");
    var isBeforeFlag = !!objj_msgSend(theChanges, "objectForKey:", CPKeyValueChangeNotificationIsPriorKey);
    for (var i = 0; i < objj_msgSend(dependantKeys, "count"); i++)
    {
        var dependantKey = objj_msgSend(dependantKeys, "objectAtIndex:", i);
        objj_msgSend(self, "_sendNotificationsForKey:changeOptions:isBefore:", dependantKey, theChanges, isBeforeFlag);
    }
}
,["void","CPString","id","CPDictionary","id"]), new objj_method(sel_getUid("_addObserver:forKeyPath:options:context:"), function $_CPKVOProxy___addObserver_forKeyPath_options_context_(self, _cmd, anObserver, aPath, options, aContext)
{
    if (!anObserver)
        return;
    var forwarder = nil;
    if (aPath.indexOf('.') !== CPNotFound && aPath.charAt(0) !== '@')
        forwarder = objj_msgSend(objj_msgSend(_CPKVOForwardingObserver, "alloc"), "initWithKeyPath:object:observer:options:context:", aPath, self._targetObject, anObserver, options, aContext);
    else
        objj_msgSend(self, "_replaceModifiersForKey:", aPath);
    var observers = self._observersForKey[aPath];
    if (!observers)
    {
        observers = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        self._observersForKey[aPath] = observers;
        self._observersForKeyLength++;
    }
    objj_msgSend(observers, "setObject:forKey:", _CPKVOInfoMake(anObserver, options, aContext, forwarder), objj_msgSend(anObserver, "UID"));
    if (options & CPKeyValueObservingOptionInitial)
    {
        var newValue = objj_msgSend(self._targetObject, "valueForKeyPath:", aPath);
        if (newValue === nil || newValue === undefined)
            newValue = objj_msgSend(CPNull, "null");
        var changes = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", newValue, CPKeyValueChangeNewKey);
        objj_msgSend(anObserver, "observeValueForKeyPath:ofObject:change:context:", aPath, self._targetObject, changes, aContext);
    }
}
,["void","id","CPString","unsigned","id"]), new objj_method(sel_getUid("_removeObserver:forKeyPath:"), function $_CPKVOProxy___removeObserver_forKeyPath_(self, _cmd, anObserver, aPath)
{
    var observers = self._observersForKey[aPath];
    if (!observers)
    {
        CPLog.warn("Cannot remove an observer %@ for the key path \"%@\" from %@ because it is not registered as an observer.",
            self._targetObject, aPath, anObserver);
        return;
    }
    if (aPath.indexOf('.') != CPNotFound)
    {
        var observer = objj_msgSend(observers, "objectForKey:", objj_msgSend(anObserver, "UID")),
            forwarder = observer ? observer.forwarder : nil;
        objj_msgSend(forwarder, "finalize");
    }
    objj_msgSend(observers, "removeObjectForKey:", objj_msgSend(anObserver, "UID"));
    if (!objj_msgSend(observers, "count"))
    {
        self._observersForKeyLength--;
        delete self._observersForKey[aPath];
    }
    if (!self._observersForKeyLength)
    {
        self._targetObject.isa = self._nativeClass;
        delete self._targetObject[KVOProxyKey];
    }
}
,["void","id","CPString"]), new objj_method(sel_getUid("_sendNotificationsForKey:changeOptions:isBefore:"), function $_CPKVOProxy___sendNotificationsForKey_changeOptions_isBefore_(self, _cmd, aKey, changeOptions, isBefore)
{
    var changes = self._changesForKey[aKey];
    if (isBefore)
    {
        if (changes)
        {
            var level = self._nestingForKey[aKey];
            if (!level)
                objj_msgSend(CPException, "raise:reason:", CPInternalInconsistencyException, "_changesForKey without _nestingForKey");
            self._nestingForKey[aKey] = level + 1;
            return;
        }
        self._nestingForKey[aKey] = 1;
        changes = changeOptions;
        var indexes = objj_msgSend(changes, "objectForKey:", CPKeyValueChangeIndexesKey),
            setMutationKind = changes[_CPKeyValueChangeSetMutationKindKey];
        if (setMutationKind)
        {
            var setMutationObjects = objj_msgSend(changes[_CPKeyValueChangeSetMutationObjectsKey], "copy"),
                setExistingObjects = objj_msgSend(objj_msgSend(self._targetObject, "valueForKey:", aKey), "copy");
            if (setMutationKind == CPKeyValueMinusSetMutation)
            {
                objj_msgSend(setExistingObjects, "intersectSet:", setMutationObjects);
                objj_msgSend(changes, "setValue:forKey:", setExistingObjects, CPKeyValueChangeOldKey);
            }
            else if (setMutationKind === CPKeyValueIntersectSetMutation || setMutationKind === CPKeyValueSetSetMutation)
            {
                objj_msgSend(setExistingObjects, "minusSet:", setMutationObjects);
                objj_msgSend(changes, "setValue:forKey:", setExistingObjects, CPKeyValueChangeOldKey);
            }
            if (setMutationKind === CPKeyValueUnionSetMutation || setMutationKind === CPKeyValueSetSetMutation)
            {
                objj_msgSend(setMutationObjects, "minusSet:", setExistingObjects);
                changes[_CPKeyValueChangeSetMutationNewValueKey] = setMutationObjects;
            }
        }
        else if (indexes)
        {
            var type = objj_msgSend(changes, "objectForKey:", CPKeyValueChangeKindKey);
            if (type === CPKeyValueChangeReplacement || type === CPKeyValueChangeRemoval)
            {
                var newValues = objj_msgSend(objj_msgSend(self._targetObject, "mutableArrayValueForKeyPath:", aKey), "objectsAtIndexes:", indexes);
                objj_msgSend(changes, "setValue:forKey:", newValues, CPKeyValueChangeOldKey);
            }
        }
        else
        {
            var oldValue = objj_msgSend(self._targetObject, "valueForKey:", aKey);
            if (oldValue === nil || oldValue === undefined)
                oldValue = objj_msgSend(CPNull, "null");
            objj_msgSend(changes, "setObject:forKey:", oldValue, CPKeyValueChangeOldKey);
        }
        objj_msgSend(changes, "setObject:forKey:", 1, CPKeyValueChangeNotificationIsPriorKey);
        self._changesForKey[aKey] = changes;
    }
    else
    {
        var level = self._nestingForKey[aKey];
        if (!changes || !level)
        {
            if (self._targetObject._willChangeMessageCounter && self._targetObject._willChangeMessageCounter[aKey])
            {
                self._targetObject._willChangeMessageCounter[aKey] -= 1;
                if (!self._targetObject._willChangeMessageCounter[aKey])
                    delete self._targetObject._willChangeMessageCounter[aKey];
                return;
            }
            else
                objj_msgSend(CPException, "raise:reason:", "CPKeyValueObservingException", "'didChange...' message called without prior call of 'willChange...'");
        }
        self._nestingForKey[aKey] = level - 1;
        if (level - 1 > 0)
        {
            return;
        }
        delete self._nestingForKey[aKey];
        objj_msgSend(changes, "removeObjectForKey:", CPKeyValueChangeNotificationIsPriorKey);
        var indexes = objj_msgSend(changes, "objectForKey:", CPKeyValueChangeIndexesKey),
            setMutationKind = changes[_CPKeyValueChangeSetMutationKindKey];
        if (setMutationKind)
        {
            var newValue = changes[_CPKeyValueChangeSetMutationNewValueKey];
            objj_msgSend(changes, "setValue:forKey:", newValue, CPKeyValueChangeNewKey);
            delete changes[_CPKeyValueChangeSetMutationNewValueKey];
            delete changes[_CPKeyValueChangeSetMutationObjectsKey];
            delete changes[_CPKeyValueChangeSetMutationKindKey];
        }
        else if (indexes)
        {
            var type = objj_msgSend(changes, "objectForKey:", CPKeyValueChangeKindKey);
            if (type == CPKeyValueChangeReplacement || type == CPKeyValueChangeInsertion)
            {
                var newValues = objj_msgSend(objj_msgSend(self._targetObject, "mutableArrayValueForKeyPath:", aKey), "objectsAtIndexes:", indexes);
                objj_msgSend(changes, "setValue:forKey:", newValues, CPKeyValueChangeNewKey);
            }
        }
        else
        {
            var newValue = objj_msgSend(self._targetObject, "valueForKey:", aKey);
            if (newValue === nil || newValue === undefined)
                newValue = objj_msgSend(CPNull, "null");
            objj_msgSend(changes, "setObject:forKey:", newValue, CPKeyValueChangeNewKey);
        }
        delete self._changesForKey[aKey];
    }
    var observers = objj_msgSend(self._observersForKey[aKey], "allValues"),
        count = observers ? observers.length : 0;
    while (count--)
    {
        var observerInfo = observers[count];
        if (!isBefore || (observerInfo.options & CPKeyValueObservingOptionPrior))
            objj_msgSend(observerInfo.observer, "observeValueForKeyPath:ofObject:change:context:", aKey, self._targetObject, changes, observerInfo.context);
    }
    var dependentKeysMap = self._nativeClass[DependentKeysKey];
    if (!dependentKeysMap)
        return;
    var dependentKeyPaths = objj_msgSend(dependentKeysMap[aKey], "allObjects");
    if (!dependentKeyPaths)
        return;
    var index = 0,
        count = objj_msgSend(dependentKeyPaths, "count");
    for (; index < count; ++index)
    {
        var keyPath = dependentKeyPaths[index];
        objj_msgSend(self, "_sendNotificationsForKey:changeOptions:isBefore:", keyPath, isBefore ? objj_msgSend(changeOptions, "copy") : self._changesForKey[keyPath], isBefore);
    }
}
,["void","CPString","CPDictionary","BOOL"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("proxyForObject:"), function $_CPKVOProxy__proxyForObject_(self, _cmd, anObject)
{
    var proxy = anObject[KVOProxyKey];
    if (proxy)
        return proxy;
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithTarget:", anObject);
}
,["id","CPObject"])]);
}
{var the_class = objj_allocateClassPair(Nil, "_CPKVOModelSubclass"),
meta_class = the_class.isa;









objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("willChangeValueForKey:"), function $_CPKVOModelSubclass__willChangeValueForKey_(self, _cmd, aKey)
{
    var superClass = objj_msgSend(self, "class"),
        methodSelector = sel_getUid("willChangeValueForKey:"),
        methodImp = class_getMethodImplementation(superClass, methodSelector);
    methodImp(self, methodSelector, aKey);
    if (!aKey)
        return;
    var changeOptions = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", CPKeyValueChangeSetting, CPKeyValueChangeKindKey);
    objj_msgSend(objj_msgSend(_CPKVOProxy, "proxyForObject:", self), "_sendNotificationsForKey:changeOptions:isBefore:", aKey, changeOptions, YES);
}
,["void","CPString"]), new objj_method(sel_getUid("didChangeValueForKey:"), function $_CPKVOModelSubclass__didChangeValueForKey_(self, _cmd, aKey)
{
    var superClass = objj_msgSend(self, "class"),
        methodSelector = sel_getUid("didChangeValueForKey:"),
        methodImp = class_getMethodImplementation(superClass, methodSelector);
    methodImp(self, methodSelector, aKey);
    if (!aKey)
        return;
    objj_msgSend(objj_msgSend(_CPKVOProxy, "proxyForObject:", self), "_sendNotificationsForKey:changeOptions:isBefore:", aKey, nil, NO);
}
,["void","CPString"]), new objj_method(sel_getUid("willChange:valuesAtIndexes:forKey:"), function $_CPKVOModelSubclass__willChange_valuesAtIndexes_forKey_(self, _cmd, change, indexes, aKey)
{
    var superClass = objj_msgSend(self, "class"),
        methodSelector = sel_getUid("willChange:valuesAtIndexes:forKey:"),
        methodImp = class_getMethodImplementation(superClass, methodSelector);
    methodImp(self, methodSelector, change, indexes, aKey);
    if (!aKey)
        return;
    var changeOptions = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", change, CPKeyValueChangeKindKey, indexes, CPKeyValueChangeIndexesKey);
    objj_msgSend(objj_msgSend(_CPKVOProxy, "proxyForObject:", self), "_sendNotificationsForKey:changeOptions:isBefore:", aKey, changeOptions, YES);
}
,["void","CPKeyValueChange","CPIndexSet","CPString"]), new objj_method(sel_getUid("didChange:valuesAtIndexes:forKey:"), function $_CPKVOModelSubclass__didChange_valuesAtIndexes_forKey_(self, _cmd, change, indexes, aKey)
{
    var superClass = objj_msgSend(self, "class"),
        methodSelector = sel_getUid("didChange:valuesAtIndexes:forKey:"),
        methodImp = class_getMethodImplementation(superClass, methodSelector);
    methodImp(self, methodSelector, change, indexes, aKey);
    if (!aKey)
        return;
    objj_msgSend(objj_msgSend(_CPKVOProxy, "proxyForObject:", self), "_sendNotificationsForKey:changeOptions:isBefore:", aKey, nil, NO);
}
,["void","CPKeyValueChange","CPIndexSet","CPString"]), new objj_method(sel_getUid("willChangeValueForKey:withSetMutation:usingObjects:"), function $_CPKVOModelSubclass__willChangeValueForKey_withSetMutation_usingObjects_(self, _cmd, aKey, mutationKind, objects)
{
    var superClass = objj_msgSend(self, "class"),
        methodSelector = sel_getUid("willChangeValueForKey:withSetMutation:usingObjects:"),
        methodImp = class_getMethodImplementation(superClass, methodSelector);
    methodImp(self, methodSelector, aKey, mutationKind, objects);
    if (!aKey)
        return;
    var changeKind = _changeKindForSetMutationKind(mutationKind),
        changeOptions = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", changeKind, CPKeyValueChangeKindKey);
    changeOptions[_CPKeyValueChangeSetMutationObjectsKey] = objects;
    changeOptions[_CPKeyValueChangeSetMutationKindKey] = mutationKind;
    objj_msgSend(objj_msgSend(_CPKVOProxy, "proxyForObject:", self), "_sendNotificationsForKey:changeOptions:isBefore:", aKey, changeOptions, YES);
}
,["void","CPString","CPKeyValueSetMutationKind","CPSet"]), new objj_method(sel_getUid("didChangeValueForKey:withSetMutation:usingObjects:"), function $_CPKVOModelSubclass__didChangeValueForKey_withSetMutation_usingObjects_(self, _cmd, aKey, mutationKind, objects)
{
    var superClass = objj_msgSend(self, "class"),
        methodSelector = sel_getUid("didChangeValueForKey:withSetMutation:usingObjects:"),
        methodImp = class_getMethodImplementation(superClass, methodSelector);
    methodImp(self, methodSelector, aKey, mutationKind, objects);
    if (!aKey)
        return;
    objj_msgSend(objj_msgSend(_CPKVOProxy, "proxyForObject:", self), "_sendNotificationsForKey:changeOptions:isBefore:", aKey, nil, NO);
}
,["void","CPString","CPKeyValueSetMutationKind","CPSet"]), new objj_method(sel_getUid("class"), function $_CPKVOModelSubclass__class(self, _cmd)
{
    return self[KVOProxyKey]._nativeClass;
}
,["Class"]), new objj_method(sel_getUid("superclass"), function $_CPKVOModelSubclass__superclass(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "class"), "superclass");
}
,["Class"]), new objj_method(sel_getUid("isKindOfClass:"), function $_CPKVOModelSubclass__isKindOfClass_(self, _cmd, aClass)
{
    return objj_msgSend(objj_msgSend(self, "class"), "isSubclassOfClass:", aClass);
}
,["BOOL","Class"]), new objj_method(sel_getUid("isMemberOfClass:"), function $_CPKVOModelSubclass__isMemberOfClass_(self, _cmd, aClass)
{
    return objj_msgSend(self, "class") == aClass;
}
,["BOOL","Class"]), new objj_method(sel_getUid("className"), function $_CPKVOModelSubclass__className(self, _cmd)
{
    return objj_msgSend(self, "class").name;
}
,["CPString"])]);
}
{var the_class = objj_allocateClassPair(Nil, "_CPKVOModelDictionarySubclass"),
meta_class = the_class.isa;

objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("removeAllObjects"), function $_CPKVOModelDictionarySubclass__removeAllObjects(self, _cmd)
{
    var keys = objj_msgSend(self, "allKeys"),
        count = objj_msgSend(keys, "count"),
        i = 0;
    for (; i < count; i++)
        objj_msgSend(self, "willChangeValueForKey:", keys[i]);
    var superClass = objj_msgSend(self, "class"),
        methodSelector = sel_getUid("removeAllObjects"),
        methodImp = class_getMethodImplementation(superClass, methodSelector);
    methodImp(self, methodSelector);
    for (i = 0; i < count; i++)
        objj_msgSend(self, "didChangeValueForKey:", keys[i]);
}
,["void"]), new objj_method(sel_getUid("removeObjectForKey:"), function $_CPKVOModelDictionarySubclass__removeObjectForKey_(self, _cmd, aKey)
{
    objj_msgSend(self, "willChangeValueForKey:", aKey);
    var superClass = objj_msgSend(self, "class"),
        methodSelector = sel_getUid("removeObjectForKey:"),
        methodImp = class_getMethodImplementation(superClass, methodSelector);
    methodImp(self, methodSelector, aKey);
    objj_msgSend(self, "didChangeValueForKey:", aKey);
}
,["void","id"]), new objj_method(sel_getUid("setObject:forKey:"), function $_CPKVOModelDictionarySubclass__setObject_forKey_(self, _cmd, anObject, aKey)
{
    objj_msgSend(self, "willChangeValueForKey:", aKey);
    var superClass = objj_msgSend(self, "class"),
        methodSelector = sel_getUid("setObject:forKey:"),
        methodImp = class_getMethodImplementation(superClass, methodSelector);
    methodImp(self, methodSelector, anObject, aKey);
    objj_msgSend(self, "didChangeValueForKey:", aKey);
}
,["void","id","id"])]);
}
{var the_class = objj_allocateClassPair(CPObject, "_CPKVOForwardingObserver"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_object"), new objj_ivar("_observer"), new objj_ivar("_context"), new objj_ivar("_options"), new objj_ivar("_firstPart"), new objj_ivar("_secondPart"), new objj_ivar("_value")]);

objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithKeyPath:object:observer:options:context:"), function $_CPKVOForwardingObserver__initWithKeyPath_object_observer_options_context_(self, _cmd, aKeyPath, anObject, anObserver, options, aContext)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPKVOForwardingObserver").super_class }, "init");
    self._context = aContext;
    self._observer = anObserver;
    self._object = anObject;
    self._options = options;
    var dotIndex = aKeyPath.indexOf('.');
    if (dotIndex === CPNotFound)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "Created _CPKVOForwardingObserver without compound key path: " + aKeyPath);
    self._firstPart = aKeyPath.substring(0, dotIndex);
    self._secondPart = aKeyPath.substring(dotIndex + 1);
    objj_msgSend(self._object, "addObserver:forKeyPath:options:context:", self, self._firstPart, self._options, nil);
    self._value = objj_msgSend(self._object, "valueForKey:", self._firstPart);
    if (self._value)
        objj_msgSend(self._value, "addObserver:forKeyPath:options:context:", self, self._secondPart, self._options, nil);
    return self;
}
,["id","CPString","id","id","unsigned","id"]), new objj_method(sel_getUid("observeValueForKeyPath:ofObject:change:context:"), function $_CPKVOForwardingObserver__observeValueForKeyPath_ofObject_change_context_(self, _cmd, aKeyPath, anObject, changes, aContext)
{
    if (aKeyPath === self._firstPart)
    {
        var oldValue = objj_msgSend(self._value, "valueForKeyPath:", self._secondPart),
            newValue = objj_msgSend(self._object, "valueForKeyPath:", self._firstPart + "." + self._secondPart),
            pathChanges = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", newValue ? newValue : objj_msgSend(CPNull, "null"), CPKeyValueChangeNewKey, oldValue ? oldValue : objj_msgSend(CPNull, "null"), CPKeyValueChangeOldKey, CPKeyValueChangeSetting, CPKeyValueChangeKindKey);
        objj_msgSend(self._observer, "observeValueForKeyPath:ofObject:change:context:", self._firstPart + "." + self._secondPart, self._object, pathChanges, self._context);
        if (self._value)
            objj_msgSend(self._value, "removeObserver:forKeyPath:", self, self._secondPart);
        self._value = objj_msgSend(self._object, "valueForKey:", self._firstPart);
        if (self._value)
            objj_msgSend(self._value, "addObserver:forKeyPath:options:context:", self, self._secondPart, self._options, nil);
    }
    else
    {
        objj_msgSend(self._observer, "observeValueForKeyPath:ofObject:change:context:", self._firstPart + "." + aKeyPath, self._object, changes, self._context);
    }
}
,["void","CPString","id","CPDictionary","id"]), new objj_method(sel_getUid("finalize"), function $_CPKVOForwardingObserver__finalize(self, _cmd)
{
    if (self._value)
        objj_msgSend(self._value, "removeObserver:forKeyPath:", self, self._secondPart);
    objj_msgSend(self._object, "removeObserver:forKeyPath:", self, self._firstPart);
    self._object = nil;
    self._observer = nil;
    self._context = nil;
    self._value = nil;
}
,["void"])]);
}
var _CPKVOInfoMake = _CPKVOInfoMake = function(anObserver, theOptions, aContext, aForwarder)
{
    return {
        observer: anObserver,
        options: theOptions,
        context: aContext,
        forwarder: aForwarder
    };
};
objj_executeFile("CPArray+KVO.j", YES);
objj_executeFile("CPSet+KVO.j", YES);p;7;CPLog.jt;21;@STATIC;1.0;t;5;


1;p;16;CPNotification.jt;2208;@STATIC;1.0;i;13;CPException.ji;10;CPObject.jt;2156;objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPNotification"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_name"), new objj_ivar("_object"), new objj_ivar("_userInfo")]);





objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPNotification__init(self, _cmd)
{
    objj_msgSend(CPException, "raise:reason:", CPUnsupportedMethodException, "CPNotification's init method should not be used");
}
,["id"]), new objj_method(sel_getUid("initWithName:object:userInfo:"), function $CPNotification__initWithName_object_userInfo_(self, _cmd, aNotificationName, anObject, aUserInfo)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPNotification").super_class }, "init");
    if (self)
    {
        self._name = aNotificationName;
        self._object = anObject;
        self._userInfo = aUserInfo;
    }
    return self;
}
,["id","CPString","id","CPDictionary"]), new objj_method(sel_getUid("name"), function $CPNotification__name(self, _cmd)
{
    return self._name;
}
,["CPString"]), new objj_method(sel_getUid("object"), function $CPNotification__object(self, _cmd)
{
    return self._object;
}
,["id"]), new objj_method(sel_getUid("userInfo"), function $CPNotification__userInfo(self, _cmd)
{
    return self._userInfo;
}
,["CPDictionary"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("notificationWithName:object:userInfo:"), function $CPNotification__notificationWithName_object_userInfo_(self, _cmd, aNotificationName, anObject, aUserInfo)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithName:object:userInfo:", aNotificationName, anObject, aUserInfo);
}
,["CPNotification","CPString","id","CPDictionary"]), new objj_method(sel_getUid("notificationWithName:object:"), function $CPNotification__notificationWithName_object_(self, _cmd, aNotificationName, anObject)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithName:object:userInfo:", aNotificationName, anObject, nil);
}
,["CPNotification","CPString","id"])]);
}p;22;CPNotificationCenter.jt;10387;@STATIC;1.0;i;9;CPArray.ji;14;CPDictionary.ji;13;CPException.ji;16;CPNotification.ji;8;CPNull.ji;7;CPSet.jt;10273;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPNotification.j", YES);
objj_executeFile("CPNull.j", YES);
objj_executeFile("CPSet.j", YES);
var CPNotificationDefaultCenter = nil;
{var the_class = objj_allocateClassPair(CPObject, "CPNotificationCenter"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_namedRegistries"), new objj_ivar("_unnamedRegistry")]);






objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPNotificationCenter__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPNotificationCenter").super_class }, "init");
    if (self)
    {
        self._namedRegistries = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        self._unnamedRegistry = objj_msgSend(objj_msgSend(_CPNotificationRegistry, "alloc"), "init");
    }
   return self;
}
,["id"]), new objj_method(sel_getUid("addObserver:selector:name:object:"), function $CPNotificationCenter__addObserver_selector_name_object_(self, _cmd, anObserver, aSelector, aNotificationName, anObject)
{
    var registry,
        observer = objj_msgSend(objj_msgSend(_CPNotificationObserver, "alloc"), "initWithObserver:selector:", anObserver, aSelector);
    if (aNotificationName == nil)
        registry = self._unnamedRegistry;
    else if (!(registry = objj_msgSend(self._namedRegistries, "objectForKey:", aNotificationName)))
    {
        registry = objj_msgSend(objj_msgSend(_CPNotificationRegistry, "alloc"), "init");
        objj_msgSend(self._namedRegistries, "setObject:forKey:", registry, aNotificationName);
    }
    objj_msgSend(registry, "addObserver:object:", observer, anObject);
}
,["void","id","SEL","CPString","id"]), new objj_method(sel_getUid("removeObserver:"), function $CPNotificationCenter__removeObserver_(self, _cmd, anObserver)
{
    var name = nil,
        names = objj_msgSend(self._namedRegistries, "keyEnumerator");
    while ((name = objj_msgSend(names, "nextObject")) !== nil)
        objj_msgSend(objj_msgSend(self._namedRegistries, "objectForKey:", name), "removeObserver:object:", anObserver, nil);
    objj_msgSend(self._unnamedRegistry, "removeObserver:object:", anObserver, nil);
}
,["void","id"]), new objj_method(sel_getUid("removeObserver:name:object:"), function $CPNotificationCenter__removeObserver_name_object_(self, _cmd, anObserver, aNotificationName, anObject)
{
    if (aNotificationName == nil)
    {
        var name = nil,
            names = objj_msgSend(self._namedRegistries, "keyEnumerator");
        while ((name = objj_msgSend(names, "nextObject")) !== nil)
            objj_msgSend(objj_msgSend(self._namedRegistries, "objectForKey:", name), "removeObserver:object:", anObserver, anObject);
        objj_msgSend(self._unnamedRegistry, "removeObserver:object:", anObserver, anObject);
    }
    else
        objj_msgSend(objj_msgSend(self._namedRegistries, "objectForKey:", aNotificationName), "removeObserver:object:", anObserver, anObject);
}
,["void","id","CPString","id"]), new objj_method(sel_getUid("postNotification:"), function $CPNotificationCenter__postNotification_(self, _cmd, aNotification)
{
    if (!aNotification)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "postNotification: does not except 'nil' notifications");
    _CPNotificationCenterPostNotification(self, aNotification);
}
,["void","CPNotification"]), new objj_method(sel_getUid("postNotificationName:object:userInfo:"), function $CPNotificationCenter__postNotificationName_object_userInfo_(self, _cmd, aNotificationName, anObject, aUserInfo)
{
   _CPNotificationCenterPostNotification(self, objj_msgSend(objj_msgSend(CPNotification, "alloc"), "initWithName:object:userInfo:", aNotificationName, anObject, aUserInfo));
}
,["void","CPString","id","CPDictionary"]), new objj_method(sel_getUid("postNotificationName:object:"), function $CPNotificationCenter__postNotificationName_object_(self, _cmd, aNotificationName, anObject)
{
   _CPNotificationCenterPostNotification(self, objj_msgSend(objj_msgSend(CPNotification, "alloc"), "initWithName:object:userInfo:", aNotificationName, anObject, nil));
}
,["void","CPString","id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("defaultCenter"), function $CPNotificationCenter__defaultCenter(self, _cmd)
{
    if (!CPNotificationDefaultCenter)
        CPNotificationDefaultCenter = objj_msgSend(objj_msgSend(CPNotificationCenter, "alloc"), "init");
    return CPNotificationDefaultCenter;
}
,["CPNotificationCenter"])]);
}
var _CPNotificationCenterPostNotification = function( self, aNotification)
{
    objj_msgSend(self._unnamedRegistry, "postNotification:", aNotification);
    objj_msgSend(objj_msgSend(self._namedRegistries, "objectForKey:", objj_msgSend(aNotification, "name")), "postNotification:", aNotification);
};
{var the_class = objj_allocateClassPair(CPObject, "_CPNotificationRegistry"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_objectObservers")]);



objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $_CPNotificationRegistry__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPNotificationRegistry").super_class }, "init");
    if (self)
    {
        self._objectObservers = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("addObserver:object:"), function $_CPNotificationRegistry__addObserver_object_(self, _cmd, anObserver, anObject)
{
    if (!anObject)
        anObject = objj_msgSend(CPNull, "null");
    var observers = objj_msgSend(self._objectObservers, "objectForKey:", objj_msgSend(anObject, "UID"));
    if (!observers)
    {
        observers = objj_msgSend(CPMutableSet, "set");
        objj_msgSend(self._objectObservers, "setObject:forKey:", observers, objj_msgSend(anObject, "UID"));
    }
    objj_msgSend(observers, "addObject:", anObserver);
}
,["void","_CPNotificationObserver","id"]), new objj_method(sel_getUid("removeObserver:object:"), function $_CPNotificationRegistry__removeObserver_object_(self, _cmd, anObserver, anObject)
{
    var removedKeys = [];
    if (anObject == nil)
    {
        var key = nil,
            keys = objj_msgSend(self._objectObservers, "keyEnumerator");
        while ((key = objj_msgSend(keys, "nextObject")) !== nil)
        {
            var observers = objj_msgSend(self._objectObservers, "objectForKey:", key),
                observer = nil,
                observersEnumerator = objj_msgSend(observers, "objectEnumerator");
            while ((observer = objj_msgSend(observersEnumerator, "nextObject")) !== nil)
                if (objj_msgSend(observer, "observer") == anObserver)
                    objj_msgSend(observers, "removeObject:", observer);
            if (!objj_msgSend(observers, "count"))
                removedKeys.push(key);
        }
    }
    else
    {
        var key = objj_msgSend(anObject, "UID"),
            observers = objj_msgSend(self._objectObservers, "objectForKey:", key),
            observer = nil,
            observersEnumerator = objj_msgSend(observers, "objectEnumerator");
        while ((observer = objj_msgSend(observersEnumerator, "nextObject")) !== nil)
            if (objj_msgSend(observer, "observer") == anObserver)
                objj_msgSend(observers, "removeObject:", observer);
        if (!objj_msgSend(observers, "count"))
            removedKeys.push(key);
    }
    var count = removedKeys.length;
    while (count--)
        objj_msgSend(self._objectObservers, "removeObjectForKey:", removedKeys[count]);
}
,["void","id","id"]), new objj_method(sel_getUid("postNotification:"), function $_CPNotificationRegistry__postNotification_(self, _cmd, aNotification)
{
    var object = objj_msgSend(aNotification, "object"),
        currentObservers = nil;
    if (object != nil && (currentObservers = objj_msgSend(self._objectObservers, "objectForKey:", objj_msgSend(object, "UID"))))
    {
        var observers = objj_msgSend(currentObservers, "copy"),
            observer = nil,
            observersEnumerator = objj_msgSend(observers, "objectEnumerator");
        while ((observer = objj_msgSend(observersEnumerator, "nextObject")) !== nil)
        {
            if (objj_msgSend(currentObservers, "containsObject:", observer))
                objj_msgSend(observer, "postNotification:", aNotification);
        }
    }
    currentObservers = objj_msgSend(self._objectObservers, "objectForKey:", objj_msgSend(objj_msgSend(CPNull, "null"), "UID"));
    if (!currentObservers)
        return;
    var observers = objj_msgSend(currentObservers, "copy"),
        observersEnumerator = objj_msgSend(observers, "objectEnumerator");
    while ((observer = objj_msgSend(observersEnumerator, "nextObject")) !== nil)
    {
        if (objj_msgSend(currentObservers, "containsObject:", observer))
            objj_msgSend(observer, "postNotification:", aNotification);
    }
}
,["void","CPNotification"]), new objj_method(sel_getUid("count"), function $_CPNotificationRegistry__count(self, _cmd)
{
    return objj_msgSend(self._objectObservers, "count");
}
,["unsigned"])]);
}
{var the_class = objj_allocateClassPair(CPObject, "_CPNotificationObserver"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_observer"), new objj_ivar("_selector")]);

objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithObserver:selector:"), function $_CPNotificationObserver__initWithObserver_selector_(self, _cmd, anObserver, aSelector)
{
    if (self)
    {
        self._observer = anObserver;
        self._selector = aSelector;
    }
   return self;
}
,["id","id","SEL"]), new objj_method(sel_getUid("observer"), function $_CPNotificationObserver__observer(self, _cmd)
{
    return self._observer;
}
,["id"]), new objj_method(sel_getUid("postNotification:"), function $_CPNotificationObserver__postNotification_(self, _cmd, aNotification)
{
    objj_msgSend(self._observer, "performSelector:withObject:", self._selector, aNotification);
}
,["void","CPNotification"])]);
}p;8;CPNull.jt;1048;@STATIC;1.0;i;10;CPObject.jt;1014;objj_executeFile("CPObject.j", YES);
var CPNullSharedNull = nil;
{var the_class = objj_allocateClassPair(CPObject, "CPNull"),
meta_class = the_class.isa;


objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("isEqual:"), function $CPNull__isEqual_(self, _cmd, anObject)
{
    if (self === anObject)
        return YES;
    return objj_msgSend(anObject, "isKindOfClass:", objj_msgSend(CPNull, "class"));
}
,["BOOL","id"]), new objj_method(sel_getUid("initWithCoder:"), function $CPNull__initWithCoder_(self, _cmd, aCoder)
{
    return objj_msgSend(CPNull, "null");
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPNull__encodeWithCoder_(self, _cmd, aCoder)
{
}
,["void","CPCoder"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("null"), function $CPNull__null(self, _cmd)
{
    if (!CPNullSharedNull)
        CPNullSharedNull = objj_msgSend(objj_msgSend(CPNull, "alloc"), "init");
    return CPNullSharedNull;
}
,["CPNull"])]);
}p;10;CPNumber.jt;8847;@STATIC;1.0;i;10;CPObject.ji;15;CPObjJRuntime.jt;8793;objj_executeFile("CPObject.j", YES);
objj_executeFile("CPObjJRuntime.j", YES);
var CPNumberUIDs = new CFMutableDictionary();
{var the_class = objj_allocateClassPair(CPObject, "CPNumber"),
meta_class = the_class.isa;










































objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithBool:"), function $CPNumber__initWithBool_(self, _cmd, aBoolean)
{
    return aBoolean;
}
,["id","BOOL"]), new objj_method(sel_getUid("initWithChar:"), function $CPNumber__initWithChar_(self, _cmd, aChar)
{
    if (aChar.charCodeAt)
        return aChar.charCodeAt(0);
    return aChar;
}
,["id","char"]), new objj_method(sel_getUid("initWithDouble:"), function $CPNumber__initWithDouble_(self, _cmd, aDouble)
{
    return aDouble;
}
,["id","double"]), new objj_method(sel_getUid("initWithFloat:"), function $CPNumber__initWithFloat_(self, _cmd, aFloat)
{
    return aFloat;
}
,["id","float"]), new objj_method(sel_getUid("initWithInt:"), function $CPNumber__initWithInt_(self, _cmd, anInt)
{
    return anInt;
}
,["id","int"]), new objj_method(sel_getUid("initWithLong:"), function $CPNumber__initWithLong_(self, _cmd, aLong)
{
    return aLong;
}
,["id","long"]), new objj_method(sel_getUid("initWithLongLong:"), function $CPNumber__initWithLongLong_(self, _cmd, aLongLong)
{
    return aLongLong;
}
,["id","long long"]), new objj_method(sel_getUid("initWithShort:"), function $CPNumber__initWithShort_(self, _cmd, aShort)
{
    return aShort;
}
,["id","short"]), new objj_method(sel_getUid("initWithUnsignedChar:"), function $CPNumber__initWithUnsignedChar_(self, _cmd, aChar)
{
    if (aChar.charCodeAt)
        return aChar.charCodeAt(0);
    return aChar;
}
,["id","unsigned char"]), new objj_method(sel_getUid("initWithUnsignedInt:"), function $CPNumber__initWithUnsignedInt_(self, _cmd, anUnsignedInt)
{
    return anUnsignedInt;
}
,["id","unsigned"]), new objj_method(sel_getUid("initWithUnsignedLong:"), function $CPNumber__initWithUnsignedLong_(self, _cmd, anUnsignedLong)
{
    return anUnsignedLong;
}
,["id","unsigned long"]), new objj_method(sel_getUid("initWithUnsignedShort:"), function $CPNumber__initWithUnsignedShort_(self, _cmd, anUnsignedShort)
{
    return anUnsignedShort;
}
,["id","unsigned short"]), new objj_method(sel_getUid("UID"), function $CPNumber__UID(self, _cmd)
{
    var UID = CPNumberUIDs.valueForKey(self);
    if (!UID)
    {
        UID = objj_generateObjectUID();
        CPNumberUIDs.setValueForKey(self, UID);
    }
    return UID + "";
}
,["CPString"]), new objj_method(sel_getUid("boolValue"), function $CPNumber__boolValue(self, _cmd)
{
    return self ? true : false;
}
,["BOOL"]), new objj_method(sel_getUid("charValue"), function $CPNumber__charValue(self, _cmd)
{
    return String.fromCharCode(self);
}
,["char"]), new objj_method(sel_getUid("decimalValue"), function $CPNumber__decimalValue(self, _cmd)
{
    throw new Error("decimalValue: NOT YET IMPLEMENTED");
}
,["CPDecimal"]), new objj_method(sel_getUid("descriptionWithLocale:"), function $CPNumber__descriptionWithLocale_(self, _cmd, aDictionary)
{
    if (!aDictionary)
        return self.toString();
    throw new Error("descriptionWithLocale: NOT YET IMPLEMENTED");
}
,["CPString","CPDictionary"]), new objj_method(sel_getUid("description"), function $CPNumber__description(self, _cmd)
{
    return objj_msgSend(self, "descriptionWithLocale:", nil);
}
,["CPString"]), new objj_method(sel_getUid("doubleValue"), function $CPNumber__doubleValue(self, _cmd)
{
    if (typeof self == "boolean")
        return self ? 1 : 0;
    return self;
}
,["double"]), new objj_method(sel_getUid("floatValue"), function $CPNumber__floatValue(self, _cmd)
{
    if (typeof self == "boolean")
        return self ? 1 : 0;
    return self;
}
,["float"]), new objj_method(sel_getUid("intValue"), function $CPNumber__intValue(self, _cmd)
{
    if (typeof self == "boolean")
        return self ? 1 : 0;
    return self;
}
,["int"]), new objj_method(sel_getUid("longLongValue"), function $CPNumber__longLongValue(self, _cmd)
{
    if (typeof self == "boolean")
        return self ? 1 : 0;
    return self;
}
,["long long"]), new objj_method(sel_getUid("longValue"), function $CPNumber__longValue(self, _cmd)
{
    if (typeof self == "boolean")
        return self ? 1 : 0;
    return self;
}
,["long"]), new objj_method(sel_getUid("shortValue"), function $CPNumber__shortValue(self, _cmd)
{
    if (typeof self == "boolean")
        return self ? 1 : 0;
    return self;
}
,["short"]), new objj_method(sel_getUid("stringValue"), function $CPNumber__stringValue(self, _cmd)
{
    return self.toString();
}
,["CPString"]), new objj_method(sel_getUid("unsignedCharValue"), function $CPNumber__unsignedCharValue(self, _cmd)
{
    return String.fromCharCode(self);
}
,["unsigned char"]), new objj_method(sel_getUid("unsignedIntValue"), function $CPNumber__unsignedIntValue(self, _cmd)
{
    if (typeof self == "boolean")
        return self ? 1 : 0;
    return self;
}
,["unsigned int"]), new objj_method(sel_getUid("unsignedLongValue"), function $CPNumber__unsignedLongValue(self, _cmd)
{
    if (typeof self == "boolean")
        return self ? 1 : 0;
    return self;
}
,["unsigned long"]), new objj_method(sel_getUid("unsignedShortValue"), function $CPNumber__unsignedShortValue(self, _cmd)
{
    if (typeof self == "boolean")
        return self ? 1 : 0;
    return self;
}
,["unsigned short"]), new objj_method(sel_getUid("compare:"), function $CPNumber__compare_(self, _cmd, aNumber)
{
    if (self > aNumber)
        return CPOrderedDescending;
    else if (self < aNumber)
        return CPOrderedAscending;
    return CPOrderedSame;
}
,["CPComparisonResult","CPNumber"]), new objj_method(sel_getUid("isEqualToNumber:"), function $CPNumber__isEqualToNumber_(self, _cmd, aNumber)
{
    return self == aNumber;
}
,["BOOL","CPNumber"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $CPNumber__alloc(self, _cmd)
{
    var result = new Number();
    result.isa = objj_msgSend(self, "class");
    return result;
}
,["id"]), new objj_method(sel_getUid("numberWithBool:"), function $CPNumber__numberWithBool_(self, _cmd, aBoolean)
{
    return aBoolean;
}
,["id","BOOL"]), new objj_method(sel_getUid("numberWithChar:"), function $CPNumber__numberWithChar_(self, _cmd, aChar)
{
    if (aChar.charCodeAt)
        return aChar.charCodeAt(0);
    return aChar;
}
,["id","char"]), new objj_method(sel_getUid("numberWithDouble:"), function $CPNumber__numberWithDouble_(self, _cmd, aDouble)
{
    return aDouble;
}
,["id","double"]), new objj_method(sel_getUid("numberWithFloat:"), function $CPNumber__numberWithFloat_(self, _cmd, aFloat)
{
    return aFloat;
}
,["id","float"]), new objj_method(sel_getUid("numberWithInt:"), function $CPNumber__numberWithInt_(self, _cmd, anInt)
{
    return anInt;
}
,["id","int"]), new objj_method(sel_getUid("numberWithLong:"), function $CPNumber__numberWithLong_(self, _cmd, aLong)
{
    return aLong;
}
,["id","long"]), new objj_method(sel_getUid("numberWithLongLong:"), function $CPNumber__numberWithLongLong_(self, _cmd, aLongLong)
{
    return aLongLong;
}
,["id","long long"]), new objj_method(sel_getUid("numberWithShort:"), function $CPNumber__numberWithShort_(self, _cmd, aShort)
{
    return aShort;
}
,["id","short"]), new objj_method(sel_getUid("numberWithUnsignedChar:"), function $CPNumber__numberWithUnsignedChar_(self, _cmd, aChar)
{
    if (aChar.charCodeAt)
        return aChar.charCodeAt(0);
    return aChar;
}
,["id","unsigned char"]), new objj_method(sel_getUid("numberWithUnsignedInt:"), function $CPNumber__numberWithUnsignedInt_(self, _cmd, anUnsignedInt)
{
    return anUnsignedInt;
}
,["id","unsigned"]), new objj_method(sel_getUid("numberWithUnsignedLong:"), function $CPNumber__numberWithUnsignedLong_(self, _cmd, anUnsignedLong)
{
    return anUnsignedLong;
}
,["id","unsigned long"]), new objj_method(sel_getUid("numberWithUnsignedShort:"), function $CPNumber__numberWithUnsignedShort_(self, _cmd, anUnsignedShort)
{
    return anUnsignedShort;
}
,["id","unsigned short"])]);
}
{
var the_class = objj_getClass("CPNumber")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPNumber\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPNumber__initWithCoder_(self, _cmd, aCoder)
{
    return objj_msgSend(aCoder, "decodeNumber");
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPNumber__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeNumber:forKey:", self, "self");
}
,["void","CPCoder"])]);
}
Number.prototype.isa = CPNumber;
Boolean.prototype.isa = CPNumber;
objj_msgSend(CPNumber, "initialize");p;19;CPNumberFormatter.jt;13688;@STATIC;1.0;i;10;CPString.ji;13;CPFormatter.ji;17;CPDecimalNumber.jt;13613;objj_executeFile("CPString.j", YES);
objj_executeFile("CPFormatter.j", YES);
objj_executeFile("CPDecimalNumber.j", YES);
CPNumberFormatterNoStyle = 0;
CPNumberFormatterDecimalStyle = 1;
CPNumberFormatterCurrencyStyle = 2;
CPNumberFormatterPercentStyle = 3;
CPNumberFormatterScientificStyle = 4;
CPNumberFormatterSpellOutStyle = 5;
CPNumberFormatterRoundCeiling = CPRoundUp;
CPNumberFormatterRoundFloor = CPRoundDown;
CPNumberFormatterRoundDown = CPRoundDown;
CPNumberFormatterRoundUp = CPRoundUp;
CPNumberFormatterRoundHalfEven = CPRoundBankers;
CPNumberFormatterRoundHalfDown = _CPRoundHalfDown;
CPNumberFormatterRoundHalfUp = CPRoundPlain;
var NumberRegex = new RegExp('(-)?(\\d*)(\\.(\\d*))?');
{var the_class = objj_allocateClassPair(CPFormatter, "CPNumberFormatter"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_numberStyle"), new objj_ivar("_perMillSymbol"), new objj_ivar("_groupingSeparator"), new objj_ivar("_roundingMode"), new objj_ivar("_minimumFractionDigits"), new objj_ivar("_maximumFractionDigits"), new objj_ivar("_currencyCode"), new objj_ivar("_currencySymbol"), new objj_ivar("_generatesDecimalNumbers"), new objj_ivar("_numberHandler")]);









       
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("numberStyle"), function $CPNumberFormatter__numberStyle(self, _cmd)
{
return self._numberStyle;
}
,["CPNumberFormatterStyle"]), new objj_method(sel_getUid("setNumberStyle:"), function $CPNumberFormatter__setNumberStyle_(self, _cmd, newValue)
{
self._numberStyle = newValue;
}
,["void","CPNumberFormatterStyle"]), new objj_method(sel_getUid("perMillSymbol"), function $CPNumberFormatter__perMillSymbol(self, _cmd)
{
return self._perMillSymbol;
}
,["CPString"]), new objj_method(sel_getUid("setPerMillSymbol:"), function $CPNumberFormatter__setPerMillSymbol_(self, _cmd, newValue)
{
self._perMillSymbol = newValue;
}
,["void","CPString"]), new objj_method(sel_getUid("groupingSeparator"), function $CPNumberFormatter__groupingSeparator(self, _cmd)
{
return self._groupingSeparator;
}
,["CPString"]), new objj_method(sel_getUid("setGroupingSeparator:"), function $CPNumberFormatter__setGroupingSeparator_(self, _cmd, newValue)
{
self._groupingSeparator = newValue;
}
,["void","CPString"]), new objj_method(sel_getUid("roundingMode"), function $CPNumberFormatter__roundingMode(self, _cmd)
{
return self._roundingMode;
}
,["CPNumberFormatterRoundingMode"]), new objj_method(sel_getUid("setRoundingMode:"), function $CPNumberFormatter__setRoundingMode_(self, _cmd, newValue)
{
self._roundingMode = newValue;
}
,["void","CPNumberFormatterRoundingMode"]), new objj_method(sel_getUid("minimumFractionDigits"), function $CPNumberFormatter__minimumFractionDigits(self, _cmd)
{
return self._minimumFractionDigits;
}
,["CPUInteger"]), new objj_method(sel_getUid("setMinimumFractionDigits:"), function $CPNumberFormatter__setMinimumFractionDigits_(self, _cmd, newValue)
{
self._minimumFractionDigits = newValue;
}
,["void","CPUInteger"]), new objj_method(sel_getUid("maximumFractionDigits"), function $CPNumberFormatter__maximumFractionDigits(self, _cmd)
{
return self._maximumFractionDigits;
}
,["CPUInteger"]), new objj_method(sel_getUid("setMaximumFractionDigits:"), function $CPNumberFormatter__setMaximumFractionDigits_(self, _cmd, newValue)
{
self._maximumFractionDigits = newValue;
}
,["void","CPUInteger"]), new objj_method(sel_getUid("currencyCode"), function $CPNumberFormatter__currencyCode(self, _cmd)
{
return self._currencyCode;
}
,["CPString"]), new objj_method(sel_getUid("setCurrencyCode:"), function $CPNumberFormatter__setCurrencyCode_(self, _cmd, newValue)
{
self._currencyCode = newValue;
}
,["void","CPString"]), new objj_method(sel_getUid("currencySymbol"), function $CPNumberFormatter__currencySymbol(self, _cmd)
{
return self._currencySymbol;
}
,["CPString"]), new objj_method(sel_getUid("setCurrencySymbol:"), function $CPNumberFormatter__setCurrencySymbol_(self, _cmd, newValue)
{
self._currencySymbol = newValue;
}
,["void","CPString"]), new objj_method(sel_getUid("generatesDecimalNumbers"), function $CPNumberFormatter__generatesDecimalNumbers(self, _cmd)
{
return self._generatesDecimalNumbers;
}
,["BOOL"]), new objj_method(sel_getUid("setGeneratesDecimalNumbers:"), function $CPNumberFormatter__setGeneratesDecimalNumbers_(self, _cmd, newValue)
{
self._generatesDecimalNumbers = newValue;
}
,["void","BOOL"]), new objj_method(sel_getUid("init"), function $CPNumberFormatter__init(self, _cmd)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPNumberFormatter").super_class }, "init"))
    {
        self._roundingMode = CPNumberFormatterRoundHalfEven;
        self._minimumFractionDigits = 0;
        self._maximumFractionDigits = 0;
        self._groupingSeparator = ",";
        self._generatesDecimalNumbers = YES;
        self._currencyCode = "USD";
        self._currencySymbol = "$";
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("stringFromNumber:"), function $CPNumberFormatter__stringFromNumber_(self, _cmd, number)
{
    if (self._numberStyle == CPNumberFormatterPercentStyle)
    {
        number *= 100.0;
    }
    var dcmn = objj_msgSend(number, "isKindOfClass:", CPDecimalNumber) ? number : objj_msgSend(objj_msgSend(CPDecimalNumber, "alloc"), "_initWithJSNumber:", number);
    switch (self._numberStyle)
    {
        case CPNumberFormatterCurrencyStyle:
        case CPNumberFormatterDecimalStyle:
        case CPNumberFormatterPercentStyle:
            objj_msgSend(self, "_updateNumberHandlerIfNecessary");
            dcmn = objj_msgSend(dcmn, "decimalNumberByRoundingAccordingToBehavior:", self._numberHandler);
            var output = objj_msgSend(dcmn, "descriptionWithLocale:", nil),
                parts = output.match(NumberRegex) || ["", undefined, "", undefined, undefined],
                negativePrefix = parts[1] || "",
                preFraction = parts[2] || "",
                fraction = parts[4] || "",
                preFractionLength = objj_msgSend(preFraction, "length"),
                commaPosition = 3;
            while (fraction.length < self._minimumFractionDigits)
                fraction += "0";
            if (self._groupingSeparator)
            {
                for (var commaPosition = 3, prefLength = objj_msgSend(preFraction, "length"); commaPosition < prefLength; commaPosition += 4)
                {
                    preFraction = objj_msgSend(preFraction, "stringByReplacingCharactersInRange:withString:", CPMakeRange(prefLength - commaPosition, 0), self._groupingSeparator);
                    prefLength += 1;
                }
            }
            var string = preFraction;
            if (fraction)
                string += "." + fraction;
            if (self._numberStyle === CPNumberFormatterCurrencyStyle)
            {
                if (self._currencySymbol)
                    string = self._currencySymbol + string;
                else
                    string = self._currencyCode + string;
            }
            if (self._numberStyle == CPNumberFormatterPercentStyle)
                string += "%";
            if (negativePrefix)
                string = negativePrefix + string;
            return string;
        default:
            return objj_msgSend(number, "description");
    }
}
,["CPString","CPNumber"]), new objj_method(sel_getUid("numberFromString:"), function $CPNumberFormatter__numberFromString_(self, _cmd, aString)
{
    if (self._generatesDecimalNumbers)
        return objj_msgSend(CPDecimalNumber, "decimalNumberWithString:", aString);
    else
        return parseFloat(aString);
}
,["CPNumber","CPString"]), new objj_method(sel_getUid("stringForObjectValue:"), function $CPNumberFormatter__stringForObjectValue_(self, _cmd, anObject)
{
    if (objj_msgSend(anObject, "isKindOfClass:", objj_msgSend(CPNumber, "class")))
        return objj_msgSend(self, "stringFromNumber:", anObject);
    else
        return objj_msgSend(anObject, "description");
}
,["CPString","id"]), new objj_method(sel_getUid("editingStringForObjectValue:"), function $CPNumberFormatter__editingStringForObjectValue_(self, _cmd, anObject)
{
    return objj_msgSend(self, "stringForObjectValue:", anObject);
}
,["CPString","id"]), new objj_method(sel_getUid("getObjectValue:forString:errorDescription:"), function $CPNumberFormatter__getObjectValue_forString_errorDescription_(self, _cmd, anObject, aString, anError)
{
    var value = objj_msgSend(self, "numberFromString:", aString);
    anObject( value);
    return YES;
}
,["BOOL","id","CPString","CPString"]), new objj_method(sel_getUid("setNumberStyle:"), function $CPNumberFormatter__setNumberStyle_(self, _cmd, aStyle)
{
    self._numberStyle = aStyle;
    switch (aStyle)
    {
        case CPNumberFormatterDecimalStyle:
            self._minimumFractionDigits = 0;
            self._maximumFractionDigits = 3;
            self._numberHandler = nil;
            break;
        case CPNumberFormatterCurrencyStyle:
            self._minimumFractionDigits = 2;
            self._maximumFractionDigits = 2;
            self._numberHandler = nil;
            break;
    }
}
,["void","CPNumberFormatterStyle"]), new objj_method(sel_getUid("setRoundingMode:"), function $CPNumberFormatter__setRoundingMode_(self, _cmd, aRoundingMode)
{
    self._roundingMode = aRoundingMode;
    self._numberHandler = nil;
}
,["void","CPNumberFormatterRoundingMode"]), new objj_method(sel_getUid("setMinimumFractionDigits:"), function $CPNumberFormatter__setMinimumFractionDigits_(self, _cmd, aNumber)
{
    self._minimumFractionDigits = aNumber;
    self._numberHandler = nil;
}
,["void","CPUInteger"]), new objj_method(sel_getUid("setMaximumFractionDigits:"), function $CPNumberFormatter__setMaximumFractionDigits_(self, _cmd, aNumber)
{
    self._maximumFractionDigits = aNumber;
    self._numberHandler = nil;
}
,["void","CPUInteger"]), new objj_method(sel_getUid("_updateNumberHandlerIfNecessary"), function $CPNumberFormatter___updateNumberHandlerIfNecessary(self, _cmd)
{
    if (!self._numberHandler)
        self._numberHandler = objj_msgSend(CPDecimalNumberHandler, "decimalNumberHandlerWithRoundingMode:scale:raiseOnExactness:raiseOnOverflow:raiseOnUnderflow:raiseOnDivideByZero:", self._roundingMode, self._maximumFractionDigits, NO, NO, NO, YES);
}
,["void"])]);
}
var CPNumberFormatterStyleKey = "CPNumberFormatterStyleKey",
    CPNumberFormatterMinimumFractionDigitsKey = "CPNumberFormatterMinimumFractionDigitsKey",
    CPNumberFormatterMaximumFractionDigitsKey = "CPNumberFormatterMaximumFractionDigitsKey",
    CPNumberFormatterRoundingModeKey = "CPNumberFormatterRoundingModeKey",
    CPNumberFormatterGroupingSeparatorKey = "CPNumberFormatterGroupingSeparatorKey",
    CPNumberFormatterCurrencyCodeKey = "CPNumberFormatterCurrencyCodeKey",
    CPNumberFormatterCurrencySymbolKey = "CPNumberFormatterCurrencySymbolKey",
    CPNumberFormatterGeneratesDecimalNumbers = "CPNumberFormatterGeneratesDecimalNumbers";
{
var the_class = objj_getClass("CPNumberFormatter")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPNumberFormatter\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPNumberFormatter__initWithCoder_(self, _cmd, aCoder)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPNumberFormatter").super_class }, "initWithCoder:", aCoder);
    if (self)
    {
        self._numberStyle = objj_msgSend(aCoder, "decodeIntForKey:", CPNumberFormatterStyleKey);
        self._minimumFractionDigits = objj_msgSend(aCoder, "decodeIntForKey:", CPNumberFormatterMinimumFractionDigitsKey);
        self._maximumFractionDigits = objj_msgSend(aCoder, "decodeIntForKey:", CPNumberFormatterMaximumFractionDigitsKey);
        self._roundingMode = objj_msgSend(aCoder, "decodeIntForKey:", CPNumberFormatterRoundingModeKey);
        self._groupingSeparator = objj_msgSend(aCoder, "decodeObjectForKey:", CPNumberFormatterGroupingSeparatorKey);
        self._currencyCode = objj_msgSend(aCoder, "decodeObjectForKey:", CPNumberFormatterCurrencyCodeKey);
        self._currencySymbol = objj_msgSend(aCoder, "decodeObjectForKey:", CPNumberFormatterCurrencySymbolKey);
        self._generatesDecimalNumbers = objj_msgSend(aCoder, "decodeBoolForKey:", CPNumberFormatterGeneratesDecimalNumbers);
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPNumberFormatter__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPNumberFormatter").super_class }, "encodeWithCoder:", aCoder);
    objj_msgSend(aCoder, "encodeInt:forKey:", self._numberStyle, CPNumberFormatterStyleKey);
    objj_msgSend(aCoder, "encodeInt:forKey:", self._minimumFractionDigits, CPNumberFormatterMinimumFractionDigitsKey);
    objj_msgSend(aCoder, "encodeInt:forKey:", self._maximumFractionDigits, CPNumberFormatterMaximumFractionDigitsKey);
    objj_msgSend(aCoder, "encodeInt:forKey:", self._roundingMode, CPNumberFormatterRoundingModeKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._groupingSeparator, CPNumberFormatterGroupingSeparatorKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._currencyCode, CPNumberFormatterCurrencyCodeKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._currencySymbol, CPNumberFormatterCurrencySymbolKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._generatesDecimalNumbers, CPNumberFormatterGeneratesDecimalNumbers);
}
,["void","CPCoder"])]);
}p;10;CPObject.jt;11324;@STATIC;1.0;t;11304;//@class CPString
//@class CPException
//@global CPInvalidArgumentException
{var the_class = objj_allocateClassPair(Nil, "CPObject"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("isa")]);
















































objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPObject__init(self, _cmd)
{
    return self;
}
,["id"]), new objj_method(sel_getUid("copy"), function $CPObject__copy(self, _cmd)
{
    return self;
}
,["id"]), new objj_method(sel_getUid("mutableCopy"), function $CPObject__mutableCopy(self, _cmd)
{
    return objj_msgSend(self, "copy");
}
,["id"]), new objj_method(sel_getUid("dealloc"), function $CPObject__dealloc(self, _cmd)
{
}
,["void"]), new objj_method(sel_getUid("class"), function $CPObject__class(self, _cmd)
{
    return self.isa;
}
,["Class"]), new objj_method(sel_getUid("isKindOfClass:"), function $CPObject__isKindOfClass_(self, _cmd, aClass)
{
    return objj_msgSend(self.isa, "isSubclassOfClass:", aClass);
}
,["BOOL","Class"]), new objj_method(sel_getUid("isMemberOfClass:"), function $CPObject__isMemberOfClass_(self, _cmd, aClass)
{
    return self.isa === aClass;
}
,["BOOL","Class"]), new objj_method(sel_getUid("isProxy"), function $CPObject__isProxy(self, _cmd)
{
    return NO;
}
,["BOOL"]), new objj_method(sel_getUid("respondsToSelector:"), function $CPObject__respondsToSelector_(self, _cmd, aSelector)
{
    return !!class_getInstanceMethod(self.isa, aSelector);
}
,["BOOL","SEL"]), new objj_method(sel_getUid("implementsSelector:"), function $CPObject__implementsSelector_(self, _cmd, aSelector)
{
    var methods = class_copyMethodList(self.isa),
        count = methods.length;
    while (count--)
        if (method_getName(methods[count]) === aSelector)
            return YES;
    return NO;
}
,["BOOL","SEL"]), new objj_method(sel_getUid("methodForSelector:"), function $CPObject__methodForSelector_(self, _cmd, aSelector)
{
    return class_getMethodImplementation(self.isa, aSelector);
}
,["IMP","SEL"]), new objj_method(sel_getUid("methodSignatureForSelector:"), function $CPObject__methodSignatureForSelector_(self, _cmd, aSelector)
{
    return nil;
}
,["CPMethodSignature","SEL"]), new objj_method(sel_getUid("description"), function $CPObject__description(self, _cmd)
{
    return "<" + class_getName(self.isa) + " 0x" + objj_msgSend(CPString, "stringWithHash:", objj_msgSend(self, "UID")) + ">";
}
,["CPString"]), new objj_method(sel_getUid("performSelector:"), function $CPObject__performSelector_(self, _cmd, aSelector)
{
    return objj_msgSend(self, aSelector);
}
,["id","SEL"]), new objj_method(sel_getUid("performSelector:withObject:"), function $CPObject__performSelector_withObject_(self, _cmd, aSelector, anObject)
{
    return objj_msgSend(self, aSelector, anObject);
}
,["id","SEL","id"]), new objj_method(sel_getUid("performSelector:withObject:withObject:"), function $CPObject__performSelector_withObject_withObject_(self, _cmd, aSelector, anObject, anotherObject)
{
    return objj_msgSend(self, aSelector, anObject, anotherObject);
}
,["id","SEL","id","id"]), new objj_method(sel_getUid("performSelector:withObjects:"), function $CPObject__performSelector_withObjects_(self, _cmd, aSelector, anObject)
{
    var params = [self, aSelector].concat(Array.prototype.slice.apply(arguments, [3]));
    return objj_msgSend.apply(this, params);
}
,["id","SEL","id"]), new objj_method(sel_getUid("forwardingTargetForSelector:"), function $CPObject__forwardingTargetForSelector_(self, _cmd, aSelector)
{
    return nil;
}
,["id","SEL"]), new objj_method(sel_getUid("forwardInvocation:"), function $CPObject__forwardInvocation_(self, _cmd, anInvocation)
{
    objj_msgSend(self, "doesNotRecognizeSelector:", objj_msgSend(anInvocation, "selector"));
}
,["void","CPInvocation"]), new objj_method(sel_getUid("doesNotRecognizeSelector:"), function $CPObject__doesNotRecognizeSelector_(self, _cmd, aSelector)
{
    objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, (class_isMetaClass(self.isa) ? "+" : "-") + " [" + objj_msgSend(self, "className") + " " + aSelector + "] unrecognized selector sent to " +
        (class_isMetaClass(self.isa) ? "class " + class_getName(self.isa) : "instance 0x" + objj_msgSend(CPString, "stringWithHash:", objj_msgSend(self, "UID"))));
}
,["void","SEL"]), new objj_method(sel_getUid("awakeAfterUsingCoder:"), function $CPObject__awakeAfterUsingCoder_(self, _cmd, aCoder)
{
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("classForKeyedArchiver"), function $CPObject__classForKeyedArchiver(self, _cmd)
{
    return objj_msgSend(self, "classForCoder");
}
,["Class"]), new objj_method(sel_getUid("classForCoder"), function $CPObject__classForCoder(self, _cmd)
{
    return objj_msgSend(self, "class");
}
,["Class"]), new objj_method(sel_getUid("replacementObjectForArchiver:"), function $CPObject__replacementObjectForArchiver_(self, _cmd, anArchiver)
{
    return objj_msgSend(self, "replacementObjectForCoder:", anArchiver);
}
,["id","CPArchiver"]), new objj_method(sel_getUid("replacementObjectForKeyedArchiver:"), function $CPObject__replacementObjectForKeyedArchiver_(self, _cmd, anArchiver)
{
    return objj_msgSend(self, "replacementObjectForCoder:", anArchiver);
}
,["id","CPKeyedArchiver"]), new objj_method(sel_getUid("replacementObjectForCoder:"), function $CPObject__replacementObjectForCoder_(self, _cmd, aCoder)
{
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("className"), function $CPObject__className(self, _cmd)
{
    return self.isa.name;
}
,["CPString"]), new objj_method(sel_getUid("autorelease"), function $CPObject__autorelease(self, _cmd)
{
    return self;
}
,["id"]), new objj_method(sel_getUid("hash"), function $CPObject__hash(self, _cmd)
{
    return objj_msgSend(self, "UID");
}
,["unsigned"]), new objj_method(sel_getUid("UID"), function $CPObject__UID(self, _cmd)
{
    if (typeof self._UID === "undefined")
        self._UID = objj_generateObjectUID();
    return self._UID + "";
}
,["CPString"]), new objj_method(sel_getUid("isEqual:"), function $CPObject__isEqual_(self, _cmd, anObject)
{
    return self === anObject || objj_msgSend(self, "UID") === objj_msgSend(anObject, "UID");
}
,["BOOL","id"]), new objj_method(sel_getUid("retain"), function $CPObject__retain(self, _cmd)
{
    return self;
}
,["id"]), new objj_method(sel_getUid("release"), function $CPObject__release(self, _cmd)
{
}
,["void"]), new objj_method(sel_getUid("self"), function $CPObject__self(self, _cmd)
{
    return self;
}
,["id"]), new objj_method(sel_getUid("superclass"), function $CPObject__superclass(self, _cmd)
{
    return self.isa.super_class;
}
,["Class"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("load"), function $CPObject__load(self, _cmd)
{
}
,["void"]), new objj_method(sel_getUid("initialize"), function $CPObject__initialize(self, _cmd)
{
}
,["void"]), new objj_method(sel_getUid("new"), function $CPObject__new(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "init");
}
,["id"]), new objj_method(sel_getUid("alloc"), function $CPObject__alloc(self, _cmd)
{
    return class_createInstance(self);
}
,["id"]), new objj_method(sel_getUid("allocWithCoder:"), function $CPObject__allocWithCoder_(self, _cmd, aCoder)
{
    return objj_msgSend(self, "alloc");
}
,["id","CPCoder"]), new objj_method(sel_getUid("class"), function $CPObject__class(self, _cmd)
{
    return self;
}
,["Class"]), new objj_method(sel_getUid("superclass"), function $CPObject__superclass(self, _cmd)
{
    return self.super_class;
}
,["Class"]), new objj_method(sel_getUid("isSubclassOfClass:"), function $CPObject__isSubclassOfClass_(self, _cmd, aClass)
{
    var theClass = self;
    for (; theClass; theClass = theClass.super_class)
        if (theClass === aClass)
            return YES;
    return NO;
}
,["BOOL","Class"]), new objj_method(sel_getUid("isKindOfClass:"), function $CPObject__isKindOfClass_(self, _cmd, aClass)
{
    return objj_msgSend(self, "isSubclassOfClass:", aClass);
}
,["BOOL","Class"]), new objj_method(sel_getUid("isMemberOfClass:"), function $CPObject__isMemberOfClass_(self, _cmd, aClass)
{
    return self === aClass;
}
,["BOOL","Class"]), new objj_method(sel_getUid("instancesRespondToSelector:"), function $CPObject__instancesRespondToSelector_(self, _cmd, aSelector)
{
    return !!class_getInstanceMethod(self, aSelector);
}
,["BOOL","SEL"]), new objj_method(sel_getUid("instanceMethodForSelector:"), function $CPObject__instanceMethodForSelector_(self, _cmd, aSelector)
{
    return class_getMethodImplementation(self, aSelector);
}
,["IMP","SEL"]), new objj_method(sel_getUid("description"), function $CPObject__description(self, _cmd)
{
    return class_getName(self.isa);
}
,["CPString"]), new objj_method(sel_getUid("setVersion:"), function $CPObject__setVersion_(self, _cmd, aVersion)
{
    class_setVersion(self, aVersion);
}
,["void","int"]), new objj_method(sel_getUid("version"), function $CPObject__version(self, _cmd)
{
    return class_getVersion(self);
}
,["int"])]);
}
CPDescriptionOfObject = function(anObject)
{
    if (anObject === nil)
        return "nil";
    if (anObject === undefined)
        return "undefined";
    if (anObject.isa)
    {
        if (objj_msgSend(anObject, "isKindOfClass:", CPString))
            return '@"' + objj_msgSend(anObject, "description") + '"';
        return objj_msgSend(anObject, "description");
    }
    if (typeof(anObject) !== "object")
        return String(anObject);
    var properties = [],
        desc;
    for (var property in anObject)
        if (anObject.hasOwnProperty(property))
            properties.push(property);
    properties.sort();
    if (properties.length === 2 && anObject.hasOwnProperty("width") && anObject.hasOwnProperty("height"))
        desc = objj_msgSend(CPString, "stringWithFormat:", "CGSize: { width:%f, height:%f }", anObject.width, anObject.height);
    else if (properties.length === 2 && anObject.hasOwnProperty("x") && anObject.hasOwnProperty("y"))
        desc = objj_msgSend(CPString, "stringWithFormat:", "CGPoint: { x:%f, y:%f }", anObject.x, anObject.y);
    else if (properties.length === 2 && anObject.hasOwnProperty("origin") && anObject.hasOwnProperty("size"))
        desc = objj_msgSend(CPString, "stringWithFormat:", "CGRect: { x:%f, y:%f }, { width:%f, height:%f }", anObject.origin.x, anObject.origin.y, anObject.size.width, anObject.size.height);
    else if (properties.length === 4 && anObject.hasOwnProperty("top") && anObject.hasOwnProperty("right") && anObject.hasOwnProperty("bottom") && anObject.hasOwnProperty("left"))
        desc = objj_msgSend(CPString, "stringWithFormat:", "CGInset: { top:%f, right:%f, bottom:%f, left:%f }", anObject.top, anObject.right, anObject.bottom, anObject.left);
    else
    {
        desc = "{";
        for (var i = 0; i < properties.length; ++i)
        {
            if (i === 0)
                desc += "\n";
            desc += "    " + properties[i] + ": " + CPDescriptionOfObject(anObject[properties[i]]).split("\n").join("\n    ");
            if (i < properties.length - 1)
                desc += ",\n";
            else
                desc += "\n";
        }
        desc += "}";
    }
    return desc;
}p;15;CPObjJRuntime.jt;438;@STATIC;1.0;t;420;CPStringFromSelector = function(aSelector)
{
    return sel_getName(aSelector);
}
CPSelectorFromString = function(aSelectorName)
{
    return sel_registerName(aSelectorName);
}
CPClassFromString = function(aClassName)
{
    return objj_getClass(aClassName);
}
CPStringFromClass = function(aClass)
{
    return class_getName(aClass);
}
CPOrderedAscending = -1;
CPOrderedSame = 0;
CPOrderedDescending = 1;
CPNotFound = -1;p;13;CPOperation.jt;6034;@STATIC;1.0;i;9;CPArray.ji;10;CPObject.jt;5987;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPObject.j", YES);
//@global CPKeyValueObservingOptionNew
CPOperationQueuePriorityVeryLow = -8;
CPOperationQueuePriorityLow = -4;
CPOperationQueuePriorityNormal = 0;
CPOperationQueuePriorityHigh = 4;
CPOperationQueuePriorityVeryHigh = 8;
{var the_class = objj_allocateClassPair(CPObject, "CPOperation"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("operations"), new objj_ivar("_cancelled"), new objj_ivar("_executing"), new objj_ivar("_finished"), new objj_ivar("_ready"), new objj_ivar("_queuePriority"), new objj_ivar("_completionFunction"), new objj_ivar("_dependencies")]);

















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("main"), function $CPOperation__main(self, _cmd)
{
}
,["void"]), new objj_method(sel_getUid("init"), function $CPOperation__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPOperation").super_class }, "init");
    if (self)
    {
        self._cancelled = NO;
        self._executing = NO;
        self._finished = NO;
        self._ready = YES;
        self._dependencies = objj_msgSend(objj_msgSend(CPArray, "alloc"), "init");
        self._queuePriority = CPOperationQueuePriorityNormal;
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("start"), function $CPOperation__start(self, _cmd)
{
    if (!self._cancelled)
    {
        objj_msgSend(self, "willChangeValueForKey:", "isExecuting");
        self._executing = YES;
        objj_msgSend(self, "didChangeValueForKey:", "isExecuting");
        objj_msgSend(self, "main");
        if (self._completionFunction)
        {
            self._completionFunction();
        }
        objj_msgSend(self, "willChangeValueForKey:", "isExecuting");
        self._executing = NO;
        objj_msgSend(self, "didChangeValueForKey:", "isExecuting");
        objj_msgSend(self, "willChangeValueForKey:", "isFinished");
        self._finished = YES;
        objj_msgSend(self, "didChangeValueForKey:", "isFinished");
    }
}
,["void"]), new objj_method(sel_getUid("isCancelled"), function $CPOperation__isCancelled(self, _cmd)
{
    return self._cancelled;
}
,["BOOL"]), new objj_method(sel_getUid("isExecuting"), function $CPOperation__isExecuting(self, _cmd)
{
    return self._executing;
}
,["BOOL"]), new objj_method(sel_getUid("isFinished"), function $CPOperation__isFinished(self, _cmd)
{
    return self._finished;
}
,["BOOL"]), new objj_method(sel_getUid("isConcurrent"), function $CPOperation__isConcurrent(self, _cmd)
{
    return NO;
}
,["BOOL"]), new objj_method(sel_getUid("isReady"), function $CPOperation__isReady(self, _cmd)
{
    return self._ready;
}
,["BOOL"]), new objj_method(sel_getUid("completionFunction"), function $CPOperation__completionFunction(self, _cmd)
{
    return self._completionFunction;
}
,["JSObject"]), new objj_method(sel_getUid("setCompletionFunction:"), function $CPOperation__setCompletionFunction_(self, _cmd, aJavaScriptFunction)
{
    self._completionFunction = aJavaScriptFunction;
}
,["void","JSObject"]), new objj_method(sel_getUid("addDependency:"), function $CPOperation__addDependency_(self, _cmd, anOperation)
{
    objj_msgSend(self, "willChangeValueForKey:", "dependencies");
    objj_msgSend(anOperation, "addObserver:forKeyPath:options:context:", self, "isFinished", (CPKeyValueObservingOptionNew), NULL);
    objj_msgSend(self._dependencies, "addObject:", anOperation);
    objj_msgSend(self, "didChangeValueForKey:", "dependencies");
    objj_msgSend(self, "_updateIsReadyState");
}
,["void","CPOperation"]), new objj_method(sel_getUid("removeDependency:"), function $CPOperation__removeDependency_(self, _cmd, anOperation)
{
    objj_msgSend(self, "willChangeValueForKey:", "dependencies");
    objj_msgSend(self._dependencies, "removeObject:", anOperation);
    objj_msgSend(anOperation, "removeObserver:forKeyPath:", self, "isFinished");
    objj_msgSend(self, "didChangeValueForKey:", "dependencies");
    objj_msgSend(self, "_updateIsReadyState");
}
,["void","CPOperation"]), new objj_method(sel_getUid("dependencies"), function $CPOperation__dependencies(self, _cmd)
{
    return self._dependencies;
}
,["CPArray"]), new objj_method(sel_getUid("waitUntilFinished"), function $CPOperation__waitUntilFinished(self, _cmd)
{
}
,["void"]), new objj_method(sel_getUid("cancel"), function $CPOperation__cancel(self, _cmd)
{
    objj_msgSend(self, "willChangeValueForKey:", "isCancelled");
    self._cancelled = YES;
    objj_msgSend(self, "didChangeValueForKey:", "isCancelled");
}
,["void"]), new objj_method(sel_getUid("setQueuePriority:"), function $CPOperation__setQueuePriority_(self, _cmd, priority)
{
    self._queuePriority = priority;
}
,["void","int"]), new objj_method(sel_getUid("queuePriority"), function $CPOperation__queuePriority(self, _cmd)
{
    return self._queuePriority;
}
,["int"]), new objj_method(sel_getUid("observeValueForKeyPath:ofObject:change:context:"), function $CPOperation__observeValueForKeyPath_ofObject_change_context_(self, _cmd, keyPath, object, change, context)
{
    if (keyPath == "isFinished")
    {
        objj_msgSend(self, "_updateIsReadyState");
    }
}
,["void","CPString","id","CPDictionary","void"]), new objj_method(sel_getUid("_updateIsReadyState"), function $CPOperation___updateIsReadyState(self, _cmd)
{
    var newReady = YES;
    if (self._dependencies && objj_msgSend(self._dependencies, "count") > 0)
    {
        var i = 0;
        for (i = 0; i < objj_msgSend(self._dependencies, "count"); i++)
        {
            if (!objj_msgSend(objj_msgSend(self._dependencies, "objectAtIndex:", i), "isFinished"))
            {
                newReady = NO;
            }
        }
    }
    if (newReady != self._ready)
    {
        objj_msgSend(self, "willChangeValueForKey:", "isReady");
        self._ready = newReady;
        objj_msgSend(self, "didChangeValueForKey:", "isReady");
    }
}
,["void"])]);
}p;18;CPOperationQueue.jt;7970;@STATIC;1.0;i;9;CPArray.ji;21;CPFunctionOperation.ji;23;CPInvocationOperation.ji;10;CPObject.ji;13;CPOperation.ji;10;CPString.ji;9;CPTimer.jt;7823;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPFunctionOperation.j", YES);
objj_executeFile("CPInvocationOperation.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPOperation.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("CPTimer.j", YES);
var cpOperationMainQueue = nil;
{var the_class = objj_allocateClassPair(CPObject, "CPOperationQueue"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_operations"), new objj_ivar("_suspended"), new objj_ivar("_name"), new objj_ivar("_timer")]);















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("name"), function $CPOperationQueue__name(self, _cmd)
{
return self._name;
}
,["CPString"]), new objj_method(sel_getUid("setName:"), function $CPOperationQueue__setName_(self, _cmd, newValue)
{
self._name = newValue;
}
,["void","CPString"]), new objj_method(sel_getUid("init"), function $CPOperationQueue__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPOperationQueue").super_class }, "init");
    if (self)
    {
        self._operations = objj_msgSend(objj_msgSend(CPArray, "alloc"), "init");
        self._suspended = NO;
        self._timer = objj_msgSend(CPTimer, "scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:", 0.01, self, sel_getUid("_runNextOpsInQueue"), nil, YES);
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("_runNextOpsInQueue"), function $CPOperationQueue___runNextOpsInQueue(self, _cmd)
{
    if (!self._suspended && objj_msgSend(self, "operationCount") > 0)
    {
        var i = 0,
            count = objj_msgSend(self._operations, "count");
        for (; i < count; i++)
        {
            var op = objj_msgSend(self._operations, "objectAtIndex:", i);
            if (objj_msgSend(op, "isReady") && !objj_msgSend(op, "isCancelled") && !objj_msgSend(op, "isFinished") && !objj_msgSend(op, "isExecuting"))
            {
                objj_msgSend(op, "start");
            }
        }
    }
}
,["void"]), new objj_method(sel_getUid("_enableTimer:"), function $CPOperationQueue___enableTimer_(self, _cmd, enable)
{
    if (!enable)
    {
        if (self._timer)
        {
            objj_msgSend(self._timer, "invalidate");
            self._timer = nil;
        }
    }
    else
    {
        if (!self._timer)
        {
            self._timer = objj_msgSend(CPTimer, "scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:", 0.01, self, sel_getUid("_runNextOpsInQueue"), nil, YES);
        }
    }
}
,["void","BOOL"]), new objj_method(sel_getUid("addOperation:"), function $CPOperationQueue__addOperation_(self, _cmd, anOperation)
{
    objj_msgSend(self, "willChangeValueForKey:", "operations");
    objj_msgSend(self, "willChangeValueForKey:", "operationCount");
    objj_msgSend(self._operations, "addObject:", anOperation);
    objj_msgSend(self, "_sortOpsByPriority:", self._operations);
    objj_msgSend(self, "didChangeValueForKey:", "operations");
    objj_msgSend(self, "didChangeValueForKey:", "operationCount");
}
,["void","CPOperation"]), new objj_method(sel_getUid("addOperations:waitUntilFinished:"), function $CPOperationQueue__addOperations_waitUntilFinished_(self, _cmd, ops, wait)
{
    if (ops)
    {
        if (wait)
        {
            objj_msgSend(self, "_sortOpsByPriority:", ops);
            objj_msgSend(self, "_runOpsSynchronously:", ops);
        }
        objj_msgSend(self._operations, "addObjectsFromArray:", ops);
        objj_msgSend(self, "_sortOpsByPriority:", self._operations);
    }
}
,["void","CPArray","BOOL"]), new objj_method(sel_getUid("addOperationWithFunction:"), function $CPOperationQueue__addOperationWithFunction_(self, _cmd, aFunction)
{
    objj_msgSend(self, "addOperation:", objj_msgSend(CPFunctionOperation, "functionOperationWithFunction:", aFunction));
}
,["void","JSObject"]), new objj_method(sel_getUid("operations"), function $CPOperationQueue__operations(self, _cmd)
{
    return self._operations;
}
,["CPArray"]), new objj_method(sel_getUid("operationCount"), function $CPOperationQueue__operationCount(self, _cmd)
{
    if (self._operations)
    {
        return objj_msgSend(self._operations, "count");
    }
    return 0;
}
,["int"]), new objj_method(sel_getUid("cancelAllOperations"), function $CPOperationQueue__cancelAllOperations(self, _cmd)
{
    if (self._operations)
    {
        var i = 0,
            count = objj_msgSend(self._operations, "count");
        for (; i < count; i++)
        {
            objj_msgSend(objj_msgSend(self._operations, "objectAtIndex:", i), "cancel");
        }
    }
}
,["void"]), new objj_method(sel_getUid("waitUntilAllOperationsAreFinished"), function $CPOperationQueue__waitUntilAllOperationsAreFinished(self, _cmd)
{
    objj_msgSend(self, "_enableTimer:", NO);
    objj_msgSend(self, "_runOpsSynchronously:", self._operations);
    if (!self._suspended)
    {
        objj_msgSend(self, "_enableTimer:", YES);
    }
}
,["void"]), new objj_method(sel_getUid("maxConcurrentOperationCount"), function $CPOperationQueue__maxConcurrentOperationCount(self, _cmd)
{
    return 1;
}
,["int"]), new objj_method(sel_getUid("setSuspended:"), function $CPOperationQueue__setSuspended_(self, _cmd, suspend)
{
    self._suspended = suspend;
    objj_msgSend(self, "_enableTimer:", !suspend);
}
,["void","BOOL"]), new objj_method(sel_getUid("isSuspended"), function $CPOperationQueue__isSuspended(self, _cmd)
{
    return self._suspended;
}
,["BOOL"]), new objj_method(sel_getUid("_sortOpsByPriority:"), function $CPOperationQueue___sortOpsByPriority_(self, _cmd, someOps)
{
    if (someOps)
    {
        objj_msgSend(someOps, "sortUsingFunction:context:", function(lhs, rhs)
        {
            if (objj_msgSend(lhs, "queuePriority") < objj_msgSend(rhs, "queuePriority"))
            {
                return 1;
            }
            else
            {
                if (objj_msgSend(lhs, "queuePriority") > objj_msgSend(rhs, "queuePriority"))
                {
                    return -1;
                }
                else
                {
                    return 0;
                }
            }
        }, nil);
    }
}
,["void","CPArray"]), new objj_method(sel_getUid("_runOpsSynchronously:"), function $CPOperationQueue___runOpsSynchronously_(self, _cmd, ops)
{
    if (ops)
    {
        var keepGoing = YES;
        while (keepGoing)
        {
            var i = 0,
                count = objj_msgSend(ops, "count");
            keepGoing = NO;
            for (; i < count; i++)
            {
                var op = objj_msgSend(ops, "objectAtIndex:", i);
                if (objj_msgSend(op, "isReady") && !objj_msgSend(op, "isCancelled") && !objj_msgSend(op, "isFinished") && !objj_msgSend(op, "isExecuting"))
                {
                    objj_msgSend(op, "start");
                }
            }
            for (i = 0; i < count; i++)
            {
                var op = objj_msgSend(ops, "objectAtIndex:", i);
                if (!objj_msgSend(op, "isFinished") && !objj_msgSend(op, "isCancelled"))
                {
                    keepGoing = YES;
                }
            }
        }
    }
}
,["void","CPArray"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("mainQueue"), function $CPOperationQueue__mainQueue(self, _cmd)
{
    if (!cpOperationMainQueue)
    {
        cpOperationMainQueue = objj_msgSend(objj_msgSend(CPOperationQueue, "alloc"), "init");
        objj_msgSend(cpOperationMainQueue, "setName:", "main");
    }
    return cpOperationMainQueue;
}
,["CPOperationQueue"]), new objj_method(sel_getUid("currentQueue"), function $CPOperationQueue__currentQueue(self, _cmd)
{
    return objj_msgSend(CPOperationQueue, "mainQueue");
}
,["CPOperationQueue"])]);
}p;29;CPPropertyListSerialization.jt;2206;@STATIC;1.0;i;13;CPException.ji;10;CPObject.jt;2154;objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
CPPropertyListUnknownFormat = 0;
CPPropertyListOpenStepFormat = kCFPropertyListOpenStepFormat;
CPPropertyListXMLFormat_v1_0 = kCFPropertyListXMLFormat_v1_0;
CPPropertyListBinaryFormat_v1_0 = kCFPropertyListBinaryFormat_v1_0;
CPPropertyList280NorthFormat_v1_0 = kCFPropertyList280NorthFormat_v1_0;
{var the_class = objj_allocateClassPair(CPObject, "CPPropertyListSerialization"),
meta_class = the_class.isa;
objj_registerClassPair(the_class);
class_addMethods(meta_class, [new objj_method(sel_getUid("dataFromPropertyList:format:"), function $CPPropertyListSerialization__dataFromPropertyList_format_(self, _cmd, aPlist, aFormat)
{
    return CPPropertyListCreateData(aPlist, aFormat);
}
,["CPData","id","CPPropertyListFormat"]), new objj_method(sel_getUid("propertyListFromData:format:"), function $CPPropertyListSerialization__propertyListFromData_format_(self, _cmd, data, aFormat)
{
    return CPPropertyListCreateFromData(data, aFormat);
}
,["id","CPData","CPPropertyListFormat"])]);
}
{
var the_class = objj_getClass("CPPropertyListSerialization")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPPropertyListSerialization\"");
var meta_class = the_class.isa;
class_addMethods(meta_class, [new objj_method(sel_getUid("dataFromPropertyList:format:errorDescription:"), function $CPPropertyListSerialization__dataFromPropertyList_format_errorDescription_(self, _cmd, aPlist, aFormat, anErrorString)
{
    _CPReportLenientDeprecation(self, _cmd, sel_getUid("dataFromPropertyList:format:"));
    return objj_msgSend(self, "dataFromPropertyList:format:", aPlist, aFormat);
}
,["CPData","id","CPPropertyListFormat","id"]), new objj_method(sel_getUid("propertyListFromData:format:errorDescription:"), function $CPPropertyListSerialization__propertyListFromData_format_errorDescription_(self, _cmd, data, aFormat, errorString)
{
    _CPReportLenientDeprecation(self, _cmd, sel_getUid("propertyListFromData:format:"));
    return objj_msgSend(self, "propertyListFromData:format:", data, aFormat);
}
,["id","CPData","CPPropertyListFormat","id"])]);
}p;9;CPProxy.jt;4968;@STATIC;1.0;i;13;CPException.ji;14;CPInvocation.ji;10;CPObject.ji;10;CPString.jt;4882;objj_executeFile("CPException.j", YES);
objj_executeFile("CPInvocation.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
{var the_class = objj_allocateClassPair(Nil, "CPProxy"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("isa")]);




















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("methodSignatureForSelector:"), function $CPProxy__methodSignatureForSelector_(self, _cmd, aSelector)
{
    objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "-methodSignatureForSelector: called on abstract CPProxy class.");
}
,["CPMethodSignature","SEL"]), new objj_method(sel_getUid("forwardInvocation:"), function $CPProxy__forwardInvocation_(self, _cmd, anInvocation)
{
    objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "-forwardInvocation: called on abstract CPProxy class.");
}
,["void","CPInvocation"]), new objj_method(sel_getUid("forward::"), function $CPProxy__forward__(self, _cmd, aSelector, args)
{
    return objj_msgSend(CPObject, "methodForSelector:", _cmd)(self, _cmd, aSelector, args);
}
,["void","SEL","marg_list"]), new objj_method(sel_getUid("hash"), function $CPProxy__hash(self, _cmd)
{
    return objj_msgSend(self, "UID");
}
,["unsigned"]), new objj_method(sel_getUid("UID"), function $CPProxy__UID(self, _cmd)
{
    if (typeof self._UID === "undefined")
        self._UID = objj_generateObjectUID();
    return self._UID;
}
,["unsigned"]), new objj_method(sel_getUid("isEqual:"), function $CPProxy__isEqual_(self, _cmd, anObject)
{
   return self === anObject;
}
,["BOOL","id"]), new objj_method(sel_getUid("self"), function $CPProxy__self(self, _cmd)
{
    return self;
}
,["id"]), new objj_method(sel_getUid("class"), function $CPProxy__class(self, _cmd)
{
    return self.isa;
}
,["Class"]), new objj_method(sel_getUid("superclass"), function $CPProxy__superclass(self, _cmd)
{
    return class_getSuperclass(self.isa);
}
,["Class"]), new objj_method(sel_getUid("performSelector:"), function $CPProxy__performSelector_(self, _cmd, aSelector)
{
    return objj_msgSend(self, aSelector);
}
,["id","SEL"]), new objj_method(sel_getUid("performSelector:withObject:"), function $CPProxy__performSelector_withObject_(self, _cmd, aSelector, anObject)
{
    return objj_msgSend(self, aSelector, anObject);
}
,["id","SEL","id"]), new objj_method(sel_getUid("performSelector:withObject:withObject:"), function $CPProxy__performSelector_withObject_withObject_(self, _cmd, aSelector, anObject, anotherObject)
{
    return objj_msgSend(self, aSelector, anObject, anotherObject);
}
,["id","SEL","id","id"]), new objj_method(sel_getUid("isProxy"), function $CPProxy__isProxy(self, _cmd)
{
    return YES;
}
,["BOOL"]), new objj_method(sel_getUid("isKindOfClass:"), function $CPProxy__isKindOfClass_(self, _cmd, aClass)
{
    var signature = objj_msgSend(self, "methodSignatureForSelector:", _cmd),
        invocation = objj_msgSend(CPInvocation, "invocationWithMethodSignature:", signature);
   objj_msgSend(self, "forwardInvocation:", invocation);
   return objj_msgSend(invocation, "returnValue");
}
,["BOOL","Class"]), new objj_method(sel_getUid("isMemberOfClass:"), function $CPProxy__isMemberOfClass_(self, _cmd, aClass)
{
    var signature = objj_msgSend(self, "methodSignatureForSelector:", _cmd),
        invocation = objj_msgSend(CPInvocation, "invocationWithMethodSignature:", signature);
   objj_msgSend(self, "forwardInvocation:", invocation);
   return objj_msgSend(invocation, "returnValue");
}
,["BOOL","Class"]), new objj_method(sel_getUid("respondsToSelector:"), function $CPProxy__respondsToSelector_(self, _cmd, aSelector)
{
    var signature = objj_msgSend(self, "methodSignatureForSelector:", _cmd),
        invocation = objj_msgSend(CPInvocation, "invocationWithMethodSignature:", signature);
   objj_msgSend(self, "forwardInvocation:", invocation);
   return objj_msgSend(invocation, "returnValue");
}
,["BOOL","SEL"]), new objj_method(sel_getUid("description"), function $CPProxy__description(self, _cmd)
{
    return "<" + class_getName(self.isa) + " 0x" + objj_msgSend(CPString, "stringWithHash:", objj_msgSend(self, "UID")) + ">";
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("load"), function $CPProxy__load(self, _cmd)
{
}
,["void"]), new objj_method(sel_getUid("initialize"), function $CPProxy__initialize(self, _cmd)
{
}
,["void"]), new objj_method(sel_getUid("class"), function $CPProxy__class(self, _cmd)
{
    return self;
}
,["Class"]), new objj_method(sel_getUid("alloc"), function $CPProxy__alloc(self, _cmd)
{
    return class_createInstance(self);
}
,["id"]), new objj_method(sel_getUid("respondsToSelector:"), function $CPProxy__respondsToSelector_(self, _cmd, selector)
{
    return !!class_getInstanceMethod(isa, aSelector);
}
,["BOOL","SEL"])]);
}p;9;CPRange.jt;1665;@STATIC;1.0;t;1646;CPMakeRange = function(location, length) { return { location:(location), length:length }; }
CPMakeRangeCopy = function(aRange) { return { location:(aRange).location, length:(aRange).length }; }
CPEmptyRange = function(aRange) { return ((aRange).length === 0); }
CPMaxRange = function(aRange) { return ((aRange).location + (aRange).length); }
CPEqualRanges = function(lhsRange, rhsRange)
{
    return ((lhsRange.location === rhsRange.location) && (lhsRange.length === rhsRange.length));
}
CPLocationInRange = function(aLocation, aRange) { return (((aLocation) >= (aRange).location) && ((aLocation) < ((aRange).location + (aRange).length))); }
CPUnionRange = function(lhsRange, rhsRange)
{
    var location = MIN(lhsRange.location, rhsRange.location);
    return CPMakeRange(location, MAX(CPMaxRange(lhsRange), CPMaxRange(rhsRange)) - location);
}
CPIntersectionRange = function(lhsRange, rhsRange)
{
    if (CPMaxRange(lhsRange) < rhsRange.location || CPMaxRange(rhsRange) < lhsRange.location)
        return CPMakeRange(0, 0);
    var location = MAX(lhsRange.location, rhsRange.location);
    return CPMakeRange(location, MIN(CPMaxRange(lhsRange), CPMaxRange(rhsRange)) - location);
}
CPRangeInRange = function(lhsRange, rhsRange)
{
    return (lhsRange.location <= rhsRange.location && CPMaxRange(lhsRange) >= CPMaxRange(rhsRange));
}
CPStringFromRange = function(aRange)
{
    return "{" + aRange.location + ", " + aRange.length + "}";
}
CPRangeFromString = function(aString)
{
    var comma = aString.indexOf(',');
    return { location:parseInt(aString.substr(1, comma - 1)), length:parseInt(aString.substring(comma + 1, aString.length)) };
}p;11;CPRunLoop.jt;10934;@STATIC;1.0;i;9;CPArray.ji;8;CPDate.ji;10;CPObject.ji;10;CPString.jt;10859;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPDate.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
CPDefaultRunLoopMode = "CPDefaultRunLoopMode";
_CPRunLoopPerformCompare = function(lhs, rhs)
{
    return objj_msgSend(rhs, "order") - objj_msgSend(lhs, "order");
}
var _CPRunLoopPerformPool = [],
    _CPRunLoopPerformPoolCapacity = 5;
{var the_class = objj_allocateClassPair(CPObject, "_CPRunLoopPerform"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_target"), new objj_ivar("_selector"), new objj_ivar("_argument"), new objj_ivar("_order"), new objj_ivar("_runLoopModes"), new objj_ivar("_isValid")]);







objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithSelector:target:argument:order:modes:"), function $_CPRunLoopPerform__initWithSelector_target_argument_order_modes_(self, _cmd, aSelector, aTarget, anArgument, anOrder, modes)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPRunLoopPerform").super_class }, "init");
    if (self)
    {
        self._selector = aSelector;
        self._target = aTarget;
        self._argument = anArgument;
        self._order = anOrder;
        self._runLoopModes = modes;
        self._isValid = YES;
    }
    return self;
}
,["id","SEL","SEL","id","unsigned","CPArray"]), new objj_method(sel_getUid("selector"), function $_CPRunLoopPerform__selector(self, _cmd)
{
    return self._selector;
}
,["SEL"]), new objj_method(sel_getUid("target"), function $_CPRunLoopPerform__target(self, _cmd)
{
    return self._target;
}
,["id"]), new objj_method(sel_getUid("argument"), function $_CPRunLoopPerform__argument(self, _cmd)
{
    return self._argument;
}
,["id"]), new objj_method(sel_getUid("order"), function $_CPRunLoopPerform__order(self, _cmd)
{
    return self._order;
}
,["unsigned"]), new objj_method(sel_getUid("fireInMode:"), function $_CPRunLoopPerform__fireInMode_(self, _cmd, aRunLoopMode)
{
    if (!self._isValid)
        return YES;
    if (objj_msgSend(self._runLoopModes, "containsObject:", aRunLoopMode))
    {
        objj_msgSend(self._target, "performSelector:withObject:", self._selector, self._argument);
        return YES;
    }
    return NO;
}
,["BOOL","CPString"]), new objj_method(sel_getUid("invalidate"), function $_CPRunLoopPerform__invalidate(self, _cmd)
{
    self._isValid = NO;
}
,["void"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("_poolPerform:"), function $_CPRunLoopPerform___poolPerform_(self, _cmd, aPerform)
{
    if (!aPerform || _CPRunLoopPerformPool.length >= _CPRunLoopPerformPoolCapacity)
        return;
    _CPRunLoopPerformPool.push(aPerform);
}
,["void","_CPRunLoopPerform"]), new objj_method(sel_getUid("performWithSelector:target:argument:order:modes:"), function $_CPRunLoopPerform__performWithSelector_target_argument_order_modes_(self, _cmd, aSelector, aTarget, anArgument, anOrder, modes)
{
    if (_CPRunLoopPerformPool.length)
    {
        var perform = _CPRunLoopPerformPool.pop();
        perform._target = aTarget;
        perform._selector = aSelector;
        perform._argument = anArgument;
        perform._order = anOrder;
        perform._runLoopModes = modes;
        perform._isValid = YES;
        return perform;
    }
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithSelector:target:argument:order:modes:", aSelector, aTarget, anArgument, anOrder, modes);
}
,["_CPRunLoopPerform","SEL","id","id","unsigned","CPArray"])]);
}
var CPRunLoopLastNativeRunLoop = 0;
{var the_class = objj_allocateClassPair(CPObject, "CPRunLoop"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_runLoopLock"), new objj_ivar("_timersForModes"), new objj_ivar("_nativeTimersForModes"), new objj_ivar("_nextTimerFireDatesForModes"), new objj_ivar("_didAddTimer"), new objj_ivar("_effectiveDate"), new objj_ivar("_orderedPerforms"), new objj_ivar("_runLoopInsuranceTimer")]);







objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPRunLoop__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPRunLoop").super_class }, "init");
    if (self)
    {
        self._orderedPerforms = [];
        self._timersForModes = {};
        self._nativeTimersForModes = {};
        self._nextTimerFireDatesForModes = {};
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("performSelector:target:argument:order:modes:"), function $CPRunLoop__performSelector_target_argument_order_modes_(self, _cmd, aSelector, aTarget, anArgument, anOrder, modes)
{
    var perform = objj_msgSend(_CPRunLoopPerform, "performWithSelector:target:argument:order:modes:", aSelector, aTarget, anArgument, anOrder, modes),
        count = self._orderedPerforms.length;
    while (count--)
        if (anOrder < objj_msgSend(self._orderedPerforms[count], "order"))
            break;
    self._orderedPerforms.splice(count + 1, 0, perform);
}
,["void","SEL","id","id","int","CPArray"]), new objj_method(sel_getUid("cancelPerformSelector:target:argument:"), function $CPRunLoop__cancelPerformSelector_target_argument_(self, _cmd, aSelector, aTarget, anArgument)
{
    var count = self._orderedPerforms.length;
    while (count--)
    {
        var perform = self._orderedPerforms[count];
        if (objj_msgSend(perform, "selector") === aSelector && objj_msgSend(perform, "target") == aTarget && objj_msgSend(perform, "argument") == anArgument)
            objj_msgSend(self._orderedPerforms[count], "invalidate");
    }
}
,["void","SEL","id","id"]), new objj_method(sel_getUid("performSelectors"), function $CPRunLoop__performSelectors(self, _cmd)
{
    objj_msgSend(self, "limitDateForMode:", CPDefaultRunLoopMode);
}
,["void"]), new objj_method(sel_getUid("addTimer:forMode:"), function $CPRunLoop__addTimer_forMode_(self, _cmd, aTimer, aMode)
{
    if (self._timersForModes[aMode])
        self._timersForModes[aMode].push(aTimer);
    else
        self._timersForModes[aMode] = [aTimer];
    self._didAddTimer = YES;
    if (!aTimer._lastNativeRunLoopsForModes)
        aTimer._lastNativeRunLoopsForModes = {};
    aTimer._lastNativeRunLoopsForModes[aMode] = CPRunLoopLastNativeRunLoop;
    if (objj_msgSend(CFBundle.environments(), "indexOfObject:", ("Browser")) !== CPNotFound)
    {
        if (!self._runLoopInsuranceTimer)
            self._runLoopInsuranceTimer = window.setNativeTimeout(function()
            {
                objj_msgSend(self, "limitDateForMode:", CPDefaultRunLoopMode);
            }, 0);
    }
}
,["void","CPTimer","CPString"]), new objj_method(sel_getUid("limitDateForMode:"), function $CPRunLoop__limitDateForMode_(self, _cmd, aMode)
{
    if (self._runLoopLock)
        return;
    self._runLoopLock = YES;
    if (objj_msgSend(CFBundle.environments(), "indexOfObject:", ("Browser")) !== CPNotFound)
    {
        if (self._runLoopInsuranceTimer)
        {
            window.clearNativeTimeout(self._runLoopInsuranceTimer);
            self._runLoopInsuranceTimer = nil;
        }
    }
    var now = self._effectiveDate ? objj_msgSend(self._effectiveDate, "laterDate:", objj_msgSend(CPDate, "date")) : objj_msgSend(CPDate, "date"),
        nextFireDate = nil,
        nextTimerFireDate = self._nextTimerFireDatesForModes[aMode];
    if (self._didAddTimer || nextTimerFireDate && nextTimerFireDate <= now)
    {
        self._didAddTimer = NO;
        if (self._nativeTimersForModes[aMode] !== nil)
        {
            window.clearNativeTimeout(self._nativeTimersForModes[aMode]);
            self._nativeTimersForModes[aMode] = nil;
        }
        var timers = self._timersForModes[aMode],
            index = timers.length;
        self._timersForModes[aMode] = nil;
        while (index--)
        {
            var timer = timers[index];
            if (timer._lastNativeRunLoopsForModes[aMode] < CPRunLoopLastNativeRunLoop && timer._isValid && timer._fireDate <= now)
                objj_msgSend(timer, "fire");
            if (timer._isValid)
                nextFireDate = (nextFireDate === nil) ? timer._fireDate : objj_msgSend(nextFireDate, "earlierDate:", timer._fireDate);
            else
            {
                timer._lastNativeRunLoopsForModes[aMode] = 0;
                timers.splice(index, 1);
            }
        }
        var newTimers = self._timersForModes[aMode];
        if (newTimers && newTimers.length)
        {
            index = newTimers.length;
            while (index--)
            {
                var timer = newTimers[index];
                if (objj_msgSend(timer, "isValid"))
                    nextFireDate = (nextFireDate === nil) ? timer._fireDate : objj_msgSend(nextFireDate, "earlierDate:", timer._fireDate);
                else
                    newTimers.splice(index, 1);
            }
            self._timersForModes[aMode] = newTimers.concat(timers);
        }
        else
            self._timersForModes[aMode] = timers;
        self._nextTimerFireDatesForModes[aMode] = nextFireDate;
        if (self._nextTimerFireDatesForModes[aMode] !== nil)
            self._nativeTimersForModes[aMode] = window.setNativeTimeout(function()
                {
                    self._effectiveDate = nextFireDate;
                    self._nativeTimersForModes[aMode] = nil;
                    ++CPRunLoopLastNativeRunLoop;
                    objj_msgSend(self, "limitDateForMode:", aMode);
                    self._effectiveDate = nil;
                }, MAX(0, objj_msgSend(nextFireDate, "timeIntervalSinceNow") * 1000));
    }
    var performs = self._orderedPerforms,
        index = performs.length;
    self._orderedPerforms = [];
    while (index--)
    {
        var perform = performs[index];
        if (objj_msgSend(perform, "fireInMode:", CPDefaultRunLoopMode))
        {
            objj_msgSend(_CPRunLoopPerform, "_poolPerform:", perform);
            performs.splice(index, 1);
        }
    }
    if (self._orderedPerforms.length)
    {
        self._orderedPerforms = self._orderedPerforms.concat(performs);
        self._orderedPerforms.sort(_CPRunLoopPerformCompare);
    }
    else
        self._orderedPerforms = performs;
    self._runLoopLock = NO;
    return nextFireDate;
}
,["CPDate","CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("initialize"), function $CPRunLoop__initialize(self, _cmd)
{
    if (self !== objj_msgSend(CPRunLoop, "class"))
        return;
    CPMainRunLoop = objj_msgSend(objj_msgSend(CPRunLoop, "alloc"), "init");
}
,["void"]), new objj_method(sel_getUid("currentRunLoop"), function $CPRunLoop__currentRunLoop(self, _cmd)
{
    return CPMainRunLoop;
}
,["CPRunLoop"]), new objj_method(sel_getUid("mainRunLoop"), function $CPRunLoop__mainRunLoop(self, _cmd)
{
    return CPMainRunLoop;
}
,["CPRunLoop"])]);
}p;11;CPScanner.jt;10435;@STATIC;1.0;i;16;CPCharacterSet.ji;14;CPDictionary.ji;10;CPString.jt;10360;objj_executeFile("CPCharacterSet.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPString.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPScanner"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_string"), new objj_ivar("_locale"), new objj_ivar("_scanLocation"), new objj_ivar("_caseSensitive"), new objj_ivar("_charactersToBeSkipped")]);





























objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithString:"), function $CPScanner__initWithString_(self, _cmd, aString)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPScanner").super_class }, "init"))
    {
        self._string = objj_msgSend(aString, "copy");
        self._scanLocation = 0;
        self._charactersToBeSkipped = objj_msgSend(CPCharacterSet, "whitespaceCharacterSet");
        self._caseSensitive = NO;
    }
    return self;
}
,["id","CPString"]), new objj_method(sel_getUid("copy"), function $CPScanner__copy(self, _cmd)
{
    var copy = objj_msgSend(objj_msgSend(CPScanner, "alloc"), "initWithString:", objj_msgSend(self, "string"));
    objj_msgSend(copy, "setCharactersToBeSkipped:", objj_msgSend(self, "charactersToBeSkipped"));
    objj_msgSend(copy, "setCaseSensitive:", objj_msgSend(self, "caseSensitive"));
    objj_msgSend(copy, "setLocale:", objj_msgSend(self, "locale"));
    objj_msgSend(copy, "setScanLocation:", objj_msgSend(self, "scanLocation"));
    return copy;
}
,["id"]), new objj_method(sel_getUid("locale"), function $CPScanner__locale(self, _cmd)
{
    return self._locale;
}
,["CPDictionary"]), new objj_method(sel_getUid("setLocale:"), function $CPScanner__setLocale_(self, _cmd, aLocale)
{
    self._locale = aLocale;
}
,["void","CPDictionary"]), new objj_method(sel_getUid("setCaseSensitive:"), function $CPScanner__setCaseSensitive_(self, _cmd, flag)
{
    self._caseSensitive = flag;
}
,["void","BOOL"]), new objj_method(sel_getUid("caseSensitive"), function $CPScanner__caseSensitive(self, _cmd)
{
    return self._caseSensitive;
}
,["BOOL"]), new objj_method(sel_getUid("string"), function $CPScanner__string(self, _cmd)
{
    return self._string;
}
,["CPString"]), new objj_method(sel_getUid("charactersToBeSkipped"), function $CPScanner__charactersToBeSkipped(self, _cmd)
{
    return self._charactersToBeSkipped;
}
,["CPCharacterSet"]), new objj_method(sel_getUid("setCharactersToBeSkipped:"), function $CPScanner__setCharactersToBeSkipped_(self, _cmd, c)
{
    self._charactersToBeSkipped = c;
}
,["void","CPCharacterSet"]), new objj_method(sel_getUid("isAtEnd"), function $CPScanner__isAtEnd(self, _cmd)
{
    return self._scanLocation == self._string.length;
}
,["BOOL"]), new objj_method(sel_getUid("scanLocation"), function $CPScanner__scanLocation(self, _cmd)
{
    return self._scanLocation;
}
,["int"]), new objj_method(sel_getUid("setScanLocation:"), function $CPScanner__setScanLocation_(self, _cmd, aLocation)
{
    if (aLocation > self._string.length)
        aLocation = self._string.length;
    else if (aLocation < 0)
        aLocation = 0;
    self._scanLocation = aLocation;
}
,["void","int"]), new objj_method(sel_getUid("_performScanWithSelector:withObject:into:"), function $CPScanner___performScanWithSelector_withObject_into_(self, _cmd, s, arg, ref)
{
    var ret = objj_msgSend(self, "performSelector:withObject:", s, arg);
    if (ret == nil)
        return NO;
    if (ref != nil)
        ref(ret);
    return YES;
}
,["BOOL","SEL","id","id"]), new objj_method(sel_getUid("scanCharactersFromSet:intoString:"), function $CPScanner__scanCharactersFromSet_intoString_(self, _cmd, scanSet, ref)
{
    return objj_msgSend(self, "_performScanWithSelector:withObject:into:", sel_getUid("scanCharactersFromSet:"), scanSet, ref);
}
,["BOOL","CPCharacterSet","id"]), new objj_method(sel_getUid("scanCharactersFromSet:"), function $CPScanner__scanCharactersFromSet_(self, _cmd, scanSet)
{
    return objj_msgSend(self, "_scanWithSet:breakFlag:", scanSet, NO);
}
,["CPString","CPCharacterSet"]), new objj_method(sel_getUid("scanUpToCharactersFromSet:intoString:"), function $CPScanner__scanUpToCharactersFromSet_intoString_(self, _cmd, scanSet, ref)
{
    return objj_msgSend(self, "_performScanWithSelector:withObject:into:", sel_getUid("scanUpToCharactersFromSet:"), scanSet, ref);
}
,["BOOL","CPCharacterSet","id"]), new objj_method(sel_getUid("scanUpToCharactersFromSet:"), function $CPScanner__scanUpToCharactersFromSet_(self, _cmd, scanSet)
{
    return objj_msgSend(self, "_scanWithSet:breakFlag:", scanSet, YES);
}
,["CPString","CPCharacterSet"]), new objj_method(sel_getUid("_scanWithSet:breakFlag:"), function $CPScanner___scanWithSet_breakFlag_(self, _cmd, scanSet, stop)
{
    if (objj_msgSend(self, "isAtEnd"))
        return nil;
    var current = objj_msgSend(self, "scanLocation"),
        str = nil;
    while (current < self._string.length)
    {
        var c = (self._string.charAt(current));
        if (objj_msgSend(scanSet, "characterIsMember:", c) == stop)
            break;
        if (!objj_msgSend(self._charactersToBeSkipped, "characterIsMember:", c))
        {
            if (!str)
                str = '';
            str += c;
        }
        current++;
    }
    if (str)
        objj_msgSend(self, "setScanLocation:", current);
    return str;
}
,["CPString","CPCharacterSet","BOOL"]), new objj_method(sel_getUid("_movePastCharactersToBeSkipped"), function $CPScanner___movePastCharactersToBeSkipped(self, _cmd)
{
    var current = objj_msgSend(self, "scanLocation"),
        string = objj_msgSend(self, "string"),
        toSkip = objj_msgSend(self, "charactersToBeSkipped");
    while (current < string.length)
    {
        if (!objj_msgSend(toSkip, "characterIsMember:", string.charAt(current)))
            break;
        current++;
    }
    objj_msgSend(self, "setScanLocation:", current);
}
,["void"]), new objj_method(sel_getUid("scanString:intoString:"), function $CPScanner__scanString_intoString_(self, _cmd, aString, ref)
{
    return objj_msgSend(self, "_performScanWithSelector:withObject:into:", sel_getUid("scanString:"), aString, ref);
}
,["BOOL","CPString","id"]), new objj_method(sel_getUid("scanString:"), function $CPScanner__scanString_(self, _cmd, s)
{
    objj_msgSend(self, "_movePastCharactersToBeSkipped");
    if (objj_msgSend(self, "isAtEnd"))
        return nil;
    var currentStr = objj_msgSend(self, "string").substr(objj_msgSend(self, "scanLocation"), s.length);
    if ((self._caseSensitive && currentStr != s) || (!self._caseSensitive && (currentStr.toLowerCase() != s.toLowerCase())))
    {
        return nil;
    }
    else
    {
        objj_msgSend(self, "setScanLocation:", objj_msgSend(self, "scanLocation") + s.length);
        return s;
    }
}
,["CPString","CPString"]), new objj_method(sel_getUid("scanUpToString:intoString:"), function $CPScanner__scanUpToString_intoString_(self, _cmd, aString, ref)
{
    return objj_msgSend(self, "_performScanWithSelector:withObject:into:", sel_getUid("scanUpToString:"), aString, ref);
}
,["BOOL","CPString","id"]), new objj_method(sel_getUid("scanUpToString:"), function $CPScanner__scanUpToString_(self, _cmd, s)
{
    var current = objj_msgSend(self, "scanLocation"),
        str = objj_msgSend(self, "string"),
        captured = nil;
    while (current < str.length)
    {
        var currentStr = str.substr(current, s.length);
        if (currentStr == s || (!self._caseSensitive && currentStr.toLowerCase() == s.toLowerCase()))
            break;
        if (!captured)
            captured = '';
        captured += str.charAt(current);
        current++;
    }
    if (captured)
        objj_msgSend(self, "setScanLocation:", current);
    if (objj_msgSend(self, "charactersToBeSkipped"))
        captured = objj_msgSend(captured, "_stringByTrimmingCharactersInSet:options:", objj_msgSend(self, "charactersToBeSkipped"), _CPCharacterSetTrimAtBeginning);
    return captured;
}
,["CPString","CPString"]), new objj_method(sel_getUid("scanWithParseFunction:"), function $CPScanner__scanWithParseFunction_(self, _cmd, parseFunction)
{
    objj_msgSend(self, "_movePastCharactersToBeSkipped");
    var str = objj_msgSend(self, "string"),
        loc = objj_msgSend(self, "scanLocation");
    if (objj_msgSend(self, "isAtEnd"))
        return 0;
    var s = str.substring(loc, str.length),
        f = parseFunction(s);
    if (isNaN(f))
        return nil;
    loc += (""+f).length;
    var i = 0;
    while (!isNaN(parseFloat(str.substring(loc + i, str.length))))
        {i++;}
    objj_msgSend(self, "setScanLocation:", loc + i);
    return f;
}
,["float","Function"]), new objj_method(sel_getUid("scanFloat"), function $CPScanner__scanFloat(self, _cmd)
{
    return objj_msgSend(self, "scanWithParseFunction:", parseFloat);
}
,["float"]), new objj_method(sel_getUid("scanInt"), function $CPScanner__scanInt(self, _cmd)
{
    return objj_msgSend(self, "scanWithParseFunction:", parseInt);
}
,["int"]), new objj_method(sel_getUid("scanInt:"), function $CPScanner__scanInt_(self, _cmd, intoInt)
{
    return objj_msgSend(self, "_performScanWithSelector:withObject:into:", sel_getUid("scanInt"), nil, intoInt);
}
,["BOOL","int"]), new objj_method(sel_getUid("scanFloat:"), function $CPScanner__scanFloat_(self, _cmd, intoFloat)
{
    return objj_msgSend(self, "_performScanWithSelector:withObject:into:", sel_getUid("scanFloat"), nil, intoFloat);
}
,["BOOL","float"]), new objj_method(sel_getUid("scanDouble:"), function $CPScanner__scanDouble_(self, _cmd, intoDouble)
{
    return objj_msgSend(self, "scanFloat:", intoDouble);
}
,["BOOL","float"]), new objj_method(sel_getUid("description"), function $CPScanner__description(self, _cmd)
{
    return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPScanner").super_class }, "description") + " {" + CPStringFromClass(objj_msgSend(self, "class")) + ", state = '" + (objj_msgSend(self, "string").substr(0, self._scanLocation) + "{{ SCAN LOCATION ->}}" + objj_msgSend(self, "string").substr(self._scanLocation)) + "'; }";
}
,["void"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("scannerWithString:"), function $CPScanner__scannerWithString_(self, _cmd, aString)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithString:", aString);
}
,["id","CPString"])]);
}p;11;CPSet+KVO.jt;15687;@STATIC;1.0;i;13;CPException.ji;10;CPObject.ji;14;CPMutableSet.ji;8;CPNull.ji;27;_CPCollectionKVCOperators.jt;15571;objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPMutableSet.j", YES);
objj_executeFile("CPNull.j", YES);
objj_executeFile("_CPCollectionKVCOperators.j", YES);
{
var the_class = objj_getClass("CPObject")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPObject\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("mutableSetValueForKey:"), function $CPObject__mutableSetValueForKey_(self, _cmd, aKey)
{
    return objj_msgSend(objj_msgSend(_CPKVCSet, "alloc"), "initWithKey:forProxyObject:", aKey, self);
}
,["id","id"]), new objj_method(sel_getUid("mutableSetValueForKeyPath:"), function $CPObject__mutableSetValueForKeyPath_(self, _cmd, aKeyPath)
{
    var dotIndex = aKeyPath.indexOf(".");
    if (dotIndex < 0)
        return objj_msgSend(self, "mutableSetValueForKey:", aKeyPath);
    var firstPart = aKeyPath.substring(0, dotIndex),
        lastPart = aKeyPath.substring(dotIndex + 1);
    return objj_msgSend(objj_msgSend(self, "valueForKeyPath:", firstPart), "mutableSetValueForKeyPath:", lastPart);
}
,["id","id"])]);
}
{var the_class = objj_allocateClassPair(CPMutableSet, "_CPKVCSet"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_proxyObject"), new objj_ivar("_key"), new objj_ivar("_accessSEL"), new objj_ivar("_access"), new objj_ivar("_setSEL"), new objj_ivar("_set"), new objj_ivar("_countSEL"), new objj_ivar("_count"), new objj_ivar("_enumeratorSEL"), new objj_ivar("_enumerator"), new objj_ivar("_memberSEL"), new objj_ivar("_member"), new objj_ivar("_addSEL"), new objj_ivar("_add"), new objj_ivar("_addManySEL"), new objj_ivar("_addMany"), new objj_ivar("_removeSEL"), new objj_ivar("_remove"), new objj_ivar("_removeManySEL"), new objj_ivar("_removeMany"), new objj_ivar("_intersectSEL"), new objj_ivar("_intersect")]);




















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithKey:forProxyObject:"), function $_CPKVCSet__initWithKey_forProxyObject_(self, _cmd, aKey, anObject)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPKVCSet").super_class }, "init");
    self._key = aKey;
    self._proxyObject = anObject;
    var capitalizedKey = self._key.charAt(0).toUpperCase() + self._key.substring(1);
    self._accessSEL = sel_getName(self._key);
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._accessSEL))
        self._access = objj_msgSend(self._proxyObject, "methodForSelector:", self._accessSEL);
    self._setSEL = sel_getName("set"+capitalizedKey+":");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._setSEL))
        self._set = objj_msgSend(self._proxyObject, "methodForSelector:", self._setSEL);
    self._countSEL = sel_getName("countOf"+capitalizedKey);
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._countSEL))
        self._count = objj_msgSend(self._proxyObject, "methodForSelector:", self._countSEL);
    self._enumeratorSEL = sel_getName("enumeratorOf"+capitalizedKey);
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._enumeratorSEL))
        self._enumerator = objj_msgSend(self._proxyObject, "methodForSelector:", self._enumeratorSEL);
    self._memberSEL = sel_getName("memberOf"+capitalizedKey+":");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._memberSEL))
        self._member = objj_msgSend(self._proxyObject, "methodForSelector:", self._memberSEL);
    self._addSEL = sel_getName("add"+capitalizedKey+"Object:");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._addSEL))
        self._add = objj_msgSend(self._proxyObject, "methodForSelector:", self._addSEL);
    self._addManySEL = sel_getName("add"+capitalizedKey+":");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._addManySEL))
        self._addMany = objj_msgSend(self._proxyObject, "methodForSelector:", self._addManySEL);
    self._removeSEL = sel_getName("remove"+capitalizedKey+"Object:");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._removeSEL))
        self._remove = objj_msgSend(self._proxyObject, "methodForSelector:", self._removeSEL);
    self._removeManySEL = sel_getName("remove"+capitalizedKey+":");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._removeManySEL))
        self._removeMany = objj_msgSend(self._proxyObject, "methodForSelector:", self._removeManySEL);
    self._intersectSEL = sel_getName("intersect"+capitalizedKey+":");
    if (objj_msgSend(self._proxyObject, "respondsToSelector:", self._intersectSEL))
        self._intersect = objj_msgSend(self._proxyObject, "methodForSelector:", self._intersectSEL);
    return self;
}
,["id","id","id"]), new objj_method(sel_getUid("_representedObject"), function $_CPKVCSet___representedObject(self, _cmd)
{
    if (self._access)
        return self._access(self._proxyObject, self._accessSEL);
    return objj_msgSend(self._proxyObject, "valueForKey:", self._key);
}
,["id"]), new objj_method(sel_getUid("_setRepresentedObject:"), function $_CPKVCSet___setRepresentedObject_(self, _cmd, anObject)
{
    if (self._set)
        return self._set(self._proxyObject, self._setSEL, anObject);
    objj_msgSend(self._proxyObject, "setValue:forKey:", anObject, self._key);
}
,["void","id"]), new objj_method(sel_getUid("count"), function $_CPKVCSet__count(self, _cmd)
{
    if (self._count)
        return self._count(self._proxyObject, self._countSEL);
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "count");
}
,["unsigned"]), new objj_method(sel_getUid("objectEnumerator"), function $_CPKVCSet__objectEnumerator(self, _cmd)
{
    if (self._enumerator)
        return self._enumerator(self._proxyObject, self._enumeratorSEL);
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "objectEnumerator");
}
,["CPEnumerator"]), new objj_method(sel_getUid("member:"), function $_CPKVCSet__member_(self, _cmd, anObject)
{
    if (self._member)
        return self._member(self._proxyObject, self._memberSEL, anObject);
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "member:", anObject);
}
,["id","id"]), new objj_method(sel_getUid("addObject:"), function $_CPKVCSet__addObject_(self, _cmd, anObject)
{
    if (self._add)
        self._add(self._proxyObject, self._addSEL, anObject);
    else if (self._addMany)
    {
        var objectSet = objj_msgSend(CPSet, "setWithObject:", anObject);
        self._addMany(self._proxyObject, self._addManySEL, objectSet);
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "addObject:", anObject);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","id"]), new objj_method(sel_getUid("addObjectsFromArray:"), function $_CPKVCSet__addObjectsFromArray_(self, _cmd, objects)
{
    if (self._addMany)
    {
        var objectSet = objj_msgSend(CPSet, "setWithArray:", objects);
        self._addMany(self._proxyObject, self._addManySEL, objectSet);
    }
    else if (self._add)
    {
        var object,
            objectEnumerator = objj_msgSend(objects, "objectEnumerator");
        while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
            self._add(self._proxyObject, self._addSEL, object);
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "addObjectsFromArray:", objects);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","CPArray"]), new objj_method(sel_getUid("unionSet:"), function $_CPKVCSet__unionSet_(self, _cmd, aSet)
{
    if (self._addMany)
        self._addMany(self._proxyObject, self._addManySEL, aSet);
    else if (self._add)
    {
        var object,
            objectEnumerator = objj_msgSend(aSet, "objectEnumerator");
        while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
            self._add(self._proxyObject, self._addSEL, object);
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "unionSet:", aSet);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","CPSet"]), new objj_method(sel_getUid("removeObject:"), function $_CPKVCSet__removeObject_(self, _cmd, anObject)
{
    if (self._remove)
        self._remove(self._proxyObject, self._removeSEL, anObject);
    else if (self._removeMany)
    {
        var objectSet = objj_msgSend(CPSet, "setWithObject:", anObject);
        self._removeMany(self._proxyObject, self._removeManySEL, objectSet);
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "removeObject:", anObject);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","id"]), new objj_method(sel_getUid("minusSet:"), function $_CPKVCSet__minusSet_(self, _cmd, aSet)
{
    if (self._removeMany)
        self._removeMany(self._proxyObject, self._removeManySEL, aSet);
    else if (self._remove)
    {
        var object,
            objectEnumerator = objj_msgSend(aSet, "objectEnumerator");
        while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
            self._remove(self._proxyObject, self._removeSEL, object);
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "minusSet:", aSet);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","CPSet"]), new objj_method(sel_getUid("removeObjectsInArray:"), function $_CPKVCSet__removeObjectsInArray_(self, _cmd, objects)
{
    if (self._removeMany)
    {
        var objectSet = objj_msgSend(CPSet, "setWithArray:", objects);
        self._removeMany(self._proxyObject, self._removeManySEL, objectSet);
    }
    else if (self._remove)
    {
        var object,
            objectEnumerator = objj_msgSend(objects, "objectEnumerator");
        while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
            self._remove(self._proxyObject, self._removeSEL, object);
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "removeObjectsInArray:", objects);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","CPArray"]), new objj_method(sel_getUid("removeAllObjects"), function $_CPKVCSet__removeAllObjects(self, _cmd)
{
    if (self._removeMany)
    {
        var allObjectsSet = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        self._removeMany(self._proxyObject, self._removeManySEL, allObjectsSet);
    }
    else if (self._remove)
    {
        var object,
            objectEnumerator = objj_msgSend(objj_msgSend(objj_msgSend(self, "_representedObject"), "copy"), "objectEnumerator");
        while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
            self._remove(self._proxyObject, self._removeSEL, object);
    }
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "removeAllObjects");
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void"]), new objj_method(sel_getUid("intersectSet:"), function $_CPKVCSet__intersectSet_(self, _cmd, aSet)
{
    if (self._intersect)
        self._intersect(self._proxyObject, self._intersectSEL, aSet);
    else
    {
        var target = objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
        objj_msgSend(target, "intersectSet:", aSet);
        objj_msgSend(self, "_setRepresentedObject:", target);
    }
}
,["void","CPSet"]), new objj_method(sel_getUid("setSet:"), function $_CPKVCSet__setSet_(self, _cmd, set)
{
    objj_msgSend(self, "_setRepresentedObject:", set);
}
,["void","CPSet"]), new objj_method(sel_getUid("allObjects"), function $_CPKVCSet__allObjects(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "allObjects");
}
,["CPArray"]), new objj_method(sel_getUid("anyObject"), function $_CPKVCSet__anyObject(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "anyObject");
}
,["id"]), new objj_method(sel_getUid("containsObject:"), function $_CPKVCSet__containsObject_(self, _cmd, anObject)
{
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "containsObject:", anObject);
}
,["BOOL","id"]), new objj_method(sel_getUid("intersectsSet:"), function $_CPKVCSet__intersectsSet_(self, _cmd, aSet)
{
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "intersectsSet:", aSet);
}
,["BOOL","CPSet"]), new objj_method(sel_getUid("isEqualToSet:"), function $_CPKVCSet__isEqualToSet_(self, _cmd, aSet)
{
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "isEqualToSet:", aSet);
}
,["BOOL","CPSet"]), new objj_method(sel_getUid("copy"), function $_CPKVCSet__copy(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "_representedObject"), "copy");
}
,["id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $_CPKVCSet__alloc(self, _cmd)
{
    var set = objj_msgSend(CPMutableSet, "set");
    set.isa = self;
    var ivars = class_copyIvarList(self),
        count = ivars.length;
    while (count--)
        set[ivar_getName(ivars[count])] = nil;
    return set;
}
,["id"])]);
}
{
var the_class = objj_getClass("CPSet")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPSet\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("valueForKeyPath:"), function $CPSet__valueForKeyPath_(self, _cmd, aKeyPath)
{
    if (!aKeyPath)
        objj_msgSend(self, "valueForUndefinedKey:", "<empty path>");
    if (aKeyPath.charAt(0) === "@")
    {
        var dotIndex = aKeyPath.indexOf("."),
            operator,
            parameter;
        if (dotIndex !== -1)
        {
            operator = aKeyPath.substring(1, dotIndex);
            parameter = aKeyPath.substring(dotIndex + 1);
        }
        else
            operator = aKeyPath.substring(1);
        return objj_msgSend(_CPCollectionKVCOperator, "performOperation:withCollection:propertyPath:", operator, self, parameter);
    }
    else
    {
        var valuesForKeySet = objj_msgSend(CPSet, "set"),
            containedObject,
            containedObjectValue,
            containedObjectEnumerator = objj_msgSend(self, "objectEnumerator");
        while ((containedObject = objj_msgSend(containedObjectEnumerator, "nextObject")) !== nil)
        {
            containedObjectValue = objj_msgSend(containedObject, "valueForKeyPath:", aKeyPath);
            if (containedObjectValue === nil || containedObjectValue === undefined)
                containedObjectValue = objj_msgSend(CPNull, "null");
            objj_msgSend(valuesForKeySet, "addObject:", containedObjectValue);
        }
        return valuesForKeySet;
    }
}
,["id","CPString"]), new objj_method(sel_getUid("setValue:forKey:"), function $CPSet__setValue_forKey_(self, _cmd, aValue, aKey)
{
    var containedObject,
        containedObjectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((containedObject = objj_msgSend(containedObjectEnumerator, "nextObject")) !== nil)
        objj_msgSend(containedObject, "setValue:forKey:", aValue, aKey);
}
,["void","id","CPString"])]);
}p;18;CPSortDescriptor.jt;4721;@STATIC;1.0;i;10;CPObject.ji;15;CPObjJRuntime.ji;10;CPString.jt;4652;objj_executeFile("CPObject.j", YES);
objj_executeFile("CPObjJRuntime.j", YES);
objj_executeFile("CPString.j", YES);
//@class CPString
{var the_class = objj_allocateClassPair(CPObject, "CPSortDescriptor"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_key"), new objj_ivar("_selector"), new objj_ivar("_ascending")]);








objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithKey:ascending:"), function $CPSortDescriptor__initWithKey_ascending_(self, _cmd, aKey, isAscending)
{
    return objj_msgSend(self, "initWithKey:ascending:selector:", aKey, isAscending, sel_getUid("compare:"));
}
,["id","CPString","BOOL"]), new objj_method(sel_getUid("initWithKey:ascending:selector:"), function $CPSortDescriptor__initWithKey_ascending_selector_(self, _cmd, aKey, isAscending, aSelector)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPSortDescriptor").super_class }, "init");
    if (self)
    {
        self._key = aKey;
        self._ascending = isAscending;
        self._selector = aSelector;
    }
    return self;
}
,["id","CPString","BOOL","SEL"]), new objj_method(sel_getUid("ascending"), function $CPSortDescriptor__ascending(self, _cmd)
{
    return self._ascending;
}
,["BOOL"]), new objj_method(sel_getUid("key"), function $CPSortDescriptor__key(self, _cmd)
{
    return self._key;
}
,["CPString"]), new objj_method(sel_getUid("selector"), function $CPSortDescriptor__selector(self, _cmd)
{
    return self._selector;
}
,["SEL"]), new objj_method(sel_getUid("compareObject:withObject:"), function $CPSortDescriptor__compareObject_withObject_(self, _cmd, lhsObject, rhsObject)
{
    return (self._ascending ? 1 : -1) * objj_msgSend(objj_msgSend(lhsObject, "valueForKeyPath:", self._key), "performSelector:withObject:", self._selector, objj_msgSend(rhsObject, "valueForKeyPath:", self._key));
}
,["CPComparisonResult","id","id"]), new objj_method(sel_getUid("reversedSortDescriptor"), function $CPSortDescriptor__reversedSortDescriptor(self, _cmd)
{
    return objj_msgSend(objj_msgSend(objj_msgSend(self, "class"), "alloc"), "initWithKey:ascending:selector:", self._key, !self._ascending, self._selector);
}
,["id"]), new objj_method(sel_getUid("description"), function $CPSortDescriptor__description(self, _cmd)
{
    return objj_msgSend(CPString, "stringWithFormat:", "(%@, %@, %@)", objj_msgSend(self, "key"), objj_msgSend(self, "ascending") ? "ascending": "descending", CPStringFromSelector(objj_msgSend(self, "selector")));
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("sortDescriptorWithKey:ascending:"), function $CPSortDescriptor__sortDescriptorWithKey_ascending_(self, _cmd, aKey, isAscending)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithKey:ascending:", aKey, isAscending);
}
,["id","CPString","BOOL"]), new objj_method(sel_getUid("sortDescriptorWithKey:ascending:selector:"), function $CPSortDescriptor__sortDescriptorWithKey_ascending_selector_(self, _cmd, aKey, isAscending, aSelector)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithKey:ascending:selector:", aKey, isAscending, aSelector);
}
,["id","CPString","BOOL","SEL"])]);
}
var CPSortDescriptorKeyKey = "CPSortDescriptorKeyKey",
    CPSortDescriptorAscendingKey = "CPSortDescriptorAscendingKey",
    CPSortDescriptorSelectorKey = "CPSortDescriptorSelectorKey";
{
var the_class = objj_getClass("CPSortDescriptor")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPSortDescriptor\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPSortDescriptor__initWithCoder_(self, _cmd, aCoder)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPSortDescriptor").super_class }, "init"))
    {
        self._key = objj_msgSend(aCoder, "decodeObjectForKey:", CPSortDescriptorKeyKey);
        self._ascending = objj_msgSend(aCoder, "decodeBoolForKey:", CPSortDescriptorAscendingKey);
        self._selector = CPSelectorFromString(objj_msgSend(aCoder, "decodeObjectForKey:", CPSortDescriptorSelectorKey));
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPSortDescriptor__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeObject:forKey:", self._key, CPSortDescriptorKeyKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._ascending, CPSortDescriptorAscendingKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", CPStringFromSelector(self._selector), CPSortDescriptorSelectorKey);
}
,["void","CPCoder"])]);
}p;10;CPString.jt;20345;@STATIC;1.0;i;13;CPException.ji;10;CPObject.ji;15;CPObjJRuntime.ji;9;CPRange.ji;18;CPSortDescriptor.ji;7;CPURL.ji;9;CPValue.jt;20212;objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPObjJRuntime.j", YES);
objj_executeFile("CPRange.j", YES);
objj_executeFile("CPSortDescriptor.j", YES);
objj_executeFile("CPURL.j", YES);
objj_executeFile("CPValue.j", YES);
//@class CPException
//@class CPURL
//@global CPInvalidArgumentException
//@global CPRangeException
CPCaseInsensitiveSearch = 1;
CPLiteralSearch = 2;
CPBackwardsSearch = 4;
CPAnchoredSearch = 8;
CPNumericSearch = 64;
CPDiacriticInsensitiveSearch = 128;
var CPStringUIDs = new CFMutableDictionary(),
    CPStringRegexSpecialCharacters = [
      '/', '.', '*', '+', '?', '|', '$', '^',
      '(', ')', '[', ']', '{', '}', '\\'
    ],
    CPStringRegexEscapeExpression = new RegExp("(\\" + CPStringRegexSpecialCharacters.join("|\\") + ")", 'g'),
    CPStringRegexTrimWhitespace = new RegExp("(^\\s+|\\s+$)", 'g');
{var the_class = objj_allocateClassPair(CPObject, "CPString"),
meta_class = the_class.isa;


















































objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithString:"), function $CPString__initWithString_(self, _cmd, aString)
{
    if (objj_msgSend(self, "class") === CPString)
        return String(aString);
    var result = new String(aString);
    result.isa = objj_msgSend(self, "class");
    return result;
}
,["id","CPString"]), new objj_method(sel_getUid("initWithFormat:"), function $CPString__initWithFormat_(self, _cmd, format)
{
    if (!format)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "initWithFormat: the format can't be 'nil'");
    self = ObjectiveJ.sprintf.apply(this, Array.prototype.slice.call(arguments, 2));
    return self;
}
,["id","CPString"]), new objj_method(sel_getUid("description"), function $CPString__description(self, _cmd)
{
    return self;
}
,["CPString"]), new objj_method(sel_getUid("length"), function $CPString__length(self, _cmd)
{
    return self.length;
}
,["int"]), new objj_method(sel_getUid("characterAtIndex:"), function $CPString__characterAtIndex_(self, _cmd, anIndex)
{
    return self.charAt(anIndex);
}
,["CPString","unsigned"]), new objj_method(sel_getUid("stringByAppendingFormat:"), function $CPString__stringByAppendingFormat_(self, _cmd, format)
{
    if (!format)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "initWithFormat: the format can't be 'nil'");
    return self + ObjectiveJ.sprintf.apply(this, Array.prototype.slice.call(arguments, 2));
}
,["CPString","CPString"]), new objj_method(sel_getUid("stringByAppendingString:"), function $CPString__stringByAppendingString_(self, _cmd, aString)
{
    return self + aString;
}
,["CPString","CPString"]), new objj_method(sel_getUid("stringByPaddingToLength:withString:startingAtIndex:"), function $CPString__stringByPaddingToLength_withString_startingAtIndex_(self, _cmd, aLength, aString, anIndex)
{
    if (self.length == aLength)
        return self;
    if (aLength < self.length)
        return self.substr(0, aLength);
    var string = self,
        substring = aString.substring(anIndex),
        difference = aLength - self.length;
    while ((difference -= substring.length) >= 0)
        string += substring;
    if (-difference < substring.length)
        string += substring.substring(0, -difference);
    return string;
}
,["CPString","unsigned","CPString","unsigned"]), new objj_method(sel_getUid("componentsSeparatedByString:"), function $CPString__componentsSeparatedByString_(self, _cmd, aString)
{
    return self.split(aString);
}
,["CPArray","CPString"]), new objj_method(sel_getUid("substringFromIndex:"), function $CPString__substringFromIndex_(self, _cmd, anIndex)
{
    return self.substr(anIndex);
}
,["CPString","unsigned"]), new objj_method(sel_getUid("substringWithRange:"), function $CPString__substringWithRange_(self, _cmd, aRange)
{
    if (aRange.location < 0 || ((aRange).location + (aRange).length) > self.length)
        objj_msgSend(CPException, "raise:reason:", CPRangeException, "aRange out of bounds");
    return self.substr(aRange.location, aRange.length);
}
,["CPString","CPRange"]), new objj_method(sel_getUid("substringToIndex:"), function $CPString__substringToIndex_(self, _cmd, anIndex)
{
    if (anIndex > self.length)
        objj_msgSend(CPException, "raise:reason:", CPRangeException, "index out of bounds");
    return self.substring(0, anIndex);
}
,["CPString","unsigned"]), new objj_method(sel_getUid("rangeOfString:"), function $CPString__rangeOfString_(self, _cmd, aString)
{
   return objj_msgSend(self, "rangeOfString:options:", aString, 0);
}
,["CPRange","CPString"]), new objj_method(sel_getUid("rangeOfString:options:"), function $CPString__rangeOfString_options_(self, _cmd, aString, aMask)
{
    return objj_msgSend(self, "rangeOfString:options:range:", aString, aMask, nil);
}
,["CPRange","CPString","int"]), new objj_method(sel_getUid("rangeOfString:options:range:"), function $CPString__rangeOfString_options_range_(self, _cmd, aString, aMask, aRange)
{
    if (!aString)
        return CPMakeRange(CPNotFound, 0);
    var string = (aRange == nil) ? self : objj_msgSend(self, "substringWithRange:", aRange),
        location = CPNotFound;
    if (aMask & CPCaseInsensitiveSearch)
    {
        string = string.toLowerCase();
        aString = aString.toLowerCase();
    }
    if (aMask & CPBackwardsSearch)
    {
        location = string.lastIndexOf(aString);
        if (aMask & CPAnchoredSearch && location + aString.length != string.length)
            location = CPNotFound;
    }
    else if (aMask & CPAnchoredSearch)
        location = string.substr(0, aString.length).indexOf(aString) != CPNotFound ? 0 : CPNotFound;
    else
        location = string.indexOf(aString);
    if (location == CPNotFound)
        return CPMakeRange(CPNotFound, 0);
    return CPMakeRange(location + (aRange ? aRange.location : 0), aString.length);
}
,["CPRange","CPString","int","CPrange"]), new objj_method(sel_getUid("stringByEscapingRegexControlCharacters"), function $CPString__stringByEscapingRegexControlCharacters(self, _cmd)
{
    return self.replace(CPStringRegexEscapeExpression, "\\$1");
}
,["CPString"]), new objj_method(sel_getUid("stringByReplacingOccurrencesOfString:withString:"), function $CPString__stringByReplacingOccurrencesOfString_withString_(self, _cmd, target, replacement)
{
    return self.replace(new RegExp(objj_msgSend(target, "stringByEscapingRegexControlCharacters"), "g"), replacement);
}
,["CPString","CPString","CPString"]), new objj_method(sel_getUid("stringByReplacingOccurrencesOfString:withString:options:range:"), function $CPString__stringByReplacingOccurrencesOfString_withString_options_range_(self, _cmd, target, replacement, options, searchRange)
{
    var start = self.substring(0, searchRange.location),
        stringSegmentToSearch = self.substr(searchRange.location, searchRange.length),
        end = self.substring(searchRange.location + searchRange.length, self.length),
        target = objj_msgSend(target, "stringByEscapingRegexControlCharacters"),
        regExp;
    if (options & CPCaseInsensitiveSearch)
        regExp = new RegExp(target, "gi");
    else
        regExp = new RegExp(target, "g");
    return start + '' + stringSegmentToSearch.replace(regExp, replacement) + '' + end;
}
,["CPString","CPString","CPString","int","CPRange"]), new objj_method(sel_getUid("stringByReplacingCharactersInRange:withString:"), function $CPString__stringByReplacingCharactersInRange_withString_(self, _cmd, range, replacement)
{
    return '' + self.substring(0, range.location) + replacement + self.substring(range.location + range.length, self.length);
}
,["CPString","CPRange","CPString"]), new objj_method(sel_getUid("stringByTrimmingWhitespace"), function $CPString__stringByTrimmingWhitespace(self, _cmd)
{
    return self.replace(CPStringRegexTrimWhitespace, "");
}
,["CPString"]), new objj_method(sel_getUid("compare:"), function $CPString__compare_(self, _cmd, aString)
{
    return objj_msgSend(self, "compare:options:", aString, nil);
}
,["CPComparisonResult","CPString"]), new objj_method(sel_getUid("caseInsensitiveCompare:"), function $CPString__caseInsensitiveCompare_(self, _cmd, aString)
{
    return objj_msgSend(self, "compare:options:", aString, CPCaseInsensitiveSearch);
}
,["CPComparisonResult","CPString"]), new objj_method(sel_getUid("compare:options:"), function $CPString__compare_options_(self, _cmd, aString, aMask)
{
    var lhs = self,
        rhs = aString;
    if (aMask & CPCaseInsensitiveSearch)
    {
        lhs = lhs.toLowerCase();
        rhs = rhs.toLowerCase();
    }
    if (aMask & CPDiacriticInsensitiveSearch)
    {
        lhs = lhs.stripDiacritics();
        rhs = rhs.stripDiacritics();
    }
    if (lhs < rhs)
        return CPOrderedAscending;
    if (lhs > rhs)
        return CPOrderedDescending;
    return CPOrderedSame;
}
,["CPComparisonResult","CPString","int"]), new objj_method(sel_getUid("compare:options:range:"), function $CPString__compare_options_range_(self, _cmd, aString, aMask, range)
{
    var lhs = objj_msgSend(self, "substringWithRange:", range),
        rhs = aString;
    return objj_msgSend(lhs, "compare:options:", rhs, aMask);
}
,["CPComparisonResult","CPString","int","CPRange"]), new objj_method(sel_getUid("hasPrefix:"), function $CPString__hasPrefix_(self, _cmd, aString)
{
    return aString && aString != "" && self.indexOf(aString) == 0;
}
,["BOOL","CPString"]), new objj_method(sel_getUid("hasSuffix:"), function $CPString__hasSuffix_(self, _cmd, aString)
{
    return aString && aString != "" && self.length >= aString.length && self.lastIndexOf(aString) == (self.length - aString.length);
}
,["BOOL","CPString"]), new objj_method(sel_getUid("isEqual:"), function $CPString__isEqual_(self, _cmd, anObject)
{
    if (self === anObject)
        return YES;
    if (!anObject || !objj_msgSend(anObject, "isKindOfClass:", objj_msgSend(CPString, "class")))
        return NO;
    return objj_msgSend(self, "isEqualToString:", anObject);
}
,["BOOL","id"]), new objj_method(sel_getUid("isEqualToString:"), function $CPString__isEqualToString_(self, _cmd, aString)
{
    return self == String(aString);
}
,["BOOL","CPString"]), new objj_method(sel_getUid("UID"), function $CPString__UID(self, _cmd)
{
    var UID = CPStringUIDs.valueForKey(self);
    if (!UID)
    {
        UID = objj_generateObjectUID();
        CPStringUIDs.setValueForKey(self, UID);
    }
    return UID + "";
}
,["unsigned"]), new objj_method(sel_getUid("commonPrefixWithString:"), function $CPString__commonPrefixWithString_(self, _cmd, aString)
{
    return objj_msgSend(self, "commonPrefixWithString:options:", aString, 0);
}
,["CPString","CPString"]), new objj_method(sel_getUid("commonPrefixWithString:options:"), function $CPString__commonPrefixWithString_options_(self, _cmd, aString, aMask)
{
    var len = 0,
        lhs = self,
        rhs = aString,
        min = MIN(objj_msgSend(lhs, "length"), objj_msgSend(rhs, "length"));
    if (aMask & CPCaseInsensitiveSearch)
    {
        lhs = objj_msgSend(lhs, "lowercaseString");
        rhs = objj_msgSend(rhs, "lowercaseString");
    }
    for (; len < min; len++)
    {
        if (objj_msgSend(lhs, "characterAtIndex:", len) !== objj_msgSend(rhs, "characterAtIndex:", len))
            break;
    }
    return objj_msgSend(self, "substringToIndex:", len);
}
,["CPString","CPString","int"]), new objj_method(sel_getUid("capitalizedString"), function $CPString__capitalizedString(self, _cmd)
{
    var parts = self.split(/\b/g),
        i = 0,
        count = parts.length;
    for (; i < count; i++)
    {
        if (i == 0 || (/\s$/).test(parts[i - 1]))
            parts[i] = parts[i].substring(0, 1).toUpperCase() + parts[i].substring(1).toLowerCase();
        else
            parts[i] = parts[i].toLowerCase();
    }
    return parts.join("");
}
,["CPString"]), new objj_method(sel_getUid("lowercaseString"), function $CPString__lowercaseString(self, _cmd)
{
    return self.toLowerCase();
}
,["CPString"]), new objj_method(sel_getUid("uppercaseString"), function $CPString__uppercaseString(self, _cmd)
{
    return self.toUpperCase();
}
,["CPString"]), new objj_method(sel_getUid("doubleValue"), function $CPString__doubleValue(self, _cmd)
{
    return parseFloat(self, 10);
}
,["double"]), new objj_method(sel_getUid("boolValue"), function $CPString__boolValue(self, _cmd)
{
    var replaceRegExp = new RegExp("^\\s*[\\+,\\-]?0*");
    return RegExp("^[Y,y,t,T,1-9]").test(self.replace(replaceRegExp, ''));
}
,["BOOL"]), new objj_method(sel_getUid("floatValue"), function $CPString__floatValue(self, _cmd)
{
    return parseFloat(self, 10);
}
,["float"]), new objj_method(sel_getUid("intValue"), function $CPString__intValue(self, _cmd)
{
    return parseInt(self, 10);
}
,["int"]), new objj_method(sel_getUid("pathComponents"), function $CPString__pathComponents(self, _cmd)
{
    if (self.length === 0)
        return [""];
    if (self === "/")
        return ["/"];
    var result = self.split('/');
    if (result[0] === "")
        result[0] = "/";
    var index = result.length - 1;
    if (index > 0)
    {
        if (result[index] === "")
            result[index] = "/";
        while (index--)
        {
            while (result[index] === "")
                result.splice(index--, 1);
        }
    }
    return result;
}
,["CPArray"]), new objj_method(sel_getUid("pathExtension"), function $CPString__pathExtension(self, _cmd)
{
    if (self.lastIndexOf('.') === CPNotFound)
        return "";
    return self.substr(self.lastIndexOf('.') + 1);
}
,["CPString"]), new objj_method(sel_getUid("lastPathComponent"), function $CPString__lastPathComponent(self, _cmd)
{
    var components = objj_msgSend(self, "pathComponents"),
        lastIndex = components.length - 1,
        lastComponent = components[lastIndex];
    return lastIndex > 0 && lastComponent === "/" ? components[lastIndex - 1] : lastComponent;
}
,["CPString"]), new objj_method(sel_getUid("stringByAppendingPathComponent:"), function $CPString__stringByAppendingPathComponent_(self, _cmd, aString)
{
    var components = objj_msgSend(self, "pathComponents"),
        addComponents = aString && aString !== "/" ? objj_msgSend(aString, "pathComponents") : [];
    return objj_msgSend(CPString, "pathWithComponents:", components.concat(addComponents));
}
,["CPString","CPString"]), new objj_method(sel_getUid("stringByAppendingPathExtension:"), function $CPString__stringByAppendingPathExtension_(self, _cmd, ext)
{
    if (ext.indexOf('/') >= 0 || self.length === 0 || self === "/")
        return self;
    var components = objj_msgSend(self, "pathComponents"),
        last = components.length - 1;
    if (last > 0 && components[last] === "/")
        components.splice(last--, 1);
    components[last] = components[last] + "." + ext;
    return objj_msgSend(CPString, "pathWithComponents:", components);
}
,["CPString","CPString"]), new objj_method(sel_getUid("stringByDeletingLastPathComponent"), function $CPString__stringByDeletingLastPathComponent(self, _cmd)
{
    if (self.length === 0)
        return "";
    else if (self === "/")
        return "/";
    var components = objj_msgSend(self, "pathComponents"),
        last = components.length - 1;
    if (components[last] === "/")
        last--;
    components.splice(last, components.length - last);
    return objj_msgSend(CPString, "pathWithComponents:", components);
}
,["CPString"]), new objj_method(sel_getUid("stringByDeletingPathExtension"), function $CPString__stringByDeletingPathExtension(self, _cmd)
{
    var extension = objj_msgSend(self, "pathExtension");
    if (extension === "")
        return self;
    else if (self.lastIndexOf('.') < 1)
        return self;
    return self.substr(0, objj_msgSend(self, "length") - (extension.length + 1));
}
,["CPString"]), new objj_method(sel_getUid("stringByStandardizingPath"), function $CPString__stringByStandardizingPath(self, _cmd)
{
    return objj_msgSend(objj_msgSend(CPURL, "URLWithString:", self), "absoluteString");
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $CPString__alloc(self, _cmd)
{
    if (objj_msgSend(self, "class") !== CPString)
       return objj_msgSendSuper({ receiver:self, super_class:objj_getMetaClass("CPString").super_class }, "alloc");
    return new String;
}
,["id"]), new objj_method(sel_getUid("string"), function $CPString__string(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "init");
}
,["id"]), new objj_method(sel_getUid("stringWithHash:"), function $CPString__stringWithHash_(self, _cmd, aHash)
{
    var hashString = parseInt(aHash, 10).toString(16);
    return "000000".substring(0, MAX(6 - hashString.length, 0)) + hashString;
}
,["id","unsigned"]), new objj_method(sel_getUid("stringWithString:"), function $CPString__stringWithString_(self, _cmd, aString)
{
    if (!aString)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "stringWithString: the string can't be 'nil'");
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithString:", aString);
}
,["id","CPString"]), new objj_method(sel_getUid("stringWithFormat:"), function $CPString__stringWithFormat_(self, _cmd, format)
{
    if (!format)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "initWithFormat: the format can't be 'nil'");
    return ObjectiveJ.sprintf.apply(this, Array.prototype.slice.call(arguments, 2));
}
,["id","CPString"]), new objj_method(sel_getUid("pathWithComponents:"), function $CPString__pathWithComponents_(self, _cmd, components)
{
    var size = components.length,
        result = "",
        i = -1,
        firstRound = true,
        firstIsSlash = false;
    while (++i < size)
    {
        var component = components[i],
            lenMinusOne = component.length - 1;
        if (lenMinusOne >= 0 && (component !== "/" || firstRound))
        {
            if (lenMinusOne > 0 && component.indexOf("/",lenMinusOne) === lenMinusOne)
                component = component.substring(0, lenMinusOne);
            if (firstRound)
            {
                if (component === "/")
                    firstIsSlash = true;
                firstRound = false;
            }
            else if (!firstIsSlash)
                result += "/";
            else
                firstIsSlash = false;
            result += component;
        }
    }
    return result;
}
,["CPString","CPArray"])]);
}
{
var the_class = objj_getClass("CPString")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPString\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("objectFromJSON"), function $CPString__objectFromJSON(self, _cmd)
{
    return JSON.parse(self);
}
,["JSObject"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("JSONFromObject:"), function $CPString__JSONFromObject_(self, _cmd, anObject)
{
    return JSON.stringify(anObject);
}
,["CPString","JSObject"])]);
}
{
var the_class = objj_getClass("CPString")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPString\"");
var meta_class = the_class.isa;class_addMethods(meta_class, [new objj_method(sel_getUid("UUID"), function $CPString__UUID(self, _cmd)
{
    var g = "",
        i = 0;
    for (; i < 32; i++)
        g += FLOOR(RAND() * 0xF).toString(0xF);
    return g;
}
,["CPString"])]);
}
var diacritics = [[192,198],[224,230],[231,231],[232,235],[236,239],[242,246],[249,252]],
    normalized = [65,97,99,101,105,111,117];
String.prototype.stripDiacritics = function()
{
    var output = "";
    for (var indexSource = 0; indexSource < this.length; indexSource++)
    {
        var code = this.charCodeAt(indexSource);
        for (var i = 0; i < diacritics.length; i++)
        {
            var drange = diacritics[i];
            if (code >= drange[0] && code <= drange[drange.length - 1])
            {
                code = normalized[i];
                break;
            }
        }
        output += String.fromCharCode(code);
    }
    return output;
};
String.prototype.isa = CPString;p;9;CPTimer.jt;8813;@STATIC;1.0;i;8;CPDate.ji;14;CPInvocation.ji;10;CPObject.ji;11;CPRunLoop.jt;8732;objj_executeFile("CPDate.j", YES);
objj_executeFile("CPInvocation.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPRunLoop.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPTimer"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_timeInterval"), new objj_ivar("_invocation"), new objj_ivar("_callback"), new objj_ivar("_repeats"), new objj_ivar("_isValid"), new objj_ivar("_fireDate"), new objj_ivar("_userInfo")]);














objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFireDate:interval:invocation:repeats:"), function $CPTimer__initWithFireDate_interval_invocation_repeats_(self, _cmd, aDate, seconds, anInvocation, shouldRepeat)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPTimer").super_class }, "init");
    if (self)
    {
        self._timeInterval = seconds;
        self._invocation = anInvocation;
        self._repeats = shouldRepeat;
        self._isValid = YES;
        self._fireDate = aDate;
    }
    return self;
}
,["id","CPDate","CPTimeInterval","CPInvocation","BOOL"]), new objj_method(sel_getUid("initWithFireDate:interval:target:selector:userInfo:repeats:"), function $CPTimer__initWithFireDate_interval_target_selector_userInfo_repeats_(self, _cmd, aDate, seconds, aTarget, aSelector, userInfo, shouldRepeat)
{
    var invocation = objj_msgSend(CPInvocation, "invocationWithMethodSignature:", 1);
    objj_msgSend(invocation, "setTarget:", aTarget);
    objj_msgSend(invocation, "setSelector:", aSelector);
    objj_msgSend(invocation, "setArgument:atIndex:", self, 2);
    self = objj_msgSend(self, "initWithFireDate:interval:invocation:repeats:", aDate, seconds, invocation, shouldRepeat);
    if (self)
        self._userInfo = userInfo;
    return self;
}
,["id","CPDate","CPTimeInterval","id","SEL","id","BOOL"]), new objj_method(sel_getUid("initWithFireDate:interval:callback:repeats:"), function $CPTimer__initWithFireDate_interval_callback_repeats_(self, _cmd, aDate, seconds, aFunction, shouldRepeat)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPTimer").super_class }, "init");
    if (self)
    {
        self._timeInterval = seconds;
        self._callback = aFunction;
        self._repeats = shouldRepeat;
        self._isValid = YES;
        self._fireDate = aDate;
    }
    return self;
}
,["id","CPDate","CPTimeInterval","Function","BOOL"]), new objj_method(sel_getUid("timeInterval"), function $CPTimer__timeInterval(self, _cmd)
{
   return self._timeInterval;
}
,["CPTimeInterval"]), new objj_method(sel_getUid("fireDate"), function $CPTimer__fireDate(self, _cmd)
{
   return self._fireDate;
}
,["CPDate"]), new objj_method(sel_getUid("setFireDate:"), function $CPTimer__setFireDate_(self, _cmd, aDate)
{
    self._fireDate = aDate;
}
,["void","CPDate"]), new objj_method(sel_getUid("fire"), function $CPTimer__fire(self, _cmd)
{
    if (!self._isValid)
        return;
    if (self._callback)
        self._callback();
    else
        objj_msgSend(self._invocation, "invoke");
    if (!self._isValid)
        return;
    if (self._repeats)
        self._fireDate = objj_msgSend(CPDate, "dateWithTimeIntervalSinceNow:", self._timeInterval);
    else
        objj_msgSend(self, "invalidate");
}
,["void"]), new objj_method(sel_getUid("isValid"), function $CPTimer__isValid(self, _cmd)
{
   return self._isValid;
}
,["BOOL"]), new objj_method(sel_getUid("invalidate"), function $CPTimer__invalidate(self, _cmd)
{
   self._isValid = NO;
   self._userInfo = nil;
   self._invocation = nil;
   self._callback = nil;
}
,["void"]), new objj_method(sel_getUid("userInfo"), function $CPTimer__userInfo(self, _cmd)
{
   return self._userInfo;
}
,["id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("scheduledTimerWithTimeInterval:invocation:repeats:"), function $CPTimer__scheduledTimerWithTimeInterval_invocation_repeats_(self, _cmd, seconds, anInvocation, shouldRepeat)
{
    var timer = objj_msgSend(objj_msgSend(self, "alloc"), "initWithFireDate:interval:invocation:repeats:", objj_msgSend(CPDate, "dateWithTimeIntervalSinceNow:", seconds), seconds, anInvocation, shouldRepeat);
    objj_msgSend(objj_msgSend(CPRunLoop, "currentRunLoop"), "addTimer:forMode:", timer, CPDefaultRunLoopMode);
    return timer;
}
,["CPTimer","CPTimeInterval","CPInvocation","BOOL"]), new objj_method(sel_getUid("scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:"), function $CPTimer__scheduledTimerWithTimeInterval_target_selector_userInfo_repeats_(self, _cmd, seconds, aTarget, aSelector, userInfo, shouldRepeat)
{
    var timer = objj_msgSend(objj_msgSend(self, "alloc"), "initWithFireDate:interval:target:selector:userInfo:repeats:", objj_msgSend(CPDate, "dateWithTimeIntervalSinceNow:", seconds), seconds, aTarget, aSelector, userInfo, shouldRepeat);
    objj_msgSend(objj_msgSend(CPRunLoop, "currentRunLoop"), "addTimer:forMode:", timer, CPDefaultRunLoopMode);
    return timer;
}
,["CPTimer","CPTimeInterval","id","SEL","id","BOOL"]), new objj_method(sel_getUid("scheduledTimerWithTimeInterval:callback:repeats:"), function $CPTimer__scheduledTimerWithTimeInterval_callback_repeats_(self, _cmd, seconds, aFunction, shouldRepeat)
{
    var timer = objj_msgSend(objj_msgSend(self, "alloc"), "initWithFireDate:interval:callback:repeats:", objj_msgSend(CPDate, "dateWithTimeIntervalSinceNow:", seconds), seconds, aFunction, shouldRepeat);
    objj_msgSend(objj_msgSend(CPRunLoop, "currentRunLoop"), "addTimer:forMode:", timer, CPDefaultRunLoopMode);
    return timer;
}
,["CPTimer","CPTimeInterval","Function","BOOL"]), new objj_method(sel_getUid("timerWithTimeInterval:invocation:repeats:"), function $CPTimer__timerWithTimeInterval_invocation_repeats_(self, _cmd, seconds, anInvocation, shouldRepeat)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithFireDate:interval:invocation:repeats:", objj_msgSend(CPDate, "dateWithTimeIntervalSinceNow:", seconds), seconds, anInvocation, shouldRepeat);
}
,["CPTimer","CPTimeInterval","CPInvocation","BOOL"]), new objj_method(sel_getUid("timerWithTimeInterval:target:selector:userInfo:repeats:"), function $CPTimer__timerWithTimeInterval_target_selector_userInfo_repeats_(self, _cmd, seconds, aTarget, aSelector, userInfo, shouldRepeat)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithFireDate:interval:target:selector:userInfo:repeats:", objj_msgSend(CPDate, "dateWithTimeIntervalSinceNow:", seconds), seconds, aTarget, aSelector, userInfo, shouldRepeat);
}
,["CPTimer","CPTimeInterval","id","SEL","id","BOOL"]), new objj_method(sel_getUid("timerWithTimeInterval:callback:repeats:"), function $CPTimer__timerWithTimeInterval_callback_repeats_(self, _cmd, seconds, aFunction, shouldRepeat)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithFireDate:interval:callback:repeats:", objj_msgSend(CPDate, "dateWithTimeIntervalSinceNow:", seconds), seconds, aFunction, shouldRepeat);
}
,["CPTimer","CPTimeInterval","Function","BOOL"])]);
}
var CPTimersTimeoutID = 1000,
    CPTimersForTimeoutIDs = {};
var _CPTimerBridgeTimer = function(codeOrFunction, aDelay, shouldRepeat, functionArgs)
{
    var timeoutID = CPTimersTimeoutID++,
        theFunction = nil;
    if (typeof codeOrFunction === "string")
    {
        theFunction = function()
        {
            new Function(codeOrFunction)();
            if (!shouldRepeat)
                CPTimersForTimeoutIDs[timeoutID] = nil;
        }
    }
    else
    {
        if (!functionArgs)
            functionArgs = [];
        theFunction = function()
        {
            codeOrFunction.apply(window, functionArgs);
            if (!shouldRepeat)
                CPTimersForTimeoutIDs[timeoutID] = nil;
        }
    }
    aDelay = aDelay | 0.0;
    CPTimersForTimeoutIDs[timeoutID] = objj_msgSend(CPTimer, "scheduledTimerWithTimeInterval:callback:repeats:", aDelay / 1000, theFunction, shouldRepeat);
    return timeoutID;
};
if (typeof(window) !== 'undefined')
{
    window.setTimeout = function(codeOrFunction, aDelay)
    {
        return _CPTimerBridgeTimer(codeOrFunction, aDelay, NO, Array.prototype.slice.apply(arguments, [2]));
    };
    window.clearTimeout = function(aTimeoutID)
    {
        var timer = CPTimersForTimeoutIDs[aTimeoutID];
        if (timer)
            objj_msgSend(timer, "invalidate");
        CPTimersForTimeoutIDs[aTimeoutID] = nil;
    };
    window.setInterval = function(codeOrFunction, aDelay, functionArgs)
    {
        return _CPTimerBridgeTimer(codeOrFunction, aDelay, YES, Array.prototype.slice.apply(arguments, [2]));
    };
    window.clearInterval = function(aTimeoutID)
    {
        window.clearTimeout(aTimeoutID);
    };
}p;15;CPUndoManager.jt;25314;@STATIC;1.0;i;9;CPArray.ji;13;CPException.ji;14;CPInvocation.ji;22;CPNotificationCenter.ji;10;CPObject.ji;9;CPProxy.ji;21;CPKeyValueObserving.ji;11;CPRunLoop.jt;25147;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPInvocation.j", YES);
objj_executeFile("CPNotificationCenter.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPProxy.j", YES);
objj_executeFile("CPKeyValueObserving.j", YES);
objj_executeFile("CPRunLoop.j", YES);
var CPUndoManagerNormal = 0,
    CPUndoManagerUndoing = 1,
    CPUndoManagerRedoing = 2;
CPUndoManagerCheckpointNotification = "CPUndoManagerCheckpointNotification";
CPUndoManagerDidOpenUndoGroupNotification = "CPUndoManagerDidOpenUndoGroupNotification";
CPUndoManagerDidCloseUndoGroupNotification = "CPUndoManagerDidCloseUndoGroupNotification";
CPUndoManagerDidRedoChangeNotification = "CPUndoManagerDidRedoChangeNotification";
CPUndoManagerDidUndoChangeNotification = "CPUndoManagerDidUndoChangeNotification";
CPUndoManagerWillCloseUndoGroupNotification = "CPUndoManagerWillCloseUndoGroupNotification";
CPUndoManagerWillRedoChangeNotification = "CPUndoManagerWillRedoChangeNotification";
CPUndoManagerWillUndoChangeNotification = "CPUndoManagerWillUndoChangeNotification";
CPUndoCloseGroupingRunLoopOrdering = 350000;
var _CPUndoGroupingPool = [],
    _CPUndoGroupingPoolCapacity = 5;
{var the_class = objj_allocateClassPair(CPObject, "_CPUndoGrouping"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_parent"), new objj_ivar("_invocations"), new objj_ivar("_actionName")]);









objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithParent:"), function $_CPUndoGrouping__initWithParent_(self, _cmd, anUndoGrouping)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPUndoGrouping").super_class }, "init");
    if (self)
    {
        self._parent = anUndoGrouping;
        self._invocations = [];
        self._actionName = "";
    }
    return self;
}
,["id","_CPUndoGrouping"]), new objj_method(sel_getUid("parent"), function $_CPUndoGrouping__parent(self, _cmd)
{
    return self._parent;
}
,["_CPUndoGrouping"]), new objj_method(sel_getUid("addInvocation:"), function $_CPUndoGrouping__addInvocation_(self, _cmd, anInvocation)
{
    self._invocations.push(anInvocation);
}
,["void","CPInvocation"]), new objj_method(sel_getUid("addInvocationsFromArray:"), function $_CPUndoGrouping__addInvocationsFromArray_(self, _cmd, invocations)
{
    objj_msgSend(self._invocations, "addObjectsFromArray:", invocations);
}
,["void","CPArray"]), new objj_method(sel_getUid("removeInvocationsWithTarget:"), function $_CPUndoGrouping__removeInvocationsWithTarget_(self, _cmd, aTarget)
{
    var index = self._invocations.length;
    while (index--)
        if (objj_msgSend(self._invocations[index], "target") == aTarget)
            self._invocations.splice(index, 1);
}
,["BOOL","id"]), new objj_method(sel_getUid("invocations"), function $_CPUndoGrouping__invocations(self, _cmd)
{
    return self._invocations;
}
,["CPArray"]), new objj_method(sel_getUid("invoke"), function $_CPUndoGrouping__invoke(self, _cmd)
{
    var index = self._invocations.length;
    while (index--)
        objj_msgSend(self._invocations[index], "invoke");
}
,["void"]), new objj_method(sel_getUid("setActionName:"), function $_CPUndoGrouping__setActionName_(self, _cmd, aName)
{
    self._actionName = aName;
}
,["void","CPString"]), new objj_method(sel_getUid("actionName"), function $_CPUndoGrouping__actionName(self, _cmd)
{
    return self._actionName;
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("_poolUndoGrouping:"), function $_CPUndoGrouping___poolUndoGrouping_(self, _cmd, anUndoGrouping)
{
    if (!anUndoGrouping || _CPUndoGroupingPool.length >= _CPUndoGroupingPoolCapacity)
        return;
    _CPUndoGroupingPool.push(anUndoGrouping);
}
,["void","_CPUndoGrouping"]), new objj_method(sel_getUid("undoGroupingWithParent:"), function $_CPUndoGrouping__undoGroupingWithParent_(self, _cmd, anUndoGrouping)
{
    if (_CPUndoGroupingPool.length)
    {
        var grouping = _CPUndoGroupingPool.pop();
        grouping._parent = anUndoGrouping;
        if (grouping._invocations.length)
            grouping._invocations = [];
        return grouping;
    }
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithParent:", anUndoGrouping);
}
,["id","_CPUndoGrouping"])]);
}
var _CPUndoGroupingParentKey = "_CPUndoGroupingParentKey",
    _CPUndoGroupingInvocationsKey = "_CPUndoGroupingInvocationsKey",
    _CPUndoGroupingActionNameKey = "_CPUndoGroupingActionNameKey";
{
var the_class = objj_getClass("_CPUndoGrouping")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"_CPUndoGrouping\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $_CPUndoGrouping__initWithCoder_(self, _cmd, aCoder)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPUndoGrouping").super_class }, "init");
    if (self)
    {
        self._parent = objj_msgSend(aCoder, "decodeObjectForKey:", _CPUndoGroupingParentKey);
        self._invocations = objj_msgSend(aCoder, "decodeObjectForKey:", _CPUndoGroupingInvocationsKey);
        self._actionName = objj_msgSend(aCoder, "decodeObjectForKey:", _CPUndoGroupingActionNameKey);
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $_CPUndoGrouping__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeObject:forKey:", self._parent, _CPUndoGroupingParentKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._invocations, _CPUndoGroupingInvocationsKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._actionName, _CPUndoGroupingActionNameKey);
}
,["void","CPCoder"])]);
}
{var the_class = objj_allocateClassPair(CPObject, "CPUndoManager"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_redoStack"), new objj_ivar("_undoStack"), new objj_ivar("_groupsByEvent"), new objj_ivar("_disableCount"), new objj_ivar("_levelsOfUndo"), new objj_ivar("_currentGrouping"), new objj_ivar("_state"), new objj_ivar("_preparedTarget"), new objj_ivar("_undoManagerProxy"), new objj_ivar("_runLoopModes"), new objj_ivar("_registeredWithRunLoop")]);






































objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPUndoManager__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPUndoManager").super_class }, "init");
    if (self)
    {
        self._redoStack = [];
        self._undoStack = [];
        self._state = CPUndoManagerNormal;
        objj_msgSend(self, "setRunLoopModes:", [CPDefaultRunLoopMode]);
        objj_msgSend(self, "setGroupsByEvent:", YES);
        self._undoManagerProxy = objj_msgSend(_CPUndoManagerProxy, "alloc");
        self._undoManagerProxy._undoManager = self;
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("_addUndoInvocation:"), function $CPUndoManager___addUndoInvocation_(self, _cmd, anInvocation)
{
    if (!self._currentGrouping)
        if (objj_msgSend(self, "groupsByEvent"))
            objj_msgSend(self, "_beginUndoGroupingForEvent");
        else
            objj_msgSend(CPException, "raise:reason:", CPInternalInconsistencyException, "No undo group is currently open");
    objj_msgSend(self._currentGrouping, "addInvocation:", anInvocation);
    if (self._state === CPUndoManagerNormal)
        objj_msgSend(self._redoStack, "removeAllObjects");
}
,["void","CPInvocation"]), new objj_method(sel_getUid("registerUndoWithTarget:selector:object:"), function $CPUndoManager__registerUndoWithTarget_selector_object_(self, _cmd, aTarget, aSelector, anObject)
{
    if (self._disableCount > 0)
        return;
    var invocation = objj_msgSend(CPInvocation, "invocationWithMethodSignature:", nil);
    objj_msgSend(invocation, "setTarget:", aTarget);
    objj_msgSend(invocation, "setSelector:", aSelector);
    objj_msgSend(invocation, "setArgument:atIndex:", anObject, 2);
    objj_msgSend(self, "_addUndoInvocation:", invocation);
}
,["void","id","SEL","id"]), new objj_method(sel_getUid("prepareWithInvocationTarget:"), function $CPUndoManager__prepareWithInvocationTarget_(self, _cmd, aTarget)
{
    self._preparedTarget = aTarget;
    return self._undoManagerProxy;
}
,["id","id"]), new objj_method(sel_getUid("_methodSignatureOfPreparedTargetForSelector:"), function $CPUndoManager___methodSignatureOfPreparedTargetForSelector_(self, _cmd, aSelector)
{
    if (objj_msgSend(self._preparedTarget, "respondsToSelector:", aSelector))
        return 1;
    return nil;
}
,["CPMethodSignature","SEL"]), new objj_method(sel_getUid("_forwardInvocationToPreparedTarget:"), function $CPUndoManager___forwardInvocationToPreparedTarget_(self, _cmd, anInvocation)
{
    if (self._disableCount > 0)
        return;
    objj_msgSend(anInvocation, "setTarget:", self._preparedTarget);
    objj_msgSend(self, "_addUndoInvocation:", anInvocation);
    self._preparedTarget = nil;
}
,["void","CPInvocation"]), new objj_method(sel_getUid("canRedo"), function $CPUndoManager__canRedo(self, _cmd)
{
    objj_msgSend(objj_msgSend(CPNotificationCenter, "defaultCenter"), "postNotificationName:object:", CPUndoManagerCheckpointNotification, self);
    return objj_msgSend(self._redoStack, "count") > 0;
}
,["BOOL"]), new objj_method(sel_getUid("canUndo"), function $CPUndoManager__canUndo(self, _cmd)
{
    if (self._undoStack.length > 0)
        return YES;
    return objj_msgSend(objj_msgSend(self._currentGrouping, "invocations"), "count") > 0;
}
,["BOOL"]), new objj_method(sel_getUid("undo"), function $CPUndoManager__undo(self, _cmd)
{
    if (objj_msgSend(self, "groupingLevel") === 1)
        objj_msgSend(self, "endUndoGrouping");
    objj_msgSend(self, "undoNestedGroup");
}
,["void"]), new objj_method(sel_getUid("undoNestedGroup"), function $CPUndoManager__undoNestedGroup(self, _cmd)
{
    if (objj_msgSend(self._undoStack, "count") <= 0)
        return;
    var defaultCenter = objj_msgSend(CPNotificationCenter, "defaultCenter");
    objj_msgSend(defaultCenter, "postNotificationName:object:", CPUndoManagerCheckpointNotification, self);
    objj_msgSend(defaultCenter, "postNotificationName:object:", CPUndoManagerWillUndoChangeNotification, self);
    var undoGrouping = self._undoStack.pop(),
        actionName = objj_msgSend(undoGrouping, "actionName");
    self._state = CPUndoManagerUndoing;
    objj_msgSend(self, "_beginUndoGrouping");
    objj_msgSend(undoGrouping, "invoke");
    objj_msgSend(self, "endUndoGrouping");
    objj_msgSend(_CPUndoGrouping, "_poolUndoGrouping:", undoGrouping);
    self._state = CPUndoManagerNormal;
    objj_msgSend(objj_msgSend(self._redoStack, "lastObject"), "setActionName:", actionName);
    objj_msgSend(defaultCenter, "postNotificationName:object:", CPUndoManagerDidUndoChangeNotification, self);
}
,["void"]), new objj_method(sel_getUid("redo"), function $CPUndoManager__redo(self, _cmd)
{
    if (objj_msgSend(self._redoStack, "count") <= 0)
        return;
    var defaultCenter = objj_msgSend(CPNotificationCenter, "defaultCenter");
    objj_msgSend(defaultCenter, "postNotificationName:object:", CPUndoManagerCheckpointNotification, self);
    objj_msgSend(defaultCenter, "postNotificationName:object:", CPUndoManagerWillRedoChangeNotification, self);
    var oldUndoGrouping = self._currentGrouping,
        undoGrouping = self._redoStack.pop(),
        actionName = objj_msgSend(undoGrouping, "actionName");
    self._currentGrouping = nil;
    self._state = CPUndoManagerRedoing;
    objj_msgSend(self, "_beginUndoGrouping");
    objj_msgSend(undoGrouping, "invoke");
    objj_msgSend(self, "endUndoGrouping");
    objj_msgSend(_CPUndoGrouping, "_poolUndoGrouping:", undoGrouping);
    self._currentGrouping = oldUndoGrouping;
    self._state = CPUndoManagerNormal;
    objj_msgSend(objj_msgSend(self._undoStack, "lastObject"), "setActionName:", actionName);
    objj_msgSend(defaultCenter, "postNotificationName:object:", CPUndoManagerDidRedoChangeNotification, self);
}
,["void"]), new objj_method(sel_getUid("beginUndoGrouping"), function $CPUndoManager__beginUndoGrouping(self, _cmd)
{
    if (!self._currentGrouping && objj_msgSend(self, "groupsByEvent"))
        objj_msgSend(self, "_beginUndoGroupingForEvent");
    objj_msgSend(objj_msgSend(CPNotificationCenter, "defaultCenter"), "postNotificationName:object:", CPUndoManagerCheckpointNotification, self);
    objj_msgSend(self, "_beginUndoGrouping");
}
,["void"]), new objj_method(sel_getUid("_beginUndoGroupingForEvent"), function $CPUndoManager___beginUndoGroupingForEvent(self, _cmd)
{
    objj_msgSend(self, "_beginUndoGrouping");
    objj_msgSend(self, "_registerWithRunLoop");
}
,["void"]), new objj_method(sel_getUid("_beginUndoGrouping"), function $CPUndoManager___beginUndoGrouping(self, _cmd)
{
    self._currentGrouping = objj_msgSend(_CPUndoGrouping, "undoGroupingWithParent:", self._currentGrouping);
}
,["void"]), new objj_method(sel_getUid("endUndoGrouping"), function $CPUndoManager__endUndoGrouping(self, _cmd)
{
    if (!self._currentGrouping)
        objj_msgSend(CPException, "raise:reason:", CPInternalInconsistencyException, "endUndoGrouping. No undo group is currently open.");
    var defaultCenter = objj_msgSend(CPNotificationCenter, "defaultCenter");
    objj_msgSend(defaultCenter, "postNotificationName:object:", CPUndoManagerCheckpointNotification, self);
    var parent = objj_msgSend(self._currentGrouping, "parent");
    if (!parent && objj_msgSend(self._currentGrouping, "invocations").length > 0)
    {
        objj_msgSend(defaultCenter, "postNotificationName:object:", CPUndoManagerWillCloseUndoGroupNotification, self);
        var stack = self._state === CPUndoManagerUndoing ? self._redoStack : self._undoStack;
        stack.push(self._currentGrouping);
        if (self._levelsOfUndo > 0 && stack.length > self._levelsOfUndo)
            stack.splice(0, 1);
        objj_msgSend(defaultCenter, "postNotificationName:object:", CPUndoManagerDidCloseUndoGroupNotification, self);
    }
    else
    {
        objj_msgSend(parent, "addInvocationsFromArray:", objj_msgSend(self._currentGrouping, "invocations"));
        objj_msgSend(_CPUndoGrouping, "_poolUndoGrouping:", self._currentGrouping);
    }
    self._currentGrouping = parent;
}
,["void"]), new objj_method(sel_getUid("enableUndoRegistration"), function $CPUndoManager__enableUndoRegistration(self, _cmd)
{
    if (self._disableCount <= 0)
        objj_msgSend(CPException, "raise:reason:", CPInternalInconsistencyException, "enableUndoRegistration. There are no disable messages in effect right now.");
    self._disableCount--;
}
,["void"]), new objj_method(sel_getUid("groupsByEvent"), function $CPUndoManager__groupsByEvent(self, _cmd)
{
    return self._groupsByEvent;
}
,["BOOL"]), new objj_method(sel_getUid("setGroupsByEvent:"), function $CPUndoManager__setGroupsByEvent_(self, _cmd, aFlag)
{
    aFlag = !!aFlag;
    if (self._groupsByEvent === aFlag)
        return;
    self._groupsByEvent = aFlag;
    if (!objj_msgSend(self, "groupsByEvent"))
        objj_msgSend(self, "_unregisterWithRunLoop");
}
,["void","BOOL"]), new objj_method(sel_getUid("groupingLevel"), function $CPUndoManager__groupingLevel(self, _cmd)
{
    var grouping = self._currentGrouping,
        level = self._currentGrouping ? 1 : 0;
    while (grouping = objj_msgSend(grouping, "parent"))
        ++level;
    return level;
}
,["unsigned"]), new objj_method(sel_getUid("disableUndoRegistration"), function $CPUndoManager__disableUndoRegistration(self, _cmd)
{
    ++self._disableCount;
}
,["void"]), new objj_method(sel_getUid("isUndoRegistrationEnabled"), function $CPUndoManager__isUndoRegistrationEnabled(self, _cmd)
{
    return self._disableCount == 0;
}
,["BOOL"]), new objj_method(sel_getUid("isUndoing"), function $CPUndoManager__isUndoing(self, _cmd)
{
    return self._state === CPUndoManagerUndoing;
}
,["BOOL"]), new objj_method(sel_getUid("isRedoing"), function $CPUndoManager__isRedoing(self, _cmd)
{
    return self._state === CPUndoManagerRedoing;
}
,["BOOL"]), new objj_method(sel_getUid("removeAllActions"), function $CPUndoManager__removeAllActions(self, _cmd)
{
    while (self._currentGrouping)
        objj_msgSend(self, "endUndoGrouping");
    objj_msgSend(self, "_unregisterWithRunLoop");
    self._state = CPUndoManagerNormal;
    self._redoStack = [];
    self._undoStack = [];
    self._disableCount = 0;
}
,["void"]), new objj_method(sel_getUid("removeAllActionsWithTarget:"), function $CPUndoManager__removeAllActionsWithTarget_(self, _cmd, aTarget)
{
    objj_msgSend(self._currentGrouping, "removeInvocationsWithTarget:", aTarget);
    var index = self._redoStack.length;
    while (index--)
    {
        var grouping = self._redoStack[index];
        objj_msgSend(grouping, "removeInvocationsWithTarget:", aTarget);
        if (!objj_msgSend(grouping, "invocations").length)
            self._redoStack.splice(index, 1);
    }
    index = self._undoStack.length;
    while (index--)
    {
        var grouping = self._undoStack[index];
        objj_msgSend(grouping, "removeInvocationsWithTarget:", aTarget);
        if (!objj_msgSend(grouping, "invocations").length)
            self._undoStack.splice(index, 1);
    }
}
,["void","id"]), new objj_method(sel_getUid("setActionName:"), function $CPUndoManager__setActionName_(self, _cmd, anActionName)
{
    if (anActionName !== nil && self._currentGrouping)
        objj_msgSend(self._currentGrouping, "setActionName:", anActionName);
}
,["void","CPString"]), new objj_method(sel_getUid("redoActionName"), function $CPUndoManager__redoActionName(self, _cmd)
{
    if (!objj_msgSend(self, "canRedo"))
        return nil;
    return objj_msgSend(objj_msgSend(self._redoStack, "lastObject"), "actionName");
}
,["CPString"]), new objj_method(sel_getUid("redoMenuItemTitle"), function $CPUndoManager__redoMenuItemTitle(self, _cmd)
{
    return objj_msgSend(self, "redoMenuTitleForUndoActionName:", objj_msgSend(self, "redoActionName"));
}
,["CPString"]), new objj_method(sel_getUid("redoMenuTitleForUndoActionName:"), function $CPUndoManager__redoMenuTitleForUndoActionName_(self, _cmd, anActionName)
{
    if (anActionName || anActionName === 0)
        return "Redo " + anActionName;
    return "Redo";
}
,["CPString","CPString"]), new objj_method(sel_getUid("undoActionName"), function $CPUndoManager__undoActionName(self, _cmd)
{
    if (!objj_msgSend(self, "canUndo"))
        return nil;
    return objj_msgSend(objj_msgSend(self._undoStack, "lastObject"), "actionName");
}
,["CPString"]), new objj_method(sel_getUid("undoMenuItemTitle"), function $CPUndoManager__undoMenuItemTitle(self, _cmd)
{
    return objj_msgSend(self, "undoMenuTitleForUndoActionName:", objj_msgSend(self, "undoActionName"));
}
,["CPString"]), new objj_method(sel_getUid("undoMenuTitleForUndoActionName:"), function $CPUndoManager__undoMenuTitleForUndoActionName_(self, _cmd, anActionName)
{
    if (anActionName || anActionName === 0)
        return "Undo " + anActionName;
    return "Undo";
}
,["CPString","CPString"]), new objj_method(sel_getUid("runLoopModes"), function $CPUndoManager__runLoopModes(self, _cmd)
{
    return self._runLoopModes;
}
,["CPArray"]), new objj_method(sel_getUid("setRunLoopModes:"), function $CPUndoManager__setRunLoopModes_(self, _cmd, modes)
{
    self._runLoopModes = objj_msgSend(modes, "copy");
    if (self._registeredWithRunLoop)
    {
        objj_msgSend(self, "_unregisterWithRunLoop");
        objj_msgSend(self, "_registerWithRunLoop");
    }
}
,["void","CPArray"]), new objj_method(sel_getUid("_runLoopEndUndoGrouping"), function $CPUndoManager___runLoopEndUndoGrouping(self, _cmd)
{
    objj_msgSend(self, "endUndoGrouping");
    self._registeredWithRunLoop = NO;
}
,["void"]), new objj_method(sel_getUid("_registerWithRunLoop"), function $CPUndoManager___registerWithRunLoop(self, _cmd)
{
    if (self._registeredWithRunLoop)
        return;
    self._registeredWithRunLoop = YES;
    objj_msgSend(objj_msgSend(CPRunLoop, "currentRunLoop"), "performSelector:target:argument:order:modes:", sel_getUid("_runLoopEndUndoGrouping"), self, nil, CPUndoCloseGroupingRunLoopOrdering, self._runLoopModes);
}
,["void"]), new objj_method(sel_getUid("_unregisterWithRunLoop"), function $CPUndoManager___unregisterWithRunLoop(self, _cmd)
{
    if (!self._registeredWithRunLoop)
        return;
    self._registeredWithRunLoop = NO;
    objj_msgSend(objj_msgSend(CPRunLoop, "currentRunLoop"), "cancelPerformSelector:target:argument:", sel_getUid("_runLoopEndUndoGrouping"), self, nil);
}
,["void"]), new objj_method(sel_getUid("observeChangesForKeyPath:ofObject:"), function $CPUndoManager__observeChangesForKeyPath_ofObject_(self, _cmd, aKeyPath, anObject)
{
    objj_msgSend(anObject, "addObserver:forKeyPath:options:context:", self, aKeyPath, CPKeyValueObservingOptionOld | CPKeyValueObservingOptionNew, NULL);
}
,["void","CPString","id"]), new objj_method(sel_getUid("stopObservingChangesForKeyPath:ofObject:"), function $CPUndoManager__stopObservingChangesForKeyPath_ofObject_(self, _cmd, aKeyPath, anObject)
{
    objj_msgSend(anObject, "removeObserver:forKeyPath:", self, aKeyPath);
}
,["void","CPString","id"]), new objj_method(sel_getUid("observeValueForKeyPath:ofObject:change:context:"), function $CPUndoManager__observeValueForKeyPath_ofObject_change_context_(self, _cmd, aKeyPath, anObject, aChange, aContext)
{
    var before = objj_msgSend(aChange, "valueForKey:", CPKeyValueChangeOldKey),
        after = objj_msgSend(aChange, "valueForKey:", CPKeyValueChangeNewKey);
    if (before === after || (before !== nil && before.isa && (after === nil || after.isa) && objj_msgSend(before, "isEqual:", after)))
        return;
    objj_msgSend(objj_msgSend(self, "prepareWithInvocationTarget:", anObject), "applyChange:toKeyPath:", objj_msgSend(aChange, "inverseChangeDictionary"), aKeyPath);
}
,["void","CPString","id","CPDictionary","id"])]);
}
var CPUndoManagerRedoStackKey = "CPUndoManagerRedoStackKey",
    CPUndoManagerUndoStackKey = "CPUndoManagerUndoStackKey",
    CPUndoManagerLevelsOfUndoKey = "CPUndoManagerLevelsOfUndoKey",
    CPUndoManagerActionNameKey = "CPUndoManagerActionNameKey",
    CPUndoManagerCurrentGroupingKey = "CPUndoManagerCurrentGroupingKey",
    CPUndoManagerRunLoopModesKey = "CPUndoManagerRunLoopModesKey",
    CPUndoManagerGroupsByEventKey = "CPUndoManagerGroupsByEventKey";
{
var the_class = objj_getClass("CPUndoManager")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPUndoManager\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPUndoManager__initWithCoder_(self, _cmd, aCoder)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPUndoManager").super_class }, "init");
    if (self)
    {
        self._redoStack = objj_msgSend(aCoder, "decodeObjectForKey:", CPUndoManagerRedoStackKey);
        self._undoStack = objj_msgSend(aCoder, "decodeObjectForKey:", CPUndoManagerUndoStackKey);
        self._levelsOfUndo = objj_msgSend(aCoder, "decodeObjectForKey:", CPUndoManagerLevelsOfUndoKey);
        self._currentGrouping = objj_msgSend(aCoder, "decodeObjectForKey:", CPUndoManagerCurrentGroupingKey);
        self._state = CPUndoManagerNormal;
        objj_msgSend(self, "setRunLoopModes:", objj_msgSend(aCoder, "decodeObjectForKey:", CPUndoManagerRunLoopModesKey));
        objj_msgSend(self, "setGroupsByEvent:", objj_msgSend(aCoder, "decodeBoolForKey:", CPUndoManagerGroupsByEventKey));
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPUndoManager__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeObject:forKey:", self._redoStack, CPUndoManagerRedoStackKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._undoStack, CPUndoManagerUndoStackKey);
    objj_msgSend(aCoder, "encodeInt:forKey:", self._levelsOfUndo, CPUndoManagerLevelsOfUndoKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._currentGrouping, CPUndoManagerCurrentGroupingKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._runLoopModes, CPUndoManagerRunLoopModesKey);
    objj_msgSend(aCoder, "encodeBool:forKey:", self._groupsByEvent, CPUndoManagerGroupsByEventKey);
}
,["void","CPCoder"])]);
}
{var the_class = objj_allocateClassPair(CPProxy, "_CPUndoManagerProxy"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_undoManager")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("methodSignatureForSelector:"), function $_CPUndoManagerProxy__methodSignatureForSelector_(self, _cmd, aSelector)
{
    return objj_msgSend(self._undoManager, "_methodSignatureOfPreparedTargetForSelector:", aSelector);
}
,["CPMethodSignature","SEL"]), new objj_method(sel_getUid("forwardInvocation:"), function $_CPUndoManagerProxy__forwardInvocation_(self, _cmd, anInvocation)
{
    objj_msgSend(self._undoManager, "_forwardInvocationToPreparedTarget:", anInvocation);
}
,["void","CPInvocation"])]);
}p;7;CPURL.jt;8387;@STATIC;1.0;i;10;CPObject.ji;10;CPString.jt;8338;objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
CPURLNameKey = "CPURLNameKey";
CPURLLocalizedNameKey = "CPURLLocalizedNameKey";
CPURLIsRegularFileKey = "CPURLIsRegularFileKey";
CPURLIsDirectoryKey = "CPURLIsDirectoryKey";
CPURLIsSymbolicLinkKey = "CPURLIsSymbolicLinkKey";
CPURLIsVolumeKey = "CPURLIsVolumeKey";
CPURLIsPackageKey = "CPURLIsPackageKey";
CPURLIsSystemImmutableKey = "CPURLIsSystemImmutableKey";
CPURLIsUserImmutableKey = "CPURLIsUserImmutableKey";
CPURLIsHiddenKey = "CPURLIsHiddenKey";
CPURLHasHiddenExtensionKey = "CPURLHasHiddenExtensionKey";
CPURLCreationDateKey = "CPURLCreationDateKey";
CPURLContentAccessDateKey = "CPURLContentAccessDateKey";
CPURLContentModificationDateKey = "CPURLContentModificationDateKey";
CPURLAttributeModificationDateKey = "CPURLAttributeModificationDateKey";
CPURLLinkCountKey = "CPURLLinkCountKey";
CPURLParentDirectoryURLKey = "CPURLParentDirectoryURLKey";
CPURLVolumeURLKey = "CPURLTypeIdentifierKey";
CPURLTypeIdentifierKey = "CPURLTypeIdentifierKey";
CPURLLocalizedTypeDescriptionKey = "CPURLLocalizedTypeDescriptionKey";
CPURLLabelNumberKey = "CPURLLabelNumberKey";
CPURLLabelColorKey = "CPURLLabelColorKey";
CPURLLocalizedLabelKey = "CPURLLocalizedLabelKey";
CPURLEffectiveIconKey = "CPURLEffectiveIconKey";
CPURLCustomIconKey = "CPURLCustomIconKey";
{var the_class = objj_allocateClassPair(CPObject, "CPURL"),
meta_class = the_class.isa;






























objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPURL__init(self, _cmd)
{
    return nil;
}
,["id"]), new objj_method(sel_getUid("initWithScheme:host:path:"), function $CPURL__initWithScheme_host_path_(self, _cmd, aScheme, aHost, aPath)
{
    var URLString = (aScheme ? aScheme + ":" : "") + (aHost ? aHost + "//" : "") + (aPath || "");
    return objj_msgSend(self, "initWithString:", URLString);
}
,["id","CPString","CPString","CPString"]), new objj_method(sel_getUid("initWithString:"), function $CPURL__initWithString_(self, _cmd, URLString)
{
    return objj_msgSend(self, "initWithString:relativeToURL:", URLString, nil);
}
,["id","CPString"]), new objj_method(sel_getUid("initWithString:relativeToURL:"), function $CPURL__initWithString_relativeToURL_(self, _cmd, URLString, aBaseURL)
{
    var result = new CFURL(URLString, aBaseURL);
    result.isa = objj_msgSend(self, "class");
    return result;
}
,["id","CPString","CPURL"]), new objj_method(sel_getUid("absoluteURL"), function $CPURL__absoluteURL(self, _cmd)
{
    return self.absoluteURL();
}
,["CPURL"]), new objj_method(sel_getUid("baseURL"), function $CPURL__baseURL(self, _cmd)
{
    return self.baseURL();
}
,["CPURL"]), new objj_method(sel_getUid("absoluteString"), function $CPURL__absoluteString(self, _cmd)
{
    return self.absoluteString();
}
,["CPString"]), new objj_method(sel_getUid("relativeString"), function $CPURL__relativeString(self, _cmd)
{
    return self.string();
}
,["CPString"]), new objj_method(sel_getUid("path"), function $CPURL__path(self, _cmd)
{
    return objj_msgSend(self, "absoluteURL").path();
}
,["CPString"]), new objj_method(sel_getUid("pathComponents"), function $CPURL__pathComponents(self, _cmd)
{
    var components = self.pathComponents();
    return objj_msgSend(components, "copy");
}
,["CPArray"]), new objj_method(sel_getUid("relativePath"), function $CPURL__relativePath(self, _cmd)
{
    return self.path();
}
,["CPString"]), new objj_method(sel_getUid("scheme"), function $CPURL__scheme(self, _cmd)
{
    return self.scheme();
}
,["CPString"]), new objj_method(sel_getUid("user"), function $CPURL__user(self, _cmd)
{
    return objj_msgSend(self, "absoluteURL").user();
}
,["CPString"]), new objj_method(sel_getUid("password"), function $CPURL__password(self, _cmd)
{
    return objj_msgSend(self, "absoluteURL").password();
}
,["CPString"]), new objj_method(sel_getUid("host"), function $CPURL__host(self, _cmd)
{
    return objj_msgSend(self, "absoluteURL").domain();
}
,["CPString"]), new objj_method(sel_getUid("port"), function $CPURL__port(self, _cmd)
{
    var portNumber = objj_msgSend(self, "absoluteURL").portNumber();
    if (portNumber === -1)
        return nil;
    return portNumber;
}
,["Number"]), new objj_method(sel_getUid("parameterString"), function $CPURL__parameterString(self, _cmd)
{
    return self.queryString();
}
,["CPString"]), new objj_method(sel_getUid("fragment"), function $CPURL__fragment(self, _cmd)
{
    return self.fragment();
}
,["CPString"]), new objj_method(sel_getUid("isEqual:"), function $CPURL__isEqual_(self, _cmd, anObject)
{
    if (self === anObject)
        return YES;
    if (!anObject || !objj_msgSend(anObject, "isKindOfClass:", objj_msgSend(CPURL, "class")))
        return NO;
    return objj_msgSend(self, "isEqualToURL:", anObject);
}
,["BOOL","id"]), new objj_method(sel_getUid("isEqualToURL:"), function $CPURL__isEqualToURL_(self, _cmd, aURL)
{
    if (self === aURL)
        return YES;
    return objj_msgSend(objj_msgSend(self, "absoluteString"), "isEqual:", objj_msgSend(aURL, "absoluteString"));
}
,["BOOL","id"]), new objj_method(sel_getUid("lastPathComponent"), function $CPURL__lastPathComponent(self, _cmd)
{
    return objj_msgSend(self, "absoluteURL").lastPathComponent();
}
,["CPString"]), new objj_method(sel_getUid("pathExtension"), function $CPURL__pathExtension(self, _cmd)
{
    return self.pathExtension();
}
,["CPString"]), new objj_method(sel_getUid("URLByDeletingLastPathComponent"), function $CPURL__URLByDeletingLastPathComponent(self, _cmd)
{
    var result = self.createCopyDeletingLastPathComponent();
    result.isa = objj_msgSend(self, "class");
    return result;
}
,["CPURL"]), new objj_method(sel_getUid("standardizedURL"), function $CPURL__standardizedURL(self, _cmd)
{
    return self.standardizedURL();
}
,["CPURL"]), new objj_method(sel_getUid("isFileURL"), function $CPURL__isFileURL(self, _cmd)
{
    return objj_msgSend(self, "scheme") === "file";
}
,["BOOL"]), new objj_method(sel_getUid("description"), function $CPURL__description(self, _cmd)
{
    return objj_msgSend(self, "absoluteString");
}
,["CPString"]), new objj_method(sel_getUid("resourceValueForKey:"), function $CPURL__resourceValueForKey_(self, _cmd, aKey)
{
    return self.resourcePropertyForKey(aKey);
}
,["id","CPString"]), new objj_method(sel_getUid("setResourceValue:forKey:"), function $CPURL__setResourceValue_forKey_(self, _cmd, anObject, aKey)
{
    return self.setResourcePropertyForKey(aKey, anObject);
}
,["id","id","CPString"]), new objj_method(sel_getUid("staticResourceData"), function $CPURL__staticResourceData(self, _cmd)
{
    return self.staticResourceData();
}
,["CPData"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $CPURL__alloc(self, _cmd)
{
    var result = new CFURL();
    result.isa = objj_msgSend(self, "class");
    return result;
}
,["id"]), new objj_method(sel_getUid("URLWithString:"), function $CPURL__URLWithString_(self, _cmd, URLString)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithString:", URLString);
}
,["id","CPString"]), new objj_method(sel_getUid("URLWithString:relativeToURL:"), function $CPURL__URLWithString_relativeToURL_(self, _cmd, URLString, aBaseURL)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithString:relativeToURL:", URLString, aBaseURL);
}
,["id","CPString","CPURL"])]);
}
var CPURLURLStringKey = "CPURLURLStringKey",
    CPURLBaseURLKey = "CPURLBaseURLKey";
{
var the_class = objj_getClass("CPURL")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPURL\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPURL__initWithCoder_(self, _cmd, aCoder)
{
    return objj_msgSend(self, "initWithString:relativeToURL:", objj_msgSend(aCoder, "decodeObjectForKey:", CPURLURLStringKey), objj_msgSend(aCoder, "decodeObjectForKey:", CPURLBaseURLKey));
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPURL__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeObject:forKey:", self._baseURL, CPURLBaseURLKey);
    objj_msgSend(aCoder, "encodeObject:forKey:", self._string, CPURLURLStringKey);
}
,["void","CPCoder"])]);
}
CFURL.prototype.isa = objj_msgSend(CPURL, "class");p;17;CPURLConnection.jt;8168;@STATIC;1.0;i;8;CPData.ji;10;CPObject.ji;11;CPRunLoop.ji;14;CPURLRequest.ji;15;CPURLResponse.jt;8067;objj_executeFile("CPData.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPRunLoop.j", YES);
objj_executeFile("CPURLRequest.j", YES);
objj_executeFile("CPURLResponse.j", YES);
var CPURLConnectionDelegate = nil;
{var the_class = objj_allocateClassPair(CPObject, "CPURLConnection"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_request"), new objj_ivar("_delegate"), new objj_ivar("_isCanceled"), new objj_ivar("_isLocalFileConnection"), new objj_ivar("_HTTPRequest")]);









objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithRequest:delegate:startImmediately:"), function $CPURLConnection__initWithRequest_delegate_startImmediately_(self, _cmd, aRequest, aDelegate, shouldStartImmediately)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPURLConnection").super_class }, "init");
    if (self)
    {
        self._request = aRequest;
        self._delegate = aDelegate;
        self._isCanceled = NO;
        var URL = objj_msgSend(self._request, "URL"),
            scheme = objj_msgSend(URL, "scheme");
        self._isLocalFileConnection = scheme === "file" ||
                                    ((scheme === "http" || scheme === "https:") &&
                                    window.location &&
                                    (window.location.protocol === "file:" || window.location.protocol === "app:"));
        self._HTTPRequest = new CFHTTPRequest();
        if (shouldStartImmediately)
            objj_msgSend(self, "start");
    }
    return self;
}
,["id","CPURLRequest","id","BOOL"]), new objj_method(sel_getUid("initWithRequest:delegate:"), function $CPURLConnection__initWithRequest_delegate_(self, _cmd, aRequest, aDelegate)
{
    return objj_msgSend(self, "initWithRequest:delegate:startImmediately:", aRequest, aDelegate, YES);
}
,["id","CPURLRequest","id"]), new objj_method(sel_getUid("delegate"), function $CPURLConnection__delegate(self, _cmd)
{
    return self._delegate;
}
,["id"]), new objj_method(sel_getUid("start"), function $CPURLConnection__start(self, _cmd)
{
    self._isCanceled = NO;
    try
    {
        self._HTTPRequest.open(objj_msgSend(self._request, "HTTPMethod"), objj_msgSend(objj_msgSend(self._request, "URL"), "absoluteString"), YES);
        self._HTTPRequest.onreadystatechange = function() { objj_msgSend(self, "_readyStateDidChange"); };
        var fields = objj_msgSend(self._request, "allHTTPHeaderFields"),
            key = nil,
            keys = objj_msgSend(fields, "keyEnumerator");
        while ((key = objj_msgSend(keys, "nextObject")) !== nil)
            self._HTTPRequest.setRequestHeader(key, objj_msgSend(fields, "objectForKey:", key));
        self._HTTPRequest.send(objj_msgSend(self._request, "HTTPBody"));
    }
    catch (anException)
    {
        if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("connection:didFailWithError:")))
            objj_msgSend(self._delegate, "connection:didFailWithError:", self, anException);
    }
}
,["void"]), new objj_method(sel_getUid("cancel"), function $CPURLConnection__cancel(self, _cmd)
{
    self._isCanceled = YES;
    try
    {
        self._HTTPRequest.abort();
    }
    catch (anException)
    {
    }
}
,["void"]), new objj_method(sel_getUid("isLocalFileConnection"), function $CPURLConnection__isLocalFileConnection(self, _cmd)
{
    return self._isLocalFileConnection;
}
,["BOOL"]), new objj_method(sel_getUid("_readyStateDidChange"), function $CPURLConnection___readyStateDidChange(self, _cmd)
{
    if (self._HTTPRequest.readyState() === CFHTTPRequest.CompleteState)
    {
        var statusCode = self._HTTPRequest.status(),
            URL = objj_msgSend(self._request, "URL");
        if (statusCode === 401 && objj_msgSend(CPURLConnectionDelegate, "respondsToSelector:", sel_getUid("connectionDidReceiveAuthenticationChallenge:")))
            objj_msgSend(CPURLConnectionDelegate, "connectionDidReceiveAuthenticationChallenge:", self);
        else
        {
            if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("connection:didReceiveResponse:")))
            {
                if (self._isLocalFileConnection)
                    objj_msgSend(self._delegate, "connection:didReceiveResponse:", self, objj_msgSend(objj_msgSend(CPURLResponse, "alloc"), "initWithURL:", URL));
                else
                {
                    var response = objj_msgSend(objj_msgSend(CPHTTPURLResponse, "alloc"), "initWithURL:", URL);
                    objj_msgSend(response, "_setStatusCode:", statusCode);
                    objj_msgSend(response, "_setAllResponseHeaders:", self._HTTPRequest.getAllResponseHeaders());
                    objj_msgSend(self._delegate, "connection:didReceiveResponse:", self, response);
                }
            }
            if (!self._isCanceled)
            {
                if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("connection:didReceiveData:")))
                    objj_msgSend(self._delegate, "connection:didReceiveData:", self, self._HTTPRequest.responseText());
                if (objj_msgSend(self._delegate, "respondsToSelector:", sel_getUid("connectionDidFinishLoading:")))
                    objj_msgSend(self._delegate, "connectionDidFinishLoading:", self);
            }
        }
    }
    objj_msgSend(objj_msgSend(CPRunLoop, "currentRunLoop"), "limitDateForMode:", CPDefaultRunLoopMode);
}
,["void"]), new objj_method(sel_getUid("_HTTPRequest"), function $CPURLConnection___HTTPRequest(self, _cmd)
{
    return self._HTTPRequest;
}
,["HTTPRequest"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("setClassDelegate:"), function $CPURLConnection__setClassDelegate_(self, _cmd, delegate)
{
    CPURLConnectionDelegate = delegate;
}
,["void","id"]), new objj_method(sel_getUid("sendSynchronousRequest:returningResponse:"), function $CPURLConnection__sendSynchronousRequest_returningResponse_(self, _cmd, aRequest, aURLResponse)
{
    try
    {
        var request = new CFHTTPRequest();
        request.open(objj_msgSend(aRequest, "HTTPMethod"), objj_msgSend(objj_msgSend(aRequest, "URL"), "absoluteString"), NO);
        var fields = objj_msgSend(aRequest, "allHTTPHeaderFields"),
            key = nil,
            keys = objj_msgSend(fields, "keyEnumerator");
        while ((key = objj_msgSend(keys, "nextObject")) !== nil)
            request.setRequestHeader(key, objj_msgSend(fields, "objectForKey:", key));
        request.send(objj_msgSend(aRequest, "HTTPBody"));
        if (!request.success())
            return nil;
        return objj_msgSend(CPData, "dataWithRawString:", request.responseText());
    }
    catch (anException)
    {
    }
    return nil;
}
,["CPData","CPURLRequest","CPURLResponse"]), new objj_method(sel_getUid("connectionWithRequest:delegate:"), function $CPURLConnection__connectionWithRequest_delegate_(self, _cmd, aRequest, aDelegate)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithRequest:delegate:", aRequest, aDelegate);
}
,["CPURLConnection","CPURLRequest","id"])]);
}
{
var the_class = objj_getClass("CPURLConnection")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPURLConnection\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("_XMLHTTPRequest"), function $CPURLConnection___XMLHTTPRequest(self, _cmd)
{
    _CPReportLenientDeprecation(self, _cmd, sel_getUid("_HTTPRequest"));
    return objj_msgSend(self, "_HTTPRequest");
}
,["HTTPRequest"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("sendSynchronousRequest:returningResponse:error:"), function $CPURLConnection__sendSynchronousRequest_returningResponse_error_(self, _cmd, aRequest, aURLResponse, anError)
{
    _CPReportLenientDeprecation(self, _cmd, sel_getUid("sendSynchronousRequest:returningResponse:"));
    return objj_msgSend(self, "sendSynchronousRequest:returningResponse:", aRequest, aURLResponse);
}
,["CPData","CPURLRequest","CPURLResponse","id"])]);
}p;14;CPURLRequest.jt;3232;@STATIC;1.0;i;14;CPDictionary.ji;10;CPObject.ji;10;CPString.ji;7;CPURL.jt;3153;objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("CPURL.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPURLRequest"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_URL"), new objj_ivar("_HTTPBody"), new objj_ivar("_HTTPMethod"), new objj_ivar("_HTTPHeaderFields")]);










objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPURLRequest__init(self, _cmd)
{
    return objj_msgSend(self, "initWithURL:", nil);
}
,["id"]), new objj_method(sel_getUid("initWithURL:"), function $CPURLRequest__initWithURL_(self, _cmd, aURL)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPURLRequest").super_class }, "init");
    if (self)
    {
        objj_msgSend(self, "setURL:", aURL);
        self._HTTPBody = "";
        self._HTTPMethod = "GET";
        self._HTTPHeaderFields = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        objj_msgSend(self, "setValue:forHTTPHeaderField:", "Thu, 01 Jan 1970 00:00:00 GMT", "If-Modified-Since");
        objj_msgSend(self, "setValue:forHTTPHeaderField:", "no-cache", "Cache-Control");
        objj_msgSend(self, "setValue:forHTTPHeaderField:", "XMLHttpRequest", "X-Requested-With");
    }
    return self;
}
,["id","CPURL"]), new objj_method(sel_getUid("URL"), function $CPURLRequest__URL(self, _cmd)
{
    return self._URL;
}
,["CPURL"]), new objj_method(sel_getUid("setURL:"), function $CPURLRequest__setURL_(self, _cmd, aURL)
{
    self._URL = new CFURL(aURL);
}
,["void","CPURL"]), new objj_method(sel_getUid("setHTTPBody:"), function $CPURLRequest__setHTTPBody_(self, _cmd, anHTTPBody)
{
    self._HTTPBody = anHTTPBody;
}
,["void","CPString"]), new objj_method(sel_getUid("HTTPBody"), function $CPURLRequest__HTTPBody(self, _cmd)
{
    return self._HTTPBody;
}
,["CPString"]), new objj_method(sel_getUid("setHTTPMethod:"), function $CPURLRequest__setHTTPMethod_(self, _cmd, anHTTPMethod)
{
    self._HTTPMethod = anHTTPMethod;
}
,["void","CPString"]), new objj_method(sel_getUid("HTTPMethod"), function $CPURLRequest__HTTPMethod(self, _cmd)
{
    return self._HTTPMethod;
}
,["CPString"]), new objj_method(sel_getUid("allHTTPHeaderFields"), function $CPURLRequest__allHTTPHeaderFields(self, _cmd)
{
    return self._HTTPHeaderFields;
}
,["CPDictionary"]), new objj_method(sel_getUid("valueForHTTPHeaderField:"), function $CPURLRequest__valueForHTTPHeaderField_(self, _cmd, aField)
{
    return objj_msgSend(self._HTTPHeaderFields, "objectForKey:", aField);
}
,["CPString","CPString"]), new objj_method(sel_getUid("setValue:forHTTPHeaderField:"), function $CPURLRequest__setValue_forHTTPHeaderField_(self, _cmd, aValue, aField)
{
    objj_msgSend(self._HTTPHeaderFields, "setObject:forKey:", aValue, aField);
}
,["void","CPString","CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("requestWithURL:"), function $CPURLRequest__requestWithURL_(self, _cmd, aURL)
{
    return objj_msgSend(objj_msgSend(CPURLRequest, "alloc"), "initWithURL:", aURL);
}
,["id","CPURL"])]);
}p;15;CPURLResponse.jt;2591;@STATIC;1.0;i;10;CPObject.ji;7;CPURL.jt;2546;objj_executeFile("CPObject.j", YES);
objj_executeFile("CPURL.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPURLResponse"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_URL")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithURL:"), function $CPURLResponse__initWithURL_(self, _cmd, aURL)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPURLResponse").super_class }, "init");
    if (self)
        self._URL = aURL;
    return self;
}
,["id","CPURL"]), new objj_method(sel_getUid("URL"), function $CPURLResponse__URL(self, _cmd)
{
    return self._URL;
}
,["CPURL"])]);
}
{var the_class = objj_allocateClassPair(CPURLResponse, "CPHTTPURLResponse"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_statusCode"), new objj_ivar("_allResponseHeaders"), new objj_ivar("_responseHeaders")]);



objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("_setStatusCode:"), function $CPHTTPURLResponse___setStatusCode_(self, _cmd, aStatusCode)
{
    self._statusCode = aStatusCode;
}
,["void","int"]), new objj_method(sel_getUid("statusCode"), function $CPHTTPURLResponse__statusCode(self, _cmd)
{
    return self._statusCode;
}
,["int"]), new objj_method(sel_getUid("_setAllResponseHeaders:"), function $CPHTTPURLResponse___setAllResponseHeaders_(self, _cmd, responseHeadersString)
{
    self._allResponseHeaders = responseHeadersString;
}
,["void","CPString"]), new objj_method(sel_getUid("allHeaderFields"), function $CPHTTPURLResponse__allHeaderFields(self, _cmd)
{
    if (!self._responseHeaders)
        self._responseHeaders = objj_msgSend(objj_msgSend(self, "class"), "parseHTTPHeaders:", self._allResponseHeaders);
    return self._responseHeaders;
}
,["CPDictionary"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("parseHTTPHeaders:"), function $CPHTTPURLResponse__parseHTTPHeaders_(self, _cmd, headersString)
{
    var r = objj_msgSend(CPMutableDictionary, "dictionary");
    if (headersString)
    {
        var headerLines = headersString.split('\r\n'),
            count = headerLines.length;
        while (count--)
        {
            var headerLine = headerLines[count],
                index = headerLine.indexOf(': ');
            if (index !== CPNotFound)
                objj_msgSend(r, "setValue:forKey:", headerLine.substring(index + 2), headerLine.substring(0, index));
        }
    }
    return r;
}
,["CPDictionary","CPString"])]);
}p;16;CPUserDefaults.jt;19627;@STATIC;1.0;i;10;CPBundle.ji;8;CPData.ji;14;CPDictionary.ji;13;CPException.ji;17;CPKeyedArchiver.ji;19;CPKeyedUnarchiver.ji;22;CPNotificationCenter.ji;10;CPObject.ji;11;CPRunLoop.ji;10;CPString.ji;7;CPURL.ji;17;CPURLConnection.ji;14;CPURLRequest.jt;19372;objj_executeFile("CPBundle.j", YES);
objj_executeFile("CPData.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPKeyedArchiver.j", YES);
objj_executeFile("CPKeyedUnarchiver.j", YES);
objj_executeFile("CPNotificationCenter.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPRunLoop.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("CPURL.j", YES);
objj_executeFile("CPURLConnection.j", YES);
objj_executeFile("CPURLRequest.j", YES);
//@class CPCookie
//@global CPApp
CPArgumentDomain = "CPArgumentDomain";
CPApplicationDomain = objj_msgSend(objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "infoDictionary"), "objectForKey:", "CPBundleIdentifier") || "CPApplicationDomain";
CPGlobalDomain = "CPGlobalDomain";
CPLocaleDomain = "CPLocaleDomain";
CPRegistrationDomain = "CPRegistrationDomain";
CPUserDefaultsDidChangeNotification = "CPUserDefaultsDidChangeNotification";
var StandardUserDefaults;
{var the_class = objj_allocateClassPair(CPObject, "CPUserDefaults"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_domains"), new objj_ivar("_stores"), new objj_ivar("_searchList"), new objj_ivar("_searchListNeedsReload")]);



















       










       




objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPUserDefaults__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPUserDefaults").super_class }, "init");
    if (self)
    {
        self._domains = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        objj_msgSend(self, "_setupArgumentsDomain");
        var defaultStore = objj_msgSend(CPUserDefaultsLocalStore, "supportsLocalStorage") ? CPUserDefaultsLocalStore : CPUserDefaultsCookieStore;
        self._stores = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        objj_msgSend(self, "setPersistentStoreClass:forDomain:reloadData:", defaultStore, CPGlobalDomain, YES);
        objj_msgSend(self, "setPersistentStoreClass:forDomain:reloadData:", defaultStore, CPApplicationDomain, YES);
    }
    return self;
}
,["id"]), new objj_method(sel_getUid("_setupArgumentsDomain"), function $CPUserDefaults___setupArgumentsDomain(self, _cmd)
{
    var args = objj_msgSend(CPApp, "namedArguments"),
        keys = objj_msgSend(args, "allKeys"),
        count = objj_msgSend(keys, "count"),
        i = 0;
    for (; i < count; i++)
    {
        var key = keys[i];
        objj_msgSend(self, "setObject:forKey:inDomain:", objj_msgSend(args, "objectForKey:", key), key, CPArgumentDomain);
    }
}
,["void"]), new objj_method(sel_getUid("objectForKey:"), function $CPUserDefaults__objectForKey_(self, _cmd, aKey)
{
    if (self._searchListNeedsReload)
        objj_msgSend(self, "_reloadSearchList");
    return objj_msgSend(self._searchList, "objectForKey:", aKey);
}
,["id","CPString"]), new objj_method(sel_getUid("setObject:forKey:"), function $CPUserDefaults__setObject_forKey_(self, _cmd, anObject, aKey)
{
    objj_msgSend(self, "setObject:forKey:inDomain:", anObject, aKey, CPApplicationDomain);
}
,["void","id","CPString"]), new objj_method(sel_getUid("objectForKey:inDomain:"), function $CPUserDefaults__objectForKey_inDomain_(self, _cmd, aKey, aDomain)
{
    var domain = objj_msgSend(self._domains, "objectForKey:", aDomain);
    if (!domain)
        return nil;
    return objj_msgSend(domain, "objectForKey:", aKey);
}
,["id","CPString","CPString"]), new objj_method(sel_getUid("setObject:forKey:inDomain:"), function $CPUserDefaults__setObject_forKey_inDomain_(self, _cmd, anObject, aKey, aDomain)
{
    if (!aKey || !aDomain)
        return;
    var domain = objj_msgSend(self._domains, "objectForKey:", aDomain);
    if (!domain)
    {
        domain = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        objj_msgSend(self._domains, "setObject:forKey:", domain, aDomain);
    }
    objj_msgSend(domain, "setObject:forKey:", anObject, aKey);
    self._searchListNeedsReload = YES;
    objj_msgSend(self, "domainDidChange:", aDomain);
}
,["void","id","CPString","CPString"]), new objj_method(sel_getUid("removeObjectForKey:"), function $CPUserDefaults__removeObjectForKey_(self, _cmd, aKey)
{
    objj_msgSend(self, "removeObjectForKey:inDomain:", aKey, CPApplicationDomain);
}
,["void","CPString"]), new objj_method(sel_getUid("removeObjectForKey:inDomain:"), function $CPUserDefaults__removeObjectForKey_inDomain_(self, _cmd, aKey, aDomain)
{
    if (!aKey || !aDomain)
        return;
    var domain = objj_msgSend(self._domains, "objectForKey:", aDomain);
    if (!domain)
        return;
    objj_msgSend(domain, "removeObjectForKey:", aKey);
    self._searchListNeedsReload = YES;
    objj_msgSend(self, "domainDidChange:", aDomain);
}
,["void","CPString","CPString"]), new objj_method(sel_getUid("registerDefaults:"), function $CPUserDefaults__registerDefaults_(self, _cmd, aDictionary)
{
    var keys = objj_msgSend(aDictionary, "allKeys"),
        count = objj_msgSend(keys, "count"),
        i = 0;
    for (; i < count; i++)
    {
        var key = keys[i];
        objj_msgSend(self, "setObject:forKey:inDomain:", objj_msgSend(aDictionary, "objectForKey:", key), key, CPRegistrationDomain);
    }
}
,["void","CPDictionary"]), new objj_method(sel_getUid("registerDefaultsFromContentsOfFile:"), function $CPUserDefaults__registerDefaultsFromContentsOfFile_(self, _cmd, aURL)
{
    var contents = objj_msgSend(CPURLConnection, "sendSynchronousRequest:returningResponse:", objj_msgSend(CPURLRequest, "requestWithURL:", aURL), nil),
        data = objj_msgSend(CPData, "dataWithRawString:", objj_msgSend(contents, "rawString")),
        plist = objj_msgSend(data, "plistObject");
    objj_msgSend(self, "registerDefaults:", plist);
}
,["void","CPURL"]), new objj_method(sel_getUid("_reloadSearchList"), function $CPUserDefaults___reloadSearchList(self, _cmd)
{
    self._searchListNeedsReload = NO;
    var dicts = [CPRegistrationDomain, CPGlobalDomain, CPApplicationDomain, CPArgumentDomain],
        count = objj_msgSend(dicts, "count"),
        i = 0;
    self._searchList = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    for (; i < count; i++)
    {
        var domain = objj_msgSend(self._domains, "objectForKey:", dicts[i]);
        if (!domain)
            continue;
        var keys = objj_msgSend(domain, "allKeys"),
            keysCount = objj_msgSend(keys, "count"),
            j = 0;
        for (; j < keysCount; j++)
        {
            var key = keys[j];
            objj_msgSend(self._searchList, "setObject:forKey:", objj_msgSend(domain, "objectForKey:", key), key);
        }
    }
}
,["void"]), new objj_method(sel_getUid("volatileDomainNames"), function $CPUserDefaults__volatileDomainNames(self, _cmd)
{
    return [CPArgumentDomain, CPLocaleDomain, CPRegistrationDomain];
}
,["CPArray"]), new objj_method(sel_getUid("persistentDomainNames"), function $CPUserDefaults__persistentDomainNames(self, _cmd)
{
    return [CPGlobalDomain, CPApplicationDomain];
}
,["CPArray"]), new objj_method(sel_getUid("persistentStoreForDomain:"), function $CPUserDefaults__persistentStoreForDomain_(self, _cmd, aDomain)
{
    return objj_msgSend(self._stores, "objectForKey:", aDomain);
}
,["CPUserDefaultsStore","CPString"]), new objj_method(sel_getUid("setPersistentStoreClass:forDomain:reloadData:"), function $CPUserDefaults__setPersistentStoreClass_forDomain_reloadData_(self, _cmd, aStoreClass, aDomain, aFlag)
{
    var currentStore = objj_msgSend(self._stores, "objectForKey:", aDomain);
    if (currentStore && objj_msgSend(currentStore, "class") === aStoreClass)
        return currentStore;
    var store = objj_msgSend(objj_msgSend(aStoreClass, "alloc"), "init");
    objj_msgSend(store, "setDomain:", aDomain);
    objj_msgSend(self._stores, "setObject:forKey:", store, aDomain);
    if (aFlag)
        objj_msgSend(self, "reloadDataFromStoreForDomain:", aDomain);
    return store;
}
,["CPUserDefaultsStore","Class","CPString","BOOL"]), new objj_method(sel_getUid("reloadDataFromStoreForDomain:"), function $CPUserDefaults__reloadDataFromStoreForDomain_(self, _cmd, aDomain)
{
    var data = objj_msgSend(objj_msgSend(self, "persistentStoreForDomain:", aDomain), "data"),
        domain = data ? objj_msgSend(CPKeyedUnarchiver, "unarchiveObjectWithData:", data) : nil;
    objj_msgSend(self._domains, "setObject:forKey:", domain, aDomain);
    self._searchListNeedsReload = YES;
}
,["void","CPString"]), new objj_method(sel_getUid("domainDidChange:"), function $CPUserDefaults__domainDidChange_(self, _cmd, aDomain)
{
    if (aDomain === CPGlobalDomain || aDomain === CPApplicationDomain)
        objj_msgSend(objj_msgSend(CPRunLoop, "currentRunLoop"), "performSelector:target:argument:order:modes:", sel_getUid("synchronize"), self, nil, 0, [CPDefaultRunLoopMode]);
    objj_msgSend(objj_msgSend(CPNotificationCenter, "defaultCenter"), "postNotificationName:object:", CPUserDefaultsDidChangeNotification, self);
}
,["void","CPString"]), new objj_method(sel_getUid("synchronize"), function $CPUserDefaults__synchronize(self, _cmd)
{
    var globalDomain = objj_msgSend(self._domains, "objectForKey:", CPGlobalDomain);
    if (globalDomain)
    {
        var data = objj_msgSend(CPKeyedArchiver, "archivedDataWithRootObject:", globalDomain);
        objj_msgSend(objj_msgSend(self, "persistentStoreForDomain:", CPGlobalDomain), "setData:", data);
    }
    var appDomain = objj_msgSend(self._domains, "objectForKey:", CPApplicationDomain);
    if (appDomain)
    {
        var data = objj_msgSend(CPKeyedArchiver, "archivedDataWithRootObject:", appDomain);
        objj_msgSend(objj_msgSend(self, "persistentStoreForDomain:", CPApplicationDomain), "setData:", data);
    }
}
,["void"]), new objj_method(sel_getUid("arrayForKey:"), function $CPUserDefaults__arrayForKey_(self, _cmd, aKey)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (objj_msgSend(value, "isKindOfClass:", CPArray))
        return value;
    return nil;
}
,["CPArray","CPString"]), new objj_method(sel_getUid("boolForKey:"), function $CPUserDefaults__boolForKey_(self, _cmd, aKey)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (objj_msgSend(value, "respondsToSelector:", sel_getUid("boolValue")))
        return objj_msgSend(value, "boolValue");
    return NO;
}
,["BOOL","CPString"]), new objj_method(sel_getUid("dataForKey:"), function $CPUserDefaults__dataForKey_(self, _cmd, aKey)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (objj_msgSend(value, "isKindOfClass:", CPData))
        return value;
    return nil;
}
,["CPData","CPString"]), new objj_method(sel_getUid("dictionaryForKey:"), function $CPUserDefaults__dictionaryForKey_(self, _cmd, aKey)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (objj_msgSend(value, "isKindOfClass:", CPDictionary))
        return value;
    return nil;
}
,["CPDictionary","CPString"]), new objj_method(sel_getUid("floatForKey:"), function $CPUserDefaults__floatForKey_(self, _cmd, aKey)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (value === nil)
        return 0;
    if (objj_msgSend(value, "respondsToSelector:", sel_getUid("floatValue")))
        value = objj_msgSend(value, "floatValue");
    return parseFloat(value);
}
,["float","CPString"]), new objj_method(sel_getUid("integerForKey:"), function $CPUserDefaults__integerForKey_(self, _cmd, aKey)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (value === nil)
        return 0;
    if (objj_msgSend(value, "respondsToSelector:", sel_getUid("intValue")))
        value = objj_msgSend(value, "intValue");
    return parseInt(value);
}
,["int","CPString"]), new objj_method(sel_getUid("doubleForKey:"), function $CPUserDefaults__doubleForKey_(self, _cmd, aKey)
{
    return objj_msgSend(self, "floatForKey:", aKey);
}
,["double","CPString"]), new objj_method(sel_getUid("stringForKey:"), function $CPUserDefaults__stringForKey_(self, _cmd, aKey)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (objj_msgSend(value, "isKindOfClass:", CPString))
        return value;
    else if (objj_msgSend(value, "respondsToSelector:", sel_getUid("stringValue")))
        return objj_msgSend(value, "stringValue");
    return nil;
}
,["CPString","CPString"]), new objj_method(sel_getUid("stringArrayForKey:"), function $CPUserDefaults__stringArrayForKey_(self, _cmd, aKey)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (!objj_msgSend(value, "isKindOfClass:", CPArray))
        return nil;
    for (var i = 0, count = objj_msgSend(value, "count"); i < count; i++)
        if (!objj_msgSend(value[i], "isKindOfClass:", CPString))
            return nil;
    return value;
}
,["CPArray","CPString"]), new objj_method(sel_getUid("URLForKey:"), function $CPUserDefaults__URLForKey_(self, _cmd, aKey)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (objj_msgSend(value, "isKindOfClass:", CPURL))
        return value;
    if (objj_msgSend(value, "isKindOfClass:", CPString))
        return objj_msgSend(CPURL, "URLWithString:", value);
    return nil;
}
,["CPURL","CPString"]), new objj_method(sel_getUid("setBool:forKey:"), function $CPUserDefaults__setBool_forKey_(self, _cmd, aValue, aKey)
{
    if (objj_msgSend(aValue, "respondsToSelector:", sel_getUid("boolValue")))
        objj_msgSend(self, "setObject:forKey:", objj_msgSend(aValue, "boolValue"), aKey);
}
,["void","BOOL","CPString"]), new objj_method(sel_getUid("setFloat:forKey:"), function $CPUserDefaults__setFloat_forKey_(self, _cmd, aValue, aKey)
{
    if (objj_msgSend(aValue, "respondsToSelector:", sel_getUid("aValue")))
        aValue = objj_msgSend(aValue, "floatValue");
    objj_msgSend(self, "setObject:forKey:", parseFloat(aValue), aKey);
}
,["void","float","CPString"]), new objj_method(sel_getUid("setDouble:forKey:"), function $CPUserDefaults__setDouble_forKey_(self, _cmd, aValue, aKey)
{
    objj_msgSend(self, "setFloat:forKey:", aValue, aKey);
}
,["void","double","CPString"]), new objj_method(sel_getUid("setInteger:forKey:"), function $CPUserDefaults__setInteger_forKey_(self, _cmd, aValue, aKey)
{
    if (objj_msgSend(aValue, "respondsToSelector:", sel_getUid("intValue")))
        aValue = objj_msgSend(aValue, "intValue");
    objj_msgSend(self, "setObject:forKey:", parseInt(aValue), aKey);
}
,["void","int","CPString"]), new objj_method(sel_getUid("setURL:forKey:"), function $CPUserDefaults__setURL_forKey_(self, _cmd, aValue, aKey)
{
    if (objj_msgSend(aValue, "isKindOfClass:", CPString))
        aValue = objj_msgSend(CPURL, "URLWithString:", aValue);
    objj_msgSend(self, "setObject:forKey:", aValue, aKey);
}
,["void","CPURL","CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("standardUserDefaults"), function $CPUserDefaults__standardUserDefaults(self, _cmd)
{
    if (!StandardUserDefaults)
        StandardUserDefaults = objj_msgSend(objj_msgSend(CPUserDefaults, "alloc"), "init");
    return StandardUserDefaults;
}
,["id"]), new objj_method(sel_getUid("resetStandardUserDefaults"), function $CPUserDefaults__resetStandardUserDefaults(self, _cmd)
{
    if (StandardUserDefaults)
        objj_msgSend(StandardUserDefaults, "synchronize");
    StandardUserDefaults = nil;
}
,["void"])]);
}
{var the_class = objj_allocateClassPair(CPObject, "CPUserDefaultsStore"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_domain")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("domain"), function $CPUserDefaultsStore__domain(self, _cmd)
{
return self._domain;
}
,["CPString"]), new objj_method(sel_getUid("setDomain:"), function $CPUserDefaultsStore__setDomain_(self, _cmd, newValue)
{
self._domain = newValue;
}
,["void","CPString"]), new objj_method(sel_getUid("data"), function $CPUserDefaultsStore__data(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["CPData"]), new objj_method(sel_getUid("setData:"), function $CPUserDefaultsStore__setData_(self, _cmd, aData)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["void","CPData"])]);
}
{var the_class = objj_allocateClassPair(CPUserDefaultsStore, "CPUserDefaultsCookieStore"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_cookie")]);

objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("setDomain:"), function $CPUserDefaultsCookieStore__setDomain_(self, _cmd, aDomain)
{
    if (self._domain === aDomain)
        return;
    self._domain = aDomain;
    self._cookie = objj_msgSend(objj_msgSend(CPCookie, "alloc"), "initWithName:", self._domain);
}
,["void","CPString"]), new objj_method(sel_getUid("data"), function $CPUserDefaultsCookieStore__data(self, _cmd)
{
    var result = objj_msgSend(self._cookie, "value");
    if (!result || objj_msgSend(result, "length") < 1)
        return nil;
    return objj_msgSend(CPData, "dataWithRawString:", decodeURIComponent(result));
}
,["CPData"]), new objj_method(sel_getUid("setData:"), function $CPUserDefaultsCookieStore__setData_(self, _cmd, aData)
{
    objj_msgSend(self._cookie, "setValue:expires:domain:", encodeURIComponent(objj_msgSend(aData, "rawString")), objj_msgSend(CPDate, "distantFuture"), window.location.href.hostname);
}
,["void","CPData"])]);
}
var CPUserDefaultsLocalStoreTestKey = "9961800812587769-Cappuccino-Storage-Test";
{var the_class = objj_allocateClassPair(CPUserDefaultsStore, "CPUserDefaultsLocalStore"),
meta_class = the_class.isa;


objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPUserDefaultsLocalStore__init(self, _cmd)
{
    if (!objj_msgSend(objj_msgSend(self, "class"), "supportsLocalStorage"))
    {
        objj_msgSend(CPException, "raise:reason:", "UnsupportedFeature", "Browser does not support localStorage for CPUserDefaultsLocalStore");
        return self = nil;
    }
    return self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPUserDefaultsLocalStore").super_class }, "init");
}
,["id"]), new objj_method(sel_getUid("data"), function $CPUserDefaultsLocalStore__data(self, _cmd)
{
    var result = localStorage.getItem(self._domain);
    if (!result || objj_msgSend(result, "length") < 1)
        return nil;
    return objj_msgSend(CPData, "dataWithRawString:", decodeURIComponent(result));
}
,["CPData"]), new objj_method(sel_getUid("setData:"), function $CPUserDefaultsLocalStore__setData_(self, _cmd, aData)
{
    try
    {
        localStorage.setItem(self._domain, encodeURIComponent(objj_msgSend(aData, "rawString")));
    }
    catch (e)
    {
        CPLog.warn("Unable to write to local storage: " + e);
    }
}
,["void","CPData"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("supportsLocalStorage"), function $CPUserDefaultsLocalStore__supportsLocalStorage(self, _cmd)
{
    if (!window.localStorage)
        return NO;
    try
    {
        localStorage.setItem(CPUserDefaultsLocalStoreTestKey, "1");
        if (localStorage.getItem(CPUserDefaultsLocalStoreTestKey) != "1")
            return NO;
        localStorage.removeItem(CPUserDefaultsLocalStoreTestKey);
    }
    catch (e)
    {
        return NO;
    }
    return YES;
}
,["BOOL"])]);
}p;22;CPUserSessionManager.jt;2675;@STATIC;1.0;i;22;CPNotificationCenter.ji;10;CPObject.ji;10;CPString.jt;2599;objj_executeFile("CPNotificationCenter.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
CPUserSessionUndeterminedStatus = 0;
CPUserSessionLoggedInStatus = 1;
CPUserSessionLoggedOutStatus = 2;
CPUserSessionManagerStatusDidChangeNotification = "CPUserSessionManagerStatusDidChangeNotification";
CPUserSessionManagerUserIdentifierDidChangeNotification = "CPUserSessionManagerUserIdentifierDidChangeNotification";
var CPDefaultUserSessionManager = nil;
{var the_class = objj_allocateClassPair(CPObject, "CPUserSessionManager"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_status"), new objj_ivar("_userIdentifier")]);




objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPUserSessionManager__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPUserSessionManager").super_class }, "init");
    if (self)
        self._status = CPUserSessionUndeterminedStatus;
    return self;
}
,["id"]), new objj_method(sel_getUid("status"), function $CPUserSessionManager__status(self, _cmd)
{
    return self._status;
}
,["CPUserSessionStatus"]), new objj_method(sel_getUid("setStatus:"), function $CPUserSessionManager__setStatus_(self, _cmd, aStatus)
{
    if (self._status == aStatus)
        return;
    self._status = aStatus;
    objj_msgSend(objj_msgSend(CPNotificationCenter, "defaultCenter"), "postNotificationName:object:", CPUserSessionManagerStatusDidChangeNotification, self);
    if (self._status != CPUserSessionLoggedInStatus)
        objj_msgSend(self, "setUserIdentifier:", nil);
}
,["void","CPUserSessionStatus"]), new objj_method(sel_getUid("userIdentifier"), function $CPUserSessionManager__userIdentifier(self, _cmd)
{
    return self._userIdentifier;
}
,["CPString"]), new objj_method(sel_getUid("setUserIdentifier:"), function $CPUserSessionManager__setUserIdentifier_(self, _cmd, anIdentifier)
{
    if (self._userIdentifier == anIdentifier)
        return;
    self._userIdentifier = anIdentifier;
    objj_msgSend(objj_msgSend(CPNotificationCenter, "defaultCenter"), "postNotificationName:object:", CPUserSessionManagerUserIdentifierDidChangeNotification, self);
}
,["void","CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("defaultManager"), function $CPUserSessionManager__defaultManager(self, _cmd)
{
    if (!CPDefaultUserSessionManager)
        CPDefaultUserSessionManager = objj_msgSend(objj_msgSend(CPUserSessionManager, "alloc"), "init");
    return CPDefaultUserSessionManager;
}
,["id"])]);
}p;9;CPValue.jt;2225;@STATIC;1.0;i;9;CPCoder.ji;10;CPObject.jt;2178;objj_executeFile("CPCoder.j", YES);
objj_executeFile("CPObject.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "CPValue"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_JSObject")]);

objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithJSObject:"), function $CPValue__initWithJSObject_(self, _cmd, aJSObject)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPValue").super_class }, "init");
    if (self)
        self._JSObject = aJSObject;
    return self;
}
,["id","JSObject"]), new objj_method(sel_getUid("JSObject"), function $CPValue__JSObject(self, _cmd)
{
    return self._JSObject;
}
,["JSObject"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("valueWithJSObject:"), function $CPValue__valueWithJSObject_(self, _cmd, aJSObject)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithJSObject:", aJSObject);
}
,["id","JSObject"])]);
}
var CPValueValueKey = "CPValueValueKey";
{
var the_class = objj_getClass("CPValue")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPValue\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPValue__initWithCoder_(self, _cmd, aCoder)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPValue").super_class }, "init");
    if (self)
        self._JSObject = JSON.parse(objj_msgSend(aCoder, "decodeObjectForKey:", CPValueValueKey));
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPValue__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeObject:forKey:", JSON.stringify(self._JSObject), CPValueValueKey);
}
,["void","CPCoder"])]);
}
CPJSObjectCreateJSON = function(aJSObject)
{
    CPLog.warn("CPJSObjectCreateJSON deprecated, use JSON.stringify() or CPString's objectFromJSON");
    return JSON.stringify(aJSObject);
}
CPJSObjectCreateWithJSON = function(aString)
{
    CPLog.warn("CPJSObjectCreateWithJSON deprecated, use JSON.parse() or CPString's JSONFromObject");
    return JSON.parse(aString);
}p;20;CPValueTransformer.jt;6941;@STATIC;1.0;i;8;CPData.ji;14;CPDictionary.ji;13;CPException.ji;17;CPKeyedArchiver.ji;19;CPKeyedUnarchiver.ji;10;CPNumber.ji;10;CPObject.jt;6797;objj_executeFile("CPData.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPKeyedArchiver.j", YES);
objj_executeFile("CPKeyedUnarchiver.j", YES);
objj_executeFile("CPNumber.j", YES);
objj_executeFile("CPObject.j", YES);
var transformerMap = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
{var the_class = objj_allocateClassPair(CPObject, "CPValueTransformer"),
meta_class = the_class.isa;






objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("reverseTransformedValue:"), function $CPValueTransformer__reverseTransformedValue_(self, _cmd, aValue)
{
    if (!objj_msgSend(objj_msgSend(self, "class"), "allowsReverseTransformation"))
    {
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, (self + " is not reversible."));
    }
    return objj_msgSend(self, "transformedValue:", aValue);
}
,["id","id"]), new objj_method(sel_getUid("transformedValue:"), function $CPValueTransformer__transformedValue_(self, _cmd, aValue)
{
    return nil;
}
,["id","id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("initialize"), function $CPValueTransformer__initialize(self, _cmd)
{
    if (self !== objj_msgSend(CPValueTransformer, "class"))
        return;
}
,["void"]), new objj_method(sel_getUid("setValueTransformer:forName:"), function $CPValueTransformer__setValueTransformer_forName_(self, _cmd, transformer, aName)
{
    objj_msgSend(transformerMap, "setObject:forKey:", transformer, aName);
}
,["void","CPValueTransformer","CPString"]), new objj_method(sel_getUid("valueTransformerForName:"), function $CPValueTransformer__valueTransformerForName_(self, _cmd, aName)
{
    return objj_msgSend(transformerMap, "objectForKey:", aName);
}
,["CPValueTransformer","CPString"]), new objj_method(sel_getUid("valueTransformerNames"), function $CPValueTransformer__valueTransformerNames(self, _cmd)
{
    return objj_msgSend(transformerMap, "allKeys");
}
,["CPArray"]), new objj_method(sel_getUid("allowsReverseTransformation"), function $CPValueTransformer__allowsReverseTransformation(self, _cmd)
{
  return NO;
}
,["BOOL"]), new objj_method(sel_getUid("transformedValueClass"), function $CPValueTransformer__transformedValueClass(self, _cmd)
{
    return objj_msgSend(CPObject, "class");
}
,["Class"])]);
}
{var the_class = objj_allocateClassPair(CPValueTransformer, "CPNegateBooleanTransformer"),
meta_class = the_class.isa;


objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("reverseTransformedValue:"), function $CPNegateBooleanTransformer__reverseTransformedValue_(self, _cmd, aValue)
{
    return !objj_msgSend(aValue, "boolValue");
}
,["id","id"]), new objj_method(sel_getUid("transformedValue:"), function $CPNegateBooleanTransformer__transformedValue_(self, _cmd, aValue)
{
    return !objj_msgSend(aValue, "boolValue");
}
,["id","id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("allowsReverseTransformation"), function $CPNegateBooleanTransformer__allowsReverseTransformation(self, _cmd)
{
    return YES;
}
,["BOOL"]), new objj_method(sel_getUid("transformedValueClass"), function $CPNegateBooleanTransformer__transformedValueClass(self, _cmd)
{
    return objj_msgSend(CPNumber, "class");
}
,["Class"])]);
}
{var the_class = objj_allocateClassPair(CPValueTransformer, "CPIsNilTransformer"),
meta_class = the_class.isa;

objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("transformedValue:"), function $CPIsNilTransformer__transformedValue_(self, _cmd, aValue)
{
    return aValue === nil || aValue === undefined;
}
,["id","id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("allowsReverseTransformation"), function $CPIsNilTransformer__allowsReverseTransformation(self, _cmd)
{
    return NO;
}
,["BOOL"]), new objj_method(sel_getUid("transformedValueClass"), function $CPIsNilTransformer__transformedValueClass(self, _cmd)
{
    return objj_msgSend(CPNumber, "class");
}
,["Class"])]);
}
{var the_class = objj_allocateClassPair(CPValueTransformer, "CPIsNotNilTransformer"),
meta_class = the_class.isa;

objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("transformedValue:"), function $CPIsNotNilTransformer__transformedValue_(self, _cmd, aValue)
{
    return aValue !== nil && aValue !== undefined;
}
,["id","id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("allowsReverseTransformation"), function $CPIsNotNilTransformer__allowsReverseTransformation(self, _cmd)
{
    return NO;
}
,["BOOL"]), new objj_method(sel_getUid("transformedValueClass"), function $CPIsNotNilTransformer__transformedValueClass(self, _cmd)
{
    return objj_msgSend(CPNumber, "class");
}
,["Class"])]);
}
{var the_class = objj_allocateClassPair(CPValueTransformer, "CPUnarchiveFromDataTransformer"),
meta_class = the_class.isa;


objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("reverseTransformedValue:"), function $CPUnarchiveFromDataTransformer__reverseTransformedValue_(self, _cmd, aValue)
{
    return objj_msgSend(CPKeyedArchiver, "archivedDataWithRootObject:", aValue);
}
,["id","id"]), new objj_method(sel_getUid("transformedValue:"), function $CPUnarchiveFromDataTransformer__transformedValue_(self, _cmd, aValue)
{
    return objj_msgSend(CPKeyedUnarchiver, "unarchiveObjectWithData:", aValue);
}
,["id","id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("allowsReverseTransformation"), function $CPUnarchiveFromDataTransformer__allowsReverseTransformation(self, _cmd)
{
    return YES;
}
,["BOOL"]), new objj_method(sel_getUid("transformedValueClass"), function $CPUnarchiveFromDataTransformer__transformedValueClass(self, _cmd)
{
    return objj_msgSend(CPData, "class");
}
,["Class"])]);
}
CPNegateBooleanTransformerName = "CPNegateBoolean";
CPIsNilTransformerName = "CPIsNil";
CPIsNotNilTransformerName = "CPIsNotNil";
CPUnarchiveFromDataTransformerName = "CPUnarchiveFromData";
CPKeyedUnarchiveFromDataTransformerName = "CPKeyedUnarchiveFromData";
objj_msgSend(CPValueTransformer, "setValueTransformer:forName:", objj_msgSend(objj_msgSend(CPNegateBooleanTransformer, "alloc"), "init"), CPNegateBooleanTransformerName);
objj_msgSend(CPValueTransformer, "setValueTransformer:forName:", objj_msgSend(objj_msgSend(CPIsNilTransformer, "alloc"), "init"), CPIsNilTransformerName);
objj_msgSend(CPValueTransformer, "setValueTransformer:forName:", objj_msgSend(objj_msgSend(CPIsNotNilTransformer, "alloc"), "init"), CPIsNotNilTransformerName);
objj_msgSend(CPValueTransformer, "setValueTransformer:forName:", objj_msgSend(objj_msgSend(CPUnarchiveFromDataTransformer, "alloc"), "init"), CPUnarchiveFromDataTransformerName);p;17;CPWebDAVManager.jt;7447;@STATIC;1.0;i;9;CPArray.ji;14;CPDictionary.ji;10;CPObject.ji;10;CPString.ji;7;CPURL.ji;17;CPURLConnection.ji;14;CPURLRequest.jt;7314;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("CPURL.j", YES);
objj_executeFile("CPURLConnection.j", YES);
objj_executeFile("CPURLRequest.j", YES);
var setURLResourceValuesForKeysFromProperties = function(aURL, keys, properties)
{
    var resourceType = objj_msgSend(properties, "objectForKey:", "resourcetype");
    if (resourceType === CPWebDAVManagerCollectionResourceType)
    {
        objj_msgSend(aURL, "setResourceValue:forKey:", YES, CPURLIsDirectoryKey);
        objj_msgSend(aURL, "setResourceValue:forKey:", NO, CPURLIsRegularFileKey);
    }
    else if (resourceType === CPWebDAVManagerNonCollectionResourceType)
    {
        objj_msgSend(aURL, "setResourceValue:forKey:", NO, CPURLIsDirectoryKey);
        objj_msgSend(aURL, "setResourceValue:forKey:", YES, CPURLIsRegularFileKey);
    }
    var displayName = objj_msgSend(properties, "objectForKey:", "displayname");
    if (displayName !== nil)
    {
        objj_msgSend(aURL, "setResourceValue:forKey:", displayName, CPURLNameKey);
        objj_msgSend(aURL, "setResourceValue:forKey:", displayName, CPURLLocalizedNameKey);
    }
};
CPWebDAVManagerCollectionResourceType = 1;
CPWebDAVManagerNonCollectionResourceType = 0;
{var the_class = objj_allocateClassPair(CPObject, "CPWebDAVManager"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_blocksForConnections")]);


objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPWebDAVManager__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPWebDAVManager").super_class }, "init");
    if (self)
        self._blocksForConnections = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    return self;
}
,["id"]), new objj_method(sel_getUid("contentsOfDirectoryAtURL:includingPropertiesForKeys:options:block:"), function $CPWebDAVManager__contentsOfDirectoryAtURL_includingPropertiesForKeys_options_block_(self, _cmd, aURL, keys, aMask, aBlock)
{
    var properties = [],
        count = objj_msgSend(keys, "count");
    while (count--)
        properties.push(WebDAVPropertiesForURLKeys[keys[count]]);
    var makeContents = function(aURL, response)
    {
        var contents = [],
            URLString = nil,
            URLStrings = objj_msgSend(response, "keyEnumerator");
        while ((URLString = objj_msgSend(URLStrings, "nextObject")) !== nil)
        {
            var URL = objj_msgSend(CPURL, "URLWithString:", URLString),
                properties = objj_msgSend(response, "objectForKey:", URLString);
            if (!objj_msgSend(objj_msgSend(URL, "absoluteString"), "isEqual:", objj_msgSend(aURL, "absoluteString")))
            {
                contents.push(URL);
                setURLResourceValuesForKeysFromProperties(URL, keys, properties);
            }
        }
        return contents;
    };
    if (!aBlock)
        return makeContents(aURL, objj_msgSend(self, "PROPFIND:properties:depth:block:", aURL, properties, 1, nil));
    objj_msgSend(self, "PROPFIND:properties:depth:block:", aURL, properties, 1, function(aURL, response)
    {
        aBlock(aURL, makeContents(aURL, response));
    });
}
,["CPArray","CPURL","CPArray","CPDirectoryEnumerationOptions","Function"]), new objj_method(sel_getUid("PROPFIND:properties:depth:block:"), function $CPWebDAVManager__PROPFIND_properties_depth_block_(self, _cmd, aURL, properties, aDepth, aBlock)
{
    var request = objj_msgSend(CPURLRequest, "requestWithURL:", aURL);
    objj_msgSend(request, "setHTTPMethod:", "PROPFIND");
    objj_msgSend(request, "setValue:forHTTPHeaderField:", aDepth, "Depth");
    var HTTPBody = ["<?xml version=\"1.0\"?><a:propfind xmlns:a=\"DAV:\">"],
        index = 0,
        count = properties.length;
    for (; index < count; ++index)
        HTTPBody.push("<a:prop><a:", properties[index], "/></a:prop>");
    HTTPBody.push("</a:propfind>");
    objj_msgSend(request, "setHTTPBody:", HTTPBody.join(""));
    if (!aBlock)
        return parsePROPFINDResponse(objj_msgSend(objj_msgSend(CPURLConnection, "sendSynchronousRequest:returningResponse:", request, nil), "rawString"));
    else
    {
        var connection = objj_msgSend(CPURLConnection, "connectionWithRequest:delegate:", request, self);
        objj_msgSend(self._blocksForConnections, "setObject:forKey:", aBlock, objj_msgSend(connection, "UID"));
    }
}
,["CPDictionary","CPURL","CPDictionary","CPString","Function"]), new objj_method(sel_getUid("connection:didReceiveData:"), function $CPWebDAVManager__connection_didReceiveData_(self, _cmd, aURLConnection, aString)
{
    var block = objj_msgSend(self._blocksForConnections, "objectForKey:", objj_msgSend(aURLConnection, "UID"));
    block(objj_msgSend(aURLConnection._request, "URL"), parsePROPFINDResponse(aString));
}
,["void","CPURLConnection","CPString"])]);
}
var WebDAVPropertiesForURLKeys = { };
WebDAVPropertiesForURLKeys[CPURLNameKey] = "displayname";
WebDAVPropertiesForURLKeys[CPURLLocalizedNameKey] = "displayname";
WebDAVPropertiesForURLKeys[CPURLIsRegularFileKey] = "resourcetype";
WebDAVPropertiesForURLKeys[CPURLIsDirectoryKey] = "resourcetype";
var XMLDocumentFromString = function(anXMLString)
{
    if (typeof window["ActiveXObject"] !== "undefined")
    {
        var XMLDocument = new ActiveXObject("Microsoft.XMLDOM");
        XMLDocument.async = false;
        XMLDocument.loadXML(anXMLString);
        return XMLDocument;
    }
    return new DOMParser().parseFromString(anXMLString,"text/xml");
};
var parsePROPFINDResponse = function(anXMLString)
{
    var XMLDocument = XMLDocumentFromString(anXMLString),
        responses = XMLDocument.getElementsByTagNameNS("*", "response"),
        responseIndex = 0,
        responseCount = responses.length,
        propertiesForURLs = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
    for (; responseIndex < responseCount; ++responseIndex)
    {
        var response = responses[responseIndex],
            elements = response.getElementsByTagNameNS("*", "prop").item(0).childNodes,
            index = 0,
            count = elements.length,
            properties = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "init");
        for (; index < count; ++index)
        {
            var element = elements[index];
            if (element.nodeType === 8 || element.nodeType === 3)
                continue;
            var nodeName = element.nodeName,
                colonIndex = nodeName.lastIndexOf(':');
            if (colonIndex > -1)
                nodeName = nodeName.substr(colonIndex + 1);
            if (nodeName === "resourcetype")
                objj_msgSend(properties, "setObject:forKey:", element.firstChild ? CPWebDAVManagerCollectionResourceType : CPWebDAVManagerNonCollectionResourceType, nodeName);
            else
                objj_msgSend(properties, "setObject:forKey:", element.firstChild.nodeValue, nodeName);
        }
        var href = response.getElementsByTagNameNS("*", "href").item(0);
        objj_msgSend(propertiesForURLs, "setObject:forKey:", properties, href.firstChild.nodeValue);
    }
    return propertiesForURLs;
};
var mapURLsAndProperties = function( properties, ignoredURL)
{
};p;12;Foundation.jt;3413;@STATIC;1.0;i;13;_CGGeometry.ji;9;CPArray.ji;10;CPBundle.ji;22;CPByteCountFormatter.ji;16;CPCharacterSet.ji;9;CPCoder.ji;23;CPComparisonPredicate.ji;21;CPCompoundPredicate.ji;8;CPData.ji;8;CPDate.ji;17;CPDateFormatter.ji;11;CPDecimal.ji;17;CPDecimalNumber.ji;14;CPDictionary.ji;14;CPEnumerator.ji;9;CPError.ji;13;CPException.ji;14;CPExpression.ji;13;CPFormatter.ji;12;CPIndexSet.ji;13;CPIndexPath.ji;14;CPInvocation.ji;19;CPJSONPConnection.ji;17;CPKeyedArchiver.ji;19;CPKeyedUnarchiver.ji;18;CPKeyValueCoding.ji;21;CPKeyValueObserving.ji;16;CPMutableArray.ji;14;CPMutableSet.ji;16;CPNotification.ji;22;CPNotificationCenter.ji;8;CPNull.ji;10;CPNumber.ji;19;CPNumberFormatter.ji;10;CPObject.ji;15;CPObjJRuntime.ji;13;CPOperation.ji;18;CPOperationQueue.ji;13;CPPredicate.ji;29;CPPropertyListSerialization.ji;9;CPRange.ji;11;CPRunLoop.ji;11;CPScanner.ji;7;CPSet.ji;18;CPSortDescriptor.ji;10;CPString.ji;9;CPTimer.ji;15;CPUndoManager.ji;7;CPURL.ji;17;CPURLConnection.ji;14;CPURLRequest.ji;15;CPURLResponse.ji;16;CPUserDefaults.ji;22;CPUserSessionManager.ji;9;CPValue.ji;20;CPValueTransformer.jt;2318;objj_executeFile("_CGGeometry.j", YES);
objj_executeFile("CPArray.j", YES);
objj_executeFile("CPBundle.j", YES);
objj_executeFile("CPByteCountFormatter.j", YES);
objj_executeFile("CPCharacterSet.j", YES);
objj_executeFile("CPCoder.j", YES);
objj_executeFile("CPComparisonPredicate.j", YES);
objj_executeFile("CPCompoundPredicate.j", YES);
objj_executeFile("CPData.j", YES);
objj_executeFile("CPDate.j", YES);
objj_executeFile("CPDateFormatter.j", YES);
objj_executeFile("CPDecimal.j", YES);
objj_executeFile("CPDecimalNumber.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPEnumerator.j", YES);
objj_executeFile("CPError.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPExpression.j", YES);
objj_executeFile("CPFormatter.j", YES);
objj_executeFile("CPIndexSet.j", YES);
objj_executeFile("CPIndexPath.j", YES);
objj_executeFile("CPInvocation.j", YES);
objj_executeFile("CPJSONPConnection.j", YES);
objj_executeFile("CPKeyedArchiver.j", YES);
objj_executeFile("CPKeyedUnarchiver.j", YES);
objj_executeFile("CPKeyValueCoding.j", YES);
objj_executeFile("CPKeyValueObserving.j", YES);
objj_executeFile("CPMutableArray.j", YES);
objj_executeFile("CPMutableSet.j", YES);
objj_executeFile("CPNotification.j", YES);
objj_executeFile("CPNotificationCenter.j", YES);
objj_executeFile("CPNull.j", YES);
objj_executeFile("CPNumber.j", YES);
objj_executeFile("CPNumberFormatter.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPObjJRuntime.j", YES);
objj_executeFile("CPOperation.j", YES);
objj_executeFile("CPOperationQueue.j", YES);
objj_executeFile("CPPredicate.j", YES);
objj_executeFile("CPPropertyListSerialization.j", YES);
objj_executeFile("CPRange.j", YES);
objj_executeFile("CPRunLoop.j", YES);
objj_executeFile("CPScanner.j", YES);
objj_executeFile("CPSet.j", YES);
objj_executeFile("CPSortDescriptor.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("CPTimer.j", YES);
objj_executeFile("CPUndoManager.j", YES);
objj_executeFile("CPURL.j", YES);
objj_executeFile("CPURLConnection.j", YES);
objj_executeFile("CPURLRequest.j", YES);
objj_executeFile("CPURLResponse.j", YES);
objj_executeFile("CPUserDefaults.j", YES);
objj_executeFile("CPUserSessionManager.j", YES);
objj_executeFile("CPValue.j", YES);
objj_executeFile("CPValueTransformer.j", YES);p;10;_CPArray.jt;25207;@STATIC;1.0;i;14;CPEnumerator.ji;13;CPException.ji;10;CPObject.ji;9;CPRange.ji;18;CPSortDescriptor.jt;25099;objj_executeFile("CPEnumerator.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPRange.j", YES);
objj_executeFile("CPSortDescriptor.j", YES);
//@class _CPJavaScriptArray
//@class CPIndexSet
CPEnumerationNormal = 0;
CPEnumerationConcurrent = 1 << 0;
CPEnumerationReverse = 1 << 1;
CPBinarySearchingFirstEqual = 1 << 8;
CPBinarySearchingLastEqual = 1 << 9;
CPBinarySearchingInsertionIndex = 1 << 10;
var concat = Array.prototype.concat,
    join = Array.prototype.join,
    push = Array.prototype.push;
{var the_class = objj_allocateClassPair(CPObject, "CPArray"),
meta_class = the_class.isa;




















































objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $CPArray__init(self, _cmd)
{
    if (self === _CPSharedPlaceholderArray) { arguments[0] = objj_msgSend(_CPJavaScriptArray, "alloc"); return objj_msgSend.apply(this, arguments); } return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPArray").super_class }, "init");;
}
,["id"]), new objj_method(sel_getUid("initWithArray:"), function $CPArray__initWithArray_(self, _cmd, anArray)
{
    if (self === _CPSharedPlaceholderArray) { arguments[0] = objj_msgSend(_CPJavaScriptArray, "alloc"); return objj_msgSend.apply(this, arguments); } return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPArray").super_class }, "init");;
}
,["id","CPArray"]), new objj_method(sel_getUid("initWithArray:copyItems:"), function $CPArray__initWithArray_copyItems_(self, _cmd, anArray, shouldCopyItems)
{
    if (self === _CPSharedPlaceholderArray) { arguments[0] = objj_msgSend(_CPJavaScriptArray, "alloc"); return objj_msgSend.apply(this, arguments); } return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPArray").super_class }, "init");;
}
,["id","CPArray","BOOL"]), new objj_method(sel_getUid("initWithObjects:"), function $CPArray__initWithObjects_(self, _cmd, anObject)
{
    if (self === _CPSharedPlaceholderArray) { arguments[0] = objj_msgSend(_CPJavaScriptArray, "alloc"); return objj_msgSend.apply(this, arguments); } return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPArray").super_class }, "init");;
}
,["id","id"]), new objj_method(sel_getUid("initWithObjects:count:"), function $CPArray__initWithObjects_count_(self, _cmd, objects, aCount)
{
    if (self === _CPSharedPlaceholderArray) { arguments[0] = objj_msgSend(_CPJavaScriptArray, "alloc"); return objj_msgSend.apply(this, arguments); } return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPArray").super_class }, "init");;
}
,["id","id","unsigned"]), new objj_method(sel_getUid("initWithCapacity:"), function $CPArray__initWithCapacity_(self, _cmd, aCapacity)
{
    if (self === _CPSharedPlaceholderArray) { arguments[0] = objj_msgSend(_CPJavaScriptArray, "alloc"); return objj_msgSend.apply(this, arguments); } return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPArray").super_class }, "init");;
}
,["id","unsigned"]), new objj_method(sel_getUid("containsObject:"), function $CPArray__containsObject_(self, _cmd, anObject)
{
    return objj_msgSend(self, "indexOfObject:", anObject) !== CPNotFound;
}
,["BOOL","id"]), new objj_method(sel_getUid("containsObjectIdenticalTo:"), function $CPArray__containsObjectIdenticalTo_(self, _cmd, anObject)
{
    return objj_msgSend(self, "indexOfObjectIdenticalTo:", anObject) !== CPNotFound;
}
,["BOOL","id"]), new objj_method(sel_getUid("count"), function $CPArray__count(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["int"]), new objj_method(sel_getUid("firstObject"), function $CPArray__firstObject(self, _cmd)
{
    var count = objj_msgSend(self, "count");
    if (count > 0)
        return objj_msgSend(self, "objectAtIndex:", 0);
    return nil;
}
,["id"]), new objj_method(sel_getUid("lastObject"), function $CPArray__lastObject(self, _cmd)
{
    var count = objj_msgSend(self, "count");
    if (count <= 0)
        return nil;
    return objj_msgSend(self, "objectAtIndex:", count - 1);
}
,["id"]), new objj_method(sel_getUid("objectAtIndex:"), function $CPArray__objectAtIndex_(self, _cmd, anIndex)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["id","int"]), new objj_method(sel_getUid("objectsAtIndexes:"), function $CPArray__objectsAtIndexes_(self, _cmd, indexes)
{
    var index = CPNotFound,
        objects = [];
    while ((index = objj_msgSend(indexes, "indexGreaterThanIndex:", index)) !== CPNotFound)
        objects.push(objj_msgSend(self, "objectAtIndex:", index));
    return objects;
}
,["CPArray","CPIndexSet"]), new objj_method(sel_getUid("objectEnumerator"), function $CPArray__objectEnumerator(self, _cmd)
{
    return objj_msgSend(objj_msgSend(_CPArrayEnumerator, "alloc"), "initWithArray:", self);
}
,["CPEnumerator"]), new objj_method(sel_getUid("reverseObjectEnumerator"), function $CPArray__reverseObjectEnumerator(self, _cmd)
{
    return objj_msgSend(objj_msgSend(_CPReverseArrayEnumerator, "alloc"), "initWithArray:", self);
}
,["CPEnumerator"]), new objj_method(sel_getUid("indexOfObject:"), function $CPArray__indexOfObject_(self, _cmd, anObject)
{
    return objj_msgSend(self, "indexOfObject:inRange:", anObject, nil);
}
,["CPUInteger","id"]), new objj_method(sel_getUid("indexOfObject:inRange:"), function $CPArray__indexOfObject_inRange_(self, _cmd, anObject, aRange)
{
    if (anObject && anObject.isa)
    {
        var index = aRange ? aRange.location : 0,
            count = aRange ? CPMaxRange(aRange) : objj_msgSend(self, "count");
        for (; index < count; ++index)
            if (objj_msgSend(objj_msgSend(self, "objectAtIndex:", index), "isEqual:", anObject))
                return index;
        return CPNotFound;
    }
    return objj_msgSend(self, "indexOfObjectIdenticalTo:inRange:", anObject, aRange);
}
,["CPUInteger","id","CPRange"]), new objj_method(sel_getUid("indexOfObjectIdenticalTo:"), function $CPArray__indexOfObjectIdenticalTo_(self, _cmd, anObject)
{
    return objj_msgSend(self, "indexOfObjectIdenticalTo:inRange:", anObject, nil);
}
,["CPUInteger","id"]), new objj_method(sel_getUid("indexOfObjectIdenticalTo:inRange:"), function $CPArray__indexOfObjectIdenticalTo_inRange_(self, _cmd, anObject, aRange)
{
    var index = aRange ? aRange.location : 0,
        count = aRange ? CPMaxRange(aRange) : objj_msgSend(self, "count");
    for (; index < count; ++index)
        if (objj_msgSend(self, "objectAtIndex:", index) === anObject)
            return index;
    return CPNotFound;
}
,["CPUInteger","id","CPRange"]), new objj_method(sel_getUid("indexOfObjectPassingTest:"), function $CPArray__indexOfObjectPassingTest_(self, _cmd, aPredicate)
{
    return objj_msgSend(self, "indexOfObjectWithOptions:passingTest:context:", CPEnumerationNormal, aPredicate, undefined);
}
,["unsigned","Function"]), new objj_method(sel_getUid("indexOfObjectPassingTest:context:"), function $CPArray__indexOfObjectPassingTest_context_(self, _cmd, aPredicate, aContext)
{
    return objj_msgSend(self, "indexOfObjectWithOptions:passingTest:context:", CPEnumerationNormal, aPredicate, aContext);
}
,["unsigned","Function","id"]), new objj_method(sel_getUid("indexOfObjectWithOptions:passingTest:"), function $CPArray__indexOfObjectWithOptions_passingTest_(self, _cmd, options, aPredicate)
{
    return objj_msgSend(self, "indexOfObjectWithOptions:passingTest:context:", options, aPredicate, undefined);
}
,["unsigned","CPEnumerationOptions","Function"]), new objj_method(sel_getUid("indexOfObjectWithOptions:passingTest:context:"), function $CPArray__indexOfObjectWithOptions_passingTest_context_(self, _cmd, options, aPredicate, aContext)
{
    if (options & CPEnumerationReverse)
    {
        var index = objj_msgSend(self, "count") - 1,
            stop = -1,
            increment = -1;
    }
    else
    {
        var index = 0,
            stop = objj_msgSend(self, "count"),
            increment = 1;
    }
    for (; index !== stop; index += increment)
        if (aPredicate(objj_msgSend(self, "objectAtIndex:", index), index, aContext))
            return index;
    return CPNotFound;
}
,["unsigned","CPEnumerationOptions","Function","id"]), new objj_method(sel_getUid("indexOfObject:inSortedRange:options:usingComparator:"), function $CPArray__indexOfObject_inSortedRange_options_usingComparator_(self, _cmd, anObject, aRange, options, aComparator)
{
    if (!aComparator)
        _CPRaiseInvalidArgumentException(self, _cmd, "comparator is nil");
    if ((options & CPBinarySearchingFirstEqual) && (options & CPBinarySearchingLastEqual))
        _CPRaiseInvalidArgumentException(self, _cmd,
            "both CPBinarySearchingFirstEqual and CPBinarySearchingLastEqual options cannot be specified");
    var count = objj_msgSend(self, "count");
    if (count <= 0)
        return (options & CPBinarySearchingInsertionIndex) ? 0 : CPNotFound;
    var first = aRange ? aRange.location : 0,
        last = (aRange ? CPMaxRange(aRange) : objj_msgSend(self, "count")) - 1;
    if (first < 0)
        _CPRaiseRangeException(self, _cmd, first, count);
    if (last >= count)
        _CPRaiseRangeException(self, _cmd, last, count);
    while (first <= last)
    {
        var middle = FLOOR((first + last) / 2),
            result = aComparator(anObject, objj_msgSend(self, "objectAtIndex:", middle));
        if (result > 0)
            first = middle + 1;
        else if (result < 0)
            last = middle - 1;
        else
        {
            if (options & CPBinarySearchingFirstEqual)
                while (middle > first && aComparator(anObject, objj_msgSend(self, "objectAtIndex:", middle - 1)) === CPOrderedSame)
                    --middle;
            else if (options & CPBinarySearchingLastEqual)
            {
                while (middle < last && aComparator(anObject, objj_msgSend(self, "objectAtIndex:", middle + 1)) === CPOrderedSame)
                    ++middle;
                if (options & CPBinarySearchingInsertionIndex)
                    ++middle;
            }
            return middle;
        }
    }
    if (options & CPBinarySearchingInsertionIndex)
        return MAX(first, 0);
    return CPNotFound;
}
,["CPUInteger","id","CPRange","CPBinarySearchingOptions","Function"]), new objj_method(sel_getUid("indexesOfObjectsPassingTest:"), function $CPArray__indexesOfObjectsPassingTest_(self, _cmd, aPredicate)
{
    return objj_msgSend(self, "indexesOfObjectsWithOptions:passingTest:context:", CPEnumerationNormal, aPredicate, undefined);
}
,["CPIndexSet","Function"]), new objj_method(sel_getUid("indexesOfObjectsPassingTest:context:"), function $CPArray__indexesOfObjectsPassingTest_context_(self, _cmd, aPredicate, aContext)
{
    return objj_msgSend(self, "indexesOfObjectsWithOptions:passingTest:context:", CPEnumerationNormal, aPredicate, aContext);
}
,["CPIndexSet","Function","id"]), new objj_method(sel_getUid("indexesOfObjectsWithOptions:passingTest:"), function $CPArray__indexesOfObjectsWithOptions_passingTest_(self, _cmd, options, aPredicate)
{
    return objj_msgSend(self, "indexesOfObjectsWithOptions:passingTest:context:", options, aPredicate, undefined);
}
,["CPIndexSet","CPEnumerationOptions","Function"]), new objj_method(sel_getUid("indexesOfObjectsWithOptions:passingTest:context:"), function $CPArray__indexesOfObjectsWithOptions_passingTest_context_(self, _cmd, options, aPredicate, aContext)
{
    if (options & CPEnumerationReverse)
    {
        var index = objj_msgSend(self, "count") - 1,
            stop = -1,
            increment = -1;
    }
    else
    {
        var index = 0,
            stop = objj_msgSend(self, "count"),
            increment = 1;
    }
    var indexes = objj_msgSend(CPIndexSet, "indexSet");
    for (; index !== stop; index += increment)
        if (aPredicate(objj_msgSend(self, "objectAtIndex:", index), index, aContext))
            objj_msgSend(indexes, "addIndex:", index);
    return indexes;
}
,["CPIndexSet","CPEnumerationOptions","Function","id"]), new objj_method(sel_getUid("makeObjectsPerformSelector:"), function $CPArray__makeObjectsPerformSelector_(self, _cmd, aSelector)
{
    objj_msgSend(self, "makeObjectsPerformSelector:withObjects:", aSelector, nil);
}
,["void","SEL"]), new objj_method(sel_getUid("makeObjectsPerformSelector:withObject:"), function $CPArray__makeObjectsPerformSelector_withObject_(self, _cmd, aSelector, anObject)
{
    return objj_msgSend(self, "makeObjectsPerformSelector:withObjects:", aSelector, [anObject]);
}
,["void","SEL","id"]), new objj_method(sel_getUid("makeObjectsPerformSelector:withObjects:"), function $CPArray__makeObjectsPerformSelector_withObjects_(self, _cmd, aSelector, objects)
{
    if (!aSelector)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "makeObjectsPerformSelector:withObjects: 'aSelector' can't be nil");
    var index = 0,
        count = objj_msgSend(self, "count");
    if (objj_msgSend(objects, "count"))
    {
        var argumentsArray = objj_msgSend([nil, aSelector], "arrayByAddingObjectsFromArray:", objects);
        for (; index < count; ++index)
        {
            argumentsArray[0] = objj_msgSend(self, "objectAtIndex:", index);
            objj_msgSend.apply(this, argumentsArray);
        }
    }
    else
        for (; index < count; ++index)
            objj_msgSend(objj_msgSend(self, "objectAtIndex:", index), aSelector);
}
,["void","SEL","CPArray"]), new objj_method(sel_getUid("enumerateObjectsUsingBlock:"), function $CPArray__enumerateObjectsUsingBlock_(self, _cmd, aFunction)
{
    var index = 0,
        count = objj_msgSend(self, "count"),
        shouldStop = NO,
        shouldStopRef = function(__input) { if (arguments.length) return shouldStop = __input; return shouldStop; };
    for (; index < count; ++index)
    {
        aFunction(objj_msgSend(self, "objectAtIndex:", index), index, shouldStopRef);
        if (shouldStop)
            return;
    }
}
,["void","Function"]), new objj_method(sel_getUid("enumerateObjectsWithOptions:usingBlock:"), function $CPArray__enumerateObjectsWithOptions_usingBlock_(self, _cmd, options, aFunction)
{
    var shouldStop = NO;
    if (options & CPEnumerationReverse)
    {
        var index = objj_msgSend(self, "count") - 1,
            stop = -1,
            increment = -1;
    }
    else
    {
        var index = 0,
            stop = objj_msgSend(self, "count"),
            increment = 1;
    }
    for (; index !== stop; index += increment)
    {
        aFunction(objj_msgSend(self, "objectAtIndex:", index), index, function(__input) { if (arguments.length) return shouldStop = __input; return shouldStop; });
        if (shouldStop)
            return;
    }
}
,["void","CPEnumerationOptions","Function"]), new objj_method(sel_getUid("firstObjectCommonWithArray:"), function $CPArray__firstObjectCommonWithArray_(self, _cmd, anArray)
{
    var count = objj_msgSend(self, "count");
    if (!objj_msgSend(anArray, "count") || !count)
        return nil;
    var index = 0;
    for (; index < count; ++index)
    {
        var object = objj_msgSend(self, "objectAtIndex:", index);
        if (objj_msgSend(anArray, "containsObject:", object))
            return object;
    }
    return nil;
}
,["id","CPArray"]), new objj_method(sel_getUid("isEqualToArray:"), function $CPArray__isEqualToArray_(self, _cmd, anArray)
{
    if (self === anArray)
        return YES;
    if (!objj_msgSend(anArray, "isKindOfClass:", CPArray))
        return NO;
    var count = objj_msgSend(self, "count"),
        otherCount = objj_msgSend(anArray, "count");
    if (anArray === nil || count !== otherCount)
        return NO;
    var index = 0;
    for (; index < count; ++index)
    {
        var lhs = objj_msgSend(self, "objectAtIndex:", index),
            rhs = objj_msgSend(anArray, "objectAtIndex:", index);
        if (lhs !== rhs && (lhs && !lhs.isa || rhs && !rhs.isa || !objj_msgSend(lhs, "isEqual:", rhs)))
            return NO;
    }
    return YES;
}
,["BOOL","id"]), new objj_method(sel_getUid("isEqual:"), function $CPArray__isEqual_(self, _cmd, anObject)
{
    return (self === anObject) || objj_msgSend(self, "isEqualToArray:", anObject);
}
,["BOOL","id"]), new objj_method(sel_getUid("_javaScriptArrayCopy"), function $CPArray___javaScriptArrayCopy(self, _cmd)
{
    var index = 0,
        count = objj_msgSend(self, "count"),
        copy = [];
    for (; index < count; ++index)
        push.call(copy, objj_msgSend(self, "objectAtIndex:", index));
    return copy;
}
,["Array"]), new objj_method(sel_getUid("arrayByAddingObject:"), function $CPArray__arrayByAddingObject_(self, _cmd, anObject)
{
    var argumentArray = objj_msgSend(self, "_javaScriptArrayCopy");
    push.call(argumentArray, anObject);
    return objj_msgSend(objj_msgSend(self, "class"), sel_getUid("arrayWithArray:"), argumentArray);
}
,["CPArray","id"]), new objj_method(sel_getUid("arrayByAddingObjectsFromArray:"), function $CPArray__arrayByAddingObjectsFromArray_(self, _cmd, anArray)
{
    if (!anArray)
        return objj_msgSend(self, "copy");
    var anArray = anArray.isa === _CPJavaScriptArray ? anArray : objj_msgSend(anArray, "_javaScriptArrayCopy"),
        argumentArray = concat.call(objj_msgSend(self, "_javaScriptArrayCopy"), anArray);
    return objj_msgSend(objj_msgSend(self, "class"), sel_getUid("arrayWithArray:"), argumentArray);
}
,["CPArray","CPArray"]), new objj_method(sel_getUid("subarrayWithRange:"), function $CPArray__subarrayWithRange_(self, _cmd, aRange)
{
    if (!aRange)
        return objj_msgSend(self, "copy");
    if (aRange.location < 0 || CPMaxRange(aRange) > self.length)
        objj_msgSend(CPException, "raise:reason:", CPRangeException, "subarrayWithRange: aRange out of bounds");
    var index = aRange.location,
        count = CPMaxRange(aRange),
        argumentArray = [];
    for (; index < count; ++index)
        push.call(argumentArray, objj_msgSend(self, "objectAtIndex:", index));
    return objj_msgSend(objj_msgSend(self, "class"), sel_getUid("arrayWithArray:"), argumentArray);
}
,["CPArray","CPRange"]), new objj_method(sel_getUid("sortedArrayUsingDescriptors:"), function $CPArray__sortedArrayUsingDescriptors_(self, _cmd, descriptors)
{
    var sorted = objj_msgSend(self, "copy");
    objj_msgSend(sorted, "sortUsingDescriptors:", descriptors);
    return sorted;
}
,["CPArray","CPArray"]), new objj_method(sel_getUid("sortedArrayUsingFunction:"), function $CPArray__sortedArrayUsingFunction_(self, _cmd, aFunction)
{
    return objj_msgSend(self, "sortedArrayUsingFunction:context:", aFunction, nil);
}
,["CPArray","Function"]), new objj_method(sel_getUid("sortedArrayUsingFunction:context:"), function $CPArray__sortedArrayUsingFunction_context_(self, _cmd, aFunction, aContext)
{
    var sorted = objj_msgSend(self, "copy");
    objj_msgSend(sorted, "sortUsingFunction:context:", aFunction, aContext);
    return sorted;
}
,["CPArray","Function","id"]), new objj_method(sel_getUid("sortedArrayUsingSelector:"), function $CPArray__sortedArrayUsingSelector_(self, _cmd, aSelector)
{
    var sorted = objj_msgSend(self, "copy");
    objj_msgSend(sorted, "sortUsingSelector:", aSelector);
    return sorted;
}
,["CPArray","SEL"]), new objj_method(sel_getUid("componentsJoinedByString:"), function $CPArray__componentsJoinedByString_(self, _cmd, aString)
{
    return join.call(objj_msgSend(self, "_javaScriptArrayCopy"), aString);
}
,["CPString","CPString"]), new objj_method(sel_getUid("description"), function $CPArray__description(self, _cmd)
{
    var index = 0,
        count = objj_msgSend(self, "count"),
        description = "@[";
    for (; index < count; ++index)
    {
        if (index === 0)
            description += "\n";
        var object = objj_msgSend(self, "objectAtIndex:", index);
        description += CPDescriptionOfObject(object).replace(/^/mg, "    ");
        if (index < count - 1)
            description += ",\n";
        else
            description += "\n";
    }
    return description + "]";
}
,["CPString"]), new objj_method(sel_getUid("pathsMatchingExtensions:"), function $CPArray__pathsMatchingExtensions_(self, _cmd, filterTypes)
{
    var index = 0,
        count = objj_msgSend(self, "count"),
        array = [];
    for (; index < count; ++index)
        if (self[index].isa && objj_msgSend(self[index], "isKindOfClass:", objj_msgSend(CPString, "class")) && objj_msgSend(filterTypes, "containsObject:", objj_msgSend(self[index], "pathExtension")))
            array.push(self[index]);
    return array;
}
,["CPArray","CPArray"]), new objj_method(sel_getUid("copy"), function $CPArray__copy(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "class"), "arrayWithArray:", self);
}
,["id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $CPArray__alloc(self, _cmd)
{
    if (self === CPArray || self === CPMutableArray)
        return objj_msgSend(_CPPlaceholderArray, "alloc");
    return objj_msgSendSuper({ receiver:self, super_class:objj_getMetaClass("CPArray").super_class }, "alloc");
}
,["id"]), new objj_method(sel_getUid("array"), function $CPArray__array(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "init");
}
,["id"]), new objj_method(sel_getUid("arrayWithArray:"), function $CPArray__arrayWithArray_(self, _cmd, anArray)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithArray:", anArray);
}
,["id","CPArray"]), new objj_method(sel_getUid("arrayWithObject:"), function $CPArray__arrayWithObject_(self, _cmd, anObject)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithObjects:", anObject);
}
,["id","id"]), new objj_method(sel_getUid("arrayWithObjects:"), function $CPArray__arrayWithObjects_(self, _cmd, anObject)
{
    arguments[0] = objj_msgSend(self, "alloc");
    arguments[1] = sel_getUid("initWithObjects:");
    return objj_msgSend.apply(this, arguments);
}
,["id","id"]), new objj_method(sel_getUid("arrayWithObjects:count:"), function $CPArray__arrayWithObjects_count_(self, _cmd, objects, aCount)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithObjects:count:", objects, aCount);
}
,["id","id","unsigned"])]);
}
{
var the_class = objj_getClass("CPArray")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPArray\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPArray__initWithCoder_(self, _cmd, aCoder)
{
    return objj_msgSend(aCoder, "decodeObjectForKey:", "CP.objects");
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPArray__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "_encodeArrayOfObjects:forKey:", self, "CP.objects");
}
,["void","CPCoder"])]);
}
{var the_class = objj_allocateClassPair(CPEnumerator, "_CPArrayEnumerator"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_array"), new objj_ivar("_index")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithArray:"), function $_CPArrayEnumerator__initWithArray_(self, _cmd, anArray)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPArrayEnumerator").super_class }, "init");
    if (self)
    {
        self._array = anArray;
        self._index = -1;
    }
    return self;
}
,["id","CPArray"]), new objj_method(sel_getUid("nextObject"), function $_CPArrayEnumerator__nextObject(self, _cmd)
{
    if (++self._index >= objj_msgSend(self._array, "count"))
        return nil;
    return objj_msgSend(self._array, "objectAtIndex:", self._index);
}
,["id"])]);
}
{var the_class = objj_allocateClassPair(CPEnumerator, "_CPReverseArrayEnumerator"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_array"), new objj_ivar("_index")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithArray:"), function $_CPReverseArrayEnumerator__initWithArray_(self, _cmd, anArray)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPReverseArrayEnumerator").super_class }, "init");
    if (self)
    {
        self._array = anArray;
        self._index = objj_msgSend(self._array, "count");
    }
    return self;
}
,["id","CPArray"]), new objj_method(sel_getUid("nextObject"), function $_CPReverseArrayEnumerator__nextObject(self, _cmd)
{
    if (--self._index < 0)
        return nil;
    return objj_msgSend(self._array, "objectAtIndex:", self._index);
}
,["id"])]);
}
var _CPSharedPlaceholderArray = nil;
{var the_class = objj_allocateClassPair(CPArray, "_CPPlaceholderArray"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $_CPPlaceholderArray__alloc(self, _cmd)
{
    if (!_CPSharedPlaceholderArray)
        _CPSharedPlaceholderArray = objj_msgSendSuper({ receiver:self, super_class:objj_getMetaClass("_CPPlaceholderArray").super_class }, "alloc");
    return _CPSharedPlaceholderArray;
}
,["id"])]);
}p;20;_CPJavaScriptArray.jt;12552;@STATIC;1.0;i;16;CPMutableArray.jt;12511;


objj_executeFile("CPMutableArray.j", YES);


var concat = Array.prototype.concat,
    indexOf = Array.prototype.indexOf,
    join = Array.prototype.join,
    pop = Array.prototype.pop,
    push = Array.prototype.push,
    slice = Array.prototype.slice,
    splice = Array.prototype.splice;

{var the_class = objj_allocateClassPair(CPMutableArray, "_CPJavaScriptArray"),
meta_class = the_class.isa;
































































objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithArray:"), function $_CPJavaScriptArray__initWithArray_(self, _cmd, anArray)
{
    return objj_msgSend(self, "initWithArray:copyItems:", anArray, NO);
}
,["id","CPArray"]), new objj_method(sel_getUid("initWithArray:copyItems:"), function $_CPJavaScriptArray__initWithArray_copyItems_(self, _cmd, anArray, shouldCopyItems)
{
    if (!shouldCopyItems && objj_msgSend(anArray, "isKindOfClass:", _CPJavaScriptArray))
        return slice.call(anArray, 0);

    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPJavaScriptArray").super_class }, "init");

    var index = 0;

    if (objj_msgSend(anArray, "isKindOfClass:", _CPJavaScriptArray))
    {

        var count = anArray.length;

        for (; index < count; ++index)
        {
            var object = anArray[index];

            self[index] = (object && object.isa) ? objj_msgSend(object, "copy") : object;
        }

        return self;
    }

    var count = objj_msgSend(anArray, "count");

    for (; index < count; ++index)
    {
        var object = objj_msgSend(anArray, "objectAtIndex:", index);

        self[index] = (shouldCopyItems && object && object.isa) ? objj_msgSend(object, "copy") : object;
    }

    return self;
}
,["id","CPArray","BOOL"]), new objj_method(sel_getUid("initWithObjects:"), function $_CPJavaScriptArray__initWithObjects_(self, _cmd, anObject)
{

    var index = 2,
        count = arguments.length;

    for (; index < count; ++index)
        if (arguments[index] === nil)
            break;

    return slice.call(arguments, 2, index);
}
,["id","id"]), new objj_method(sel_getUid("initWithObjects:count:"), function $_CPJavaScriptArray__initWithObjects_count_(self, _cmd, objects, aCount)
{
    if (objj_msgSend(objects, "isKindOfClass:", _CPJavaScriptArray))
        return slice.call(objects, 0);

    var array = [],
        index = 0;

    for (; index < aCount; ++index)
        push.call(array, objj_msgSend(objects, "objectAtIndex:", index));

    return array;
}
,["id","CPArray","CPUInteger"]), new objj_method(sel_getUid("initWithCapacity:"), function $_CPJavaScriptArray__initWithCapacity_(self, _cmd, aCapacity)
{
    return self;
}
,["id","CPUInteger"]), new objj_method(sel_getUid("count"), function $_CPJavaScriptArray__count(self, _cmd)
{
    return self.length;
}
,["BOOL"]), new objj_method(sel_getUid("objectAtIndex:"), function $_CPJavaScriptArray__objectAtIndex_(self, _cmd, anIndex)
{
    if (anIndex >= self.length || anIndex < 0)
        _CPRaiseRangeException(self, _cmd, anIndex, self.length);

    return self[anIndex];
}
,["id","CPUInteger"]), new objj_method(sel_getUid("objectsAtIndexes:"), function $_CPJavaScriptArray__objectsAtIndexes_(self, _cmd, indexes)
{
    if (objj_msgSend(indexes, "lastIndex") >= self.length)
        objj_msgSend(CPException, "raise:reason:", CPRangeException, _cmd + " indexes out of bounds");

    var ranges = indexes._ranges,
        count = ranges.length,
        result = [],
             i = 0;

    for (; i < count; i++)
    {
        var range = ranges[i],
            loc = range.location,
            len = range.length,
            subArray = self.slice(loc, loc + len);

        result.splice.apply(result, [result.length, 0].concat(subArray));
    }

    return result;
}
,["CPArray","CPIndexSet"]), new objj_method(sel_getUid("indexOfObject:inRange:"), function $_CPJavaScriptArray__indexOfObject_inRange_(self, _cmd, anObject, aRange)
{

    if (anObject && anObject.isa)
    {
        var index = aRange ? aRange.location : 0,
            count = aRange ? CPMaxRange(aRange) : self.length;

        for (; index < count; ++index)
            if (objj_msgSend(self[index], "isEqual:", anObject))
                return index;

        return CPNotFound;
    }

    return objj_msgSend(self, "indexOfObjectIdenticalTo:inRange:", anObject, aRange);
}
,["CPUInteger","id","CPRange"]), new objj_method(sel_getUid("indexOfObjectIdenticalTo:inRange:"), function $_CPJavaScriptArray__indexOfObjectIdenticalTo_inRange_(self, _cmd, anObject, aRange)
{
    if (indexOf && !aRange)
        return indexOf.call(self, anObject);

    var index = aRange ? aRange.location : 0,
        count = aRange ? CPMaxRange(aRange) : self.length;

    for (; index < count; ++index)
        if (self[index] === anObject)
            return index;

    return CPNotFound;
}
,["CPUInteger","id","CPRange"]), new objj_method(sel_getUid("makeObjectsPerformSelector:withObjects:"), function $_CPJavaScriptArray__makeObjectsPerformSelector_withObjects_(self, _cmd, aSelector, objects)
{
    if (!aSelector)
        _CPRaiseInvalidArgumentException(self, _cmd, 'attempt to pass a nil selector');

    var index = 0,
        count = self.length;

    if (objj_msgSend(objects, "count"))
    {
        var argumentsArray = objj_msgSend([nil, aSelector], "arrayByAddingObjectsFromArray:", objects);

        for (; index < count; ++index)
        {
            argumentsArray[0] = self[index];
            objj_msgSend.apply(this, argumentsArray);
        }
    }

    else
        for (; index < count; ++index)
            objj_msgSend(self[index], aSelector);
}
,["void","SEL","CPArray"]), new objj_method(sel_getUid("arrayByAddingObject:"), function $_CPJavaScriptArray__arrayByAddingObject_(self, _cmd, anObject)
{

    if (anObject && anObject.isa && objj_msgSend(anObject, "isKindOfClass:", _CPJavaScriptArray))
        return concat.call(self, [anObject]);

    return concat.call(self, anObject);
}
,["CPArray","id"]), new objj_method(sel_getUid("arrayByAddingObjectsFromArray:"), function $_CPJavaScriptArray__arrayByAddingObjectsFromArray_(self, _cmd, anArray)
{
    if (!anArray)
        return objj_msgSend(self, "copy");

    return concat.call(self, objj_msgSend(anArray, "isKindOfClass:", _CPJavaScriptArray) ? anArray : objj_msgSend(anArray, "_javaScriptArrayCopy"));
}
,["CPArray","CPArray"]), new objj_method(sel_getUid("subarrayWithRange:"), function $_CPJavaScriptArray__subarrayWithRange_(self, _cmd, aRange)
{
    if (aRange.location < 0 || CPMaxRange(aRange) > self.length)
        objj_msgSend(CPException, "raise:reason:", CPRangeException, _cmd + " aRange out of bounds");

    return slice.call(self, aRange.location, CPMaxRange(aRange));
}
,["CPArray","CPRange"]), new objj_method(sel_getUid("componentsJoinedByString:"), function $_CPJavaScriptArray__componentsJoinedByString_(self, _cmd, aString)
{
    return join.call(self, aString);
}
,["CPString","CPString"]), new objj_method(sel_getUid("insertObject:atIndex:"), function $_CPJavaScriptArray__insertObject_atIndex_(self, _cmd, anObject, anIndex)
{
    if (anIndex > self.length || anIndex < 0)
        _CPRaiseRangeException(self, _cmd, anIndex, self.length);

    splice.call(self, anIndex, 0, anObject);
}
,["void","id","int"]), new objj_method(sel_getUid("removeObjectAtIndex:"), function $_CPJavaScriptArray__removeObjectAtIndex_(self, _cmd, anIndex)
{
    if (anIndex >= self.length || anIndex < 0)
        _CPRaiseRangeException(self, _cmd, anIndex, self.length);

    splice.call(self, anIndex, 1);
}
,["void","int"]), new objj_method(sel_getUid("removeObjectIdenticalTo:"), function $_CPJavaScriptArray__removeObjectIdenticalTo_(self, _cmd, anObject)
{
    if (indexOf)
    {
        var anIndex;
        while ((anIndex = indexOf.call(self, anObject)) !== -1)
            splice.call(self, anIndex, 1);
    }
    else
        objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPJavaScriptArray").super_class }, "removeObjectIdenticalTo:inRange:", anObject, CPMakeRange(0, self.length));
}
,["void","id"]), new objj_method(sel_getUid("removeObjectIdenticalTo:inRange:"), function $_CPJavaScriptArray__removeObjectIdenticalTo_inRange_(self, _cmd, anObject, aRange)
{
    if (indexOf && !aRange)
        objj_msgSend(self, "removeObjectIdenticalTo:", anObject);

    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPJavaScriptArray").super_class }, "removeObjectIdenticalTo:inRange:", anObject, aRange);
}
,["void","id","CPRange"]), new objj_method(sel_getUid("addObject:"), function $_CPJavaScriptArray__addObject_(self, _cmd, anObject)
{
    push.call(self, anObject);
}
,["void","id"]), new objj_method(sel_getUid("removeAllObjects"), function $_CPJavaScriptArray__removeAllObjects(self, _cmd)
{
    splice.call(self, 0, self.length);
}
,["void"]), new objj_method(sel_getUid("removeLastObject"), function $_CPJavaScriptArray__removeLastObject(self, _cmd)
{
    pop.call(self);
}
,["void"]), new objj_method(sel_getUid("removeObjectsInRange:"), function $_CPJavaScriptArray__removeObjectsInRange_(self, _cmd, aRange)
{
    if (aRange.location < 0 || CPMaxRange(aRange) > self.length)
        objj_msgSend(CPException, "raise:reason:", CPRangeException, _cmd + " aRange out of bounds");

    splice.call(self, aRange.location, aRange.length);
}
,["void","CPRange"]), new objj_method(sel_getUid("replaceObjectAtIndex:withObject:"), function $_CPJavaScriptArray__replaceObjectAtIndex_withObject_(self, _cmd, anIndex, anObject)
{
    if (anIndex >= self.length || anIndex < 0)
        _CPRaiseRangeException(self, _cmd, anIndex, self.length);

    self[anIndex] = anObject;
}
,["void","int","id"]), new objj_method(sel_getUid("replaceObjectsInRange:withObjectsFromArray:range:"), function $_CPJavaScriptArray__replaceObjectsInRange_withObjectsFromArray_range_(self, _cmd, aRange, anArray, otherRange)
{
    if (aRange.location < 0 || CPMaxRange(aRange) > self.length)
        objj_msgSend(CPException, "raise:reason:", CPRangeException, _cmd + " aRange out of bounds");

    if (otherRange && (otherRange.location < 0 || CPMaxRange(otherRange) > anArray.length))
        objj_msgSend(CPException, "raise:reason:", CPRangeException, _cmd + " otherRange out of bounds");

    if (otherRange && (otherRange.location !== 0 || otherRange.length !== objj_msgSend(anArray, "count")))
        anArray = objj_msgSend(anArray, "subarrayWithRange:", otherRange);

    if (anArray.isa !== _CPJavaScriptArray)
        anArray = objj_msgSend(anArray, "_javaScriptArrayCopy");

    splice.apply(self, [aRange.location, aRange.length].concat(anArray));
}
,["void","CPRange","CPArray","CPRange"]), new objj_method(sel_getUid("setArray:"), function $_CPJavaScriptArray__setArray_(self, _cmd, anArray)
{
    if (objj_msgSend(anArray, "isKindOfClass:", _CPJavaScriptArray))
        splice.apply(self, [0, self.length].concat(anArray));

    else
        objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPJavaScriptArray").super_class }, "setArray:", anArray);
}
,["void","CPArray"]), new objj_method(sel_getUid("addObjectsFromArray:"), function $_CPJavaScriptArray__addObjectsFromArray_(self, _cmd, anArray)
{
    if (objj_msgSend(anArray, "isKindOfClass:", _CPJavaScriptArray))
        splice.apply(self, [self.length, 0].concat(anArray));

    else
        objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPJavaScriptArray").super_class }, "addObjectsFromArray:", anArray);
}
,["void","CPArray"]), new objj_method(sel_getUid("copy"), function $_CPJavaScriptArray__copy(self, _cmd)
{
    return slice.call(self, 0);
}
,["void"]), new objj_method(sel_getUid("classForCoder"), function $_CPJavaScriptArray__classForCoder(self, _cmd)
{
    return CPArray;
}
,["Class"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $_CPJavaScriptArray__alloc(self, _cmd)
{
    return [];
}
,["id"]), new objj_method(sel_getUid("array"), function $_CPJavaScriptArray__array(self, _cmd)
{
    return [];
}
,["CPArray"]), new objj_method(sel_getUid("arrayWithArray:"), function $_CPJavaScriptArray__arrayWithArray_(self, _cmd, anArray)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithArray:", anArray);
}
,["id","CPArray"]), new objj_method(sel_getUid("arrayWithObject:"), function $_CPJavaScriptArray__arrayWithObject_(self, _cmd, anObject)
{
    return [anObject];
}
,["id","id"])]);
}

Array.prototype.isa = _CPJavaScriptArray;p;9;CPArray.jt;140;@STATIC;1.0;i;10;_CPArray.ji;20;_CPJavaScriptArray.jt;83;objj_executeFile("_CPArray.j", YES);
objj_executeFile("_CPJavaScriptArray.j", YES);p;16;CPMutableArray.jt;13587;@STATIC;1.0;i;10;_CPArray.jt;13552;


objj_executeFile("_CPArray.j", YES);

//@class CPIndexSet
{var the_class = objj_allocateClassPair(CPArray, "CPMutableArray"),
meta_class = the_class.isa;























objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("addObject:"), function $CPMutableArray__addObject_(self, _cmd, anObject)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["void","id"]), new objj_method(sel_getUid("addObjectsFromArray:"), function $CPMutableArray__addObjectsFromArray_(self, _cmd, anArray)
{
    var index = 0,
        count = objj_msgSend(anArray, "count");
    for (; index < count; ++index)
        objj_msgSend(self, "addObject:", objj_msgSend(anArray, "objectAtIndex:", index));
}
,["void","CPArray"]), new objj_method(sel_getUid("insertObject:atIndex:"), function $CPMutableArray__insertObject_atIndex_(self, _cmd, anObject, anIndex)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["void","id","int"]), new objj_method(sel_getUid("insertObjects:atIndexes:"), function $CPMutableArray__insertObjects_atIndexes_(self, _cmd, objects, indexes)
{
    var indexesCount = objj_msgSend(indexes, "count"),
        objectsCount = objj_msgSend(objects, "count");
    if (indexesCount !== objectsCount)
        objj_msgSend(CPException, "raise:reason:", CPRangeException, "the counts of the passed-in array (" + objectsCount + ") and index set (" + indexesCount + ") must be identical.");
    var lastIndex = objj_msgSend(indexes, "lastIndex");
    if (lastIndex >= objj_msgSend(self, "count") + indexesCount)
        objj_msgSend(CPException, "raise:reason:", CPRangeException, "the last index (" + lastIndex + ") must be less than the sum of the original count (" + objj_msgSend(self, "count") + ") and the insertion count (" + indexesCount + ").");
    var index = 0,
        currentIndex = objj_msgSend(indexes, "firstIndex");
    for (; index < objectsCount; ++index, currentIndex = objj_msgSend(indexes, "indexGreaterThanIndex:", currentIndex))
        objj_msgSend(self, "insertObject:atIndex:", objj_msgSend(objects, "objectAtIndex:", index), currentIndex);
}
,["void","CPArray","CPIndexSet"]), new objj_method(sel_getUid("insertObject:inArraySortedByDescriptors:"), function $CPMutableArray__insertObject_inArraySortedByDescriptors_(self, _cmd, anObject, descriptors)
{
    var index,
        count = objj_msgSend(descriptors, "count");
    if (count)
        index = objj_msgSend(self, "indexOfObject:inSortedRange:options:usingComparator:", anObject, nil, CPBinarySearchingInsertionIndex, function(lhs, rhs)
        {
            var index = 0,
                result = CPOrderedSame;
            while (index < count && ((result = objj_msgSend(objj_msgSend(descriptors, "objectAtIndex:", index), "compareObject:withObject:", lhs, rhs)) === CPOrderedSame))
                ++index;
            return result;
        });
    else
        index = objj_msgSend(self, "count");
    objj_msgSend(self, "insertObject:atIndex:", anObject, index);
    return index;
}
,["unsigned","id","CPArray"]), new objj_method(sel_getUid("replaceObjectAtIndex:withObject:"), function $CPMutableArray__replaceObjectAtIndex_withObject_(self, _cmd, anIndex, anObject)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["void","int","id"]), new objj_method(sel_getUid("replaceObjectsAtIndexes:withObjects:"), function $CPMutableArray__replaceObjectsAtIndexes_withObjects_(self, _cmd, indexes, objects)
{
    var i = 0,
        index = objj_msgSend(indexes, "firstIndex");
    while (index !== CPNotFound)
    {
        objj_msgSend(self, "replaceObjectAtIndex:withObject:", index, objj_msgSend(objects, "objectAtIndex:", i++));
        index = objj_msgSend(indexes, "indexGreaterThanIndex:", index);
    }
}
,["void","CPIndexSet","CPArray"]), new objj_method(sel_getUid("replaceObjectsInRange:withObjectsFromArray:range:"), function $CPMutableArray__replaceObjectsInRange_withObjectsFromArray_range_(self, _cmd, aRange, anArray, otherRange)
{
    objj_msgSend(self, "removeObjectsInRange:", aRange);
    if (otherRange && (otherRange.location !== 0 || otherRange.length !== objj_msgSend(anArray, "count")))
        anArray = objj_msgSend(anArray, "subarrayWithRange:", otherRange);
    var indexes = objj_msgSend(CPIndexSet, "indexSetWithIndexesInRange:", CPMakeRange(aRange.location, objj_msgSend(anArray, "count")));
    objj_msgSend(self, "insertObjects:atIndexes:", anArray, indexes);
}
,["void","CPRange","CPArray","CPRange"]), new objj_method(sel_getUid("replaceObjectsInRange:withObjectsFromArray:"), function $CPMutableArray__replaceObjectsInRange_withObjectsFromArray_(self, _cmd, aRange, anArray)
{
    objj_msgSend(self, "replaceObjectsInRange:withObjectsFromArray:range:", aRange, anArray, nil);
}
,["void","CPRange","CPArray"]), new objj_method(sel_getUid("setArray:"), function $CPMutableArray__setArray_(self, _cmd, anArray)
{
    if (self === anArray)
        return;
    objj_msgSend(self, "removeAllObjects");
    objj_msgSend(self, "addObjectsFromArray:", anArray);
}
,["void","CPArray"]), new objj_method(sel_getUid("removeAllObjects"), function $CPMutableArray__removeAllObjects(self, _cmd)
{
    while (objj_msgSend(self, "count"))
        objj_msgSend(self, "removeLastObject");
}
,["void"]), new objj_method(sel_getUid("removeLastObject"), function $CPMutableArray__removeLastObject(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["void"]), new objj_method(sel_getUid("removeObject:"), function $CPMutableArray__removeObject_(self, _cmd, anObject)
{
    objj_msgSend(self, "removeObject:inRange:", anObject, CPMakeRange(0, objj_msgSend(self, "count")));
}
,["void","id"]), new objj_method(sel_getUid("removeObject:inRange:"), function $CPMutableArray__removeObject_inRange_(self, _cmd, anObject, aRange)
{
    var index;
    while ((index = objj_msgSend(self, "indexOfObject:inRange:", anObject, aRange)) != CPNotFound)
    {
        objj_msgSend(self, "removeObjectAtIndex:", index);
        aRange = CPIntersectionRange(CPMakeRange(index, objj_msgSend(self, "count") - index), aRange);
    }
}
,["void","id","CPRange"]), new objj_method(sel_getUid("removeObjectAtIndex:"), function $CPMutableArray__removeObjectAtIndex_(self, _cmd, anIndex)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["void","int"]), new objj_method(sel_getUid("removeObjectsAtIndexes:"), function $CPMutableArray__removeObjectsAtIndexes_(self, _cmd, anIndexSet)
{
    var index = objj_msgSend(anIndexSet, "lastIndex");
    while (index !== CPNotFound)
    {
        objj_msgSend(self, "removeObjectAtIndex:", index);
        index = objj_msgSend(anIndexSet, "indexLessThanIndex:", index);
    }
}
,["void","CPIndexSet"]), new objj_method(sel_getUid("removeObjectIdenticalTo:"), function $CPMutableArray__removeObjectIdenticalTo_(self, _cmd, anObject)
{
    objj_msgSend(self, "removeObjectIdenticalTo:inRange:", anObject, CPMakeRange(0, objj_msgSend(self, "count")));
}
,["void","id"]), new objj_method(sel_getUid("removeObjectIdenticalTo:inRange:"), function $CPMutableArray__removeObjectIdenticalTo_inRange_(self, _cmd, anObject, aRange)
{
    var index,
        count = objj_msgSend(self, "count");
    while ((index = objj_msgSend(self, "indexOfObjectIdenticalTo:inRange:", anObject, aRange)) !== CPNotFound)
    {
        objj_msgSend(self, "removeObjectAtIndex:", index);
        aRange = CPIntersectionRange(CPMakeRange(index, (--count) - index), aRange);
    }
}
,["void","id","CPRange"]), new objj_method(sel_getUid("removeObjectsInArray:"), function $CPMutableArray__removeObjectsInArray_(self, _cmd, anArray)
{
    var index = 0,
        count = objj_msgSend(anArray, "count");
    for (; index < count; ++index)
        objj_msgSend(self, "removeObject:", objj_msgSend(anArray, "objectAtIndex:", index));
}
,["void","CPArray"]), new objj_method(sel_getUid("removeObjectsInRange:"), function $CPMutableArray__removeObjectsInRange_(self, _cmd, aRange)
{
    var index = aRange.location,
        count = CPMaxRange(aRange);
    while (count-- > index)
        objj_msgSend(self, "removeObjectAtIndex:", index);
}
,["void","CPRange"]), new objj_method(sel_getUid("exchangeObjectAtIndex:withObjectAtIndex:"), function $CPMutableArray__exchangeObjectAtIndex_withObjectAtIndex_(self, _cmd, anIndex, otherIndex)
{
    if (anIndex === otherIndex)
        return;
    var temporary = objj_msgSend(self, "objectAtIndex:", anIndex);
    objj_msgSend(self, "replaceObjectAtIndex:withObject:", anIndex, objj_msgSend(self, "objectAtIndex:", otherIndex));
    objj_msgSend(self, "replaceObjectAtIndex:withObject:", otherIndex, temporary);
}
,["void","unsigned","unsigned"]), new objj_method(sel_getUid("sortUsingDescriptors:"), function $CPMutableArray__sortUsingDescriptors_(self, _cmd, descriptors)
{
    var i = objj_msgSend(descriptors, "count"),
        jsDescriptors = [];
    while (i--)
    {
        var d = objj_msgSend(descriptors, "objectAtIndex:", i);
        objj_msgSend(jsDescriptors, "addObject:", { "k": objj_msgSend(d, "key"), "a": objj_msgSend(d, "ascending"), "s": objj_msgSend(d, "selector")});
    }
    sortArrayUsingJSDescriptors(self, jsDescriptors);
}
,["void","CPArray"]), new objj_method(sel_getUid("sortUsingFunction:context:"), function $CPMutableArray__sortUsingFunction_context_(self, _cmd, aFunction, aContext)
{
    sortArrayUsingFunction(self, aFunction, aContext);
}
,["void","Function","id"]), new objj_method(sel_getUid("sortUsingSelector:"), function $CPMutableArray__sortUsingSelector_(self, _cmd, aSelector)
{
    sortArrayUsingFunction(self, selectorCompare, aSelector);
}
,["void","SEL"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("arrayWithCapacity:"), function $CPMutableArray__arrayWithCapacity_(self, _cmd, aCapacity)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithCapacity:", aCapacity);
}
,["CPArray","unsigned"])]);
}
{
var the_class = objj_getClass("CPArray")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPArray\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("mutableCopy"), function $CPArray__mutableCopy(self, _cmd)
{
    var r = objj_msgSend(CPMutableArray, "new");
    objj_msgSend(r, "addObjectsFromArray:", self);
    return r;
}
,["id"])]);
}
var selectorCompare = function(object1, object2, selector)
{
    return objj_msgSend(object1, "performSelector:withObject:", selector, object2);
};
var sortArrayUsingFunction = function(array, aFunction, aContext)
{
    var h,
        i,
        j,
        k,
        l,
        m,
        n = array.length,
        o;
    var A,
        B = [];
    for (h = 1; h < n; h += h)
    {
        for (m = n - 1 - h; m >= 0; m -= h + h)
        {
            l = m - h + 1;
            if (l < 0)
                l = 0;
            for (i = 0, j = l; j <= m; i++, j++)
                B[i] = array[j];
            for (i = 0, k = l; k < j && j <= m + h; k++)
            {
                A = array[j];
                o = aFunction(A, B[i], aContext);
                if (o >= 0)
                    array[k] = B[i++];
                else
                {
                    array[k] = A;
                    j++;
                }
            }
            while (k < j)
                array[k++] = B[i++];
        }
    }
}
var sortArrayUsingJSDescriptors = function(a, d)
{
    var h,
        i,
        j,
        k,
        l,
        m,
        n = a.length,
        dl = d.length - 1,
        o,
        c = {};
    var A,
        B = [],
        C1,
        C2,
        cn,
        aUID,
        bUID,
        key,
        dd;
    if (dl < 0)
        return;
    for (h = 1; h < n; h += h)
    {
        for (m = n - 1 - h; m >= 0; m -= h + h)
        {
            l = m - h + 1;
            if (l < 0)
                l = 0;
            for (i = 0, j = l; j <= m; i++, j++)
                B[i] = a[j];
            for (i = 0, k = l; k < j && j <= m + h; k++)
            {
                A = a[j];
                aUID = A._UID;
                if (!aUID)
                    aUID = objj_msgSend(A, "UID");
                C1 = c[aUID];
                if (!C1)
                {
                    C1 = {};
                    cn = dl;
                    do
                    {
                        key = d[cn].k;
                        C1[key] = objj_msgSend(A, "valueForKeyPath:", key);
                    } while (cn--)
                    c[aUID] = C1;
                }
                bUID = B[i]._UID;
                if (!bUID)
                    bUID = objj_msgSend(B[i], "UID");
                C2 = c[bUID];
                if (!C2)
                {
                    C2 = {};
                    cn = dl;
                    do
                    {
                        key = d[cn].k;
                        C2[key] = objj_msgSend(B[i], "valueForKeyPath:", key);
                    } while (cn--)
                    c[bUID] = C2;
                }
                cn = dl;
                do
                {
                    dd = d[cn];
                    key = dd.k;
                    o = objj_msgSend(C1[key], dd.s, C2[key]);
                    if (o && !dd.a)
                        o = -o;
                } while (cn-- && o == CPOrderedSame)
                if (o >= 0)
                    a[k] = B[i++];
                else
                {
                    a[k] = A;
                    j++;
                }
            }
            while (k < j)
                a[k++] = B[i++];
        }
    }
}p;24;_CPAggregateExpression.jt;3710;@STATIC;1.0;i;9;CPArray.ji;10;CPString.ji;15;_CPExpression.jt;3643;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("_CPExpression.j", YES);
{var the_class = objj_allocateClassPair(CPExpression, "_CPAggregateExpression"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_aggregate")]);




objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithAggregate:"), function $_CPAggregateExpression__initWithAggregate_(self, _cmd, collection)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPAggregateExpression").super_class }, "initWithExpressionType:", CPAggregateExpressionType);
    if (self)
        self._aggregate = collection;
    return self;
}
,["id","CPArray"]), new objj_method(sel_getUid("isEqual:"), function $_CPAggregateExpression__isEqual_(self, _cmd, object)
{
    if (self === object)
        return YES;
    if (object.isa !== self.isa || !objj_msgSend(objj_msgSend(object, "collection"), "isEqual:", self._aggregate))
        return NO;
    return YES;
}
,["BOOL","id"]), new objj_method(sel_getUid("collection"), function $_CPAggregateExpression__collection(self, _cmd)
{
    return self._aggregate;
}
,["id"]), new objj_method(sel_getUid("expressionValueWithObject:context:"), function $_CPAggregateExpression__expressionValueWithObject_context_(self, _cmd, object, context)
{
    var eval_array = objj_msgSend(CPArray, "array"),
        collection = objj_msgSend(self._aggregate, "objectEnumerator"),
        exp;
    while ((exp = objj_msgSend(collection, "nextObject")) !== nil)
    {
        var eval = objj_msgSend(exp, "expressionValueWithObject:context:", object, context);
        objj_msgSend(eval_array, "addObject:", eval);
    }
    return eval_array;
}
,["id","id","CPDictionary"]), new objj_method(sel_getUid("description"), function $_CPAggregateExpression__description(self, _cmd)
{
    var i = 0,
        count = objj_msgSend(self._aggregate, "count"),
        result = "{";
    for (; i < count; i++)
        result = result + objj_msgSend(CPString, "stringWithFormat:", "%s%s", objj_msgSend(objj_msgSend(self._aggregate, "objectAtIndex:", i), "description"), (i + 1 < count) ? ", " : "");
    result = result + "}";
    return result;
}
,["CPString"]), new objj_method(sel_getUid("_expressionWithSubstitutionVariables:"), function $_CPAggregateExpression___expressionWithSubstitutionVariables_(self, _cmd, variables)
{
    var subst_array = objj_msgSend(CPArray, "array"),
        count = objj_msgSend(self._aggregate, "count"),
        i = 0;
    for (; i < count; i++)
        objj_msgSend(subst_array, "addObject:", objj_msgSend(objj_msgSend(self._aggregate, "objectAtIndex:", i), "_expressionWithSubstitutionVariables:", variables));
    return objj_msgSend(CPExpression, "expressionForAggregate:", subst_array);
}
,["CPExpression","CPDictionary"])]);
}
var CPCollectionKey = "CPCollection";
{
var the_class = objj_getClass("_CPAggregateExpression")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"_CPAggregateExpression\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $_CPAggregateExpression__initWithCoder_(self, _cmd, coder)
{
    var collection = objj_msgSend(coder, "decodeObjectForKey:", CPCollectionKey);
    return objj_msgSend(self, "initWithAggregate:", collection);
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $_CPAggregateExpression__encodeWithCoder_(self, _cmd, coder)
{
    objj_msgSend(coder, "encodeObject:forKey:", self._aggregate, CPCollectionKey);
}
,["void","CPCoder"])]);
}p;28;_CPConstantValueExpression.jt;2542;@STATIC;1.0;i;14;CPDictionary.ji;15;_CPExpression.jt;2484;objj_executeFile("CPDictionary.j", YES);
objj_executeFile("_CPExpression.j", YES);
{var the_class = objj_allocateClassPair(CPExpression, "_CPConstantValueExpression"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_value")]);



objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithValue:"), function $_CPConstantValueExpression__initWithValue_(self, _cmd, value)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPConstantValueExpression").super_class }, "initWithExpressionType:", CPConstantValueExpressionType);
    if (self)
        self._value = value;
    return self;
}
,["id","id"]), new objj_method(sel_getUid("isEqual:"), function $_CPConstantValueExpression__isEqual_(self, _cmd, object)
{
    if (self === object)
        return YES;
    if (object.isa !== self.isa || !objj_msgSend(objj_msgSend(object, "constantValue"), "isEqual:", self._value))
        return NO;
    return YES;
}
,["BOOL","id"]), new objj_method(sel_getUid("constantValue"), function $_CPConstantValueExpression__constantValue(self, _cmd)
{
    return self._value;
}
,["id"]), new objj_method(sel_getUid("expressionValueWithObject:context:"), function $_CPConstantValueExpression__expressionValueWithObject_context_(self, _cmd, object, context)
{
    return self._value;
}
,["id","id","CPDictionary"]), new objj_method(sel_getUid("description"), function $_CPConstantValueExpression__description(self, _cmd)
{
    if (objj_msgSend(self._value, "isKindOfClass:", objj_msgSend(CPString, "class")))
        return "\"" + self._value + "\"";
    return objj_msgSend(self._value, "description");
}
,["CPString"])]);
}
var CPConstantValueKey = "CPConstantValue";
{
var the_class = objj_getClass("_CPConstantValueExpression")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"_CPConstantValueExpression\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $_CPConstantValueExpression__initWithCoder_(self, _cmd, coder)
{
    var value = objj_msgSend(coder, "decodeObjectForKey:", CPConstantValueKey);
    return objj_msgSend(self, "initWithValue:", value);
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $_CPConstantValueExpression__encodeWithCoder_(self, _cmd, coder)
{
    objj_msgSend(coder, "encodeObject:forKey:", self._value, CPConstantValueKey);
}
,["void","CPCoder"])]);
}p;15;_CPExpression.jt;6609;@STATIC;1.0;i;9;CPArray.ji;14;CPDictionary.ji;18;CPKeyValueCoding.ji;10;CPObject.ji;10;CPString.jt;6505;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPKeyValueCoding.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPString.j", YES);
CPConstantValueExpressionType = 0;
CPEvaluatedObjectExpressionType = 1;
CPVariableExpressionType = 2;
CPKeyPathExpressionType = 3;
CPFunctionExpressionType = 4;
CPAggregateExpressionType = 5;
CPSubqueryExpressionType = 6;
CPUnionSetExpressionType = 7;
CPIntersectSetExpressionType = 8;
CPMinusSetExpressionType = 9;
{var the_class = objj_allocateClassPair(CPObject, "CPExpression"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_type")]);






















objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithExpressionType:"), function $CPExpression__initWithExpressionType_(self, _cmd, type)
{
    self._type = type;
    return self;
}
,["id","int"]), new objj_method(sel_getUid("expressionType"), function $CPExpression__expressionType(self, _cmd)
{
    return self._type;
}
,["int"]), new objj_method(sel_getUid("constantValue"), function $CPExpression__constantValue(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["id"]), new objj_method(sel_getUid("variable"), function $CPExpression__variable(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["CPString"]), new objj_method(sel_getUid("keyPath"), function $CPExpression__keyPath(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["CPString"]), new objj_method(sel_getUid("function"), function $CPExpression__function(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["CPString"]), new objj_method(sel_getUid("arguments"), function $CPExpression__arguments(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["CPArray"]), new objj_method(sel_getUid("collection"), function $CPExpression__collection(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["id"]), new objj_method(sel_getUid("predicate"), function $CPExpression__predicate(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["CPPredicate"]), new objj_method(sel_getUid("operand"), function $CPExpression__operand(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["CPExpression"]), new objj_method(sel_getUid("leftExpression"), function $CPExpression__leftExpression(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["CPExpression"]), new objj_method(sel_getUid("rightExpression"), function $CPExpression__rightExpression(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
    return nil;
}
,["CPExpression"]), new objj_method(sel_getUid("_expressionWithSubstitutionVariables:"), function $CPExpression___expressionWithSubstitutionVariables_(self, _cmd, variables)
{
    return self;
}
,["CPExpression","CPDictionary"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("expressionForConstantValue:"), function $CPExpression__expressionForConstantValue_(self, _cmd, value)
{
    return objj_msgSend(objj_msgSend(_CPConstantValueExpression, "alloc"), "initWithValue:", value);
}
,["CPExpression","id"]), new objj_method(sel_getUid("expressionForEvaluatedObject"), function $CPExpression__expressionForEvaluatedObject(self, _cmd)
{
    return objj_msgSend(_CPSelfExpression, "evaluatedObject");
}
,["CPExpression"]), new objj_method(sel_getUid("expressionForVariable:"), function $CPExpression__expressionForVariable_(self, _cmd, string)
{
    return objj_msgSend(objj_msgSend(_CPVariableExpression, "alloc"), "initWithVariable:", string);
}
,["CPExpression","CPString"]), new objj_method(sel_getUid("expressionForKeyPath:"), function $CPExpression__expressionForKeyPath_(self, _cmd, keyPath)
{
    return objj_msgSend(objj_msgSend(_CPKeyPathExpression, "alloc"), "initWithKeyPath:", keyPath);
}
,["CPExpression","CPString"]), new objj_method(sel_getUid("expressionForAggregate:"), function $CPExpression__expressionForAggregate_(self, _cmd, collection)
{
    return objj_msgSend(objj_msgSend(_CPAggregateExpression, "alloc"), "initWithAggregate:", collection);
}
,["CPExpression","CPArray"]), new objj_method(sel_getUid("expressionForUnionSet:with:"), function $CPExpression__expressionForUnionSet_with_(self, _cmd, left, right)
{
    return objj_msgSend(objj_msgSend(_CPSetExpression, "alloc"), "initWithType:left:right:", CPUnionSetExpressionType, left, right);
}
,["CPExpression","CPExpression","CPExpression"]), new objj_method(sel_getUid("expressionForIntersectSet:with:"), function $CPExpression__expressionForIntersectSet_with_(self, _cmd, left, right)
{
    return objj_msgSend(objj_msgSend(_CPSetExpression, "alloc"), "initWithType:left:right:", CPIntersectSetExpressionType, left, right);
}
,["CPExpression","CPExpression","CPExpression"]), new objj_method(sel_getUid("expressionForMinusSet:with:"), function $CPExpression__expressionForMinusSet_with_(self, _cmd, left, right)
{
    return objj_msgSend(objj_msgSend(_CPSetExpression, "alloc"), "initWithType:left:right:", CPMinusSetExpressionType, left, right);
}
,["CPExpression","CPExpression","CPExpression"]), new objj_method(sel_getUid("expressionForFunction:arguments:"), function $CPExpression__expressionForFunction_arguments_(self, _cmd, function_name, parameters)
{
    return objj_msgSend(objj_msgSend(_CPFunctionExpression, "alloc"), "initWithSelector:arguments:", CPSelectorFromString(function_name), parameters);
}
,["CPExpression","CPString","CPArray"]), new objj_method(sel_getUid("expressionForFunction:selectorName:arguments:"), function $CPExpression__expressionForFunction_selectorName_arguments_(self, _cmd, target, selectorName, parameters)
{
    return objj_msgSend(objj_msgSend(_CPFunctionExpression, "alloc"), "initWithTarget:selector:arguments:", target, CPSelectorFromString(selectorName), parameters);
}
,["CPExpression","CPExpression","CPString","CPArray"]), new objj_method(sel_getUid("expressionForSubquery:usingIteratorVariable:predicate:"), function $CPExpression__expressionForSubquery_usingIteratorVariable_predicate_(self, _cmd, expression, variable, predicate)
{
    return objj_msgSend(objj_msgSend(_CPSubqueryExpression, "alloc"), "initWithExpression:usingIteratorVariable:predicate:", expression, variable, predicate);
}
,["CPExpression","CPExpression","CPString","CPPredicate"])]);
}p;23;_CPFunctionExpression.jt;11238;@STATIC;1.0;i;9;CPArray.ji;8;CPDate.ji;14;CPDictionary.ji;13;CPException.ji;10;CPString.ji;15;_CPExpression.jt;11121;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPDate.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("_CPExpression.j", YES);
{var the_class = objj_allocateClassPair(CPExpression, "_CPFunctionExpression"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_operand"), new objj_ivar("_selector"), new objj_ivar("_arguments"), new objj_ivar("_argc"), new objj_ivar("_maxargs")]);









objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithSelector:arguments:"), function $_CPFunctionExpression__initWithSelector_arguments_(self, _cmd, aSelector, parameters)
{
    var target = objj_msgSend(CPPredicateUtilities, "class");
    if (!objj_msgSend(target, "respondsToSelector:", aSelector))
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "Unknown function implementation: " + aSelector);
    var operand = objj_msgSend(CPExpression, "expressionForConstantValue:", target);
    return objj_msgSend(self, "initWithTarget:selector:arguments:", operand, aSelector, parameters);
}
,["id","SEL","CPArray"]), new objj_method(sel_getUid("initWithTarget:selector:arguments:"), function $_CPFunctionExpression__initWithTarget_selector_arguments_(self, _cmd, operand, aSelector, parameters)
{
    return objj_msgSend(self, "initWithTarget:selector:arguments:type:", operand, aSelector, parameters, CPFunctionExpressionType);
}
,["id","CPExpression","SEL","CPArray"]), new objj_method(sel_getUid("initWithTarget:selector:arguments:type:"), function $_CPFunctionExpression__initWithTarget_selector_arguments_type_(self, _cmd, operand, aSelector, parameters, type)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPFunctionExpression").super_class }, "initWithExpressionType:", type);
    if (self)
    {
        self._selector = aSelector;
        self._operand = operand;
        self._arguments = parameters;
        self._argc = objj_msgSend(parameters, "count");
        self._maxargs = objj_msgSend(objj_msgSend(CPStringFromSelector(self._selector), "componentsSeparatedByString:", ":"), "count") - 1;
    }
    return self;
}
,["id","CPExpression","SEL","CPArray","int"]), new objj_method(sel_getUid("isEqual:"), function $_CPFunctionExpression__isEqual_(self, _cmd, object)
{
    if (self === object)
        return YES;
    if (object.isa !== self.isa || !objj_msgSend(objj_msgSend(object, "_function"), "isEqual:", self._selector) || !objj_msgSend(objj_msgSend(object, "operand"), "isEqual:", self._operand) || !objj_msgSend(objj_msgSend(object, "arguments"), "isEqualToArray:", self._arguments))
        return NO;
    return YES;
}
,["BOOL","id"]), new objj_method(sel_getUid("_function"), function $_CPFunctionExpression___function(self, _cmd)
{
    return CPStringFromSelector(self._selector);
}
,["CPString"]), new objj_method(sel_getUid("function"), function $_CPFunctionExpression__function(self, _cmd)
{
    return objj_msgSend(self, "_function");
}
,["CPString"]), new objj_method(sel_getUid("arguments"), function $_CPFunctionExpression__arguments(self, _cmd)
{
    return self._arguments;
}
,["CPArray"]), new objj_method(sel_getUid("operand"), function $_CPFunctionExpression__operand(self, _cmd)
{
    return self._operand;
}
,["CPExpression"]), new objj_method(sel_getUid("expressionValueWithObject:context:"), function $_CPFunctionExpression__expressionValueWithObject_context_(self, _cmd, object, context)
{
    var target = objj_msgSend(self._operand, "expressionValueWithObject:context:", object, context),
        objj_args = [target, self._selector],
        i = 0;
    for (; i < self._argc; i++)
    {
        var arg = objj_msgSend(self._arguments[i], "expressionValueWithObject:context:", object, context);
        objj_args.push(arg);
    }
    if (self._argc > self._maxargs)
    {
        var r = MAX(self._maxargs + 1, 2);
        objj_args = objj_args.slice(0, r).concat([objj_args.slice(r)]);
    }
    return objj_msgSend.apply(this, objj_args);
}
,["id","id","CPDictionary"]), new objj_method(sel_getUid("description"), function $_CPFunctionExpression__description(self, _cmd)
{
    var result = "";
    if (objj_msgSend(self._operand, "isEqual:", objj_msgSend(CPExpression, "expressionForConstantValue:", objj_msgSend(CPPredicateUtilities, "class"))))
        result += CPStringFromSelector(self._selector) + "(";
    else
    {
        result += "FUNCTION(";
        result += self._operand ? objj_msgSend(self._operand, "description") + ", ":"";
        result += self._selector ? CPStringFromSelector(self._selector) + ", ":"";
    }
    for (var i = 0; i < self._argc; i++)
        result = result + objj_msgSend(self._arguments[i], "description") + ((i + 1 < self._argc) ? ", " : "");
    result += ")";
    return result ;
}
,["CPString"]), new objj_method(sel_getUid("_expressionWithSubstitutionVariables:"), function $_CPFunctionExpression___expressionWithSubstitutionVariables_(self, _cmd, variables)
{
    var operand = objj_msgSend(objj_msgSend(self, "operand"), "_expressionWithSubstitutionVariables:", variables),
        args = objj_msgSend(CPArray, "array"),
        i = 0;
    for (; i < self._argc; i++)
        objj_msgSend(args, "addObject:", objj_msgSend(self._arguments[i], "_expressionWithSubstitutionVariables:", variables));
    return objj_msgSend(CPExpression, "expressionForFunction:selectorName:arguments:", operand, objj_msgSend(self, "_function"), args);
}
,["CPExpression","CPDictionary"])]);
}
var CPSelectorNameKey = "CPSelectorName",
    CPArgumentsKey = "CPArguments",
    CPOperandKey = "CPOperand",
    CPExpressionTypeKey = "CPExpressionType";
{
var the_class = objj_getClass("_CPFunctionExpression")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"_CPFunctionExpression\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $_CPFunctionExpression__initWithCoder_(self, _cmd, coder)
{
    var type = objj_msgSend(coder, "decodeIntForKey:", CPExpressionTypeKey),
        operand = objj_msgSend(coder, "decodeObjectForKey:", CPOperandKey),
        selector = CPSelectorFromString(objj_msgSend(coder, "decodeObjectForKey:", CPSelectorNameKey)),
        parameters = objj_msgSend(coder, "decodeObjectForKey:", CPArgumentsKey);
    return objj_msgSend(self, "initWithTarget:selector:arguments:type:", operand, selector, parameters, type);
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $_CPFunctionExpression__encodeWithCoder_(self, _cmd, coder)
{
    objj_msgSend(coder, "encodeObject:forKey:", objj_msgSend(self, "_function"), CPSelectorNameKey);
    objj_msgSend(coder, "encodeObject:forKey:", self._arguments, CPArgumentsKey);
    objj_msgSend(coder, "encodeObject:forKey:", self._operand, CPOperandKey);
    objj_msgSend(coder, "encodeInt:forKey:", self._type, CPExpressionTypeKey);
}
,["void","CPCoder"])]);
}
{var the_class = objj_allocateClassPair(CPObject, "CPPredicateUtilities"),
meta_class = the_class.isa;




















objj_registerClassPair(the_class);
class_addMethods(meta_class, [new objj_method(sel_getUid("sum:"), function $CPPredicateUtilities__sum_(self, _cmd, parameters)
{
    var sum = 0,
        count = parameters.length;
    while (count--)
        sum += parameters[count];
    return sum;
}
,["float","CPArray"]), new objj_method(sel_getUid("count:"), function $CPPredicateUtilities__count_(self, _cmd, parameters)
{
    return objj_msgSend(parameters, "count");
}
,["float","CPArray"]), new objj_method(sel_getUid("min:"), function $CPPredicateUtilities__min_(self, _cmd, parameters)
{
    return parameters.sort()[0];
}
,["float","CPArray"]), new objj_method(sel_getUid("max:"), function $CPPredicateUtilities__max_(self, _cmd, parameters)
{
    return parameters.sort()[parameters.length - 1];
}
,["float","CPArray"]), new objj_method(sel_getUid("average:"), function $CPPredicateUtilities__average_(self, _cmd, parameters)
{
    return objj_msgSend(self, "sum:", parameters) / parameters.length;
}
,["float","CPArray"]), new objj_method(sel_getUid("first:"), function $CPPredicateUtilities__first_(self, _cmd, parameters)
{
    return parameters[0];
}
,["id","CPArray"]), new objj_method(sel_getUid("last:"), function $CPPredicateUtilities__last_(self, _cmd, parameters)
{
    return parameters[parameters.length - 1];
}
,["id","CPArray"]), new objj_method(sel_getUid("fromObject:index:"), function $CPPredicateUtilities__fromObject_index_(self, _cmd, object, anIndex)
{
    if (objj_msgSend(object, "isKindOfClass:", objj_msgSend(CPDictionary, "class")))
        return objj_msgSend(object, "objectForKey:", anIndex);
    else objj_msgSend(object, "isKindOfClass:", objj_msgSend(CPArray, "class"))
        return objj_msgSend(object, "objectAtIndex:", anIndex);
    objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "object[#] requires a CPDictionary or CPArray");
}
,["id","id","id"]), new objj_method(sel_getUid("add:to:"), function $CPPredicateUtilities__add_to_(self, _cmd, n, m)
{
    return n + m;
}
,["float","int","int"]), new objj_method(sel_getUid("from:substract:"), function $CPPredicateUtilities__from_substract_(self, _cmd, n, m)
{
    return n - m;
}
,["float","int","int"]), new objj_method(sel_getUid("multiply:by:"), function $CPPredicateUtilities__multiply_by_(self, _cmd, n, m)
{
    return n * m;
}
,["float","float","int"]), new objj_method(sel_getUid("divide:by:"), function $CPPredicateUtilities__divide_by_(self, _cmd, n, m)
{
    return n / m;
}
,["float","float","float"]), new objj_method(sel_getUid("sqrt:"), function $CPPredicateUtilities__sqrt_(self, _cmd, n)
{
    return SQRT(n);
}
,["float","float"]), new objj_method(sel_getUid("raise:to:"), function $CPPredicateUtilities__raise_to_(self, _cmd, num, power)
{
    return POW(num, power);
}
,["float","float","int"]), new objj_method(sel_getUid("abs:"), function $CPPredicateUtilities__abs_(self, _cmd, num)
{
    return ABS(num);
}
,["float","float"]), new objj_method(sel_getUid("now:"), function $CPPredicateUtilities__now_(self, _cmd, _)
{
    return objj_msgSend(CPDate, "date");
}
,["CPDate","id"]), new objj_method(sel_getUid("ln:"), function $CPPredicateUtilities__ln_(self, _cmd, num)
{
    return LN10(num);
}
,["float","float"]), new objj_method(sel_getUid("exp:"), function $CPPredicateUtilities__exp_(self, _cmd, num)
{
    return EXP(num);
}
,["float","float"]), new objj_method(sel_getUid("ceiling:"), function $CPPredicateUtilities__ceiling_(self, _cmd, num)
{
    return CEIL(num);
}
,["float","float"]), new objj_method(sel_getUid("random:"), function $CPPredicateUtilities__random_(self, _cmd, num)
{
    return ROUND(RAND() * num);
}
,["int","int"]), new objj_method(sel_getUid("modulus:by:"), function $CPPredicateUtilities__modulus_by_(self, _cmd, n, m)
{
    return n % m;
}
,["int","int","int"]), new objj_method(sel_getUid("chs:"), function $CPPredicateUtilities__chs_(self, _cmd, num)
{
    return -num;
}
,["float","int"])]);
}p;22;_CPKeyPathExpression.jt;2838;@STATIC;1.0;i;18;CPKeyValueCoding.ji;10;CPString.ji;15;_CPExpression.ji;23;_CPFunctionExpression.ji;28;_CPConstantValueExpression.jt;2700;objj_executeFile("CPKeyValueCoding.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("_CPExpression.j", YES);
objj_executeFile("_CPFunctionExpression.j", YES);
objj_executeFile("_CPConstantValueExpression.j", YES);
{var the_class = objj_allocateClassPair(_CPFunctionExpression, "_CPKeyPathExpression"),
meta_class = the_class.isa;




objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithKeyPath:"), function $_CPKeyPathExpression__initWithKeyPath_(self, _cmd, keyPath)
{
    return objj_msgSend(self, "initWithOperand:andKeyPath:", objj_msgSend(CPExpression, "expressionForEvaluatedObject"), keyPath);
}
,["id","CPString"]), new objj_method(sel_getUid("initWithOperand:andKeyPath:"), function $_CPKeyPathExpression__initWithOperand_andKeyPath_(self, _cmd, operand, keyPath)
{
    var arg = objj_msgSend(CPExpression, "expressionForConstantValue:", keyPath);
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPKeyPathExpression").super_class }, "initWithTarget:selector:arguments:type:", operand, sel_getUid("valueForKeyPath:"), [arg], CPKeyPathExpressionType);
    return self;
}
,["id","CPExpression","CPString"]), new objj_method(sel_getUid("isEqual:"), function $_CPKeyPathExpression__isEqual_(self, _cmd, object)
{
    if (object === self)
        return YES;
    if (object.isa !== self.isa || !objj_msgSend(objj_msgSend(object, "keyPath"), "isEqualToString:", objj_msgSend(self, "keyPath")))
        return NO;
    return YES;
}
,["BOOL","id"]), new objj_method(sel_getUid("pathExpression"), function $_CPKeyPathExpression__pathExpression(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "arguments"), "objectAtIndex:", 0);
}
,["CPExpression"]), new objj_method(sel_getUid("keyPath"), function $_CPKeyPathExpression__keyPath(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "pathExpression"), "keyPath");
}
,["CPString"]), new objj_method(sel_getUid("description"), function $_CPKeyPathExpression__description(self, _cmd)
{
    var result = "";
    if (objj_msgSend(self._operand, "expressionType") != CPEvaluatedObjectExpressionType)
        result += objj_msgSend(self._operand, "description") + ".";
    result += objj_msgSend(self, "keyPath");
    return result;
}
,["CPString"])]);
}
{
var the_class = objj_getClass("_CPConstantValueExpression")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"_CPConstantValueExpression\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("keyPath"), function $_CPConstantValueExpression__keyPath(self, _cmd)
{
    return objj_msgSend(self, "constantValue");
}
,["CPString"])]);
}p;14;_CPPredicate.jt;34069;@STATIC;1.0;i;9;CPArray.ji;13;CPException.ji;8;CPNull.ji;10;CPObject.ji;11;CPScanner.ji;7;CPSet.ji;9;CPValue.ji;16;CPCharacterSet.ji;33;CPComparisonPredicate_Constants.ji;31;CPCompoundPredicate_Constants.ji;15;_CPExpression.jt;33836;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPNull.j", YES);
objj_executeFile("CPObject.j", YES);
objj_executeFile("CPScanner.j", YES);
objj_executeFile("CPSet.j", YES);
objj_executeFile("CPValue.j", YES);
objj_executeFile("CPCharacterSet.j", YES);
objj_executeFile("CPComparisonPredicate_Constants.j", YES);
objj_executeFile("CPCompoundPredicate_Constants.j", YES);
objj_executeFile("_CPExpression.j", YES);
//@class CPCompoundPredicate
//@class CPComparisonPredicate
//@class _CPKeyPathExpression
//@class _CPSubqueryExpression
{var the_class = objj_allocateClassPair(CPObject, "CPPredicate"),
meta_class = the_class.isa;







objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("predicateWithSubstitutionVariables:"), function $CPPredicate__predicateWithSubstitutionVariables_(self, _cmd, variables)
{
}
,["CPPredicate","CPDictionary"]), new objj_method(sel_getUid("evaluateWithObject:"), function $CPPredicate__evaluateWithObject_(self, _cmd, object)
{
}
,["BOOL","id"]), new objj_method(sel_getUid("evaluateWithObject:substitutionVariables:"), function $CPPredicate__evaluateWithObject_substitutionVariables_(self, _cmd, object, variables)
{
}
,["BOOL","id","CPDictionary"]), new objj_method(sel_getUid("predicateFormat"), function $CPPredicate__predicateFormat(self, _cmd)
{
}
,["CPString"]), new objj_method(sel_getUid("description"), function $CPPredicate__description(self, _cmd)
{
    return objj_msgSend(self, "predicateFormat");
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("predicateWithFormat:"), function $CPPredicate__predicateWithFormat_(self, _cmd, format)
{
    if (!format)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, _cmd + " the format can't be 'nil'");
    var args = Array.prototype.slice.call(arguments, 3);
    return objj_msgSend(self, "predicateWithFormat:argumentArray:", arguments[2], args);
}
,["CPPredicate","CPString"]), new objj_method(sel_getUid("predicateWithFormat:argumentArray:"), function $CPPredicate__predicateWithFormat_argumentArray_(self, _cmd, format, args)
{
    if (!format)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, _cmd + " the format can't be 'nil'");
    var s = objj_msgSend(objj_msgSend(CPPredicateScanner, "alloc"), "initWithString:args:", format, args),
        p = objj_msgSend(s, "parse");
    return p;
}
,["CPPredicate","CPString","CPArray"]), new objj_method(sel_getUid("predicateWithFormat:arguments:"), function $CPPredicate__predicateWithFormat_arguments_(self, _cmd, format, argList)
{
    return nil;
}
,["CPPredicate","CPString","va_list"]), new objj_method(sel_getUid("predicateWithValue:"), function $CPPredicate__predicateWithValue_(self, _cmd, value)
{
    return objj_msgSend(objj_msgSend(CPPredicate_BOOL, "alloc"), "initWithBool:", value);
}
,["CPPredicate","BOOL"])]);
}
{var the_class = objj_allocateClassPair(CPPredicate, "CPPredicate_BOOL"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_value")]);



objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithBool:"), function $CPPredicate_BOOL__initWithBool_(self, _cmd, value)
{
    self._value = value;
    return self;
}
,["id","BOOL"]), new objj_method(sel_getUid("isEqual:"), function $CPPredicate_BOOL__isEqual_(self, _cmd, anObject)
{
    if (self === anObject)
        return YES;
    if (self.isa !== anObject.isa || self._value !== objj_msgSend(anObject, "evaluateWithObject:", nil))
        return NO;
    return YES;
}
,["BOOL","id"]), new objj_method(sel_getUid("evaluateWithObject:"), function $CPPredicate_BOOL__evaluateWithObject_(self, _cmd, object)
{
    return self._value;
}
,["BOOL","id"]), new objj_method(sel_getUid("evaluateWithObject:substitutionVariables:"), function $CPPredicate_BOOL__evaluateWithObject_substitutionVariables_(self, _cmd, object, variables)
{
    return self._value;
}
,["BOOL","id","CPDictionary"]), new objj_method(sel_getUid("predicateFormat"), function $CPPredicate_BOOL__predicateFormat(self, _cmd)
{
    return (self._value) ? "TRUEPREDICATE" : "FALSEPREDICATE";
}
,["CPString"])]);
}
{
var the_class = objj_getClass("CPArray")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPArray\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("filteredArrayUsingPredicate:"), function $CPArray__filteredArrayUsingPredicate_(self, _cmd, predicate)
{
    var count = objj_msgSend(self, "count"),
        result = objj_msgSend(CPArray, "array"),
        i = 0;
    for (; i < count; i++)
    {
        var object = objj_msgSend(self, "objectAtIndex:", i);
        if (objj_msgSend(predicate, "evaluateWithObject:", object))
            result.push(object);
    }
    return result;
}
,["CPArray","CPPredicate"]), new objj_method(sel_getUid("filterUsingPredicate:"), function $CPArray__filterUsingPredicate_(self, _cmd, predicate)
{
    var count = objj_msgSend(self, "count");
    while (count--)
    {
        if (!objj_msgSend(predicate, "evaluateWithObject:", objj_msgSend(self, "objectAtIndex:", count)))
            self.splice(count, 1);
    }
}
,["void","CPPredicate"])]);
}
{
var the_class = objj_getClass("CPSet")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPSet\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("filteredSetUsingPredicate:"), function $CPSet__filteredSetUsingPredicate_(self, _cmd, predicate)
{
    var count = objj_msgSend(self, "count"),
        result = objj_msgSend(CPSet, "set"),
        i = 0;
    for (; i < count; i++)
    {
        var object = objj_msgSend(self, "objectAtIndex:", i);
        if (objj_msgSend(predicate, "evaluateWithObject:", object))
            objj_msgSend(result, "addObject:", object);
    }
    return result;
}
,["CPSet","CPPredicate"]), new objj_method(sel_getUid("filterUsingPredicate:"), function $CPSet__filterUsingPredicate_(self, _cmd, predicate)
{
    var count = objj_msgSend(self, "count");
    while (--count >= 0)
    {
        var object = objj_msgSend(self, "objectAtIndex:", count);
        if (!objj_msgSend(predicate, "evaluateWithObject:", object))
            objj_msgSend(self, "removeObjectAtIndex:", count);
    }
}
,["void","CPPredicate"])]);
}
{var the_class = objj_allocateClassPair(CPScanner, "CPPredicateScanner"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_args"), new objj_ivar("_retrieved")]);














objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithString:args:"), function $CPPredicateScanner__initWithString_args_(self, _cmd, format, args)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPPredicateScanner").super_class }, "initWithString:", format)
    if (self)
    {
        self._args = objj_msgSend(args, "objectEnumerator");
    }
    return self;
}
,["id","CPString","CPArray"]), new objj_method(sel_getUid("nextArg"), function $CPPredicateScanner__nextArg(self, _cmd)
{
    return objj_msgSend(self._args, "nextObject");
}
,["id"]), new objj_method(sel_getUid("scanPredicateKeyword:"), function $CPPredicateScanner__scanPredicateKeyword_(self, _cmd, key)
{
    var loc = objj_msgSend(self, "scanLocation");
    objj_msgSend(self, "setCaseSensitive:", NO);
    if (!objj_msgSend(self, "scanString:intoString:", key, NULL))
        return NO;
    if (objj_msgSend(self, "isAtEnd"))
        return YES;
    var c = objj_msgSend(objj_msgSend(self, "string"), "characterAtIndex:", objj_msgSend(self, "scanLocation"));
    if (!objj_msgSend(objj_msgSend(CPCharacterSet, "alphanumericCharacterSet"), "characterIsMember:", c))
        return YES;
    objj_msgSend(self, "setScanLocation:", loc);
    return NO;
}
,["BOOL","CPString"]), new objj_method(sel_getUid("parse"), function $CPPredicateScanner__parse(self, _cmd)
{
    var r = nil;
    try
    {
        objj_msgSend(self, "setCharactersToBeSkipped:", objj_msgSend(CPCharacterSet, "whitespaceCharacterSet"));
        r = objj_msgSend(self, "parsePredicate");
    }
    catch(error)
    {
        CPLogConsole("Unable to parse predicate '" + objj_msgSend(self, "string") + "' with " + error);
    }
    finally
    {
        if (!objj_msgSend(self, "isAtEnd"))
        {
            var pstr = objj_msgSend(self, "string"),
                loc = objj_msgSend(self, "scanLocation");
            CPLogConsole("Format string contains extra characters: '" + objj_msgSend(pstr, "substringToIndex:", loc) + "**" + objj_msgSend(pstr, "substringFromIndex:", loc) + "**'");
        }
    }
    return r;
}
,["CPPredicate"]), new objj_method(sel_getUid("parsePredicate"), function $CPPredicateScanner__parsePredicate(self, _cmd)
{
    return objj_msgSend(self, "parseAnd");
}
,["CPPredicate"]), new objj_method(sel_getUid("parseAnd"), function $CPPredicateScanner__parseAnd(self, _cmd)
{
    var l = objj_msgSend(self, "parseOr");
    while (objj_msgSend(self, "scanPredicateKeyword:", "AND") || objj_msgSend(self, "scanPredicateKeyword:", "&&"))
    {
        var r = objj_msgSend(self, "parseOr");
        if (objj_msgSend(r, "isKindOfClass:", objj_msgSend(CPCompoundPredicate, "class")) && objj_msgSend(r, "compoundPredicateType") == CPAndPredicateType)
        {
            if (objj_msgSend(l, "isKindOfClass:", objj_msgSend(CPCompoundPredicate, "class")) && objj_msgSend(l, "compoundPredicateType") == CPAndPredicateType)
            {
                objj_msgSend(objj_msgSend(l, "subpredicates"), "addObjectsFromArray:", objj_msgSend(r, "subpredicates"));
            }
            else
            {
                objj_msgSend(objj_msgSend(r, "subpredicates"), "insertObject:atIndex:", l, 0);
                l = r;
            }
        }
        else if (objj_msgSend(l, "isKindOfClass:", objj_msgSend(CPCompoundPredicate, "class")) && objj_msgSend(l, "compoundPredicateType") == CPAndPredicateType)
        {
            objj_msgSend(objj_msgSend(l, "subpredicates"), "addObject:", r);
        }
        else
        {
            l = objj_msgSend(CPCompoundPredicate, "andPredicateWithSubpredicates:", objj_msgSend(CPArray, "arrayWithObjects:", l, r));
        }
    }
    return l;
}
,["CPPredicate"]), new objj_method(sel_getUid("parseNot"), function $CPPredicateScanner__parseNot(self, _cmd)
{
    if (objj_msgSend(self, "scanString:intoString:", "(", NULL))
    {
        var r = objj_msgSend(self, "parsePredicate");
        if (!objj_msgSend(self, "scanString:intoString:", ")", NULL))
            CPRaiseParseError(self, "predicate");
        return r;
    }
    if (objj_msgSend(self, "scanPredicateKeyword:", "NOT") || objj_msgSend(self, "scanPredicateKeyword:", "!"))
    {
        return objj_msgSend(CPCompoundPredicate, "notPredicateWithSubpredicate:", objj_msgSend(self, "parseNot"));
    }
    if (objj_msgSend(self, "scanPredicateKeyword:", "TRUEPREDICATE"))
    {
        return objj_msgSend(CPPredicate, "predicateWithValue:", YES);
    }
    if (objj_msgSend(self, "scanPredicateKeyword:", "FALSEPREDICATE"))
    {
        return objj_msgSend(CPPredicate, "predicateWithValue:", NO);
    }
    return objj_msgSend(self, "parseComparison");
}
,["CPPredicate"]), new objj_method(sel_getUid("parseOr"), function $CPPredicateScanner__parseOr(self, _cmd)
{
    var l = objj_msgSend(self, "parseNot");
    while (objj_msgSend(self, "scanPredicateKeyword:", "OR") || objj_msgSend(self, "scanPredicateKeyword:", "||"))
    {
        var r = objj_msgSend(self, "parseNot");
        if (objj_msgSend(r, "isKindOfClass:", objj_msgSend(CPCompoundPredicate, "class")) && objj_msgSend(r, "compoundPredicateType") == CPOrPredicateType)
        {
            if (objj_msgSend(l, "isKindOfClass:", objj_msgSend(CPCompoundPredicate, "class")) && objj_msgSend(l, "compoundPredicateType") == CPOrPredicateType)
            {
                objj_msgSend(objj_msgSend(l, "subpredicates"), "addObjectsFromArray:", objj_msgSend(r, "subpredicates"));
            }
            else
            {
                objj_msgSend(objj_msgSend(r, "subpredicates"), "insertObject:atIndex:", l, 0);
                l = r;
            }
        }
        else if (objj_msgSend(l, "isKindOfClass:", objj_msgSend(CPCompoundPredicate, "class")) && objj_msgSend(l, "compoundPredicateType") == CPOrPredicateType)
        {
            objj_msgSend(objj_msgSend(l, "subpredicates"), "addObject:", r);
        }
        else
        {
            l = objj_msgSend(CPCompoundPredicate, "orPredicateWithSubpredicates:", objj_msgSend(CPArray, "arrayWithObjects:", l, r));
        }
    }
    return l;
}
,["CPPredicate"]), new objj_method(sel_getUid("parseComparison"), function $CPPredicateScanner__parseComparison(self, _cmd)
{
    var modifier = CPDirectPredicateModifier,
        type = 0,
        opts = 0,
        left,
        right,
        p,
        negate = NO;
    if (objj_msgSend(self, "scanPredicateKeyword:", "ANY"))
    {
        modifier = CPAnyPredicateModifier;
    }
    else if (objj_msgSend(self, "scanPredicateKeyword:", "ALL"))
    {
        modifier = CPAllPredicateModifier;
    }
    else if (objj_msgSend(self, "scanPredicateKeyword:", "NONE"))
    {
        modifier = CPAnyPredicateModifier;
        negate = YES;
    }
    else if (objj_msgSend(self, "scanPredicateKeyword:", "SOME"))
    {
        modifier = CPAllPredicateModifier;
        negate = YES;
    }
    left = objj_msgSend(self, "parseExpression");
    if (objj_msgSend(self, "scanString:intoString:", "!=", NULL) || objj_msgSend(self, "scanString:intoString:", "<>", NULL))
    {
        type = CPNotEqualToPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanString:intoString:", "<=", NULL) || objj_msgSend(self, "scanString:intoString:", "=<", NULL))
    {
        type = CPLessThanOrEqualToPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanString:intoString:", ">=", NULL) || objj_msgSend(self, "scanString:intoString:", "=>", NULL))
    {
        type = CPGreaterThanOrEqualToPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanString:intoString:", "<", NULL))
    {
        type = CPLessThanPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanString:intoString:", ">", NULL))
    {
        type = CPGreaterThanPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanString:intoString:", "==", NULL) || objj_msgSend(self, "scanString:intoString:", "=", NULL))
    {
        type = CPEqualToPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanPredicateKeyword:", "MATCHES"))
    {
        type = CPMatchesPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanPredicateKeyword:", "LIKE"))
    {
        type = CPLikePredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanPredicateKeyword:", "BEGINSWITH"))
    {
        type = CPBeginsWithPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanPredicateKeyword:", "ENDSWITH"))
    {
        type = CPEndsWithPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanPredicateKeyword:", "IN"))
    {
        type = CPInPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanPredicateKeyword:", "CONTAINS"))
    {
        type = CPContainsPredicateOperatorType;
    }
    else if (objj_msgSend(self, "scanPredicateKeyword:", "BETWEEN"))
    {
        type = CPBetweenPredicateOperatorType;
    }
    else
        CPRaiseParseError(self, "comparison predicate");
    if (objj_msgSend(self, "scanString:intoString:", "[cd]", NULL))
    {
        opts = CPCaseInsensitivePredicateOption | CPDiacriticInsensitivePredicateOption;
    }
    else if (objj_msgSend(self, "scanString:intoString:", "[c]", NULL))
    {
        opts = CPCaseInsensitivePredicateOption;
    }
    else if (objj_msgSend(self, "scanString:intoString:", "[d]", NULL))
    {
        opts = CPDiacriticInsensitivePredicateOption;
    }
    right = objj_msgSend(self, "parseExpression");
    p = objj_msgSend(CPComparisonPredicate, "predicateWithLeftExpression:rightExpression:modifier:type:options:", left, right, modifier, type, opts);
    return negate ? objj_msgSend(CPCompoundPredicate, "notPredicateWithSubpredicate:", p):p;
}
,["CPPredicate"]), new objj_method(sel_getUid("parseExpression"), function $CPPredicateScanner__parseExpression(self, _cmd)
{
    return objj_msgSend(self, "parseBinaryExpression");
}
,["CPExpression"]), new objj_method(sel_getUid("parseSimpleExpression"), function $CPPredicateScanner__parseSimpleExpression(self, _cmd)
{
    var identifier,
        location,
        ident,
        dbl;
    if (objj_msgSend(self, "scanDouble:", function(newValue){ var oldValue = dbl; if (typeof newValue != 'undefined') dbl = newValue; return oldValue;}))
        return objj_msgSend(CPExpression, "expressionForConstantValue:", dbl);
    if (objj_msgSend(self, "scanString:intoString:", "-", NULL))
        return objj_msgSend(CPExpression, "expressionForFunction:arguments:", "chs:", objj_msgSend(CPArray, "arrayWithObject:", objj_msgSend(self, "parseExpression")));
    if (objj_msgSend(self, "scanString:intoString:", "(", NULL))
    {
        var arg = objj_msgSend(self, "parseExpression");
        if (!objj_msgSend(self, "scanString:intoString:", ")", NULL))
            CPRaiseParseError(self, "expression");
        return arg;
    }
    if (objj_msgSend(self, "scanString:intoString:", "{", NULL))
    {
        var a = [];
        if (objj_msgSend(self, "scanString:intoString:", "}", NULL))
            return objj_msgSend(CPExpression, "expressionForConstantValue:", a);
        objj_msgSend(a, "addObject:", objj_msgSend(self, "parseExpression"));
        while (objj_msgSend(self, "scanString:intoString:", ",", NULL))
            objj_msgSend(a, "addObject:", objj_msgSend(self, "parseExpression"));
        if (!objj_msgSend(self, "scanString:intoString:", "}", NULL))
            CPRaiseParseError(self, "expression");
        return objj_msgSend(CPExpression, "expressionForAggregate:", a);
    }
    if (objj_msgSend(self, "scanPredicateKeyword:", "NULL") || objj_msgSend(self, "scanPredicateKeyword:", "NIL"))
    {
        return objj_msgSend(CPExpression, "expressionForConstantValue:", objj_msgSend(CPNull, "null"));
    }
    if (objj_msgSend(self, "scanPredicateKeyword:", "TRUE") || objj_msgSend(self, "scanPredicateKeyword:", "YES"))
    {
        return objj_msgSend(CPExpression, "expressionForConstantValue:", objj_msgSend(CPNumber, "numberWithBool:", YES));
    }
    if (objj_msgSend(self, "scanPredicateKeyword:", "FALSE") || objj_msgSend(self, "scanPredicateKeyword:", "NO"))
    {
        return objj_msgSend(CPExpression, "expressionForConstantValue:", objj_msgSend(CPNumber, "numberWithBool:", NO));
    }
    if (objj_msgSend(self, "scanPredicateKeyword:", "SELF"))
    {
        return objj_msgSend(CPExpression, "expressionForEvaluatedObject");
    }
    if (objj_msgSend(self, "scanString:intoString:", "$", NULL))
    {
        var variable = objj_msgSend(self, "parseSimpleExpression");
        if (!objj_msgSend(variable, "keyPath"))
            CPRaiseParseError(self, "expression");
        return objj_msgSend(CPExpression, "expressionForVariable:", variable);
    }
    location = objj_msgSend(self, "scanLocation");
    if (objj_msgSend(self, "scanString:intoString:", "%", NULL))
    {
        if (objj_msgSend(self, "isAtEnd") == NO)
        {
            var c = objj_msgSend(objj_msgSend(self, "string"), "characterAtIndex:", objj_msgSend(self, "scanLocation"));
            switch (c)
            {
                case '%':
                    location = objj_msgSend(self, "scanLocation");
                    break;
                case 'K':
                    objj_msgSend(self, "setScanLocation:", objj_msgSend(self, "scanLocation") + 1);
                    return objj_msgSend(CPExpression, "expressionForKeyPath:", objj_msgSend(self, "nextArg"));
                case '@':
                case 'c':
                case 'C':
                case 'd':
                case 'D':
                case 'i':
                case 'o':
                case 'O':
                case 'u':
                case 'U':
                case 'x':
                case 'X':
                case 'e':
                case 'E':
                case 'f':
                case 'g':
                case 'G':
                    objj_msgSend(self, "setScanLocation:", objj_msgSend(self, "scanLocation") + 1);
                    return objj_msgSend(CPExpression, "expressionForConstantValue:", objj_msgSend(self, "nextArg"));
                case 'h':
                    objj_msgSend(self, "scanString:intoString:", "h", NULL);
                    if (objj_msgSend(self, "isAtEnd") == NO)
                    {
                        c = objj_msgSend(objj_msgSend(self, "string"), "characterAtIndex:", objj_msgSend(self, "scanLocation"));
                        if (c == 'i' || c == 'u')
                        {
                            objj_msgSend(self, "setScanLocation:", objj_msgSend(self, "scanLocation") + 1);
                            return objj_msgSend(CPExpression, "expressionForConstantValue:", objj_msgSend(self, "nextArg"));
                        }
                    }
                    break;
                case 'q':
                    objj_msgSend(self, "scanString:intoString:", "q", NULL);
                    if (objj_msgSend(self, "isAtEnd") == NO)
                    {
                        c = objj_msgSend(objj_msgSend(self, "string"), "characterAtIndex:", objj_msgSend(self, "scanLocation"));
                        if (c == 'i' || c == 'u' || c == 'x' || c == 'X')
                        {
                            objj_msgSend(self, "setScanLocation:", objj_msgSend(self, "scanLocation") + 1);
                            return objj_msgSend(CPExpression, "expressionForConstantValue:", objj_msgSend(self, "nextArg"));
                        }
                    }
                    break;
            }
        }
        objj_msgSend(self, "setScanLocation:", location);
    }
    if (objj_msgSend(self, "scanString:intoString:", "\"", NULL))
    {
        var skip = objj_msgSend(self, "charactersToBeSkipped"),
            str = "";
        objj_msgSend(self, "setCharactersToBeSkipped:", nil);
        objj_msgSend(self, "scanUpToString:intoString:", "\"", function(newValue){ var oldValue = str; if (typeof newValue != 'undefined') str = newValue; return oldValue;});
        if (objj_msgSend(self, "scanString:intoString:", "\"", NULL) == NO)
            CPRaiseParseError(self, "expression");
        objj_msgSend(self, "setCharactersToBeSkipped:", skip);
        return objj_msgSend(CPExpression, "expressionForConstantValue:", str);
    }
    if (objj_msgSend(self, "scanString:intoString:", "'", NULL))
    {
        var skip = objj_msgSend(self, "charactersToBeSkipped"),
            str = "";
        objj_msgSend(self, "setCharactersToBeSkipped:", nil);
        objj_msgSend(self, "scanUpToString:intoString:", "'", function(newValue){ var oldValue = str; if (typeof newValue != 'undefined') str = newValue; return oldValue;});
        if (objj_msgSend(self, "scanString:intoString:", "'", NULL) == NO)
            CPRaiseParseError(self, "expression");
        objj_msgSend(self, "setCharactersToBeSkipped:", skip);
        return objj_msgSend(CPExpression, "expressionForConstantValue:", str);
    }
    if (objj_msgSend(self, "scanString:intoString:", "@", NULL))
    {
        var e = objj_msgSend(self, "parseExpression");
        if (!objj_msgSend(e, "keyPath"))
            CPRaiseParseError(self, "expression");
        return objj_msgSend(CPExpression, "expressionForKeyPath:", objj_msgSend(e, "keyPath") + "@");
    }
    if (objj_msgSend(self, "scanString:intoString:", "SUBQUERY", NULL))
    {
        if (!objj_msgSend(self, "scanString:intoString:", "(", NULL))
            CPRaiseParseError(self, "expression");
        var collection = objj_msgSend(self, "parseExpression"),
            variableExpression,
            subpredicate;
        if (!objj_msgSend(self, "scanString:intoString:", ",", NULL))
            CPRaiseParseError(self, "expression");
        variableExpression = objj_msgSend(self, "parseExpression");
        if (!objj_msgSend(self, "scanString:intoString:", ",", NULL))
            CPRaiseParseError(self, "expression");
        subpredicate = objj_msgSend(self, "parsePredicate");
        if (!objj_msgSend(self, "scanString:intoString:", ")", NULL))
            CPRaiseParseError(self, "expression");
        return objj_msgSend(objj_msgSend(_CPSubqueryExpression, "alloc"), "initWithExpression:usingIteratorExpression:predicate:", collection, variableExpression, subpredicate);
    }
    if (objj_msgSend(self, "scanString:intoString:", "FUNCTION", NULL))
    {
        if (!objj_msgSend(self, "scanString:intoString:", "(", NULL))
            CPRaiseParseError(self, "expression");
        var args = objj_msgSend(CPArray, "arrayWithObject:", objj_msgSend(self, "parseExpression"));
        while (objj_msgSend(self, "scanString:intoString:", ",", NULL))
            objj_msgSend(args, "addObject:", objj_msgSend(self, "parseExpression"));
        if (!objj_msgSend(self, "scanString:intoString:", ")", NULL) || objj_msgSend(args, "count") < 2 || objj_msgSend(args[1], "expressionType") != CPConstantValueExpressionType)
            CPRaiseParseError(self, "expression");
         return objj_msgSend(CPExpression, "expressionForFunction:selectorName:arguments:", args[0], objj_msgSend(args[1], "constantValue"), args.slice(2));
    }
    objj_msgSend(self, "scanString:intoString:", "#", NULL);
    if (!identifier)
        identifier = objj_msgSend(CPCharacterSet, "characterSetWithCharactersInString:", "_$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
    if (!objj_msgSend(self, "scanCharactersFromSet:intoString:", identifier, function(newValue){ var oldValue = ident; if (typeof newValue != 'undefined') ident = newValue; return oldValue;}))
        CPRaiseParseError(self, "expression");
    return objj_msgSend(CPExpression, "expressionForKeyPath:", ident);
}
,["CPExpression"]), new objj_method(sel_getUid("parseFunctionalExpression"), function $CPPredicateScanner__parseFunctionalExpression(self, _cmd)
{
    var left = objj_msgSend(self, "parseSimpleExpression");
    while (YES)
    {
        if (objj_msgSend(self, "scanString:intoString:", ".", NULL))
        {
            var right = objj_msgSend(self, "parseSimpleExpression"),
                expressionType = objj_msgSend(right, "expressionType");
            if (expressionType == CPKeyPathExpressionType)
                left = objj_msgSend(objj_msgSend(_CPKeyPathExpression, "alloc"), "initWithOperand:andKeyPath:", left, objj_msgSend(right, "keyPath"));
            else if (expressionType == CPVariableExpressionType)
                left = objj_msgSend(CPExpression, "expressionForFunction:selectorName:arguments:", left, "valueForKey:", [right]);
            else
                CPRaiseParseError(self, "expression");
        }
        else if (objj_msgSend(self, "scanString:intoString:", "[", NULL))
        {
            if (objj_msgSend(self, "scanPredicateKeyword:", "FIRST"))
            {
                left = objj_msgSend(CPExpression, "expressionForFunction:arguments:", "first:", objj_msgSend(CPArray, "arrayWithObject:", left));
            }
            else if (objj_msgSend(self, "scanPredicateKeyword:", "LAST"))
            {
                left = objj_msgSend(CPExpression, "expressionForFunction:arguments:", "last:", objj_msgSend(CPArray, "arrayWithObject:", left));
            }
            else if (objj_msgSend(self, "scanPredicateKeyword:", "SIZE"))
            {
                left = objj_msgSend(CPExpression, "expressionForFunction:arguments:", "count:", objj_msgSend(CPArray, "arrayWithObject:", left));
            }
            else
            {
                var index = objj_msgSend(self, "parseExpression");
                left = objj_msgSend(CPExpression, "expressionForFunction:arguments:", "fromObject:index:", objj_msgSend(CPArray, "arrayWithObjects:", left, index));
            }
            if (!objj_msgSend(self, "scanString:intoString:", "]", NULL))
                CPRaiseParseError(self, "expression");
        }
        else if (objj_msgSend(self, "scanString:intoString:", ":", NULL))
        {
            if (!objj_msgSend(left, "keyPath"))
                CPRaiseParseError(self, "expression");
            var selector = objj_msgSend(left, "keyPath") + ":",
                args = [];
            if (!objj_msgSend(self, "scanString:intoString:", "(", NULL))
            {
                var str;
                objj_msgSend(self, "scanCharactersFromSet:intoString:", objj_msgSend(CPCharacterSet, "lowercaseLetterCharacterSet"), function(newValue){ var oldValue = str; if (typeof newValue != 'undefined') str = newValue; return oldValue;});
                if (!objj_msgSend(self, "scanString:intoString:", ":(", NULL))
                    CPRaiseParseError(self, "expression");
                selector += str + ":";
            }
            if (!objj_msgSend(self, "scanString:intoString:", ")", NULL))
            {
                objj_msgSend(args, "addObject:", objj_msgSend(self, "parseExpression"));
                while (objj_msgSend(self, "scanString:intoString:", ",", NULL))
                    objj_msgSend(args, "addObject:", objj_msgSend(self, "parseExpression"));
                if (!objj_msgSend(self, "scanString:intoString:", ")", NULL))
                    CPRaiseParseError(self, "expression");
            }
            left = objj_msgSend(CPExpression, "expressionForFunction:arguments:", selector, args);
        }
        else if (objj_msgSend(self, "scanString:intoString:", "UNION", NULL))
        {
            left = objj_msgSend(CPExpression, "expressionForUnionSet:with:", left, objj_msgSend(self, "parseExpression"));
        }
        else if (objj_msgSend(self, "scanString:intoString:", "INTERSECT", NULL))
        {
            left = objj_msgSend(CPExpression, "expressionForIntersectSet:with:", left, objj_msgSend(self, "parseExpression"));
        }
        else if (objj_msgSend(self, "scanString:intoString:", "MINUS", NULL))
        {
            left = objj_msgSend(CPExpression, "expressionForMinusSet:with:", left, objj_msgSend(self, "parseExpression"));
        }
        else
        {
            return left;
        }
    }
}
,["CPExpression"]), new objj_method(sel_getUid("parsePowerExpression"), function $CPPredicateScanner__parsePowerExpression(self, _cmd)
{
    var left = objj_msgSend(self, "parseFunctionalExpression");
    while (YES)
    {
        var right;
        if (objj_msgSend(self, "scanString:intoString:", "**", NULL))
        {
            right = objj_msgSend(self, "parseFunctionalExpression");
            left = objj_msgSend(CPExpression, "expressionForFunction:arguments:", "raise:to:", objj_msgSend(CPArray, "arrayWithObjects:", left, right));
        }
        else
        {
            return left;
        }
    }
}
,["CPExpression"]), new objj_method(sel_getUid("parseMultiplicationExpression"), function $CPPredicateScanner__parseMultiplicationExpression(self, _cmd)
{
    var left = objj_msgSend(self, "parsePowerExpression");
    while (YES)
    {
        var right;
        if (objj_msgSend(self, "scanString:intoString:", "*", NULL))
        {
            right = objj_msgSend(self, "parsePowerExpression");
            left = objj_msgSend(CPExpression, "expressionForFunction:arguments:", "multiply:by:", objj_msgSend(CPArray, "arrayWithObjects:", left, right));
        }
        else if (objj_msgSend(self, "scanString:intoString:", "/", NULL))
        {
            right = objj_msgSend(self, "parsePowerExpression");
            left = objj_msgSend(CPExpression, "expressionForFunction:arguments:", "divide:by:", objj_msgSend(CPArray, "arrayWithObjects:", left, right));
        }
        else
        {
            return left;
        }
    }
}
,["CPExpression"]), new objj_method(sel_getUid("parseAdditionExpression"), function $CPPredicateScanner__parseAdditionExpression(self, _cmd)
{
    var left = objj_msgSend(self, "parseMultiplicationExpression");
    while (YES)
    {
        var right;
        if (objj_msgSend(self, "scanString:intoString:", "+", NULL))
        {
            right = objj_msgSend(self, "parseMultiplicationExpression");
            left = objj_msgSend(CPExpression, "expressionForFunction:arguments:", "add:to:", objj_msgSend(CPArray, "arrayWithObjects:", left, right));
        }
        else if (objj_msgSend(self, "scanString:intoString:", "-", NULL))
        {
            right = objj_msgSend(self, "parseMultiplicationExpression");
            left = objj_msgSend(CPExpression, "expressionForFunction:arguments:", "from:substract:", objj_msgSend(CPArray, "arrayWithObjects:", left, right));
        }
        else
        {
            return left;
        }
    }
}
,["CPExpression"]), new objj_method(sel_getUid("parseBinaryExpression"), function $CPPredicateScanner__parseBinaryExpression(self, _cmd)
{
    var left = objj_msgSend(self, "parseAdditionExpression");
    while (YES)
    {
        var right;
        if (objj_msgSend(self, "scanString:intoString:", ":=", NULL))
        {
            right = objj_msgSend(self, "parseAdditionExpression");
        }
        else
        {
            return left;
        }
    }
}
,["CPExpression"])]);
}
var CPRaiseParseError = CPRaiseParseError = function(aScanner, target)
{
    objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "unable to parse " + target + " at index " + objj_msgSend(aScanner, "scanLocation"));
};p;19;_CPSelfExpression.jt;1785;@STATIC;1.0;i;14;CPDictionary.ji;10;CPString.ji;15;_CPExpression.jt;1712;objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("_CPExpression.j", YES);
var evaluatedObject = nil;
{var the_class = objj_allocateClassPair(CPExpression, "_CPSelfExpression"),
meta_class = the_class.isa;





objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("init"), function $_CPSelfExpression__init(self, _cmd)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPSelfExpression").super_class }, "initWithExpressionType:", CPEvaluatedObjectExpressionType);
    return self;
}
,["id"]), new objj_method(sel_getUid("initWithCoder:"), function $_CPSelfExpression__initWithCoder_(self, _cmd, coder)
{
    return objj_msgSend(_CPSelfExpression, "evaluatedObject");
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $_CPSelfExpression__encodeWithCoder_(self, _cmd, coder)
{
}
,["void","CPCoder"]), new objj_method(sel_getUid("isEqual:"), function $_CPSelfExpression__isEqual_(self, _cmd, object)
{
    return (object === self);
}
,["BOOL","id"]), new objj_method(sel_getUid("expressionValueWithObject:context:"), function $_CPSelfExpression__expressionValueWithObject_context_(self, _cmd, object, context)
{
    return object;
}
,["id","id","CPDictionary"]), new objj_method(sel_getUid("description"), function $_CPSelfExpression__description(self, _cmd)
{
    return "SELF";
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("evaluatedObject"), function $_CPSelfExpression__evaluatedObject(self, _cmd)
{
    if (evaluatedObject == nil)
        evaluatedObject = objj_msgSend(_CPSelfExpression, "new");
    return evaluatedObject;
}
,["id"])]);
}p;18;_CPSetExpression.jt;5320;@STATIC;1.0;i;13;CPException.ji;7;CPSet.ji;15;_CPExpression.jt;5252;objj_executeFile("CPException.j", YES);
objj_executeFile("CPSet.j", YES);
objj_executeFile("_CPExpression.j", YES);
{var the_class = objj_allocateClassPair(CPExpression, "_CPSetExpression"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_left"), new objj_ivar("_right")]);





objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithType:left:right:"), function $_CPSetExpression__initWithType_left_right_(self, _cmd, type, left, right)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPSetExpression").super_class }, "initWithExpressionType:", type);
    if (self)
    {
        self._left = left;
        self._right = right;
    }
    return self;
}
,["id","int","CPExpression","CPExpression"]), new objj_method(sel_getUid("isEqual:"), function $_CPSetExpression__isEqual_(self, _cmd, object)
{
    if (self === object)
        return YES;
    if (object.isa !== self.isa || !objj_msgSend(objj_msgSend(object, "leftExpression"), "isEqual:", self._left) || !objj_msgSend(objj_msgSend(object, "rightExpression"), "isEqual:", self._right))
        return NO;
    return YES;
}
,["BOOL","id"]), new objj_method(sel_getUid("expressionValueWithObject:context:"), function $_CPSetExpression__expressionValueWithObject_context_(self, _cmd, object, context)
{
    var right = objj_msgSend(self._right, "expressionValueWithObject:context:", object, context);
    if (objj_msgSend(right, "isKindOfClass:", objj_msgSend(CPArray, "class")))
        right = objj_msgSend(CPSet, "setWithArray:", right);
    else if (objj_msgSend(right, "isKindOfClass:", objj_msgSend(CPDictionary, "class")))
        right = objj_msgSend(CPSet, "setWithArray:", objj_msgSend(right, "allValues"));
    else if (!objj_msgSend(right, "isKindOfClass:", objj_msgSend(CPSet, "class")))
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "The right expression for a CP*SetExpressionType expression must evaluate to a CPArray, CPDictionary or CPSet");
    var left = objj_msgSend(self._left, "expressionValueWithObject:context:", object, context);
    if (!objj_msgSend(left, "isKindOfClass:", objj_msgSend(CPSet, "class")))
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "The left expression for a CP*SetExpressionType expression must evaluate to a CPSet");
    var result = objj_msgSend(left, "copy");
    switch (self._type)
    {
        case CPIntersectSetExpressionType : objj_msgSend(result, "intersectSet:", right);
                                            break;
        case CPUnionSetExpressionType : objj_msgSend(result, "unionSet:", right);
                                            break;
        case CPMinusSetExpressionType : objj_msgSend(result, "minusSet:", right);
                                            break;
        default:
    }
    return result;
}
,["id",null,"CPDictionary"]), new objj_method(sel_getUid("_expressionWithSubstitutionVariables:"), function $_CPSetExpression___expressionWithSubstitutionVariables_(self, _cmd, variables)
{
    return self;
}
,["CPExpression","CPDictionary"]), new objj_method(sel_getUid("leftExpression"), function $_CPSetExpression__leftExpression(self, _cmd)
{
    return self._left;
}
,["CPExpression"]), new objj_method(sel_getUid("rightExpression"), function $_CPSetExpression__rightExpression(self, _cmd)
{
    return self._right;
}
,["CPExpression"]), new objj_method(sel_getUid("description"), function $_CPSetExpression__description(self, _cmd)
{
    var desc;
    switch (self._type)
    {
        case CPIntersectSetExpressionType : desc = " INTERSECT ";
                                            break;
        case CPUnionSetExpressionType : desc = " UNION ";
                                            break;
        case CPMinusSetExpressionType : desc = " MINUS ";
                                            break;
        default:
    }
    return objj_msgSend(self._left, "description") + desc + objj_msgSend(self._right, "description");
}
,["CPString"])]);
}
var CPLeftExpressionKey = "CPLeftExpression",
    CPRightExpressionKey = "CPRightExpression",
    CPExpressionType = "CPExpressionType";
{
var the_class = objj_getClass("_CPSetExpression")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"_CPSetExpression\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $_CPSetExpression__initWithCoder_(self, _cmd, coder)
{
    var left = objj_msgSend(coder, "decodeObjectForKey:", CPLeftExpressionKey),
        right = objj_msgSend(coder, "decodeObjectForKey:", CPRightExpressionKey),
        type = objj_msgSend(coder, "decodeIntForKey:", CPExpressionType);
    return objj_msgSend(self, "initWithType:left:right:", type, left, right);
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $_CPSetExpression__encodeWithCoder_(self, _cmd, coder)
{
    objj_msgSend(coder, "encodeObject:forKey:", self._left, CPLeftExpressionKey);
    objj_msgSend(coder, "encodeObject:forKey:", self._right, CPRightExpressionKey);
    objj_msgSend(coder, "encodeInt:forKey:", self._type, CPExpressionType);
}
,["void","CPCoder"])]);
}p;23;_CPSubqueryExpression.jt;5865;@STATIC;1.0;i;9;CPArray.ji;14;CPDictionary.ji;15;_CPExpression.ji;14;_CPPredicate.jt;5775;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPDictionary.j", YES);
objj_executeFile("_CPExpression.j", YES);
objj_executeFile("_CPPredicate.j", YES);
{var the_class = objj_allocateClassPair(CPExpression, "_CPSubqueryExpression"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_collection"), new objj_ivar("_variableExpression"), new objj_ivar("_subpredicate")]);









objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithExpression:usingIteratorVariable:predicate:"), function $_CPSubqueryExpression__initWithExpression_usingIteratorVariable_predicate_(self, _cmd, collection, variable, subpredicate)
{
    var variableExpression = objj_msgSend(CPExpression, "expressionForVariable:", variable);
    return objj_msgSend(self, "initWithExpression:usingIteratorExpression:predicate:", collection, variableExpression, subpredicate);
}
,["id","CPExpression","CPString","CPPredicate"]), new objj_method(sel_getUid("initWithExpression:usingIteratorExpression:predicate:"), function $_CPSubqueryExpression__initWithExpression_usingIteratorExpression_predicate_(self, _cmd, collection, variableExpression, subpredicate)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPSubqueryExpression").super_class }, "initWithExpressionType:", CPSubqueryExpressionType);
    if (self)
    {
        self._subpredicate = subpredicate;
        self._collection = collection;
        self._variableExpression = variableExpression;
    }
    return self;
}
,["id","CPExpression","CPExpression","CPPredicate"]), new objj_method(sel_getUid("expressionValueWithObject:context:"), function $_CPSubqueryExpression__expressionValueWithObject_context_(self, _cmd, object, context)
{
    var collection = objj_msgSend(self._collection, "expressionValueWithObject:context:", object, context),
        count = objj_msgSend(collection, "count"),
        result = objj_msgSend(CPArray, "array"),
        bindings = objj_msgSend(objj_msgSend(CPDictionary, "alloc"), "initWithObjectsAndKeys:", objj_msgSend(CPExpression, "expressionForEvaluatedObject"), objj_msgSend(self, "variable")),
        i = 0;
    for (; i < count; i++)
    {
        var item = objj_msgSend(collection, "objectAtIndex:", i);
        if (objj_msgSend(self._subpredicate, "evaluateWithObject:substitutionVariables:", item, bindings))
            objj_msgSend(result, "addObject:", item);
    }
    return result;
}
,["id","id","id"]), new objj_method(sel_getUid("isEqual:"), function $_CPSubqueryExpression__isEqual_(self, _cmd, object)
{
    if (self === object)
        return YES;
    if (object.isa !== self.isa || !objj_msgSend(self._collection, "isEqual:", objj_msgSend(object, "collection")) || !objj_msgSend(self._variableExpression, "isEqual:", objj_msgSend(object, "variableExpression")) || !objj_msgSend(self._subpredicate, "isEqual:", objj_msgSend(object, "predicate")))
        return NO;
    return YES;
}
,["BOOL","id"]), new objj_method(sel_getUid("collection"), function $_CPSubqueryExpression__collection(self, _cmd)
{
    return self._collection;
}
,["CPExpression"]), new objj_method(sel_getUid("copy"), function $_CPSubqueryExpression__copy(self, _cmd)
{
    return objj_msgSend(objj_msgSend(_CPSubqueryExpression, "alloc"), "initWithExpression:usingIteratorExpression:predicate:", objj_msgSend(self._collection, "copy"), objj_msgSend(self._variableExpression, "copy"), objj_msgSend(self._subpredicate, "copy"));
}
,["id"]), new objj_method(sel_getUid("predicate"), function $_CPSubqueryExpression__predicate(self, _cmd)
{
    return self._subpredicate;
}
,["CPPredicate"]), new objj_method(sel_getUid("description"), function $_CPSubqueryExpression__description(self, _cmd)
{
    return objj_msgSend(self, "predicateFormat");
}
,["CPString"]), new objj_method(sel_getUid("predicateFormat"), function $_CPSubqueryExpression__predicateFormat(self, _cmd)
{
    return "SUBQUERY(" + objj_msgSend(self._collection, "description") + ", " + objj_msgSend(self._variableExpression, "description") + ", " + objj_msgSend(self._subpredicate, "predicateFormat") + ")";
}
,["CPString"]), new objj_method(sel_getUid("variable"), function $_CPSubqueryExpression__variable(self, _cmd)
{
    return objj_msgSend(self._variableExpression, "variable");
}
,["CPString"]), new objj_method(sel_getUid("variableExpression"), function $_CPSubqueryExpression__variableExpression(self, _cmd)
{
    return self._variableExpression;
}
,["CPExpression"])]);
}
var CPExpressionKey = "CPExpression",
    CPSubpredicateKey = "CPSubpredicate",
    CPVariableKey = "CPVariable";
{
var the_class = objj_getClass("_CPSubqueryExpression")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"_CPSubqueryExpression\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $_CPSubqueryExpression__initWithCoder_(self, _cmd, coder)
{
    var collection = objj_msgSend(coder, "decodeObjectForKey:", CPExpressionKey),
        subpredicate = objj_msgSend(coder, "decodeObjectForKey:", CPSubpredicateKey),
        variableExpression = objj_msgSend(coder, "decodeObjectForKey:", CPVariableKey);
    return objj_msgSend(self, "initWithExpression:usingIteratorExpression:predicate:", collection, variableExpression, subpredicate);
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $_CPSubqueryExpression__encodeWithCoder_(self, _cmd, coder)
{
    objj_msgSend(coder, "encodeObject:forKey:", self._collection, CPExpressionKey);
    objj_msgSend(coder, "encodeObject:forKey:", self._subpredicate, CPSubpredicateKey);
    objj_msgSend(coder, "encodeObject:forKey:", self._variableExpression, CPVariableKey);
}
,["void","CPCoder"])]);
}p;23;_CPVariableExpression.jt;3330;@STATIC;1.0;i;14;CPDictionary.ji;13;CPException.ji;10;CPString.ji;15;_CPExpression.jt;3239;objj_executeFile("CPDictionary.j", YES);
objj_executeFile("CPException.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("_CPExpression.j", YES);
{var the_class = objj_allocateClassPair(CPExpression, "_CPVariableExpression"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_variable")]);




objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithVariable:"), function $_CPVariableExpression__initWithVariable_(self, _cmd, variable)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPVariableExpression").super_class }, "initWithExpressionType:", CPVariableExpressionType);
    if (self)
    {
        self._variable = objj_msgSend(variable, "copy");
    }
    return self;
}
,["id","CPString"]), new objj_method(sel_getUid("isEqual:"), function $_CPVariableExpression__isEqual_(self, _cmd, object)
{
    if (self === object)
        return YES;
    if (object.isa !== self.isa || !objj_msgSend(objj_msgSend(object, "variable"), "isEqual:", self._variable))
        return NO;
    return YES;
}
,["BOOL","id"]), new objj_method(sel_getUid("variable"), function $_CPVariableExpression__variable(self, _cmd)
{
    return self._variable;
}
,["CPString"]), new objj_method(sel_getUid("expressionValueWithObject:context:"), function $_CPVariableExpression__expressionValueWithObject_context_(self, _cmd, object, context)
{
    var expression = objj_msgSend(self, "_expressionWithSubstitutionVariables:", context);
    return objj_msgSend(expression, "expressionValueWithObject:context:", object, context);
}
,["id",null,"CPDictionary"]), new objj_method(sel_getUid("description"), function $_CPVariableExpression__description(self, _cmd)
{
    return objj_msgSend(CPString, "stringWithFormat:", "$%s", self._variable);
}
,["CPString"]), new objj_method(sel_getUid("_expressionWithSubstitutionVariables:"), function $_CPVariableExpression___expressionWithSubstitutionVariables_(self, _cmd, variables)
{
    var value = objj_msgSend(variables, "objectForKey:", self._variable);
    if (value == nil)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "Can't get value for '" + self._variable + "' in bindings" + variables);
    if (objj_msgSend(value, "isKindOfClass:", objj_msgSend(CPExpression, "class")))
        return value;
    return objj_msgSend(CPExpression, "expressionForConstantValue:", value);
}
,["CPExpression","CPDictionary"])]);
}
var CPVariableKey = "CPVariable";
{
var the_class = objj_getClass("_CPVariableExpression")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"_CPVariableExpression\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $_CPVariableExpression__initWithCoder_(self, _cmd, coder)
{
    var variable = objj_msgSend(coder, "decodeObjectForKey:", CPVariableKey);
    return objj_msgSend(self, "initWithVariable:", variable);
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $_CPVariableExpression__encodeWithCoder_(self, _cmd, coder)
{
    objj_msgSend(coder, "encodeObject:forKey:", self._variable, CPVariableKey);
}
,["void","CPCoder"])]);
}p;23;CPComparisonPredicate.jt;19923;@STATIC;1.0;i;33;CPComparisonPredicate_Constants.ji;9;CPArray.ji;14;CPEnumerator.ji;8;CPNull.ji;10;CPString.ji;15;_CPExpression.ji;14;_CPPredicate.jt;19767;objj_executeFile("CPComparisonPredicate_Constants.j", YES);
objj_executeFile("CPArray.j", YES);
objj_executeFile("CPEnumerator.j", YES);
objj_executeFile("CPNull.j", YES);
objj_executeFile("CPString.j", YES);
objj_executeFile("_CPExpression.j", YES);
objj_executeFile("_CPPredicate.j", YES);
var CPComparisonPredicateModifier,
    CPPredicateOperatorType;
{var the_class = objj_allocateClassPair(CPPredicate, "CPComparisonPredicate"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_left"), new objj_ivar("_right"), new objj_ivar("_modifier"), new objj_ivar("_type"), new objj_ivar("_options"), new objj_ivar("_customSelector")]);














objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithLeftExpression:rightExpression:customSelector:"), function $CPComparisonPredicate__initWithLeftExpression_rightExpression_customSelector_(self, _cmd, left, right, selector)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPComparisonPredicate").super_class }, "init");
    if (self)
    {
        self._left = left;
        self._right = right;
        self._modifier = CPDirectPredicateModifier;
        self._type = CPCustomSelectorPredicateOperatorType;
        self._options = 0;
        self._customSelector = selector;
    }
    return self;
}
,["id","CPExpression","CPExpression","SEL"]), new objj_method(sel_getUid("initWithLeftExpression:rightExpression:modifier:type:options:"), function $CPComparisonPredicate__initWithLeftExpression_rightExpression_modifier_type_options_(self, _cmd, left, right, modifier, type, options)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPComparisonPredicate").super_class }, "init");
    if (self)
    {
        self._left = left;
        self._right = right;
        self._modifier = modifier;
        self._type = type;
        self._options = (type != CPMatchesPredicateOperatorType &&
                    type != CPLikePredicateOperatorType &&
                    type != CPBeginsWithPredicateOperatorType &&
                    type != CPEndsWithPredicateOperatorType &&
                    type != CPInPredicateOperatorType &&
                    type != CPContainsPredicateOperatorType) ? 0 : options;
        self._customSelector = NULL;
    }
    return self;
}
,["id","CPExpression","CPExpression","CPComparisonPredicateModifier","CPPredicateOperatorType","unsigned"]), new objj_method(sel_getUid("comparisonPredicateModifier"), function $CPComparisonPredicate__comparisonPredicateModifier(self, _cmd)
{
    return self._modifier;
}
,["CPComparisonPredicateModifier"]), new objj_method(sel_getUid("customSelector"), function $CPComparisonPredicate__customSelector(self, _cmd)
{
    return self._customSelector;
}
,["SEL"]), new objj_method(sel_getUid("leftExpression"), function $CPComparisonPredicate__leftExpression(self, _cmd)
{
    return self._left;
}
,["CPExpression"]), new objj_method(sel_getUid("options"), function $CPComparisonPredicate__options(self, _cmd)
{
    return self._options;
}
,["unsigned"]), new objj_method(sel_getUid("predicateOperatorType"), function $CPComparisonPredicate__predicateOperatorType(self, _cmd)
{
    return self._type;
}
,["CPPredicateOperatorType"]), new objj_method(sel_getUid("rightExpression"), function $CPComparisonPredicate__rightExpression(self, _cmd)
{
    return self._right;
}
,["CPExpression"]), new objj_method(sel_getUid("predicateFormat"), function $CPComparisonPredicate__predicateFormat(self, _cmd)
{
    var modifier;
    switch (self._modifier)
    {
        case CPDirectPredicateModifier: modifier = "";
                                        break;
        case CPAllPredicateModifier: modifier = "ALL ";
                                        break;
        case CPAnyPredicateModifier: modifier = "ANY ";
                                        break;
        default: modifier = "";
                                        break;
    }
    var options;
    switch (self._options)
    {
        case CPCaseInsensitivePredicateOption: options = "[c]";
                                                    break;
        case CPDiacriticInsensitivePredicateOption: options = "[d]";
                                                    break;
        case CPCaseInsensitivePredicateOption | CPDiacriticInsensitivePredicateOption:
                                                    options = "[cd]";
                                                    break;
        default: options = "";
                                                    break;
    }
    var operator;
    switch (self._type)
    {
        case CPLessThanPredicateOperatorType: operator = "<";
                                                            break;
        case CPLessThanOrEqualToPredicateOperatorType: operator = "<=";
                                                            break;
        case CPGreaterThanPredicateOperatorType: operator = ">";
                                                            break;
        case CPGreaterThanOrEqualToPredicateOperatorType: operator = ">=";
                                                            break;
        case CPEqualToPredicateOperatorType: operator = "==";
                                                            break;
        case CPNotEqualToPredicateOperatorType: operator = "!=";
                                                            break;
        case CPMatchesPredicateOperatorType: operator = "MATCHES";
                                                            break;
        case CPLikePredicateOperatorType: operator = "LIKE";
                                                            break;
        case CPBeginsWithPredicateOperatorType: operator = "BEGINSWITH";
                                                            break;
        case CPEndsWithPredicateOperatorType: operator = "ENDSWITH";
                                                            break;
        case CPInPredicateOperatorType: operator = "IN";
                                                            break;
        case CPContainsPredicateOperatorType: operator = "CONTAINS";
                                                            break;
        case CPCustomSelectorPredicateOperatorType: operator = CPStringFromSelector(self._customSelector);
                                                            break;
    }
    return objj_msgSend(CPString, "stringWithFormat:", "%s%s %s%s %s", modifier, objj_msgSend(self._left, "description"), operator, options, objj_msgSend(self._right, "description"));
}
,["CPString"]), new objj_method(sel_getUid("predicateWithSubstitutionVariables:"), function $CPComparisonPredicate__predicateWithSubstitutionVariables_(self, _cmd, variables)
{
    var left = objj_msgSend(self._left, "_expressionWithSubstitutionVariables:", variables),
        right = objj_msgSend(self._right, "_expressionWithSubstitutionVariables:", variables);
    if (self._type != CPCustomSelectorPredicateOperatorType)
        return objj_msgSend(CPComparisonPredicate, "predicateWithLeftExpression:rightExpression:modifier:type:options:", left, right, self._modifier, self._type, self._options);
    else
        return objj_msgSend(CPComparisonPredicate, "predicateWithLeftExpression:rightExpression:customSelector:", left, right, self._customSelector);
}
,["CPPredicate","CPDictionary"]), new objj_method(sel_getUid("isEqual:"), function $CPComparisonPredicate__isEqual_(self, _cmd, anObject)
{
    if (self === anObject)
        return YES;
    if (anObject.isa !== self.isa || self._modifier !== objj_msgSend(anObject, "comparisonPredicateModifier") || self._type !== objj_msgSend(anObject, "predicateOperatorType") || self._options !== objj_msgSend(anObject, "options") || self._customSelector !== objj_msgSend(anObject, "customSelector") || !objj_msgSend(self._left, "isEqual:", objj_msgSend(anObject, "leftExpression")) || !objj_msgSend(self._right, "isEqual:", objj_msgSend(anObject, "rightExpression")))
        return NO;
    return YES;
}
,["BOOL","id"]), new objj_method(sel_getUid("_evaluateValue:rightValue:"), function $CPComparisonPredicate___evaluateValue_rightValue_(self, _cmd, lhs, rhs)
{
    var leftIsNil = (lhs == nil || objj_msgSend(lhs, "isEqual:", objj_msgSend(CPNull, "null"))),
        rightIsNil = (rhs == nil || objj_msgSend(rhs, "isEqual:", objj_msgSend(CPNull, "null")));
    if ((leftIsNil || rightIsNil) && self._type != CPCustomSelectorPredicateOperatorType)
        return (leftIsNil == rightIsNil &&
               (self._type == CPEqualToPredicateOperatorType ||
                self._type == CPLessThanOrEqualToPredicateOperatorType ||
                self._type == CPGreaterThanOrEqualToPredicateOperatorType));
    var string_compare_options = 0;
    switch (self._type)
    {
        case CPLessThanPredicateOperatorType: return (objj_msgSend(lhs, "compare:", rhs) == CPOrderedAscending);
        case CPLessThanOrEqualToPredicateOperatorType: return (objj_msgSend(lhs, "compare:", rhs) != CPOrderedDescending);
        case CPGreaterThanPredicateOperatorType: return (objj_msgSend(lhs, "compare:", rhs) == CPOrderedDescending);
        case CPGreaterThanOrEqualToPredicateOperatorType: return (objj_msgSend(lhs, "compare:", rhs) != CPOrderedAscending);
        case CPEqualToPredicateOperatorType: return objj_msgSend(lhs, "isEqual:", rhs);
        case CPNotEqualToPredicateOperatorType: return (!objj_msgSend(lhs, "isEqual:", rhs));
        case CPMatchesPredicateOperatorType: var commut = (self._options & CPCaseInsensitivePredicateOption) ? "gi":"g";
                                                            if (self._options & CPDiacriticInsensitivePredicateOption)
                                                            {
                                                                lhs = lhs.stripDiacritics();
                                                                rhs = rhs.stripDiacritics();
                                                            }
                                                            return (new RegExp(rhs,commut)).test(lhs);
        case CPLikePredicateOperatorType: if (self._options & CPDiacriticInsensitivePredicateOption)
                                                            {
                                                                lhs = lhs.stripDiacritics();
                                                                rhs = rhs.stripDiacritics();
                                                            }
                                                            var commut = (self._options & CPCaseInsensitivePredicateOption) ? "gi":"g",
                                                                reg = new RegExp(rhs.escapeForRegExp(),commut);
                                                            return reg.test(lhs);
        case CPBeginsWithPredicateOperatorType: var range = CPMakeRange(0, MIN(objj_msgSend(lhs, "length"), objj_msgSend(rhs, "length")));
                                                            if (self._options & CPCaseInsensitivePredicateOption)
                                                                string_compare_options |= CPCaseInsensitiveSearch;
                                                            if (self._options & CPDiacriticInsensitivePredicateOption)
                                                                string_compare_options |= CPDiacriticInsensitiveSearch;
                                                            return (objj_msgSend(lhs, "compare:options:range:", rhs, string_compare_options, range) == CPOrderedSame);
        case CPEndsWithPredicateOperatorType: var range = CPMakeRange(MAX(objj_msgSend(lhs, "length") - objj_msgSend(rhs, "length"), 0), MIN(objj_msgSend(lhs, "length"), objj_msgSend(rhs, "length")));
                                                            if (self._options & CPCaseInsensitivePredicateOption)
                                                                string_compare_options |= CPCaseInsensitiveSearch;
                                                            if (self._options & CPDiacriticInsensitivePredicateOption)
                                                                string_compare_options |= CPDiacriticInsensitiveSearch;
                                                            return (objj_msgSend(lhs, "compare:options:range:", rhs, string_compare_options, range) == CPOrderedSame);
        case CPCustomSelectorPredicateOperatorType: return objj_msgSend(lhs, "performSelector:withObject:", self._customSelector, rhs);
        case CPInPredicateOperatorType: var a = lhs;
                                                            lhs = rhs;
                                                            rhs = a;
        case CPContainsPredicateOperatorType: if (!objj_msgSend(lhs, "isKindOfClass:", objj_msgSend(CPString, "class")))
                                                            {
                                                                 if (!objj_msgSend(lhs, "respondsToSelector:", sel_getUid("objectEnumerator")))
                                                                     objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "The left/right hand side for a CONTAINS/IN  operator must be a collection or a string");
                                                                 return objj_msgSend(lhs, "containsObject:", rhs);
                                                            }
                                                            if (self._options & CPCaseInsensitivePredicateOption)
                                                                string_compare_options |= CPCaseInsensitiveSearch;
                                                            if (self._options & CPDiacriticInsensitivePredicateOption)
                                                                string_compare_options |= CPDiacriticInsensitiveSearch;
                                                            return (objj_msgSend(lhs, "rangeOfString:options:", rhs, string_compare_options).location != CPNotFound);
        case CPBetweenPredicateOperatorType: if (objj_msgSend(rhs, "count") < 2)
                                                                objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "The right hand side for a BETWEEN operator must contain 2 objects");
                                                            return (objj_msgSend(lhs, "compare:", rhs[0]) == CPOrderedDescending && objj_msgSend(lhs, "compare:", rhs[1]) == CPOrderedAscending);
        default: return NO;
    }
}
,["BOOL",null,null]), new objj_method(sel_getUid("evaluateWithObject:"), function $CPComparisonPredicate__evaluateWithObject_(self, _cmd, object)
{
    return objj_msgSend(self, "evaluateWithObject:substitutionVariables:", object, nil);
}
,["BOOL","id"]), new objj_method(sel_getUid("evaluateWithObject:substitutionVariables:"), function $CPComparisonPredicate__evaluateWithObject_substitutionVariables_(self, _cmd, object, variables)
{
    var leftValue = objj_msgSend(self._left, "expressionValueWithObject:context:", object, variables),
        rightValue = objj_msgSend(self._right, "expressionValueWithObject:context:", object, variables);
    if (self._modifier == CPDirectPredicateModifier)
        return objj_msgSend(self, "_evaluateValue:rightValue:", leftValue, rightValue);
    else
    {
        if (!objj_msgSend(leftValue, "respondsToSelector:", sel_getUid("objectEnumerator")))
            objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "The left hand side for an ALL or ANY operator must be either a CPArray or a CPSet");
        var e = objj_msgSend(leftValue, "objectEnumerator"),
            result = (self._modifier == CPAllPredicateModifier),
            value;
        while ((value = objj_msgSend(e, "nextObject")) !== nil)
        {
            var eval = objj_msgSend(self, "_evaluateValue:rightValue:", value, rightValue);
            if (eval != result)
                return eval;
        }
        return result;
    }
}
,["BOOL","id","CPDictionary"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("predicateWithLeftExpression:rightExpression:customSelector:"), function $CPComparisonPredicate__predicateWithLeftExpression_rightExpression_customSelector_(self, _cmd, left, right, selector)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithLeftExpression:rightExpression:customSelector:", left, right, selector);
}
,["CPPredicate","CPExpression","CPExpression","SEL"]), new objj_method(sel_getUid("predicateWithLeftExpression:rightExpression:modifier:type:options:"), function $CPComparisonPredicate__predicateWithLeftExpression_rightExpression_modifier_type_options_(self, _cmd, left, right, modifier, type, options)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithLeftExpression:rightExpression:modifier:type:options:", left, right, modifier, type, options);
}
,["CPPredicate","CPExpression","CPExpression","CPComparisonPredicateModifier","int","unsigned"])]);
}
{
var the_class = objj_getClass("CPComparisonPredicate")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPComparisonPredicate\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPComparisonPredicate__initWithCoder_(self, _cmd, coder)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPComparisonPredicate").super_class }, "init");
    if (self != nil)
    {
        self._left = objj_msgSend(coder, "decodeObjectForKey:", "CPComparisonPredicateLeftExpression");
        self._right = objj_msgSend(coder, "decodeObjectForKey:", "CPComparisonPredicateRightExpression");
        self._modifier = objj_msgSend(coder, "decodeIntForKey:", "CPComparisonPredicateModifier");
        self._type = objj_msgSend(coder, "decodeIntForKey:", "CPComparisonPredicateType");
        self._options = objj_msgSend(coder, "decodeIntForKey:", "CPComparisonPredicateOptions");
        self._customSelector = objj_msgSend(coder, "decodeObjectForKey:", "CPComparisonPredicateCustomSelector");
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPComparisonPredicate__encodeWithCoder_(self, _cmd, coder)
{
    objj_msgSend(coder, "encodeObject:forKey:", self._left, "CPComparisonPredicateLeftExpression");
    objj_msgSend(coder, "encodeObject:forKey:", self._right, "CPComparisonPredicateRightExpression");
    objj_msgSend(coder, "encodeInt:forKey:", self._modifier, "CPComparisonPredicateModifier");
    objj_msgSend(coder, "encodeInt:forKey:", self._type, "CPComparisonPredicateType");
    objj_msgSend(coder, "encodeInt:forKey:", self._options, "CPComparisonPredicateOptions");
    objj_msgSend(coder, "encodeObject:forKey:", self._customSelector, "CPComparisonPredicateCustomSelector");
}
,["void","CPCoder"])]);
}
var source = ['*','?','(',')','{','}','.','+','|','/','$','^'],
    dest = ['.*','.?','\\(','\\)','\\{','\\}','\\.','\\+','\\|','\\/','\\$','\\^'];
String.prototype.escapeForRegExp = function()
{
    var foundChar = false,
        i = 0;
    for (; i < source.length; ++i)
    {
        if (this.indexOf(source[i]) !== -1)
        {
            foundChar = true;
            break;
        }
    }
    if (!foundChar)
        return this;
    var result = "";
    for (i = 0; i < this.length; ++i)
    {
        var sourceIndex = source.indexOf(this.charAt(i));
        if (sourceIndex !== -1)
            result += dest[sourceIndex];
        else
            result += this.charAt(i);
    }
    return result;
};p;33;CPComparisonPredicate_Constants.jt;765;@STATIC;1.0;t;747;CPDirectPredicateModifier = 0;
CPAllPredicateModifier = 1;
CPAnyPredicateModifier = 2;
CPCaseInsensitivePredicateOption = 1;
CPDiacriticInsensitivePredicateOption = 2;
CPDiacriticInsensitiveSearch = 128;
CPLessThanPredicateOperatorType = 0;
CPLessThanOrEqualToPredicateOperatorType = 1;
CPGreaterThanPredicateOperatorType = 2;
CPGreaterThanOrEqualToPredicateOperatorType = 3;
CPEqualToPredicateOperatorType = 4;
CPNotEqualToPredicateOperatorType = 5;
CPMatchesPredicateOperatorType = 6;
CPLikePredicateOperatorType = 7;
CPBeginsWithPredicateOperatorType = 8;
CPEndsWithPredicateOperatorType = 9;
CPInPredicateOperatorType = 10;
CPCustomSelectorPredicateOperatorType = 11;
CPContainsPredicateOperatorType = 99;
CPBetweenPredicateOperatorType = 100;p;21;CPCompoundPredicate.jt;7876;@STATIC;1.0;i;31;CPCompoundPredicate_Constants.ji;9;CPArray.ji;14;_CPPredicate.jt;7789;objj_executeFile("CPCompoundPredicate_Constants.j", YES);
objj_executeFile("CPArray.j", YES);
objj_executeFile("_CPPredicate.j", YES);
var CPCompoundPredicateType;
{var the_class = objj_allocateClassPair(CPPredicate, "CPCompoundPredicate"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_type"), new objj_ivar("_predicates")]);









objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithType:subpredicates:"), function $CPCompoundPredicate__initWithType_subpredicates_(self, _cmd, type, predicates)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPCompoundPredicate").super_class }, "init");
    if (self)
    {
        self._type = type;
        self._predicates = predicates;
    }
    return self;
}
,["id","CPCompoundPredicateType","CPArray"]), new objj_method(sel_getUid("compoundPredicateType"), function $CPCompoundPredicate__compoundPredicateType(self, _cmd)
{
    return self._type;
}
,["CPCompoundPredicateType"]), new objj_method(sel_getUid("subpredicates"), function $CPCompoundPredicate__subpredicates(self, _cmd)
{
    return self._predicates;
}
,["CPArray"]), new objj_method(sel_getUid("predicateWithSubstitutionVariables:"), function $CPCompoundPredicate__predicateWithSubstitutionVariables_(self, _cmd, variables)
{
    var subp = objj_msgSend(CPArray, "array"),
        count = objj_msgSend(subp, "count"),
        i = 0;
    for (; i < count; i++)
    {
        var p = objj_msgSend(subp, "objectAtIndex:", i),
            sp = objj_msgSend(p, "predicateWithSubstitutionVariables:", variables);
        objj_msgSend(subp, "addObject:", sp);
    }
    return objj_msgSend(objj_msgSend(CPCompoundPredicate, "alloc"), "initWithType:subpredicates:", self._type, subp);
}
,["CPPredicate","CPDictionary"]), new objj_method(sel_getUid("predicateFormat"), function $CPCompoundPredicate__predicateFormat(self, _cmd)
{
    var result = "",
        args = objj_msgSend(CPArray, "array"),
        count = objj_msgSend(self._predicates, "count"),
        i = 0;
    if (count == 0)
        return "TRUEPREDICATE";
    for (; i < count; i++)
    {
        var subpredicate = objj_msgSend(self._predicates, "objectAtIndex:", i),
            precedence = objj_msgSend(subpredicate, "predicateFormat");
        if (objj_msgSend(subpredicate, "isKindOfClass:", objj_msgSend(CPCompoundPredicate, "class")) && objj_msgSend(objj_msgSend(subpredicate, "subpredicates"), "count")> 1 && objj_msgSend(subpredicate, "compoundPredicateType") != self._type)
            precedence = objj_msgSend(CPString, "stringWithFormat:", "(%s)", precedence);
        if (precedence != nil)
            objj_msgSend(args, "addObject:", precedence);
    }
    switch (self._type)
    {
        case CPNotPredicateType: result += "NOT " + objj_msgSend(args, "objectAtIndex:", 0);
                                    break;
        case CPAndPredicateType: result += objj_msgSend(args, "objectAtIndex:", 0);
                                    var count = objj_msgSend(args, "count");
                                    for (var j = 1; j < count; j++)
                                        result += " AND " + objj_msgSend(args, "objectAtIndex:", j);
                                    break;
        case CPOrPredicateType: result += objj_msgSend(args, "objectAtIndex:", 0);
                                    var count = objj_msgSend(args, "count");
                                    for (var j = 1; j < count; j++)
                                        result += " OR " + objj_msgSend(args, "objectAtIndex:", j);
                                    break;
    }
    return result;
}
,["CPString"]), new objj_method(sel_getUid("evaluateWithObject:"), function $CPCompoundPredicate__evaluateWithObject_(self, _cmd, object)
{
    return objj_msgSend(self, "evaluateWithObject:substitutionVariables:", object, nil);
}
,["BOOL","id"]), new objj_method(sel_getUid("evaluateWithObject:substitutionVariables:"), function $CPCompoundPredicate__evaluateWithObject_substitutionVariables_(self, _cmd, object, variables)
{
    var result = NO,
        count = objj_msgSend(self._predicates, "count"),
        i = 0;
    if (count == 0)
        return YES;
    for (; i < count; i++)
    {
        var predicate = objj_msgSend(self._predicates, "objectAtIndex:", i);
        switch (self._type)
        {
            case CPNotPredicateType: return !objj_msgSend(predicate, "evaluateWithObject:substitutionVariables:", object, variables);
            case CPAndPredicateType: if (i == 0)
                                            result = objj_msgSend(predicate, "evaluateWithObject:substitutionVariables:", object, variables);
                                        else
                                            result = result && objj_msgSend(predicate, "evaluateWithObject:substitutionVariables:", object, variables);
                                        if (!result)
                                            return NO;
                                        break;
            case CPOrPredicateType: if (objj_msgSend(predicate, "evaluateWithObject:substitutionVariables:", object, variables))
                                            return YES;
                                        break;
        }
    }
    return result;
}
,["BOOL","id","CPDictionary"]), new objj_method(sel_getUid("isEqual:"), function $CPCompoundPredicate__isEqual_(self, _cmd, anObject)
{
    if (self === anObject)
        return YES;
    if (anObject.isa !== self.isa || self._type !== objj_msgSend(anObject, "compoundPredicateType") || !objj_msgSend(self._predicates, "isEqualToArray:", objj_msgSend(anObject, "subpredicates")))
        return NO;
    return YES;
}
,["BOOL","id"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("notPredicateWithSubpredicate:"), function $CPCompoundPredicate__notPredicateWithSubpredicate_(self, _cmd, predicate)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithType:subpredicates:", CPNotPredicateType, objj_msgSend(CPArray, "arrayWithObject:", predicate));
}
,["CPPredicate","CPPredicate"]), new objj_method(sel_getUid("andPredicateWithSubpredicates:"), function $CPCompoundPredicate__andPredicateWithSubpredicates_(self, _cmd, subpredicates)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithType:subpredicates:", CPAndPredicateType, subpredicates);
}
,["CPPredicate","CPArray"]), new objj_method(sel_getUid("orPredicateWithSubpredicates:"), function $CPCompoundPredicate__orPredicateWithSubpredicates_(self, _cmd, predicates)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithType:subpredicates:", CPOrPredicateType, predicates);
}
,["CPPredicate","CPArray"])]);
}
{
var the_class = objj_getClass("CPCompoundPredicate")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPCompoundPredicate\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPCompoundPredicate__initWithCoder_(self, _cmd, coder)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPCompoundPredicate").super_class }, "init");
    if (self != nil)
    {
        self._predicates = objj_msgSend(coder, "decodeObjectForKey:", "CPCompoundPredicateSubpredicates");
        self._type = objj_msgSend(coder, "decodeIntForKey:", "CPCompoundPredicateType");
    }
    return self;
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPCompoundPredicate__encodeWithCoder_(self, _cmd, coder)
{
    objj_msgSend(coder, "encodeObject:forKey:", self._predicates, "CPCompoundPredicateSubpredicates");
    objj_msgSend(coder, "encodeInt:forKey:", self._type, "CPCompoundPredicateType");
}
,["void","CPCoder"])]);
}p;31;CPCompoundPredicate_Constants.jt;87;@STATIC;1.0;t;70;CPNotPredicateType = 0;
CPAndPredicateType = 1;
CPOrPredicateType = 2;p;14;CPExpression.jt;695;@STATIC;1.0;i;15;_CPExpression.ji;28;_CPConstantValueExpression.ji;19;_CPSelfExpression.ji;23;_CPVariableExpression.ji;22;_CPKeyPathExpression.ji;23;_CPFunctionExpression.ji;24;_CPAggregateExpression.ji;18;_CPSetExpression.ji;23;_CPSubqueryExpression.jt;437;objj_executeFile("_CPExpression.j", YES);
objj_executeFile("_CPConstantValueExpression.j", YES);
objj_executeFile("_CPSelfExpression.j", YES);
objj_executeFile("_CPVariableExpression.j", YES);
objj_executeFile("_CPKeyPathExpression.j", YES);
objj_executeFile("_CPFunctionExpression.j", YES);
objj_executeFile("_CPAggregateExpression.j", YES);
objj_executeFile("_CPSetExpression.j", YES);
objj_executeFile("_CPSubqueryExpression.j", YES);p;13;CPPredicate.jt;289;@STATIC;1.0;i;14;_CPPredicate.ji;21;CPCompoundPredicate.ji;23;CPComparisonPredicate.ji;14;CPExpression.jt;179;objj_executeFile("_CPPredicate.j", YES);
objj_executeFile("CPCompoundPredicate.j", YES);
objj_executeFile("CPComparisonPredicate.j", YES);
objj_executeFile("CPExpression.j", YES);p;23;_CPConcreteMutableSet.jt;3621;@STATIC;1.0;i;14;CPMutableSet.jt;3583;


objj_executeFile("CPMutableSet.j", YES);


var hasOwnProperty = Object.prototype.hasOwnProperty;






{var the_class = objj_allocateClassPair(CPMutableSet, "_CPConcreteMutableSet"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_contents"), new objj_ivar("_count")]);


























objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithObjects:count:"), function $_CPConcreteMutableSet__initWithObjects_count_(self, _cmd, objects, aCount)
{
    self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("_CPConcreteMutableSet").super_class }, "initWithObjects:count:", objects, aCount);

    if (self)
    {
        self._count = 0;
        self._contents = { };

        var index = 0,
            count = MIN(objj_msgSend(objects, "count"), aCount);

        for (; index < count; ++index)
            objj_msgSend(self, "addObject:", objects[index]);
    }

    return self;
}
,["id","CPArray","CPUInteger"]), new objj_method(sel_getUid("count"), function $_CPConcreteMutableSet__count(self, _cmd)
{
    return self._count;
}
,["CPUInteger"]), new objj_method(sel_getUid("member:"), function $_CPConcreteMutableSet__member_(self, _cmd, anObject)
{
    var UID = objj_msgSend(anObject, "UID");

    if (hasOwnProperty.call(self._contents, UID))
        return self._contents[UID];
    else
    {
        for (var objectUID in self._contents)
        {
            if (!hasOwnProperty.call(self._contents, objectUID))
                continue;

            var object = self._contents[objectUID];

            if (object === anObject || objj_msgSend(object, "isEqual:", anObject))
                return object;
        }
    }

    return nil;
}
,["id","id"]), new objj_method(sel_getUid("allObjects"), function $_CPConcreteMutableSet__allObjects(self, _cmd)
{
    var array = [],
        property;

    for (property in self._contents)
    {
        if (hasOwnProperty.call(self._contents, property))
            array.push(self._contents[property]);
    }

    return array;
}
,["CPArray"]), new objj_method(sel_getUid("objectEnumerator"), function $_CPConcreteMutableSet__objectEnumerator(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "allObjects"), "objectEnumerator");
}
,["CPEnumerator"]), new objj_method(sel_getUid("addObject:"), function $_CPConcreteMutableSet__addObject_(self, _cmd, anObject)
{
    if (anObject === nil || anObject === undefined)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "attempt to insert nil or undefined");

    if (objj_msgSend(self, "containsObject:", anObject))
        return;

    self._contents[objj_msgSend(anObject, "UID")] = anObject;
    self._count++;
}
,["void","id"]), new objj_method(sel_getUid("removeObject:"), function $_CPConcreteMutableSet__removeObject_(self, _cmd, anObject)
{

    if (anObject === nil || anObject === undefined)
        objj_msgSend(CPException, "raise:reason:", CPInvalidArgumentException, "attempt to remove nil or undefined");


    var object = objj_msgSend(self, "member:", anObject);


    if (object !== nil)
    {
        delete self._contents[objj_msgSend(object, "UID")];
        self._count--;
    }
}
,["void","id"]), new objj_method(sel_getUid("removeAllObjects"), function $_CPConcreteMutableSet__removeAllObjects(self, _cmd)
{
    self._contents = {};
    self._count = 0;
}
,["void"]), new objj_method(sel_getUid("classForCoder"), function $_CPConcreteMutableSet__classForCoder(self, _cmd)
{
    return objj_msgSend(CPSet, "class");
}
,["Class"])]);
}p;8;_CPSet.jt;13126;@STATIC;1.0;i;9;CPArray.ji;14;CPEnumerator.ji;10;CPNumber.ji;10;CPObject.jt;13044;objj_executeFile("CPArray.j", YES);
objj_executeFile("CPEnumerator.j", YES);
objj_executeFile("CPNumber.j", YES);
objj_executeFile("CPObject.j", YES);
//@class _CPConcreteMutableSet
{var the_class = objj_allocateClassPair(CPObject, "CPSet"),
meta_class = the_class.isa;
































objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("setByAddingObject:"), function $CPSet__setByAddingObject_(self, _cmd, anObject)
{
    return objj_msgSend(objj_msgSend(self, "class"), "setWithArray:", objj_msgSend(objj_msgSend(self, "allObjects"), "arrayByAddingObject:", anObject));
}
,["id","id"]), new objj_method(sel_getUid("setByAddingObjectsFromSet:"), function $CPSet__setByAddingObjectsFromSet_(self, _cmd, aSet)
{
    return objj_msgSend(self, "setByAddingObjectsFromArray:", objj_msgSend(aSet, "allObjects"));
}
,["id","CPSet"]), new objj_method(sel_getUid("setByAddingObjectsFromArray:"), function $CPSet__setByAddingObjectsFromArray_(self, _cmd, anArray)
{
    return objj_msgSend(objj_msgSend(self, "class"), "setWithArray:", objj_msgSend(objj_msgSend(self, "allObjects"), "arrayByAddingObjectsFromArray:", anArray));
}
,["id","CPArray"]), new objj_method(sel_getUid("init"), function $CPSet__init(self, _cmd)
{
    return objj_msgSend(self, "initWithObjects:count:", nil, 0);
}
,["id"]), new objj_method(sel_getUid("initWithArray:"), function $CPSet__initWithArray_(self, _cmd, anArray)
{
    return objj_msgSend(self, "initWithObjects:count:", anArray, objj_msgSend(anArray, "count"));
}
,["id","CPArray"]), new objj_method(sel_getUid("initWithObjects:"), function $CPSet__initWithObjects_(self, _cmd, anObject)
{
    var index = 2,
        count = arguments.length;
    for (; index < count; ++index)
        if (arguments[index] === nil)
            break;
    return objj_msgSend(self, "initWithObjects:count:", Array.prototype.slice.call(arguments, 2, index), index - 2);
}
,["id","id"]), new objj_method(sel_getUid("initWithObjects:count:"), function $CPSet__initWithObjects_count_(self, _cmd, objects, aCount)
{
    if (self === _CPSharedPlaceholderSet)
        return objj_msgSend(objj_msgSend(_CPConcreteMutableSet, "alloc"), "initWithObjects:count:", objects, aCount);
    return objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPSet").super_class }, "init");
}
,["id","CPArray","CPUInteger"]), new objj_method(sel_getUid("initWithSet:"), function $CPSet__initWithSet_(self, _cmd, aSet)
{
    return objj_msgSend(self, "initWithArray:", objj_msgSend(aSet, "allObjects"));
}
,["id","CPSet"]), new objj_method(sel_getUid("initWithSet:copyItems:"), function $CPSet__initWithSet_copyItems_(self, _cmd, aSet, shouldCopyItems)
{
    if (shouldCopyItems)
        return objj_msgSend(aSet, "valueForKey:", "copy");
    return objj_msgSend(self, "initWithSet:", aSet);
}
,["id","CPSet","BOOL"]), new objj_method(sel_getUid("count"), function $CPSet__count(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["CPUInteger"]), new objj_method(sel_getUid("allObjects"), function $CPSet__allObjects(self, _cmd)
{
    var objects = [],
        object,
        objectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        objects.push(object);
    return objects;
}
,["CPArray"]), new objj_method(sel_getUid("anyObject"), function $CPSet__anyObject(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "objectEnumerator"), "nextObject");
}
,["id"]), new objj_method(sel_getUid("containsObject:"), function $CPSet__containsObject_(self, _cmd, anObject)
{
    return objj_msgSend(self, "member:", anObject) !== nil;
}
,["BOOL","id"]), new objj_method(sel_getUid("filteredSetUsingPredicate:"), function $CPSet__filteredSetUsingPredicate_(self, _cmd, aPredicate)
{
    var objects = [],
        object,
        objectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        if (objj_msgSend(aPredicate, "evaluateWithObject:", object))
            objects.push(object);
    return objj_msgSend(objj_msgSend(objj_msgSend(self, "class"), "alloc"), "initWithArray:", objects);
}
,["CPSet","CPPredicate"]), new objj_method(sel_getUid("makeObjectsPerformSelector:"), function $CPSet__makeObjectsPerformSelector_(self, _cmd, aSelector)
{
    objj_msgSend(self, "makeObjectsPerformSelector:withObjects:", aSelector, nil);
}
,["void","SEL"]), new objj_method(sel_getUid("makeObjectsPerformSelector:withObject:"), function $CPSet__makeObjectsPerformSelector_withObject_(self, _cmd, aSelector, anObject)
{
    objj_msgSend(self, "makeObjectsPerformSelector:withObjects:", aSelector, [anObject]);
}
,["void","SEL","id"]), new objj_method(sel_getUid("makeObjectsPerformSelector:withObjects:"), function $CPSet__makeObjectsPerformSelector_withObjects_(self, _cmd, aSelector, objects)
{
    var object,
        objectEnumerator = objj_msgSend(self, "objectEnumerator"),
        argumentsArray = [nil, aSelector].concat(objects || []);
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
    {
        argumentsArray[0] = object;
        objj_msgSend.apply(this, argumentsArray);
    }
}
,["void","SEL","CPArray"]), new objj_method(sel_getUid("member:"), function $CPSet__member_(self, _cmd, anObject)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["id","id"]), new objj_method(sel_getUid("objectEnumerator"), function $CPSet__objectEnumerator(self, _cmd)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["CPEnumerator"]), new objj_method(sel_getUid("enumerateObjectsUsingBlock:"), function $CPSet__enumerateObjectsUsingBlock_(self, _cmd, aFunction)
{
    var object,
        objectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        if (aFunction(object))
            break;
}
,["void","Function"]), new objj_method(sel_getUid("objectsPassingTest:"), function $CPSet__objectsPassingTest_(self, _cmd, aFunction)
{
    var objects = [],
        object = nil,
        objectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        if (aFunction(object))
            objects.push(object);
    return objj_msgSend(objj_msgSend(objj_msgSend(self, "class"), "alloc"), "initWithArray:", objects);
}
,["CPSet","Function"]), new objj_method(sel_getUid("isSubsetOfSet:"), function $CPSet__isSubsetOfSet_(self, _cmd, aSet)
{
    var object = nil,
        objectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        if (!objj_msgSend(aSet, "containsObject:", object))
            return NO;
    return YES;
}
,["BOOL","CPSet"]), new objj_method(sel_getUid("intersectsSet:"), function $CPSet__intersectsSet_(self, _cmd, aSet)
{
    if (self === aSet)
        return objj_msgSend(self, "count") > 0;
    var object = nil,
        objectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        if (objj_msgSend(aSet, "containsObject:", object))
            return YES;
    return NO;
}
,["BOOL","CPSet"]), new objj_method(sel_getUid("sortedArrayUsingDescriptors:"), function $CPSet__sortedArrayUsingDescriptors_(self, _cmd, someSortDescriptors)
{
    return objj_msgSend(objj_msgSend(self, "allObjects"), "sortedArrayUsingDescriptors:", someSortDescriptors);
}
,["CPArray","CPArray"]), new objj_method(sel_getUid("isEqualToSet:"), function $CPSet__isEqualToSet_(self, _cmd, aSet)
{
    return objj_msgSend(self, "isEqual:", aSet);
}
,["BOOL","CPSet"]), new objj_method(sel_getUid("isEqual:"), function $CPSet__isEqual_(self, _cmd, aSet)
{
    return self === aSet ||
            objj_msgSend(aSet, "isKindOfClass:", objj_msgSend(CPSet, "class")) &&
            (objj_msgSend(self, "count") === objj_msgSend(aSet, "count") &&
            objj_msgSend(aSet, "isSubsetOfSet:", self));
}
,["BOOL","CPSet"]), new objj_method(sel_getUid("description"), function $CPSet__description(self, _cmd)
{
    var string = "{(\n",
        objects = objj_msgSend(self, "allObjects"),
        index = 0,
        count = objj_msgSend(objects, "count");
    for (; index < count; ++index)
    {
        var object = objects[index];
        string += "\t" + String(object).split('\n').join("\n\t") + "\n";
    }
    return string + ")}";
}
,["CPString"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $CPSet__alloc(self, _cmd)
{
    if (self === objj_msgSend(CPSet, "class") || self === objj_msgSend(CPMutableSet, "class"))
        return objj_msgSend(_CPPlaceholderSet, "alloc");
    return objj_msgSendSuper({ receiver:self, super_class:objj_getMetaClass("CPSet").super_class }, "alloc");
}
,["id"]), new objj_method(sel_getUid("set"), function $CPSet__set(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "init");
}
,["id"]), new objj_method(sel_getUid("setWithArray:"), function $CPSet__setWithArray_(self, _cmd, anArray)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithArray:", anArray);
}
,["id","CPArray"]), new objj_method(sel_getUid("setWithObject:"), function $CPSet__setWithObject_(self, _cmd, anObject)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithObjects:", anObject);
}
,["id","id"]), new objj_method(sel_getUid("setWithObjects:count:"), function $CPSet__setWithObjects_count_(self, _cmd, objects, count)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithObjects:count:", objects, count);
}
,["id","id","CPUInteger"]), new objj_method(sel_getUid("setWithObjects:"), function $CPSet__setWithObjects_(self, _cmd, anObject)
{
    var argumentsArray = Array.prototype.slice.apply(arguments);
    argumentsArray[0] = objj_msgSend(self, "alloc");
    argumentsArray[1] = sel_getUid("initWithObjects:");
    return objj_msgSend.apply(this, argumentsArray);
}
,["id","id"]), new objj_method(sel_getUid("setWithSet:"), function $CPSet__setWithSet_(self, _cmd, set)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithSet:", set);
}
,["id","CPSet"])]);
}
{
var the_class = objj_getClass("CPSet")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPSet\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("copy"), function $CPSet__copy(self, _cmd)
{
    return objj_msgSend(objj_msgSend(self, "class"), "setWithSet:", self);
}
,["id"]), new objj_method(sel_getUid("mutableCopy"), function $CPSet__mutableCopy(self, _cmd)
{
    return objj_msgSend(self, "copy");
}
,["id"])]);
}
var CPSetObjectsKey = "CPSetObjectsKey";
{
var the_class = objj_getClass("CPSet")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPSet\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $CPSet__initWithCoder_(self, _cmd, aCoder)
{
    return objj_msgSend(self, "initWithArray:", objj_msgSend(aCoder, "decodeObjectForKey:", CPSetObjectsKey));
}
,["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $CPSet__encodeWithCoder_(self, _cmd, aCoder)
{
    objj_msgSend(aCoder, "encodeObject:forKey:", objj_msgSend(self, "allObjects"), CPSetObjectsKey);
}
,["void","CPCoder"])]);
}
{
var the_class = objj_getClass("CPSet")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"CPSet\"");
var meta_class = the_class.isa;
class_addMethods(the_class, [new objj_method(sel_getUid("valueForKey:"), function $CPSet__valueForKey_(self, _cmd, aKey)
{
    if (aKey === "@count")
        return objj_msgSend(self, "count");
    var valueSet = objj_msgSend(CPSet, "set"),
        object,
        objectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
    {
        var value = objj_msgSend(object, "valueForKey:", aKey);
        objj_msgSend(valueSet, "addObject:", value);
    }
    return valueSet;
}
,["id","CPString"]), new objj_method(sel_getUid("setValue:forKey:"), function $CPSet__setValue_forKey_(self, _cmd, aValue, aKey)
{
    var object,
        objectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        objj_msgSend(object, "setValue:forKey:", aValue, aKey);
}
,["void","id","CPString"])]);
}
var _CPSharedPlaceholderSet = nil;
{var the_class = objj_allocateClassPair(CPSet, "_CPPlaceholderSet"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(meta_class, [new objj_method(sel_getUid("alloc"), function $_CPPlaceholderSet__alloc(self, _cmd)
{
    if (!_CPSharedPlaceholderSet)
        _CPSharedPlaceholderSet = objj_msgSendSuper({ receiver:self, super_class:objj_getMetaClass("_CPPlaceholderSet").super_class }, "alloc");
    return _CPSharedPlaceholderSet;
}
,["id"])]);
}p;14;CPMutableSet.jt;3643;@STATIC;1.0;i;8;_CPSet.jt;3612;objj_executeFile("_CPSet.j", YES);
{var the_class = objj_allocateClassPair(CPSet, "CPMutableSet"),
meta_class = the_class.isa;

  







objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithCapacity:"), function $CPMutableSet__initWithCapacity_(self, _cmd, aCapacity)
{
    return objj_msgSend(self, "init");
}
,["id","unsigned"]), new objj_method(sel_getUid("filterUsingPredicate:"), function $CPMutableSet__filterUsingPredicate_(self, _cmd, aPredicate)
{
    var object,
        objectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        if (!objj_msgSend(aPredicate, "evaluateWithObject:", object))
            objj_msgSend(self, "removeObject:", object);
}
,["void","CPPredicate"]), new objj_method(sel_getUid("removeObject:"), function $CPMutableSet__removeObject_(self, _cmd, anObject)
{
    _CPRaiseInvalidAbstractInvocation(self, _cmd);
}
,["void","id"]), new objj_method(sel_getUid("removeObjectsInArray:"), function $CPMutableSet__removeObjectsInArray_(self, _cmd, anArray)
{
    var index = 0,
        count = objj_msgSend(anArray, "count");
    for (; index < count; ++index)
        objj_msgSend(self, "removeObject:", objj_msgSend(anArray, "objectAtIndex:", index));
}
,["void","CPArray"]), new objj_method(sel_getUid("removeAllObjects"), function $CPMutableSet__removeAllObjects(self, _cmd)
{
    var object,
        objectEnumerator = objj_msgSend(self, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        objj_msgSend(self, "removeObject:", object);
}
,["void"]), new objj_method(sel_getUid("addObjectsFromArray:"), function $CPMutableSet__addObjectsFromArray_(self, _cmd, objects)
{
    var count = objj_msgSend(objects, "count");
    while (count--)
        objj_msgSend(self, "addObject:", objects[count]);
}
,["void","CPArray"]), new objj_method(sel_getUid("unionSet:"), function $CPMutableSet__unionSet_(self, _cmd, aSet)
{
    var object,
        objectEnumerator = objj_msgSend(aSet, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        objj_msgSend(self, "addObject:", object);
}
,["void","CPSet"]), new objj_method(sel_getUid("minusSet:"), function $CPMutableSet__minusSet_(self, _cmd, aSet)
{
    var object,
        objectEnumerator = objj_msgSend(aSet, "objectEnumerator");
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        objj_msgSend(self, "removeObject:", object);
}
,["void","CPSet"]), new objj_method(sel_getUid("intersectSet:"), function $CPMutableSet__intersectSet_(self, _cmd, aSet)
{
    var object,
        objectEnumerator = objj_msgSend(self, "objectEnumerator"),
        objectsToRemove = [];
    while ((object = objj_msgSend(objectEnumerator, "nextObject")) !== nil)
        if (!objj_msgSend(aSet, "containsObject:", object))
            objectsToRemove.push(object);
    var count = objj_msgSend(objectsToRemove, "count");
    while (count--)
        objj_msgSend(self, "removeObject:", objectsToRemove[count]);
}
,["void","CPSet"]), new objj_method(sel_getUid("setSet:"), function $CPMutableSet__setSet_(self, _cmd, aSet)
{
    objj_msgSend(self, "removeAllObjects");
    objj_msgSend(self, "unionSet:", aSet);
}
,["void","CPSet"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("setWithCapacity:"), function $CPMutableSet__setWithCapacity_(self, _cmd, aCapacity)
{
    return objj_msgSend(objj_msgSend(self, "alloc"), "initWithCapacity:", aCapacity);
}
,["id","CPUInteger"])]);
}p;7;CPSet.jt;95;@STATIC;1.0;i;23;_CPConcreteMutableSet.jt;50; objj_executeFile("_CPConcreteMutableSet.j", YES);e;