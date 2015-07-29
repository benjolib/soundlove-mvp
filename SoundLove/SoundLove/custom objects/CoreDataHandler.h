//
//  CoreDataHandler.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConcertModel, CDConcert;

@interface CoreDataHandler : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;

+ (instancetype)sharedHandler;

- (NSInteger)numberOfSavedConcerts;

- (BOOL)addConcertToFavorites:(ConcertModel*)concertModel;
- (void)removeConcertObject:(CDConcert*)concert;

- (NSArray*)allSavedConcerts;
- (BOOL)isConcertSaved:(ConcertModel*)concertModel;


@end
