//
// Created by Adam Folmert on 12/7/14.
// Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import "CKPaletteView.h"
#import "CKPalette.h"

static const char *kCKPaletteViewFontName = "Courier";

static unsigned int kCKPaletteViewFontSize = 12;


@implementation CKPaletteView
{
    CKPalette *_palette;
    NSString *_title;
    NSTrackingArea *_trackingArea;


}


- (CKPalette *)palette
{
    return _palette;
}

- (void)setPalette:(CKPalette *)palette
{
    _palette = palette;
    _title = [palette name];
    [self setNeedsDisplay:YES];

}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        _palette = [CKPalette defaultPalette];
        _title = [_palette name];

        [self initializeView];
    }

    return self;

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView
{
    _trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:NSTrackingActiveInActiveApp | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:_trackingArea];
}
 

- (void)viewDidEndLiveResize
{
}



- (void)processMouseEvent:(NSEvent *)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];


    NSRect bounds = [self bounds];
    NSUInteger colWidth = bounds.size.width / _palette.colorCount;
    NSUInteger index = (int)(location.x / colWidth);

    if (index >= _palette.colorCount) {
        index = _palette.colorCount - 1;

    }


    NSString *newTitle = [NSString stringWithFormat:@"%@: %@", [_palette name], @(index)];
    if (![newTitle isEqualToString:_title]) {
        _title = newTitle;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseEntered:(NSEvent *)event
{
    [self processMouseEvent:event];
}


- (void)mouseExited:(NSEvent *)event
{
    [self processMouseEvent:event];
}

- (void)mouseMoved:(NSEvent *)event
{
    [self processMouseEvent:event];
}


- (void)drawTitle:(NSString *)text
{

    text = [NSString stringWithFormat:@" %@ ", text];

    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    attributes[NSFontAttributeName] = [NSFont 
                                        fontWithName:[NSString stringWithUTF8String:kCKPaletteViewFontName]
                                                size:kCKPaletteViewFontSize];
    attributes[NSForegroundColorAttributeName] = [NSColor blackColor];
    attributes[NSBackgroundColorAttributeName] = [NSColor whiteColor];

    NSSize size = [text sizeWithAttributes:attributes];

    NSRect bounds = [self bounds];
    NSPoint origin;

    origin.x = (bounds.size.width - size.width) / 2;
    origin.y = 10;

    [text drawAtPoint:origin withAttributes:attributes];
}




- (void)drawRect:(NSRect)dirtyRect
{
   
    NSRect bounds = [self bounds];
    NSUInteger colWidth = bounds.size.width / _palette.colorCount;


    for (NSUInteger i = 0; i < _palette.colorCount; i++) {

        NSColor *color = [_palette colorByIndex:i];
        [color set];
        NSRect rect = NSMakeRect(i * colWidth, 0, colWidth, bounds.size.height);
        NSRectFill(rect);
    }

    [self drawTitle:_title];


}
@end