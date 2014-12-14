//
//  CKCellView.m
//  cocoa-2048
//
//  Created by Adam Folmert on 11/29/14.
//  Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import "CKCellView.h"
#import "CKUtils.h"
#import "CKPalette.h"

@implementation CKCellView
{
    NSMutableDictionary *_textAttributes;
    CKPalette *_palette;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = 1;
        _value = 2;

        _textAttributes = [self initializeTextAttributes];
        _palette = [CKPalette new];
    }
    
    return self;
}

- (NSMutableDictionary *)initializeTextAttributes
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    result[NSFontAttributeName] = [NSFont fontWithName:@"Courier" size:40];
    result[NSForegroundColorAttributeName] = [NSColor blackColor];

    return result;

}

- (void)increaseTextAttributesFontSize:(NSMutableDictionary *)attributes byPoints:(NSInteger)points
{
    NSFont *font = attributes[NSFontAttributeName];
    attributes[NSFontAttributeName] = [NSFont fontWithName:font.fontName size:font.pointSize + points];
}


- (void)advanceLevel
{
    _color += 1;
    _value *= 2;
}


- (void)drawTextInCenter:(NSString *)text
{
    NSSize size = [text sizeWithAttributes:_textAttributes];


    NSRect bounds = [self bounds];

    // adjust font size 
    while (size.width > bounds.size.width || size.height > bounds.size.height) {
        [self increaseTextAttributesFontSize:_textAttributes byPoints:-1];
        size = [text sizeWithAttributes:_textAttributes];
    }

    
    NSPoint origin;

    origin.x = (bounds.size.width - size.width) / 2;
    origin.y = (bounds.size.height - size.height) / 2;

    [text drawAtPoint:origin withAttributes:_textAttributes];
}

- (void)drawRect:(NSRect)dirtyRect
{

    NSColor *color = [_palette colorByIndex:_color];
    [color set];
    NSRectFill([self bounds]);

    [self drawTextInCenter:[NSString stringWithFormat:@"%ld", (unsigned long)_value]];
}

@end
