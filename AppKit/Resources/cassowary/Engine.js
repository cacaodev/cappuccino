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

scope.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP = [];

scope.VARIABLES_MAP = {};

scope.EDIT_VARIABLES = null;

scope.solver = null;

scope.setDisableOnSolvedNotification = function(flag)
{
    scope.solver.onvaluechange = flag ? onValueChange : scope.noop;
    scope.solver.onSolved = flag ? onSolved : scope.noop;
};

scope.createSolver = function()
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

scope.resolve = function()
{
    if (!scope.SolverExists('solve'))
        return;

    scope.solver.resolve();

    WorkerLog("resolve");
};

scope.info = function()
{
    var info = scope.solver.toString();
    WorkerLog(info);

    return info;
};

scope.layoutConstraint = function(uuid, container, type, casso_constraint)
{
    this.uuid = uuid;
    this.container = container;
    this.type = type;
    this.constraint = casso_constraint;

    this.toString = function()
    {
        return (this.uuid + " " + this.type + " " + this.constraint.toString());
    };

    return this;
};

scope.getconstraints = function()
{
    var str = "";

    scope.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.forEach(function(w)
    {
        str += w.toString() + "\n";
    });

    WorkerLog(str + "\n" + scope.solver.rows.toString());
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
        scope._addConstraint(constraint, json.uuid, json.container, type);
    });

    return constraints;
};

scope._addConstraint = function(casso_constraint, uuid, container, type)
{
    scope.solver.addConstraint(casso_constraint);

    var wrapper = new scope.layoutConstraint(uuid , container, type, casso_constraint);
    scope.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.push(wrapper);

    WorkerLog("Added: " + wrapper.toString());
};

scope.removeConstraintWithUUID = function(uuid, type, isMultiple)
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
            WorkerLog('Removed: ' +  w.toString());
            constraints_list.splice(count, 1);

            if (!isMultiple)
                break;
        }
    }

    return ret;
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
    }

    return (error == null);
};

scope.replaceConstraints = function(args)
{
    var orig_all_constraints = scope.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP,
        final_constraints = args.constraints,
        container = args.container;

    var orig_constraints = orig_all_constraints.filter(function(cst)
    {
        return (cst.container == container && cst.type == "Constraint");
    });

    var mutation = compareArrays(orig_constraints, "uuid", final_constraints, "uuid"),
        removed = mutation.removed,
        added = mutation.added;

    WorkerLog("Constraints: should add " + added.length + " and remove " + removed.length);

    removed.forEach(function(cst)
    {
        scope.removeConstraintWithUUID(cst.uuid, "Constraint", false);
    });

    added.forEach(function(json)
    {
        scope.addConstraint(json);
    });
};

scope.replaceSizeConstraints = function(args)
{
    var json_constraints = args.constraints;
    WorkerLog("Size Constraints: should replace " + json_constraints.length);

    json_constraints.forEach(function(json)
    {
        // Removes constraints for both hugging and antiCompression
        scope.removeConstraintWithUUID(json.uuid, "SizeConstraint", true);
        scope.addConstraint(json);
    });
};
/*
scope.createContext = function(container, variableTag, priority)
{
    return new scope.Context(container, variableTag, priority);
};

scope.Context = function(uuid, prefix, variableTag, priority)
{
    this.uuid = uuid;
    this.prefix = prefix;
    this.tags = variableTag;
    this.priority = priority;

    return this;
};

scope.pushContext = function(aContext)
{
    scope.CONTEXT_STACK.push(aContext);
};

scope.popContext = function()
{
    return scope.CONTEXT_STACK.pop();
};
*/

scope.stopEditing = function()
{
    if (scope.EDIT_VARIABLES !== null)
    {
        scope.solver.removeAllEditVars();
        scope.EDIT_VARIABLES = null;
        WorkerLog("removeAllEditVars");
    }
};

