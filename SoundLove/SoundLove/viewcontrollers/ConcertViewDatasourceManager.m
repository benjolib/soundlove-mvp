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
#import "SortingObject.h"

@implementation ConcertViewDatasourceManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentLimit = 20.0;
    }
    return self;
}

- (void)setCurrentSortingObject:(SortingObject *)currentSortingObject
{
    _currentSortingObject = currentSortingObject;

    self.favoriteConcertDatasource.sortingObject = _currentSortingObject;
    self.recommendedConcertDatasource.sortingObject = _currentSortingObject;
    self.allConcertDatasource.sortingObject = _currentSortingObject;

    if (_currentSortingObject.sortingType != SortingTypeNone)
    {
        self.currentlyUsedObjectsArray = [self sortArray:self.currentlyUsedObjectsArray usingSortingObject:_currentSortingObject];
    }
}

- (void)setIsSearching:(BOOL)isSearching
{
    _isSearching = isSearching;
    if (!isSearching) {
        [self.favoriteConcertDatasource resetDatasource];
        [self.recommendedConcertDatasource resetDatasource];
        [self.allConcertDatasource resetDatasource];
    }
}

- (void)redownloadConcertsWithIndex:(NSInteger)selectedIndex filterModel:(FilterModel*)filterModel withCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    self.currentFilterModel = filterModel;

    self.favoriteConcertDatasource.startIndex = 0;
    self.recommendedConcertDatasource.startIndex = 0;
    self.allConcertDatasource.startIndex = 0;

    if (selectedIndex == SelectedTabIndexFavorites)
    {
        [self downloadFavoriteConcertsWithCompletionBlock:completionBlock];
        [self downloadAllConcertsWithCompletionBlock:nil];
        [self downloadRecommendedConcertsWithCompletionBlock:nil];
    }
    else if (selectedIndex == SelectedTabIndexRecommended)
    {
        [self downloadRecommendedConcertsWithCompletionBlock:completionBlock];
        [self downloadAllConcertsWithCompletionBlock:nil];
        [self downloadFavoriteConcertsWithCompletionBlock:nil];
    }
    else
    {
        [self downloadAllConcertsWithCompletionBlock:completionBlock];
        [self downloadFavoriteConcertsWithCompletionBlock:nil];
        [self downloadRecommendedConcertsWithCompletionBlock:nil];
    }
}

- (void)showArrayAtIndex:(SelectedTabIndex)tabIndex
{
    switch (tabIndex) {
        case SelectedTabIndexFavorites:
            self.currentLimit = self.favoriteConcertDatasource.objectsArray.count + self.favoriteConcertDatasource.limit;
            self.currentlyUsedObjectsArray = self.favoriteConcertDatasource.objectsArray;
            break;
        case SelectedTabIndexRecommended:
            self.currentLimit = self.recommendedConcertDatasource.objectsArray.count + self.recommendedConcertDatasource.limit;
            self.currentlyUsedObjectsArray = self.recommendedConcertDatasource.objectsArray;
            break;
        case SelectedTabIndexAll:
            self.currentLimit = self.allConcertDatasource.objectsArray.count + self.allConcertDatasource.limit;
            self.currentlyUsedObjectsArray = self.allConcertDatasource.objectsArray;
            break;
        default:
            break;
    }
}

#pragma mark - loading methods
- (void)reloadObjectsAtIndex:(NSInteger)index withFilterModel:(FilterModel*)filterModel completionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    self.currentFilterModel = filterModel;

    switch (index) {
        case SelectedTabIndexFavorites:
            self.favoriteConcertDatasource.filterModel = self.currentFilterModel;
            [self downloadFavoriteConcertsWithCompletionBlock:completionBlock];
            break;
        case SelectedTabIndexRecommended:
            self.recommendedConcertDatasource.filterModel = self.currentFilterModel;
            [self downloadRecommendedConcertsWithCompletionBlock:completionBlock];
            break;
        case SelectedTabIndexAll:
            self.allConcertDatasource.filterModel = self.currentFilterModel;
            [self downloadAllConcertsWithCompletionBlock:completionBlock];
            break;
        default:
            break;
    }
}

