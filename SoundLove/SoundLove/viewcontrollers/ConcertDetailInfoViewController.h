//
//  FestivalDetailInfoViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailBaseViewController.h"

@interface FestivalDetailInfoViewController : FestivalDetailBaseViewController

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *infoTextLabelHeightConstraint;
@property (nonatomic, weak) IBOutlet UILabel *infoTextLabel;
@property (nonatomic, weak) IBOutlet UILabel *festivalTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *festivalTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *festivalLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *festivalCostsLabel;

@property (weak, nonatomic) IBOutlet UILabel *costTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeTitleLabel;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;

@end
