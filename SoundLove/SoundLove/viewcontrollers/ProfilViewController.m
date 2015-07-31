//
//  ProfilViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ProfilViewController.h"
#import "FacebookManager.h"
#import "CoreDataHandler.h"

@interface ProfilViewController ()
@property (nonatomic, strong) FacebookManager *facebookManager;
@end

@implementation ProfilViewController

- (IBAction)logoutButtonPressed:(id)sender
{
    if (!self.facebookManager) {
        self.facebookManager = [[FacebookManager alloc] init];
    }
    [self.facebookManager logoutUser];
    [[CoreDataHandler sharedHandler] clearDatabase];
}

@end
