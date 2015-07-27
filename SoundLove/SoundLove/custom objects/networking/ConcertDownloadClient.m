//
//  ConcertDownloadClient.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 27/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertDownloadClient.h"
#import "ConcertModel.h"

@implementation ConcertDownloadClient

- (void)downloadConcertsFromIndex:(NSInteger)startIndex limit:(NSInteger)numberOfItems withFilters:(NSString*)EDIT_THIS searchText:(NSString*)searchText completionBlock:(void (^)(NSString *errorMessage, NSArray *concertsArray))completionBlock
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@?start=%ld&limit=%ld", kBaseURL, kConcertsList, (long)startIndex, (long)numberOfItems];

    [self downloadConcertsWithURL:[NSURL URLWithString:urlString] completionBlock:completionBlock];
}

#pragma mark - private methods
- (void)downloadConcertsWithURL:(NSURL*)url completionBlock:(void (^)(NSString *errorMessage, NSArray *concertsArray))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    __weak typeof(self) weakSelf = self;

    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            NSArray *festivals = [weakSelf parseJSONData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(nil, festivals);
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(errorMessage, nil);
                }
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
        NSMutableArray *concerts = [NSMutableArray array];
        for (int i = 0; i < jsonArray.count; i++) {
            [concerts addObject:[ConcertModel concertWithDictionary:jsonArray[i]]];
        }
        return concerts;
    } else {
        return nil;
    }
}

@end
