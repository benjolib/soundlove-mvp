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
#import "FilterModel.h"
#import "FacebookManager.h"
#import "NSDictionary+nonNullObjectForKey.h"

@implementation ConcertViewDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startIndex = 0;
        self.limit = 20;
    }
    return self;
}

- (BOOL)shouldLoadNextItems
{
    if (self.objectsArray.count < [self.totalNumberOfConcerts intValue] && self.objectsArray.count != 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)downloadObjectsWithCompletionBlock:(void(^)(BOOL completed, NSString *errorMesage))completionBlock
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@?start=%ld&limit=%ld", kBaseURL, self.urlToDownloadFrom, (long)self.startIndex, (long)self.limit];

    // if there is sorting option selected
    if (self.sortingObject.sortingType != SortingTypeNone) {
        NSString *sortingKey = self.sortingObject.apiKey;
        NSString *sortingDir = self.sortingObject.orderDir;
        urlString = [NSMutableString stringWithFormat:@"&orderProperty=%@&orderDir=%@", sortingKey, sortingDir];
    }

    // add user_id
    [urlString appendString:[NSString stringWithFormat:@"&user_id=%@", [FacebookManager currentUserID]]];

    if (self.searchText.length > 0) {
        [urlString appendString:[NSString stringWithFormat:@"&artist=%@", [self.searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }

    if ([self.filterModel isFiltering]) {
        if ([self.filterModel isLocationFilteringSet]) {
            [urlString appendString:[NSString stringWithFormat:@"&lat=%f&lng=%f&distance=%f", self.filterModel.centerCoordinate.latitude, self.filterModel.centerCoordinate.longitude, self.filterModel.locationDiameter]];
        }
        if (self.filterModel.startDate) {
            [urlString appendString:[NSString stringWithFormat:@"&dateFrom=%@", [self.filterModel startDateString]]];
        }
        if (self.filterModel.endDate) {
            [urlString appendString:[NSString stringWithFormat:@"&dateTo=%@", [self.filterModel endDateString]]];
        }
        if (self.filterModel.selectedGenresArray.count > 0) {
            [urlString appendString:[NSString stringWithFormat:@"&category=%@", [self.filterModel genresStringForAPICall]]];
        }
        if (self.filterModel.selectedBandsArray.count > 0) {
            [urlString appendString:[NSString stringWithFormat:@"&artist=%@", [self.filterModel bandsStringForAPICall]]];
        }
        if (self.filterModel.fromPrice) {
            [urlString appendString:[NSString stringWithFormat:@"&priceFrom=%@", self.filterModel.fromPrice]];
        }
        if (self.filterModel.toPrice) {
            [urlString appendString:[NSString stringWithFormat:@"&priceTo=%@", self.filterModel.toPrice]];
        }
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
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            NSNumber *totalNumberOfConcerts = [jsonDictionary nonNullObjectForKey:@"foundRows"];
            weakSelf.totalNumberOfConcerts = totalNumberOfConcerts;

            NSArray *concerts = [weakSelf parseJSONData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(nil, concerts);
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
            if ([jsonArray[i] isKindOfClass:[NSDictionary class]]) {
                [concerts addObject:[ConcertModel concertWithDictionary:jsonArray[i]]];
            }
        }
        return concerts;
    } else {
        return nil;
    }
}

@end
