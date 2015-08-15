//
//  SortingButton.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 15/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "SortingButton.h"
#import "UIColor+GlobalColors.h"

@implementation SortingButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];
    self.imageView.tintColor = [UIColor globalGreenColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect labelFrame = self.titleLabel.frame;
    labelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 10.0;
    self.titleLabel.frame = labelFrame;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.imageView.alpha = 0.5;
        self.titleLabel.alpha = 0.5;
    } else {
        self.imageView.alpha = 1.0;
        self.titleLabel.alpha = 1.0;
    }
}

@end
