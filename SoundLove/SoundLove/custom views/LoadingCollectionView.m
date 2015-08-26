//
//  LoadingCollectionView.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "LoadingCollectionView.h"
#import "SearchEmptyView.h"
#import "UIColor+GlobalColors.h"

@interface LoadingCollectionView ()
@property (nonatomic, strong) UIImageView *loadingIndicatorView;
@property (nonatomic, strong) SearchEmptyView *emptyView;
@end

@implementation LoadingCollectionView

- (void)showLoadingIndicator
{
    self.loadingIndicatorView.hidden = NO;
    if (self.loadingIndicatorView) {
        [self bringSubviewToFront:self.loadingIndicatorView];
    }
    [self startRefreshing];
}

- (void)hideLoadingIndicator
{
    self.loadingIndicatorView.hidden = YES;
    [self endRefreshing];
}

- (void)reloadData
{
    [super reloadData];
    self.userInteractionEnabled = YES;
    if (self.loadingIndicatorView) {
        [self bringSubviewToFront:self.loadingIndicatorView];
    }
}

- (void)showEmptySearchView
{
    self.emptyView.hidden = NO;
    if (self.emptyView) {
        [self.emptyView showEmptySearch];
        [self bringSubviewToFront:self.emptyView];
    }
}

- (void)showEmptyCalendarView
{
    self.emptyView.hidden = NO;
    if (self.emptyView) {
        [self.emptyView showEmptyCalendarView];
        [self bringSubviewToFront:self.emptyView];
    }
}

- (void)showEmptyFilterView
{
    self.emptyView.hidden = NO;
    if (self.emptyView) {
        [self.emptyView showEmptyFilter];
        [self bringSubviewToFront:self.emptyView];
    }
}

- (void)showEmptyKunstlerFavoriteView
{
    self.emptyView.hidden = NO;
    if (self.emptyView) {
        [self.emptyView showEmptyKunslterFavoriteView];
        [self bringSubviewToFront:self.emptyView];
    }
}

- (void)hideEmptyView
{
    self.userInteractionEnabled = YES;
    self.emptyView.hidden = YES;
}

#pragma mark - private methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.loadingIndicatorView.superview) {
        UIImage *image = self.loadingIndicatorView.image;
        self.loadingIndicatorView.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - image.size.width/2, CGRectGetHeight(self.frame)/2 - image.size.height/2, image.size.width, image.size.height);
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
    [self setupEmptyView];
}

- (void)setupView
{
    UIImage *image = [UIImage imageNamed:@"reloadIcon"];
    self.loadingIndicatorView = [[UIImageView alloc] initWithImage:image];
    self.loadingIndicatorView.tintColor = [UIColor globalGreenColor];
    self.loadingIndicatorView.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - image.size.width/2, CGRectGetHeight(self.frame)/2 - image.size.height/2, image.size.width, image.size.height);
    [self addSubview:self.loadingIndicatorView];
}

- (void)setupEmptyView
{
    self.emptyView = [[SearchEmptyView alloc] init];
    self.emptyView.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - CGRectGetWidth(self.emptyView.frame)/2, CGRectGetHeight(self.frame)/2 - [SearchEmptyView viewHeight]/2, CGRectGetWidth(self.emptyView.frame), [SearchEmptyView viewHeight]);
    [self addSubview:self.emptyView];
    self.emptyView.hidden = YES;
}

- (void)startRefreshing
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.toValue = @(M_PI * 2.0);
    animation.duration = 0.8;
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    [self.loadingIndicatorView.layer addAnimation:animation forKey:@"rotationAnimation"];
}

- (void)endRefreshing
{
    [self.loadingIndicatorView.layer removeAllAnimations];
}

@end
