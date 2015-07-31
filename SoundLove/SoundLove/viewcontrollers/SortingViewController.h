//
//  SortingViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"

@class LoadingTableView, CustomNavigationView;

@interface SortingViewController : BaseGradientViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet LoadingTableView *tableView;
@property (nonatomic, weak) IBOutlet CustomNavigationView *navigationView;

@end
