//
//  AppDelegate.h
//  NSLayoutConstraintDemo
//
//  Created by x on 24/04/13.
//  Copyright (c) 2013 x. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "WebScripObject+Objective-J.h"

@interface WindowController : NSWindowController

@end

@interface FlippedView : NSView

@end

@interface GridView : FlippedView

@end

@interface ColorView : FlippedView

@end

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>
{
    IBOutlet NSTableView *tableView;
    IBOutlet WebView *cappView;
    IBOutlet GridView *windowSpace;
    IBOutlet NSTextField *consoleView;
    IBOutlet NSPopUpButton *popUp;
    
    WebScriptObject *_webScriptObject;
/*
    NSMutableArray *windowControllers;
    NSWindowController *currentController;
*/
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSMutableArray *windowControllers;
@property (assign) WindowController *currentController;
@property (retain, nonatomic) WebScriptObject *webScriptObject;

@end
