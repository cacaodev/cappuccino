@import "CPLayoutConstraint.j"

@implementation CPAutoresizingMaskLayoutConstraint : CPLayoutConstraint
{
}

- (CPView)viewForAutoresizingMask
{
    return (_firstItem !== _container) ? _firstItem : _secondItem;
}

- (CPString)_constraintType
{
    return @"AutoresizingConstraint";
}

+ (CPArray)constraintsWithAutoresizingMask:(unsigned)aMask subitem:(id)subItem frame:(CGRect)aFrame superitem:(id)superItem bounds:(CGRect)bounds
{
    var hconstraints = [CPAutoresizingMaskLayoutConstraint _constraintsWithAutoresizingMask:aMask subitem:subItem frame:aFrame superitem:superItem bounds:bounds orientation:0];

    var vconstraints = [CPAutoresizingMaskLayoutConstraint _constraintsWithAutoresizingMask:aMask subitem:subItem frame:aFrame superitem:superItem bounds:bounds orientation:1];

    return [hconstraints arrayByAddingObjectsFromArray:vconstraints];
}

+ (CPArray)_constraintsWithAutoresizingMask:(unsigned)aMask subitem:(id)subItem frame:(CGRect)aFrame superitem:(id)superItem bounds:(CGRect)bounds orientation:(CPInteger)orientation
{
    var result = [CPArray array];

    if (!superItem)
        return result;

    var min                   = orientation ? CGRectGetMinY(aFrame) : CGRectGetMinX(aFrame),
        max                   = orientation ? CGRectGetMaxY(aFrame) : CGRectGetMaxX(aFrame),
        size                  = orientation ? CGRectGetHeight(aFrame) : CGRectGetWidth(aFrame),
        ssize                 = orientation ? CGRectGetHeight(bounds) : CGRectGetWidth(bounds),
        CPViewMinMargin       = orientation ? CPViewMinYMargin : CPViewMinXMargin,
        CPViewMaxMargin       = orientation ? CPViewMaxYMargin : CPViewMaxXMargin,
        CPViewSizable         = orientation ? CPViewHeightSizable : CPViewWidthSizable,
        CPLayoutAttributeMin  = orientation ? CPLayoutAttributeTop : CPLayoutAttributeLeft,
        CPLayoutAttributeMax  = orientation ? CPLayoutAttributeBottom : CPLayoutAttributeRight,
        CPLayoutAttributeSize = orientation ? CPLayoutAttributeHeight : CPLayoutAttributeWidth;

    var pconstraint,
        sconstaint;

    if (!(aMask & CPViewSizable))
    {
        var sconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeSize relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:0 constant:size];

        if ((aMask & CPViewMinMargin) && (aMask & CPViewMaxMargin))
        {
            var m = min / (ssize - size),
                k = - m * size;

            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMin relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeSize multiplier:m constant:k];
        }
        else if (aMask & CPViewMinMargin)
        {
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMax relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeMax multiplier:1 constant:(max - ssize)];
        }
        else // CPViewMaxMargin or no H aMask
        {
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMin relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:0 constant:min];
        }
    }
    else
    {
        var pconstraint,
            sconstaint;

        if ((aMask & CPViewMinMargin) && (aMask & CPViewMaxMargin))
        {
            var m = min / ssize;
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMin relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeSize multiplier:m constant:0];

            m = size / ssize;
            sconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeSize relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeSize multiplier:m constant:0];
        }
        else if (aMask & CPViewMinMargin)
        {
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMax relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeMax multiplier:1 constant:(max - ssize)];

            var m = size / max,
                k = size - m * ssize;

            sconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeSize relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeSize multiplier:m constant:k];

        }
        else if (aMask & CPViewMaxMargin)
        {
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMin relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:0 constant:min];

            var m = size / (ssize - min),
                k = - m * min;

            sconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeSize relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeSize multiplier:m constant:k];
        }
        else
        {
            pconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMin relatedBy:CPLayoutRelationEqual toItem:nil attribute:CPLayoutAttributeNotAnAttribute multiplier:0 constant:min];

            sconstraint = [CPAutoresizingMaskLayoutConstraint constraintWithItem:subItem attribute:CPLayoutAttributeMax relatedBy:CPLayoutRelationEqual toItem:superItem attribute:CPLayoutAttributeMax multiplier:1 constant:(max - ssize)];
        }
    }

    [pconstraint _setContainer:superItem];
    [sconstraint _setContainer:superItem];

    [result addObject:pconstraint];
    [result addObject:sconstraint];

    return result;
}

@end