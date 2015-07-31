//
//  OnboardingViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 28/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FacebookButton;

@interface OnboardingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet FacebookButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *questionButton;
@property (weak, nonatomic) IBOutlet UIView *fadeView;

- (IBAction)unwindToOnboardingView:(UIStoryboardSegue*)segue;

- (IBAction)questionButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;

@end
