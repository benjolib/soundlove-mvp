//
//  GeneralSettings.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "GeneralSettings.h"
#import "AppDelegate.h"

static NSString * const kOnboardingViewedKey = @"onboardingViewed";
static NSString * const kTutorialShownKey = @"tutorialShownKey";
static NSString * const kOnTrackKey = @"onTrackViewKey";
static NSString * const kRateAppKey = @"rateAppKey";
static NSString * const kAppStartDateKey = @"appStartDateKey";

static NSString * const kFirstTimeSelectedKunslter = @"FirstTimeSelectedKunslter";
static NSString * const kFirstTimeMarkerMiddle = @"FirstTimeMarkerMiddle";
static NSString * const kFirstTimeMarkerLeft = @"FirstTimeMarkerLeft";
static NSString * const kFirstTimeMarkerRight = @"FirstTimeMarkerRight";

@implementation GeneralSettings

+ (NSString*)appStoreID
{
    return @"1031561925";
}

+ (void)setOnboardingViewed
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kOnboardingViewedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setTutorialsShown
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTutorialShownKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)onboardingViewed
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kOnboardingViewedKey];
}

+ (BOOL)wasTutorialShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialShownKey];
}

+ (void)setOnTrackPromptWasShown
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kOnTrackKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)wasOnTrackPromptShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kOnTrackKey];
}

+ (void)setRateAppWasShown
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRateAppKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)wasRateAppShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kRateAppKey];
}

+ (void)saveAppStartDate
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kAppStartDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate startPopupTimer];
}

+ (NSTimeInterval)passedIntervalSinceAppStart
{
    NSDate *appStartDate = [[NSUserDefaults standardUserDefaults] objectForKey:kAppStartDateKey];
    NSTimeInterval difference = [appStartDate timeIntervalSinceNow];
    return -difference;
}

#pragma mark - onboarind settings
+ (void)increaseNumberOfSelectedKunstler
{
    NSInteger numberOfKunstler = [self numberOfSelectedKunstler];
    numberOfKunstler++;
    [[NSUserDefaults standardUserDefaults] setInteger:numberOfKunstler forKey:kFirstTimeSelectedKunslter];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)numberOfSelectedKunstler
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kFirstTimeSelectedKunslter];
}

+ (void)setFirstTimeMarkerMiddleShown
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstTimeMarkerMiddle];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)firstTimeMarkerMiddleShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFirstTimeMarkerMiddle];
}

+ (void)setFirstTimeMarkerLeftShown
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstTimeMarkerLeft];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)firstTimeMarkerLeftShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFirstTimeMarkerLeft];
}

+ (void)setFirstTimeMarkerRightShown
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstTimeMarkerRight];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)firstTimeMarkerRightShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFirstTimeMarkerRight];
}

@end
