//
//  CoreDataHandler.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataHandler : NSObject

+ (instancetype)sharedHandler;

- (NSInteger)numberOfSavedConcerts;

@end
