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
    self.artistImageView.layer.borderWidth = 1.0;
    self.artistImageView.layer.borderColor = [UIColor colorWithR:24.0 G:28.0 B:39.0].CGColor;
    self.artistImageView.layer.cornerRadius = CGRectGetHeight(self.artistImageView.frame)/2;
}

@end
