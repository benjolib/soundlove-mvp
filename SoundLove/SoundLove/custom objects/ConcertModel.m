//
//  ConcertModel.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 27/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertModel.h"
#import "NSDictionary+nonNullObjectForKey.h"
#import "FriendObject.h"

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
    NSString *detailsURL = [dictionary nonNullObjectForKey:@"details_url"];
    NSString *rank = [dictionary nonNullObjectForKey:@"rank"];

    ConcertModel *concert = [[ConcertModel alloc] initWithName:name concertID:concertID city:city place:place price:price date:date imageURL:imageURL rank:rank];
    concert.concertLocation = [ConcertLocation concertLocationWithDictionary:dictionary];
    concert.detailsURL = detailsURL;

//#ifdef DEBUG
//    concert.friendsArray = [ConcertModel createFakeFriends];
//#else 
    NSArray *friendsArray = [dictionary nonNullObjectForKey:@"friends"];
    if (friendsArray)
    {
        NSMutableArray *friendsTempArray = [NSMutableArray array];
        for (NSDictionary *friendDictionary in friendsArray) {
            [friendsTempArray addObject:[FriendObject friendObjectWithDictionary:friendDictionary]];
        }
        concert.friendsArray = friendsTempArray;
    }
//#endif
    return concert;
}

- (instancetype)initWithName:(NSString*)name concertID:(NSString*)concertID city:(NSString*)city place:(NSString*)place price:(NSString*)price date:(NSDate*)date imageURL:(NSString*)imageURL rank:(NSString*)rank
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
        self.rank = rank;
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

+ (NSArray*)createFakeFriends
{
    NSMutableArray *friendsTempArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [friendsTempArray addObject:[FriendObject friendObjectWithDictionary:@{@"id": @"24141", @"name": @"John Smith", @"picture": @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/v/t1.0-1/p50x50/10603588_102209476787153_6748298543344698984_n.jpg?oh=6bc4c78d9f568041cd48e06b91fbdf20&oe=56782B82&__gda__=1450349470_68e004032853bc5f3b469a5a8538ce6b"}]];
    }
    return friendsTempArray;
}

@end
