//
//  FilterModel.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 31/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FilterModel : NSObject

@property (nonatomic, strong) NSArray *selectedGenresArray;
@property (nonatomic, strong) NSArray *selectedBandsArray;

@property (nonatomic) NSNumber *fromPrice;
@property (nonatomic) NSNumber *toPrice;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic) CLLocationCoordinate2D *centerCoordinate;
@property (nonatomic) float locationDiameter;

+ (FilterModel*)copySettingsFromFilterModel:(FilterModel*)filterModel;

- (void)clearFilters;

- (BOOL)isFiltering;

- (NSString*)bandsString;
- (NSString*)genresString;

- (NSString*)bandsStringForAPICall;
- (NSString*)genresStringForAPICall;

@end
