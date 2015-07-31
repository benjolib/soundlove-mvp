//
//  BandCollectionViewCell.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BandCollectionViewCell.h"
#import "UIColor+GlobalColors.h"

@implementation BandCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.nameLabel.textColor = [UIColor globalGreenColor];
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [UIColor colorWithR:24.0 G:28.0 B:39.0].CGColor;
    self.imageView.layer.cornerRadius = CGRectGetHeight(self.imageView.frame)/2;
}

@end
