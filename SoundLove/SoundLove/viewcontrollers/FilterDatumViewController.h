//
//  FilterDatumViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 31/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"
#import "FilterViewController.h"

@class PriceContainerView, CustomNavigationView;

@interface FilterDatumViewController : FilterViewController

@property (nonatomic, weak) IBOutlet PriceContainerView *leftDatePickerView;
@property (nonatomic, weak) IBOutlet PriceContainerView *rightDatePickerView;
@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;

@end
