@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import <Foundation/CPBundle.j>
@import <Foundation/CPIndexSet.j>

@import "CPLayoutConstraint.j"
@import "c.js"

@typedef SimplexSolver
@typedef Map

/*
var CPLayoutItemIsNull          = 2,
    CPLayoutItemIsContainer     = 4,
    CPLayoutItemIsNotContainer  = 8;
*/
@implementation CPLayoutConstraintEngine : CPObject
{
    SimplexSolver _simplexSolver;
    Map           _constraintContainerMap;
    Map           _variableOwnerMap;
    CPArray       _editingVariables;
    Object        _defaultEditStrength;
    id            _delegate @accessors(getter=delegate);
}

- (id)initWithDelegate:(id)aDelegate
{
    self = [super init];

    _variableOwnerMap = new Map();
    _constraintContainerMap = new Map();
    _editingVariables = nil;
    _defaultEditStrength = c.Strength.strong;
    _delegate = aDelegate;

    _simplexSolver = new c.SimplexSolver();
    _simplexSolver.autoSolve = false;
    _simplexSolver.onsolved = function(changes)
    {
        changes.forEach(function(change)
        {
            var variable = change.variable,
                   owner = _variableOwnerMap.get(variable);

            [_delegate engine:self variableDidChange:variable withOwner:owner];
        });
    };

    return self;
}

- (void)disableOnSolvedNotification
{
    _simplexSolver.onsolved = function(){};
}

- (void)suggestValues:(CPArray)values forVariables:(CPArray)variables withPriority:(CPLayoutPriority)priority
{
    if (_editingVariables == nil)
    {
        variables.forEach(function(variable)
        {
           _simplexSolver.addEditVar(variable, _defaultEditStrength, 1);
        });

        _editingVariables = variables;
    }

    _editingVariables.forEach(function(variable, idx)
    {
        _simplexSolver.suggestValue(variable, values[idx]);
    });

    // Perf: call the solver directly ?
    _simplexSolver.resolve();
}

- (void)stopEditing
{
    if (_editingVariables !== nil)
    {
        var error = nil;

        try {
            _simplexSolver.removeAllEditVars();
            _editingVariables = nil;
        }
        catch (e)
        {
            error = e;
        }
        finally
        {
            if (error !== nil)
                EngineError(error + " EDIT_VARIABLES were " + _editingVariables);
        }
    }
}

- (void)solve
{
    _simplexSolver.solve();
}

- (void)resolve
{
    _simplexSolver.resolve();
}

- (void)replaceStayConstraintsForItem:(id)anItem priority:(CPLayoutPriority)aPriority
{
    var widthStay   = CreateStayConstraint([anItem _variableWidth], aPriority),
        heightStay  = CreateStayConstraint([anItem _variableHeight], aPriority),
        containerId = [anItem debugID],
        type        = "StayConstraint",
        toRemove    = [];

    var onAdd = function(constraint)
    {
        _constraintContainerMap.set(constraint, {"Type":type, "Container":anItem});
        EngineLog("Added " + type + " in " + containerId + " : " + constraint.toString());
    };

    var onAddError = function(error, constraint)
    {
        EngineWarn(containerId + ": could not add " + type + " " + constraint.toString() + " with error " + error);
    };

    var onRemove = function(constraint)
    {
        _constraintContainerMap.delete(constraint);
        EngineLog("Removed " + type + " in " + containerId + " : " + constraint.toString());
    };

    var onRemoveError = function(error, constraint)
    {
        EngineWarn(containerId + ": could not remove " + type + " " + constraint.toString() + " with error " + error);
    };

    var toRemove = [];

    _constraintContainerMap.forEach(function(viewAndType, engine_constraint)
    {
        if (viewAndType.Container == anItem && viewAndType.Type == type)
            toRemove.push(engine_constraint);
    });

    toRemove.forEach(function(engine_constraint, idx)
    {
        RemoveConstraint(_simplexSolver ,engine_constraint, onRemove, onRemoveError);
    });

    AddConstraint(_simplexSolver, widthStay, onAdd, onAddError);
    AddConstraint(_simplexSolver, heightStay, onAdd, onAddError);
}

- (void)addConstraints:(CPArray)constraints
{
    var result = YES;

    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        result &= [self addConstraint:aConstraint];
    }];

    return result;
}

- (void)removeConstraints:(CPArray)constraints
{
    var result = YES;

    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        result &= [self removeConstraint:aConstraint];
    }];

    return result;
}

