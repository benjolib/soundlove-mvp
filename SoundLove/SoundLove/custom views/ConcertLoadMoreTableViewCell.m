//
//  FestivalLoadMoreTableViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 18/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalLoadMoreTableViewCell.h"

@interface FestivalLoadMoreTableViewCell ()
@property (nonatomic, strong) UIImageView *loadingIndicatorView;
@end

@implementation FestivalLoadMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self endRefreshing];
}

- (void)setupView
{
    self.loadingIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reloadIcon"]];
    self.loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.loadingIndicatorView];

    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]]
     ];
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
