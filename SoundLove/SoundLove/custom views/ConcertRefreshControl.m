//
//  FestivalRefreshControl.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "ConcertRefreshControl.h"
#import "UIColor+GlobalColors.h"

@interface ConcertRefreshControl ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) RefreshState currentState;
@end

@implementation ConcertRefreshControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reloadIcon"]];
    self.imageView.tintColor = [UIColor globalGreenColor];
    self.imageView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2) - 16.0, 5.0, 32.0, 32.0);
    [self addSubview:self.imageView];
}

- (void)startRefreshing
{
    CAAnimation *animation = [[self.imageView.layer animationForKey:@"slowAnimation"] mutableCopy];
    animation.duration = 0.5;
}

- (void)endRefreshing
{
    [self.imageView.layer removeAllAnimations];
}

- (void)addSlowAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.toValue = @(M_PI * 2.0);
    animation.duration = 1.0;
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    [self.imageView.layer addAnimation:animation forKey:@"slowAnimation"];
}

- (void)removeSlowAnimation
{
    [self.imageView.layer removeAnimationForKey:@"slowAnimation"];
}

- (void)setRefreshState:(RefreshState)state
{
    switch (state) {
        case RefreshStateNormal:
            [self endRefreshing];
            break;
        case RefreshStatePulling:

            break;
        case RefreshStateLoading:
            [self startRefreshing];
            break;
        default:
            break;
    }

    self.currentState = state;
}

#pragma mark - scrollView methods
- (void)parentScrollViewDidEndDragging:(UIScrollView *)parentScrollView
{
    if (parentScrollView.contentOffset.y <= -50.0)
    {
        self.currentState = RefreshStateLoading;

        CGPoint contentOffset = parentScrollView.contentOffset;

        [UIView animateWithDuration:0.3 animations:^{
            parentScrollView.contentInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0);
            parentScrollView.contentOffset = contentOffset;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.currentState = RefreshStateNormal;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            });
        }];
    }
}

- (void)parentScrollViewDidScroll:(UIScrollView *)parentScrollView
{
    if (parentScrollView.dragging)
    {
        if (self.currentState == RefreshStateNormal && parentScrollView.contentOffset.y <= -50) {
            self.currentState = RefreshStatePulling;

            [self addSlowAnimation];
        }

        if (parentScrollView.contentInset.top != 0) {
            parentScrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

@end
