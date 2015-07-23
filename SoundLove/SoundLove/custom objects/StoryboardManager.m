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

@end
