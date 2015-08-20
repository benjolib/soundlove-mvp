//
//  BaseTableViewCell.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UIColor+GlobalColors.h"

@implementation BaseTableViewCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [[UIColor tabbingButtonInactiveColor] colorWithAlphaComponent:0.6];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
