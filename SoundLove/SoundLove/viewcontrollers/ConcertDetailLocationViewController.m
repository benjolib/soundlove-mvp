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
    self.cityLabel.text = self.concertToDisplay.city;
    self.streetLabel.text = self.concertToDisplay.concertLocation.street;
    self.postCodeLabel.text = self.concertToDisplay.concertLocation.zip;
    self.locationNameLabel.text = self.concertToDisplay.place;

    [self refreshMapView];
}

- (void)refreshMapView
{
    CLLocationCoordinate2D coordinate = [self.concertToDisplay coordinate];

    [self.mapView setCenterCoordinate:coordinate];
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1, 0.1))];

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
}

#pragma mark - mapView delegate methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    }

    annotationView.annotation = annotation;
    annotationView.image = [UIImage imageNamed:@"location-pin"];
    annotationView.canShowCallout = NO;
    return annotationView;
}

- (void)dealloc
{
    self.mapView.delegate = nil;
    self.mapView = nil;
}

@end
