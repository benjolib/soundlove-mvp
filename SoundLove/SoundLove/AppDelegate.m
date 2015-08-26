//
//  AppDelegate.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 20/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <StoreKit/StoreKit.h>
#import "FacebookManager.h"
#import "StoryboardManager.h"
#import "GeneralSettings.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Parse/Parse.h>
#import "TrackingManager.h"
#import "OverlayTransitionManager.h"
#import "OnboardingViewController.h"

@interface AppDelegate () <SKStoreProductViewControllerDelegate, OverlayViewControllerDelegate>
@property (nonatomic, strong) NSTimer *popupDisplayerTimer;
@property (nonatomic, strong) OverlayTransitionManager *overlayTransitionManager;
@property (nonatomic, strong) OverlayViewController *overlayViewController;
@end

#define IS_iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[TrackingManager sharedManager] trackUserLaunchedApp];

    [Fabric with:@[CrashlyticsKit]];
    [Parse setApplicationId:@"26hpoVG7s5u7auIoBhXUKTLg4ZGmez2SfQ05ttSh"
                  clientKey:@"QtTaZxLKrkEJmebzcKXQMs4NsI08mbiDvISPqGXj"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    UIViewController *rootViewController = nil;
    if ([FacebookManager isUserLoggedInToFacebook]) {
        rootViewController = [StoryboardManager mainNavigationController];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        rootViewController = [storyboard instantiateInitialViewController];
    }

    self.window.rootViewController = rootViewController;
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

/**
 *  Returns YES, if the OnboardingViewController is the rootViewController
 */
- (BOOL)isOnboardingViewControllerRoot
{
    if ([self.window.rootViewController isMemberOfClass:[OnboardingViewController class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setRootViewControllerToOnboardingView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *rootViewController = [storyboard instantiateInitialViewController];

    self.window.rootViewController = rootViewController;
}

#pragma mark - push notification
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
    // Register for Push Notitications
    UIUserNotificationSettings *settings = [self userNotificationSettings];

    UIApplication *application = [UIApplication sharedApplication];
    if (IS_iOS8) {
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRegisteredForNotifications" object:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRegisteredForNotifications" object:nil];
}

- (void)displayAppStoreReviewPopup
{
    self.overlayTransitionManager = [[OverlayTransitionManager alloc] init];
    self.overlayViewController = [self.overlayTransitionManager presentOverlayViewWithType:OverlayTypeAppStore onViewController:self.window.rootViewController];
    self.overlayViewController.delegate = self;

    [GeneralSettings setRateAppWasShown];
}

- (void)startPopupTimer
{
    if ([GeneralSettings wasOnTrackPromptShown] || [GeneralSettings wasRateAppShown]) {
        return;
    }
    self.popupDisplayerTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updatePopupTimer:) userInfo:nil repeats:YES];
}

- (void)stopPopupTimer
{
    [self.popupDisplayerTimer invalidate];
    self.popupDisplayerTimer = nil;
}

- (void)updatePopupTimer:(NSTimer*)timer
{
    [self checkToDisplayOnTrackPopup];
}

- (void)checkToDisplayOnTrackPopup
{
    if ([GeneralSettings passedIntervalSinceAppStart] > (5 * 60) && ![GeneralSettings wasRateAppShown]) {
        [self displayAppStoreReviewPopup];
        [self.popupDisplayerTimer invalidate];
        self.popupDisplayerTimer = nil;
    }
}

- (void)overlayViewControllerConfirmButtonPressed
{
    [[TrackingManager sharedManager] userTapsReviewNow];
    [self performSelector:@selector(rateTheApp) withObject:nil afterDelay:1.0];
}

- (void)overlayViewControllerCancelButtonPressed
{
    [self stopPopupTimer];
    [GeneralSettings saveAppStartDate];
    [[TrackingManager sharedManager] userTapsReviewLater];
}

#pragma mark - rating the app
- (void)rateTheApp
{
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    [storeProductViewController setDelegate:self];

    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : [GeneralSettings appStoreID]} completionBlock:^(BOOL result, NSError *error) {
        if (!error) {
            [self.window.rootViewController presentViewController:storeProductViewController animated:YES completion:nil];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
