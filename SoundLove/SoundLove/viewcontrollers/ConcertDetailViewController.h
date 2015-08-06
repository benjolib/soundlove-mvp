//
//  FestivalDetailViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"

@class GreenButton, ConcertModel, TabbingButton, CustomNavigationView;

@interface ConcertDetailViewController : BaseGradientViewController

@property (nonatomic, strong) ConcertModel *concertToDisplay;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet CustomNavigationView *navigationView;
@property (nonatomic, weak) IBOutlet TabbingButton *concertButton;
@property (nonatomic, weak) IBOutlet TabbingButton *locationButton;
@property (nonatomic, weak) IBOutlet TabbingButton *friendsButton;

- (IBAction)backButtonPressed:(id)sender;

@end
