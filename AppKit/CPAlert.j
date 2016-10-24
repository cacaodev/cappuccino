/*
 * CPAlert.j
 * AppKit
 *
 * Created by Jake MacMullin.
 * Copyright 2008, Jake MacMullin.
 *
 * 11/10/2008 Ross Boucher
 *     - Make it conform to style guidelines, general cleanup and enhancements
 * 11/10/2010 Antoine Mercadal
 *     - Enhancements, better compliance with Cocoa API
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@import "CPButton.j"
@import "CPColor.j"
@import "CPFont.j"
@import "CPImage.j"
@import "CPImageView.j"
@import "CPPanel.j"
@import "CPText.j"
@import "CPTextField.j"

@class CPCheckBox

@global CPApp

var CPAlertDelegate_alertShowHelp_              = 1 << 0,
    CPAlertDelegate_alertDidEnd_returnCode_     = 1 << 1;

@typedef CPAlertStyle
/*
    @global
    @group CPAlertStyle
*/
CPWarningAlertStyle         = 0;
/*
    @global
    @group CPAlertStyle
*/
CPInformationalAlertStyle   = 1;
/*
    @global
    @group CPAlertStyle
*/
CPCriticalAlertStyle        = 2;

var bottomHeight = 71;

@protocol CPAlertDelegate <CPObject>

@optional
- (BOOL)alertShowHelp:(CPAlert)alert;
- (void)alertDidEnd:(CPAlert)theAlert returnCode:(int)returnCode;

@end

@implementation _CPAlertThemeView : CPView

+ (CPString)defaultThemeClass
{
    return @"alert";
}

+ (CPDictionary)themeAttributes
{
    return @{
            @"size": CGSizeMake(400.0, 110.0),
            @"content-inset": CGInsetMake(15, 15, 15, 50),
            @"informative-offset": 6,
            @"button-offset": 10,
            @"message-text-alignment": CPJustifiedTextAlignment,
            @"message-text-color": [CPColor blackColor],
            @"message-text-font": [CPFont boldSystemFontOfSize:13.0],
            @"message-text-shadow-color": [CPNull null],
            @"message-text-shadow-offset": CGSizeMakeZero(),
            @"informative-text-alignment": CPJustifiedTextAlignment,
            @"informative-text-color": [CPColor blackColor],
            @"informative-text-font": [CPFont systemFontOfSize:12.0],
            @"informative-text-shadow-color": [CPNull null],
            @"informative-text-shadow-offset": CGSizeMakeZero(),
            @"image-offset": CGPointMake(15, 12),
            @"information-image": [CPNull null],
            @"warning-image": [CPNull null],
            @"error-image": [CPNull null],
            @"help-image": [CPNull null],
            @"help-image-left-offset": 15,
            @"help-image-pressed": [CPNull null],
            @"suppression-button-y-offset": 0.0,
            @"suppression-button-x-offset": 0.0,
            @"default-elements-margin": 3.0,
            @"suppression-button-text-color": [CPColor blackColor],
            @"suppression-button-text-font": [CPFont systemFontOfSize:12.0],
            @"suppression-button-text-shadow-color": [CPNull null],
            @"suppression-button-text-shadow-offset": 0.0,
            @"modal-window-button-margin-y": 0.0,
            @"modal-window-button-margin-x": 0.0,
            @"standard-window-button-margin-y": 0.0,
            @"standard-window-button-margin-x": 0.0,
        };
}

@end

