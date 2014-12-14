//
// Created by Adam Folmert on 11/30/14.
// Copyright (c) 2014 Adam Folmert. All rights reserved.
//

#import "CKPalette.h"
#import "CKUtils.h"

static const unsigned int kPaletteColorCount = 8;
static const unsigned int kPaletteBrownish[] = { 0x0B7C68B, 0xF4F0CB, 0xDED29E, 0xB3A580, 0x685642,  0x382E1C, 0x453823, 0x2C2416 };


static const char *kCKDefaultPaletteName = "Default";



@implementation CKPalette
{

    unsigned int* _palette;
    NSString *_name;
}


+ (NSArray *)availablePaletteNames
{
    return @[@"Brownish", @"Greenish", @"Blueish"];
}



+ (instancetype)defaultPalette
{

    return [[CKPalette alloc] init];
}


+ (instancetype)paletteWithName:(NSString *)name
{

    return [[CKPalette alloc] initWithName:name];
}


- (NSUInteger)colorCount
{
    return kPaletteColorCount;
}


- (NSString *)name
{
    return _name;

}

- (instancetype)init
{
    // TODO default names
    NSString *name = [NSString stringWithUTF8String:kCKDefaultPaletteName];
    return [self initWithName:name];
}



- (instancetype)initWithName:(NSString *)name
{

    self = [super init];
    if (self != nil) {
        //  TODO take care of the name s
        _palette = kPaletteBrownish;
        _name = [name copy];
    }
    return self;
}



- (NSColor *)colorByIndex:(NSUInteger)index
{
    if (index >= kPaletteColorCount) {
        NSLog(@"Warning: index exceeded max color count ");
        index = kPaletteColorCount - 1;
    }
    return NSColorFromRGB(_palette[index]);

}

@end


