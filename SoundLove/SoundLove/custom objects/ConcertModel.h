//
//  ConcertModel.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 27/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConcertModel : NSObject

@property (nonatomic, copy) NSString *concertID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *price;

+ (ConcertModel*)concertWithDictionary:(NSDictionary*)dictionary;
- (instancetype)initWithName:(NSString*)name concertID:(NSString*)concertID city:(NSString*)city place:(NSString*)place price:(NSString*)price date:(NSDate*)date;

- (NSString*)priceString;
- (NSString*)calendarDaysTillStartDateString;

@end
