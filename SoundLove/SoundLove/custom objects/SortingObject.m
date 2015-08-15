//
//  SortingObject.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "SortingObject.h"

@implementation SortingObject

+ (SortingObject*)sortingWithName:(NSString*)name andKey:(NSString*)key orderDir:(NSString*)orderDir
{
    return [[SortingObject alloc] initWithName:name andKey:key orderDir:orderDir];
}

- (instancetype)initWithName:(NSString*)name andKey:(NSString*)key  orderDir:(NSString*)orderDir
{
    self = [super init];
    if (self) {
        self.name = name;
        self.apiKey = key;
        self.orderDir = orderDir;
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

@end
