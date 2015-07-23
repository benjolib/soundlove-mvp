//
//  OverlayViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 22/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "OverlayViewController.h"
#import "RoundedButton.h"
#import "UIColor+GlobalColors.h"

@interface OverlayViewController ()
@property (nonatomic) OverlayType overlayTypeToDisplay;
@end

@implementation OverlayViewController

- (instancetype)initWithOverlayType:(OverlayType)type
{
    self = [super init];
    if (self) {
        self.overlayTypeToDisplay = type;
    }
    return self;
}

- (IBAction)confirmButtonPressed:(RoundedButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadViewWithOverlayType:(OverlayType)type
{
    switch (type)
    {
        case OverlayTypeLocation:
            self.titleLabel.text = @"Wo bist du?";
            self.detailLabel.text = @"Bitte erlaube uns auf Deinen Ort zuzugreifen, damit wir Dir Konzerte in Deiner Nähe zeigen können";
            self.iconImageView.image = [UIImage imageNamed:@"Email icon"];
            [self.confirmButton setTitle:@"Erlauben" forState:UIControlStateNormal];
            break;
        case OverlayTypeMessage:
            self.titleLabel.text = @"Nachrichten";
            self.detailLabel.text = @"Wir benachrichtigen Dich, wenn Künstler denen Du folgst in Deine Stadt kommen. Kein Spaß zu Künstlern, die Dich nicht interessieren.";
            self.iconImageView.image = [UIImage imageNamed:@"location icon"];
            [self.confirmButton setTitle:@"Klar, warum nicht" forState:UIControlStateNormal];
            break;
        case OverlayTypeOnTrack:
            self.titleLabel.text = @"On Track";
            self.detailLabel.text = @"Sichere Dir die Möglichkeit an geschlossenen Vorverkaufs-Aktionen teilzunehmen.";
            self.iconImageView.image = [UIImage imageNamed:@"ontrack icon"];
            [self.confirmButton setTitle:@"Klar, warum nicht" forState:UIControlStateNormal];
            break;
        case OverlayTypeNoInternet:
            self.titleLabel.text = @"Sorry";
            self.detailLabel.text = @"Es scheint als hättest Du derzeit keine Verbindung zum Internet.";
            self.iconImageView.image = [UIImage imageNamed:@"wifi icon"];
            [self.confirmButton setTitle:@"Erneut versuchen" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customiseView];
    [self loadViewWithOverlayType:self.overlayTypeToDisplay];
}

- (void)customiseView
{
    self.titleLabel.textColor = [UIColor globalGreenColor];
    self.detailLabel.textColor = [UIColor globalGreenColor];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
