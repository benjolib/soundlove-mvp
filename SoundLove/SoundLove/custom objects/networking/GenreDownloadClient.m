//
//  CategoryDownloadClient.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 16/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "GenreDownloadClient.h"
#import "Genre.h"

@implementation GenreDownloadClient

- (void)downloadAllGenresWithCompletionBlock:(void (^)(NSArray *sortedGenres, NSString *errorMessage, BOOL completed))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kGenresList]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];
    
    __weak typeof(self) weakSelf = self;
    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completed)
        {
            NSArray *genresArray = [weakSelf parseJSONData:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(genresArray, nil, YES);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, errorMessage, NO);
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
        NSMutableArray *genresArray = [NSMutableArray array];
        for (int i = 0; i < jsonArray.count; i++) {
            [genresArray addObject:[Genre genreWithName:jsonArray[i]]];
        }

        return [genresArray sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
            Genre *genre1 = (Genre*)obj1;
            Genre *genre2 = (Genre*)obj2;
            return [genre1.name compare:genre2.name];
        }];
    } else {
        return nil;
    }
}

@end
