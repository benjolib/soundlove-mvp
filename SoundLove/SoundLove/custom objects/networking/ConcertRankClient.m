//
//  FestivalRankClient.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "ConcertRankClient.h"
#import "ConcertModel.h"
#import "FacebookManager.h"

@implementation ConcertRankClient

- (void)sendRankingForFestival:(ConcertModel*)concert increment:(BOOL)increment withCompletionBlock:(void (^)(BOOL succeeded, NSString *errorMessage))completionBlock
{
    if (increment) {
        [self incrementRankForFestival:concert withCompletionBlock:completionBlock];
    } else {
        [self decrementRankForFestival:concert withCompletionBlock:completionBlock];
    }
}

- (void)incrementRankForFestival:(ConcertModel*)concert withCompletionBlock:(void (^)(BOOL succeeded, NSString *errorMessage))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?event_id=%@&user_id=%@", kBaseURL, kConcertIncrement, concert.concertID, [FacebookManager currentUserID]]]];
    [self sendRequest:request withCompletionBlock:completionBlock];
}

- (void)decrementRankForFestival:(ConcertModel*)concert withCompletionBlock:(void (^)(BOOL succeeded, NSString *errorMessage))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?event_id=%@&user_id=%@", kBaseURL, kConcertDecrement, concert.concertID, [FacebookManager currentUserID]]]];
    [self sendRequest:request withCompletionBlock:completionBlock];
}

#pragma mark - private methods
- (void)sendRequest:(NSURLRequest*)request withCompletionBlock:(void (^)(BOOL succeeded, NSString *errorMessage))completionBlock
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(completed, errorMessage);
            }
        });
    }];
}

@end
