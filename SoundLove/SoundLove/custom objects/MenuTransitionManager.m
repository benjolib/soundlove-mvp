//
//  MenuTransitionManager.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "MenuTransitionManager.h"
#import "MenuViewController.h"
#import "StoryboardManager.h"
#import "OverlayTransitionAnimator.h"

@implementation MenuTransitionManager

- (void)presentMenuViewControllerOnViewController:(UIViewController*)baseController
{
    MenuViewController *menuViewController = [StoryboardManager menuViewController];
    menuViewController.transitioningDelegate = self;
    [baseController presentViewController:menuViewController animated:YES completion:^{
        [menuViewController saveSourceViewController:baseController];
    }];
}

#pragma mark - transitioningDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    OverlayTransitionAnimator *animator = [OverlayTransitionAnimator new];
    animator.isPresented = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    OverlayTransitionAnimator *animator = [OverlayTransitionAnimator new];
    animator.isPresented = NO;
    return animator;
}

@end
