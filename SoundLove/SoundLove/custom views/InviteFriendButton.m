//
//  InviteFriendButton.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 05/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "InviteFriendButton.h"
#import "UIColor+GlobalColors.h"

@implementation InviteFriendButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];

    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor globalGreenColor].CGColor;

    [self setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor globalGreenColorWithAlpha:0.6] forState:UIControlStateHighlighted];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.titleLabel sizeToFit];
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = CGRectGetWidth(self.frame)/2 - CGRectGetWidth(titleFrame)/2 + 15.0;
    self.titleLabel.frame = titleFrame;


    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.size.height = 30.0;
    imageViewFrame.size.width = 30.0;
    imageViewFrame.origin.x = CGRectGetMinX(self.titleLabel.frame) - 40.0;
    imageViewFrame.origin.y = CGRectGetHeight(self.frame)/2 - 15.0;
    self.imageView.frame = imageViewFrame;
}

@end
