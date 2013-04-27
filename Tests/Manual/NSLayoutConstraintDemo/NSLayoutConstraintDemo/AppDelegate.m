//
//  AppDelegate.m
//  NSLayoutConstraintDemo
//
//  Created by x on 24/04/13.
//  Copyright (c) 2013 x. All rights reserved.
//

#import "AppDelegate.h"

@implementation FlippedView

- (BOOL)isFlipped
{
    return YES;
}

@end

@implementation ColorView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor redColor] set];
    
    NSRectFill([self bounds]);
}

@end

@implementation GridView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor blueColor] setStroke];
    [[NSColor colorWithCalibratedWhite:0.9 alpha:1] setFill];
    NSRectFill(dirtyRect);
    
    [NSBezierPath setDefaultLineWidth:1];
    float width = CGRectGetWidth(dirtyRect);
    float height = CGRectGetHeight(dirtyRect);
    
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, height);
    
    float spacing = 50;
    
    while (startPoint.x < width) {
        startPoint.x += spacing;
        endPoint.x += spacing;
        [NSBezierPath strokeLineFromPoint:startPoint toPoint:endPoint];
    }
    
    startPoint = CGPointMake(0, 0);
    endPoint = CGPointMake(width, 0);
        
    while (startPoint.y < height) {
        startPoint.y += spacing;
        endPoint.y += spacing;
        [NSBezierPath strokeLineFromPoint:startPoint toPoint:endPoint];
    }

}

@end

@interface Window : NSWindow
{
    CGRect _constraintRect;
}

@property(assign) CGRect constraintRect;
@end

@implementation Window

- (BOOL)canBecomeKeyWindow
{
    return NO;
}

- (NSRect)constrainFrameRect:(NSRect)frameRect toScreen:(NSScreen *)screen
{
    float x = MAX(CGRectGetMinX(frameRect), CGRectGetMinX(self.constraintRect));
    x = MIN(x, CGRectGetMaxX(self.constraintRect) - CGRectGetWidth(frameRect));

    float y = MAX(CGRectGetMinY(frameRect), CGRectGetMinY(self.constraintRect));
    y = MIN(y, CGRectGetMaxY(self.constraintRect) - CGRectGetHeight(frameRect));

    frameRect.origin.x = x;
    frameRect.origin.y = y;
    
    return frameRect;
}

@end


@implementation WindowController

- (void)windowDidLoad
{
    NSLog(@"%s", _cmd);
}

@end

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

-(id)init
{
    self = [super init];
    
    self.currentController = nil;
    webScriptObject = nil;
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
        //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
    [self.window setFrame:[[NSScreen mainScreen] visibleFrame] display:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainWindowDidMove:) name:NSWindowDidMoveNotification object:self.window];
    
    NSArray *nibpaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"nib" inDirectory:nil];
    
    self.windowControllers = [NSMutableArray array];
    
    [nibpaths enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL*stop)
    {
        NSString *nibname = path.lastPathComponent.stringByDeletingPathExtension;
        
        if ([nibname isEqualToString:@"MainMenu"])
            return;
        
        WindowController *controller = [[WindowController alloc] initWithWindowNibName:nibname];
        
        [self.windowControllers addObject:controller];
    }];
    
    [tableView reloadData];
    
    NSURL *cappURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html" subdirectory:@"CPLayoutConstraintDemo"];
    NSURLRequest *request = [NSURLRequest requestWithURL:cappURL];
    
    [[cappView mainFrame] loadRequest:request];
}

- (NSView*)tableView:(NSTableView*)aTableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *view = [aTableView makeViewWithIdentifier:@"Windows" owner:self];
    
    NSString *name = [[self.windowControllers objectAtIndex:row] windowNibName];
    
    view.textField.stringValue = [name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    return view;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.windowControllers.count;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    if (self.currentController)
    {
        [defaultCenter removeObserver:self name:NSWindowDidResizeNotification object:nil];
        [defaultCenter removeObserver:self name:NSWindowDidMoveNotification object:nil];
        
        [self.currentController close];
        
        self.currentController = nil;
    }
    
    NSInteger selectedRow = [tableView selectedRow];
    
    self.currentController = [self.windowControllers objectAtIndex:selectedRow];

    [self showWindowCibName:self.currentController.windowNibName];

    [self.currentController showWindow:nil];

    Window * window = self.currentController.window;
    [defaultCenter addObserver:self selector:@selector(updateCappuccinoFrame:) name:NSWindowDidResizeNotification object:window];
    [defaultCenter addObserver:self selector:@selector(updateCappuccinoFrame:) name:NSWindowDidMoveNotification object:window];
    
    [[self window] addChildWindow:window ordered:NSWindowAbove];
    [self updateConstrainedRectForWindow:window];
    
    NSMutableString *description= [NSMutableString string];
    [window.contentView getConstraintsDescriptionInWindow:window buffer:description];
    
    [consoleView setStringValue:description];
    
    window.hasShadow = YES;
    [window center];
    [window becomeKeyWindow];
    [window display];
    window.title = self.currentController.windowNibName;
}

- (void)showWindowCibName:(NSString*)aWindowCibName
{
    NSString *objj_msgSend = [NSString stringWithFormat:@"[[CPApp delegate] _showWindowCibName:@\"%@\"];[[CPRunLoop mainRunLoop] performSelectors];", aWindowCibName];
    
    [[self webScriptObject] evaluateObjectiveJ:objj_msgSend];
}

- (void)updateCappuccinoFrame:(NSNotification*)note
{
    NSWindow *window = [note object];
    
    if (!(window == self.currentController.window))
        return;
    
    CGRect frame = [window frame];
    
    CGRect baseRect = [[self window] convertRectFromScreen:frame];
    CGRect rect = [windowSpace convertRectFromBase:baseRect];
    
    NSString *objj_msgSend = [NSString stringWithFormat:@"[[CPApp delegate] setWindowLeft:%f top:%f Width:%f height:%f];[[CPRunLoop mainRunLoop] performSelectors];", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
    
    [[self webScriptObject] evaluateObjectiveJ:objj_msgSend];
}

- (void)updateConstrainedRectForWindow:(Window*)aWindow
{
    CGRect baseWindowSpace = [[windowSpace superview] convertRectToBase:[windowSpace frame]];
    aWindow.constraintRect  = [[self window] convertRectToScreen:baseWindowSpace];
}

- (void)mainWindowDidMove:(NSNotification*)note
{
    Window *window = self.currentController.window;
    if (!window)
        return;
    
    [self updateConstrainedRectForWindow:window];
    [window setFrame:[window frame] display:YES];
}

- (WebScriptObject*)webScriptObject
{
    if (!webScriptObject)
        webScriptObject = [cappView windowScriptObject];
    
    return webScriptObject;
}

@end

@implementation NSView (VisualizeConstraints)

- (void)getConstraintsDescriptionInWindow:(NSWindow*)aWindow buffer:(NSMutableString*)buffer
{
    NSArray *constraints = [self constraints];
    
    if ([constraints count])
    {
        [buffer appendFormat:@"Constraints For View %@:\n", [self identifier]];
        
        [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL*stop)
         {
             [buffer appendFormat:@"\n%@ priority: %f", constraint.description, constraint.priority];
         }];
        
        [buffer appendString:@"\n\n"];
    }
    
    [[self subviews] enumerateObjectsUsingBlock:^(NSView *view, NSUInteger idx, BOOL*stop)
     {
         [view getConstraintsDescriptionInWindow:aWindow buffer:buffer];
     }];
}

@end