//
// Created by Adam Folmert on 11/30/14.
// Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import "CKMatrix.h"
#import "CKMatrixLocation.h"


@implementation CKMatrix
{
    NSUInteger _columnCount;
    NSUInteger _rowCount;

    NSMutableArray *_data;

}

+ (instancetype)matrixWithRowCount:(NSUInteger)rowCount columnCount:(NSUInteger)columnCount
{
    return [[CKMatrix alloc] initWithRowCount:rowCount columnCount:columnCount];
}

- (void)enumerateValues:(CKEnumerateValuesBlock)block
{
    BOOL stop = NO;
    for (NSUInteger row = 0; row < _rowCount; row++) {
        for (NSUInteger col = 0; col < _columnCount; col++) {
            id value =  _data[row * _columnCount + col];
            if (value != [NSNull null]) {

                block(value, row, col, &stop);

                if (stop) {
                    break;
                }
            }
        }
    }

}


- (instancetype)initWithRowCount:(NSUInteger)rowCount columnCount:(NSUInteger)columnCount
{
    self = [super init];
    if (self != nil) {

        _data = [[NSMutableArray alloc] initWithCapacity:rowCount * columnCount];

        if (columnCount == 0) {
            [NSException raise:@"columnCount cannot be 0" format:@""];
        }

        if (rowCount == 0) {
            [NSException raise:@"rowCount cannot be 0" format:@""];

        }


        _columnCount = columnCount;
        _rowCount = rowCount;

        for (NSUInteger i = 0; i < _columnCount * _rowCount; i++) {
            _data[i] = [NSNull null];
        }

    }
    return self;

}

- (void)checkValidRow:(NSUInteger)row column:(NSUInteger)column
{
    if (row >= _rowCount) {
        [NSException raise:@"Maximum row exceeded" format:@"Was: %ld (maximum: %ld)", (unsigned long)row, (unsigned long)_rowCount];
    }

    if (column >= _columnCount) {
        [NSException raise:@"Maximum col exceeded" format:@"Was: %ld (maximum: %ld", (unsigned long) column, (unsigned long)_columnCount];
    }


}


- (void)setValue:(id)value atRow:(NSUInteger)row column:(NSUInteger)column
{
    [self checkValidRow:row column:column];
    _data[row * _columnCount + column] = value;
}


- (void)clearValueAtRow:(NSUInteger)row column:(NSUInteger)column
{
    [self checkValidRow:row column:column];
    _data[row * _columnCount + column] = [NSNull null];

}

- (id)valueAtRow:(NSUInteger)row column:(NSUInteger)column
{
    [self checkValidRow:row column:column];
    
    id value = _data[row * _columnCount + column];
    if ([value isEqualTo:[NSNull null]]) {
        return nil;
    } else {
        return value;
    }
}


- (BOOL)isEmptyAtRow:(NSUInteger)row column:(NSInteger)column
{
    return [[self valueAtRow:row column:column] isEqualTo:[NSNull null]];

}

- (NSArray *)allValues
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger row = 0; row < _rowCount; row++) {
        for (NSUInteger column = 0; column < _columnCount; column++) {
            id value =  _data[row * _columnCount + column];
            if (![value isEqualTo:[NSNull null]]) {
                [result addObject:value];
            }

        }
    }
    return result;
}

- (void)clear
{

    for (NSUInteger i = 0; i < _columnCount * _rowCount; i++) {
        _data[i] = [NSNull null];
    }
}

- (NSUInteger)size
{
    return _columnCount * _rowCount;

}



- (NSArray *)emptyLocations
{
    NSMutableArray *result = [NSMutableArray array];

    for (NSUInteger row = 0; row < _rowCount; row++) {
        for (NSUInteger column = 0; column < _columnCount; column++) {
            id value =  _data[row * _columnCount + column];
            if ([value isEqualTo:[NSNull null]]) {
                [result addObject:[CKMatrixLocation locationWithRow:row column:column]];
            }

        }
    }
    return result;

}


- (NSArray *)nonEmptyLocations
{
    NSMutableArray *result = [NSMutableArray array];

    for (NSUInteger row = 0; row < _rowCount; row++) {
        for (NSUInteger column = 0; column < _columnCount; column++) {
            id value =  _data[row * _columnCount + column];
            if (![value isEqualTo:[NSNull null]]) {
                [result addObject:[CKMatrixLocation locationWithRow:row column:column]];
            }

        }
    }

    return result;
}


@end