//
//  FestivalDetailLocationViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "ConcertDetailBaseViewController.h"
#import <MapKit/MapKit.h>

@class WebsiteButton;

@interface ConcertDetailLocationViewController : ConcertDetailBaseViewController

@property (nonatomic, weak) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *streetLabel;
@property (nonatomic, weak) IBOutlet UILabel *postCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postcodeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeTitleLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *mapViewOverlay;
@property (weak, nonatomic) IBOutlet WebsiteButton *websiteButton;

@end
