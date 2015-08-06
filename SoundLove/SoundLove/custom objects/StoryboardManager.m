//
//  StoryboardManager.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "StoryboardManager.h"

@implementation StoryboardManager

+ (UIStoryboard*)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard*)filterStoryboard
{
    return [UIStoryboard storyboardWithName:@"Filter" bundle:nil];
}

#pragma mark - viewControllers
+ (UINavigationController*)mainNavigationController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"mainNavigaitonView"];
}

+ (OverlayViewController*)overlayViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"OverlayViewController"];
}

+ (MenuViewController*)menuViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"MenuViewController"];
}

+ (UINavigationController*)infoNavigationController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"infoNavigationID"];
}

+ (ConcertsViewController*)concertsViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"ConcertsViewController"];
}

+ (FavoriteConcertViewController*)favoriteConcertViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"FavoriteConcertViewController"];
}

+ (CalendarViewController*)calendarViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"CalendarViewController"];
}

+ (BandsViewController*)bandsViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"BandsViewController"];
}

+ (ProfilViewController*)profilViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"ProfilViewController"];
}

#pragma mark - filter views
+ (FilterNavigationController*)filterNavigationController
{
    return [[self filterStoryboard] instantiateViewControllerWithIdentifier:@"FilterNavigationController"];
}

+ (SortingViewController*)sortingViewController
{
    return [[self filterStoryboard] instantiateViewControllerWithIdentifier:@"SortingViewController"];
}

#pragma mark - concert detail views
+ (ConcertDetailLocationViewController*)concertDetailLocationViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"ConcertDetailLocationViewController"];
}

+ (ConcertFriendsViewController*)concertDetailFriendsViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"ConcertFriendsViewController"];
}

+ (ConcertDetailInfoViewController*)concertDetailInfoViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"ConcertDetailInfoViewController"];
}

@end
