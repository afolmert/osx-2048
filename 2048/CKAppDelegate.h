//
//  CKAppDelegate.h
//  cocoa-2048
//
//  Created by Adam Folmert on 11/29/14.
//  Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CKMainView;

@interface CKAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet CKMainView *mainView;

- (IBAction)preferencesMenuClicked:(id)sender;

@end

