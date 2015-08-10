//
//  ConcertModel.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 27/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseImageModel.h"
#import <CoreLocation/CoreLocation.h>
#import "ConcertLocation.h"

@interface ConcertModel : BaseImageModel

@property (nonatomic, copy) NSString *concertID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *detailsURL;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, strong) ConcertLocation *concertLocation;

+ (ConcertModel*)concertWithDictionary:(NSDictionary*)dictionary;
- (instancetype)initWithName:(NSString*)name concertID:(NSString*)concertID city:(NSString*)city place:(NSString*)place price:(NSString*)price date:(NSDate*)date imageURL:(NSString*)imageURL;

- (NSString*)priceString;
- (NSString*)calendarDaysTillStartDateString;
- (NSString*)formattedAddress;
- (CLLocationCoordinate2D)coordinate;

@end
