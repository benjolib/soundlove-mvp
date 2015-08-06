//
//  BandsDownloadClient.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BandsDownloadClient.h"
#import "Band.h"

@implementation BandsDownloadClient

- (void)downloadAllBandsWithCompletionBlock:(void (^)(NSArray *sortedBands, NSString *errorMessage, BOOL completed))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kBandsList]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    __weak typeof(self) weakSelf = self;
    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            NSArray *bandsArray = [weakSelf parseJSONData:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(bandsArray, errorMessage, YES);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, errorMessage, NO);
            });
        }
    }];
}

- (NSArray*)parseJSONData:(NSData*)data
{
    NSError *jsonError = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    NSArray *jsonArray = jsonDictionary[@"data"];
    if (jsonArray.count > 0)
    {
        NSMutableArray *bandsArray = [NSMutableArray array];
        for (int i = 0; i < jsonArray.count; i++) {
            [bandsArray addObject:[Band bandWithName:jsonArray[i]]];
        }

        return [bandsArray sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
            Band *band1 = (Band*)obj1;
            Band *band2 = (Band*)obj2;
            return [band1.name compare:band2.name];
        }];
    } else {
        return nil;
    }
}

@end
