//
//  ConcertViewDatasource.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 01/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "AbstractClient.h"

@class SortingObject, FilterModel;

@interface ConcertViewDatasource : AbstractClient

@property (nonatomic, strong) NSMutableArray *objectsArray;
@property (nonatomic) NSInteger startIndex;
@property (nonatomic) NSInteger limit;
@property (nonatomic, strong) NSNumber *totalNumberOfConcerts;
@property (nonatomic, copy) NSString *urlToDownloadFrom;

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, weak) SortingObject *sortingObject;
@property (nonatomic, weak) FilterModel *filterModel;

- (void)downloadObjectsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;

- (void)resetDatasource;

/**
 *  Return YES, if ther are more items on the server available, than downloaded.
 */
- (BOOL)shouldLoadNextItems;

@end
