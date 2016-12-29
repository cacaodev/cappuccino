@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import <Foundation/CPBundle.j>
@import <Foundation/CPIndexSet.j>

@import "CPLayoutConstraint.j"
@import "c.js"

@typedef SimplexSolver
@typedef Map

var SOLVER_DEFAULT_EDIT_STRENGTH;

@implementation CPLayoutConstraintEngine : CPObject
{
    SimplexSolver _simplexSolver;
    Map           _constraintToOwnerMap @accessors(readonly);
    Map           _variableToOwnerMap @accessors(readonly);
    CPArray       _editingVariables;
    id            _delegate @accessors(getter=delegate, setter=_setDelegate:);
}

+ (void)initialize
{
    SOLVER_DEFAULT_EDIT_STRENGTH = c.Strength.strong;
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
           _simplexSolver.addEditVar(variable, SOLVER_DEFAULT_EDIT_STRENGTH, 1);
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
#if (DEBUG)
        EngineLog("Added " + type + " in " + containerId + " : " + constraint.toString());
#endif
        [_delegate engine:self constraintDidChangeInContainer:container];
    };

    var onerror = function(error, constraint)
    {
        CPLog.warn("Unable to simultaneously satisfy constraints.\nThe following constraint conflicts with an existing constraint.\n" + [aConstraint description] + "\nYou can fix the problem by changing the current required priority to a lower priority.");
#if (DEBUG)
        EngineWarn(containerId + ": could not add " + type + " " + constraint.toString() + " with error " + error);
#endif
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
#if (DEBUG)
        EngineLog("Removed " + type + " in " + containerId + " : " + constraint.toString());
#endif
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

- (BOOL)_addConstraintsFromEngine:(CPLayoutConstraintEngine)anEngine passingTest:(Function/* cst, type, owner */)predicateFunction
{
    var aConstraintToOwnerMap = [anEngine _constraintToOwnerMap],
        aVariableToOwnerMap = [anEngine _variableToOwnerMap],
        result = YES;

    var onerror = function(error, constraint)
    {
        CPLog.warn("Unable to simultaneously satisfy constraints.\nThe following constraint conflicts with an existing constraint.\n" + constraint.toString() + "\nYou can fix the problem by changing the current required priority to a lower priority.");
    };

    aConstraintToOwnerMap.forEach(function(TypeAndContainer, engine_constraint)
    {
        if (!predicateFunction(engine_constraint, TypeAndContainer.Type, TypeAndContainer.Container))
            return;

        var onsuccess = function(constraint)
        {
            _constraintToOwnerMap.set(constraint, {"Type":TypeAndContainer.Type, "Container":TypeAndContainer.Container});
        };

        result &= AddConstraint(_simplexSolver, engine_constraint, onsuccess, onerror);
    });

    aVariableToOwnerMap.forEach(function(owner, variable)
    {
        _variableToOwnerMap.set(variable, owner);
    });

    return result;
}

- (void)_discard
{
    _constraintToOwnerMap.forEach(function(TypeAndContainer, engine_constraint)
    {
        _simplexSolver.removeConstraint(engine_constraint);
    });

    _constraintToOwnerMap = nil;
    _variableToOwnerMap = nil;
    _simplexSolver = nil;
    _delegate = nil;
    _editingVariables = nil;
}

- (Variable)variableWithPrefix:(CPString)aPrefix name:(CPString)aName value:(float)aValue owner:(id)anOwner
{
    if ([anOwner _anchorType] !== 0)
        [CPException raise:CPInvalidArgumentException format:@"The variable owner %@ is not a simple (with one variable) anchor. This should never happen", anOwner];

    //CPLog.debug(_cmd + " prefix:" + aPrefix + " name:" + aName + " owner:" + [aSimpleAnchor description]);
    var result = nil;

    _variableToOwnerMap.forEach(function(owner, variable)
    {
        if (variable._prefix == aPrefix && variable.name == aName)
        {
            result = variable;
#if (DEBUG)
            EngineWarn([CPString stringWithFormat:"Reuse variable %@(%@)[%@]", aPrefix, [[owner _referenceItem] debugID], aName]);
#endif
        }
    });

    if (result == nil)
    {
        result = new c.Variable({prefix:aPrefix, name:aName, value:aValue});
        _variableToOwnerMap.set(result, anOwner);
    }

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
    if (p >= 1000)
        return {strength:c.Strength.required, weight:1};

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
        hugg             = CreateInequality(variable, c.LEQ, constant, huggingPriority),
        anticompr        = CreateInequality(variable, c.GEQ, constant, compressPriority);

    return [hugg, anticompr];
};

var CreateInequality = function(variable, relation, constant, priority)
{
    var variableExp = new c.Expression.fromVariable(variable),
        constantExp = new c.Expression.fromConstant(constant),
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
        if (onerror)
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
        if (onerror)
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
