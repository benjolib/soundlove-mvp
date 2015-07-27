//
//  NSDictionary+nonNullObjectForKey.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 15/12/14.
//  Copyright (c) 2014 Sztanyi Szabolcs. All rights reserved.
//

#import "NSDictionary+nonNullObjectForKey.h"

@implementation NSDictionary (nonNullObjectForKey)

- (id)nonNullObjectForKey:(id)key
{
    id obj = [self objectForKey:key];
    return ([obj isKindOfClass:[NSNull class]]) ? nil : obj;
}

@end
