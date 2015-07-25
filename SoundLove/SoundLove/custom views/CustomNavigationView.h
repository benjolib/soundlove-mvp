//
//  CustomNavigationView.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 25/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *backButton;

- (void)setTitle:(NSString*)title;
- (void)setButtonTarget:(id)target selector:(SEL)selector;

@end