- (BOOL)addConstraint:(CPLayoutConstraint)aConstraint
{
    var type        = [aConstraint _constraintType],
        container   = [aConstraint container],
        containerId = [container debugID],
        result      = YES;

    var onsuccess = function(constraint)
    {
        _constraintContainerMap.set(constraint, {"Type":type, "Container":container});
        EngineLog("Added " + type + " in " + containerId + " : " + constraint.toString());
        [_delegate engine:self constraintDidChangeInContainer:container];
    };

    var onerror = function(error, constraint)
    {
        EngineWarn(containerId + ": could not add " + type + " " + constraint.toString() + " with error " + error);
    };

    var engine_constraints = [aConstraint _engineConstraints];

    if (!engine_constraints)
    {
        engine_constraints = (type == "SizeConstraint") ? CreateSizeConstraints(aConstraint) : CreateConstraint(aConstraint);
        [aConstraint _setEngineConstraints:engine_constraints];
    }

    [engine_constraints enumerateObjectsUsingBlock:function(engine_constraint, idx, stop)
    {
        result = AddConstraint(_simplexSolver, engine_constraint, onsuccess, onerror);

        if (!result)
            stop(YES);
    }];

    return result;
}

- (BOOL)removeConstraint:(CPLayoutConstraint)aConstraint
{
    var type = [aConstraint _constraintType],
        container = [aConstraint container],
        containerId = [container debugID],
        result = YES;

    var engine_constraints = [aConstraint _engineConstraints];

    var onsuccess = function(constraint)
    {
        _constraintContainerMap.delete(constraint);
        EngineLog("Removed " + type + " in " + containerId + " : " + constraint.toString());
        [_delegate engine:self constraintDidChangeInContainer:container];
    };

    var onerror = function(error, constraint)
    {
        EngineWarn(containerId + ": could not remove " + type + " " + constraint.toString() + " with error " + error);
    };

    [engine_constraints enumerateObjectsUsingBlock:function(engine_constraint, idx, stop)
    {
        result = RemoveConstraint(_simplexSolver, engine_constraint, onsuccess, onerror);

        if (!result)
            stop(YES);
    }];

//CPLog.debug(_cmd + "=" + result);
    return result;
}

- (Variable)variableWithPrefix:(CPString)aPrefix name:(CPString)aName value:(float)aValue owner:(id)anOwner
{
    var variable = new c.Variable({prefix:aPrefix, name:aName, value:aValue});
    _variableOwnerMap.set(variable, anOwner);

    return variable;
}

- (CPString)description
{
    var str = "Engine Constraints:\n";

    _constraintContainerMap.forEach(function(TypeAndContainer, engine_constraint)
    {
        str += [TypeAndContainer.Container debugID] + " (" + TypeAndContainer.Type + ") " + engine_constraint.toString() + "\n";
    });

    return (str + "\nInternalInfo:\n" + _simplexSolver.getInternalInfo());
}

@end

var StrengthForPriority = function(p)
{
//    var h = Math.floor(p / 100),
//        d = Math.floor((p - 100*c) / 10),
//        n = p - 100*c - 10*d;
//    (new c.Strength("", h, d, n))
    if (p >= 1000)
        return {strength:c.Strength.required, weight:p};

    return {strength:c.Strength.medium, weight:p};
};

var CreateConstraint = function(aConstraint)
{
// EngineLog("firstItem " + args.firstItem.uuid + " secondItem " + args.secondItem.uuid + " containerUUID " + args.containerUUID + " flags " + args.flags);

    var firstAttribute    = [aConstraint firstAttribute],
        secondAttribute   = [aConstraint secondAttribute],
        firstItem         = [aConstraint firstItem],
        secondItem        = [aConstraint secondItem],
        firstIsContainer  = [aConstraint _isContainerItem:firstItem],
        secondIsContainer = [aConstraint _isContainerItem:secondItem],
        relation          = [aConstraint relation],
        multiplier        = [aConstraint multiplier],
        constant          = [aConstraint _frameBasedConstant],
        priority          = [aConstraint priority],
        sw                = StrengthForPriority(priority),
        constraint,
        rhs_term;

    var lhs_term = expressionForAttribute(firstAttribute, firstIsContainer, firstItem),
        secondExp = expressionForAttribute(secondAttribute, secondIsContainer, secondItem);

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

    return [constraint];
};

