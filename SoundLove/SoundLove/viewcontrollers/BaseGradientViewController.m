//
//  BaseGradientViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"
#import "UIColor+GlobalColors.h"

@implementation BaseGradientViewController

//#pragma mark - searchnavigation view delegate methods
//- (void)searchNavigationViewSearchButtonPressed:(NSString *)searchText
//{
//
//}
//
//- (void)searchNavigationViewUserEnteredNewCharacter:(NSString *)searchText
//{
//
//}
//
//- (void)searchNavigationViewCancelButtonPressed
//{
//
//}
//
//- (void)searchNavigationViewMenuButtonPressed
//{
//
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self addGradientBackground];
}

- (void)addGradientBackground
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.frame;

    UIColor *topColor = [UIColor gradientTopColor];
    UIColor *bottomColor = [UIColor gradientBottomColor];

    gradientLayer.colors = @[(id)topColor.CGColor, (id)bottomColor.CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
