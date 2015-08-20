//
//  TrackingManager.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "TrackingManager.h"
#import "Adjust.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface TrackingManager ()
@property(nonatomic, strong) id<GAITracker> tracker;
@end

@implementation TrackingManager

+ (instancetype)sharedManager
{
    static TrackingManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupAdjustTracker];
        [self setupGATracker];
    }
    return self;
}

#pragma mark - GA tracking
- (void)setupGATracker
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;

    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 40;

#ifdef DEBUG
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelInfo];
#endif

    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-62788448-12"];

    self.tracker = [[GAI sharedInstance] defaultTracker];
}

#pragma mark - adjustTracking
- (void)setupAdjustTracker
{
    NSString *yourAppToken = @"8zunhuxkf4wv";
    NSString *environment;
#ifdef DEBUG
    environment = ADJEnvironmentSandbox;
#else
    environment = ADJEnvironmentProduction;
#endif
    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:yourAppToken
                                                environment:environment];
    [Adjust appDidLaunch:adjustConfig];
    [adjustConfig setLogLevel:ADJLogLevelDebug];
}

#pragma mark - tracking methods
- (void)trackEventWithToken:(NSString*)token
{
    ADJEvent *event = [ADJEvent eventWithEventToken:token];
    [Adjust trackEvent:event];
}

- (void)trackUserLaunchedApp
{
    [self trackEventWithToken:@"6vph4n"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userLaunchedApp"
                                                                value:nil] build]];
}

- (void)trackUserSelectsReviewApp
{

}

- (void)trackUserSelectsReviewAppLater
{

}

@end