/*!
    @ingroup appkit

    CPAlert is an alert panel that can be displayed modally to present the
    user with a message and one or more options.

    It can be used to display an information message \c CPInformationalAlertStyle,
    a warning message \c CPWarningAlertStyle (the default), or a critical
    alert \c CPCriticalAlertStyle. In each case the user can be presented with one
    or more options by adding buttons using the \c -addButtonWithTitle: method.

    The panel is displayed modally by calling \c -runModal and once the user has
    dismissed the panel, a message will be sent to the panel's delegate (if set), informing
    it which button was clicked (see delegate methods).

    @delegate -(void)alertDidEnd:(CPAlert)theAlert returnCode:(int)returnCode;
    Called when the user dismisses the alert by clicking one of the buttons.
    @param theAlert the alert panel that the user dismissed
    @param returnCode the index of the button that the user clicked (starting from 0,
           representing the first button added to the alert which appears on the
           right, 1 representing the next button to the left and so on)
*/
@implementation CPAlert : CPObject
{
    BOOL                    _showHelp                   @accessors(property=showsHelp);
    BOOL                    _showSuppressionButton      @accessors(property=showsSuppressionButton);

    CPAlertStyle            _alertStyle                 @accessors(property=alertStyle);
    CPString                _title                      @accessors(property=title);
    CPImage                 _icon                       @accessors(property=icon);

    CPArray                 _buttons                    @accessors(property=buttons, readonly);
    CPCheckBox              _suppressionButton          @accessors(property=suppressionButton, readonly);

    id <CPAlertDelegate>    _delegate                   @accessors(property=delegate);
    id                      _modalDelegate;
    SEL                     _didEndSelector             @accessors(property=didEndSelector);
    Function                _didEndBlock;
    unsigned                _implementedDelegateMethods;

    _CPAlertThemeView       _themeView                  @accessors(property=themeView, readonly);
    CPWindow                _window                     @accessors(property=window, readonly);
    int                     _defaultWindowStyle;

    CPTextField             _messageLabel @accessors(getter=messageLabel);
    CPTextField             _informativeLabel;
    CPImageView             _alertImageView;
    CPView                  _accessoryView              @accessors(property=accessoryView);
    CPButton                _alertHelpButton;

    BOOL                    _needsLayout;
}

#pragma mark Creating Alerts

/*!
    Returns a CPAlert object with the provided info

    @param aMessage the main body text of the alert
    @param defaultButton the title of the default button
    @param alternateButton if not nil, the title of a second button
    @param otherButton if not nil, the title of the third button
    @param informativeText if not nil the informative text of the alert
    @return fully initialized CPAlert
*/
+ (CPAlert)alertWithMessageText:(CPString)aMessage defaultButton:(CPString)defaultButtonTitle alternateButton:(CPString)alternateButtonTitle otherButton:(CPString)otherButtonTitle informativeTextWithFormat:(CPString)informativeText
{
    var newAlert = [[self alloc] init];

    [newAlert setMessageText:aMessage];
    [newAlert addButtonWithTitle:defaultButtonTitle];

    if (alternateButtonTitle)
        [newAlert addButtonWithTitle:alternateButtonTitle];

    if (otherButtonTitle)
        [newAlert addButtonWithTitle:otherButtonTitle];

    if (informativeText)
        [newAlert setInformativeText:informativeText];

    return newAlert;
}

/*!
    Return an CPAlert with type error

    @param anErrorMessage the message of the alert
    @return fully initialized CPAlert
*/
+ (CPAlert)alertWithError:(CPString)anErrorMessage
{
    var newAlert = [[self alloc] init];

    [newAlert setMessageText:anErrorMessage];
    [newAlert setAlertStyle:CPCriticalAlertStyle];

    return newAlert;
}

