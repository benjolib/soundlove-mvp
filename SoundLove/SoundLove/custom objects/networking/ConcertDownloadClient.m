//
//  ConcertDownloadClient.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 27/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertDownloadClient.h"
#import "ConcertModel.h"
#import "FilterModel.h"
#import "FacebookManager.h"
#import "FriendObject.h"

@implementation ConcertDownloadClient

- (void)downloadListOfFriendsGoingToConcert:(ConcertModel*)concert withCompletionBlock:(void(^)(NSArray *listOfFriends, BOOL completed, NSString *errorMessage))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"http://api-eventim.makers.do/events/facebook/friends?event_id=%@&user_id=%@&access_token=%@", concert.concertID, [FacebookManager currentUserID], [FacebookManager currentUserAccessToken]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    __weak typeof(self) weakSelf = self;

    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            NSArray *listOfFriends = [weakSelf convertJSONDataToFriendsArray:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(listOfFriends, YES, nil);
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(nil, NO, errorMessage);
                }
            });
        }
    }];
}

#pragma mark - private methods
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

- (NSArray*)convertJSONDataToFriendsArray:(NSData*)data
{
    NSError *jsonError = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    NSArray *jsonArray = jsonDictionary[@"data"];
    if (jsonArray.count > 0)
    {
        NSMutableArray *concerts = [NSMutableArray array];
        for (int i = 0; i < jsonArray.count; i++) {
            [concerts addObject:[FriendObject friendObjectWithDictionary:jsonArray[i]]];
        }
        return concerts;
    } else {
        return nil;
    }
}

@end
