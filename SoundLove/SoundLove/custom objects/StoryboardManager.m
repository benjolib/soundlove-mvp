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
    return (OverlayViewController*)[[self mainStoryboard] instantiateViewControllerWithIdentifier:@"OverlayViewController"];
}

+ (MenuViewController*)menuViewController
{
    return (MenuViewController*)[[self mainStoryboard] instantiateViewControllerWithIdentifier:@"MenuViewController"];
}

+ (UINavigationController*)infoNavigationController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"infoNavigationID"];
}

+ (ConcertsViewController*)concertsViewController
{
    return (ConcertsViewController*)[[self mainStoryboard] instantiateViewControllerWithIdentifier:@"ConcertsViewController"];
}

+ (FavoriteConcertViewController*)favoriteConcertViewController
{
    return (FavoriteConcertViewController*)[[self mainStoryboard] instantiateViewControllerWithIdentifier:@"FavoriteConcertViewController"];
}

+ (CalendarViewController*)calendarViewController
{
    return (CalendarViewController*)[[self mainStoryboard] instantiateViewControllerWithIdentifier:@"CalendarViewController"];
}

+ (KunstlerViewController*)bandsViewController
{
    return (KunstlerViewController*)[[self mainStoryboard] instantiateViewControllerWithIdentifier:@"BandsViewController"];
}

#pragma mark - filter views
+ (FilterNavigationController*)filterNavigationController
{
    return (FilterNavigationController*)[[self filterStoryboard] instantiateViewControllerWithIdentifier:@"FilterNavigationController"];
}

+ (SortingViewController*)sortingViewController
{
    return (SortingViewController*)[[self filterStoryboard] instantiateViewControllerWithIdentifier:@"SortingViewController"];
}

#pragma mark - concert detail views
+ (ConcertDetailLocationViewController*)concertDetailLocationViewController
{
    return (ConcertDetailLocationViewController*)[[self mainStoryboard] instantiateViewControllerWithIdentifier:@"ConcertDetailLocationViewController"];
}

+ (ConcertFriendsViewController*)concertDetailFriendsViewController
{
    return (ConcertFriendsViewController*)[[self mainStoryboard] instantiateViewControllerWithIdentifier:@"ConcertFriendsViewController"];
}

+ (ConcertDetailInfoViewController*)concertDetailInfoViewController
{
    return (ConcertDetailInfoViewController*)[[self mainStoryboard] instantiateViewControllerWithIdentifier:@"ConcertDetailInfoViewController"];
}

@end
