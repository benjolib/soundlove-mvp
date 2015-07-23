//
//  FestivalTransitionManager.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 03/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalTransitionManager.h"
#import "FestivalTransitionAnimator.h"
//#import "FestivalNavigationController.h"
#import "StoryboardManager.h"

@implementation FestivalTransitionManager

- (void)presentFestivalViewControllerOnViewController:(UIViewController*)baseController
{
//    FestivalNavigationController *festivalViewController = [StoryboardManager festivalNavigationController];
//    festivalViewController.transitioningDelegate = self;
//    [baseController presentViewController:festivalViewController animated:YES completion:nil];
}

- (void)presentInfoViewControllerOnViewController:(UIViewController*)baseController
{
    UINavigationController *navigationController = [StoryboardManager infoNavigationController];
    navigationController.transitioningDelegate = self;
    [baseController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - transitioningDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    FestivalTransitionAnimator *animator = [FestivalTransitionAnimator new];
    animator.isPresenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    FestivalTransitionAnimator *animator = [FestivalTransitionAnimator new];
    animator.isPresenting = NO;
    return animator;
}

@end
