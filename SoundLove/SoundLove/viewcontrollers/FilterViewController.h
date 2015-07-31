//
//  FilterViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"
#import "LoadingTableView.h"

@class CustomNavigationView;

@interface FilterViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet CustomNavigationView *navigationView;
@property (nonatomic, weak) IBOutlet LoadingTableView *tableView;

@property (nonatomic, strong) NSArray *genresArray;
@property (nonatomic, strong) NSArray *allBandsArray;

- (void)adjustButtonToFilterModel;

@end
