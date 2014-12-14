//
//  CKMainView.m
//  cocoa-2048
//
//  Created by Adam Folmert on 11/29/14.
//  Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CKMainView.h"
#import "CKUtils.h"
#import "CKMatrix.h"
#import "CKMatrixLocation.h"
#import "CKPaletteView.h"

#import "CKConfig.h"
#import "CKCellView.h"
#import "NSArray+CKUtils.h"

#define TEST_TRACKING 0



// Key codes
static const unsigned short kCKKeyCodeArrowUp = 126;

static const unsigned short kCKKeyCodeArrowDown = 125;

static const unsigned short kCKKeyCodeArrowRight = 124;

static const unsigned short kCKKeyCodeArrowLeft = 123;



typedef NS_ENUM(NSUInteger, CKDirection) {
    kCKDirectionLeft,
    kCKDirectionRight,
    kCKDirectionUp,
    kCKDirectionDown
};


@implementation CKMainView
{
    BOOL _isAwaken;

    BOOL _initWithFrameCalled;

    BOOL _gameRunning;

    CKMatrix *_cells;

    NSUInteger _cellWidth;
    NSUInteger _cellCountPerRow;

    CKPaletteView *_paletteView;

}



- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _initWithFrameCalled = YES;
        _isAwaken = NO;
        
        _cells = nil;

        _cellCountPerRow = kCKDefaultCellCountPerRow;
        _cellWidth = 0;

        _gameRunning = YES;
     }
    
    return self;
}

- (void)awakeFromNib 
{

    NSLog(@"self = %p", self);
    NSLog(@"isAwaken %d", _isAwaken);
    
    if (_isAwaken) {
        return;
    }
    

    NSLog(@"Why is this called twice?!");

    _isAwaken = YES;


    // XXX
    
    if (TEST_TRACKING) {
        _paletteView = [[CKPaletteView alloc] initWithFrame:[self bounds]];
        [self addSubview:_paletteView];
        [_paletteView setNeedsDisplay:YES];
        _gameRunning = NO;
        
        
    } else {
        [self resetGameWithCellCountPerRow:kCKDefaultCellCountPerRow];
        _gameRunning = YES;
        
    }
 
}

- (void)resetGame
{
    [self resetGameWithCellCountPerRow:_cellCountPerRow];
}

- (void)resetGameWithCellCountPerRow:(NSUInteger)cellCountPerRow
{

    // clean all existing cells
    if (_cells != nil) {
        for (CKCellView *cellView in [_cells allValues]) {
            [cellView removeFromSuperview];
        }
    }

    // clear all subviews
    for (NSView *subview in self.subviews) {
        [subview removeFromSuperview];
    }

    // reset cells
    _cellCountPerRow = cellCountPerRow;
    _cellWidth = floor(([self frame].size.height - kCKCellMargin) / _cellCountPerRow);
    _cells = [CKMatrix matrixWithRowCount:_cellCountPerRow columnCount:_cellCountPerRow];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kCKResetGameNewCellDelay * NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
        for (int i = 0; i < kCKInitialCellCount; i++) {
            if (![self createNewCell]) {
                break;
            }
        }
    });

    _gameRunning = YES;
}

- (NSRect)cellFrameAtRow:(NSUInteger)row column:(NSUInteger)column
{
    return NSMakeRect(kCKCellMargin + column * _cellWidth,
                        kCKCellMargin + row * _cellWidth,
                        _cellWidth - kCKCellMargin,
                        _cellWidth - kCKCellMargin);
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSColor *color = NSColorFromRGB(0xFCFBE3);
    [color set];
    NSRectFill([self bounds]);
}

     
     
- (BOOL)acceptsFirstResponder 
{
    return YES;
}




- (unichar)extractKeyFromEvent:(NSEvent *)event
{
    NSString* const chars = [[event charactersIgnoringModifiers] lowercaseString];
    if ([chars length] > 0) {
        unichar const code = [chars characterAtIndex:0];
        return code;
    } else {
        return 0;
    }
}



