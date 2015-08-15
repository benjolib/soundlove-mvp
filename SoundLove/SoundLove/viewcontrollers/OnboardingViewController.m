//
//  OnboardingViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 28/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "OnboardingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FacebookButton.h"
#import "FacebookManager.h"
#import "OverlayViewController.h"
#import "OverlayTransitionManager.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

#define IS_iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface OnboardingViewController () <OverlayViewControllerDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) FacebookManager *facebookManager;
@property (nonatomic, strong) OverlayTransitionManager *overlayTransitionManager;
@property (nonatomic, strong) OverlayViewController *overlayViewController;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation OnboardingViewController

- (IBAction)unwindToOnboardingView:(UIStoryboardSegue*)segue
{
    self.overlayViewController = nil;

    if (!self.overlayTransitionManager) {
        self.overlayTransitionManager = [[OverlayTransitionManager alloc] init];
    }
    self.overlayViewController = [self.overlayTransitionManager presentOverlayViewWithType:OverlayTypeFacebook onViewController:self];
    self.overlayViewController.delegate = self;
}

- (IBAction)questionButtonPressed:(id)sender
{
    // TODO: 
}

- (IBAction)facebookButtonPressed:(id)sender
{
    __weak typeof(self) weakSelf = self;
    self.facebookManager = [[FacebookManager alloc] init];
    [self.facebookManager loginUserToFacebookWithCompletion:^(BOOL completed, NSString *errorMessage) {
        if (completed) {
            [weakSelf userLoggedIn];
        } else {
            if (errorMessage) {
                UIAlertView *someAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:errorMessage
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [someAlert show];
            }
        }
    }];
}

- (void)userLoggedIn
{
    [self showPushNotificationMessageView];
}

- (void)showViewContents
{
    [UIView animateWithDuration:0.3 animations:^{
        self.titleLabel.alpha = 1.0;
        self.facebookButton.alpha = 1.0;
        self.questionButton.alpha = 1.0;
        self.logoImageView.alpha = 1.0;
    }];
}

- (void)showPushNotificationMessageView
{
    self.overlayTransitionManager = [[OverlayTransitionManager alloc] init];
    self.overlayViewController = [self.overlayTransitionManager presentOverlayViewWithType:OverlayTypeMessage onViewController:self];
    self.overlayViewController.delegate = self;
}

- (void)showLocationOverlayView
{
    self.overlayViewController = nil;

    if (!self.overlayTransitionManager) {
        self.overlayTransitionManager = [[OverlayTransitionManager alloc] init];
    }
    self.overlayViewController = [self.overlayTransitionManager presentOverlayViewWithType:OverlayTypeLocation onViewController:self];
    self.overlayViewController.delegate = self;
}

- (void)overlayViewControllerConfirmButtonPressed
{
    if (self.overlayViewController.overlayTypeToDisplay == OverlayTypeLocation) {
        [self showLocationTrackingNotification];
    } else if (self.overlayViewController.overlayTypeToDisplay == OverlayTypeFacebook) {
        [self facebookButtonPressed:nil];
    } else {
        [self askUserForPushNotifications];
    }
}

- (UIUserNotificationSettings*)userNotificationSettings
{
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    return settings;
}

- (void)askUserForPushNotifications
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate askUserForPushNotifications];
}

- (void)userAnsweredPushNotificationQuestion
{
    [self showLocationOverlayView];
}

#pragma mark - location management
- (void)showLocationTrackingNotification
{
    self.locationManager = [[CLLocationManager alloc] init];
    if (IS_iOS8) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [manager stopUpdatingLocation];
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self performSegueWithIdentifier:@"userLoggedIn" sender:nil];
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.alpha = 0.0;
    self.facebookButton.alpha = 0.0;
    self.questionButton.alpha = 0.0;
    self.logoImageView.alpha = 0.0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAnsweredPushNotificationQuestion) name:@"userRegisteredForNotifications" object:nil];

    [self addVideoBackgroundLayer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showViewContents];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _playerLayer = nil;
}

#pragma mark - background video methods
- (AVPlayerLayer*)playerLayer
{
    if (!_playerLayer) {
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"onboarding" ofType:@"mov"];
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
        AVPlayer *player = [[AVPlayer alloc] initWithURL:movieURL];
        player.rate = 0.6;
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        _playerLayer.frame = CGRectMake(-CGRectGetWidth(self.view.frame), -2.5*CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame) * 4, CGRectGetHeight(self.view.frame) * 6);
        [_playerLayer.player play];
        return _playerLayer;
    }
    return _playerLayer;
}

- (void)replayMovie:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)addVideoBackgroundLayer
{
    [self.view.layer insertSublayer:self.playerLayer below:self.fadeView.layer];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replayMovie:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
