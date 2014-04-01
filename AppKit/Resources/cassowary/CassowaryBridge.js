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

DISABLE_ON_SOLVED_NOTIFICATIONS = false;

VARIABLES_MAP = {};

CONSTRAINTS_BY_VIEW_AND_TYPE_MAP = [];

EDIT_CONTEXT = null;

EDITVARS_FOR_CONTEXT = {};

self.caller = {

setDisableOnSolvedNotification : function(flag)
                                 {
                                     self.solver.onvaluechange = flag ? onValueChange : noop;
                                     self.solver.onSolved = flag ? onSolved : noop;
                                 },

createSolver  : function()
                {
                    self.solver = newSolver();
                    CPLogMain('created solver');

                    return self.solver;
                },

solve         : function()
                {
                    if (!SolverExists('solve'))
                        return;

                    self.solver.solve();

                    CPLogMain("solve");
                },

info          : function()
                {
                    var info = self.solver.toString();
                    CPLogMain(info);

                    return info;
                },

getconstraints : function()
                {
                    var str = "";

                    CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.forEach(function(w)
                    {
                        str += w.constraint.toString() + "\n";
                    });

                    CPLogMain(str);
                },

addConstraint : function(json)
                {
                    if (!SolverExists('addConstraint'))
                        return;

                    var type = json.type,
                        constraints = [];

                    if (type == "Constraint")
                    {
                        var newConstraint = CreateConstraint(json);
                        constraints.push(newConstraint);
                    }
                    else if (type == "SizeConstraint")
                    {
                        var newConstraints = CreateSizeConstraints(json);
                        constraints.push.apply(constraints, newConstraints);
                    }

                    constraints.forEach(function(constraint)
                    {
                        self.solver.addConstraint(constraint);
                        CPLogMain('addConstraint uuid: ' + json.uuid  + " type: " + type + " cst:" + constraint.toString());
                    });

                    return constraints;
                },

addConstraints : function(jsonarray)
                 {
                     var add = self.caller.addConstraint;

                     jsonarray.forEach(function(json)
                     {
                         add(json);
                     });
                 },

removeConstraint : function(casso_constraint)
                   {
                       var error = null;

                       try
                       {
                           self.solver.removeConstraint(casso_constraint);
                       }
                       catch (e)
                       {
                           error = e;
                       }
                       finally
                       {
                           if (error)
                               CPLogWarn(error.toString());
                            else
                               CPLogMain('removed constraint :' + casso_constraint.toString());
                       }
                   },

replaceConstraints : function(args)
                    {
                        var container = args.container,
                            type = args.type,
                            json_constraints = args.constraints;

                        var constraints_by_view_and_type = CONSTRAINTS_BY_VIEW_AND_TYPE_MAP;
                        var i = constraints_by_view_and_type.length;
// remove
                        while(i--)
                        {
                            var constraint_view_type = constraints_by_view_and_type[i];
                            if (constraint_view_type.container == container && constraint_view_type.type == type)
                            {
                                self.caller.removeConstraint(constraint_view_type.constraint);
                                constraints_by_view_and_type.splice(i, 1);
                            }
                        }
// add
                        json_constraints.forEach(function(json)
                        {
                            var casso_constraints = self.caller.addConstraint(json);

                            casso_constraints.forEach(function(constraint)
                            {
                                var wrapper = {container:container, type:json.type, constraint:constraint};
                                constraints_by_view_and_type.push(wrapper);
                            });
                        });
                    },

updateSizeConstraints : function(args)
                    {
                        var container = args.container,
                            size_constraints = args.constraints;

                        size_constraints.forEach(function(size_constraint)
                        {
                            var orientation = size_constraint.orientation,
                                constant = size_constraint.constant,
                                hugg_constant_id = container + "_" + orientation + "_hugg",
                                compr_constant_id = container + "_" + orientation + "_compr";

                            self.caller.suggestValue({identifier:hugg_constant_id, tag:0, priority:10000, value:constant});
                            self.caller.suggestValue({identifier:compr_constant_id, tag:0, priority:10000, value:constant});

                        });

                        self.solver.resolve();
                    },

setEditVarsForContext : function(args)
                        {
                            var tags = args.tags,
                                identifier = args.identifier,
                                priority = args.priority,
                                editVars = [];

                            tags.forEach(function(tag)
                            {
                               var variable = GetVariable(identifier, tag);
                               editVars.push({variable:variable, priority:priority});
                            });

                            EDITVARS_FOR_CONTEXT[identifier] = editVars;
                        },

removeAllEditVars : function()
                    {
                        self.solver.removeAllEditVars();
                        EDIT_CONTEXT = null;
                    },

suggestValue : function(args)
               {
                   if (!SolverExists('suggestValue'))
                        return;

                   var solver = self.solver,
                       variable = GetVariable(args.identifier, args.tag),
                       sw = StrengthAndWeight(args.priority);

                   if (EDIT_CONTEXT !== null)
                       solver.removeAllEditVars();

                   solver.addEditVar(variable, sw.strength, sw.weight).beginEdit();
                   solver.suggestValue(variable, args.value);
                   solver.endEdit();

                   EDIT_CONTEXT = args.identifier;

                   CPLogMain("suggestValue " + args.value + " for " + variable.toString());
               },

suggestValuesMultiple : function(args)
                        {
                            suggestValues(args.values, args.context);
                            //CPLogMain("suggestValuesMultiple");
                        },

addStay : function(args)
          {
              if (!SolverExists('addStay'))
                  return;

              var variable = CPViewLayoutVariable(args.identifier, args.prefix, args.tag, args.value),
                  sw = StrengthAndWeight(args.priority);

              self.solver.addStay(variable, sw.strength, sw.weight);

              CPLogMain('add Stay ' + variable.toString());
          },
};

