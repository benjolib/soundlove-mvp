//
//  ConcertDownloadClient.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 27/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "AbstractClient.h"

@interface ConcertDownloadClient : AbstractClient

- (void)downloadConcertsFromIndex:(NSInteger)startIndex limit:(NSInteger)numberOfItems withFilters:(NSString*)EDIT_THIS searchText:(NSString*)searchText completionBlock:(void (^)(NSString *errorMessage, NSArray *concertsArray))completionBlock;

@end
