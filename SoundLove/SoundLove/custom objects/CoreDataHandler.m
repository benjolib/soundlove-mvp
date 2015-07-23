//
//  CoreDataHandler.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "CoreDataHandler.h"

@implementation CoreDataHandler

+ (instancetype)sharedHandler
{
    static CoreDataHandler *sharedHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandler = [[self alloc] init];
    });
    return sharedHandler;
}

- (NSInteger)numberOfSavedConcerts
{
    return 0;
}

@end
