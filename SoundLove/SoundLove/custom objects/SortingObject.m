//
//  SortingObject.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "SortingObject.h"

@implementation SortingObject

+ (SortingObject*)sortingWithName:(NSString*)name andKey:(NSString*)key
{
    return [[SortingObject alloc] initWithName:name andKey:key];
}

- (instancetype)initWithName:(NSString*)name andKey:(NSString*)key
{
    self = [super init];
    if (self) {
        self.name = name;
        self.apiKey = key;
    }
    return self;
}

@end
