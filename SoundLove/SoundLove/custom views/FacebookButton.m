//
//  FacebookButton.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 28/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FacebookButton.h"
#import "UIColor+GlobalColors.h"

@implementation FacebookButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 32.0;

    self.backgroundColor = [UIColor clearColor];

    self.layer.borderColor = [UIColor globalGreenColor].CGColor;
    self.layer.borderWidth = 1.0;
    [self setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor globalGreenColorWithAlpha:0.6] forState:UIControlStateNormal];
}

@end
