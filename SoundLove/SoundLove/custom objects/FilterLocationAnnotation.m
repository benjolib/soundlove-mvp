//
//  FilterLocationAnnotation.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 13/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FilterLocationAnnotation.h"

@implementation FilterLocationAnnotation
@synthesize coordinate = _coordinate;

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    _coordinate = coordinate;
}

@end
