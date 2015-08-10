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
#import "StoryboardManager.h"
#import "FilterNavigationController.h"
#import "SortingViewController.h"
#import "ConcertViewDatasourceManager.h"
#import "ConcertRankClient.h"
#import "ConcertDetailViewController.h"
#import "ConcertLoadMoreTableViewCell.h"

@interface ConcertsViewController ()
@property (nonatomic, strong) ConcertRankClient *rankClient;
@property (nonatomic, strong) ConcertRefreshControl *refreshController;
@property (nonatomic, strong) ConcertDownloadClient *downloadClient;
@property (nonatomic, strong) ConcertViewDatasourceManager *datasourceManager;

@property (nonatomic) BOOL showLoadingIndicatorCell;
@property (nonatomic) NSInteger startIndex;
@property (nonatomic) BOOL isSearching;
@end

@implementation ConcertsViewController

- (IBAction)unwindFromSortingView:(id)sender
{

}

- (IBAction)tabbuttonSelected:(TabbingButton*)selectedButton
{
    for (TabbingButton *button in self.tabbuttonsArray) {
        [button setButtonActive:(button == selectedButton)];
    }

    [self.tableView reloadData];
    [self.datasourceManager tabSelectedAtIndex:selectedButton.tag];
    // TODO:

    switch (selectedButton.tag) {
        case 0:
            [self downloadFavoriteConcerts];
            break;
        case 1:
            [self downloadRecommendedConcerts];
            break;
        case 2:
            [self downloadAllConcerts];
            break;
        default:
            break;
    }
}

- (IBAction)filterButtonPressed:(id)sender
{
    FilterNavigationController *filterNav = [StoryboardManager filterNavigationController];
    [self presentViewController:filterNav animated:YES completion:nil];
}

- (IBAction)sortingButtonPressed:(id)sender
{
    SortingViewController *sortingViewController = [StoryboardManager sortingViewController];
    [self presentViewController:sortingViewController animated:YES completion:nil];
}

- (void)calendarButtonTapped:(UIButton*)button
{
    UIView *aSuperview = [button superview];
    while (![aSuperview isKindOfClass:[ConcertsTableViewCell class]]) {
        aSuperview = [aSuperview superview];
    }

    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)aSuperview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ConcertModel *concertModel = self.objectsToDisplay[indexPath.row];

    BOOL alreadyExisting = [[CoreDataHandler sharedHandler] addConcertToFavorites:concertModel];
    if (alreadyExisting) {
//        [[TrackingManager sharedManager] trackUserRemovedFestival];
    } else {
//        [[TrackingManager sharedManager] trackUserAddedFestival];
    }
    [self sendRankInformationAboutSelectedConcert:concertModel increment:!alreadyExisting];
    [self.tableView reloadData];
}

- (void)sendRankInformationAboutSelectedConcert:(ConcertModel*)concert increment:(BOOL)increment
{
    self.rankClient = [[ConcertRankClient alloc] init];
    [self.rankClient sendRankingForFestival:concert increment:increment withCompletionBlock:^(BOOL succeeded, NSString *errorMessage) {
        if (!succeeded) {
            // TODO: error handling
        }
    }];
}

- (NSMutableArray*)objectsToDisplay
{
   return [self.datasourceManager currentlyUsedObjectsArray];
}

