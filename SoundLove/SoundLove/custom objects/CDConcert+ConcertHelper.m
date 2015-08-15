//
//  CDConcert+ConcertHelper.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "CDConcert+ConcertHelper.h"
#import "ConcertModel.h"

@implementation CDConcert (ConcertHelper)

- (ConcertModel*)concertModel
{
    ConcertModel *concert = [ConcertModel new];
    concert.name = self.name;
    concert.price = self.price;
    concert.place = self.place;
    concert.city = self.city;
    concert.concertID = self.concertID;
    concert.date = self.date;
    concert.concertLocation = [self.location concertLocation];

    concert.image = [UIImage imageWithData:self.image.image];
    return concert;
}

@end
