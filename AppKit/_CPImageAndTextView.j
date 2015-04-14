/*
 * _CPImageAndTextView.j
 * AppKit
 *
 * Created by Francisco Tolmasky.
 * Copyright 2008, 280 North, Inc.
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

@import <Foundation/CPString.j>

@import "CPColor.j"
@import "CPFont.j"
@import "CPImage.j"
@import "CPView.j"
@import "CPControl.j"
@import "CPPlatform.j"

@typedef ImageContainer

var _CPimageAndTextViewFrameSizeChangedFlag         = 1 << 0,
    _CPImageAndTextViewImageChangedFlag             = 1 << 1,
    _CPImageAndTextViewTextChangedFlag              = 1 << 2,
    _CPImageAndTextViewAlignmentChangedFlag         = 1 << 3,
    _CPImageAndTextViewVerticalAlignmentChangedFlag = 1 << 4,
    _CPImageAndTextViewLineBreakModeChangedFlag     = 1 << 5,
    _CPImageAndTextViewTextColorChangedFlag         = 1 << 6,
    _CPImageAndTextViewFontChangedFlag              = 1 << 7,
    _CPImageAndTextViewTextShadowColorChangedFlag   = 1 << 8,
    _CPImageAndTextViewImagePositionChangedFlag     = 1 << 9,
    _CPImageAndTextViewImageScalingChangedFlag      = 1 << 10,
    _CPImageAndTextViewTextUnderlineChangedFlag     = 1 << 11;

/* @ignore */
@implementation _CPImageAndTextView : CPView
{
    CPTextAlignment         _alignment;
    CPVerticalTextAlignment _verticalAlignment;

    CPLineBreakMode         _lineBreakMode;
    CPColor                 _textColor;
    CPFont                  _font;
    BOOL                    _textUnderline;

    CPColor                 _textShadowColor;
    CGSize                  _textShadowOffset;

    CPCellImagePosition     _imagePosition;
    CPImageScaling          _imageScaling;
    float                   _imageOffset;
    BOOL                    _shouldDimImage;

    CPImage                 _image;
    CPString                _text;

    CGSize                  _textSize;

    unsigned                _flags;

    ImageContainer          _imageContainer;
#if PLATFORM(DOM)
    DOMElement              _DOMTextElement;
    DOMElement              _DOMTextShadowElement;
#endif
}

- (id)initWithFrame:(CGRect)aFrame control:(CPControl)aControl
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        _textShadowOffset = CGSizeMakeZero();
        [self setVerticalAlignment:CPTopVerticalTextAlignment];

        if (aControl)
        {
            [self setLineBreakMode:[aControl lineBreakMode]];
            [self setTextColor:[aControl textColor]];
            [self setAlignment:[aControl alignment]];
            [self setVerticalAlignment:[aControl verticalAlignment]];
            [self setFont:[aControl font]];
            [self setImagePosition:[aControl imagePosition]];
            [self setImageScaling:[aControl imageScaling]];
            [self setImageOffset:[aControl imageOffset]];
        }
        else
        {
            [self setLineBreakMode:CPLineBreakByClipping];
            //[self setTextColor:[aControl textColor]];
            [self setAlignment:CPCenterTextAlignment];
            [self setFont:[CPFont systemFontOfSize:CPFontCurrentSystemSize]];
            [self setImagePosition:CPNoImage];
            [self setImageScaling:CPImageScaleNone];
        }

        _image = nil;
        _textSize = nil;
        [self setHitTests:NO];
    }

    return self;
}

- (id)initWithFrame:(CGRect)aFrame
{
    return [self initWithFrame:aFrame control:nil];
}

- (ImageContainer)_imageContainer
{
    if (!_imageContainer)
        _imageContainer = new ImageContainer(self);

    return _imageContainer;
}

- (void)setAlignment:(CPTextAlignment)anAlignment
{
    if (_alignment === anAlignment)
        return;

    _alignment = anAlignment;

#if PLATFORM(DOM)
    switch (_alignment)
    {
        case CPLeftTextAlignment:
            _DOMElement.style.textAlign = "left";
            break;

        case CPRightTextAlignment:
            _DOMElement.style.textAlign = "right";
            break;

        case CPCenterTextAlignment:
            _DOMElement.style.textAlign = "center";
            break;

        case CPJustifiedTextAlignment:
            _DOMElement.style.textAlign = "justify";
            break;

        case CPNaturalTextAlignment:
            _DOMElement.style.textAlign = "";
            break;
    }
#endif
}

