//
//  ConcertDownloadClient.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 27/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "AbstractClient.h"

@class FilterModel, ConcertModel;

@interface ConcertDownloadClient : AbstractClient

- (void)downloadConcertsFromIndex:(NSInteger)startIndex limit:(NSInteger)numberOfItems withFilters:(FilterModel*)filterModel searchText:(NSString*)searchText completionBlock:(void (^)(NSString *errorMessage, NSArray *concertsArray))completionBlock;

- (void)downloadListOfFriendsGoingToConcert:(ConcertModel*)concert withCompletionBlock:(void(^)(NSArray *listOfFriends, BOOL completed, NSString *errorMessage))completionBlock;

@end
