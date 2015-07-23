//
//  OverlayTransitionAnimator.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 22/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "OverlayTransitionAnimator.h"
#import "OverlayViewController.h"
#import "UIImage+ImageEffects.h"

@implementation OverlayTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    OverlayViewController *toViewController = (OverlayViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIView *containerView = [transitionContext containerView];

    if (self.isPresented)
    {
        UIImage *snapshotImage = [self createBlurredSnapshotOfView:fromViewController.view];

        UIImageView *blurredImageView = [[UIImageView alloc] initWithFrame:fromViewController.view.frame];
        blurredImageView.image = snapshotImage;

//        UIView *glassWhiteView = [[UIView alloc] initWithFrame:toViewController.view.frame];
//        glassWhiteView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
//        [blurredImageView addSubview:glassWhiteView];

        toViewController.view.alpha = 0.0;
        [toViewController.view insertSubview:blurredImageView atIndex:0];
        [containerView addSubview:toViewController.view];

        [UIView animateWithDuration:duration
                         animations:^{
                             toViewController.view.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else
    {
        UIView *snapshotView = [fromViewController.view resizableSnapshotViewFromRect:fromViewController.view.frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        snapshotView.frame = [transitionContext finalFrameForViewController:toViewController];
        [containerView addSubview:snapshotView];

        fromViewController.view.alpha = 0.0;

        // add toViewController's view to the view tree to avoid the black background
        UIView *toViewControllerSnapshotView = [toViewController.view resizableSnapshotViewFromRect:toViewController.view.frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        [containerView insertSubview:toViewControllerSnapshotView belowSubview:snapshotView];

        [UIView animateWithDuration:duration
                         animations:^{
                             snapshotView.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [snapshotView removeFromSuperview];
                             [fromViewController.view removeFromSuperview];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

- (UIImage*)createBlurredSnapshotOfView:(UIView*)view
{
    return [[self createSnapshotOfView:view] applyDarkEffect];
}

- (UIImage*)createSnapshotOfView:(UIView*)view
{
    CGRect frame = view.frame;
    UIGraphicsBeginImageContext(frame.size);
    [view drawViewHierarchyInRect:frame afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

@end
