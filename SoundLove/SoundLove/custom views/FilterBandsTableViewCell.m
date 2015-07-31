//
//  FilterBandsTableViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 03/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterBandsTableViewCell.h"
#import "UIFont+LatoFonts.h"

@implementation FilterBandsTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.bandDetailLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont latoRegularFontWithSize:16];
    self.nameLabel.font = [UIFont latoRegularFontWithSize:16];
}

@end
