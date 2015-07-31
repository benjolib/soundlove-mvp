//
//  ConcertViewDatasource.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 01/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "AbstractClient.h"

@interface ConcertViewDatasource : AbstractClient

@property (nonatomic, strong) NSMutableArray *objectsArray;
@property (nonatomic) NSInteger startIndex;
@property (nonatomic) NSInteger limit;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString *urlToDownloadFrom;

- (void)downloadObjectsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;
- (void)downloadNextObjectsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock;

@end
