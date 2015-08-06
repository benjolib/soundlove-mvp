//
//  LocationManager.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject 

- (void)startLocationDiscoveryWithCompletionBlock:(void(^)(CLLocation *userLocation, NSString *errorMessage))completionBlock;
- (void)stopLocationDiscovery;

@end
