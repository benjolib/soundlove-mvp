//
//  PriceContainerView.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceContainerView : UIView

@property (nonatomic, readonly) BOOL isActive;

- (void)setValueText:(NSString*)text;
- (void)setActive:(BOOL)active;

@end
