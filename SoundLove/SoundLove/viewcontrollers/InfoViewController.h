//
//  InfoViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 05/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"

@class CustomNavigationView;

@interface InfoViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet CustomNavigationView *customNavigationView;
@property (nonatomic, weak) IBOutlet UILabel *versionNumberLabel;

@end