- (CPTextAlignment)alignment
{
    return _alignment;
}

- (void)setVerticalAlignment:(CPVerticalTextAlignment)anAlignment
{
    if (_verticalAlignment === anAlignment)
        return;

    _verticalAlignment = anAlignment;
    _flags |= _CPImageAndTextViewVerticalAlignmentChangedFlag;

    [self setNeedsLayout];
}

- (unsigned)verticalAlignment
{
    return _verticalAlignment;
}

- (void)setLineBreakMode:(CPLineBreakMode)aLineBreakMode
{
    if (_lineBreakMode === aLineBreakMode)
        return;

    _lineBreakMode = aLineBreakMode;
    _flags |= _CPImageAndTextViewLineBreakModeChangedFlag;

    [self setNeedsLayout];
}

- (CPLineBreakMode)lineBreakMode
{
    return _lineBreakMode;
}

- (void)setImagePosition:(CPCellImagePosition)anImagePosition
{
    if (_imagePosition == anImagePosition)
        return;

    var container = [self _imageContainer];
    container.setImagePosition(anImagePosition);

    _imagePosition = anImagePosition;
    _flags |= _CPImageAndTextViewImagePositionChangedFlag;

    [self setNeedsLayout];
}

- (CPCellImagePosition)imagePosition
{
    return _imagePosition;
}

- (void)setImageScaling:(CPImageScaling)anImageScaling
{
    if (_imageScaling == anImageScaling)
        return;

    var container = [self _imageContainer];
    container.setImageScaling(anImageScaling);

    _imageScaling = anImageScaling;
    _flags |= _CPImageAndTextViewImageScalingChangedFlag;

    [self setNeedsLayout];
}

- (CPUInteger)imageScaling
{
    return _imageScaling;
}

- (void)setDimsImage:(BOOL)shouldDimImage
{
    shouldDimImage = !!shouldDimImage;

    if (_shouldDimImage !== shouldDimImage)
    {
        var container = [self _imageContainer];
        container._shouldDimImage = shouldDimImage;

        _shouldDimImage = shouldDimImage;
        [self setNeedsLayout];
    }
}

- (void)setTextColor:(CPColor)aTextColor
{
    if (_textColor === aTextColor)
        return;

    _textColor = aTextColor;

#if PLATFORM(DOM)
    _DOMElement.style.color = [_textColor cssString];
#endif
}

- (CPColor)textColor
{
    return _textColor;
}

- (void)setFont:(CPFont)aFont
{
    if ([_font isEqual:aFont])
        return;

    _font = aFont;
    _flags |= _CPImageAndTextViewFontChangedFlag;
    _textSize = nil;

    [self setNeedsLayout];
}

- (CPFont)font
{
    return _font;
}

- (void)setTextShadowColor:(CPColor)aColor
{
    if (_textShadowColor === aColor)
        return;

    _textShadowColor = aColor;
    _flags |= _CPImageAndTextViewTextShadowColorChangedFlag;

    [self setNeedsLayout];
}

- (CPColor)textShadowColor
{
    return _textShadowColor;
}

- (void)setTextShadowOffset:(CGSize)anOffset
{
    if (CGSizeEqualToSize(_textShadowOffset, anOffset))
        return;

    _textShadowOffset = CGSizeMakeCopy(anOffset);

    [self setNeedsLayout];
}

- (CGSize)textShadowOffset
{
    return _textShadowOffset;
}

- (void)setTextUnderline:(BOOL)aFlag
{
    if (_textUnderline === aFlag)
        return;

    _textUnderline = aFlag;
    _flags |= _CPImageAndTextViewTextUnderlineChangedFlag;

    [self setNeedsLayout];
}

- (BOOL)textUnderline
{
    return _textUnderline;
}

- (CGRect)textFrame
{
    [self layoutIfNeeded];

    var textFrame = CGRectMakeZero();

#if PLATFORM(DOM)
    if (_DOMTextElement)
    {
        var textStyle = _DOMTextElement.style;

        textFrame.origin.y = parseInt(textStyle.top.substr(0, textStyle.top.length - 2), 10),
        textFrame.origin.x = parseInt(textStyle.left.substr(0, textStyle.left.length - 2), 10),
        textFrame.size.width = parseInt(textStyle.width.substr(0, textStyle.width.length - 2), 10),
        textFrame.size.height = parseInt(textStyle.height.substr(0, textStyle.height.length - 2), 10);

        textFrame.size.width += _textShadowOffset.width;
        textFrame.size.height += _textShadowOffset.height;
    }
#endif

    return textFrame;
}

