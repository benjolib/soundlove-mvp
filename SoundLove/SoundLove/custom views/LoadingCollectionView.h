//
//  LoadingCollectionView.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingCollectionView : UICollectionView

- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

- (void)showEmptySearchView;
- (void)showEmptyFilterView;
- (void)showEmptyCalendarView;
- (void)hideEmptyView;

@end
