//
//  FilterLocationViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 04/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"
#import <MapKit/MapKit.h>
#import "FilterViewController.h"

@interface FilterLocationViewController : FilterViewController <MKMapViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, weak) IBOutlet UIView *searchWrapperView;
@property (nonatomic, weak) IBOutlet UITextField *searchField;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UITableView *searchResultTableView;

- (IBAction)sliderValueChanged:(UISlider*)slider;
- (IBAction)userCancelledSearch:(id)sender;

@end
