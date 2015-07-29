//
//  CalendarViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"

@class LoadingTableView, TabbingButton;

@interface CalendarViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet LoadingTableView *tableView;
@property (nonatomic, weak) IBOutlet TabbingButton *eventsButton;
@property (nonatomic, weak) IBOutlet TabbingButton *friendsButton;

@end
