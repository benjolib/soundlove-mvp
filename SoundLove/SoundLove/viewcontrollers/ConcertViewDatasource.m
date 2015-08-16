//
//  ConcertViewDatasource.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 01/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertViewDatasource.h"
#import "ConcertModel.h"
#import "SortingObject.h"

@implementation ConcertViewDatasource

- (void)downloadObjectsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    NSMutableString *urlString = nil;

    // if there is sorting option selected
    if (self.sortingObject.sortingType != SortingTypeNone) {
        NSString *sortingKey = self.sortingObject.apiKey;
        NSString *sortingDir = self.sortingObject.orderDir;
        urlString = [NSMutableString stringWithFormat:@"%@%@?start=%ld&limit=%ld&orderProperty=%@&orderDir=%@", kBaseURL, self.urlToDownloadFrom, (long)self.startIndex, (long)self.limit, sortingKey, sortingDir];
    } else {
        urlString = [NSMutableString stringWithFormat:@"%@%@?start=%ld&limit=%ld", kBaseURL, self.urlToDownloadFrom, (long)self.startIndex, (long)self.limit];
    }

    if (self.searchText.length > 0) {
        [urlString appendString:[NSString stringWithFormat:@"&artist=%@", [self.searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }

    NSLog(@"Url the request was sent to: %@", urlString);

    __weak typeof(self) weakSelf = self;
    [self downloadConcertsWithURL:[NSURL URLWithString:urlString] completionBlock:^(NSString *errorMessage, NSArray *concertsArray) {
        if (errorMessage) {
            if (completionBlock) {
                completionBlock(NO, errorMessage);
            }
        } else {
            if (!weakSelf.objectsArray) {
                weakSelf.objectsArray = [NSMutableArray array];
            }
            if (weakSelf.startIndex == 0) {
                weakSelf.objectsArray = [concertsArray mutableCopy];
            } else {
                [weakSelf.objectsArray addObjectsFromArray:concertsArray];
            }

            if (completionBlock) {
                completionBlock(YES, nil);
            }
        }
    }];
}

- (void)resetDatasource
{
    [self.objectsArray removeAllObjects];
    self.objectsArray = nil;
    self.startIndex = 0;
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
