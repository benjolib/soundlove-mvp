//
//  FilterButton.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FilterButton.h"
#import "UIColor+GlobalColors.h"

@implementation FilterButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];
    self.imageView.tintColor = [UIColor globalGreenColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = 10.0;
    self.imageView.frame = imageFrame;

    CGRect labelFrame = self.titleLabel.frame;
    labelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 10.0;
    self.titleLabel.frame = labelFrame;
}

- (void)setHighlighted:(BOOL)highlighted
{
//    if (highlighted) {
//        self.imageView.alpha = 0.5;
//        self.titleLabel.alpha = 0.5;
//    } else {
//        self.imageView.alpha = 1.0;
//        self.titleLabel.alpha = 1.0;
//    }
}

@end
