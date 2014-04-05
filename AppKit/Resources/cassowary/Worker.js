/*
    A WebWorker wrapping cassowary js https://github.com/slightlyoff/cassowary.js

// Copyright (C) 1998-2000 Greg J. Badros
// Use of this source code is governed by http://www.apache.org/licenses/LICENSE-2.0
//
// Parts Copyright (C) 2011-2012, Alex Russell (slightlyoff@chromium.org)
// Parts Copyright (C) 2013, cacaodev (cacaodev@google.com)
*/

importScripts("src/c.js");
importScripts("src/HashTable.js");
importScripts("src/HashSet.js");
importScripts("src/Error.js");
importScripts("src/SymbolicWeight.js");
importScripts("src/Strength.js");
importScripts("src/Variable.js");
importScripts("src/Point.js");
importScripts("src/Expression.js");
importScripts("src/Constraint.js");
importScripts("src/EditInfo.js");
importScripts("src/Tableau.js");
importScripts("src/SimplexSolver.js");

importScripts("CassowaryBridge.js");

self.initDone = false;

function returnMessage(type, result)
{
    //  Send a message back to the main thread with the result

    self.postMessage({type:type, result:result});
}
// Our webworker registers for an message event so we can talk
// to it from our main thread and ask it to do something.
self.addEventListener('message', function(e)
{
    if (!self.initDone)
    {
        InitCassowaryFunctions(self);
        self.initDone = true;
    }

    var messages = e.data;

    messages.forEach(function(message)
    {
        var command = self[message.command],
            result = command(message.args);

        if (message.callback)
            self.postMessage({type:"callback", uuid:message.callback, result:result});
    });

}, false);