- (BOOL)createNewCell
{
    NSArray *emptyLocations = [_cells emptyLocations];

    if (emptyLocations == nil || [emptyLocations count] == 0) {

        NSLog(@"No more space available");
        return NO;
    }

    CKMatrixLocation *loc = [emptyLocations randomValue];




    NSRect finalFrame = [self cellFrameAtRow:[loc row] column:[loc column]];
    NSRect initialFrame = CKContractRectByOffset(finalFrame, (double)finalFrame.size.width * 10 / 100);

    CKCellView *cell = [[CKCellView alloc] initWithFrame:initialFrame];
    cell.color = 2;
    [self addSubview:cell];

    [_cells setValue:cell atRow:[loc row] column:[loc column]];



    [NSAnimationContext beginGrouping];

    [NSAnimationContext currentContext].timingFunction = [CAMediaTimingFunction
            functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [NSAnimationContext currentContext].duration = 0.01;

    [[cell animator] setFrame: finalFrame];

    [NSAnimationContext endGrouping];


    return YES;
}

- (BOOL)matchesCell:(CKCellView *)cell toCell:(CKCellView *)other
{
    if (cell == nil || other == nil) {
        return false;
    } else {
        return [cell value] == [other value];    
    }

}


- (void)shiftCellsInDirection:(CKDirection)direction completionHandler:(void (^)(void))completionHandler
{

    if (self.isAnimationRunning) {
        NSLog(@"Animation still running , returning ! ");
        return;
    }

    self.isAnimationRunning = YES;

    NSUInteger rowCount = [_cells rowCount];
    NSUInteger columnCount = [_cells columnCount];


    NSMutableArray *cellsToShift = [NSMutableArray new];
    NSMutableArray *cellsToMerge = [NSMutableArray new];


    if (direction == kCKDirectionLeft) {


        for (NSInteger row = 0; row < rowCount; row++) {

            CKCellView *lastCell = [_cells valueAtRow:row column:0];
            NSUInteger shifts = lastCell == nil ? 1 : 0;

            for (NSInteger column = 1; column < columnCount; column++) {

                CKCellView *cell = [_cells valueAtRow:row column:column];

                if (cell == nil) {
                    shifts += 1;

                } else if ([self matchesCell:cell toCell:lastCell])  {

                    // shift to left where possible
                    [_cells clearValueAtRow:row column:column];

                    [cellsToShift addObject:cell];
                    [cellsToShift addObject:
                            [NSValue valueWithRect:[self cellFrameAtRow:row column:column - shifts - 1]]];

                    CKCellView *mergedCell = [_cells valueAtRow:row column:column - shifts - 1];
                    [cellsToMerge addObject:mergedCell];
                    [cellsToMerge addObject:cell];

                    lastCell = nil;
                    shifts += 1;

                } else  {
                    // shift to left where possible
                    [_cells clearValueAtRow:row column:column];
                    [_cells setValue:cell atRow:row column:column - shifts];
                    // this by animating !

                    [cellsToShift addObject:cell];
                    [cellsToShift addObject:
                            [NSValue valueWithRect:[self cellFrameAtRow:row column:column - shifts]]];


                    lastCell = cell;
                }
            }
        }

    } else if (direction == kCKDirectionRight) {

        for (NSInteger row = 0; row < rowCount; row++) {

            CKCellView *lastCell = [_cells valueAtRow:row column:columnCount - 1];
            NSUInteger shifts = lastCell == nil ? 1 : 0;

            for (NSInteger column = columnCount - 2; column >= 0; column--) {

                CKCellView *cell = [_cells valueAtRow:row column:column];

                if (cell == nil) {
                    shifts += 1;

                } else if ([self matchesCell:cell toCell:lastCell])  {

                    // shift to left where possible
                    [_cells clearValueAtRow:row column:column];

                    [cellsToShift addObject:cell];
                    [cellsToShift addObject:
                            [NSValue valueWithRect:[self cellFrameAtRow:row column:column + shifts + 1]]];

                    CKCellView *mergedCell = [_cells valueAtRow:row column:column + shifts + 1];
                    [cellsToMerge addObject:mergedCell];
                    [cellsToMerge addObject:cell];

                    lastCell = nil;
                    shifts += 1;

                } else  {
                    // shift to left where possible
                    [_cells clearValueAtRow:row column:column];
                    [_cells setValue:cell atRow:row column:column + shifts];
                    // this by animating !

                    [cellsToShift addObject:cell];
                    [cellsToShift addObject:
                            [NSValue valueWithRect:[self cellFrameAtRow:row column:column + shifts]]];


                    lastCell = cell;
                }
            }
        }


    } else if (direction == kCKDirectionUp) {

        for (NSInteger column = 0; column < columnCount; column++) {

            CKCellView *lastCell = [_cells valueAtRow:rowCount - 1 column:column];
            NSUInteger shifts = lastCell == nil ? 1 : 0;

            for (NSInteger row = rowCount - 2; row >= 0; row--) {

                CKCellView *cell = [_cells valueAtRow:row column:column];

                if (cell == nil) {
                    shifts += 1;

                } else if ([self matchesCell:cell toCell:lastCell])  {

                    // shift to left where possible
                    [_cells clearValueAtRow:row column:column];

                    [cellsToShift addObject:cell];
                    [cellsToShift addObject:
                            [NSValue valueWithRect:[self cellFrameAtRow:row + shifts + 1 column:column]]];

                    CKCellView *mergedCell = [_cells valueAtRow:row + shifts + 1 column:column];
                    [cellsToMerge addObject:mergedCell];
                    [cellsToMerge addObject:cell];

                    lastCell = nil;
                    shifts += 1;

                } else  {
                    // shift to left where possible
                    [_cells clearValueAtRow:row column:column];
                    [_cells setValue:cell atRow:row + shifts column:column];
                    // this by animating !

                    [cellsToShift addObject:cell];
                    [cellsToShift addObject:
                            [NSValue valueWithRect:[self cellFrameAtRow:row + shifts column:column]]];


                    lastCell = cell;
                }
            }
        }


    } else if (direction == kCKDirectionDown) {

        for (NSInteger column = 0; column < columnCount; column++) {

            CKCellView *lastCell = [_cells valueAtRow:0 column:column];
            NSUInteger shifts = lastCell == nil ? 1 : 0;

            for (NSInteger row = 1; row < rowCount; row++) {

                CKCellView *cell = [_cells valueAtRow:row column:column];

                if (cell == nil) {
                    shifts += 1;

                } else if ([self matchesCell:cell toCell:lastCell])  {

                    // shift to left where possible
                    [_cells clearValueAtRow:row column:column];

                    [cellsToShift addObject:cell];
                    [cellsToShift addObject:
                            [NSValue valueWithRect:[self cellFrameAtRow:row - shifts - 1 column:column]]];

                    CKCellView *mergedCell = [_cells valueAtRow:row - shifts - 1 column:column];
                    [cellsToMerge addObject:mergedCell];
                    [cellsToMerge addObject:cell];

                    lastCell = nil;
                    shifts += 1;

                } else  {
                    // shift to left where possible
                    [_cells clearValueAtRow:row column:column];
                    [_cells setValue:cell atRow:row - shifts column:column];
                    // this by animating !

                    [cellsToShift addObject:cell];
                    [cellsToShift addObject:
                            [NSValue valueWithRect:[self cellFrameAtRow:row - shifts column:column]]];


                    lastCell = cell;
                }
            }
        }


    } else {
        NSAssert(false, @"Should not happen");
    }



    // perform animations

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {

        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        context.duration = 0.1;

        NSUInteger i = 0;
        while (i < [cellsToShift count]) {
            CKCellView *cellView = cellsToShift[i];
            NSRect destFrame = [cellsToShift[i + 1] rectValue];
            [[cellView animator] setFrame:destFrame];
            i += 2;
        }


    } completionHandler:^{

        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {

            context.duration = 0.1;
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

            NSUInteger i = 0;
            while (i < [cellsToMerge count]) {

                CKCellView *destCell = cellsToMerge[i];
                CKCellView *sourceCell = cellsToMerge[i + 1];

                [sourceCell removeFromSuperview];
                [destCell advanceLevel];

                [destCell setNeedsDisplay:YES];

                NSRect destCellEnlargedFrame = CKContractRectByOffset([destCell frame], -3);
                [[destCell animator] setFrame:destCellEnlargedFrame];

                i += 2;
            }


        } completionHandler:^{

            [NSAnimationContext beginGrouping];
            [NSAnimationContext currentContext].duration = 0.1;
            [NSAnimationContext currentContext].timingFunction =
                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

            NSUInteger i = 0;
            while (i < [cellsToMerge count]) {
                CKCellView *destCell = cellsToMerge[i];
                NSRect destCellFrame = CKContractRectByOffset([destCell frame], 3);
                [[destCell animator] setFrame:destCellFrame];

                i += 2;
            }


            [NSAnimationContext endGrouping];

            if (completionHandler != nil) {
                completionHandler();
            }

            self.isAnimationRunning = NO;

        }];

    }];

}