scope.suggestValues = function(args)
{
    var values = args.values,
        solver = scope.solver,
        editVariables = scope.EDIT_VARIABLES;

    if (editVariables == null)
    {
        var tags = args.tags,
            prefix = args.prefix,
            uuid = args.uuid,
            priority = args.priority,
            var_array = [];

        tags.forEach(function(tag)
        {
           var variable = scope.CPViewLayoutVariable(uuid, prefix, tag, null);
           var sw = scope.StrengthAndWeight(priority);
           solver.addEditVar(variable, sw.strength, sw.weight);
           var_array.push(variable);
        });

        editVariables = var_array;
        scope.EDIT_VARIABLES = var_array;
    }

    editVariables.forEach(function(variable, idx)
    {
        solver.suggestValue(variable, values[idx]);
    });

    solver.resolve();
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

scope.addStayVariable = function(variable, priority)
{
    if (!scope.SolverExists('addStay'))
        return;

    var sw = scope.StrengthAndWeight(priority),
        container = variable._identifier,
        uuid = container + "_" + variable._tag,
        stayConstraint = new c.StayConstraint(variable, sw.strength, sw.weight);

    var replace_count = scope.removeConstraintWithUUID(uuid, "StayConstraint", false);

    scope._addConstraint(stayConstraint, uuid, container, "StayConstraint");

    WorkerLog('add Stay ' + variable.toString() + ' replacing ' + replace_count);
};

scope.addStay = function(args)
{
    var variable = scope.CPViewLayoutVariable(args.identifier, args.prefix, args.tag, args.value),
        priority = args.priority;

    scope.addStayVariable(variable, priority);
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

        if (aValue == null)
            aValue = 0;

        var options = {prefix:aPrefix, name:name, identifier:anIdentifier, tag:aTag, value:aValue};
        variable = new c.Variable(options);
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

    return {strength:(new c.Strength("", 0, 1, 0)), weight:p};
};

scope.CreateConstraint = function(args)
{
// WorkerLog("firstItem " + args.firstItem.uuid + " secondItem " + args.secondItem.uuid + " containerUUID " + args.containerUUID + " flags " + args.flags);

    var firstItemArgs   = args.firstItem,
        secondItemArgs  = args.secondItem,
        firstItemUUID   = firstItemArgs.uuid,
        secondItemUUID  = secondItemArgs.uuid,
        containerUUID   = args.container,
        relation        = args.relation,
        multiplier      = args.multiplier,
        constant        = args.constant,
        priority        = args.priority,
        sw              = scope.StrengthAndWeight(priority),
        constraint,
        rhs_term;

    var lhs_term = scope.expressionForAttribute(firstItemArgs),
        secondExp = scope.expressionForAttribute(secondItemArgs);

    if (secondExp.isConstant)
        rhs_term = new c.Expression.fromConstant(secondExp.constant * multiplier + constant);
    else if (multiplier === 0)
        rhs_term = new c.Expression.fromConstant(constant);
    else
        rhs_term = c.plus(c.times(secondExp, multiplier), constant);

    switch(relation)
    {
        case CPLayoutRelationLessThanOrEqual    : constraint = new c.Inequality(lhs_term, c.LEQ, rhs_term, sw.strength, sw.weight);
            break;
        case CPLayoutRelationGreaterThanOrEqual : constraint = new c.Inequality(lhs_term, c.GEQ, rhs_term, sw.strength, sw.weight);
            break;
        case CPLayoutRelationEqual              : constraint = new c.Equation(lhs_term, rhs_term, sw.strength, sw.weight);
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

scope.expressionForAttribute = function(args)
{
    var attribute = args.attribute,
        isNull = args.flags & 2;

    if (isNull || attribute === CPLayoutAttributeNotAnAttribute)
        return new c.Expression.fromConstant(0);

    var itemName = args.name,
        rect = args.rect,
        uuid = args.uuid,
        isContainer = args.flags & 4,
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

var compareArrays = function (o, keyo, n, keyn)
{
  // sort both arrays (or this won't work)
    var sorto = function(a,b){return a[keyo]-b[keyo];};
    var sortn = function(a,b){return a[keyn]-b[keyn];};

    o.sort(sorto); n.sort(sortn);

  // don't compare if either list is empty
  if (o.length == 0 || n.length == 0) return {added: n, removed: o};

  // declare temporary variables
  var op = 0; var np = 0;
  var a = []; var r = [];

  // compare arrays and add to add or remove lists
  while (op < o.length && np < n.length) {
      if (o[op][keyo] < n[np][keyn]) {
          // push to diff?
          r.push(o[op]);
          op++;
      }
      else if (o[op][keyo] > n[np][keyn]) {
          // push to diff?
          a.push(n[np]);
          np++;
      }
      else {
          op++;np++;
      }
  }

  // add remaining items
  if( np < n.length )
    a = a.concat(n.slice(np, n.length));
  if( op < o.length )
    r = r.concat(o.slice(op, o.length));

  return {added: a, removed: r};
};
