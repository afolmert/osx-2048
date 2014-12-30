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

static const NSUInteger kCKInitialFontSize = 40;

@implementation CKCellView
{
    CKPalette *_palette;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = 1;
        _value = 2;

        _palette = [CKPalette new];
    }
    
    return self;
}

- (NSMutableDictionary *)initializeTextAttributes
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    result[NSFontAttributeName] = [NSFont fontWithName:@"Courier" size:kCKInitialFontSize];
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
    NSMutableDictionary *textAttributes = [self initializeTextAttributes];
    NSSize size = [text sizeWithAttributes:textAttributes];


    NSRect bounds = [self bounds];

    // adjust font size 
    while (size.width > bounds.size.width || size.height > bounds.size.height) {
        [self increaseTextAttributesFontSize:textAttributes byPoints:-1];
        size = [text sizeWithAttributes:textAttributes];
    }

    
    NSPoint origin;

    origin.x = (bounds.size.width - size.width) / 2;
    origin.y = (bounds.size.height - size.height) / 2;


    [text drawAtPoint:origin withAttributes:textAttributes];
}

- (void)drawRect:(NSRect)dirtyRect
{

    NSColor *color = [_palette colorByIndex:_color];
    [color set];
    NSRectFill([self bounds]);

    [self drawTextInCenter:[NSString stringWithFormat:@"%ld", (unsigned long)_value]];
}

@end
