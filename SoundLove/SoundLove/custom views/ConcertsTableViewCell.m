//
//  ConcertsTableViewCell.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 25/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertsTableViewCell.h"
#import "UIColor+GlobalColors.h"

@interface ConcertsTableViewCell ()
@property (nonatomic, strong) CALayer *bottomBorderLayer;
@end

@implementation ConcertsTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.concertTitleLabel.textColor = [UIColor globalGreenColor];
    self.locationLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.dateLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.priceLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];

    self.backgroundColor = [UIColor tabbingButtonActiveColor];

    self.concertImageView.layer.borderWidth = 1.0;
    self.concertImageView.layer.borderColor = [UIColor colorWithR:24.0 G:28.0 B:39.0].CGColor;
    self.concertImageView.layer.cornerRadius = CGRectGetHeight(self.concertImageView.frame)/2;

    [self setup];
}

- (void)showSavedState:(BOOL)saved
{
    self.calendarButton.alpha = saved ? 1.0 : 0.4;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.concertImageView.image = nil;
}

- (void)setup
{
    if (self.bottomBorderLayer.superlayer) {
        return;
    }

    CGFloat scaleOfMainScreen = [UIScreen mainScreen].scale;
    CGFloat alwaysOnePixelInPoints = 1.0 / scaleOfMainScreen;

    self.bottomBorderLayer = [CALayer layer];
    self.bottomBorderLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.bottomBorderLayer.frame = CGRectMake(0.0, CGRectGetHeight(self.frame)-alwaysOnePixelInPoints, CGRectGetWidth(self.frame), alwaysOnePixelInPoints);
    [self.layer addSublayer:self.bottomBorderLayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat scaleOfMainScreen = [UIScreen mainScreen].scale;
    CGFloat alwaysOnePixelInPoints = 1.0 / scaleOfMainScreen;
    self.bottomBorderLayer.frame = CGRectMake(0.0, CGRectGetHeight(self.frame)-alwaysOnePixelInPoints, CGRectGetWidth(self.frame), alwaysOnePixelInPoints);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [[UIColor tabbingButtonActiveColor] colorWithAlphaComponent:0.4];
    } else {
        self.backgroundColor = [UIColor tabbingButtonActiveColor];
    }
}

@end