- (void)setImage:(CPImage)anImage
{
    [self setImage:anImage forIdentifier:@"main"];
}

- (void)setImage:(CPImage)anImage forIdentifier:(CPString)anIdentifier
{
    var imageContainer = [self _imageContainer];
    imageContainer.setImage(anImage, anIdentifier);

    [self setNeedsLayout];
}

- (void)setImageOffset:(float)theImageOffset
{
    if (_imageOffset === theImageOffset)
        return;

    _imageOffset = theImageOffset;
    [self setNeedsLayout];
}

- (float)imageOffset
{
    return _imageOffset;
}

- (CPImage)image
{
    if (!_imageContainer)
        return nil;

    return _imageContainer.imageForIdentifier("main");
}

- (void)setText:(CPString)text
{
    if (_text === text)
        return;

    _text = text;
    _flags |= _CPImageAndTextViewTextChangedFlag;

    _textSize = nil;

    [self setNeedsLayout];
}

- (CPString)text
{
    return _text;
}

- (void)layoutSubviews
{
#if PLATFORM(DOM)
    var needsDOMTextElement = _imagePosition !== CPImageOnly && ([_text length] > 0),
        hasDOMTextElement = !!_DOMTextElement;

    // Create or destroy the DOM Text Element as necessary
    if (needsDOMTextElement !== hasDOMTextElement)
    {
        if (hasDOMTextElement)
        {
            _DOMElement.removeChild(_DOMTextElement);
            _DOMTextElement = nil;
            hasDOMTextElement = NO;
        }
        else
        {
            _DOMTextElement = document.createElement("div");

            var textStyle = _DOMTextElement.style;
            textStyle.position = "absolute";
            textStyle.whiteSpace = "pre";
            textStyle.zIndex = 200;
            textStyle.overflow = "hidden";

            _DOMElement.appendChild(_DOMTextElement);
            hasDOMTextElement = YES;

            // We have to set all these values now.
            _flags |= _CPImageAndTextViewTextChangedFlag | _CPImageAndTextViewFontChangedFlag | _CPImageAndTextViewLineBreakModeChangedFlag | _CPImageAndTextViewTextUnderlineChangedFlag;
        }
    }

    var textStyle = hasDOMTextElement ? _DOMTextElement.style : nil;

    // Create or destroy the DOM Text Shadow element as necessary.
    // If _textShadowColor's alphaComponent is 0, don't bother drawing anything (issue #1412).
    // This improves performance as we get rid of an invisible element, and makes IE <9.0 capable
    // of correctly 'rendering' shadows with [CPColor clearColor].
    var needsDOMTextShadowElement = hasDOMTextElement && [_textShadowColor alphaComponent] > 0.0,
        hasDOMTextShadowElement = !!_DOMTextShadowElement;

    if (needsDOMTextShadowElement !== hasDOMTextShadowElement)
    {
        if (hasDOMTextShadowElement)
        {
            _DOMElement.removeChild(_DOMTextShadowElement);

            _DOMTextShadowElement = nil;

            hasDOMTextShadowElement = NO;
        }
        else
        {
            _DOMTextShadowElement = document.createElement("div");

            var shadowStyle = _DOMTextShadowElement.style,
                font = (_font || [CPFont systemFontOfSize:CPFontCurrentSystemSize]);

            shadowStyle.font = [font cssString];
            shadowStyle.position = "absolute";
            shadowStyle.whiteSpace = textStyle.whiteSpace;
            shadowStyle.wordWrap = textStyle.wordWrap;
            shadowStyle.color = [_textShadowColor cssString];
            shadowStyle.lineHeight = [font defaultLineHeightForFont] + "px";

            shadowStyle.zIndex = 150;
            shadowStyle.textOverflow = textStyle.textOverflow;

            if (document.attachEvent)
            {
                shadowStyle.overflow = textStyle.overflow;
            }
            else
            {
                shadowStyle.overflowX = textStyle.overflowX;
                shadowStyle.overflowY = textStyle.overflowY;
            }

            _DOMElement.appendChild(_DOMTextShadowElement);

            hasDOMTextShadowElement = YES;

            _flags |= _CPImageAndTextViewTextChangedFlag; //sigh...
        }
    }

    var shadowStyle = hasDOMTextShadowElement ? _DOMTextShadowElement.style : nil;

    if (hasDOMTextElement)
    {
        // Update the text contents if necessary.
        if (_flags & _CPImageAndTextViewTextChangedFlag)
            if (CPFeatureIsCompatible(CPJavaScriptInnerTextFeature))
            {
                _DOMTextElement.innerText = _text;

                if (_DOMTextShadowElement)
                    _DOMTextShadowElement.innerText = _text;
            }
            else if (CPFeatureIsCompatible(CPJavaScriptTextContentFeature))
            {
                _DOMTextElement.textContent = _text;

                if (_DOMTextShadowElement)
                    _DOMTextShadowElement.textContent = _text;
            }

        if (_flags & _CPImageAndTextViewFontChangedFlag)
        {
            var font = (_font || [CPFont systemFontOfSize:CPFontCurrentSystemSize]),
                fontStyle = [font cssString];
            textStyle.font = fontStyle;
            textStyle.lineHeight = [font defaultLineHeightForFont] + "px";

            if (shadowStyle)
            {
                shadowStyle.font = fontStyle;
                shadowStyle.lineHeight = [font defaultLineHeightForFont] + "px";
            }
        }

        if (_flags & _CPImageAndTextViewTextUnderlineChangedFlag)
        {
            textStyle.textDecoration = _textUnderline ? "underline" : "";
        }

        // Update the line break mode if necessary.
        if (_flags & _CPImageAndTextViewLineBreakModeChangedFlag)
        {
            switch (_lineBreakMode)
            {
                case CPLineBreakByClipping:
                    textStyle.overflow = "hidden";
                    textStyle.textOverflow = "clip";
                    textStyle.whiteSpace = "pre";
                    textStyle.wordWrap = "normal";
                    break;

                case CPLineBreakByTruncatingHead:
                case CPLineBreakByTruncatingMiddle: // Don't have support for these (yet?), so just degrade to truncating tail.
                case CPLineBreakByTruncatingTail:
                    textStyle.textOverflow = "ellipsis";
                    textStyle.whiteSpace = "pre";
                    textStyle.overflow = "hidden";
                    textStyle.wordWrap = "normal";
                    break;

                case CPLineBreakByCharWrapping:
                case CPLineBreakByWordWrapping:
                    textStyle.wordWrap = "break-word";
                    try {
                        textStyle.whiteSpace = "pre";
                        textStyle.whiteSpace = "-o-pre-wrap";
                        textStyle.whiteSpace = "-pre-wrap";
                        textStyle.whiteSpace = "-moz-pre-wrap";
                        textStyle.whiteSpace = "pre-wrap";
                    }
                    catch (e) {
                        //internet explorer doesn't like these properties
                        textStyle.whiteSpace = "pre";
                    }
                    textStyle.overflow = "hidden";
                    textStyle.textOverflow = "clip";
                    break;
            }

            if (shadowStyle)
            {
                if (document.attachEvent)
                {
                    shadowStyle.overflow = textStyle.overflow;
                }
                else
                {
                    shadowStyle.overflowX = textStyle.overflowX;
                    shadowStyle.overflowY = textStyle.overflowY;
                }

                shadowStyle.wordWrap = textStyle.wordWrap;
                shadowStyle.whiteSpace = textStyle.whiteSpace;
                shadowStyle.textOverflow = textStyle.textOverflow;
            }
        }
    }

    var size = [self bounds].size,
        container = [self _imageContainer];

    if (container._needsBoundsUpdate)
    {
        container.setSuperViewSize(size);
        container.updateDOM();
        container.updateBoundsIfNeeded();
        container.updateDOMproperties();
    }

    if (hasDOMTextElement)
    {
        var textRect = CGRectMake(0.0, 0.0, size.width, size.height);

        var imageSize = container.size(),
            imageWidth = imageSize.width,
            imageHeight = imageSize.height;

        if (_imagePosition === CPImageBelow)
        {
            textRect.size.height = size.height - imageHeight - _imageOffset;
        }
        else if (_imagePosition === CPImageAbove)
        {
            textRect.origin.y += imageHeight + _imageOffset;
            textRect.size.height = size.height - imageHeight - _imageOffset;
        }
        else if (_imagePosition === CPImageLeft)
        {
            textRect.origin.x = imageWidth + _imageOffset;
            textRect.size.width -= imageWidth + _imageOffset;
        }
        else if (_imagePosition === CPImageRight)
        {
            textRect.size.width -= imageWidth + _imageOffset;
        }

        var textRectX = CGRectGetMinX(textRect),
            textRectY = CGRectGetMinY(textRect),
            textRectWidth = CGRectGetWidth(textRect),
            textRectHeight = CGRectGetHeight(textRect);

        if (textRectWidth <= 0 || textRectHeight <= 0)
        {
            // Don't bother trying to position the text in an empty rect.
            textRectWidth = 0;
            textRectHeight = 0;
        }
        else
        {
            if (_verticalAlignment !== CPTopVerticalTextAlignment)
            {
                if (!_textSize)
                {
                    if (_lineBreakMode === CPLineBreakByCharWrapping ||
                        _lineBreakMode === CPLineBreakByWordWrapping)
                    {
                        _textSize = [_text sizeWithFont:_font inWidth:textRectWidth];
                    }
                    else
                    {
                        _textSize = [_text sizeWithFont:_font];

                        // Account for possible fractional pixels at right edge
                        _textSize.width += 1;
                    }

                    // Account for possible fractional pixels at bottom edge
                    _textSize.height += 1;
                }

                if (_verticalAlignment === CPCenterVerticalTextAlignment)
                {
                    // Since we added +1 px height above to show fractional pixels on the bottom, we have to remove that when calculating vertical centre.
                    textRectY = textRectY + (textRectHeight - _textSize.height + 1.0) / 2.0;
                    textRectHeight = _textSize.height;
                }

                else // if (_verticalAlignment === CPBottomVerticalTextAlignment)
                {
                    textRectY = textRectY + textRectHeight - _textSize.height;
                    textRectHeight = _textSize.height;
                }
            }
        }

        textStyle.top = ROUND(textRectY) + "px";
        textStyle.left = ROUND(textRectX) + "px";
        textStyle.width = MAX(CEIL(textRectWidth), 0) + "px";
        textStyle.height = MAX(CEIL(textRectHeight), 0) + "px";
        textStyle.verticalAlign = @"top";

        if (shadowStyle)
        {
            if (_flags & _CPImageAndTextViewTextShadowColorChangedFlag)
                shadowStyle.color = [_textShadowColor cssString];

            shadowStyle.top = ROUND(textRectY + _textShadowOffset.height) + "px";
            shadowStyle.left = ROUND(textRectX + _textShadowOffset.width) + "px";
            shadowStyle.width = MAX(CEIL(textRectWidth), 0) + "px";
            shadowStyle.height = MAX(CEIL(textRectHeight), 0) + "px";
        }
    }
#endif

    _flags = 0;
}

