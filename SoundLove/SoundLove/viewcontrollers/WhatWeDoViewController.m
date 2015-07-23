//
//  WhatWeDoViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 05/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "WhatWeDoViewController.h"

@implementation WhatWeDoViewController

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Was wir machen";

    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"aboutUs" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:htmlString baseURL:nil];
}

@end
