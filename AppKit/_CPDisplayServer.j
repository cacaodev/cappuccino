/*
 * _CPDisplayServer.j
 * AppKit
 *
 * Created by Francisco Tolmasky.
 * Copyright 2009, 280 North, Inc.
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

@import <Foundation/CPRunLoop.j>

PREPARE_DOM_OPTIMIZATION();

var displayObjects      = [],
    displayObjectsByUID = { },

    layoutObjects       = [],
    layoutObjectsByUID  = { },

    constraintsUpdateObjects       = [],
    constraintsUpdateObjectsByUID  = { },

    runLoop             = [CPRunLoop mainRunLoop],
    objectsCount        = 0,
    locked              = 0;

function _CPDisplayServerAddDisplayObject(anObject)
{
    var UID = [anObject UID];

    if (typeof displayObjectsByUID[UID] !== "undefined")
        return;

    var index = displayObjects.length;

    displayObjectsByUID[UID] = index;
    displayObjects[index] = anObject;
    objectsCount++;
}

function _CPDisplayServerAddLayoutObject(anObject)
{
    var UID = [anObject UID];

    if (typeof layoutObjectsByUID[UID] !== "undefined")
        return;

    var index = layoutObjects.length;

    layoutObjectsByUID[UID] = index;
    layoutObjects[index] = anObject;
    objectsCount++;
}

function _CPDisplayServerAddConstraintsUpdateObject(anObject)
{
    var UID = [anObject UID];

    if (typeof constraintsUpdateObjectsByUID[UID] !== "undefined")
        return;

    var index = constraintsUpdateObjects.length;

    constraintsUpdateObjectsByUID[UID] = index;
    constraintsUpdateObjects[index] = anObject;
    objectsCount++;
}

@implementation _CPDisplayServer : CPObject
{
}

+ (void)lock
{
    locked++;
}

+ (void)unlock
{
    locked = MAX(locked - 1, 0);
}

+ (void)run
{
    while (locked == 0 && (displayObjects.length || layoutObjects.length || constraintsUpdateObjects.length))
    {
        var index = 0;

        for (; index < constraintsUpdateObjects.length; ++index)
        {
            var object = constraintsUpdateObjects[index];

            delete constraintsUpdateObjectsByUID[[object UID]];
            objectsCount--;
            [object updateConstraintsIfNeeded];
        }

        constraintsUpdateObjects = [];
        constraintsUpdateObjectsByUID = { };

        index = 0;

        for (; index < layoutObjects.length; ++index)
        {
            var object = layoutObjects[index];

            delete layoutObjectsByUID[[object UID]];
            objectsCount--;
            [object layoutIfNeeded];
        }

        layoutObjects = [];
        layoutObjectsByUID = { };

        index = 0;

        for (; index < displayObjects.length; ++index)
        {
            if (layoutObjects.length)
                break;

            var object = displayObjects[index];

            delete displayObjectsByUID[[object UID]];
            objectsCount--;
            [object displayIfNeeded];
        }

        if (index === displayObjects.length)
        {
            displayObjects = [];
            displayObjectsByUID = { };
        }
        else
            displayObjects.splice(0, index);
    }

    [runLoop performSelector:@selector(run) target:self argument:nil order:0 modes:[CPDefaultRunLoopMode]];
}

@end

[_CPDisplayServer run];
