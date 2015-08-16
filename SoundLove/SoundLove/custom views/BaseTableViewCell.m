//
//  BaseTableViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UIColor+GlobalColors.h"

@interface BaseTableViewCell ()
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
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [[UIColor tabbingButtonInactiveColor] colorWithAlphaComponent:0.6];
    } else {
        self.backgroundColor = [UIColor tabbingButtonActiveColor];
    }
}

@end
