//
//  FestivalDetailInfoViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailInfoViewController.h"
#import "FestivalModel.h"
#import "UIFont+LatoFonts.h"

@implementation FestivalDetailInfoViewController

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor clearColor];

    [self refreshView];
    [self.scrollView flashScrollIndicators];
}

- (void)refreshView
{
    [super refreshView];
    [self displayFestivalInfo];
    [self adjustViewSizes];
}

- (void)displayFestivalInfo
{
    self.infoTextLabel.text = self.festivalToDisplay.festivalDescription;
    self.festivalTypeLabel.text = [self.festivalToDisplay category];
    self.festivalTimeLabel.text = [self.festivalToDisplay festivalInfoDateString];
    self.festivalLocationLabel.text = [self.festivalToDisplay infoLocationString];
    self.festivalCostsLabel.text = [self.festivalToDisplay admission];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.infoTextLabel.preferredMaxLayoutWidth = self.view.frame.size.width - 20.0;
    [self.view layoutIfNeeded];
}

- (void)adjustViewSizes
{
    if (!self.infoTextLabel) {
        return;
    }

    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.view.frame.size.height);
    [self.view setNeedsDisplay];
}

@end
