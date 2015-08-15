//
//  CDConcertLocation.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 12/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDConcert;

@interface CDConcertLocation : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * formattedAddress;
@property (nonatomic, retain) NSString * rawAddress;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * house;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) CDConcert *concert;

@end
