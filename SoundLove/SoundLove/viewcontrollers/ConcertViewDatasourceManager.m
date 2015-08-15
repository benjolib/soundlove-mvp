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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentLimit = 20.0;
    }
    return self;
}

#pragma mark - loading methods
- (void)loadObjectsAtIndex:(NSInteger)index WithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    switch (index) {
        case SelectedTabIndexFavorites:
            [self loadFavoriteConcertsWithCompletionBlock:(completionBlock ? completionBlock : nil)];
            self.currentLimit = self.favoriteConcertDatasource.startIndex  + self.favoriteConcertDatasource.limit;
            break;
        case SelectedTabIndexRecommended:
            [self loadRecommendedConcertsWithCompletionBlock:(completionBlock ? completionBlock : nil)];
            self.currentLimit = self.recommendedConcertDatasource.startIndex  + self.recommendedConcertDatasource.limit;
            break;
        case SelectedTabIndexAll:
            [self loadAllConcertsWithCompletionBlock:(completionBlock ? completionBlock : nil)];
            self.currentLimit = self.allConcertDatasource.startIndex + self.allConcertDatasource.limit;
            break;
        default:
            break;
    }
}

- (void)loadFavoriteConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    if (self.favoriteConcertDatasource.objectsArray) {
        self.currentlyUsedObjectsArray = self.favoriteConcertDatasource.objectsArray;
        completionBlock(YES, nil);
    } else {
        [self downloadFavoriteConcertsWithCompletionBlock:completionBlock];
    }
}

- (void)loadRecommendedConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    if (self.recommendedConcertDatasource.objectsArray) {
        self.currentlyUsedObjectsArray = self.recommendedConcertDatasource.objectsArray;
        completionBlock(YES, nil);
    } else {
        [self downloadRecommendedConcertsWithCompletionBlock:completionBlock];
    }
}

- (void)loadAllConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
{
    if (self.allConcertDatasource.objectsArray) {
        self.currentlyUsedObjectsArray = self.allConcertDatasource.objectsArray;
        completionBlock(YES, nil);
    } else {
        [self downloadAllConcertsWithCompletionBlock:completionBlock];
    }
}

#pragma mark - downloading next concerts
- (void)downloadNextConcertsAtIndex:(NSInteger)index WithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    switch (index) {
        case SelectedTabIndexFavorites:
            self.favoriteConcertDatasource.startIndex = self.favoriteConcertDatasource.objectsArray.count;
            self.currentLimit = self.favoriteConcertDatasource.startIndex  + self.favoriteConcertDatasource.limit;
            [self downloadFavoriteConcertsWithCompletionBlock:completionBlock];
            break;
        case SelectedTabIndexRecommended:
            self.recommendedConcertDatasource.startIndex = self.recommendedConcertDatasource.objectsArray.count;
            self.currentLimit = self.recommendedConcertDatasource.startIndex  + self.recommendedConcertDatasource.limit;
            [self downloadRecommendedConcertsWithCompletionBlock:completionBlock];
            break;
        case SelectedTabIndexAll:
            self.allConcertDatasource.startIndex = self.allConcertDatasource.objectsArray.count;
            self.currentLimit = self.allConcertDatasource.startIndex  + self.allConcertDatasource.limit;
            [self downloadAllConcertsWithCompletionBlock:completionBlock];
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
        self.allConcertDatasource.limit = 20;
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
        self.recommendedConcertDatasource.limit = 20;

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
        self.favoriteConcertDatasource.limit = 20;
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
