//
//  FestivalDetailInfoViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "ConcertDetailBaseViewController.h"

@interface ConcertDetailInfoViewController : ConcertDetailBaseViewController

@property (nonatomic, weak) IBOutlet UIView *imageWrapperView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageWrapperViewHeightConstraint;
@property (nonatomic, weak) IBOutlet UIImageView *blurredImageView;
@property (nonatomic, weak) IBOutlet UIImageView *concertImageView;
@property (nonatomic, weak) IBOutlet UILabel *concertNameLabel;

@property (nonatomic, weak) IBOutlet UIView *bottomDetailWrapperView;
@property (nonatomic, weak) IBOutlet UILabel *concertTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *concertLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *concertCostsLabel;

@property (nonatomic, weak) IBOutlet UILabel *concertTimeTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *concertLocationTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *concertCostsTitleLabel;

@end
