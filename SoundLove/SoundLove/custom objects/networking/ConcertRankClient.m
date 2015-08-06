//
//  FestivalRankClient.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalRankClient.h"
#import "FestivalModel.h"

@implementation FestivalRankClient

- (void)sendRankingForFestival:(FestivalModel*)festival increment:(BOOL)increment withCompletionBlock:(void (^)(BOOL succeeded, NSString *errorMessage))completionBlock
{
    if (increment) {
        [self incrementRankForFestival:festival withCompletionBlock:completionBlock];
    } else {
        [self decrementRankForFestival:festival withCompletionBlock:completionBlock];
    }
}

- (void)incrementRankForFestival:(FestivalModel*)festival withCompletionBlock:(void (^)(BOOL succeeded, NSString *errorMessage))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?name=%@", kBaseURL, kFestivalIncrement, [festival.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    [self sendRequest:request withCompletionBlock:completionBlock];
}

- (void)decrementRankForFestival:(FestivalModel*)festival withCompletionBlock:(void (^)(BOOL succeeded, NSString *errorMessage))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?name=%@", kBaseURL, kFestivalDecrement, [festival.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
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
