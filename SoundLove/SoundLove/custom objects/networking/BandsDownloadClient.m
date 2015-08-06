//
//  BandsDownloadClient.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BandsDownloadClient.h"
#import "BandParser.h"

@interface BandsDownloadClient ()
@property (nonatomic, strong) BandParser *bandParser;
@end

@implementation BandsDownloadClient

- (void)downloadAllBandsWithCompletionBlock:(void (^)(NSArray *sortedBands, NSString *errorMessage, BOOL completed))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, kBandsList]]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    __weak typeof(self) weakSelf = self;
    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            weakSelf.bandParser = [BandParser new];
            NSArray *bandsArray = [weakSelf.bandParser parseJSONData:data];

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

@end
