//
//  StoryboardManager.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverlayViewController, MenuViewController;
@class ConcertsViewController, FavoriteConcertViewController, CalendarViewController, BandsViewController, ProfilViewController;
@class FilterNavigationController, SortingViewController;


@interface StoryboardManager : NSObject

+ (UINavigationController*)mainNavigationController;

+ (OverlayViewController*)overlayViewController;
+ (MenuViewController*)menuViewController;

+ (UINavigationController*)infoNavigationController;

+ (ConcertsViewController*)concertsViewController;
+ (FavoriteConcertViewController*)favoriteConcertViewController;
+ (CalendarViewController*)calendarViewController;
+ (BandsViewController*)bandsViewController;
+ (ProfilViewController*)profilViewController;
+ (FilterNavigationController*)filterNavigationController;
+ (SortingViewController*)sortingViewController;

@end