var CreateSizeConstraints = function(aConstraint)
{
    var variable         = [aConstraint variableForOrientation],
        huggingPriority  = [aConstraint huggingPriority],
        compressPriority = [aConstraint compressPriority],
        constant         = [aConstraint constant],
        hugg             = CreateInequality(variable, 0, constant, huggingPriority),
        anticompr        = CreateInequality(variable, 1, constant, compressPriority);

    return [hugg, anticompr];
};

var CreateInequality = function(variable, isGreaterOrLess, constant, priority)
{
    var variableExp = new c.Expression.fromVariable(variable),
        constantExp = new c.Expression.fromConstant(constant),
           relation = (isGreaterOrLess) ? c.GEQ : c.LEQ,
                 sw = StrengthForPriority(priority);

    return new c.Inequality(variableExp, relation, constantExp, sw.strength, sw.weight);
};

var CreateStayConstraint = function(variable, priority)
{
    var sw = StrengthForPriority(priority);

    return new c.StayConstraint(variable, sw.strength, sw.weight);
};

var expressionForAttribute = function(attribute, isContainer, item)
{
    if (item == nil || attribute === CPLayoutAttributeNotAnAttribute)
        return new c.Expression.fromConstant(0);

    var left   = [item _variableMinX],
        top    = [item _variableMinY],
        width  = [item _variableWidth],
        height = [item _variableHeight],
        exp;

    switch(attribute)
    {
        case CPLayoutAttributeLeading   :
        case CPLayoutAttributeLeft      : exp = expressionForAttributeLeft(left, isContainer);
            break;
        case CPLayoutAttributeTrailing  :
        case CPLayoutAttributeRight     : exp = expressionForAttributeRight(left, width, isContainer);
            break;
        case CPLayoutAttributeTop       : exp = expressionForAttributeTop(top, isContainer);
            break;
        case CPLayoutAttributeBaseline  :
        case CPLayoutAttributeBottom    : exp = expressionForAttributeBottom(top, height, isContainer);
            break;
        case CPLayoutAttributeWidth     : exp = new c.Expression.fromVariable(width);
            break;
        case CPLayoutAttributeHeight    : exp = new c.Expression.fromVariable(height);
            break;
        case CPLayoutAttributeCenterX   : exp = expressionForAttributeCenterX(left, width, isContainer);
            break;
        case CPLayoutAttributeCenterY   : exp = expressionForAttributeCenterY(top, height, isContainer);
            break;
    }

    return exp;
};

var expressionForAttributeLeft = function(variable, isContainer)
{
    if (!isContainer)
        return new c.Expression.fromVariable(variable);

    return new c.Expression.fromConstant(0);
};

var expressionForAttributeTop = function(variable, isContainer)
{
    if (!isContainer)
        return new c.Expression.fromVariable(variable);

    return new c.Expression.fromConstant(0);
};

var expressionForAttributeRight = function(leftVariable, widthVariable, isContainer)
{
    if (isContainer)
        return new c.Expression.fromVariable(widthVariable);

    return new c.Expression.fromVariable(leftVariable).plus(widthVariable);
};

var expressionForAttributeBottom = function(topVariable, heightVariable, isContainer)
{
    if (isContainer)
        return new c.Expression.fromVariable(heightVariable);

    return new c.Expression.fromVariable(topVariable).plus(heightVariable);
};

var expressionForAttributeCenterX = function(leftVariable, widthVariable, isContainer)
{
    var midWidth = new c.Expression.fromVariable(widthVariable).divide(2);

    if (isContainer)
        return midWidth;

    var left = new c.Expression.fromVariable(leftVariable);

    return c.plus(left, midWidth);
};

var expressionForAttributeCenterY = function(topVariable, heightVariable, isContainer)
{
    var midHeight = new c.Expression.fromVariable(heightVariable).divide(2);

    if (isContainer)
        return midHeight;

    var top = new c.Expression.fromVariable(topVariable);

    return c.plus(top, midHeight);
};

var AddConstraint = function(solver, constraint, onsuccess, onerror)
{
    var result = true;

    try {
        solver.addConstraint(constraint);
    }
    catch (e)
    {
        onerror(e, constraint);
        result = false;
    }
    finally
    {
        if (result)
            onsuccess(constraint);

        return result;
    }
};

var RemoveConstraint = function(solver, constraint, onsuccess, onerror)
{
    var result = true;

    try {
        solver.removeConstraint(constraint);
    }
    catch (e)
    {
        onerror(e, constraint);
        result = false;
    }
    finally
    {
        if (result)
            onsuccess(constraint);

        return result;
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
