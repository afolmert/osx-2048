//
//  CKPreferencesWindowController.m
//  cocoa-2048
//
//  Created by Adam Folmert on 12/6/14.
//  Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import "CKPreferencesWindowController.h"

// Result codes 
const NSInteger kCKPreferencesWindowControllerOkResultCode = 0;

const NSInteger kCKPreferencesWindowControllerCancelResultCode = 1;


// Board sizecell 

const NSInteger kCKPreferencesWindowControllerBoardSize4x4 = 0;

const NSInteger kCKPreferencesWindowControllerBoardSize6x6 = 1;

const NSInteger kCKPreferencesWindowControllerBoardSize8x8 = 2;

const NSInteger kCKPreferencesWindowControllerBoardSize10x10 = 3;





@interface CKPreferencesWindowController ()

@end

@implementation CKPreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _resultCode = kCKPreferencesWindowControllerCancelResultCode;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.window center];
}

- (void)windowWillClose:(NSNotification *)notification  
{
    NSLog(@"Window will close!");
  
    [NSApp stopModalWithCode:_resultCode];
}



- (IBAction)okClicked:(NSButton *)sender 
{
    NSLog(@"OK clicked, sender tag %@", @(sender.tag));
    _resultCode = kCKPreferencesWindowControllerOkResultCode;
    [self.window close];

}

- (IBAction)cancelClicked:(NSButton *)sender 
{
    NSLog(@"Cancel clicked, sendert tag %@", @(sender.tag));
    _resultCode = kCKPreferencesWindowControllerCancelResultCode;
    [self.window close];

}
@end
