//
//  FestivalRefreshControl.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RefreshState) {
    RefreshStateNormal,
    RefreshStatePulling,
    RefreshStateLoading,
};

@interface ConcertRefreshControl : UIControl

@property (nonatomic) BOOL isLoading;

- (void)startRefreshing;
- (void)endRefreshing;

- (void)parentScrollViewDidEndDragging:(UIScrollView *)parentScrollView;
- (void)parentScrollViewDidScroll:(UIScrollView *)parentScrollView;

@end
