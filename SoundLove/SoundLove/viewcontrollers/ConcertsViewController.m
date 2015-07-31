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

@interface ConcertsViewController ()
@property (nonatomic, strong) ConcertRefreshControl *refreshController;
@property (nonatomic, strong) ConcertDownloadClient *downloadClient;

@property (nonatomic, strong) NSMutableArray *favoriteConcertsArray;
@property (nonatomic, strong) NSMutableArray *recommendedConcertsArray;
@property (nonatomic, strong) NSMutableArray *allConcertsArray;

@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger startIndex;
@property (nonatomic) BOOL isSearching;
@property (nonatomic) NSInteger selectedTabbarIndex;
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

    self.selectedTabbarIndex = selectedButton.tag;
    [self.tableView reloadData];
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
//    [self sendRankInformationAboutSelectedFestival:festival increment:!alreadyExisting];
    [self.tableView reloadData];
}

- (NSMutableArray*)objectsToDisplay
{
    switch (self.selectedTabbarIndex) {
        case 0:
            return self.favoriteConcertsArray;
            break;
        case 1:
            return self.recommendedConcertsArray;
            break;
        case 2:
            return self.allConcertsArray;
            break;
        default:
            return [NSMutableArray array];
            break;
    }
}

#pragma mark - tableView methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objectsToDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateTableViewCellAtIndexPath:(NSIndexPath *)indexPath image:(UIImage *)image
{
    ConcertModel *concert = self.objectsToDisplay[indexPath.row];
    concert.image = image;

    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.concertImageView.image = image;
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

    if (!self.allConcertsArray) {
        self.allConcertsArray = [NSMutableArray array];
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
        self.allConcertsArray = [downloadedConcertsArray mutableCopy];
    } else {
        if (self.startIndex == 0) {
            self.allConcertsArray = [downloadedConcertsArray mutableCopy];
        } else {
            [self.allConcertsArray addObjectsFromArray:downloadedConcertsArray];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ConcertsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.filterSortView.backgroundColor = [UIColor navigationBarBackgroundColor];
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)];

    for (TabbingButton *button in self.tabbuttonsArray) {
        [button setButtonActive:button.tag == 2];
    }

    self.selectedTabbarIndex = 2;

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
