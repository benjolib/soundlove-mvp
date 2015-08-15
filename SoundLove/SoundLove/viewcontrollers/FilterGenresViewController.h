//
//  FilterGenresViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterViewController.h"
#import "RGIndexView.h"

@interface FilterGenresViewController : FilterViewController <UITableViewDataSource, UITableViewDelegate, RGIndexViewDelegate>

// search views
@property (nonatomic, weak) IBOutlet UIView *searchWrapperView;
@property (nonatomic, weak) IBOutlet UITextField *searchField;
@property (nonatomic, weak) IBOutlet UIButton *searchCancelButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *searchCancelButtonWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *searchWrapperViewTrailingConstraint;
@property (nonatomic, strong) RGIndexView *indexView;

- (void)setupSearchView;
- (void)addIndexView;

@end
