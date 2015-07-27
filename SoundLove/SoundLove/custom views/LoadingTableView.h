//
//  LoadingTableView.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 03/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingTableView : UITableView

- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

- (void)showEmptySearchView;
- (void)showEmptyFilterView;
- (void)showEmptyCalendarView;
- (void)hideEmptyView;

@end
