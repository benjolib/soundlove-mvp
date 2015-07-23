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

@end
