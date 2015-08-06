//
//  FestivalDetailBaseViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 09/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FestivalModel.h"

@interface FestivalDetailBaseViewController : UIViewController

@property (nonatomic, weak) FestivalModel *festivalToDisplay;

- (void)refreshView;

@end
