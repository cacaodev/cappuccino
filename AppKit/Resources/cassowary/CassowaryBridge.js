CPLayoutRelationLessThanOrEqual = -1;
CPLayoutRelationEqual = 0;
CPLayoutRelationGreaterThanOrEqual = 1;

CPLayoutConstraintOrientationHorizontal = 0;
CPLayoutConstraintOrientationVertical = 1;

CPLayoutAttributeLeft       = 1;
CPLayoutAttributeRight      = 2;
CPLayoutAttributeTop        = 3;
CPLayoutAttributeBottom     = 4;
CPLayoutAttributeLeading    = 5;
CPLayoutAttributeTrailing   = 6;
CPLayoutAttributeWidth      = 7;
CPLayoutAttributeHeight     = 8;
CPLayoutAttributeCenterX    = 9;
CPLayoutAttributeCenterY    = 10;
CPLayoutAttributeBaseline   = 11;

CPLayoutAttributeNotAnAttribute = 0;

LayoutVariableConstant = 0;
LayoutVariableLeft     = 2;
LayoutVariableTop      = 4;
LayoutVariableWidth    = 8;
LayoutVariableHeight   = 16;

InitCassowaryFunctions = function(scope)
{

scope.DISABLE_ON_SOLVED_NOTIFICATIONS = false;

scope.VARIABLES_MAP = {};

scope.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP = [];

scope.EDIT_CONTEXT = null;

scope.EDITVARS_FOR_CONTEXT = {};

scope.solver = null;

scope.setDisableOnSolvedNotification = function(flag)
                                 {
                                     scope.solver.onvaluechange = flag ? onValueChange : scope.noop;
                                     scope.solver.onSolved = flag ? onSolved : scope.noop;
                                 };
scope.createSolver  = function()
                {
                    var simplexSolver = new c.SimplexSolver();
                    simplexSolver.autoSolve = false;
                    simplexSolver.onvaluechange = onValueChange;
                    simplexSolver.onsolved = onSolved;
                    scope.solver = simplexSolver;
                    WorkerLog('created solver');

                    return simplexSolver;
                };

scope.solve = function()
                {
                    if (!scope.SolverExists('solve'))
                        return;

                    scope.solver.solve();

                    WorkerLog("solve");
                };

scope.info = function()
                {
                    var info = scope.solver.toString();
                    WorkerLog(info);

                    return info;
                };

scope.getconstraints = function()
                {
                    var str = "";

                    scope.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.forEach(function(w)
                    {
                        str += w.type + " " + w.constraint.toString() + "\n";
                    });

                    WorkerLog(str);
                };

scope.addConstraint = function(json)
                {
                    if (!scope.SolverExists('addConstraint'))
                        return;

                    var type = json.type,
                        constraints = [];

                    if (type == "Constraint")
                    {
                        var newConstraint = scope.CreateConstraint(json);
                        constraints.push(newConstraint);
                    }
                    else if (type == "SizeConstraint")
                    {
                        var newConstraints = scope.CreateSizeConstraints(json);
                        constraints.push.apply(constraints, newConstraints);
                    }

                    constraints.forEach(function(constraint)
                    {
                        scope.solver.addConstraint(constraint);
                        WorkerLog('addConstraint uuid: ' + json.uuid  + " type: " + type + " cst:" + constraint.toString());
                    });

                    return constraints;
                };

scope.addConstraints = function(jsonarray)
                 {
                     var add = scope.addConstraint;

                     jsonarray.forEach(function(json)
                     {
                         scope.addConstraint(json);
                     });
                 };

scope.removeConstraint = function(casso_constraint)
                   {
                       var error = null;

                       try
                       {
                           scope.solver.removeConstraint(casso_constraint);
                       }
                       catch (e)
                       {
                           error = e;
                       }
                       finally
                       {
                           if (error)
                               WorkerWarn(error.toString());
                            else
                               WorkerLog('removed constraint :' + casso_constraint.toString());
                       }

                       return (error == null);
                   };
// Replace all contraints of the given type owned by the given container.
scope.replaceConstraints = function(args)
                    {
                        var container = args.container,
                            type = args.type,
                            json_constraints = args.constraints;

                        var constraints_by_view_and_type = scope.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP;
                        var i = constraints_by_view_and_type.length;
// remove
                        while(i--)
                        {
                            var constraint_view_type = constraints_by_view_and_type[i];
                            if (constraint_view_type.container == container && constraint_view_type.type == type)
                            {
                                scope.removeConstraint(constraint_view_type.constraint);
                                constraints_by_view_and_type.splice(i, 1);
                            }
                        }
// add
                        json_constraints.forEach(function(json)
                        {
                            var casso_constraints = scope.addConstraint(json);

                            casso_constraints.forEach(function(constraint)
                            {
                                var wrapper = {uuid:json.uuid, container:container, type:json.type, constraint:constraint};
                                constraints_by_view_and_type.push(wrapper);
                            });
                        });
                    };

scope.updateSizeConstraints = function(args)
                    {
                        var container = args.container,
                            json_constraints = args.constraints;

                        json_constraints.forEach(function(json)
                        {
                            var uuid = json.uuid;

                            // Removes constraints for both hugging and antiCompression
                            scope.removeConstraintWithUUID(uuid, "SizeConstraint");

                            var casso_constraints = scope.addConstraint(json);

                            casso_constraints.forEach(function(casso_constraint)
                            {
                                var wrapper = {uuid:uuid, container:container, type:"SizeConstraint", constraint:casso_constraint};

                                scope.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.push(wrapper);
                            });
                        });

                        scope.solver.solve();
                    };

scope.setEditVarsForContext = function(args)
                        {
                            var tags = args.tags,
                                identifier = args.identifier,
                                priority = args.priority,
                                editVars = [];

                            tags.forEach(function(tag)
                            {
                               var variable = scope.GetVariable(identifier, tag);
                               editVars.push({variable:variable, priority:priority});
                            });

                            scope.EDITVARS_FOR_CONTEXT[identifier] = editVars;
                        };

scope.removeAllEditVars = function()
                    {
                        scope.solver.removeAllEditVars();
                        scope.EDIT_CONTEXT = null;
                    };

scope.suggestValue = function(args)
               {
                   if (!scope.SolverExists('suggestValue'))
                        return;

                   var solver = scope.solver,
                       variable = scope.GetVariable(args.identifier, args.tag),
                       sw = scope.StrengthAndWeight(args.priority);

                   if (scope.EDIT_CONTEXT !== null)
                       solver.removeAllEditVars();

                   solver.addEditVar(variable, sw.strength, sw.weight).beginEdit();
                   solver.suggestValue(variable, args.value);
                   solver.endEdit();

                   scope.EDIT_CONTEXT = args.identifier;

                   WorkerLog("suggestValue " + args.value + " for " + variable.toString());
               };

scope.suggestValuesMultiple = function(args)
                        {
                            scope.suggestValues(args.values, args.context);
                            //WorkerLog("suggestValuesMultiple");
                        };

scope.addStayVariable = function(variable, priority)
          {
              WorkerLog('this is ' + this);

              if (!scope.SolverExists('addStay'))
                  return;

              var sw = scope.StrengthAndWeight(priority),
                  container = variable._identifier,
                  uuid = container + "_" + variable._tag,
                  stayConstraint = new c.StayConstraint(variable, sw.strength, sw.weight);

              var replace_count = scope.removeConstraintWithUUID(uuid);

              scope.solver.addConstraint(stayConstraint);

              var wrapper = {uuid:uuid ,container:container, type:"Stay", constraint:stayConstraint};
              scope.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.push(wrapper);

              WorkerLog('add Stay ' + variable.toString() + ' replacing ' + replace_count);
          };

scope.addStay = function(args)
{
    var variable = scope.CPViewLayoutVariable(args.identifier, args.prefix, args.tag, args.value),
        priority = args.priority;

    scope.addStayVariable(variable, priority);
};

scope.removeConstraintWithUUID = function(uuid, type)
{
    var constraints_list = scope.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP,
        count = constraints_list.length,
        ret = 0;

    while(count--)
    {
        var w = constraints_list[count];

        if ((type == null || w.type == type) && w.uuid == uuid)
        {
            ret += scope.removeConstraint(w.constraint);
            constraints_list.splice(count, 1);

            if (type !== "SizeConstraint")
                break;
        }
    }

    return ret;
};

scope.suggestValues = function(values, context)
{
    var solver = scope.solver,
        editVars = scope.EDITVARS_FOR_CONTEXT[context];

    if (context !== scope.EDIT_CONTEXT)
    {
        try
        {
            if (scope.EDIT_CONTEXT !== null)
                solver.removeAllEditVars();

            editVars.forEach(function(editVar)
            {
                var sw = scope.StrengthAndWeight(editVar.priority);
                solver.addEditVar(editVar.variable, sw.strength, sw.weight);
            });
        }
        catch (e)
        {
            returnMessage('warn', e);
        }

        scope.EDIT_CONTEXT = context;
    }

    editVars.forEach(function(editVar, idx)
    {
        solver.suggestValue(editVar.variable, values[idx]);
    });

    solver.resolve();
};

scope.noop = function()
{
};

scope.SolverExists = function(command)
{
    if (scope.solver == null)
    {
        returnMessage('warn', 'Asked to ' + command + ' but inexistent solver');
        return false;
    }

    return true;
};

// get variable from the cache only.
scope.GetVariable = function(anIdentifier, aTag)
{
    // Unique
    var variable_hash = anIdentifier + "_" + aTag;

    return scope.VARIABLES_MAP[variable_hash];
};

// get variable from the cache or create a new one.
scope.CPViewLayoutVariable = function(anIdentifier, aPrefix, aTag, aValue)
{
    var variable_hash = anIdentifier + "_" + aTag,
        variable = scope.VARIABLES_MAP[variable_hash];

    if (typeof variable == 'undefined')
    {
        var name;

        switch (aTag)
        {
            case 0 : name = "H";
            break;
            case 1 : name = "V";
            break;
            case LayoutVariableLeft     : name = "x";
            break;
            case LayoutVariableTop      : name = "y";
            break;
            case LayoutVariableWidth    : name = "width";
            break;
            case LayoutVariableHeight   : name = "height";
            break;
            default: name = "";
        }

        variable = new c.Variable({prefix:aPrefix, name:name, value:aValue, identifier:anIdentifier, tag:aTag});
        scope.VARIABLES_MAP[variable_hash] = variable;

        //if (aTag == LayoutVariableWidth || aTag == LayoutVariableHeight)
        //    scope.restrictToNonNegative(variable);
    }

    return variable;
};
/*
var restrictToNonNegative = function(aVariable)
{
    var restricted = new c.Inequality(new c.Expression.fromVariable(aVariable), c.GEQ, new c.Expression.fromConstant(0), c.Strength.medium, 10000);

    worker.caller.solver.addConstraint(restricted);

    var wrapper = {container:null, type:"restricted", constraint:restricted};
    worker.caller.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.push(wrapper);
};
*/
scope.StrengthAndWeight = function(p)
{
/*
    var h = Math.floor(p / 100),
        d = Math.floor((p - 100*c) / 10),
        n = p - 100*c - 10*d;
*/

    return {strength:(new c.Strength("Custom", 0, 1, 0)), weight:p};
};

scope.CreateConstraint = function(args)
{
    var firstItemArgs   = args.firstItem,
        secondItemArgs  = args.secondItem,
        firstItemUUID   = firstItemArgs.uuid,
        secondItemUUID  = secondItemArgs.uuid,
        containerUUID   = args.containerUUID,
        relation        = args.relation,
        multiplier      = args.multiplier,
        constant        = args.constant,
        priority        = args.priority,
        sw              = scope.StrengthAndWeight(priority),
        constraint;

    var first = scope.expressionForAttribute(firstItemArgs, (containerUUID === firstItemUUID), (firstItemUUID === null)),
        second = scope.expressionForAttribute(secondItemArgs, (containerUUID === secondItemUUID), (secondItemUUID === null));

    var msecond = (!(second.isConstant && second.constant == 0) && multiplier !== 0) ? c.plus(c.times(second, multiplier), constant) : constant;

    switch(relation)
    {
        case CPLayoutRelationLessThanOrEqual    : constraint = new c.Inequality(first, c.LEQ, msecond, sw.strength, sw.weight);
            break;
        case CPLayoutRelationGreaterThanOrEqual : constraint = new c.Inequality(first, c.GEQ, msecond, sw.strength, sw.weight);
            break;
        case CPLayoutRelationEqual              : constraint = new c.Equation(first, msecond, sw.strength, sw.weight);
            break;
    }

    return constraint;
};

scope.CreateSizeConstraints = function(args)
{
    var container = args.firstItemUID,
        tag = args.orientation ? LayoutVariableHeight : LayoutVariableWidth;

    var sizeVariable = scope.CPViewLayoutVariable(container, args.firstItemName, tag, args.value),
        variableExp = new c.Expression.fromVariable(sizeVariable),
        constantExp = new c.Expression.fromConstant(args.constant),
        huggingSw = scope.StrengthAndWeight(args.huggingPriority),
        compressionSw = scope.StrengthAndWeight(args.compressionPriority);

    var huggingConstraint = new c.Inequality(variableExp, c.LEQ, constantExp, huggingSw.strength, huggingSw.weight),
        compressionConstraint = new c.Inequality(variableExp, c.GEQ, constantExp, compressionSw.strength, compressionSw.weight);

    return [huggingConstraint, compressionConstraint];
};

scope.expressionForAttribute = function(args, isContainer, isNull)
{
    var attribute = args.attribute;

    if (isNull || attribute === CPLayoutAttributeNotAnAttribute)
        return new c.Expression.fromConstant(0);

    var itemName = args.name,
        rect = args.rect,
        uuid = args.uuid,
        exp;

    switch(attribute)
    {
        case CPLayoutAttributeLeading   :
        case CPLayoutAttributeLeft      : exp = scope.expressionForAttributeLeft(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeTrailing  :
        case CPLayoutAttributeRight     : exp = scope.expressionForAttributeRight(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeTop       : exp = scope.expressionForAttributeTop(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeBottom    : exp = scope.expressionForAttributeBottom(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeWidth     : exp = scope.CPViewLayoutVariable(uuid, itemName, LayoutVariableWidth, rect.size.width);
            break;
        case CPLayoutAttributeHeight    : exp = scope.CPViewLayoutVariable(uuid, itemName, LayoutVariableHeight, rect.size.height);
            break;
        case CPLayoutAttributeCenterX   : exp = scope.expressionForAttributeCenterX(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeBaseline  : exp = scope.expressionForAttributeBottom(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeCenterY   : exp = scope.expressionForAttributeCenterY(uuid, itemName, rect, isContainer);
            break;
    }

    return exp;
};

scope.expressionForAttributeLeft = function(anIdentifier, aPrefix, aRect, isContainer)
{
    if (!isContainer)
        return new c.Expression.fromVariable(scope.CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableLeft, aRect.origin.x));

    return new c.Expression.fromConstant(0);
};

scope.expressionForAttributeTop = function(anIdentifier, aPrefix, aRect, isContainer)
{
    if (!isContainer)
        return new c.Expression.fromVariable(scope.CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableTop, aRect.origin.y));

    return new c.Expression.fromConstant(0);
};

scope.expressionForAttributeRight = function(anIdentifier, aPrefix, aRect, isContainer)
{
    var variableWidth = scope.CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableWidth, aRect.size.width);

    if (isContainer)
        return new c.Expression.fromVariable(variableWidth);

    var left = scope.CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableLeft, aRect.origin.x);

    return new c.Expression.fromVariable(left).plus(variableWidth);
};

scope.expressionForAttributeBottom = function(anIdentifier, aPrefix, aRect, isContainer)
{
    var variableHeight = scope.CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableHeight, aRect.size.height);

    if (isContainer)
        return new c.Expression.fromVariable(variableHeight);

    var top = scope.CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableTop, aRect.origin.y);

    return new c.Expression.fromVariable(top).plus(variableHeight);
};

scope.expressionForAttributeCenterX = function(anIdentifier, aPrefix, aRect, isContainer)
{
    var midWidth = new c.Expression.fromVariable(scope.CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableWidth, aRect.size.width)).divide(2);

    if (isContainer)
        return midWidth;

    var left = new c.Expression.fromVariable(scope.CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableLeft, aRect.origin.x));

    return c.plus(left, midWidth);
};

scope.expressionForAttributeCenterY = function(anIdentifier, aPrefix, aRect, isContainer)
{
    var midHeight = new c.Expression.fromVariable(scope.CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableHeight, aRect.size.height)).divide(2);

    if (isContainer)
        return midHeight;

    var top = new c.Expression.fromVariable(scope.CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableTop, aRect.origin.y));

    return c.plus(top, midHeight);
};

};

var WorkerLog = function(x)
{
    returnMessage('log', x);
};

var WorkerWarn = function(x)
{
    returnMessage('warn', x);
};

var onValueChange = function(v, records)
{
    var identifier = v._identifier,
        tag = v._tag,
        value = v.value,
        record = records[identifier];

    if (typeof record == "undefined")
    {
        record = {changeMask:0, changeValues:{}};
        records[identifier] = record;
    }

    record.changeMask |= tag;
    record.changeValues[tag] = value;
};

var onSolved = function(records)
{
    returnMessage('solved', records);
};