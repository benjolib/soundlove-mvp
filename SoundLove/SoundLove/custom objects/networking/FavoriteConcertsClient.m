//
//  FavoriteConcertsClient.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 12/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FavoriteConcertsClient.h"
#import "ConcertModel.h"
#import "NSDate+DateHelper.h"

@implementation FavoriteConcertsClient

- (void)downloadConcertsWithCompletionBlock:(void (^)(NSString *errorMessage, NSArray *concertsArray))completionBlock
{
    NSDate *today = [NSDate date];

    // With a calendar object, request the day unit of the month unit
    NSRange dayRange = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:today];
    NSDateComponents *components = [today dateComponents];
    NSString *dateFromString = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)components.year, (long)components.month, (long)components.day];
    NSString *dateToString = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)components.year, (long)components.month, (unsigned long)dayRange.length];

    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@?limit=1000&dateFrom=%@&dateTo=%@&orderProperty=date_ts&orderDir=ASC", kBaseURL, kFavoriteConcertsList, dateFromString, dateToString];
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
