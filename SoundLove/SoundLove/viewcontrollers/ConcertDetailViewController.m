//
//  FestivalDetailViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 04/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailViewController.h"
#import "FestivalModel.h"
#import "UIColor+AppColors.h"
#import "FestivalDetailInfoViewController.h"
#import "FestivalDetailBandsViewController.h"
#import "FestivalDetailLocationViewController.h"
#import "GreenButton.h"
#import "StoryboardManager.h"
#import "FestivalDetailBaseViewController.h"
#import "InfoDetailSelectionButton.h"
#import "PopupView.h"
#import "TicketShopDetailViewController.h"
#import "UIFont+LatoFonts.h"
#import "TrackingManager.h"

@interface FestivalDetailViewController () <PopupViewDelegate>
@property (nonatomic, strong) FestivalDetailBaseViewController *displayViewController;
@property (nonatomic, strong) PopupView *activePopup;
@end

@implementation FestivalDetailViewController

- (IBAction)ticketShopButtonPressed:(id)sender
{
    [[TrackingManager sharedManager] trackUserSelectsTicketShop];
    [self showToTicketShopPopup];
}

- (IBAction)shareButtonPressed:(id)sender
{
    if (!self.festivalToDisplay.name) {
        return;
    }

    [[TrackingManager sharedManager] trackUserSelectsShareButton];
    NSString *stringToShare = [NSString stringWithFormat:@"Hab ein cooles Festival gefunden: %@. Die App findest Du übrigens unter www.FestivaLama.io", self.festivalToDisplay.name];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[stringToShare]
                                                                                         applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                     UIActivityTypePrint,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypePostToFlickr,
                                                     UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)infoButtonPressed:(id)sender
{
    if ([self.displayViewController isKindOfClass:[FestivalDetailInfoViewController class]]) {
        return;
    } else {
        FestivalDetailInfoViewController *festivalInfoController = [StoryboardManager festivalDetailInfoViewController];
        [self switchCurrentViewControllerTo:festivalInfoController];
        festivalInfoController.festivalToDisplay = self.festivalToDisplay;
    }

    [self.infoButton setButtonPosition:0 selectedPosition:0 active:YES];
    [self.bandsButton setButtonPosition:1 selectedPosition:0 active:NO];
    [self.locationButton setButtonPosition:2 selectedPosition:0 active:NO];
}

- (IBAction)bandsButtonPressed:(id)sender
{
    if ([self.displayViewController isKindOfClass:[FestivalDetailBandsViewController class]]) {
        return;
    } else {
        FestivalDetailBandsViewController *festivalBandsController = [StoryboardManager festivalDetailBandsViewController];
        [self switchCurrentViewControllerTo:festivalBandsController];
        festivalBandsController.festivalToDisplay = self.festivalToDisplay;
    }

    [self.infoButton setButtonPosition:0 selectedPosition:1 active:NO];
    [self.bandsButton setButtonPosition:1 selectedPosition:1 active:YES];
    [self.locationButton setButtonPosition:2 selectedPosition:1 active:NO];
}

- (IBAction)locationButtonPressed:(id)sender
{
    if ([self.displayViewController isKindOfClass:[FestivalDetailLocationViewController class]]) {
        return;
    } else {
        FestivalDetailLocationViewController *festivalLocationController = [StoryboardManager festivalDetailLocationViewController];
        [self switchCurrentViewControllerTo:festivalLocationController];
        festivalLocationController.festivalToDisplay = self.festivalToDisplay;
    }

    [self.infoButton setButtonPosition:0 selectedPosition:2 active:NO];
    [self.bandsButton setButtonPosition:1 selectedPosition:2 active:NO];
    [self.locationButton setButtonPosition:2 selectedPosition:2 active:YES];
}

- (void)switchCurrentViewControllerTo:(FestivalDetailBaseViewController*)toViewController
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

#pragma mark - popup handling
- (void)showToTicketShopPopup
{
    self.activePopup = [[PopupView alloc] initWithDelegate:self];
    [self.activePopup setupWithConfirmButtonTitle:@"OK"
                                cancelButtonTitle:nil
                                        viewTitle:@"R.S.V.P"
                                             text:@"Teile uns mit wie viele Tickets Du benötigtst und wir schicken Dir das Angebot mit dem besten Preis innerhalb weniger Stunden per E-Mail."
                                             icon:[UIImage imageNamed:@"iconShop"] showFestivalamaLogo:NO];
    [self.activePopup showPopupViewAnimationOnView:self.view withBlurredBackground:YES];
}

- (void)popupViewConfirmButtonPressed:(PopupView *)popupView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showTicketShopView" sender:nil];
    });
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.festivalToDisplay.name;

    self.titleLabel.font = [UIFont latoRegularFontWithSize:20.0];
    self.titleLabel.textColor = [UIColor globalGreenColor];
    self.titleLabel.text = self.festivalToDisplay.name;

    self.ticketShopButton.layer.cornerRadius = 30.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedInfoView"])
    {
        self.displayViewController = segue.destinationViewController;
        if ([self.displayViewController isKindOfClass:[FestivalDetailInfoViewController class]]) {
            FestivalDetailInfoViewController *infoViewController = (FestivalDetailInfoViewController*)self.displayViewController;
            infoViewController.festivalToDisplay = self.festivalToDisplay;

            [self.infoButton setButtonPosition:0 selectedPosition:0 active:YES];
            [self.bandsButton setButtonPosition:1 selectedPosition:0 active:NO];
            [self.locationButton setButtonPosition:2 selectedPosition:0 active:NO];
        }
    } else if ([segue.identifier isEqualToString:@"showTicketShopView"]) {
        TicketShopDetailViewController *ticketShop = (TicketShopDetailViewController*)segue.destinationViewController;
        ticketShop.festivalToDisplay = self.festivalToDisplay;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc
{
    self.displayViewController = nil;
    self.festivalToDisplay = nil;
    self.activePopup.delegate = nil;
    self.activePopup = nil;
}

@end
