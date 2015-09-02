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
#import "SortingObject.h"

@interface FilterModel ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation FilterModel

+ (instancetype)sharedModel
{
    static FilterModel *sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [[FilterModel alloc] init];
    });
    return sharedModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sortingObject = [SortingObject sortingWithType:SortingTypeNone];
        [self resetFiterLocation];
    }
    return self;
}

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
    self.locationDiameter = 0;
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
    } else if ([self isLocationFilteringSet]){
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isLocationFilteringSet
{
    return CLLocationCoordinate2DIsValid(self.centerCoordinate) || self.selectedCity;
}

- (void)resetFiterLocation
{
    self.locationDiameter = 0;
    self.centerCoordinate = CLLocationCoordinate2DMake(5000.0, 5000.0);
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

- (NSString*)priceString
{
    NSString *priceString = @"";
    if (self.fromPrice) {
        if (self.toPrice) {
            priceString = [NSString stringWithFormat:@"Ab %.2f € bis %.2f €", self.fromPrice.floatValue, self.toPrice.floatValue];
        } else {
            priceString = [NSString stringWithFormat:@"Ab %.2f €", self.fromPrice.floatValue];
        }
    } else if (self.toPrice) {
        priceString = [NSString stringWithFormat:@"Bis %.2f €", self.toPrice.floatValue];
    }

    return priceString;
}

- (NSString*)dateString
{
    NSString *dateString = @"";
    if (self.startDate) {
        if (self.endDate) {
            dateString = [NSString stringWithFormat:@"Von %@ bis %@", [self.dateFormatter stringFromDate:self.startDate], [self.dateFormatter stringFromDate:self.endDate]];
        } else {
            dateString = [NSString stringWithFormat:@"Von %@", [self.dateFormatter stringFromDate:self.startDate]];
        }
    } else if (self.endDate) {
        dateString = [NSString stringWithFormat:@"Bis %@", [self.dateFormatter stringFromDate:self.endDate]];
    }

    return dateString;
}

- (NSString*)startDateString
{
    return [self.dateFormatter stringFromDate:self.startDate];
}

- (NSString*)endDateString
{
    return [self.dateFormatter stringFromDate:self.endDate];
}

- (NSString*)bandsStringForAPICall
{
    return [[self bandsString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)genresStringForAPICall
{
    NSString *genreString = [[self genresString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [genreString stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
}

- (NSDateFormatter*)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"dd.MM.YYY";
    }
    return _dateFormatter;
}

@end
