//
// Created by Adam Folmert on 11/30/14.
// Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CKMatrixLocation : NSObject


+ (instancetype)locationWithRow:(NSUInteger)row column:(NSUInteger)column;

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column;


@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger column;

@end

