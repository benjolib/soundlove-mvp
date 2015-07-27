//
//  SearchEmptyView.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 14/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchEmptyView : UIView

- (void)setText:(NSString*)text;

- (void)showEmptySearch;
- (void)showEmptyFilter;
- (void)showEmptyCalendarView;

+ (CGFloat)viewHeight;

@end
