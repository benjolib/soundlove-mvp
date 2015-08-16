//
//  LocationManager.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "LocationManager.h"

#define IS_iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface LocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^completionBlock)(CLLocation *userLocation, NSString *errorMessage);
@end

@implementation LocationManager

- (CLLocationManager*)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 10;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        return _locationManager;
    }

    return _locationManager;
}

- (void)startLocationDiscoveryWithCompletionBlock:(void(^)(CLLocation *userLocation, NSString *errorMessage))completionBlock
{
    self.completionBlock = completionBlock;

    if (IS_iOS8) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocationDiscovery
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - location manager methods
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (IS_iOS8 && status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        // when authorized and running iOS8, start updating location
        [manager startUpdatingLocation];
    }
    else
    {
        if (status == kCLAuthorizationStatusAuthorized) {
            // when authorized, start updating location
            [manager startUpdatingLocation];
        }
        else if (status == kCLAuthorizationStatusNotDetermined)
        {
            if (IS_iOS8) {
                [manager requestWhenInUseAuthorization];
            }
        }
        else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted)
        {
            // location access is restricted
            if (self.completionBlock) {
                self.completionBlock(nil, @"Please authorize Location Services in the Settings app.");
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorLocationUnknown) {
        if (self.completionBlock) {
            self.completionBlock(nil, @"Unknown error occured while getting the location.");
        }
    } else if (error.code == kCLErrorDenied) {
        if (self.completionBlock) {
            self.completionBlock(nil, @"Please authorize Location Services in the Settings app.");
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0 && self.completionBlock) {
        [manager stopUpdatingLocation];
        self.completionBlock([locations firstObject], nil);
    }
}

- (BOOL)isLocationValid:(CLLocation*)location
{
    if (location.horizontalAccuracy < 0) {
        return NO;
    }

    if (location.coordinate.latitude == 0.0 && location.coordinate.longitude == 0.0) {
        return NO;
    }

    if (!CLLocationCoordinate2DIsValid(location.coordinate)) {
        return NO;
    }

    // newLocation is good to use
    return YES;
}

- (void)dealloc
{
    _locationManager.delegate = nil;
    _locationManager = nil;
}

@end
