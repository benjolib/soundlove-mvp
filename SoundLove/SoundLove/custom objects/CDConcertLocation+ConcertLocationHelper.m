//
//  CDConcertLocation+ConcertLocationHelper.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 12/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "CDConcertLocation+ConcertLocationHelper.h"

@implementation CDConcertLocation (ConcertLocationHelper)

- (ConcertLocation*)concertLocation
{
    ConcertLocation *concertLocation = [[ConcertLocation alloc] initWithCity:self.city country:self.country latitude:self.latitude longitude:self.longitude
                                                                      street:self.street formattedAddress:self.formattedAddress rawAddress:self.rawAddress
                                                                     zipcode:self.zip house:self.house];
    return concertLocation;
}

@end
