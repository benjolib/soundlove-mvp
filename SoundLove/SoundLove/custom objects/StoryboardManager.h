//
//  StoryboardManager.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverlayViewController, MenuViewController;
@class ConcertsViewController, FavoriteConcertViewController, CalendarViewController, BandsViewController;
@class FilterNavigationController, SortingViewController;
@class ConcertDetailInfoViewController, ConcertDetailLocationViewController, ConcertFriendsViewController;


@interface StoryboardManager : NSObject

+ (UINavigationController*)mainNavigationController;

+ (OverlayViewController*)overlayViewController;
+ (MenuViewController*)menuViewController;

+ (UINavigationController*)infoNavigationController;

+ (ConcertsViewController*)concertsViewController;
+ (FavoriteConcertViewController*)favoriteConcertViewController;
+ (CalendarViewController*)calendarViewController;
+ (BandsViewController*)bandsViewController;
+ (FilterNavigationController*)filterNavigationController;
+ (SortingViewController*)sortingViewController;

+ (ConcertDetailLocationViewController*)concertDetailLocationViewController;
+ (ConcertFriendsViewController*)concertDetailFriendsViewController;
+ (ConcertDetailInfoViewController*)concertDetailInfoViewController;

@end
