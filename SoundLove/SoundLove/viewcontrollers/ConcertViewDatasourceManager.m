//
//  ConcertViewDatasourceManager.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 01/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertViewDatasourceManager.h"
#import "NetworkConstants.h"
#import "FacebookManager.h"

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

    __weak typeof(self) weakSelf = self;
    [self.allConcertDatasource downloadObjectsWithCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        weakSelf.currentlyUsedObjectsArray = weakSelf.allConcertDatasource.objectsArray;
        if (completionBlock) {
            completionBlock(completed, errorMesage);
        }
    }];
}

- (void)downloadRecommendedConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    if (!self.recommendedConcertDatasource) {
        self.recommendedConcertDatasource = [[ConcertViewDatasource alloc] init];
        self.recommendedConcertDatasource.startIndex = 0;
        self.recommendedConcertDatasource.limit = 20.0;

        NSString *urlString = [NSString stringWithFormat:@"%@?user_id=%@&access_token=%@", kConcertsRecommendedList, [FacebookManager currentUserID], [FacebookManager currentUserAccessToken]];
        self.recommendedConcertDatasource.urlToDownloadFrom = urlString;
    }

    __weak typeof(self) weakSelf = self;
    [self.recommendedConcertDatasource downloadObjectsWithCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        weakSelf.currentlyUsedObjectsArray = weakSelf.recommendedConcertDatasource.objectsArray;
        if (completionBlock) {
            completionBlock(completed, errorMesage);
        }
    }];
}

- (void)downloadFavoriteConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    if (!self.favoriteConcertDatasource) {
        self.favoriteConcertDatasource = [[ConcertViewDatasource alloc] init];
        self.favoriteConcertDatasource.startIndex = 0;
        self.favoriteConcertDatasource.limit = 20.0;
        self.favoriteConcertDatasource.urlToDownloadFrom = kFavoriteConcertsList;
    }

    __weak typeof(self) weakSelf = self;
    [self.favoriteConcertDatasource downloadObjectsWithCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        weakSelf.currentlyUsedObjectsArray = weakSelf.favoriteConcertDatasource.objectsArray;
        if (completionBlock) {
            completionBlock(completed, errorMesage);
        }
    }];
}

@end
