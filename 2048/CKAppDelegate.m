//
//  CKAppDelegate.m
//  cocoa-2048
//
//  Created by Adam Folmert on 11/29/14.
//  Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import "CKAppDelegate.h"
#import "CKPreferencesWindowController.h"
#import "CKMainView.h"

@implementation CKAppDelegate

{
    CKPreferencesWindowController *_prefController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    NSLog(@"Hello world!");
    
    _prefController = [[CKPreferencesWindowController alloc] 
                        initWithWindowNibName:@"CKPreferencesWindowController"];
    
}

- (void)awakeFromNib
{
    NSLog(@"CKAppDelegate awakeFromNib called!");
    [_window makeFirstResponder:_mainView];
    
       
}

- (NSSize)windowWillResize:(NSWindow*)sender
                    toSize:(NSSize)frameSize {
    return frameSize;
}


- (void)windowWillMove:(NSNotification *)notification
{
    NSLog(@"Window will move , ho ho %@", notification);
}

- (void)windowDidMove:(NSNotification *)notification
{
    NSLog(@"Window did move , ho ho %@", notification);
}



- (void)windowDidBecomeMain:(NSNotification *)notification
{
    NSLog(@"Window did become main %@", notification);
}


- (IBAction)preferencesMenuClicked:(id)sender 
{
    NSLog(@"Opening modal window !");
//    [_prefController showWindow:self];
    NSWindow *window = [_prefController window];
    
    
    
    NSLog(@"WIndow is %@", window);
    
    NSInteger response = [NSApp runModalForWindow:window];
    
    NSLog(@"Response is %@", @(response));
    //[NSApp beginSheet:window modalForWindow:self modalDelegate:nil didEndSelector:nil contextInfo:nil];
        
    NSLog(@"Is check box ON  ? %d ", _prefController.checkCheatMode.state == NSOnState);
    
    if (response == kCKPreferencesWindowControllerOkResultCode) {
        if (_prefController.checkCheatMode.state == NSOnState) {
            NSLog(@"We are using cheat mode now , OH YEA!");
        }
    }

    if (response == kCKPreferencesWindowControllerCancelResultCode) {
        return;
    }

    NSInteger selectedRow = [_prefController.boardSizeGroup selectedRow];
    NSLog(@"Selected row is %@", @(selectedRow));
    
    NSLog(@"Selected row ");
    
    NSButtonCell *cell = _prefController.boardSizeGroup.selectedCell;


    if (cell.tag == kCKPreferencesWindowControllerBoardSize4x4) {
        NSLog(@"Selected 4x4!");

        if (_mainView.cellCountPerRow != 4) {
            [_mainView resetGameWithCellCountPerRow:4];
        }

    } else if (cell.tag == kCKPreferencesWindowControllerBoardSize6x6) {
        NSLog(@"Selected 6x6 board size!");

        if (_mainView.cellCountPerRow != 6) {
            [_mainView resetGameWithCellCountPerRow:6];
        }


    } else if (cell.tag == kCKPreferencesWindowControllerBoardSize8x8) {
        NSLog(@"Selected 8x8 board size!");


        if (_mainView.cellCountPerRow != 8) {
            [_mainView resetGameWithCellCountPerRow:8];
        }

    } else if (cell.tag == kCKPreferencesWindowControllerBoardSize10x10) {
        NSLog(@"Selected 10x10 board size ");

        if (_mainView.cellCountPerRow != 10) {
            [_mainView resetGameWithCellCountPerRow:10];
        }
    }

             
    //[NSApp endSheet:window];
    [window orderOut:self];
    
    NSLog(@"The modal window was closed now!");
    
}
@end
