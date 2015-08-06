//
//  FestivalDetailBaseViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 09/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailBaseViewController.h"

@implementation FestivalDetailBaseViewController
@synthesize festivalToDisplay = _festivalToDisplay;

- (void)setFestivalToDisplay:(FestivalModel *)festivalToDisplay
{
    _festivalToDisplay = festivalToDisplay;
    [self refreshView];
}

- (void)refreshView
{

}

@end
