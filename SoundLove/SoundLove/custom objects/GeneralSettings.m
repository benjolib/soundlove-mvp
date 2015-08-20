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

//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate startPopupTimer];
}

+ (NSTimeInterval)passedIntervalSinceAppStart
{
    NSDate *appStartDate = [[NSUserDefaults standardUserDefaults] objectForKey:kAppStartDateKey];
    NSTimeInterval difference = [appStartDate timeIntervalSinceNow];
    return -difference;
}

@end
