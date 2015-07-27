//
//  TicketShopDetailViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 10/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"

@class ConcertModel, RoundedButton, CustomNavigationView;

@interface TicketShopDetailViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet RoundedButton *sendButton;

@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet CustomNavigationView *navigationView;

@property (nonatomic, weak) ConcertModel *concertToDisplay;

- (IBAction)sendButtonTapped:(id)sender;

@end
