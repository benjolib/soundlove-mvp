//
//  CustomNavigationView.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 25/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "CustomNavigationView.h"
#import "UIColor+GlobalColors.h"

@implementation CustomNavigationView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textColor = [UIColor globalGreenColor];
    self.backgroundColor = [UIColor navigationBarBackgroundColor];
}

- (void)setTitle:(NSString*)title
{
    self.titleLabel.text = title;
}

- (void)setButtonTarget:(id)target selector:(SEL)selector
{
    [self.backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