- (void)sizeToFit
{
    var size = CGSizeMakeZero();

    if ((_imagePosition !== CPNoImage) && _image)
    {
        var imageSize = [_image size];

        size.width += imageSize.width;
        size.height += imageSize.height;
    }

    if ((_imagePosition !== CPImageOnly) && [_text length] > 0)
    {
        if (!_textSize)
        {
            _textSize = [_text sizeWithFont:_font || [CPFont systemFontOfSize:0]];

            // Account for fractional pixels
            _textSize.width += 1;
            _textSize.height += 1;
        }

        if (!_image || _imagePosition === CPImageOverlaps)
        {
            size.width = MAX(size.width, _textSize.width);
            size.height = MAX(size.height, _textSize.height);
        }
        else if (_imagePosition === CPImageLeft || _imagePosition === CPImageRight)
        {
            size.width += _textSize.width + _imageOffset;
            size.height = MAX(size.height, _textSize.height);
        }
        else if (_imagePosition === CPImageAbove || _imagePosition === CPImageBelow)
        {
            size.width = MAX(size.width, _textSize.width);
            size.height += _textSize.height + _imageOffset;
        }
    }

    [self setFrameSize:size];
}

- (void)setFrameSize:(CGSize)aSize
{
    // If we're applying line breaks the height of the text size might change as a result of the bounds changing.
    if ((_lineBreakMode === CPLineBreakByCharWrapping || _lineBreakMode === CPLineBreakByWordWrapping) && aSize.width !== [self frameSize].width)
        _textSize = nil;

    [super setFrameSize:aSize];
}

