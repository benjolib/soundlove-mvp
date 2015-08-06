//
//  FilterLocationViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 04/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FilterLocationViewController.h"
#import "CustomNavigationView.h"
#import "UIColor+GlobalColors.h"
#import "LocationManager.h"
#import "FilterModel.h"

@interface FilterLocationViewController ()
@property (nonatomic, strong) LocationManager *locationManager;
@end

@implementation FilterLocationViewController

- (IBAction)closeButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)trashButtonPressed:(UIButton*)button
{
//    [self.leftPriceView setActive:NO];
//    [self.rightPriceView setActive:NO];
//
//    self.rangeSlider.leftValue = 0.2;
//    self.rangeSlider.rightValue = 1.0;
//    self.defaultMinValue = 20;
//    self.defaultMaxValue = 100;
//    [self updateRangeText];
//
//    button.alpha = 0.4;
//    button.enabled = NO;
}

- (IBAction)sliderValueChanged:(UISlider*)slider
{
    float currentValue = slider.value;

    float currentMetering = currentValue * 100;
    if (currentValue >= 0.98) {
//        currentMetering = 
    }
}

#pragma mark - location methods
- (void)startGettingUserLocation
{
    __weak typeof(self) weakSelf = self;
    self.locationManager = [LocationManager new];
    [self.locationManager startLocationDiscoveryWithCompletionBlock:^(CLLocation *userLocation, NSString *errorMessage) {
        [weakSelf.locationManager stopLocationDiscovery];
        if (errorMessage) {

        } else {
            if (userLocation) {
                [weakSelf.mapView setShowsUserLocation:YES];
                [weakSelf.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
            }
        }
    }];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.slider setThumbImage:[UIImage imageNamed:@"locationSlider"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"sliderLeft"] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"sliderRight"] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startGettingUserLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