var CPLogMain = function(x)
{
    returnMessage('log', x);
};

var CPLogWarn = function(x)
{
    returnMessage('warn', x);
};

var newSolver = function()
{
    var s = new c.SimplexSolver();
    s.autoSolve = false;
    s.onvaluechange = onValueChange;
    s.onsolved = onSolved;

    return s;
};

var suggestValues = function(values, context)
{
    var solver = self.solver,
        editVars = EDITVARS_FOR_CONTEXT[context];

    if (context !== EDIT_CONTEXT)
    {
        try
        {
            if (EDIT_CONTEXT !== null)
                solver.removeAllEditVars();

            editVars.forEach(function(editVar)
            {
                var sw = StrengthAndWeight(editVar.priority);
                solver.addEditVar(editVar.variable, sw.strength, sw.weight);
            });
        }
        catch (e)
        {
            returnMessage('warn', e);
        }

        EDIT_CONTEXT = context;
    }

    editVars.forEach(function(editVar, idx)
    {
        solver.suggestValue(editVar.variable, values[idx]);
    });

    solver.resolve();
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

var noop = function()
{
};

var SolverExists = function(command)
{
    if (typeof self.solver == 'undefined')
    {
        returnMessage('warn', 'Asked to ' + command + ' but inexistent solver');
        return false;
    }

    return true;
};

// get variable from the cache only.
var GetVariable = function(anIdentifier, aTag)
{
    // Unique
    var variable_hash = anIdentifier + "_" + aTag;

    return VARIABLES_MAP[variable_hash];
};

// get variable from the cache or create a new one.
var CPViewLayoutVariable = function(anIdentifier, aPrefix, aTag, aValue)
{
    var variable_hash = anIdentifier + "_" + aTag,
        variable = VARIABLES_MAP[variable_hash];

    if (typeof variable == 'undefined')
    {
        var name;

        switch (aTag)
        {
            case LayoutVariableConstant : name = "k";
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
        VARIABLES_MAP[variable_hash] = variable;

        // if (aTag == LayoutVariableWidth || aTag == LayoutVariableHeight)
        // restrictToNonNegative(variable);
    }

    return variable;
};
/*
var restrictToNonNegative = function(aVariable)
{
    var tag = aVariable._tag;

    var restricted = new c.Inequality(new c.Expression.fromVariable(aVariable), c.GEQ, new c.Expression.fromConstant(0), c.Strength.required, 10000);

    self.solver.addConstraint(restricted);

    var wrapper = {container:null, type:"restricted", constraint:restricted};
    CONSTRAINTS_BY_VIEW_AND_TYPE_MAP.push(wrapper);
};
*/
var StrengthAndWeight = function(p)
{
/*
    var h = Math.floor(p / 100),
        d = Math.floor((p - 100*c) / 10),
        n = p - 100*c - 10*d;
*/

    return {strength:(new c.Strength("Custom", 0, 1, 0)), weight:p};
};

var CreateConstraint = function(args)
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
        sw              = StrengthAndWeight(priority),
        constraint;

    var first = expressionForAttribute(firstItemArgs, (containerUUID === firstItemUUID), (firstItemUUID === null)),
        second = expressionForAttribute(secondItemArgs, (containerUUID === secondItemUUID), (secondItemUUID === null));

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

var CreateSizeConstraints = function(args)
{
    var container = args.firstItemUID,
        orientation = args.orientation,
        tag = orientation ? LayoutVariableHeight : LayoutVariableWidth;

    var hugg_constant_id = container + "_" + orientation + "_hugg";
    var compr_constant_id = container + "_" + orientation + "_compr";

    var sizeVariable = CPViewLayoutVariable(container, args.firstItemName, tag, args.value),
        hugg_constant = CPViewLayoutVariable(hugg_constant_id, "CONSTANT", LayoutVariableConstant, args.constant),
        compr_constant = CPViewLayoutVariable(compr_constant_id, "CONSTANT", LayoutVariableConstant, args.constant),
        huggExp = new c.Expression.fromVariable(hugg_constant),
        comprExp = new c.Expression.fromVariable(compr_constant),
        variableExp = new c.Expression.fromVariable(sizeVariable),
        huggingSw = StrengthAndWeight(args.huggingPriority),
        compressionSw = StrengthAndWeight(args.compressionPriority);

    self.solver.addStay(hugg_constant, huggingSw.strength, huggingSw.weight + 1);
    self.solver.addStay(compr_constant, compressionSw.strength, compressionSw.weight + 1);

    var huggingConstraint = new c.Inequality(variableExp, c.LEQ, huggExp, huggingSw.strength, huggingSw.weight),
        compressionConstraint = new c.Inequality(variableExp, c.GEQ, comprExp, compressionSw.strength, compressionSw.weight);

    return [huggingConstraint, compressionConstraint];
};

var expressionForAttribute = function(args, isContainer, isNull)
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
        case CPLayoutAttributeLeft      : exp = expressionForAttributeLeft(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeTrailing  :
        case CPLayoutAttributeRight     : exp = expressionForAttributeRight(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeTop       : exp = expressionForAttributeTop(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeBottom    : exp = expressionForAttributeBottom(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeWidth     : exp = CPViewLayoutVariable(uuid, itemName, LayoutVariableWidth, rect.size.width);
            break;
        case CPLayoutAttributeHeight    : exp = CPViewLayoutVariable(uuid, itemName, LayoutVariableHeight, rect.size.height);
            break;
        case CPLayoutAttributeCenterX   : exp = expressionForAttributeCenterX(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeBaseline  : exp = expressionForAttributeBottom(uuid, itemName, rect, isContainer);
            break;
        case CPLayoutAttributeCenterY   : exp = expressionForAttributeCenterY(uuid, itemName, rect, isContainer);
            break;
    }

    return exp;
};

var expressionForAttributeLeft = function(anIdentifier, aPrefix, aRect, isContainer)
{
    if (!isContainer)
        return new c.Expression.fromVariable(CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableLeft, aRect.origin.x));

    return new c.Expression.fromConstant(0);
};

var expressionForAttributeTop = function(anIdentifier, aPrefix, aRect, isContainer)
{
    if (!isContainer)
        return new c.Expression.fromVariable(CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableTop, aRect.origin.y));

    return new c.Expression.fromConstant(0);
};

var expressionForAttributeRight = function(anIdentifier, aPrefix, aRect, isContainer)
{
    var variableWidth = CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableWidth, aRect.size.width);

    if (isContainer)
        return new c.Expression.fromVariable(variableWidth);

    var left = CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableLeft, aRect.origin.x);

    return new c.Expression.fromVariable(left).plus(variableWidth);
};

var expressionForAttributeBottom = function(anIdentifier, aPrefix, aRect, isContainer)
{
    var variableHeight = CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableHeight, aRect.size.height);

    if (isContainer)
        return new c.Expression.fromVariable(variableHeight);

    var top = CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableTop, aRect.origin.y);

    return new c.Expression.fromVariable(top).plus(variableHeight);
};

var expressionForAttributeCenterX = function(anIdentifier, aPrefix, aRect, isContainer)
{
    var midWidth = new c.Expression.fromVariable(CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableWidth, aRect.size.width)).divide(2);

    if (isContainer)
        return midWidth;

    var left = new c.Expression.fromVariable(CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableLeft, aRect.origin.x));

    return c.plus(left, midWidth);
};

var expressionForAttributeCenterY = function(anIdentifier, aPrefix, aRect, isContainer)
{
    var midHeight = new c.Expression.fromVariable(CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableHeight, aRect.size.height)).divide(2);

    if (isContainer)
        return midHeight;

    var top = new c.Expression.fromVariable(CPViewLayoutVariable(anIdentifier, aPrefix, LayoutVariableTop, aRect.origin.y));

    return c.plus(top, midHeight);
};