- (void)setSelectedRange:(CPRange)aRange
{
#if PLATFORM(DOM)
    [[[self window] platformWindow] setSelectedRange:aRange inElement:_DOMTextElement];
#endif
}

- (void)addImageElement:(Object)anImageElement
{
#if PLATFORM(DOM)
    _DOMElement.appendChild(anImageElement);
#endif
}

- (void)removeImageElement:(Object)anImageElement
{
#if PLATFORM(DOM)
    _DOMElement.removeChild(anImageElement);
#endif
}

@end

var ImageContainerOperationAdded = 0,
    ImageContainerOperationShouldAdd = 1,
    ImageContainerOperationShouldRemove = 2,
    ImageContainerOperationShouldHide = 3;

var ImageContainer = function (parentView)
{
    this._needsDOMUpdate = false;
    this._needsBoundsUpdate = false;
    this._parentView = parentView;
    this._items = [];
    this._rect = CGRectMakeZero();
    this._superviewSize = CGSizeMakeZero();
    this._shouldDimImage = false;
    this._scaling = CPImageScaleNone;
    this._imagePosition = CPImageOnly;
};

ImageContainer.prototype.addImage = function(image, anIdentifier)
{
    if (image == nil || this.containsImage(anIdentifier))
        return;

    var container = this;

    if ([image loadStatus] !== CPImageLoadStatusCompleted)
    {
        [[CPNotificationCenter defaultCenter] addObserverForName:CPImageDidLoadNotification object:image queue:nil usingBlock:function(aNotif)
        {
            if ([image size].width > CGRectGetWidth(container._rect))
            {
                container._needsBoundsUpdate = true;
                container.updateBoundsIfNeeded();
            }
        }];
    }

    var el = document.createElement("img"),
        imageStyle = el.style;

    if ([CPPlatform supportsDragAndDrop])
    {
        el.setAttribute("draggable", "true");
        imageStyle["-khtml-user-drag"] = "element";
    }

    imageStyle.position = "absolute";
    imageStyle.zIndex = 100 + container._items.length;
    el.src = [image filename];

    container._items.push({"image":image, "element":el, "identifier":anIdentifier,  operation:ImageContainerOperationShouldAdd});

    this._needsBoundsUpdate = true;
    this._needsDOMUpdate = true;
};

