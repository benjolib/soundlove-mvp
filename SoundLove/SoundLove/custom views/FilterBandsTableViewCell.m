//
//  FilterBandsTableViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 03/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterBandsTableViewCell.h"
#import "UIColor+GlobalColors.h"

@implementation FilterBandsTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.bandDetailLabel.textColor = [UIColor globalGreenColor];
//    self.textLabel.font = [UIFont latoRegularFontWithSize:16];
//    self.nameLabel.font = [UIFont latoRegularFontWithSize:16];
}

@end
