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

@interface AppDelegate () <SKStoreProductViewControllerDelegate>

@end

#define IS_iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController *rootViewController = nil;
//    if ([FacebookManager isUserLoggedInToFacebook]) {
//        rootViewController = [StoryboardManager mainNavigationController];
//    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        rootViewController = [storyboard instantiateInitialViewController];
//    }

    self.window.rootViewController = rootViewController;

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
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

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    // Store the deviceToken in the current installation and save it to Parse.
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation setDeviceTokenFromData:deviceToken];
//    [currentInstallation saveInBackground];
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    [PFPush handlePush:userInfo];
//}

#pragma mark - rating the app
- (void)rateTheApp
{
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    [storeProductViewController setDelegate:self];

    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : [GeneralSettings appStoreID]} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
        } else {
            // Present Store Product View Controller
            [self.window.rootViewController presentViewController:storeProductViewController animated:YES completion:nil];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
