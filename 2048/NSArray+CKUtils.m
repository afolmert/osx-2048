//
// Created by Adam Folmert on 11/30/14.
// Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import "NSArray+CKUtils.h"


@implementation NSArray (CKUtils)


- (id)randomValue
{
    if ([self count] == 0) {
        return nil;
    } else if ([self count] == 1) {
        return [self objectAtIndex:0];
    } else {
        return [self objectAtIndex:arc4random() % [self count]];
    }
}

@end