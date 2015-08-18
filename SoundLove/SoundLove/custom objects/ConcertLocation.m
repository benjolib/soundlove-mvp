//
//  ConcertLocation.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 10/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertLocation.h"
#import "NSDictionary+nonNullObjectForKey.h"

@implementation ConcertLocation

- (instancetype)initWithCity:(NSString*)city country:(NSString*)country latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude street:(NSString*)street formattedAddress:(NSString*)formattedAddr rawAddress:(NSString*)rawAddress zipcode:(NSString*)zipcode house:(NSString*)houseNumber
{
    self = [super init];
    if (self) {
        self.city = city;
        self.country = country;
        self.latitude = latitude;
        self.longitude = longitude;
        self.street = street;
        self.formattedAddress = formattedAddr;
        self.zip = zipcode;
        self.house = houseNumber;
        self.rawAddress = rawAddress;
    }
    return self;
}

+ (ConcertLocation*)concertLocationWithDictionary:(NSDictionary*)dictionary
{
    NSString *city = [dictionary nonNullObjectForKey:@"geo_city"];
    NSString *country = [dictionary nonNullObjectForKey:@"geo_country"];
    NSString *formattedAddress = [dictionary nonNullObjectForKey:@"geo_formatted_address"];
    NSString *rawAddress = [dictionary nonNullObjectForKey:@"geo_raw_address"];
    NSNumber *latitude = [dictionary nonNullObjectForKey:@"geo_lat"];
    NSNumber *longitude = [dictionary nonNullObjectForKey:@"geo_lng"];
    NSString *street = [dictionary nonNullObjectForKey:@"geo_street"];
    NSString *house = [dictionary nonNullObjectForKey:@"geo_street_number"];
    NSString *zip = [dictionary nonNullObjectForKey:@"geo_zip"];

    return [[ConcertLocation alloc] initWithCity:city country:country latitude:latitude longitude:longitude street:street formattedAddress:formattedAddress rawAddress:rawAddress zipcode:zip house:house];
}

@end
