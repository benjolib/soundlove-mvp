//
//  ConcertViewDatasourceManager.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 01/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertViewDatasourceManager.h"
#import "NetworkConstants.h"

@implementation ConcertViewDatasourceManager

- (void)tabSelectedAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            self.currentlyUsedObjectsArray = self.favoriteConcertDatasource.objectsArray;
            break;
        case 1:
            self.currentlyUsedObjectsArray = self.recommendedConcertDatasource.objectsArray;
            break;
        case 2:
            self.currentlyUsedObjectsArray = self.allConcertDatasource.objectsArray;
            break;
        default:
            break;
    }
}

#pragma mark - download methods
- (void)downloadAllConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    if (!self.allConcertDatasource) {
        self.allConcertDatasource = [[ConcertViewDatasource alloc] init];
        self.allConcertDatasource.startIndex = 0;
        self.allConcertDatasource.limit = 20.0;
        self.allConcertDatasource.urlToDownloadFrom = kConcertsList;
    }

    [self.allConcertDatasource downloadObjectsWithCompletionBlock:completionBlock];
}

- (void)downloadRecommendedConcertsWithCompletionBlock:(void(^)(BOOL completed))completionBlock
{

}

- (void)downloadFavoriteConcertsWithCompletionBlock:(void(^)(BOOL completed))completionBlock
{
    
}

@end