/*!
    Initializes a \c CPAlert panel with the default alert style \c CPWarningAlertStyle.
*/
- (id)init
{
    self = [super init];

    if (self)
    {
        _buttons            = [];
        _alertStyle         = CPWarningAlertStyle;
        _showHelp           = NO;
        _showSuppressionButton = NO;
        _needsLayout        = YES;
        _defaultWindowStyle = _CPModalWindowMask;
        _themeView          = [_CPAlertThemeView new];

        _messageLabel       = [CPTextField labelWithTitle:@"Alert"];
        [_messageLabel setIdentifier:@"message"];
        [_messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        _informativeLabel   = [[CPTextField alloc] init];
        [_informativeLabel setIdentifier:@"info"];
        [_informativeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        _alertImageView     = [[CPImageView alloc] init];
        [_informativeLabel setIdentifier:@"image"];
        [_alertImageView setTranslatesAutoresizingMaskIntoConstraints:NO];

        _accessoryView = nil;

        _suppressionButton  = [CPCheckBox checkBoxWithTitle:@"Do not show this message again"];
        [_suppressionButton setIdentifier:@"suppressionButton"];
        [_suppressionButton setTranslatesAutoresizingMaskIntoConstraints:NO];

        _alertHelpButton    = [[CPButton alloc] initWithFrame:CGRectMakeZero()];
        [_alertHelpButton setIdentifier:@"alertHelpButton"];
        [_alertHelpButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_alertHelpButton setTarget:self];
        [_alertHelpButton setAction:@selector(_showHelp:)];
    }

    return self;
}


#pragma mark -
#pragma mark Delegate

/*!
    Set the delegate of the receiver
    @param aDelegate the delegate object for the alert.
*/
- (void)setDelegate:(id <CPAlertDelegate>)aDelegate
{
    if (_delegate === aDelegate)
        return;

    _delegate = aDelegate;
    _implementedDelegateMethods = 0;

    if ([_delegate respondsToSelector:@selector(alertShowHelp:)])
        _implementedDelegateMethods |= CPAlertDelegate_alertShowHelp_;

    if ([_delegate respondsToSelector:@selector(alertDidEnd:returnCode:)])
        _implementedDelegateMethods |= CPAlertDelegate_alertDidEnd_returnCode_;
}


#pragma mark Accessors

- (CPTheme)theme
{
    return [_themeView theme];
}

/*!
    set the theme to use

    @param the theme to use
*/
- (void)setTheme:(CPTheme)aTheme
{
    if (aTheme === [self theme])
        return;

    if (aTheme === [CPTheme defaultHudTheme])
        _defaultWindowStyle = CPTitledWindowMask | CPHUDBackgroundWindowMask;
    else
        _defaultWindowStyle = CPTitledWindowMask;

    _window = nil; // will be regenerated at next layout
    _needsLayout = YES;
    [_themeView setTheme:aTheme];
}

- (void)setValue:(id)aValue forThemeAttribute:(CPString)aName
{
    [_themeView setValue:aValue forThemeAttribute:aName];
}

- (void)setValue:(id)aValue forThemeAttribute:(CPString)aName inState:(ThemeState)aState
{
    [_themeView setValue:aValue forThemeAttribute:aName inState:aState];
}

- (id)currentValueForThemeAttribute:(CPString)aName
{
    return [_themeView currentValueForThemeAttribute:aName];
}

/*! @deprecated */
- (void)setWindowStyle:(int)style
{
    CPLog.warn("DEPRECATED: setWindowStyle: is deprecated. use setTheme: instead");

    [self setTheme:(style === CPHUDBackgroundWindowMask) ? [CPTheme defaultHudTheme] : [CPTheme defaultTheme]];
}

/*! @deprecated */
- (int)windowStyle
{
    CPLog.warn("DEPRECATED: windowStyle: is deprecated. use theme instead");
    return _defaultWindowStyle;
}


/*!
    Set the text of the alert's message.

    @param aText CPString containing the text
*/
- (void)setMessageText:(CPString)text
{
    [_messageLabel setStringValue:text];
}

/*!
    Return the content of the message text.

    @return CPString containing the message text
*/
- (CPString)messageText
{
    return [_messageLabel stringValue];
}

/*!
    Set the text of the alert's informative text.

    @param aText CPString containing the informative text
*/
- (void)setInformativeText:(CPString)text
{
    [_informativeLabel setStringValue:text];
}

/*!
    return the content of the message text

    @return CPString containing the message text
*/
- (CPString)informativeText
{
    return [_informativeLabel stringValue];
}

/*!
    Sets the title of the alert window.
    This API is not present in Cocoa.

    @param aTitle CPString containing the window title
*/
- (void)setTitle:(CPString)aTitle
{
    _title = aTitle;
    [_window setTitle:aTitle];
}

/*!
    Set the accessory view.

    @param aView the accessory view
*/
- (void)setAccessoryView:(CPView)aView
{
    _accessoryView = aView;
    [[_window contentView] setNeedsUpdateConstraints:YES];
}

/*!
    Set if the alert shows the suppression button.

    @param shouldShowSuppressionButton YES or NO
*/
- (void)setShowsSuppressionButton:(BOOL)shouldShowSuppressionButton
{
    if (shouldShowSuppressionButton !== _showSuppressionButton)
    {
       _showSuppressionButton = shouldShowSuppressionButton;
       [[_window contentView] setNeedsUpdateConstraints:YES];
    }
}

#pragma mark Accessing Buttons

/*!
    Adds a button with a given title to the receiver.
    Buttons will be added starting from the right hand side of the \c CPAlert panel.
    The first button will have the index 0, the second button 1 and so on.

    The first button will automatically be given a key equivalent of Return,
    and any button titled "Cancel" will be given a key equivalent of Escape.

    You really shouldn't need more than 3 buttons.

    @param title the title of the button
*/
- (void)addButtonWithTitle:(CPString)aTitle
{
    var bounds = [[_window contentView] bounds],
        count = [_buttons count],

        button = [[CPButton alloc] initWithFrame:CGRectMakeZero()];

    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setIdentifier:aTitle];
    [button setTitle:aTitle];
    [button setTag:count];
    [button setTarget:self];
    [button setAction:@selector(_takeReturnCodeFrom:)];

    [[_window contentView] addSubview:button];

    if (count == 0)
        [button setKeyEquivalent:CPCarriageReturnCharacter];
    else if ([aTitle lowercaseString] === @"cancel")
        [button setKeyEquivalent:CPEscapeFunctionKey];

    [_buttons insertObject:button atIndex:0];
    [[_window contentView] setNeedsUpdateConstraints:YES];
}

#pragma mark Displaying Alerts

/*!
    Displays the \c CPAlert panel as a modal dialog. The user will not be
    able to interact with any other controls until s/he has dismissed the alert
    by clicking on one of the buttons.
*/
- (void)runModal
{
    if (!([_window styleMask] & _defaultWindowStyle))
    {
        _needsLayout = YES;
        [self _createWindowWithStyle:_defaultWindowStyle];
    }

    [self _layoutAppearanceIfNeeded];
    [CPApp runModalForWindow:_window];
}

/*!
    The same as \c runModal, but executes the code in \c block when the
    alert is dismissed.
*/
- (void)runModalWithDidEndBlock:(Function /*(CPAlert alert, int returnCode)*/)block
{
    _didEndBlock = block;

    [self runModal];
}

/*!
    Runs the receiver modally as an alert sheet attached to a specified window.

    @param window The parent window for the sheet.
    @param modalDelegate The delegate for the modal-dialog session.
    @param alertDidEndSelector Message the alert sends to modalDelegate after the sheet is dismissed.
    @param contextInfo Contextual data passed to modalDelegate in didEndSelector message.
*/
- (void)beginSheetModalForWindow:(CPWindow)aWindow modalDelegate:(id)modalDelegate didEndSelector:(SEL)alertDidEndSelector contextInfo:(id)contextInfo
{
    if (!([_window styleMask] & CPDocModalWindowMask))
    {
        _needsLayout = YES;
        [self _createWindowWithStyle:CPDocModalWindowMask];
    }

    [self _layoutAppearanceIfNeeded];

    _modalDelegate = modalDelegate;
    _didEndSelector = alertDidEndSelector;

    [CPApp beginSheet:_window modalForWindow:aWindow modalDelegate:self didEndSelector:@selector(_alertDidEnd:returnCode:contextInfo:) contextInfo:contextInfo];
}

/*!
    Runs the receiver modally as an alert sheet attached to a specified window.

    @param window The parent window for the sheet.
*/
- (void)beginSheetModalForWindow:(CPWindow)aWindow
{
    [self beginSheetModalForWindow:aWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

/*!
    Runs the receiver modally as an alert sheet attached to a specified window.
    Executes the code in \c block when the alert is dismissed.

    @param window The parent window for the sheet.
    @param block  Code block to execute on dismissal
*/
- (void)beginSheetModalForWindow:(CPWindow)aWindow didEndBlock:(Function /*(CPAlert alert, int returnCode)*/)block
{
    _didEndBlock = block;

    [self beginSheetModalForWindow:aWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

#pragma mark Private

/*!
    @ignore
*/
- (@action)_showHelp:(id)aSender
{
    [self _sendDelegateAlertShowHelp];
}

/*
    @ignore
*/
- (@action)_takeReturnCodeFrom:(id)aSender
{
    if ([_window isSheet])
    {
        [_window orderOut:nil];
        [CPApp endSheet:_window returnCode:[aSender tag]];
    }
    else
    {
        [CPApp abortModal];
        [_window close];

        [self _alertDidEnd:_window returnCode:[aSender tag] contextInfo:nil];
    }
}

/*!
    @ignore
*/
- (void)_alertDidEnd:(CPWindow)aWindow returnCode:(int)returnCode contextInfo:(id)contextInfo
{
    if (_didEndBlock)
    {
        if (typeof(_didEndBlock) === "function")
            _didEndBlock(self, returnCode);
        else
            CPLog.warn("%s: didEnd block is not a function", [self description]);

        // didEnd blocks are transient
        _didEndBlock = nil;
    }
    else if (_modalDelegate)
    {
        if (_didEndSelector)
            _modalDelegate.isa.objj_msgSend3(_modalDelegate, _didEndSelector, self, returnCode, contextInfo);
    }
    else if (_delegate)
    {
        if (_didEndSelector)
            _delegate.isa.objj_msgSend2(_delegate, _didEndSelector, self, returnCode);
        else
            [self _sendDelegateAlertDidEndReturnCode:returnCode];
    }
}

/*!
    @ignore
*/
- (void)_createWindowWithStyle:(int)forceStyle
{
    // The height will be inferred by the layout engine based on the width and content.
    var frame = CGRectMake(0, 0, [_themeView currentValueForThemeAttribute:@"size"].width, 0);

    _window = [[CPPanel alloc] initWithContentRect:frame styleMask:forceStyle || _defaultWindowStyle];
    [_window setLevel:CPStatusWindowLevel];
    [_window setPlatformWindow:[[CPApp keyWindow] platformWindow]];

    var contentView = [[_CPAlertContentView alloc] initWithAlert:self];
    [contentView setIdentifier:@"contentView"];
    [_window setContentView:contentView];

    if (_title)
        [_window setTitle:_title];

    var count = [_buttons count];

    if (count)
        while (count--)
            [contentView addSubview:_buttons[count]];
    else
        [self addButtonWithTitle:@"OK"];

    [contentView addSubview:_alertImageView];
    [contentView addSubview:_messageLabel];
    [contentView addSubview:_informativeLabel];

    if (_accessoryView)
        [contentView addSubview:_accessoryView];

    if (_showSuppressionButton)
        [contentView addSubview:_suppressionButton];

    if (_showHelp)
        [contentView addSubview:_alertHelpButton];
}

#pragma mark Layout Appearance
- (void)_layoutAppearanceIfNeeded
{
    if (!_needsLayout)
        return;

    if (!_window)
        [self _createWindowWithStyle:nil];

    [_messageLabel setTextColor:[_themeView currentValueForThemeAttribute:@"message-text-color"]];
    [_messageLabel setFont:[_themeView currentValueForThemeAttribute:@"message-text-font"]];
    [_messageLabel setTextShadowColor:[_themeView currentValueForThemeAttribute:@"message-text-shadow-color"]];
    [_messageLabel setTextShadowOffset:[_themeView currentValueForThemeAttribute:@"message-text-shadow-offset"]];
    [_messageLabel setAlignment:[_themeView currentValueForThemeAttribute:@"message-text-alignment"]];
    [_messageLabel setLineBreakMode:CPLineBreakByWordWrapping];

    [_informativeLabel setTextColor:[_themeView currentValueForThemeAttribute:@"informative-text-color"]];
    [_informativeLabel setFont:[_themeView currentValueForThemeAttribute:@"informative-text-font"]];
    [_informativeLabel setTextShadowColor:[_themeView currentValueForThemeAttribute:@"informative-text-shadow-color"]];
    [_informativeLabel setTextShadowOffset:[_themeView currentValueForThemeAttribute:@"informative-text-shadow-offset"]];
    [_informativeLabel setAlignment:[_themeView currentValueForThemeAttribute:@"informative-text-alignment"]];
    [_informativeLabel setLineBreakMode:CPLineBreakByWordWrapping];

    if (_showSuppressionButton)
    {
        [_suppressionButton setTextColor:[_themeView currentValueForThemeAttribute:@"suppression-button-text-color"]];
        [_suppressionButton setFont:[_themeView currentValueForThemeAttribute:@"suppression-button-text-font"]];
        [_suppressionButton setTextShadowColor:[_themeView currentValueForThemeAttribute:@"suppression-button-text-shadow-color"]];
        [_suppressionButton setTextShadowOffset:[_themeView currentValueForThemeAttribute:@"suppression-button-text-shadow-offset"]];
    }

    if (_showHelp)
    {
        var helpImage = [_themeView currentValueForThemeAttribute:@"help-image"],
            helpImagePressed = [_themeView currentValueForThemeAttribute:@"help-image-pressed"];

        [_alertHelpButton setImage:helpImage];
        [_alertHelpButton setAlternateImage:helpImagePressed];
        [_alertHelpButton setBordered:NO];
    }

    [_buttons enumerateObjectsUsingBlock:function(button, idx, stop)
    {
        [button setTheme:[self theme]];
    }];

    if ([_window styleMask] & _CPModalWindowMask || [_window styleMask] & CPHUDBackgroundWindowMask)
    {
        [_window setMovable:YES];
        [_window setMovableByWindowBackground:YES];
    }

    [_window center];

    _needsLayout = NO;
}

- (CGSize)_createWarningImageIfNeeded
{
    var theImage = _icon;

    if (!theImage)
    {
        var attr = [@[@"warning-image", @"information-image", @"error-image"] objectAtIndex:_alertStyle];
        theImage = [self currentValueForThemeAttribute:attr];
    }

    [_alertImageView setImage:theImage];

    return [theImage size];
}

#pragma mark Layout geometry

- (CPArray)_generateConstraintsIntoContentView:(CPView)aContentView
{
    var iconOffset = [self currentValueForThemeAttribute:@"image-offset"],
        inset = [self currentValueForThemeAttribute:@"content-inset"],
        result = @[],
        imageSize = [self _createWarningImageIfNeeded];

// Image View constraints
    var leftImage = [[_alertImageView leftAnchor] constraintEqualToAnchor:[aContentView leftAnchor] constant:iconOffset.x],
        topImage = [[_alertImageView topAnchor] constraintEqualToAnchor:[aContentView topAnchor] constant:iconOffset.y],
        widthImage = [[_alertImageView widthAnchor] constraintEqualToConstant:imageSize.width],
        heightImage = [[_alertImageView heightAnchor] constraintEqualToConstant:imageSize.height];

    [result addObjectsFromArray:@[leftImage, topImage, widthImage, heightImage]];

// Message text constraints
    var leftmessage = [[_messageLabel leftAnchor] constraintEqualToAnchor:[_alertImageView rightAnchor] constant:iconOffset.x],
    //var topmessage = [[_messageLabel topAnchor] constraintEqualToAnchor:[aContentView topAnchor] constant:inset.top];
        rightmessage = [[aContentView rightAnchor] constraintEqualToAnchor:[_messageLabel rightAnchor] constant:inset.right],
        centermessage = [[_messageLabel centerYAnchor] constraintEqualToAnchor:[_alertImageView centerYAnchor]];
    [centermessage setPriority:600];
    //[topmessage setPriority:250];
    [result addObjectsFromArray:@[leftmessage, /*topmessage,*/ centermessage, rightmessage]];

// Informative Text constraints
    var leftInfo = [[_informativeLabel leftAnchor] constraintEqualToAnchor:[_alertImageView rightAnchor] constant:iconOffset.x],
        topInfo = [[_informativeLabel topAnchor] constraintEqualToAnchor:[_messageLabel bottomAnchor] constant:8],
        rightInfo = [[aContentView rightAnchor] constraintEqualToAnchor:[_informativeLabel rightAnchor] constant:inset.right];

    [result addObjectsFromArray:@[leftInfo, topInfo, rightInfo]];
    var lastView = _informativeLabel;

// Accessory View constrainst
    if (_accessoryView)
    {
        var leftAccessory = [[_accessoryView leftAnchor] constraintEqualToAnchor:[_alertImageView rightAnchor] constant:iconOffset.x],
            topAccessory = [[_accessoryView topAnchor] constraintEqualToAnchor:[_informativeLabel bottomAnchor] constant:8],
            rightAccessory = [[aContentView rightAnchor] constraintEqualToAnchor:[_accessoryView rightAnchor] constant:inset.right],
            minheight = [[_accessoryView heightAnchor] constraintGreaterThanOrEqualToConstant:0];

        [result addObjectsFromArray:@[leftAccessory, topAccessory, rightAccessory, minheight]];
        lastView = _accessoryView;
    }

// Suppression Button constraints
    if (_showSuppressionButton)
    {
        var suppressionLeft = [[_suppressionButton leftAnchor] constraintEqualToAnchor:[lastView leftAnchor]],
            suppressionTop = [[_suppressionButton topAnchor] constraintEqualToAnchor:[lastView bottomAnchor] constant:8],
            suppressionRight = [[aContentView rightAnchor] constraintEqualToAnchor:[_suppressionButton rightAnchor] constant:inset.right];

        [result addObjectsFromArray:@[suppressionLeft, suppressionTop, suppressionRight]];
        lastView = _suppressionButton;
    }
// helpButton constraints
    if (_showHelp)
    {
        var helpLeft = [[_alertHelpButton leftAnchor] constraintEqualToAnchor:[_alertImageView leftAnchor]],
            helpBottom  = [[aContentView bottomAnchor] constraintEqualToAnchor:[_alertHelpButton bottomAnchor] constant:20],
            // TODO: Fix button intrinsic size with image.
            helpSize = [[_alertHelpButton image] size],
            helpWidth = [[_alertHelpButton widthAnchor] constraintEqualToConstant:helpSize.width],
            helpHeight = [[_alertHelpButton heightAnchor] constraintEqualToConstant:helpSize.height];

        [result addObjectsFromArray:@[helpLeft, helpBottom, helpWidth, helpHeight]];
    }

// Buttons constraints
    var count = [_buttons count],
        previousButton = nil;

    [_buttons enumerateObjectsUsingBlock:function(button, idx, stop)
    {
        // The default button
        if (idx == count - 1)
        {
            var right = [[aContentView rightAnchor] constraintEqualToAnchor:[button rightAnchor] constant:20];
            [result addObject:right];

            var top = [[button topAnchor] constraintEqualToAnchor:[lastView bottomAnchor] constant:20];
            [result addObject:top];
        }

        if (idx == 0 && count > 2)
        {
            var left = [[button leftAnchor] constraintEqualToAnchor:[lastView leftAnchor]];
            [result addObject:left];
        }

        if (idx > 0 && count < 3 || idx > 1)
        {
            var interspace = [[button leftAnchor] constraintEqualToAnchor:[previousButton rightAnchor] constant:8];
            [result addObject:interspace];
        }

        if (idx > 0)
        {
            var width = [[button widthAnchor] constraintEqualToAnchor:[previousButton widthAnchor]];
            [width setPriority:900];
            [result addObject:width];
        }

        var bottom = [[aContentView bottomAnchor] constraintEqualToAnchor:[button bottomAnchor] constant:20];
        [result addObject:bottom];

        previousButton = button;
    }];

    return result;
}

- (CPArray)_generateHeightConstraints
{
    var result = @[];

    var messageLabelHeight = [self _heightConstraintForWrappingTextField:_messageLabel],
        informativeLabelHeight = [self _heightConstraintForWrappingTextField:_informativeLabel];

    [result addObjectsFromArray:@[messageLabelHeight, informativeLabelHeight]];

    return result;
}

- (CPLayoutConstraint)_heightConstraintForWrappingTextField:(CPTextField)aTextField
{
    var str = [aTextField stringValue],
        height = 0;

    if ([str length] > 0)
    {
        var width = [aTextField _variableWidth].valueOf(),
        //var width = CGRectGetWidth([aTextField frame]),
            sizeWithFontCorrection = 6.0,
            size = [str sizeWithFont:[aTextField font] inWidth:width];

        height += size.height + sizeWithFontCorrection;
    }

    return [[aTextField heightAnchor] constraintEqualToConstant:height];
}

@end

@implementation _CPAlertContentView : CPView
{
    CPArray  _alertConstraints;
    CPArray  _heightConstraints;
    CPAlert  _alert;
    BOOL     _sizeContraintsUpdated;
}

- (id)initWithAlert:(CPAlert)parentAlert
{
    self = [super initWithFrame:CGRectMakeZero()];

    if (self)
    {
        _alertConstraints = @[];
        _heightConstraints = @[];
        _alert = parentAlert;
        _sizeContraintsUpdated = NO;
        [self setTranslatesAutoresizingMaskIntoConstraints:YES];
    }

    return self;
}

- (void)updateSizeContraintsIfNeeded
{
    if (_sizeContraintsUpdated == NO)
    {
        var size = [_alert currentValueForThemeAttribute:@"size"];
        var wcst = [[self widthAnchor] constraintEqualToConstant:size.width];
        [CPLayoutConstraint activateConstraints:@[wcst]];

        _sizeContraintsUpdated = YES;
    }
}

- (void)_updateWithOldConstraints:(CPArray)oldConstraints newConstraints:(CPArray)newConstraints
{
    var constraintsToAdd = [newConstraints arrayByExcludingObjectsInArray:oldConstraints],
        constraintsToRemove = [oldConstraints arrayByExcludingObjectsInArray:newConstraints];

    [CPLayoutConstraint deactivateConstraints:constraintsToRemove];
    [oldConstraints removeObjectsInArray:constraintsToRemove];

    [CPLayoutConstraint activateConstraints:constraintsToAdd];
    [oldConstraints addObjectsFromArray:constraintsToAdd];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self updateSizeContraintsIfNeeded];

    //CPLog.debug([[self _layoutEngine] description]);
    var newConstraints = [_alert _generateConstraintsIntoContentView:self];
    [self _updateWithOldConstraints:_alertConstraints newConstraints:newConstraints];

    // Layout once to get the desired width, then compute the height and set it as a constraint.
    [self layoutSubtreeIfNeeded];

    var newHConstraints = [_alert _generateHeightConstraints];
    [self _updateWithOldConstraints:_heightConstraints newConstraints:newHConstraints];
}

@end

@implementation CPAlert (CPAlertDelegate)

/*!
    @ignore
    Call the delegate alertDidEnd:returnCode
*/
- (void)_sendDelegateAlertDidEndReturnCode:(int)returnCode
{
    if (!(_implementedDelegateMethods & CPAlertDelegate_alertDidEnd_returnCode_))
        return;

    [_delegate alertDidEnd:self returnCode:returnCode];
}

/*!
    @ignore
    Call the delegate alertShowHelp:
*/
- (BOOL)_sendDelegateAlertShowHelp
{
    if (!(_implementedDelegateMethods & CPAlertDelegate_alertShowHelp_))
        return YES;

    return [_delegate alertShowHelp:self];
}

@end

@implementation CPArray (arrayByExcludingObjectsInArray)

- (CPArray)arrayByExcludingObjectsInArray:(CPArray)anArray
{
    var result = [CPArray arrayWithArray:self];
    [result removeObjectsInArray:anArray];

    return result;
}

@end
