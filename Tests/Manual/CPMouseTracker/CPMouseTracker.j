/*
 * CPMouseTracker
 *
 * Created by cacaodev on February 11, 2012.
 * Copyright 2012.
 */

var startTracking        = 1 << 1,
    continueTracking     = 1 << 2,
    stopTracking         = 1 << 3,
    constrainPoint       = 1 << 4,
    handlePeriodicEvents = 1 << 5;

@implementation CPMouseTracker : CPObject
{
    CGPoint _initialPoint   @accessors(getter=initialPoint);
    CGPoint _previousPoint;
    CGPoint _currentPoint   @accessors(getter=currentPoint);

    CPEvent _initialEvent;
    CPEvent _previousEvent;
    CPEvent _currentEvent;

    CPView  _view        @accessors(getter=view);
    id      _delegate    @accessors(getter=delegate);
    double  _delay       @accessors(getter=delay);
    double  _interval    @accessors(getter=interval);

    int _eventMask       @accessors(property=eventMask);

    unsigned int _trackingConstraint        @accessors(property=trackingConstraint);
    unsigned int _trackingConstraintKeyMask @accessors(property=trackingConstraintKeyMask);

    int _delegateRespondTo;
}

- (id)init
{
    self = [super init];

    _delay = 0.2;
    _interval = 0.025;

    _initialEvent = nil;
    _previousEvent = nil;
    _currentEvent = nil;

    _initialPoint = CGPointMakeZero();
    _previousPoint = CGPointMakeZero();
    _currentPoint = CGPointMakeZero();

    _delegateRespondTo = 0;
    _trackingConstraint = 0;
    _trackingConstraintKeyMask = 0;
    _eventMask = CPLeftMouseDraggedMask|CPLeftMouseUpMask;

    _delegate = nil;
    _view = nil;

    return self;
}

- (void)setPeriodicDelay:(double)aDelay interval:(double)anInterval
{
    _delay = aDelay;
    _interval = anInterval;
}

- (CGPoint)_getLocalPoint:(CPEvent)anEvent
{
    var locationInWindow = [anEvent locationInWindow];
    var point = [_view convertPoint:locationInWindow fromView:nil];

    return point;
}

- (BOOL)trackWithEvent:(CPEvent)anEvent inView:(CPView)aView withDelegate:(id)aDelegate
{
    if ([self startTrackingWithEvent:anEvent inView:aView withDelegate:aDelegate])
    {
        //if (_delegateRespondTo & handlePeriodicEvents)
        //    [CPEvent startPeriodicEventsAfterDelay:_delay withPeriod:_interval];

        var ret = [self continueTrackingWithEvent:anEvent];
    }

    [self _releaseEvents];

    return ret;
}

- (BOOL)startTrackingWithEvent:(CPEvent)anEvent inView:(CPView)aView withDelegate:(id)aDelegate
{
    [self _setDelegate:aDelegate];
    _view = aView;

    [self _releaseEvents];

    _initialEvent = anEvent;
    _currentEvent = anEvent;

    _initialPoint = [self _getLocalPoint:anEvent];;
    _currentPoint = [self _constrainPoint:_initialPoint withEvent:anEvent];
    _previousPoint = _currentPoint;

    if ( _delegateRespondTo & startTracking )
        return [_delegate mouseTracker:self shouldStartTrackingWithEvent:anEvent];

    return YES;
}

- (BOOL)continueTrackingWithEvent:(CPEvent)anEvent
{
    if ([anEvent type] == CPLeftMouseUp ||
        (_delegateRespondTo & continueTracking
        && !CGPointEqualToPoint(_previousPoint, _currentPoint)
        && ![_delegate mouseTracker:self shouldContinueTrackingWithEvent:anEvent]))
    {
        return [self stopTrackingWithEvent:anEvent];
    }

    _previousEvent = _currentEvent;
    _currentEvent = anEvent;

    _previousPoint = _currentPoint;
    var local = [self _getLocalPoint:anEvent];
    _currentPoint = [self _constrainPoint:local withEvent:anEvent];

    CPLogConsole(_cmd);
    [CPApp setTarget:self selector:@selector(continueTrackingWithEvent:) forNextEventMatchingMask:_eventMask untilDate:[CPDate distantFuture] inMode:nil dequeue:YES];

    return YES;
}

- (BOOL)stopTrackingWithEvent:(CPEvent)anEvent
{
    var localPoint = [self _getLocalPoint:anEvent];
    _currentPoint = [self _constrainPoint:localPoint withEvent:anEvent];
    _previousPoint = _currentPoint;

    //if (_delegateRespondTo & handlePeriodicEvents)
    //    [CPEvent stopPeriodicEvents];

    var stop = NO;

    if (_delegateRespondTo & stopTracking)
        stop = [_delegate mouseTracker:self didStopTrackingWithEvent:anEvent];

    [self _releaseEvents];

    return stop;
}

- (void)_releaseEvents
{
    _initialEvent = nil;
    _previousEvent = nil;
    _currentEvent = nil;
}

- (void)_setDelegate:(id)aDelegate
{
    if (_delegate != aDelegate )
    {
        _delegate = aDelegate;
        _delegateRespondTo = 0;

        if ([_delegate respondsToSelector:@selector(mouseTracker:shouldStartTrackingWithEvent:)])
            _delegateRespondTo |= startTracking;

        if ([_delegate respondsToSelector:@selector(mouseTracker:shouldContinueTrackingWithEvent:)])
            _delegateRespondTo |= continueTracking;

        if ([_delegate respondsToSelector:@selector(mouseTracker:didStopTrackingWithEvent:)])
            _delegateRespondTo |= stopTracking;

        if ([_delegate respondsToSelector:@selector(mouseTracker:constrainPoint:withEvent:)])
            _delegateRespondTo |= constrainPoint;

        if ([_delegate respondsToSelector:@selector(mouseTracker:handlePeriodicEvent:)])
            _delegateRespondTo |= handlePeriodicEvents;
    }
}


- (CGPoint)_constrainPoint:(CGPoint)aPoint withEvent:(CPEvent)anEvent
{
    var constPoint = CGPointCreateCopy(aPoint);

    if (_delegateRespondTo & constrainPoint)
        constPoint= [_delegate mouseTracker:self constrainPoint:constPoint withEvent:anEvent];

    if (_trackingConstraint != 0 && (_trackingConstraintKeyMask == 0 || [anEvent modifierFlags] & _trackingConstraintKeyMask))
    {
        if (_trackingConstraint == 1)
        {
            constPoint.y = _initialPoint.y;
        }

        else if (_trackingConstraint == 2)
        {
            constPoint.x = _initialPoint.x;
        }

        else if (_trackingConstraint == 3)
        {
            constPoint.y = _initialPoint.y + (constPoint.x - _initialPoint.x);
        }
    }

    return constPoint;
}

@end