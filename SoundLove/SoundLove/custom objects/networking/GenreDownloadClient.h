//
//  CategoryDownloadClient.h
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 16/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "AbstractClient.h"

/// Client to download the genres for the onboarding screens

@interface CategoryDownloadClient : AbstractClient

- (void)downloadAllCategoriesWithCompletionBlock:(void (^)(NSArray *sortedCategories, NSString *errorMessage, BOOL completed))completionBlock;

@end
