//
//  FestivalDetailViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "ConcertDetailViewController.h"
#import "ConcertModel.h"
#import "UIColor+GlobalColors.h"
#import "ConcertDetailInfoViewController.h"
#import "ConcertFriendsViewController.h"
#import "ConcertDetailLocationViewController.h"
#import "TabbingButton.h"
#import "StoryboardManager.h"
#import "ConcertDetailBaseViewController.h"
#import "CustomNavigationView.h"
#import "TicketShopDetailViewController.h"
//#import "UIFont+LatoFonts.h"
//#import "TrackingManager.h"

@interface ConcertDetailViewController ()
@property (nonatomic, strong) ConcertDetailBaseViewController *displayViewController;
@end

@implementation ConcertDetailViewController

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)infoButtonPressed:(id)sender
{
    if ([self.displayViewController isKindOfClass:[ConcertDetailInfoViewController class]]) {
        return;
    } else {
        ConcertDetailInfoViewController *concertInfoController = [StoryboardManager concertDetailInfoViewController];
        concertInfoController.concertToDisplay = self.concertToDisplay;
        [self switchCurrentViewControllerTo:concertInfoController];
    }

    [self.concertButton setButtonActive:YES];
    [self.locationButton setButtonActive:NO];
    [self.friendsButton setButtonActive:NO];
}

- (IBAction)locationButtonPressed:(id)sender
{
    if ([self.displayViewController isKindOfClass:[ConcertDetailLocationViewController class]]) {
        return;
    } else {
        ConcertDetailLocationViewController *concertLocationController = [StoryboardManager concertDetailLocationViewController];
        concertLocationController.concertToDisplay = self.concertToDisplay;
        [self switchCurrentViewControllerTo:concertLocationController];
    }

    [self.concertButton setButtonActive:NO];
    [self.locationButton setButtonActive:YES];
    [self.friendsButton setButtonActive:NO];
}

- (IBAction)friendsButtonPressed:(id)sender
{
    if ([self.displayViewController isKindOfClass:[ConcertFriendsViewController class]]) {
        return;
    } else {
        ConcertFriendsViewController *friendsViewController = [StoryboardManager concertDetailFriendsViewController];
        friendsViewController.concertToDisplay = self.concertToDisplay;
        [self switchCurrentViewControllerTo:friendsViewController];
    }

    [self.concertButton setButtonActive:NO];
    [self.locationButton setButtonActive:NO];
    [self.friendsButton setButtonActive:YES];
}

- (void)switchCurrentViewControllerTo:(ConcertDetailBaseViewController*)toViewController
{
    [self addChildViewController:toViewController];

    [self transitionFromViewController:self.displayViewController
                      toViewController:toViewController
                              duration:0.0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                toViewController.view.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
                            }
                            completion:^(BOOL finished) {
                                [self.displayViewController willMoveToParentViewController:nil];
                                [self.displayViewController removeFromParentViewController];

                                [toViewController didMoveToParentViewController:self];
                                self.displayViewController = toViewController;
                            }];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationView.titleLabel.text = self.concertToDisplay.name;

    [self.navigationView setShadowActive:YES];

    [self.friendsButton showBadgeWithValue:self.concertToDisplay.friendsArray.count];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openInfoView"])
    {
        self.displayViewController = segue.destinationViewController;
        if ([self.displayViewController isKindOfClass:[ConcertDetailInfoViewController class]])
        {
            ConcertDetailInfoViewController *infoViewController = (ConcertDetailInfoViewController*)self.displayViewController;
            infoViewController.concertToDisplay = self.concertToDisplay;

            [self.concertButton setButtonActive:YES];
            [self.locationButton setButtonActive:NO];
            [self.friendsButton setButtonActive:NO];
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc
{
    self.displayViewController = nil;
    self.concertToDisplay = nil;
}

@end
