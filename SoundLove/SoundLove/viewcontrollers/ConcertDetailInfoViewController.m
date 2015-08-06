//
//  FestivalDetailInfoViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "ConcertDetailInfoViewController.h"
#import "ConcertModel.h"
#import "UIImage+ImageEffects.h"
#import "ImageDownloader.h"
#import "UIColor+GlobalColors.h"

@interface ConcertDetailInfoViewController ()
@property (nonatomic, strong) ImageDownloader *imageDownloader;
@end

@implementation ConcertDetailInfoViewController

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.imageWrapperView.backgroundColor = [UIColor clearColor];
    self.concertNameLabel.textColor = [UIColor globalGreenColor];

    self.concertTimeTitleLabel.textColor = [UIColor globalGreenColor];
    self.concertLocationTitleLabel.textColor = [UIColor globalGreenColor];
    self.concertCostsTitleLabel.textColor = [UIColor globalGreenColor];

    self.concertTimeLabel.textColor = [UIColor colorWithR:139.0 G:146.0 B:148.0];
    self.concertLocationLabel.textColor = [UIColor colorWithR:139.0 G:146.0 B:148.0];
    self.concertCostsLabel.textColor = [UIColor colorWithR:139.0 G:146.0 B:148.0];

    [self refreshView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.concertImageView.layer.cornerRadius = CGRectGetHeight(self.concertImageView.frame)/2;
}

- (void)refreshView
{
    [super refreshView];

    self.concertNameLabel.text = self.concertToDisplay.name;
    self.concertLocationLabel.text = self.concertToDisplay.place;
    self.concertCostsLabel.text = [self.concertToDisplay priceString];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd.MM.YYYY";

    self.concertTimeLabel.text = [NSString stringWithFormat:@"%@\n%@", [dateFormatter stringFromDate:self.concertToDisplay.date], [self.concertToDisplay calendarDaysTillStartDateString]];

    if (self.concertToDisplay.image || self.concertToDisplay.imageURL) {
        [self blurConcertImage];
    } else {
        [self hideImageWrapperView];

        if (self.concertToDisplay.imageURL) {
            [self downloadImageForConcert];
        }
    }
}

- (void)blurConcertImage
{
    self.concertImageView.image = self.concertToDisplay.image;
    self.blurredImageView.image = [self.concertToDisplay.image applyDarkEffect];
}

- (void)hideImageWrapperView
{
    if (self.imageWrapperViewHeightConstraint.constant != 0.0) {
        self.imageWrapperViewHeightConstraint.constant = 0.0;
        [self.view layoutIfNeeded];
    }
}

- (void)showImageWrapperView
{
    self.imageWrapperViewHeightConstraint.constant = 200.0;

    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)downloadImageForConcert
{
    self.imageDownloader = [[ImageDownloader alloc] init];
    [self.imageDownloader startDownloadingImage:self.concertToDisplay.imageURL completionBlock:^(UIImage *image) {
        if (image) {
            self.concertToDisplay.image = image;
            [self blurConcertImage];
            [self showImageWrapperView];
        } else {
            [self hideImageWrapperView];
        }
    }];
}

@end
