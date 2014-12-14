//
// Created by Adam Folmert on 11/30/14.
// Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import "CKMatrixLocation.h"


@implementation CKMatrixLocation
{

}


+ (instancetype)locationWithRow:(NSUInteger)row column:(NSUInteger)column
{
    return [[CKMatrixLocation alloc] initWithRow:row column:column];

}

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column
{
    self = [super init];
    if (self != nil) {

        self.row = row;
        self.column = column;

    }
    return self;

}
@end