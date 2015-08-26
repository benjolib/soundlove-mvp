//
//  ArtistDownloadClient.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ArtistDownloadClient.h"
#import "ArtistModel.h"
#import "FacebookManager.h"

@implementation ArtistDownloadClient

- (void)downloadFavoriteArtistsWithCompletionBlock:(void (^)(NSArray *artists, BOOL completed, NSString *errorMessage))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@?user_id=%@", kKunstlerFavorites, [FacebookManager currentUserID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            NSArray *jsonArray = jsonDictionary[@"data"];
            if (jsonArray.count > 0)
            {
                NSArray *artistsArray = [ArtistModel artistArrayFromStringArray:jsonArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(artistsArray, YES, nil);
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, NO, nil);
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, NO, errorMessage);
            });
        }
    }];
}

- (void)downloadRecommendedArtistsWithCompletionBlock:(void (^)(NSArray *artists, BOOL completed, NSString *errorMessage))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@?user_id=%@", kKunstlerRecommended, [FacebookManager currentUserID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            NSArray *jsonArray = jsonDictionary[@"data"];
            if (jsonArray.count > 0)
            {
                NSArray *artistsArray = [ArtistModel artistArrayFromStringArray:jsonArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(artistsArray, YES, nil);
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, NO, nil);
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, NO, errorMessage);
            });
        }
    }];
}

@end
