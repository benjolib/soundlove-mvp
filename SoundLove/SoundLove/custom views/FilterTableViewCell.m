//
//  FilterTableViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterTableViewCell.h"
#import "UIColor+GlobalColors.h"

@implementation FilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textColor = [UIColor whiteColor];
//    self.textLabel.font = [UIFont latoRegularFontWithSize:16];
//    self.nameLabel.font = [UIFont latoRegularFontWithSize:16];
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

- (void)setCellActive:(BOOL)active
{
    if (active) {
        self.nameLabel.textColor = [UIColor globalGreenColor];
    } else {
        self.nameLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
}

@end
