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

@interface MainContainerViewController ()
@property (nonatomic, strong) BaseGradientViewController *mainViewController;
@property (nonatomic, strong) OverlayTransitionManager *overlayTransitionManager;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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

@end
