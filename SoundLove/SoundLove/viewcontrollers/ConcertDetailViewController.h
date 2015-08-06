//
//  FestivalDetailViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"

@class GreenButton, FestivalModel, InfoDetailSelectionButton;

@interface FestivalDetailViewController : BaseGradientViewController

@property (nonatomic, strong) FestivalModel *festivalToDisplay;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet GreenButton *ticketShopButton;
@property (nonatomic, weak) IBOutlet InfoDetailSelectionButton *infoButton;
@property (nonatomic, weak) IBOutlet InfoDetailSelectionButton *bandsButton;
@property (nonatomic, weak) IBOutlet InfoDetailSelectionButton *locationButton;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)ticketShopButtonPressed:(id)sender;

@end
