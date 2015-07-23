//
//  MenuButton.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "MenuButton.h"
#import "UIColor+GlobalColors.h"
#import "BadgeCounterView.h"

@interface MenuButton ()
@property (nonatomic, strong) BadgeCounterView *badgeView;
@end

@implementation MenuButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    if (self.titleLabel.text) {
        self.imageView.tintColor = [UIColor menuButtonSelectedColor];
    }
    [self setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];

    self.badgeView = [[BadgeCounterView alloc] initWithFrame:CGRectMake(0.0, 0.0, 21.0, 21.0)];
    self.badgeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.badgeView];
    [self setBadgeCounterVisible:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize iconSize = self.imageView.image.size;

    CGRect iconFrame = self.imageView.frame;
    iconFrame.origin.x = (CGRectGetWidth(self.frame) / 2) - iconSize.width/2;
    iconFrame.origin.y = 5.0;
    self.imageView.frame = iconFrame;

    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.y = CGRectGetMaxY(self.imageView.frame) + 10.0;
    titleFrame.origin.x = -CGRectGetWidth(self.frame)/2;
    titleFrame.size.width = CGRectGetWidth(self.frame) * 2;
    self.titleLabel.frame = titleFrame;
}

- (void)setActive:(BOOL)active
{
    self.alpha = active ? 1.0 : 0.5;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.imageView.tintColor = [UIColor menuButtonSelectedColor];
        [self setTitleColor:[UIColor menuButtonSelectedColor] forState:UIControlStateHighlighted];
    } else {
        self.imageView.tintColor = [UIColor menuButtonDeselectedColor];
        [self setTitleColor:[UIColor menuButtonDeselectedColor] forState:UIControlStateNormal];
    }
}

- (void)updateConstraints
{
    if (self.badgeView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.badgeView attribute:NSLayoutAttributeRight multiplier:1.0 constant:18]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.badgeView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-1.0]];
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
