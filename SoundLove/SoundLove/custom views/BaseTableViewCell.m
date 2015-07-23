//
//  BaseTableViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()
@property (nonatomic, strong) CALayer *bottomBorderLayer;
@end

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];

    if (self.bottomBorderLayer.superlayer) {
        return;
    }

    CGFloat scaleOfMainScreen = [UIScreen mainScreen].scale;
    CGFloat alwaysOnePixelInPoints = 1.0 / scaleOfMainScreen;

    self.bottomBorderLayer = [CALayer layer];
    self.bottomBorderLayer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    self.bottomBorderLayer.frame = CGRectMake(0.0, CGRectGetHeight(self.frame)-alwaysOnePixelInPoints, CGRectGetWidth(self.frame), alwaysOnePixelInPoints);
    [self.layer addSublayer:self.bottomBorderLayer];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat scaleOfMainScreen = [UIScreen mainScreen].scale;
    CGFloat alwaysOnePixelInPoints = 1.0 / scaleOfMainScreen;
    self.bottomBorderLayer.frame = CGRectMake(0.0, CGRectGetHeight(self.frame)-alwaysOnePixelInPoints, CGRectGetWidth(self.frame), alwaysOnePixelInPoints);
}

@end
