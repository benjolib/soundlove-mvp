//
//  MenuViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuButton;

@interface MenuViewController : UIViewController

@property (nonatomic, strong) IBOutletCollection(MenuButton) NSArray *menuButtonsArray;

@property (nonatomic, weak) IBOutlet MenuButton *concertButton;
@property (nonatomic, weak) IBOutlet MenuButton *calendarButton;
@property (nonatomic, weak) IBOutlet MenuButton *favoriteConcertButton;
@property (nonatomic, weak) IBOutlet MenuButton *bandsButton;
@property (nonatomic, weak) IBOutlet MenuButton *logoutButton;

@property (nonatomic, weak) IBOutlet UIButton *infoButton;

@property (nonatomic, weak) IBOutlet UILabel *versionNumberLabel;

- (void)saveSourceViewController:(UIViewController*)sourceViewController;

- (IBAction)menuButtonSelected:(MenuButton*)button;

@end
