//
//  ConcertViewDatasource.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 01/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertViewDatasource.h"
#import "ConcertModel.h"

@implementation ConcertViewDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.objectsArray = [NSMutableArray array];
    }
    return self;
}

- (void)downloadObjectsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@?start=%ld&limit=%ld", kBaseURL, self.urlToDownloadFrom, (long)self.startIndex, (long)self.limit];
    [self downloadConcertsWithURL:[NSURL URLWithString:urlString] completionBlock:^(NSString *errorMessage, NSArray *concertsArray) {
        if (errorMessage) {
            if (completionBlock) {
                completionBlock(NO, errorMessage);
            }
        } else {
            if (self.startIndex == 0) {
                self.objectsArray = [concertsArray mutableCopy];
            } else {
                [self.objectsArray addObjectsFromArray:concertsArray];
            }

            if (completionBlock) {
                completionBlock(YES, nil);
            }
        }
    }];
}

- (void)downloadNextObjectsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{

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
