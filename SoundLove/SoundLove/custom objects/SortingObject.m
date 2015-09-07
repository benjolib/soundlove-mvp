//
//  SortingObject.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "SortingObject.h"

@implementation SortingObject

+ (SortingObject*)sortingWithType:(SortingType)sortingType
{
    switch (sortingType) {
        case SortingTypeNone:
            return [SortingObject sortingWithName:@"Keine Sortierung" andKey:@"" orderDir:@"" sortingType:SortingTypeNone];
            break;
        case SortingTypePreisASC:
            return [SortingObject sortingWithName:@"Preis (niedrig zu hoch)" andKey:@"price_from" orderDir:@"ASC" sortingType:SortingTypePreisASC];
            break;
        case SortingTypePreisDESC:
            return [SortingObject sortingWithName:@"Preis (hoch zu niedrig)" andKey:@"price_from" orderDir:@"DESC" sortingType:SortingTypePreisDESC];
            break;
        case SortingTypeDateASC:
            return [SortingObject sortingWithName:@"Datum (Sobald wie möglich)" andKey:@"date_ts" orderDir:@"ASC" sortingType:SortingTypeDateASC];
            break;
        case SortingTypeDateDESC:
            return [SortingObject sortingWithName:@"Datum (Vorausplanen)" andKey:@"date_ts" orderDir:@"DESC" sortingType:SortingTypeDateDESC];
            break;
        case SortingTypePopularity:
            return [SortingObject sortingWithName:@"Beliebt" andKey:@"rank" orderDir:@"DESC" sortingType:SortingTypePopularity];
            break;
        default:
            break;
    }
}

+ (SortingObject*)sortingWithName:(NSString*)name andKey:(NSString*)key orderDir:(NSString*)orderDir sortingType:(SortingType)sortingType
{
    SortingObject *sorting = [[SortingObject alloc] initWithName:name andKey:key orderDir:orderDir sortingType:sortingType];
    return sorting;
}

- (instancetype)initWithName:(NSString*)name andKey:(NSString*)key orderDir:(NSString*)orderDir sortingType:(SortingType)sortingType
{
    self = [super init];
    if (self) {
        self.name = name;
        self.apiKey = key;
        self.orderDir = orderDir;
        self.sortingType = sortingType;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[SortingObject class]]) {
        SortingObject *sortingObj2 = (SortingObject*)object;
        return [self.name isEqualToString:sortingObj2.name] && [self.apiKey isEqualToString:sortingObj2.apiKey];
    }
    return NO;
}

- (BOOL)isAscending
{
    return [self.orderDir isEqualToString:@"ASC"];
}

@end
