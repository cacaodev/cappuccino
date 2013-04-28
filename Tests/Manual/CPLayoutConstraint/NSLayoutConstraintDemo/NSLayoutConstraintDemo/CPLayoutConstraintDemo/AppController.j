/*
 * AppController.j
 * CPLayoutConstraintDemo
 *
 * Created by You on April 24, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

CPLogRegister(CPLogConsole);

@implementation GridView : CPView

- (void)drawRect:(CGRect)dirtyRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];

    [[CPColor blueColor] setStroke];
    [[CPColor colorWithWhite:0.9 alpha:1] setFill];

    CGContextFillRect(ctx, [self bounds]);

    [CPBezierPath setDefaultLineWidth:1];
    var width = CGRectGetWidth(dirtyRect);
    var height = CGRectGetHeight(dirtyRect);

    var startPoint = CGPointMake(0, 0);
    var endPoint = CGPointMake(0, height);

    var spacing = 50;

    while (startPoint.x < width)
    {
        startPoint.x += spacing;
        endPoint.x += spacing;
        [CPBezierPath strokeLineFromPoint:startPoint toPoint:endPoint];
    }

    startPoint = CGPointMake(0, 0);
    endPoint = CGPointMake(width, 0);

    while (startPoint.y < height)
    {
        startPoint.y += spacing;
        endPoint.y += spacing;
        [CPBezierPath strokeLineFromPoint:startPoint toPoint:endPoint];
    }
}

@end

@implementation FlippedView : CPView
{
    CPColor color;
}

- (id)awakeFromCib
{
    [self setColor:[CPColor greenColor]];
}

- (void)setColor:(CPColor)aColor
{
    color = aColor;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(CGRect)aRect
{
    var ctx = [[CPGraphicsContext currentContext] graphicsPort];
    [color set];

    CGContextFillRect(ctx, [self bounds]);
}

@end

@implementation ColorView : FlippedView
{
}

- (id)awakeFromCib
{
    [self setColor:[CPColor redColor]];
}

@end

@implementation Window : CPWindow
{
}
- (BOOL)canBecomeKeyWindow
{
    return NO;
}

@end

@implementation WindowController : CPWindowController
{
}

- (void)loadWindow
{
    if (_window)
        return;

    var owner = _cibOwner || self;

    [[CPBundle mainBundle] loadCibFile:[self windowCibPath] externalNameTable:@{ CPCibOwner: owner}];
}

- (void)windowDidLoad
{
    CPLog.debug("windowDidLoad");
}

@end

@implementation AppController : CPObject
{
    @outlet CPWindow theWindow;
    CPWindowController currentController;
    CPDictionary windowControllers;
    Window _window @accessors(property=window);
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
}

- (void)awakeFromCib
{
    [theWindow setFullPlatformWindow:YES];
}

- (void)init
{
    self = [super init];

    windowControllers = @{};
    currentController = nil;
    _window = nil;

    return self;
}

- (void)showWindowCibName:(CPString)aWindowCibName
{
    try
    {
        [self _showWindowCibName:aWindowCibName];
    }
    catch(e)
    {
        document.write("<pre>"+e+"</pre>");
    }
}

- (void)_showWindowCibName:(CPString)aWindowCibName
{
    if (currentController)
        [currentController close];

    currentController = [windowControllers objectForKey:aWindowCibName];

    if (!currentController)
    {
        currentController = [[WindowController alloc] initWithWindowCibName:aWindowCibName owner:nil];

        [windowControllers setObject:currentController forKey:aWindowCibName];
    }

    [currentController showWindow:nil];

    var window = [currentController window];
    [window center];
    [window setTitle:aWindowCibName];

}

- (void)setWindowLeft:(float)left top:(float)top Width:(float)width height:(float)height
{
    [[currentController window] setFrame:CGRectMake(left, top, width, height + 9)];
}

@end
