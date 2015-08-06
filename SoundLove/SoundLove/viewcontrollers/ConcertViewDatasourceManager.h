//
//  ConcertViewDatasourceManager.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 01/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConcertViewDatasource.h"

@interface ConcertViewDatasourceManager : NSObject

@property (nonatomic, strong) ConcertViewDatasource *allConcertDatasource;
@property (nonatomic, strong) ConcertViewDatasource *favoriteConcertDatasource;
@property (nonatomic, strong) ConcertViewDatasource *recommendedConcertDatasource;

@property (nonatomic, strong) NSMutableArray *currentlyUsedObjectsArray;

- (void)downloadAllConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
- (void)downloadRecommendedConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
- (void)downloadFavoriteConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;

- (void)tabSelectedAtIndex:(NSInteger)index;

@end
