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
#import "ConcertDownloadClient.h"
#import "ConcertModel.h"
#import "CoreDataHandler.h"

@interface ConcertsViewController ()
@property (nonatomic, strong) ConcertRefreshControl *refreshController;
@property (nonatomic, strong) ConcertDownloadClient *downloadClient;
@property (nonatomic, strong) NSMutableArray *concertsArray;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger startIndex;
@property (nonatomic) BOOL isSearching;
@end

@implementation ConcertsViewController

- (IBAction)tabbuttonSelected:(TabbingButton*)selectedButton
{
    for (TabbingButton *button in self.tabbuttonsArray) {
        [button setButtonActive:(button == selectedButton)];
    }
}

- (IBAction)calenderButtonTapped:(UIButton*)button
{
    UIView *aSuperview = [button superview];
    while (![aSuperview isKindOfClass:[ConcertsTableViewCell class]]) {
        aSuperview = [aSuperview superview];
    }

    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)aSuperview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ConcertModel *concertModel = self.concertsArray[indexPath.row];

    BOOL alreadyExisting = [[CoreDataHandler sharedHandler] addConcertToFavorites:concertModel];
    if (alreadyExisting) {
//        [[TrackingManager sharedManager] trackUserRemovedFestival];
    } else {
//        [[TrackingManager sharedManager] trackUserAddedFestival];
    }
//    [self sendRankInformationAboutSelectedFestival:festival increment:!alreadyExisting];
    [self.tableView reloadData];
}

#pragma mark - tableView methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.concertsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    ConcertModel *concert = self.concertsArray[indexPath.row];

    cell.concertTitleLabel.text = concert.name;
    cell.locationLabel.text = concert.place;
    cell.priceLabel.text = [concert priceString];
    cell.dateLabel.text = [concert calendarDaysTillStartDateString];

    [cell showSavedState:[[CoreDataHandler sharedHandler] isConcertSaved:concert]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - download methods
- (void)refreshView
{
    self.startIndex = 0;
    [self.refreshController startRefreshing];

    [self downloadAllConcerts];
}

- (void)downloadAllConcerts
{
    if (!self.downloadClient) {
        self.downloadClient = [[ConcertDownloadClient alloc] init];
    }

    if (!self.concertsArray) {
        self.concertsArray = [NSMutableArray array];
    }

    self.limit = 40.0;

    __weak typeof (self) weakSelf = self;
    [self.downloadClient downloadConcertsFromIndex:self.startIndex limit:self.limit withFilters:nil searchText:nil completionBlock:^(NSString *errorMessage, NSArray *concertsArray) {
        [weakSelf.tableView hideLoadingIndicator];
        [weakSelf.refreshController endRefreshing];

        if (weakSelf.tableView.contentOffset.y < 0) {
            weakSelf.tableView.contentOffset = CGPointMake(0.0, 0.0);
        }
        if (errorMessage) {
            [weakSelf handleDownloadErrorMessage:errorMessage];
        } else {
            [weakSelf handleDownloadedConcertsArray:concertsArray];
        }
    }];
}

- (void)handleDownloadedConcertsArray:(NSArray*)downloadedConcertsArray
{
    if (self.isSearching) {
        self.concertsArray = [downloadedConcertsArray mutableCopy];
    } else {
        if (self.startIndex == 0) {
            self.concertsArray = [downloadedConcertsArray mutableCopy];
        } else {
            [self.concertsArray addObjectsFromArray:downloadedConcertsArray];
        }
    }

    [self.tableView reloadData];
}

- (void)handleDownloadErrorMessage:(NSString*)errorMessage
{


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
    [self.tableView showLoadingIndicator];
    [self refreshView];
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

    [GeneralSettings setTutorialsShown];
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
