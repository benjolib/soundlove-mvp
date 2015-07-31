//
//  OnboardingViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 28/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "OnboardingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FacebookButton.h"
#import "FacebookManager.h"

@interface OnboardingViewController ()
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) FacebookManager *facebookManager;
@end

@implementation OnboardingViewController

- (IBAction)unwindToOnboardingView:(UIStoryboardSegue*)segue
{
    
}

- (IBAction)questionButtonPressed:(id)sender
{

}

- (IBAction)facebookButtonPressed:(id)sender
{
    __weak typeof(self) weakSelf = self;
    self.facebookManager = [[FacebookManager alloc] init];
    [self.facebookManager loginUserToFacebookWithCompletion:^(BOOL completed, NSString *errorMessage) {
        if (completed) {
            [weakSelf userLoggedIn];
        } else {
            UIAlertView *someAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:errorMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [someAlert show];
        }
    }];
}

- (void)userLoggedIn
{
    [self performSegueWithIdentifier:@"userLoggedIn" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addVideoBackgroundLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _playerLayer = nil;
}

#pragma mark - background video methods
- (AVPlayerLayer*)playerLayer
{
    if (!_playerLayer) {
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"onboarding" ofType:@"mov"];
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
        AVPlayer *player = [[AVPlayer alloc] initWithURL:movieURL];
        player.rate = 0.6;
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        _playerLayer.frame = CGRectMake(-CGRectGetWidth(self.view.frame), -2.5*CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame) * 4, CGRectGetHeight(self.view.frame) * 6);
        [_playerLayer.player play];
        return _playerLayer;
    }
    return _playerLayer;
}

- (void)replayMovie:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addVideoBackgroundLayer
{
    [self.view.layer insertSublayer:self.playerLayer below:self.fadeView.layer];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replayMovie:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
