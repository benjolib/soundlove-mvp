//
//  RoundedButton.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 22/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "RoundedButton.h"
#import "UIColor+GlobalColors.h"

@implementation RoundedButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupButton];
}

- (void)setupButton
{
    self.layer.cornerRadius = 30;
    self.backgroundColor = [UIColor globalGreenColor];
    [self setTitleColor:[UIColor darkGreenButtonTitleColor] forState:UIControlStateNormal];
    [self setTitleColor:[[UIColor darkGreenButtonTitleColor] colorWithAlphaComponent:0.4]
               forState:UIControlStateHighlighted];

    self.layer.borderWidth = 0.0;
}

@end
