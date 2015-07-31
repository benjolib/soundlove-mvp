//
//  FilterTableViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterTableViewCell.h"
#import "UIFont+LatoFonts.h"

@implementation FilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont latoRegularFontWithSize:16];
    self.nameLabel.font = [UIFont latoRegularFontWithSize:16];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.imageView.image)
    {
        CGSize iconSize = self.imageView.image.size;

        CGRect iconFrame = self.imageView.frame;
        iconFrame.size.width = 24.0;
        iconFrame.size.height = 24.0;
        iconFrame.origin.x = 15.0;
        iconFrame.origin.y = (CGRectGetHeight(self.frame) - iconSize.height)/2 + 3;
        self.imageView.frame = iconFrame;

        self.imageView.layer.cornerRadius = CGRectGetHeight(self.imageView.frame)/2;
        self.imageView.clipsToBounds = YES;
        
        CGRect labelFrame = self.textLabel.frame;
        labelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 15.0;
        self.textLabel.frame = labelFrame;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
