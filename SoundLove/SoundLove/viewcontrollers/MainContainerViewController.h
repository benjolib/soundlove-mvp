//
//  MainContainerViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MenuItem) {
    MenuItemConcerts,
    MenuItemFavoriteConcerts,
    MenuItemCalendar,
    MenuItemBands,
    MenuItemProfil
};

@interface MainContainerViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIView *navigationView;

- (void)changeToMenuItem:(MenuItem)menuItem;

- (void)setParentTitle:(NSString*)title;

@end
