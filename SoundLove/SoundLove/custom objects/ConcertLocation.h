//
//  ConcertLocation.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 10/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConcertLocation : NSObject

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *formattedAddress;
@property (nonatomic, copy) NSString *rawAddress;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *house;
@property (nonatomic, copy) NSString *zip;

- (instancetype)initWithCity:(NSString*)city country:(NSString*)country latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude street:(NSString*)street
            formattedAddress:(NSString*)formattedAddr rawAddress:(NSString*)rawAddress
                     zipcode:(NSString*)zipcode house:(NSString*)houseNumber;

+ (ConcertLocation*)concertLocationWithDictionary:(NSDictionary*)dictionary;

@end
