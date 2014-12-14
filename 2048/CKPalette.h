//
// Created by Adam Folmert on 11/30/14.
// Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CKPalette : NSObject

+ (NSArray *)availablePaletteNames;
+ (instancetype)defaultPalette;
+ (instancetype)paletteWithName:(NSString *)name;

- (NSColor *)colorByIndex:(NSUInteger)index;
- (NSUInteger)colorCount;


@property (nonatomic, readonly, copy) NSString *name;


@end