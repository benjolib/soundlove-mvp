//
//  FavoriteConcertViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 20/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FavoriteConcertViewController.h"
#import "OverlayTransitionManager.h"

@interface FavoriteConcertViewController ()
@property (nonatomic, strong) OverlayTransitionManager *overlayTransitionManager;
@end

@implementation FavoriteConcertViewController

- (IBAction)showOverlay:(id)sender
{
    self.overlayTransitionManager = [[OverlayTransitionManager alloc] init];
    [self.overlayTransitionManager presentOverlayViewWithType:OverlayTypeNoInternet onViewController:self];
}

@end
