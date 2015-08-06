//
//  FestivalRankClient.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "AbstractClient.h"

@class FestivalModel;

@interface FestivalRankClient : AbstractClient

- (void)sendRankingForFestival:(FestivalModel*)festival increment:(BOOL)increment withCompletionBlock:(void (^)(BOOL succeeded, NSString *errorMessage))completionBlock;

@end
