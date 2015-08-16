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
#import "FilterLocationAnnotation.h"
#import "FilterLocationAnnotationView.h"
#import "MapOverlay.h"
#import "MapOverlayRenderer.h"
#import "DBMapSelectorManager.h"
#import "FilterLocationHelper.h"
#import "FilterModel.h"

@interface FilterLocationViewController () <DBMapSelectorManagerDelegate>
@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) MapOverlayRenderer *selectorOverlayRenderer;
@property (nonatomic, strong) DBMapSelectorManager *mapSelectorManager;
@property (nonatomic, strong) FilterLocationHelper *filterLocationHelper;

@property (nonatomic, strong) NSArray *placeMarkSuggestionsArray;
@end

@implementation FilterLocationViewController

- (IBAction)trashButtonPressed:(UIButton*)button
{
    self.filterModel.locationDiameter = 0;
    [self setTrashIconVisible:NO];
}

- (IBAction)sliderValueChanged:(UISlider*)slider
{
    float currentValue = slider.value;

    float currentMetering = currentValue * 100;
    if (currentValue >= 0.98) {
//        currentMetering = 
    }
}

#pragma mark - searching methods
- (IBAction)userCancelledSearch:(id)sender
{
    self.searchField.text = @"";
    [self.searchField resignFirstResponder];
}

- (IBAction)searchFieldTextChanged:(UITextField*)searchField
{
    if (searchField.text.length > 3)
    {
        [self.filterLocationHelper cancelGeocoding];

        if (!self.filterLocationHelper) {
            self.filterLocationHelper = [[FilterLocationHelper alloc] init];
        }
        [self.filterLocationHelper locationForCityName:searchField.text withCompletionBlock:^(NSArray *placeMarks) {
            if (placeMarks.count > 0) {
                self.placeMarkSuggestionsArray = placeMarks;
                [self.tableView reloadData];
                self.tableView.hidden = NO;
            }
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placeMarkSuggestionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    CLPlacemark *placeMark = self.placeMarkSuggestionsArray[indexPath.row];
    if (placeMark.name) {
        cell.textLabel.text = placeMark.name;
    } else if (placeMark.locality) {
        cell.textLabel.text = placeMark.locality;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CLPlacemark *selectedPlaceMark = self.placeMarkSuggestionsArray[indexPath.row];

    self.filterModel.centerCoordinate = selectedPlaceMark.location.coordinate;
    self.mapSelectorManager.circleCoordinate = selectedPlaceMark.location.coordinate;
    [self.mapSelectorManager applySelectorSettings];

    self.tableView.hidden = YES;
    [self.searchField resignFirstResponder];
    [self setTrashIconVisible:YES];
}

#pragma mark - mapView delegates
- (DBMapSelectorManager *)mapSelectorManager {
    if (!_mapSelectorManager) {
        _mapSelectorManager = [[DBMapSelectorManager alloc] initWithMapView:self.mapView];
        _mapSelectorManager.delegate = self;
    }
    return _mapSelectorManager;
}

- (void)mapSelectorManager:(DBMapSelectorManager *)mapSelectorManager didChangeCoordinate:(CLLocationCoordinate2D)coordinate {
//    _coordinateLabel.text = [NSString stringWithFormat:@"Coordinate = {%.5f, %.5f}", coordinate.latitude, coordinate.longitude];
    self.filterModel.centerCoordinate = coordinate;
}

- (void)mapSelectorManager:(DBMapSelectorManager *)mapSelectorManager didChangeRadius:(CLLocationDistance)radius {
//    NSString *radiusStr = (radius >= 1000) ? [NSString stringWithFormat:@"%.1f km", radius * .001f] : [NSString stringWithFormat:@"%.0f m", radius];
    NSLog(@"Radius: %.2f km", radius * 0.001);

    self.filterModel.locationDiameter = radius;

    if (radius <= 150000) // 150km, half of the slider
    {
        if (radius == 150000) {
            [self.slider setValue:0.5];
        } else if (radius <= 1000) {
            [self.slider setValue:0];
        } else {
            float value = (radius / 150000) / 2;
            [self.slider setValue:value];
        }
    }
    else // above 150km
    {
        [self.slider setValue:0.5];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    return [self.mapSelectorManager mapView:mapView viewForAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    [self.mapSelectorManager mapView:mapView annotationView:annotationView didChangeDragState:newState fromOldState:oldState];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    return [self.mapSelectorManager mapView:mapView rendererForOverlay:overlay];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.mapSelectorManager mapView:mapView regionDidChangeAnimated:animated];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapSelectorManager.circleCoordinate = self.mapView.userLocation.coordinate;
    [self.mapSelectorManager applySelectorSettings];
}

#pragma mark - location methods
- (void)startGettingUserLocation
{
    __weak typeof(self) weakSelf = self;
    self.locationManager = [LocationManager new];
    [self.locationManager startLocationDiscoveryWithCompletionBlock:^(CLLocation *userLocation, NSString *errorMessage) {
        if (errorMessage) {
            // TODO: error handling
        } else {
            if (userLocation) {
                if ([weakSelf.locationManager isLocationValid:userLocation]) {
                    [weakSelf.locationManager stopLocationDiscovery];
                }
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

    self.mapView.showsUserLocation = YES;

    // Set map selector settings
    self.mapSelectorManager.circleCoordinate = self.mapView.userLocation.coordinate;
    self.mapSelectorManager.circleRadius = 1000;
    self.mapSelectorManager.circleRadiusMax = 1000000;
    [self.mapSelectorManager applySelectorSettings];

    self.searchField.textColor = [UIColor globalGreenColor];
    self.searchField.tintColor = [UIColor globalGreenColor];

    self.searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchField.placeholder
                                                                             attributes:@{NSForegroundColorAttributeName: [UIColor colorWithR:142.0 G:223.0 B:183.0]}];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.filterModel isLocationFilteringSet]) {
        self.mapSelectorManager.circleCoordinate = self.filterModel.centerCoordinate;
        [self.mapSelectorManager applySelectorSettings];
    } else {
        [self startGettingUserLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
