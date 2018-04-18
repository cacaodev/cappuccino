#if ! defined (CASSOWARY_ENGINE) && ! defined (KIWI_ENGINE)
#define CASSOWARY_ENGINE
#endif

@import <Foundation/CPObject.j>
@import <Foundation/CPRunLoop.j>
@import <Foundation/CPBundle.j>
@import <Foundation/CPIndexSet.j>

@import "CPLayoutConstraint.j"
#if defined (CASSOWARY_ENGINE)
@import "c.js"
#elif defined (KIWI_ENGINE)
@import "kiwi.js"
#endif

#if defined (CASSOWARY_ENGINE)
@typedef SimplexSolver
@global c
#elif defined (KIWI_ENGINE)
@typedef Solver
@global kiwi
#endif

@global engine_expressionFromVariable
@global engine_expressionFromConstant
@global engine_plus
@global engine_multiply

@implementation CPLayoutConstraintEngine : CPObject
{
#if defined (CASSOWARY_ENGINE)
    SimplexSolver _simplexSolver;
#elif defined (KIWI_ENGINE)
    Solver        _simplexSolver;
#endif
    Map           _constraintToOwnerMap @accessors(readonly);
    Map           _variableToOwnerMap   @accessors(readonly);
    CPArray       _editingVariables;
    id            _delegate             @accessors(getter=delegate, setter=_setDelegate:);
}

+ (void)initialize
{
    if (self !== [CPLayoutConstraintEngine class])
        return;

#if !PLATFORM(DOM)
    kiwi = module.exports;
#endif

#if defined (CASSOWARY_ENGINE)
    EngineInfo("Using Cassowary engine.");
#elif defined (KIWI_ENGINE)
    EngineInfo("Using Kiwi engine.");
#endif
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

#if defined (CASSOWARY_ENGINE)
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
#elif defined (KIWI_ENGINE)
    _simplexSolver = new kiwi.Solver();
    _simplexSolver.onsolved = function(variable)
    {
        var container = _variableToOwnerMap.get(variable);
        [container valueOfVariable:variable didChangeInEngine:self];
    };
#endif
    return self;
}

- (void)disableOnSolvedNotification
{
    _simplexSolver.onsolved = function(){};
}

- (void)suggestValues:(CPArray)values forVariables:(CPArray)variables withPriority:(CPLayoutPriority)aPriority
{
    if (_editingVariables == nil)
    {
        variables.forEach(function(variable)
        {
// It seems that Cassowary and Kiwi are not behaving the same when it comes to add editVars + suggest values.
// Cassowary needs the strength of the edit var to be higher than anything (or at leat higher than the constraints
// that already hold the variable edited) but not required.
// Kiwi does not have this requirement, you can add an edit variable with a given strength and then solve the whole system.
// For example, in Autolayout when the user resizes the window by dragging the corner, the priority is 510.
#if defined (CASSOWARY_ENGINE)
           _simplexSolver.addEditVar(variable, c.Strength.strong, 1);
#elif defined (KIWI_ENGINE)
           _simplexSolver.addEditVariable(variable, StrengthForPriority(aPriority));
#endif
        });

        _editingVariables = variables;
    }

    _editingVariables.forEach(function(variable, idx)
    {
        _simplexSolver.suggestValue(variable, values[idx]);
    });
#if defined (CASSOWARY_ENGINE)
    _simplexSolver.resolve();
#elif defined (KIWI_ENGINE)
    _simplexSolver.updateVariables();
#endif
}

