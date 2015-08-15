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
    self.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    self.nameLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.2];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [[UIColor tabbingButtonInactiveColor] colorWithAlphaComponent:0.6];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setCellActive:(BOOL)active
{
    if (active) {
        self.textLabel.textColor = [UIColor globalGreenColor];
        self.nameLabel.textColor = [UIColor globalGreenColor];
    } else {
        self.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        self.nameLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    }
}

@end