- (void)loadSavedObjectsAtIndex:(NSInteger)index withCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    switch (index) {
        case SelectedTabIndexFavorites:
            [self loadFavoriteConcertsWithCompletionBlock:(completionBlock ? completionBlock : nil)];
            break;
        case SelectedTabIndexRecommended:
            [self loadRecommendedConcertsWithCompletionBlock:(completionBlock ? completionBlock : nil)];
            break;
        case SelectedTabIndexAll:
            [self loadAllConcertsWithCompletionBlock:(completionBlock ? completionBlock : nil)];
            break;
        default:
            break;
    }
}

- (void)loadFavoriteConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    if (self.favoriteConcertDatasource.objectsArray) {
        self.favoriteConcertDatasource.objectsArray = [self sortArray:self.favoriteConcertDatasource.objectsArray usingSortingObject:self.currentSortingObject];
        completionBlock(YES, nil);
    } else {
        [self downloadFavoriteConcertsWithCompletionBlock:completionBlock];
    }
}

- (void)loadRecommendedConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    if (self.recommendedConcertDatasource.objectsArray) {
        self.recommendedConcertDatasource.objectsArray = [self sortArray:self.recommendedConcertDatasource.objectsArray usingSortingObject:self.currentSortingObject];
        completionBlock(YES, nil);
    } else {
        [self downloadRecommendedConcertsWithCompletionBlock:completionBlock];
    }
}

- (void)loadAllConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
{
    if (self.allConcertDatasource.objectsArray) {
        self.allConcertDatasource.objectsArray = [self sortArray:self.allConcertDatasource.objectsArray usingSortingObject:self.currentSortingObject];
        completionBlock(YES, nil);
    } else {
        [self downloadAllConcertsWithCompletionBlock:completionBlock];
    }
}

- (NSMutableArray*)sortArray:(NSMutableArray*)array usingSortingObject:(SortingObject*)sortingObject
{
    NSString *sortingKey = sortingObject.apiKey;
    switch (sortingObject.sortingType) {
        case SortingTypeNone:
            sortingKey = @"";
            break;
        case SortingTypePreisDESC:
        case SortingTypePreisASC:
            sortingKey = @"price";
            break;
        case SortingTypeDateDESC:
        case SortingTypeDateASC:
            sortingKey = @"date";
            break;
    }

    // don't sort the array if no key is selected
    if (sortingKey.length <= 0) {
        return array;
    }

    NSMutableArray *sortedArray = [[array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:sortingKey ascending:[sortingObject isAscending]]]] mutableCopy];
    return sortedArray;
}

#pragma mark - downloading next concerts
- (void)downloadNextConcertsAtIndex:(NSInteger)index WithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    switch (index) {
        case SelectedTabIndexFavorites:
            self.favoriteConcertDatasource.startIndex = self.favoriteConcertDatasource.objectsArray.count;
            self.currentLimit = self.favoriteConcertDatasource.startIndex + self.favoriteConcertDatasource.limit;
            [self downloadFavoriteConcertsWithCompletionBlock:completionBlock];
            break;
        case SelectedTabIndexRecommended:
            self.recommendedConcertDatasource.startIndex = self.recommendedConcertDatasource.objectsArray.count;
            self.currentLimit = self.recommendedConcertDatasource.startIndex + self.recommendedConcertDatasource.limit;
            [self downloadRecommendedConcertsWithCompletionBlock:completionBlock];
            break;
        case SelectedTabIndexAll:
            self.allConcertDatasource.startIndex = self.allConcertDatasource.objectsArray.count;
            self.currentLimit = self.allConcertDatasource.startIndex + self.allConcertDatasource.limit;
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

    self.allConcertDatasource.searchText = self.searchText;
    self.allConcertDatasource.sortingObject = self.currentSortingObject;
    self.allConcertDatasource.filterModel = self.currentFilterModel;

    [self.allConcertDatasource downloadObjectsWithCompletionBlock:^(BOOL completed, NSString *errorMesage) {
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

    self.recommendedConcertDatasource.searchText = self.searchText;
    self.recommendedConcertDatasource.sortingObject = self.currentSortingObject;
    self.recommendedConcertDatasource.filterModel = self.currentFilterModel;

    [self.recommendedConcertDatasource downloadObjectsWithCompletionBlock:^(BOOL completed, NSString *errorMesage) {
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

    self.favoriteConcertDatasource.searchText = self.searchText;
    self.favoriteConcertDatasource.sortingObject = self.currentSortingObject;
    self.favoriteConcertDatasource.filterModel = self.currentFilterModel;

    [self.favoriteConcertDatasource downloadObjectsWithCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        if (completionBlock) {
            completionBlock(completed, errorMesage);
        }
    }];
}

@end
