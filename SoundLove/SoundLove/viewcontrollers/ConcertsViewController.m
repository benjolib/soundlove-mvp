//
//  ConcertsViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertsViewController.h"
#import "TabbingButton.h"
#import "ConcertsTableViewCell.h"
#import "LoadingTableView.h"

@interface ConcertsViewController ()

@end

@implementation ConcertsViewController

- (IBAction)tabbuttonSelected:(TabbingButton*)selectedButton
{
    for (TabbingButton *button in self.tabbuttonsArray) {
        [button setButtonActive:(button == selectedButton)];
    }
}

#pragma mark - tableView methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
