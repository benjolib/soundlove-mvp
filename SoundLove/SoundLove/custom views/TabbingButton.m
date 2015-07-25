//
//  TabbingButton.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 25/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "TabbingButton.h"
#import "UIColor+GlobalColors.h"

@implementation TabbingButton

- (void)setButtonActive:(BOOL)active
{
    if (active) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor tabbingButtonActiveColor];
    } else {
        [self setTitleColor:[UIColor colorWithR:128.0 G:128.0 B:128.0] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor tabbingButtonInactiveColor];
    }
}

@end
