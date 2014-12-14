//
//  CKMainView.h
//  cocoa-2048
//
//  Created by Adam Folmert on 11/29/14.
//  Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CKMainView : NSView

@property (atomic, assign) BOOL isAnimationRunning;

@property (nonatomic, readonly) NSUInteger cellCountPerRow;
@property (nonatomic, readonly) NSUInteger cellWidth;


- (void)resetGame;
- (void)resetGameWithCellCountPerRow:(NSUInteger)cellCountPerRow;

@end
