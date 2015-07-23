//
//  MainContainerViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "MainContainerViewController.h"
#import "OverlayTransitionManager.h"
#import "OverlayTransitionManager.h"
#import "MenuViewController.h"
#import "BaseGradientViewController.h"
#import "StoryboardManager.h"
#import "ConcertsViewController.h"
#import "FavoriteConcertViewController.h"
#import "BandsViewController.h"
#import "ProfilViewController.h"
#import "CalendarViewController.h"

@interface MainContainerViewController ()
@property (nonatomic, strong) BaseGradientViewController *mainViewController;
@property (nonatomic, strong) OverlayTransitionManager *overlayTransitionManager;
@property (nonatomic) MenuItem currentMenuItem;
@end

@implementation MainContainerViewController

- (IBAction)showOverlay:(id)sender
{
    if (!self.overlayTransitionManager) {
        self.overlayTransitionManager = [[OverlayTransitionManager alloc] init];
    }
    [self.overlayTransitionManager presentOverlayViewWithType:OverlayTypeNoInternet onViewController:self];
}

- (IBAction)menuButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"presentMenuView" sender:nil];
}

- (void)setParentTitle:(NSString*)title
{
//    [self.searchView setTitle:title];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    if ([segueID isEqualToString:@"embedView"])
    {
        BaseGradientViewController *controller = (BaseGradientViewController*)[segue destinationViewController];
        self.mainViewController = controller;
//        self.searchView.delegate = self.mainViewController;
//        self.currentMenuItem = MenuItemFestivals;
//        [self setParentTitle:@"Festivals"];
    }
    else
    if ([segue.identifier isEqualToString:@"presentMenuView"])
    {
        MenuViewController *menuVC = (MenuViewController*)segue.destinationViewController;
        if (!self.overlayTransitionManager) {
            self.overlayTransitionManager = [[OverlayTransitionManager alloc] init];
        }
        menuVC.transitioningDelegate = self.overlayTransitionManager;
        [menuVC saveSourceViewController:self.mainViewController];
    }
}

- (void)changeToMenuItem:(MenuItem)menuItem
{
    // If current viewcontroller is the same we selected, just dismiss the menu view
    if (self.currentMenuItem == menuItem) {
        return;
    }

    switch (menuItem)
    {
        case MenuItemConcerts: {
            ConcertsViewController *concertsViewController = [StoryboardManager concertsViewController];
            [self startTransitionToViewController:concertsViewController];
            self.currentMenuItem = menuItem;
            [self setParentTitle:@"Konzerte"];
            break;
        }
        case MenuItemFavoriteConcerts: {
            FavoriteConcertViewController *favoriteConcertViewController = [StoryboardManager favoriteConcertViewController];
            [self startTransitionToViewController:favoriteConcertViewController];
            self.currentMenuItem = menuItem;
            [self setParentTitle:@"Beliebte Konzerte"];
            break;
        }
        case MenuItemCalendar: {
            CalendarViewController *calendarViewController = [StoryboardManager calendarViewController];
            [self startTransitionToViewController:calendarViewController];
            self.currentMenuItem = menuItem;
            [self setParentTitle:@"Kalender"];
            break;
        }
        case MenuItemBands: {
            BandsViewController *bandsViewController = [StoryboardManager bandsViewController];
            [self startTransitionToViewController:bandsViewController];
            self.currentMenuItem = menuItem;
            [self setParentTitle:@"Künstler"];
            break;
        }
        case MenuItemProfil: {
            ProfilViewController *profilViewController = [StoryboardManager profilViewController];
            [self startTransitionToViewController:profilViewController];
            self.currentMenuItem = menuItem;
            [self setParentTitle:@"Profil"];
            break;
        }
        default:
            break;
    }
}

- (void)startTransitionToViewController:(BaseGradientViewController*)toDisplayViewController
{
    [self addChildViewController:toDisplayViewController];

    [self transitionFromViewController:self.mainViewController
                      toViewController:toDisplayViewController
                              duration:0.0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                toDisplayViewController.view.frame = self.containerView.bounds;
                            }
                            completion:^(BOOL finished) {
                                [self.mainViewController willMoveToParentViewController:nil];
                                [self.mainViewController removeFromParentViewController];

                                [toDisplayViewController didMoveToParentViewController:self];
                                self.mainViewController = toDisplayViewController;
//                                self.searchView.delegate = self.mainViewController;
                            }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
