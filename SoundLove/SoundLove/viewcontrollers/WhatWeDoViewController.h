//
//  WhatWeDoViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 05/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "BaseGradientViewController.h"

@class CustomNavigationView;

@interface WhatWeDoViewController : BaseGradientViewController

@property (nonatomic, weak) IBOutlet UIWebView *webview;
@property (nonatomic, weak) IBOutlet CustomNavigationView *navigationView;

- (IBAction)closeView:(id)sender;

@end