- (void)stopEditing
{
    if (_editingVariables !== nil)
    {
        var error = nil;

        try {
#if defined (CASSOWARY_ENGINE)
            _simplexSolver.removeAllEditVars();
#elif defined (KIWI_ENGINE)
            _editingVariables.forEach(function(variable, idx)
            {
                _simplexSolver.removeEditVariable(variable);
            });
#endif
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
#if defined (CASSOWARY_ENGINE)
    _simplexSolver.solve();
#elif defined (KIWI_ENGINE)
    _simplexSolver.updateVariables();
#endif
}

- (void)resolve
{
#if defined (CASSOWARY_ENGINE)
    _simplexSolver.resolve();
#elif defined (KIWI_ENGINE)
    _simplexSolver.updateVariables();
#endif
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
#if defined (CASSOWARY_ENGINE)
        if (error._name == "c.RequiredFailure")
#elif defined (KIWI_ENGINE)
        if (error.message == "unsatisfiable constraint")
#endif
            CPLog.warn("Unable to simultaneously satisfy constraints.\nThe following constraint conflicts with an existing constraint.\n" + [aConstraint description] + "\nYou can fix the problem by changing the current required priority to a lower priority.");
        else
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
        if (contextOfVariable(variable) == aPrefix && nameOfVariable(variable) == aName)
        {
            result = variable;
#if (DEBUG)
            EngineInfo([CPString stringWithFormat:"Reuse variable %@(%@)[%@]", aPrefix, [[owner _referenceItem] debugID], aName]);
#endif
        }
    });

    if (result == nil)
    {
        result = newVariable(aPrefix, aName, aValue);
        _variableToOwnerMap.set(result, anOwner);
    }

    return result;
}

