//
//  ConcertViewDatasourceManager.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 01/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConcertViewDatasource.h"
#import "SortingObject.h"
#import "FilterModel.h"

typedef NS_ENUM(NSUInteger, SelectedTabIndex) {
    SelectedTabIndexFavorites = 0,
    SelectedTabIndexRecommended = 1,
    SelectedTabIndexAll = 2,
};

@interface ConcertViewDatasourceManager : NSObject

@property (nonatomic, strong) ConcertViewDatasource *allConcertDatasource;
@property (nonatomic, strong) ConcertViewDatasource *favoriteConcertDatasource;
@property (nonatomic, strong) ConcertViewDatasource *recommendedConcertDatasource;

@property (nonatomic, strong) SortingObject *currentSortingObject;
@property (nonatomic, strong) FilterModel *currentFilterModel;
@property (nonatomic) float currentLimit;
@property (nonatomic, strong) NSMutableArray *currentlyUsedObjectsArray;

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic) BOOL forceRedownload;
@property (nonatomic) BOOL isSearching;

- (void)loadObjectsAtIndex:(NSInteger)index WithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
- (void)downloadNextConcertsAtIndex:(NSInteger)index WithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
//- (void)reloadObjectsAtIndex:(NSInteger)index withFilterModel:(FilterModel*)filterModel completionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;

- (void)downloadAllConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
- (void)downloadRecommendedConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
- (void)downloadFavoriteConcertsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;






- (void)redownloadConcertsWithIndex:(NSInteger)selectedIndex filterModel:(FilterModel*)filterModel withCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
- (void)sortObjectsUsingSortingObject:(SortingObject*)sortingObject withCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
- (void)showArrayAtIndex:(SelectedTabIndex)tabIndex;


@end
