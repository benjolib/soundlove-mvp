//
//  OverlayTransitionManager.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 22/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "OverlayTransitionManager.h"
#import "OverlayTransitionAnimator.h"
#import "StoryboardManager.h"

@implementation OverlayTransitionManager

- (void)presentOverlayViewWithType:(OverlayType)type onViewController:(UIViewController*)viewController
{
    OverlayViewController *overlayViewController = [StoryboardManager overlayViewController];
    
    overlayViewController.transitioningDelegate = self;
    [viewController presentViewController:overlayViewController animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    OverlayTransitionAnimator *animator = [OverlayTransitionAnimator new];
    animator.isPresented = NO;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    OverlayTransitionAnimator *animator = [OverlayTransitionAnimator new];
    animator.isPresented = YES;
    return animator;
}

@end