#pragma mark - tableView methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self objectsToDisplay].count && self.showLoadingIndicatorCell) {
        return 44.0;
    }
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.showLoadingIndicatorCell) {
        return self.objectsToDisplay.count + 1;
    }
    return self.objectsToDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showLoadingIndicatorCell && indexPath.row == [self objectsToDisplay].count)
    {
        ConcertLoadMoreTableViewCell *reloadCell = (ConcertLoadMoreTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"reloadCell"];
        if (!reloadCell) {
            reloadCell = [[ConcertLoadMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reloadCell"];
        }
        reloadCell.backgroundColor = [UIColor clearColor];
        return reloadCell;
    }

    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ConcertsTableViewCell alloc] init];
    }

    ConcertModel *concert = self.objectsToDisplay[indexPath.row];

    cell.concertTitleLabel.text = concert.name;
    cell.locationLabel.text = concert.place;
    cell.priceLabel.text = [concert priceString];
    cell.dateLabel.text = [concert calendarDaysTillStartDateString];

    [cell showSavedState:[[CoreDataHandler sharedHandler] isConcertSaved:concert]];
    [cell.calendarButton addTarget:self action:@selector(calendarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    if (concert.image) {
        cell.concertImageView.image = concert.image;
    } else {
        if (!tableView.dragging && !tableView.decelerating) {
            [super startImageDownloadForObject:concert atIndexPath:indexPath];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:0] - 1;
    if ((indexPath.row == lastRowIndex) && ([self objectsToDisplay].count >= self.datasourceManager.currentLimit) && !self.isSearching)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITableViewCell *reloadCell = [tableView cellForRowAtIndexPath:indexPath];
            if ([reloadCell isKindOfClass:[ConcertLoadMoreTableViewCell class]])
            {
                ConcertLoadMoreTableViewCell *cell = (ConcertLoadMoreTableViewCell*)reloadCell;
                [cell startRefreshing];
            }

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self downloadNextConcerts];
            });
        });
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != [self objectsToDisplay].count)
    {
        [self performSegueWithIdentifier:@"openDetailView" sender:indexPath];
    }
}

- (void)updateTableViewCellAtIndexPath:(NSIndexPath *)indexPath image:(UIImage *)image
{
    ConcertModel *concert = self.objectsToDisplay[indexPath.row];
    concert.image = image;

    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.concertImageView.image = image;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openDetailView"])
    {
        if ([sender isKindOfClass:[NSIndexPath class]])
        {
            NSIndexPath *indexPath = (NSIndexPath*)sender;

            ConcertModel *concertModel = self.objectsToDisplay[indexPath.row];
            ConcertDetailViewController *detailViewController = (ConcertDetailViewController*)[segue destinationViewController];
            detailViewController.concertToDisplay = concertModel;
        }
    }
}

#pragma mark - download methods
- (void)refreshView
{
    self.startIndex = 0;
    [self.refreshController startRefreshing];

    [self downloadAllConcerts];
}

- (void)downloadNextConcerts
{

}

- (void)downloadAllConcerts
{
    __weak typeof (self) weakSelf = self;
    [self.datasourceManager downloadAllConcertsWithCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        if (completed) {
            [weakSelf handleDownloadedConcerts];
        } else {
            [weakSelf handleDownloadErrorMessage:errorMesage];
        }
    }];
}

- (void)downloadRecommendedConcerts
{
    __weak typeof (self) weakSelf = self;
    [self.datasourceManager downloadRecommendedConcertsWithCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        if (completed) {
            [weakSelf handleDownloadedConcerts];
        } else {
            [weakSelf handleDownloadErrorMessage:errorMesage];
        }
    }];
}

- (void)downloadFavoriteConcerts
{
    __weak typeof (self) weakSelf = self;
    [self.datasourceManager downloadFavoriteConcertsWithCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        if (completed) {
            [weakSelf handleDownloadedConcerts];
        } else {
            [weakSelf handleDownloadErrorMessage:errorMesage];
        }
    }];
}

- (void)handleDownloadedConcerts
{
    [self.tableView hideLoadingIndicator];
    [self.refreshController endRefreshing];

    self.showLoadingIndicatorCell = [self objectsToDisplay].count == self.datasourceManager.currentLimit;

    if (self.tableView.contentOffset.y < 0) {
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ConcertsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.showLoadingIndicatorCell = NO;

    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.filterSortView.backgroundColor = [UIColor navigationBarBackgroundColor];
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)];

    for (TabbingButton *button in self.tabbuttonsArray) {
        [button setButtonActive:button.tag == 2];
    }

    self.datasourceManager = [[ConcertViewDatasourceManager alloc] init];

    [self addRefreshController];
    [self.tableView showLoadingIndicator];
    [self refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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
