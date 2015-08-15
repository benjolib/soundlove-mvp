//
//  FilterModel.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 31/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class SortingObject;

@interface FilterModel : NSObject

@property (nonatomic, strong) NSArray *selectedGenresArray;
@property (nonatomic, strong) NSArray *selectedBandsArray;

@property (nonatomic) NSNumber *fromPrice;
@property (nonatomic) NSNumber *toPrice;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic) float locationDiameter;

@property (nonatomic, strong) SortingObject *sortingObject;

+ (FilterModel*)copySettingsFromFilterModel:(FilterModel*)filterModel;
+ (instancetype)sharedModel;


- (void)clearFilters;

- (BOOL)isFiltering;

- (BOOL)isLocationFilteringSet;

- (NSString*)bandsString;
- (NSString*)genresString;
- (NSString*)priceString;
- (NSString*)dateString;
- (NSString*)locationString;

- (NSString*)bandsStringForAPICall;
- (NSString*)genresStringForAPICall;

@end
