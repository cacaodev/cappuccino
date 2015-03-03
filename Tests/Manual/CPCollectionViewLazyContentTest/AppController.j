/*
 * AppController.j
 * CPCollectionViewNibTest
 *
 * Created by You on November 28, 2012.
 * Copyright 2012, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
//@import "CPCollectionView.j"

CPLogRegister(CPLogConsole);

@implementation AppController : CPObject
{
    @outlet     CPWindow             theWindow; //this "outlet" is connected automatically by the Cib
    @outlet     CPCollectionView     collectionView;
    @outlet     InternalProtoypeItem prototypeItemInternal;
    @outlet     ExternalProtoypeItem prototypeItemExternal;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
}

- (void)awakeFromCib
{
    [self willChangeValueForKey:@"minItemWidth"];
    [self willChangeValueForKey:@"minItemHeight"];
    [collectionView setMinItemSize:CGSizeMake(100, 100)];
    [self didChangeValueForKey:@"minItemWidth"];
    [self didChangeValueForKey:@"minItemHeight"];

    [self willChangeValueForKey:@"maxItemWidth"];
    [self willChangeValueForKey:@"maxItemHeight"];
    [collectionView setMaxItemSize:CGSizeMake(200, 150)];
    [self didChangeValueForKey:@"maxItemWidth"];
    [self didChangeValueForKey:@"maxItemHeight"];

    [collectionView setMaxNumberOfRows:0];
    [collectionView setContent:[self valueForKey:@"values"]];
}

- (IBAction)setPrototypeItem:(id)sender
{
    var prototypeItem = [[sender selectedItem] tag] ? prototypeItemExternal : prototypeItemInternal;

    [collectionView setItemPrototype:prototypeItem];
}

- (void)setMinItemWidth:(CPInteger)aWidth
{
    var size = CGSizeMakeCopy([collectionView minItemSize]);
    size.width = aWidth;
    [collectionView setMinItemSize:size];
}

- (CPInteger)minItemWidth
{
    return [collectionView minItemSize].width;
}

- (void)setMinItemHeight:(CPInteger)aHeight
{
    var size = CGSizeMakeCopy([collectionView minItemSize]);
    size.height = aHeight;
    [collectionView setMinItemSize:size];
}

- (CPInteger)minItemHeight
{
    return [collectionView minItemSize].height;
}

- (void)setMaxItemWidth:(CPInteger)aWidth
{
    var size = CGSizeMakeCopy([collectionView maxItemSize]);
    size.width = aWidth;
    [collectionView setMaxItemSize:size];
}

- (CPInteger)maxItemWidth
{
    return [collectionView maxItemSize].width;
}

- (void)setMaxItemHeight:(CPInteger)aHeight
{
    var size = CGSizeMakeCopy([collectionView maxItemSize]);
    size.height = aHeight;
    [collectionView setMaxItemSize:size];
}

- (CPInteger)maxItemHeight
{
    return [collectionView maxItemSize].height;
}

/*
    Indexed accessors
*/

- (CPInteger)countOfValues
{
    CPLog.debug(_cmd);
    return 1000000;
}

- (id)objectInValuesAtIndex:(CPInteger)anIndex
{
    CPLog.debug(_cmd+anIndex);
    return @{"value":(""+anIndex), "color":[CPColor randomColor]};
}
/*
- (CPArray)valuesAtIndexes:(CPIndexSet)indexes
{
    CPLog.debug(_cmd);
    return [content objectsAtIndexes:indexes];
}
*/

@end

@implementation InternalProtoypeItem: CPCollectionViewItem
{
    @outlet CPTextField textField;
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    textField = [aCoder decodeObjectForKey:@"TextField"];

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeConditionalObject:textField forKey:@"TextField"];
}

- (void)setRepresentedObject:(id)anObject
{
    [super setRepresentedObject:anObject];
    [textField setStringValue:[anObject objectForKey:@"value"]];
    [[self view] setColor:[anObject objectForKey:@"color"]];
}

@end

@implementation ExternalProtoypeItem: CPCollectionViewItem
{
}

- (void)setRepresentedObject:(id)anObject
{
    [super setRepresentedObject:anObject];
    [[self view] setColor:[anObject objectForKey:@"color"]];
}

@end

@implementation ColorView : CPView
{
    CPColor color @accessors;
}

- (void)setColor:(CPColor)aColor
{
    color = aColor;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(CGRect)aRect
{
    if (!color)
        color = [CPColor grayColor];

    var context = [[CPGraphicsContext currentContext] graphicsPort];
    CGContextSetFillColor(context, color);
    CGContextFillRect(context, aRect);
}

@end
