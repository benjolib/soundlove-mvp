//
//  GeneralSettings.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralSettings : NSObject

+ (NSString*)appStoreID;

+ (void)setOnboardingViewed;
+ (BOOL)onboardingViewed;

+ (void)setTutorialsShown;
+ (BOOL)wasTutorialShown;

+ (void)setOnTrackPromptWasShown;
+ (BOOL)wasOnTrackPromptShown;

+ (void)setRateAppWasShown;
+ (BOOL)wasRateAppShown;

+ (void)saveAppStartDate;
+ (NSTimeInterval)passedIntervalSinceAppStart;


+ (void)increaseNumberOfSelectedKunstler;
+ (NSInteger)numberOfSelectedKunstler;

+ (void)setFirstTimeMarkerMiddleShown;
+ (BOOL)firstTimeMarkerMiddleShown;

+ (void)setFirstTimeMarkerLeftShown;
+ (BOOL)firstTimeMarkerLeftShown;

+ (void)setFirstTimeMarkerRightShown;
+ (BOOL)firstTimeMarkerRightShown;

@end
