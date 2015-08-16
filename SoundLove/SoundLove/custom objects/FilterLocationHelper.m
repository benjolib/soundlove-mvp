//
//  FilterLocationHelper.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 15/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FilterLocationHelper.h"

@interface FilterLocationHelper ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation FilterLocationHelper

- (void)locationForCityName:(NSString*)name withCompletionBlock:(void(^)(NSArray *placeMarks))completionBlock
{
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder geocodeAddressString:name completionHandler:^(NSArray *placemarks, NSError* error){
        if (!error) {
            if (completionBlock) {
                completionBlock(placemarks);
            }
        } else {
            if (completionBlock) {
                completionBlock(nil);
            }
        }
    }];
}

- (void)cancelGeocoding
{
    [self.geocoder cancelGeocode];
}

@end
