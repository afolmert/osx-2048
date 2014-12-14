//
//  CKPreferencesWindowController.h
//  cocoa-2048
//
//  Created by Adam Folmert on 12/6/14.
//  Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern const NSInteger kCKPreferencesWindowControllerOkResultCode;
extern const NSInteger kCKPreferencesWindowControllerCancelResultCode;


extern const NSInteger kCKPreferencesWindowControllerBoardSize4x4;
extern const NSInteger kCKPreferencesWindowControllerBoardSize6x6;
extern const NSInteger kCKPreferencesWindowControllerBoardSize8x8;
extern const NSInteger kCKPreferencesWindowControllerBoardSize10x10;





@interface CKPreferencesWindowController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet NSButton *checkCheatMode;
@property (nonatomic, assign) NSInteger resultCode;

@property (weak) IBOutlet NSMatrix *boardSizeGroup;


- (IBAction)okClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;



@end
