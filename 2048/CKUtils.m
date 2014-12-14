//
//  CKUtils.m
//  cocoa-2048
//
//  Created by Adam Folmert on 11/29/14.
//  Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import "CKUtils.h"

@implementation CKUtils

@end


NSRect CKContractRectByOffset(NSRect rect, double offset)
{
    if (rect.size.width > offset * 2 && rect.size.height > offset * 2) {
        rect.origin.x = rect.origin.x + offset;
        rect.origin.y = rect.origin.y + offset;
        rect.size.width = rect.size.width - offset * 2;
        rect.size.height = rect.size.height - offset * 2;

    }
    return rect;

}




