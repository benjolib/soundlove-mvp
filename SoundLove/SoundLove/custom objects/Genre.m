//
//  Genre.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "Genre.h"

@implementation Genre

+ (Genre*)genreWithName:(NSString*)name
{
    Genre *genre = [Genre new];
    genre.name = name;
    return genre;
}

+ (NSArray*)genresFromArray:(NSArray*)array
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *genreName in array) {
        [tempArray addObject:[self genreWithName:genreName]];
    }
    return tempArray;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"Genre: %@", self.name];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]])
    {
        Genre *genre = (Genre*)object;
        if ([genre.name isEqualToString:self.name]) {
            return YES;
        }
    }
    return NO;
}

@end
