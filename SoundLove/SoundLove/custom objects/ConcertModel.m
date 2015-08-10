//
//  ConcertModel.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 27/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertModel.h"
#import "NSDictionary+nonNullObjectForKey.h"

@implementation ConcertModel

+ (ConcertModel*)concertWithDictionary:(NSDictionary*)dictionary
{
    NSString *name = [dictionary nonNullObjectForKey:@"artist"];
    NSString *concertID = [dictionary nonNullObjectForKey:@"id"];
    NSString *city = [dictionary nonNullObjectForKey:@"city"];
    NSString *place = [dictionary nonNullObjectForKey:@"place"];
    NSString *price = [dictionary nonNullObjectForKey:@"price_from"];
    NSDate *date = [self convertDateStringToDate:[dictionary nonNullObjectForKey:@"date_ts"]];
    NSString *imageURL = [dictionary nonNullObjectForKey:@"image_url"];

    ConcertModel *concert = [[ConcertModel alloc] initWithName:name concertID:concertID city:city place:place price:price date:date imageURL:imageURL];
    concert.concertLocation = [ConcertLocation concertLocationWithDictionary:dictionary];
    return concert;
}

- (instancetype)initWithName:(NSString*)name concertID:(NSString*)concertID city:(NSString*)city place:(NSString*)place price:(NSString*)price date:(NSDate*)date imageURL:(NSString*)imageURL
{
    self = [super init];
    if (self) {
        self.name = name;
        self.concertID = concertID;
        self.city = city;
        self.place = place;
        self.price = price;
        self.date = date;
        self.imageURL = imageURL;
    }
    return self;
}

#pragma mark - getter methods
- (NSString*)priceString
{
    return [NSString stringWithFormat:@"ab %@ €", self.price];
}

- (NSString*)calendarDaysTillStartDateString
{
    if (!self.date) {
        return nil;
    }
    NSInteger numberOfDaysLeft = [self daysTillStartDate];
    if (numberOfDaysLeft <= 0) {
        return [NSString stringWithFormat:@"Jetzt"];
    }
    return [NSString stringWithFormat:@"In %ld Tagen", (long)numberOfDaysLeft];
}

- (NSString*)formattedAddress
{
    return [self.concertLocation formattedAddress];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.concertLocation.latitude.doubleValue, self.concertLocation.longitude.doubleValue);
}

#pragma mark - private methods
+ (NSDate*)convertDateStringToDate:(NSString*)dateString
{
    //2015-08-05 10:13:00
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:SS";

    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

- (NSInteger)daysTillStartDate
{
    if (!self.date) {
        return 0;
    }
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[NSDate date]
                                                          toDate:self.date
                                                         options:0];
    NSInteger numberOfDays = components.day;
    return numberOfDays;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        ConcertModel *model = (ConcertModel*)object;
        if ([model.concertID isEqualToString:self.concertID]) {
            return YES;
        }
    }
    return NO;
}

@end
