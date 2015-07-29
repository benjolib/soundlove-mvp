//
//  BasicButton.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BasicButton.h"
#import "UIColor+GlobalColors.h"

@implementation BasicButton

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.imageView.alpha = 0.5;
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
    } else {
        self.imageView.alpha = 1.0;
        self.imageView.transform = CGAffineTransformIdentity;
    }
}

@end
