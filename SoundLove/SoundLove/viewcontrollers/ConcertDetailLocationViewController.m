//
//  FestivalDetailLocationViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "ConcertDetailLocationViewController.h"
#import "ConcertModel.h"
#import "WebsiteButton.h"
//#import "TrackingManager.h"

@implementation ConcertDetailLocationViewController

- (IBAction)openWebsiteButtonPressed:(id)sender
{
//    [[TrackingManager sharedManager] trackUserSelectsWebsiteButton];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.concertToDisplay.website]];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self refreshView];
}

- (void)refreshView
{
    [super refreshView];
//    self.locationNameLabel.text = self.festivalToDisplay.locationName;
//    self.streetLabel.text = self.festivalToDisplay.address;
//    self.postCodeLabel.text = self.festivalToDisplay.postcode;
    self.cityLabel.text = self.concertToDisplay.city;
}

@end
