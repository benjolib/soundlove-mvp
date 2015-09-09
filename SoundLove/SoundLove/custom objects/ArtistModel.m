//
//  ArtistModel.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ArtistModel.h"
#import "NSDictionary+nonNullObjectForKey.h"

@implementation ArtistModel

+ (ArtistModel*)artistWithName:(NSString*)name imageURL:(NSString*)imageURL
{
    ArtistModel *artist = [ArtistModel new];
    artist.name = name;
    artist.imageURL = imageURL;
    return artist;
}

+ (NSArray*)artistArrayFromStringArray:(NSArray*)array
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *artistDictionary in array) {
        NSString *name = [artistDictionary nonNullObjectForKey:@"name"];
        NSString *imageURL = [artistDictionary nonNullObjectForKey:@"picture"];
        if (!imageURL) {
            imageURL = [artistDictionary nonNullObjectForKey:@"image"];
        }
        [tempArray addObject:[self artistWithName:name imageURL:imageURL]];
    }

    return [tempArray sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        ArtistModel *artist1 = (ArtistModel*)obj1;
        ArtistModel *artist2 = (ArtistModel*)obj2;
        return [artist1.name compare:artist2.name];
    }];
}

- (NSString*)artistNameForAPI
{
    NSString *artistName = [self.name stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    return [artistName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