- (BOOL)translateKeyEvent:(NSEvent *)theEvent toDirection:(CKDirection *)direction
{
    BOOL success = YES;

    unichar c = [self extractKeyFromEvent:theEvent];

    switch (c) {
        case 'i': *direction = kCKDirectionUp; break;
        case 'j': *direction = kCKDirectionLeft; break;
        case 'k': *direction = kCKDirectionDown; break;
        case 'l': *direction = kCKDirectionRight; break;
        default: {
            switch ([theEvent keyCode]) {
                case kCKKeyCodeArrowUp: *direction = kCKDirectionUp; break;
                case kCKKeyCodeArrowDown: *direction = kCKDirectionDown; break;
                case kCKKeyCodeArrowRight: *direction = kCKDirectionRight; break;
                case kCKKeyCodeArrowLeft: *direction = kCKDirectionLeft; break;
                default: success = NO;
            }
        }
    }

    return success;
}

- (void)showMessage:(NSString *)message
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:message];
    [alert runModal];
}


- (void)paletteKeyDown:(NSEvent *)theEvent
{

    if (TEST_TRACKING) {
        unichar c = [self extractKeyFromEvent:theEvent];

        if (c == 'x') {
            NSLog(@"Pressed x key!");

        } else if (c == 'p') {
            NSLog(@"Pressed p key! ");
        } else {
            NSLog(@"PRessed %@ key ", @(c));
        }

    }

}




- (void)keyDown:(NSEvent *)theEvent
{

    // XXX
    if (TEST_TRACKING) {
        [self paletteKeyDown:theEvent];    
    }
    

    if (!_gameRunning) {
        return;
    }

    unichar c = [self extractKeyFromEvent:theEvent];

    unsigned short keycode = theEvent.keyCode;


    CKDirection direction;

    if ([self translateKeyEvent:theEvent toDirection:&direction]) {
        //   NSLog(@"char is %c", c);
        // [self animateCells3InDirection:direction];
        [self shiftCellsInDirection:direction completionHandler:^{

            if (![self createNewCell]) {

                [self showMessage:@"GAME OVER!"];
                _gameRunning = false;
            }

        }];


    } else if (c == 'n') {
        [self createNewCell];

    } else if (c == 'x') {
        [self resetGame];
    } else if (c == 't') {
        NSLog(@"Testing new feature ... ");
    } else {
        NSLog(@"got c from key %@", @(c));
        NSLog(@"Key code is %@", @(keycode));

    }
}


@end

