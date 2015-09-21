//
//  OverlayViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 22/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoundedButton;

typedef NS_ENUM(NSUInteger, OverlayType) {
    OverlayTypeNoInternet,
    OverlayTypeOnTrack,
    OverlayTypeMessage,
    OverlayTypeRSVP,
    OverlayTypeTicket24,
    OverlayTypeLocation,
    OverlayTypeFacebook,
    OverlayTypeAppStore,
    OverlayTypeOnboardingFinished
};

@protocol OverlayViewControllerDelegate <NSObject>
- (void)overlayViewControllerConfirmButtonPressed;
@optional
- (void)overlayViewControllerCancelButtonPressed;
@end

@interface OverlayViewController : UIViewController

@property (weak, nonatomic) id <OverlayViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet RoundedButton *confirmButton;
@property (weak, nonatomic) IBOutlet RoundedButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonHeightConstraint;
@property (nonatomic) OverlayType overlayTypeToDisplay;

- (IBAction)confirmButtonPressed:(RoundedButton *)sender;
- (IBAction)cancelButtonPressed:(RoundedButton *)sender;

- (instancetype)initWithOverlayType:(OverlayType)type;

@end
