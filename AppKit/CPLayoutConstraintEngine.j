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
    Map           _constraintToOwnerMap;
    Map           _variableToOwnerMap;
    CPArray       _editingVariables;
    Object        _defaultEditStrength;
    id            _delegate @accessors(getter=delegate);
}

+ (CPArray)_engineConstraintsFromConstraint:(CPLayoutConstraint)aConstraint
{
    return CreateConstraint(aConstraint);
}

+ (CPArray)_engineConstraintsFromContentSizeConstraint:(CPLayoutConstraint)aConstraint
{
    return CreateSizeConstraints(aConstraint);
}

- (id)initWithDelegate:(id)aDelegate
{
    self = [super init];

    _variableToOwnerMap = new Map();
    _constraintToOwnerMap = new Map();
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
                owner = _variableToOwnerMap.get(variable);

            [owner valueOfVariable:variable didChangeInEngine:self];
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

- (BOOL)addConstraints:(CPArray)constraints
{
    var result = YES;

    [constraints enumerateObjectsUsingBlock:function(aConstraint, idx, stop)
    {
        result &= [self addConstraint:aConstraint];
    }];

    return result;
}

- (BOOL)removeConstraints:(CPArray)constraints
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
        _constraintToOwnerMap.set(constraint, {"Type":type, "Container":container});
        EngineLog("Added " + type + " in " + containerId + " : " + constraint.toString());
        [_delegate engine:self constraintDidChangeInContainer:container];
    };

    var onerror = function(error, constraint)
    {
        EngineWarn(containerId + ": could not add " + type + " " + constraint.toString() + " with error " + error);
    };

    var engine_constraints = [aConstraint _engineConstraints];

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
        _constraintToOwnerMap.delete(constraint);
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
    //CPLog.debug(_cmd + " prefix" + aPrefix + " name:" + aName + " value:" + aValue);
    var result = nil,
        variables = Array.from(_variableToOwnerMap.keys());

    [variables enumerateObjectsUsingBlock:function(variable, idx, stop)
    {
        if (variable._prefix == aPrefix && variable.name == aName)
        {
            result = variable;
            stop(YES);
            var anchor = _variableToOwnerMap.get(variable);
            EngineWarn([CPString stringWithFormat:"Reuse variable %@(%@)[%@]", aPrefix, [[anchor _referenceItem] debugID], aName]);
        }
    }];

    if (result == nil)
        result = new c.Variable({prefix:aPrefix, name:aName, value:aValue});

    [[anOwner _constituentAnchors] enumerateObjectsUsingBlock:function(anchor, idx, stop)
    {
        if (_variableToOwnerMap.get(result) == null)
            _variableToOwnerMap.set(result, anchor);
    }];

    return result;
}

- (CPString)description
{
    var str = "Engine Constraints:\n";

    _constraintToOwnerMap.forEach(function(TypeAndContainer, engine_constraint)
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

    var firstAnchor       = [aConstraint firstAnchor],
        secondAnchor      = [aConstraint secondAnchor],
        relation          = [aConstraint relation],
        multiplier        = [aConstraint multiplier],
        constant          = [aConstraint _frameBasedConstant],
        priority          = [aConstraint priority],
        sw                = StrengthForPriority(priority),
        constraint,
        rhs_term;

    var lhs_term = [firstAnchor expressionInContext:secondAnchor];

    if (secondAnchor == nil || multiplier == 0)
    {
        rhs_term = new c.Expression.fromConstant(constant);
    }
    else
    {
        var secondExp = [secondAnchor expressionInContext:firstAnchor];

        if (secondExp.isConstant)
        {
            rhs_term = new c.Expression.fromConstant(secondExp.constant * multiplier + constant);
        }
        else
        {
            rhs_term = c.plus(c.times(secondExp, multiplier), constant);
        }
    }

    if (lhs_term == nil || rhs_term == nil)
        [CPException raise:CPInvalidArgumentException format:"The lhs %@ or rhs %@ of an Equation cannot be nil", lhs_term, rhs_term];

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
