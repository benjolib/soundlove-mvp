//
//  Band.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "Band.h"

@implementation Band

+ (Band*)bandWithName:(NSString*)name
{
    Band *band = [Band new];
    band.name = name;
    return band;
}

+ (NSArray*)bandsArrayFromStringArray:(NSArray*)array
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *bandName in array) {
        [tempArray addObject:[self bandWithName:bandName]];
    }

    return [tempArray sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        Band *band1 = (Band*)obj1;
        Band *band2 = (Band*)obj2;
        return [band1.name compare:band2.name];
    }];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[Band class]]) {
        Band *band2 = (Band*)object;
        return [self.name isEqualToString:band2.name];
    }
    return NO;
}

@end
