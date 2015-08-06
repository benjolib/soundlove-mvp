//
//  FilterLocationViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 04/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"
#import <MapKit/MapKit.h>

@class CustomNavigationView;

@interface FilterLocationViewController : BaseGradientViewController

@property (nonatomic, weak) IBOutlet CustomNavigationView *navigationView;
@property (nonatomic, weak) IBOutlet UIButton *trashButton;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

- (IBAction)sliderValueChanged:(UISlider*)slider;

@end
