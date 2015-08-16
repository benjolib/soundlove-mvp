//
//  FilterLocationHelper.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 15/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FilterLocationHelper : NSObject

- (void)locationForCityName:(NSString*)name withCompletionBlock:(void(^)(NSArray *placeMarks))completionBlock;
- (void)cancelGeocoding;

@end
