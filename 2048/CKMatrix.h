//
// Created by Adam Folmert on 11/30/14.
// Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CKEnumerateValuesBlock)(id value, NSUInteger row, NSInteger column, BOOL *stop);


@interface CKMatrix : NSObject

+ (instancetype)matrixWithRowCount:(NSUInteger)rowCount columnCount:(NSUInteger)columnCount;

- (instancetype)initWithRowCount:(NSUInteger)rowCount columnCount:(NSUInteger)columnCount;
- (void)setValue:(id)value atRow:(NSUInteger)row column:(NSUInteger)column;
- (void)clearValueAtRow:(NSUInteger)row column:(NSUInteger)column;
- (id)valueAtRow:(NSUInteger)row column:(NSUInteger)column;
- (BOOL)isEmptyAtRow:(NSUInteger)row column:(NSInteger)column;
- (NSArray *)allValues;
- (void)clear;
- (NSUInteger)size;


- (NSArray *)emptyLocations;
- (NSArray *)nonEmptyLocations;


- (void)enumerateValues:(CKEnumerateValuesBlock)block;

@property (nonatomic, readonly, assign) NSUInteger columnCount;
@property (nonatomic, readonly, assign) NSUInteger rowCount;

@end