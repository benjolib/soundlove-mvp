//
//  PriceContainerView.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "PriceContainerView.h"
#import "UIColor+GlobalColors.h"

@interface PriceContainerView ()
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic) BOOL isActive;
@end

@implementation PriceContainerView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithR:39.0 G:48.0 B:62.0].CGColor;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setupLabel
{
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.textColor = [UIColor colorWithR:75.0 G:80. B:90.0];
    self.valueLabel.font = [UIFont fontWithName:@"Montserrat" size:15.0];
    self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.valueLabel];
}

- (void)updateConstraints
{
    [super updateConstraints];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.valueLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.valueLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.valueLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.valueLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
}

- (BOOL)isActive
{
    return _isActive;
}

#pragma mark - setting methods
- (void)setActive:(BOOL)active
{
    if (active) {
        self.valueLabel.textColor = [UIColor globalGreenColor];
        self.backgroundColor = [UIColor colorWithR:24.0 G:30.0 B:39.0];
    } else {
        self.valueLabel.textColor = [UIColor colorWithR:75.0 G:80. B:90.0];
        self.layer.borderColor = [UIColor colorWithR:39.0 G:48.0 B:62.0].CGColor;
        self.backgroundColor = [UIColor clearColor];
    }
    
    self.isActive = active;
}

- (void)setValueText:(NSString*)text
{
    self.valueLabel.text = text;
}

@end
