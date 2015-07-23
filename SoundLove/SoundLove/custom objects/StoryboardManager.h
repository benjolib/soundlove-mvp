//
//  StoryboardManager.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverlayViewController, MenuViewController;

@interface StoryboardManager : NSObject

+ (OverlayViewController*)overlayViewController;
+ (MenuViewController*)menuViewController;

+ (UINavigationController*)infoNavigationController;

@end
