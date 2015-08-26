//
//  CategoryDownloadClient.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 16/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "GenreDownloadClient.h"
#import "Genre.h"
#import "NSDictionary+nonNullObjectForKey.h"

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
    NSDictionary *dataDictionary = [jsonDictionary nonNullObjectForKey:@"data"];

    if (dataDictionary.allKeys.count == 0) {
        return nil;
    }
    
    __block NSInteger index = 0;
    NSMutableArray *genresArray = [NSMutableArray array];
    [dataDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [genresArray addObject:[Genre genreWithName:key andValue:obj]];
        ++index;
        if (index == dataDictionary.allKeys.count) {
            *stop = YES;
        }
    }];

    return genresArray;
}

@end
