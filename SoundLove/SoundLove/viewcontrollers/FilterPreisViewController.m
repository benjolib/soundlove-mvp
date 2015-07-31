//
//  FilterPreisViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FilterPreisViewController.h"
#import "CustomNavigationView.h"
#import "UIColor+GlobalColors.h"
#import "MARKRangeSlider.h"
#import "PriceContainerView.h"

@interface FilterPreisViewController ()
@property (nonatomic, strong) MARKRangeSlider *rangeSlider;
@end

@implementation FilterPreisViewController

- (IBAction)closeButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)trashButtonPressed:(UIButton*)button
{
    [self.leftPriceView setActive:NO];
    [self.rightPriceView setActive:NO];

    self.rangeSlider.leftValue = 0.2;
    self.rangeSlider.rightValue = 1.0;
    self.defaultMinValue = 20;
    self.defaultMaxValue = 100;
    [self updateRangeText];

    button.alpha = 0.4;
    button.enabled = NO;
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupView];
}

- (void)setupView
{
    self.defaultMinValue = 20;
    self.defaultMaxValue = 100;
    [self.leftPriceView setActive:NO];
    [self.rightPriceView setActive:NO];

    self.rangeSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectZero];
    self.rangeSlider.backgroundColor = [UIColor clearColor];
    [self.rangeSlider addTarget:self
                         action:@selector(rangeSliderValueDidChange:)
               forControlEvents:UIControlEventValueChanged];
    self.rangeSlider.minimumValue = 0.0;
    self.rangeSlider.maximumValue = 1.0;
    self.rangeSlider.leftValue = 0.2; // Default: 20 €
    self.rangeSlider.rightValue = 1.0; // Default: 100 €
    self.rangeSlider.minimumDistance = 0.1;

    [self updateRangeText];

    [self.rangeControllerContainerView addSubview:self.rangeSlider];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.rangeSlider.frame = CGRectMake(0, 50.0, CGRectGetWidth(self.rangeControllerContainerView.frame), 40.0);
}

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider
{
    [self updateRangeText];
}

- (void)updateRangeText
{
    NSLog(@"%0.2f - %0.2f", self.rangeSlider.leftValue, self.rangeSlider.rightValue);

    CGFloat newLeftValue = self.rangeSlider.leftValue * 100;
    CGFloat newRightValue = self.rangeSlider.rightValue * 100;

    if (self.defaultMinValue != newLeftValue) {
        self.defaultMinValue = newLeftValue;
        [self.leftPriceView setActive:YES];
    }

    if (self.defaultMaxValue != newRightValue) {
        self.defaultMaxValue = newRightValue;
        [self.rightPriceView setActive:YES];
    }

    [self.leftPriceView setValueText:[NSString stringWithFormat:@"%.2f €", newLeftValue]];
    [self.rightPriceView setValueText:[NSString stringWithFormat:@"%.2f €", newRightValue]];

    self.trashButton.alpha = 1.0;
    self.trashButton.enabled = YES;
}

@end