ImageContainer.prototype.removeImageWithIdentifier = function(anIdentifier)
{
    var count = this._items.length;

    while (count--)
    {
        var item = this._items[count];

        if (item.identifier == anIdentifier)
        {
            if (item.operation == ImageContainerOperationShouldAdd)
                this._items.splice(count, 1);
            else if (item.operation == ImageContainerOperationAdded)
                item.operation = ImageContainerOperationShouldRemove;

            this._needsBoundsUpdate = true;
            this._needsDOMUpdate = true;
            break;
        }
    }
};

ImageContainer.prototype.setImage = function(anImage, anIdentifier)
{
    this.removeImageWithIdentifier(anIdentifier);
    this.addImage(anImage, anIdentifier);
};

ImageContainer.prototype.imageForIdentifier = function(anIdentifier)
{
    var count = this._items.length;

    while (count--)
    {
        var item = this._items[count];

        if (item.identifier == anIdentifier && item.operation == ImageContainerOperationAdded)
            return item.image;
    }

    return null;
};

ImageContainer.prototype.elementForIdentifier = function(anIdentifier)
{
    var count = this._items.length;

    while (count--)
    {
        var item = this._items[count];

        if (item.identifier == anIdentifier && item.operation == ImageContainerOperationAdded)
            return item.element;
    }

    return null;
};

ImageContainer.prototype.containsImage = function(anIdentifier)
{
    return (this.imageForIdentifier(anIdentifier) !== null);
};

ImageContainer.prototype.updateDOM = function()
{
    if (!this._needsDOMUpdate)
        return;

    var count = this._items.length;

    while (count--)
    {
        var item = this._items[count],
            operation = item.operation,
            element = item.element;

        if (this.shouldHide() == false && operation == ImageContainerOperationShouldAdd)
        {
            [this._parentView addImageElement:element];
            item.operation = ImageContainerOperationAdded;
        }

        if (operation == ImageContainerOperationShouldRemove)
        {
            [this._parentView removeImageElement:element];
            this._items.splice(count, 1);
        }

        if (this.shouldHide() == true && operation == ImageContainerOperationShouldHide)
        {
            [this._parentView removeImageElement:element];
            item.operation = ImageContainerOperationShouldAdd;
        }
    }

    this._needsDOMUpdate = false;
};

