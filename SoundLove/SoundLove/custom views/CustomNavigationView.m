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

    self.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.layer.shadowRadius = 2.0;
    self.layer.shadowOpacity = 1.0;
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
