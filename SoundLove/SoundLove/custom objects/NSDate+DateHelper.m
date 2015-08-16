//
//  NSDate+DateHelper.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 12/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "NSDate+DateHelper.h"

@implementation NSDate (DateHelper)

- (NSDateComponents*)dateComponents
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone localTimeZone];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSDayCalendarUnit fromDate:self];
    return components;
}

@end
