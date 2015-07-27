//
//  ConcertsViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"

@class TabbingButton, LoadingTableView;

@interface ConcertsViewController : BaseGradientViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutletCollection(TabbingButton) NSArray *tabbuttonsArray;
@property (nonatomic, weak) IBOutlet LoadingTableView *tableView;

- (IBAction)tabbuttonSelected:(TabbingButton*)selectedButton;

@end
