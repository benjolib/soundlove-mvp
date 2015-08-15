//
//  FilterPreisViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"
#import "FilterViewController.h"

@class CustomNavigationView, PriceContainerView;

@interface FilterPreisViewController : FilterViewController

@property (nonatomic, weak) IBOutlet UIView *rangeControllerContainerView;
@property (nonatomic, weak) IBOutlet PriceContainerView *leftPriceView;
@property (nonatomic, weak) IBOutlet PriceContainerView *rightPriceView;

@property (nonatomic) CGFloat defaultMinValue;
@property (nonatomic) CGFloat defaultMaxValue;

@end
