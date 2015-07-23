//
//  BadgeCounterView.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BadgeCounterView.h"
#import "UIColor+GlobalColors.h"

@interface BadgeCounterView ()
@property (nonatomic, strong) UILabel *counterLabel;
@end

@implementation BadgeCounterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];

        self.backgroundColor = [UIColor menuButtonSelectedColor];
        self.layer.cornerRadius = CGRectGetHeight(frame)/2;
    }
    return self;
}

- (void)setupView
{
    self.counterLabel = [[UILabel alloc] init];
    self.counterLabel.textAlignment = NSTextAlignmentCenter;
    self.counterLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.counterLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14.0];
    self.counterLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.counterLabel];
}

- (void)updateConstraints
{
    [super updateConstraints];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.counterLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.counterLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.counterLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.counterLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
}

- (void)displayCounterValue:(NSInteger)counterValue
{
    self.counterLabel.text = [NSString stringWithFormat:@"%ld", (long)counterValue];
}

@end
