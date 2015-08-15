//
//  SortingViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"
#import "SortingObject.h"

@class LoadingTableView, CustomNavigationView, SortingButton;

@interface SortingViewController : BaseGradientViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet LoadingTableView *tableView;
@property (nonatomic, weak) IBOutlet CustomNavigationView *navigationView;
@property (nonatomic, weak) IBOutlet SortingButton *sortingButton;
@property (nonatomic, strong) SortingObject *selectedSortingObject;


@end
