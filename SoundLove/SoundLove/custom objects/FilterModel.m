//
//  FilterModel.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 31/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FilterModel.h"
#import "Genre.h"
#import "Band.h"

@implementation FilterModel

+ (FilterModel*)copySettingsFromFilterModel:(FilterModel*)filterModel
{
    FilterModel *newFilterModel = [FilterModel new];

    newFilterModel.selectedBandsArray = filterModel.selectedBandsArray;
    newFilterModel.selectedGenresArray = filterModel.selectedGenresArray;
    newFilterModel.startDate = filterModel.startDate;
    newFilterModel.endDate = filterModel.endDate;
    newFilterModel.fromPrice = filterModel.fromPrice;
    newFilterModel.toPrice = filterModel.toPrice;

    return newFilterModel;
}

- (void)clearFilters
{
    self.fromPrice = 0;
    self.toPrice = 0;
    self.startDate = nil;
    self.endDate = nil;
    self.selectedGenresArray = nil;
    self.selectedBandsArray = nil;
}

- (BOOL)isFiltering
{
    if (self.fromPrice != 0) {
        return YES;
    } else if (self.toPrice != 0) {
        return YES;
    } else if (self.selectedGenresArray.count > 0) {
        return YES;
    } else if (self.selectedBandsArray.count > 0) {
        return YES;
    } else if (self.startDate) {
        return YES;
    } else if (self.endDate) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - string methods
- (NSString*)bandsString
{
    NSMutableString *bandsString = [[NSMutableString alloc] init];
    for (int i = 0; i < self.selectedBandsArray.count; i++) {
        Band *band = self.selectedBandsArray[i];
        [bandsString appendString:band.name];
        if (i != self.selectedBandsArray.count-1) {
            [bandsString appendString:@","];
        }
    }

    return bandsString;
}

- (NSString*)genresString
{
    NSMutableString *genresString = [[NSMutableString alloc] init];
    for (int i = 0; i < self.selectedGenresArray.count; i++) {
        Genre *genre = self.selectedGenresArray[i];
        [genresString appendString:genre.name];
        if (i != self.selectedGenresArray.count-1) {
            [genresString appendString:@","];
        }
    }

    return genresString;
}

- (NSString*)bandsStringForAPICall
{
    return [[self bandsString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)genresStringForAPICall
{
    return [[self genresString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
