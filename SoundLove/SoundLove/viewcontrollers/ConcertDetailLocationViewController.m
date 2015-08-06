//
//  FestivalDetailLocationViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailLocationViewController.h"
#import "FestivalModel.h"
#import "WebsiteButton.h"
#import "UIFont+LatoFonts.h"
#import "TrackingManager.h"

@implementation FestivalDetailLocationViewController

- (IBAction)openWebsiteButtonPressed:(id)sender
{
    [[TrackingManager sharedManager] trackUserSelectsWebsiteButton];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.festivalToDisplay.website]];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self refreshView];
    [self setFonts];
}

- (void)refreshView
{
    [super refreshView];
    self.locationNameLabel.text = self.festivalToDisplay.locationName;
    self.streetLabel.text = self.festivalToDisplay.address;
    self.postCodeLabel.text = self.festivalToDisplay.postcode;
    self.cityLabel.text = self.festivalToDisplay.city;

    self.websiteButton.hidden = self.festivalToDisplay.website.length == 0;
}

- (void)setFonts
{
    self.locationTitleLabel.font = [UIFont latoBoldFontWithSize:16];
    self.streetTitleLabel.font = [UIFont latoBoldFontWithSize:16];
    self.postCodeLabel.font = [UIFont latoBoldFontWithSize:16];
    self.placeTitleLabel.font = [UIFont latoBoldFontWithSize:16];

    self.locationNameLabel.font = [UIFont latoRegularFontWithSize:16.0];
    self.streetLabel.font = [UIFont latoRegularFontWithSize:16.0];
    self.postCodeLabel.font = [UIFont latoRegularFontWithSize:16.0];
    self.cityLabel.font = [UIFont latoRegularFontWithSize:16.0];
}

@end
