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
#import "ConcertRefreshControl.h"
#import "GeneralSettings.h"
#import "UIColor+GlobalColors.h"
#import "TutorialPopupView.h"

@interface ConcertsViewController ()
@property (nonatomic, strong) ConcertRefreshControl *refreshController;
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshController parentScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshController parentScrollViewDidEndDragging:scrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.filterSortView.backgroundColor = [UIColor navigationBarBackgroundColor];
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)];

    for (TabbingButton *button in self.tabbuttonsArray) {
        [button setButtonActive:button.tag == 0];
    }

    [self addRefreshController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![GeneralSettings wasTutorialShown]) {
        [self showTutorialPopup];
    }
}

- (void)showTutorialPopup
{
    TutorialPopupView *tutorial2 = [[TutorialPopupView alloc] init];
    [tutorial2 showWithText:@"Filtere die Ergebniss nach Musik Genre, Künstler oder Ort"
                    atPoint:CGPointMake(CGRectGetMidX(self.filterSortView.frame), CGRectGetMinY(self.filterSortView.frame)-50.0)
              highLightArea:self.filterSortView.frame];
}

- (void)refreshView
{
    [self.refreshController startRefreshing];

    [self.refreshController endRefreshing];
    [self.tableView hideLoadingIndicator];
}

- (void)addRefreshController
{
    self.refreshController = [[ConcertRefreshControl alloc] initWithFrame:CGRectMake(0.0, -50.0, CGRectGetWidth(self.view.frame), 50.0)];
    [self.tableView addSubview:self.refreshController];

    [self.refreshController addTarget:self
                               action:@selector(refreshView)
                     forControlEvents:UIControlEventValueChanged];
}

@end
