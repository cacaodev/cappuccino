(function(){

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

Engine = function(autoSolve, onvaluechange, onsolved)
{
    this.DISABLE_ON_SOLVED_NOTIFICATIONS = false;

    this.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP = [];

    this.VARIABLES_MAP = {};

    this.EDIT_VARIABLES = null;

    this.DEFAULT_EDIT_STRENGTH = c.Strength.strong;

    var simplexSolver = new c.SimplexSolver();
    simplexSolver.autoSolve = autoSolve;
    simplexSolver.onvaluechange = onvaluechange ? onvaluechange : this.noop();
    simplexSolver.onsolved = onsolved ? onsolved : this.noop();

    this.solver = simplexSolver;
};

Engine.prototype.disableOnSolvedNotification = function()
{
    this.solver.onvaluechange = this.noop();
    this.solver.onSolved = this.noop();
};

Engine.prototype.noop = function()
{
};

Engine.prototype.solve = function()
{
    this.solver.solve();
    EngineLog("solve");
};

Engine.prototype.resolve = function()
{
    this.solver.resolve();
};

Engine.prototype.description = function()
{
    var str = "Engine Constraints:\n";

    this.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.forEach(function(w)
    {
        str += w.toString() + "\n";
    });

    return (str + "\nInternalInfo:\n" + this.solver.getInternalInfo());
};

Engine.prototype.Variable = function(uuid, prefix, name, tag, value)
{
    return new c.Variable({identifier:uuid, prefix:prefix, name:name, tag:tag, value:value});
};

Engine.prototype.replaceConstraints = function(args, errors)
{
    var final_constraints = args.constraints,
        container = args.container,
        type = args.type,
        self = this;

    var current_constraints = self.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.filter(function(cst)
    {
        return (cst.container == container && cst.type == type);
    });

    var mutation = compareArrays(current_constraints, final_constraints, compareUUID),
        removed = mutation.removed,
        added = mutation.added;

    EngineLog(type + ": should add " + added.length + " and remove " + removed.length);

    removed.forEach(function(cst)
    {
        var solverError = new SolverError();
        self.removeConstraintWithUUID(cst.uuid, type, solverError);

        if (solverError.error !== null)
            errors.push(solverError);
    });

    added.forEach(function(json)
    {
        var solverError = new SolverError();
        self.addConstraintFromJSON(container, type, json, solverError);

        if (solverError.error !== null)
            errors.push(solverError);
    });

    return (removed.length > 0 || added.length > 0);
};

Engine.prototype.addConstraintFromJSON = function(container, type, json, solverError)
{
    var casso_constraint = null;

    switch (type)
    {
        case "AutoresizingConstraint" :
        case "Constraint"     : casso_constraint = this.CreateConstraint(json);
        break;
        case "SizeConstraint" : casso_constraint = this.CreateSizeConstraint(json);
        break;
        case "StayConstraint" : casso_constraint = this.CreateStayConstraint(json);
        break;
    }

    if (casso_constraint)
    {
        var layoutConstraint = new LayoutConstraint(json.uuid, container, type, casso_constraint);
        layoutConstraint.addToSolver(this.solver, solverError);

        if (solverError.error == null)
        {
            this.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.push(layoutConstraint);
            EngineLog("Added " + layoutConstraint.toString());
        }
    }
};

Engine.prototype.removeConstraintWithUUID = function(uuid, type, solverError)
{
    var constraints_list = this.CONSTRAINTS_BY_VIEW_AND_TYPE_MAP,
        count = constraints_list.length;

    while(count--)
    {
        var layoutConstraint = constraints_list[count];

        if ((type == null || layoutConstraint.type == type) && layoutConstraint.uuid == uuid)
        {
            layoutConstraint.removeFromSolver(this.solver, solverError);

            if (solverError.error == null)
            {
                constraints_list.splice(count, 1);
                EngineLog("Removed " + layoutConstraint.toString());
            }

            break;
        }
    }
};

Engine.prototype.stopEditing = function()
{
    if (this.EDIT_VARIABLES !== null)
    {
        var error = null;

        try {
            this.solver.removeAllEditVars();
            this.EDIT_VARIABLES = null;
            EngineLog("removedAllEditVars");
        }
        catch (e)
        {
            error = e;
        }
        finally
        {
            if (error !== null)
                EngineError(error + " EDIT_VARIABLES were " + this.EDIT_VARIABLES);
        }
    }
};

Engine.prototype.suggestValues = function(variables, values, priority)
{
    var solver = this.solver;

    if (this.EDIT_VARIABLES == null)
    {
        //var sw = this.StrengthForPriority(priority);
        var strength = this.DEFAULT_EDIT_STRENGTH;

        variables.forEach(function(variable)
        {
           solver.addEditVar(variable, strength, 1);
        });

        this.EDIT_VARIABLES = variables;
    }

    this.EDIT_VARIABLES.forEach(function(variable, idx)
    {
        solver.suggestValue(variable, values[idx]);
    });

    // Perf: call the solver directly ?
    this.resolve();
};

Engine.prototype.StrengthForPriority = function(p)
{
//    var h = Math.floor(p / 100),
//        d = Math.floor((p - 100*c) / 10),
//        n = p - 100*c - 10*d;
//    (new c.Strength("", h, d, n))
    if (p >= 1000)
        return {strength:c.Strength.required, weight:p};

    return {strength:c.Strength.medium, weight:p};
};

Engine.prototype.CreateConstraint = function(args)
{
// EngineLog("firstItem " + args.firstItem.uuid + " secondItem " + args.secondItem.uuid + " containerUUID " + args.containerUUID + " flags " + args.flags);

    var first           = args.firstItem,
        second          = args.secondItem,
        relation        = args.relation,
        multiplier      = args.multiplier,
        constant        = args.constant,
        priority        = args.priority,
        sw              = this.StrengthForPriority(priority),
        constraint,
        rhs_term;

    var lhs_term = this.expressionForAttribute(first.attribute, first.flags, first.left, first.top, first.width, first.height),
        secondExp = this.expressionForAttribute(second.attribute, second.flags, second.left, second.top, second.width, second.height);

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

Engine.prototype.CreateSizeConstraint = function(args)
{
    var variableExp = new c.Expression.fromVariable(args.variable),
        constantExp = new c.Expression.fromConstant(args.constant),
        inequality = (args.relation === CPLayoutRelationGreaterThanOrEqual) ? c.GEQ : c.LEQ,
        sw = this.StrengthForPriority(args.priority);

    return new c.Inequality(variableExp, inequality, constantExp, sw.strength, sw.weight);
};

Engine.prototype.CreateStayConstraint = function(args)
{
    var sw = this.StrengthForPriority(args.priority);

    return new c.StayConstraint(args.variable, sw.strength, sw.weight);
};

Engine.prototype.expressionForAttribute = function(attribute, flags, left, top, width, height)
{
    var isNull = flags & 2;

    if (isNull || attribute === CPLayoutAttributeNotAnAttribute)
        return new c.Expression.fromConstant(0);

    var isContainer = flags & 4,
        exp;

    switch(attribute)
    {
        case CPLayoutAttributeLeading   :
        case CPLayoutAttributeLeft      : exp = this.expressionForAttributeLeft(left, isContainer);
            break;
        case CPLayoutAttributeTrailing  :
        case CPLayoutAttributeRight     : exp = this.expressionForAttributeRight(left, width, isContainer);
            break;
        case CPLayoutAttributeTop       : exp = this.expressionForAttributeTop(top, isContainer);
            break;
        case CPLayoutAttributeBottom    : exp = this.expressionForAttributeBottom(top, height, isContainer);
            break;
        case CPLayoutAttributeWidth     : exp = new c.Expression.fromVariable(width);
            break;
        case CPLayoutAttributeHeight    : exp = new c.Expression.fromVariable(height);
            break;
        case CPLayoutAttributeCenterX   : exp = this.expressionForAttributeCenterX(left, width, isContainer);
            break;
        case CPLayoutAttributeBaseline  : exp = this.expressionForAttributeBottom(top, height, isContainer);
            break;
        case CPLayoutAttributeCenterY   : exp = this.expressionForAttributeCenterY(top, height, isContainer);
            break;
    }

    return exp;
};

Engine.prototype.expressionForAttributeLeft = function(variable, isContainer)
{
    if (!isContainer)
        return new c.Expression.fromVariable(variable);

    return new c.Expression.fromConstant(0);
};

Engine.prototype.expressionForAttributeTop = function(variable, isContainer)
{
    if (!isContainer)
        return new c.Expression.fromVariable(variable);

    return new c.Expression.fromConstant(0);
};

Engine.prototype.expressionForAttributeRight = function(leftVariable, widthVariable, isContainer)
{
    if (isContainer)
        return new c.Expression.fromVariable(widthVariable);

    return new c.Expression.fromVariable(leftVariable).plus(widthVariable);
};

Engine.prototype.expressionForAttributeBottom = function(topVariable, heightVariable, isContainer)
{
    if (isContainer)
        return new c.Expression.fromVariable(heightVariable);

    return new c.Expression.fromVariable(topVariable).plus(heightVariable);
};

Engine.prototype.expressionForAttributeCenterX = function(leftVariable, widthVariable, isContainer)
{
    var midWidth = new c.Expression.fromVariable(widthVariable).divide(2);

    if (isContainer)
        return midWidth;

    var left = new c.Expression.fromVariable(leftVariable);

    return c.plus(left, midWidth);
};

Engine.prototype.expressionForAttributeCenterY = function(topVariable, heightVariable, isContainer)
{
    var midHeight = new c.Expression.fromVariable(heightVariable).divide(2);

    if (isContainer)
        return midHeight;

    var top = new c.Expression.fromVariable(topVariable);

    return c.plus(top, midHeight);
};

var LayoutConstraint = function(uuid, container, type, casso_constraint)
{
    this.uuid = uuid;
    this.container = container;
    this.type = type;
    this.constraint = casso_constraint;

    this.toString = function()
    {
        return (this.type + " " + this.uuid + " " + this.constraint.toString());
    };

    this.addToSolver = function(aSolver, solverError)
    {
        try
        {
            aSolver.addConstraint(this.constraint);
        }
        catch (e)
        {
            solverError.setError(e, this);
        }
    };

    this.removeFromSolver = function(aSolver, solverError)
    {
        try
        {
            aSolver.removeConstraint(this.constraint);
        }
        catch (e)
        {
            solverError.setError(e, this);
        }
    };
};

var SolverError = function()
{
    this.error = null;
    this.type = null;
    this.userInfo = null;

    this.setError = function(error, info)
    {
        this.error = error;
        this.type = error._name;
        this.userInfo = info;
    };

    this.reason = function()
    {
        return this.error.toString();
    };

    this.toString = function()
    {
        var desc = this.error ? this.reason() : "No Error";

        if (this.userInfo)
            desc += " : " + this.userInfo.toString();

        return desc;
    };

    this.raise = function()
    {
        EngineWarn(this.toString());
    }
};

var EngineLog = function(str)
{
    console.log('%c [Engine]: ' + str, 'color:darkblue; font-weight:bold');
};

var EngineWarn = function(str)
{
    console.warn('%c [Engine]: ' + str, 'color:brown; font-weight:bold');
};

var EngineError = function(str)
{
    console.error('%c [Engine]: ' + str, 'color:darkred; font-weight:bold');
};

var compareUUID = function(a, b)
{
    var uuida = a.uuid,
        uuidb = b.uuid;

    if (uuida > uuidb)
        return 1;
    else if (uuida < uuidb)
        return -1;
    else
        return 0;
};

var compareArrays = function(o, n, sortFunction)
{
    // sort both arrays (or this won't work)
    o.sort(sortFunction);
    n.sort(sortFunction);

    // don't compare if either list is empty
    if (o.length === 0 || n.length === 0)
        return {added:n, removed:o};

    // declare temporary variables
    var op = 0, np = 0,
        a = [], r = [];

    // compare arrays and add to add or remove lists
    while (op < o.length && np < n.length)
    {
        var compare = sortFunction(o[op], n[np]);

        if (compare === -1)
        {
            // push to diff?
            r.push(o[op]);
            op++;
        }
        else if (compare === 1)
        {
            // push to diff?
            a.push(n[np]);
            np++;
        }
        else
        {
            op++;np++;
        }
    }

    // add remaining items
    if (np < n.length)
        a = a.concat(n.slice(np, n.length));

    if (op < o.length)
        r = r.concat(o.slice(op, o.length));

    return {added:a, removed:r};
};
})();
