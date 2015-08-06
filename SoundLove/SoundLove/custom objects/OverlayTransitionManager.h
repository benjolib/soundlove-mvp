//
//  OverlayTransitionManager.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 22/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OverlayViewController.h"

@interface OverlayTransitionManager : NSObject <UIViewControllerTransitioningDelegate>

- (OverlayViewController*)presentOverlayViewWithType:(OverlayType)type onViewController:(UIViewController*)viewController;

@end
