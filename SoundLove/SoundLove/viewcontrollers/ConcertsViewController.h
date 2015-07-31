//
//  ConcertsViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ImageDownloadBaseViewController.h"
#import "FilterModel.h"

@class TabbingButton, LoadingTableView;

@interface ConcertsViewController : ImageDownloadBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutletCollection(TabbingButton) NSArray *tabbuttonsArray;
@property (nonatomic, weak) IBOutlet UIView *filterSortView;
@property (nonatomic, weak) IBOutlet UIButton *filterButton;
@property (nonatomic, weak) IBOutlet UIButton *sortButton;
@property (nonatomic, strong) FilterModel *filterModel;

- (IBAction)tabbuttonSelected:(TabbingButton*)selectedButton;

- (IBAction)filterButtonPressed:(id)sender;
- (IBAction)sortingButtonPressed:(id)sender;

@end
