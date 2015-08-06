//
//  BandsDownloadClient.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "AbstractClient.h"

@interface BandsDownloadClient : AbstractClient

- (void)downloadAllBandsWithCompletionBlock:(void (^)(NSArray *sortedBands, NSString *errorMessage, BOOL completed))completionBlock;

@end
