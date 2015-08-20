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
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(overlayViewControllerConfirmButtonPressed)]) {
            [self.delegate overlayViewControllerConfirmButtonPressed];
        }
    }];
}

- (IBAction)cancelButtonPressed:(RoundedButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(overlayViewControllerCancelButtonPressed)]) {
            [self.delegate overlayViewControllerCancelButtonPressed];
        }
    }];
}

- (void)loadViewWithOverlayType:(OverlayType)type
{
    if (type != OverlayTypeAppStore) {
        [self setCancelButtonHidden:YES];
    } else {
        [self setCancelButtonHidden:NO];
    }

    switch (type)
    {
        case OverlayTypeLocation:
            self.titleLabel.text = @"Wo bist du?";
            self.detailLabel.text = @"Bitte erlaube uns auf Deinen Ort zuzugreifen, damit wir Dir Konzerte in Deiner Nähe zeigen können";
            self.iconImageView.image = [UIImage imageNamed:@"location pin"];
            [self.confirmButton setTitle:@"Erlauben" forState:UIControlStateNormal];
            break;
        case OverlayTypeMessage:
            self.titleLabel.text = @"Nachrichten";
            self.detailLabel.text = @"Wir benachrichtigen Dich, wenn Künstler denen Du folgst in Deine Stadt kommen. Kein Spaß zu Künstlern, die Dich nicht interessieren.";
            self.iconImageView.image = [UIImage imageNamed:@"Email icon"];
            [self.confirmButton setTitle:@"Klar, warum nicht" forState:UIControlStateNormal];
            break;
        case OverlayTypeOnTrack:
            self.titleLabel.text = @"On Track";
            self.detailLabel.text = @"Sichere Dir die Möglichkeit an geschlossenen Vorverkaufs-Aktionen teilzunehmen.";
            self.iconImageView.image = [UIImage imageNamed:@"ontrack icon"];
            [self.confirmButton setTitle:@"Klar, warum nicht" forState:UIControlStateNormal];
            break;
        case OverlayTypeRSVP:
            self.titleLabel.text = @"R.S.V.P";
            self.detailLabel.text = @"Teile uns mit wie viele Tickets Du benötigst und wir schicken Dir das Angebot mit dem besten Preis innerhalb weniger Stunden per E-Mail";
            self.iconImageView.image = [UIImage imageNamed:@"rsvp"];
            [self.confirmButton setTitle:@"Ok" forState:UIControlStateNormal];
            break;
        case OverlayTypeTicket24:
            self.titleLabel.text = @"Unser Versprechen";
            self.detailLabel.text = @"Wir haben Deine Anfrage erhalten und Du erhältst innerhalb von 24 Stunden ein Angebot mit dem besten Preis per E-Mail";
            self.iconImageView.image = [UIImage imageNamed:@"ticket24Icon"];
            [self.confirmButton setTitle:@"Ok" forState:UIControlStateNormal];
            break;
        case OverlayTypeNoInternet:
            self.titleLabel.text = @"Sorry";
            self.detailLabel.text = @"Es scheint als hättest Du derzeit keine Verbindung zum Internet.";
            self.iconImageView.image = [UIImage imageNamed:@"wifi icon"];
            [self.confirmButton setTitle:@"Erneut versuchen" forState:UIControlStateNormal];
            break;
        case OverlayTypeFacebook:
            self.titleLabel.text = @"Warum uberhaupt Facebook?";
            self.detailLabel.text = @"Ihre Anmeldung über Facebook ermöglicht uns, Ihnen persönliche Empfehlungen zu geben. Selbstverständlich werden keine Inhalte in Ihrem Namen gepostet werden, denn Ihre Privatsphäre ist uns sehr wichtig.";
            self.iconImageView.image = [UIImage imageNamed:@"facebookIcon"];
            [self.confirmButton setTitle:@"Anmelden mit Facebook" forState:UIControlStateNormal];
            break;
        case OverlayTypeAppStore:
            self.cancelButton.backgroundColor = [UIColor clearColor];
            [self.cancelButton setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];
            [self.cancelButton setTitleColor:[UIColor globalGreenColorWithAlpha:0.4] forState:UIControlStateHighlighted];
            self.cancelButton.layer.borderWidth = 1.0;
            self.cancelButton.layer.borderColor = [UIColor globalGreenColorWithAlpha:0.4].CGColor;

            self.titleLabel.text = @"Deine Ideen";
            self.detailLabel.text = @"Hast Du Ideen was man an der App verbessern könnte? Wir würden sie gerne hören. Über den App Store kannst Du uns Deinen Kommentar hinterlassen.";
            self.iconImageView.image = [UIImage imageNamed:@"starIcon"];
            [self.confirmButton setTitle:@"Klar, warum nicht" forState:UIControlStateNormal];
            [self.cancelButton setTitle:@"Vielleicht später" forState:UIControlStateNormal];
        default:
            break;
    }
}

- (void)setCancelButtonHidden:(BOOL)hidden
{
    self.cancelButtonHeightConstraint.constant = hidden ? 0.0 : 50.0;
    [self.view layoutIfNeeded];
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
