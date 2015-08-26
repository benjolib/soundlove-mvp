//
//  ArtistRatingClient.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 21/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ArtistRatingClient.h"
#import "FacebookManager.h"

@implementation ArtistRatingClient

- (void)likeArtist:(ArtistModel*)artist withCompletionBlock:(void (^)(BOOL completed, NSString *errorMessage))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@?user_id=%@&artist=%@", kKunstlerLike, [FacebookManager currentUserID], [artist.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];

    [self sendRequestWithURL:url withCompletionBlock:completionBlock];
}

- (void)dislikeArtist:(ArtistModel*)artist withCompletionBlock:(void (^)(BOOL completed, NSString *errorMessage))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@?user_id=%@&artist=%@", kKunstlerDisLike, [FacebookManager currentUserID], [artist.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];

    [self sendRequestWithURL:url withCompletionBlock:completionBlock];
}

#pragma mark - private methods
- (void)sendRequestWithURL:(NSURL*)url withCompletionBlock:(void (^)(BOOL completed, NSString *errorMessage))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(completed, errorMessage);
        });
    }];
}

@end
