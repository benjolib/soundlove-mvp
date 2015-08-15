//
//  FilterViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"
#import "LoadingTableView.h"
#import "FilterModel.h"

@class CustomNavigationView;

@interface FilterViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet CustomNavigationView *navigationView;
@property (nonatomic, weak) IBOutlet LoadingTableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *trashButton;
@property (nonatomic, weak) IBOutlet UIView *filterButtonWrapperView;

@property (nonatomic, strong) FilterModel *filterModel;
@property (nonatomic, strong) NSArray *genresArray;
@property (nonatomic, strong) NSArray *allBandsArray;

- (void)adjustButtonToFilterModel;
- (void)setTrashIconVisible:(BOOL)visible;

@end
