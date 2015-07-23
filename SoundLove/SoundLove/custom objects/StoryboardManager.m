//
//  StoryboardManager.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "StoryboardManager.h"
#import <UIKit/UIKit.h>

@implementation StoryboardManager

+ (UIStoryboard*)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (OverlayViewController*)overlayViewController
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:@"OverlayViewController"];
}

@end
