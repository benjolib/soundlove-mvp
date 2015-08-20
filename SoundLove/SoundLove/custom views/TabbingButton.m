//
//  TabbingButton.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 25/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "TabbingButton.h"
#import "UIColor+GlobalColors.h"
#import "BadgeCounterView.h"

@interface TabbingButton ()
@property (nonatomic, strong) BadgeCounterView *badgeView;
@end

@implementation TabbingButton

- (void)setButtonActive:(BOOL)active
{
    if (active) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor tabbingButtonActiveColor];
    } else {
        [self setTitleColor:[UIColor colorWithR:128.0 G:128.0 B:128.0] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor tabbingButtonInactiveColor];
    }
}

- (void)showBadgeWithValue:(NSInteger)value
{
    if (!self.badgeView && value > 0) {
        self.badgeView = [[BadgeCounterView alloc] initWithFrame:CGRectMake(0.0, 0.0, 21.0, 21.0)];
        self.badgeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.badgeView];
        [self setBadgeCounterVisible:NO];
    }

    if (value > 0) {
        [self.badgeView displayCounterValue:value];
        [self setBadgeCounterVisible:YES];
    } else {
        [self setBadgeCounterVisible:NO];
    }
}

- (void)hideBadgeView
{
    [self setBadgeCounterVisible:NO];
}

- (void)updateConstraints
{
    if (self.badgeView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.badgeView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:8.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.badgeView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-5.0]];
        [self.badgeView addConstraint:[NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:21.0]];
        [self.badgeView addConstraint:[NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:21.0]];
    }

    [super updateConstraints];
}

#pragma mark - badge counter
- (void)setBadgeCounterValue:(NSInteger)value
{
    if (value > 0) {
        [self.badgeView displayCounterValue:value];
        [self setBadgeCounterVisible:YES];
    } else {
        [self setBadgeCounterVisible:NO];
    }
}

- (void)setBadgeCounterVisible:(BOOL)visible
{
    if (!visible) {
        self.badgeView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    }

    [UIView animateWithDuration:0.3 animations:^{
        if (visible) {
            self.badgeView.transform = CGAffineTransformIdentity;
            self.badgeView.alpha = 1.0;
        } else {
            self.badgeView.alpha = 0.0;
            self.badgeView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        }
    }];
    self.badgeView.hidden = !visible;
}

@end
