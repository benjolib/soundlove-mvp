//
//  TrackingManager.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackingManager : NSObject

+ (instancetype)sharedManager;

- (void)trackUserLaunchedApp;
- (void)trackUserSelectsReviewApp;
- (void)trackUserSelectsReviewAppLater;

@end
