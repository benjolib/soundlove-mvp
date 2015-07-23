//
//  FestivalTransitionAnimator.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 03/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalTransitionAnimator.h"
#import "UIImage+ImageEffects.h"

@implementation FestivalTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval transitonDuration = [self transitionDuration:transitionContext];

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    if (self.isPresenting)
    {
        CGFloat width = fromViewController.view.frame.size.width;
        CGRect originalFrame = fromViewController.view.frame;
        CGRect rightFrame = originalFrame;
        rightFrame.origin.x += width;

        CGRect leftFrame = originalFrame;
        leftFrame.origin.x -= width;

        [containerView addSubview:toViewController.view];
        toViewController.view.frame = rightFrame;

        [UIView animateWithDuration:transitonDuration animations:^{
            fromViewController.view.frame = leftFrame;
            toViewController.view.frame = originalFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        CGFloat width = fromViewController.view.frame.size.width;
        CGRect originalFrame = fromViewController.view.frame;
        CGRect rightFrame = originalFrame;
        rightFrame.origin.x += width;

        CGRect leftFrame = originalFrame;
        leftFrame.origin.x -= width;

        [containerView addSubview:toViewController.view];
        toViewController.view.frame = leftFrame;

        [UIView animateWithDuration:transitonDuration animations:^{
            fromViewController.view.frame = rightFrame;
            toViewController.view.frame = originalFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