ImageContainer.prototype.setSuperViewSize = function(aSize)
{
    this._superviewSize = aSize;
};

ImageContainer.prototype.rect = function ()
{
    return this._rect;
};

ImageContainer.prototype.size = function()
{
    if (this.shouldHide() || this._items.length == 0)
        return CGSizeMakeZero();

    return CGSizeMakeCopy(this._rect.size);
};

ImageContainer.prototype.updateDOMproperties = function()
{
    var frame = this._rect,
        left = CGRectGetMinX(frame),
        top = CGRectGetMinY(frame),
        width = CGRectGetWidth(frame),
        height = CGRectGetHeight(frame),
        superSize = this._superviewSize,
        centerX = superSize.width / 2.0,
        centerY = superSize.height / 2.0;

    if (this._imageScaling === CPImageScaleAxesIndependently)
    {
        width = superSize.width;
        height = superSize.height;
    }
    else if (this._imageScaling === CPImageScaleProportionallyDown)
    {
        var scale = MIN(MIN(superSize.width, width) / width, MIN(superSize.height, height) / height);

        width *= scale;
        height *= scale;
    }

    switch (this._imagePosition)
    {
        case CPImageBelow : left = FLOOR(centerX - width / 2.0);
                            top = FLOOR(superSize.height - height);
                            break;
        case CPImageAbove : left = FLOOR(centerX - width / 2.0);
                            top = 0;
                            break;
        case CPImageLeft  : left = 0;
                            top = FLOOR(centerY - height / 2.0);
                            break;
        case CPImageRight : left = FLOOR(superSize.width - width);
                            top = FLOOR(centerY - height / 2.0);
                            break;
        case CPImageOverlaps :
        case CPImageOnly  : left = FLOOR(centerX - width / 2.0);
                            top = FLOOR(centerY - height / 2.0);
                            break;
        case CPNoImage    : left = 0;
                            top = 0;
                            width = 0;
                            height = 0;
    }
// CPLog.debug("pos=" + this._imagePosition + " left=" + left + " top=" + top + " super=" + CPStringFromSize(superSize));
    for (var i = 0; i < this._items.length; i++)
    {
        var item = this._items[i],
            element = item.element,
            style = element.style,
            size = [item.image size];

        if (size.width < width)
        {
            left += (width - size.width) / 2;
            top += (height - size.height) / 2;
            width = size.width;
            height = size.height;
        }

        style.left = left + "px";
        style.top = top + "px";
        style.width = width + "px";
        style.height = height + "px";
        element.width = width + "px";
        element.height = height + "px";

        if (CPFeatureIsCompatible(CPOpacityRequiresFilterFeature))
            style.filter = @"alpha(opacity=" + this._shouldDimImage ? 50 : 100 + ")";
        else
            style.opacity = this._shouldDimImage ? 0.5 : 1.0;

        if (i > 0)
            style.mixBlendMode = "multiply";
    }
}

ImageContainer.prototype.updateBoundsIfNeeded = function()
{
    if (!this._needsBoundsUpdate)
        return;

    var size = CGSizeMakeZero(),
        count = this._items.length;

    for (var i = 0; i < count; i++)
    {
        var item = this._items[i];

        if (item.operation == ImageContainerOperationAdded)
        {
            var imageSize = [item.image size];

            if (imageSize.width > size.width)
                size = CGSizeMakeCopy(imageSize);
        }
    }

    this._rect.size = size;
    this._needsBoundsUpdate = false;
};

ImageContainer.prototype.setImagePosition = function(anImagePosition)
{
    if (anImagePosition == this._imagePosition)
        return;

    if (this._imagePosition == CPNoImage || anImagePosition == CPNoImage)
        this._needsDOMUpdate = true;

    this._imagePosition = anImagePosition;

    if (anImagePosition == CPNoImage)
        this.setHidden();

    this._needsBoundsUpdate = true;
};

ImageContainer.prototype.setImageScaling = function(anImageScaling)
{
    this._imageScaling = anImageScaling;
    this._needsBoundsUpdate = true;
};

ImageContainer.prototype.shouldHide = function()
{
    return (this._imagePosition == CPNoImage);
};

ImageContainer.prototype.setHidden = function()
{
    var count = this._items.length;

    while (count--)
    {
        var item = this._items[count];

        if (item.operation == ImageContainerOperationAdded)
            item.operation = ImageContainerOperationShouldHide;
    }
};