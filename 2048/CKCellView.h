//
//  CKCellView.h
//  cocoa-2048
//
//  Created by Adam Folmert on 11/29/14.
//  Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

const static unsigned int kMaxCellStyle = 5;

@interface CKCellView : NSView

@property (nonatomic, assign) NSUInteger color;
@property (nonatomic, assign) NSUInteger value;

- (void)advanceLevel;

@end