- (CPInteger)valueOfVariable:(Variable)aVariable
{
#if defined (CASSOWARY_ENGINE)
    return aVariable.valueOf();
#elif defined (KIWI_ENGINE)
    return aVariable.value();
#endif
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

engine_expressionFromConstant = function(cst)
{
#if defined (CASSOWARY_ENGINE)
    return new c.Expression.fromConstant(cst);
#elif defined (KIWI_ENGINE)
    return new kiwi.Expression(cst);
#endif
};

engine_expressionFromVariable = function(v)
{
#if defined (CASSOWARY_ENGINE)
    return new c.Expression.fromVariable(v);
#elif defined (KIWI_ENGINE)
    return new kiwi.Expression(v);
#endif
};

engine_plus = function(exp1, exp2)
{
#if defined (CASSOWARY_ENGINE)
    return c.plus(exp1, exp2);
#elif defined (KIWI_ENGINE)
    return exp1.plus(exp2);
#endif
};

engine_multiply = function(exp1, exp2)
{
#if defined (CASSOWARY_ENGINE)
    return c.times(exp1, exp2);
#elif defined (KIWI_ENGINE)
    return exp1.multiply(exp2);
#endif
};

var contextOfVariable = function(variable)
{
#if defined (CASSOWARY_ENGINE)
    return variable._prefix;
#elif defined (KIWI_ENGINE)
    return variable.context();
#endif
};

var nameOfVariable = function(variable)
{
#if defined (CASSOWARY_ENGINE)
    return variable.name;
#elif defined (KIWI_ENGINE)
    return variable.name();
#endif
};

var expressionIsConstant = function(exp)
{
#if defined (CASSOWARY_ENGINE)
    return exp.isConstant;
#elif defined (KIWI_ENGINE)
    return exp.isConstant();
#endif
}

var constantForExpression = function(exp)
{
#if defined (CASSOWARY_ENGINE)
    return exp.constant;
#elif defined (KIWI_ENGINE)
    return exp.constant();
#endif
};

var StrengthForPriority = function(p)
{
    if (p >= 1000)
#if defined (CASSOWARY_ENGINE)
        return c.Strength.required;
#elif defined (KIWI_ENGINE)
        return kiwi.Strength.required;
#endif

#if defined (CASSOWARY_ENGINE)
    else
        return c.Strength.medium;
#elif defined (KIWI_ENGINE)
    // FIXME: ideally,  stengths/weights should be treated with lexographic ordering.
    // See https://github.com/nucleic/kiwi/issues/33
    else if (p < 250)
    {
        return kiwi.Strength.create(0, 0, 0, 0, 0, 1, p);
    }
    else if (p < 490)
    {
        return kiwi.Strength.create(0, 0, 0, 0, 1, 0, p - 249);
    }
    else if (p < 500)
    {
        return kiwi.Strength.create(0, 0, 0, 1, 0, 0, p - 489);
    }
    else if (p < 510)
    {
        return kiwi.Strength.create(0, 0, 1, 0, 0, 0, p - 499);
    }
    else if (p < 750)
    {
        return kiwi.Strength.create(0, 1, 0, 0, 0, 0, p - 509);
    }
    else if (p < 1000)
    {
        return kiwi.Strength.create(1, 0, 0, 0, 0, 0, p - 749);
    }
#endif
};

var newVariable = function(aPrefix, aName, aValue)
{
#if defined (CASSOWARY_ENGINE)
    return new c.Variable({prefix:aPrefix, name:aName, value:aValue});
#elif defined (KIWI_ENGINE)
    var result = new kiwi.Variable(aName);
    result.setValue(aValue);
    result.setContext(aPrefix);
    return result;
#endif
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
        strength          = StrengthForPriority(priority),
        constraint,
        rhs_term;

    var lhs_term = [firstAnchor expressionInContext:secondAnchor];

    if (secondAnchor == nil || multiplier == 0)
    {
        rhs_term = engine_expressionFromConstant(constant);
    }
    else
    {
        var secondExp = [secondAnchor expressionInContext:firstAnchor];

        if (expressionIsConstant(secondExp))
        {
            rhs_term = engine_expressionFromConstant(constantForExpression(secondExp) * multiplier + constant);
        }
        else
        {
            rhs_term = engine_plus(engine_multiply(secondExp, multiplier), constant);
        }
    }

    if (lhs_term == nil || rhs_term == nil)
        [CPException raise:CPInvalidArgumentException format:"The lhs %@ or rhs %@ of an Equation cannot be nil", lhs_term, rhs_term];

    var constraint = newConstraint(lhs_term, relation, rhs_term, strength, priority);

    return [constraint];
};

var newConstraint = function(lhs_term, relation, rhs_term, strength, priority)
{
    var constraint;
#if defined (CASSOWARY_ENGINE)
    switch(relation)
    {
        case CPLayoutRelationLessThanOrEqual    : constraint = new c.Inequality(lhs_term, c.LEQ, rhs_term, strength, priority);
            break;
        case CPLayoutRelationGreaterThanOrEqual : constraint = new c.Inequality(lhs_term, c.GEQ, rhs_term, strength, priority);
            break;
        case CPLayoutRelationEqual              : constraint = new c.Equation(lhs_term, rhs_term, strength, priority);
            break;
    }
#elif defined (KIWI_ENGINE)
    var operator;
    switch(relation)
    {
        case CPLayoutRelationLessThanOrEqual    : operator = kiwi.Operator.Le;
            break;
        case CPLayoutRelationGreaterThanOrEqual : operator = kiwi.Operator.Ge;
            break;
        case CPLayoutRelationEqual              : operator = kiwi.Operator.Eq;
            break;
    }

    constraint = new kiwi.Constraint(lhs_term, operator, rhs_term, strength);
#endif

    return constraint;
};

var CreateSizeConstraints = function(aConstraint)
{
    var variable         = [aConstraint variableForOrientation],
        huggingPriority  = [aConstraint huggingPriority],
        compressPriority = [aConstraint compressPriority],
        constant         = [aConstraint constant];
#if defined (CASSOWARY_ENGINE)
    var leqOperator = c.LEQ,
        geqOperator = c.GEQ;
#elif defined (KIWI_ENGINE)
    var leqOperator = kiwi.Operator.Le,
        geqOperator = kiwi.Operator.Ge;
#endif

    var hugg             = CreateInequality(variable, leqOperator, constant, huggingPriority),
        anticompr        = CreateInequality(variable, geqOperator, constant, compressPriority);

    return [hugg, anticompr];
};

var CreateInequality = function(variable, operator, constant, priority)
{
    var variableExp = engine_expressionFromVariable(variable),
        constantExp = engine_expressionFromConstant(constant),
           strength = StrengthForPriority(priority);
#if defined (CASSOWARY_ENGINE)
    return new c.Inequality(variableExp, operator, constantExp, strength, priority);
#elif defined (KIWI_ENGINE)
    return new kiwi.Constraint(variableExp, operator, constantExp, strength);
#endif
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
#if PLATFORM(DOM)
    console.log('%c [Engine]: ' + str, 'color:darkblue; font-weight:bold');
#endif
};

var EngineInfo = function(str)
{
#if PLATFORM(DOM)
    console.log('%c [Engine]: ' + str, 'color:purple; font-weight:bold');
#endif
};

var EngineWarn = function(str)
{
    console.warn('%c [Engine]: ' + str, 'color:brown; font-weight:bold');
};

var EngineError = function(str)
{
    CPLog.error('%c [Engine]: ' + str, 'color:darkred; font-weight:bold');
};
