//
//  CKUtils.h
//  cocoa-2048
//
//  Created by Adam Folmert on 11/29/14.
//  Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSColorFromRGB(rgbValue) [NSColor colorWithDeviceRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface CKUtils : NSObject

@end


NSColor *CKGetPaletteColor(int color);
NSRect CKContractRectByOffset(NSRect rect, double offset);
