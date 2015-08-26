//
//  FavoriteConcertViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 20/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FavoriteConcertViewController.h"
#import "OverlayTransitionManager.h"
#import "LoadingTableView.h"
#import "UIColor+GlobalColors.h"
#import "ConcertRefreshControl.h"
#import "TabbingButton.h"
#import "GeneralSettings.h"
#import "ConcertsTableViewCell.h"
#import "ConcertModel.h"
#import "CoreDataHandler.h"
#import "ConcertRankClient.h"
#import "FavoriteConcertsClient.h"
#import "NSDate+DateHelper.h"
#import "ConcertDetailViewController.h"

@interface FavoriteConcertViewController ()
@property (nonatomic, strong) ConcertRankClient *rankClient;
@property (nonatomic, strong) OverlayTransitionManager *overlayTransitionManager;
@property (nonatomic, strong) ConcertRefreshControl *refreshController;
@property (nonatomic, strong) FavoriteConcertsClient *concertClient;

@property (nonatomic) NSInteger currentlySelectedTabIndex;
@property (nonatomic) BOOL isSearching;
@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong) NSMutableArray *todayConcertsArray; // Stores the ones for today
@property (nonatomic, strong) NSMutableArray *weekConcertsArray; // Stores the ones for this week
@property (nonatomic, strong) NSMutableArray *monthConcertsArray; // Stores the ones for this month
@property (nonatomic, strong) NSMutableArray *searchConcertsArray;
@end

@implementation FavoriteConcertViewController

- (IBAction)tabbuttonSelected:(TabbingButton*)selectedButton
{
    for (TabbingButton *button in self.tabbuttonsArray) {
        [button setButtonActive:(button == selectedButton)];
    }

    self.currentlySelectedTabIndex = selectedButton.tag;

    if (self.isSearching) {
        [self searchWithSearchText:self.searchText];
    } else {
        [self.tableView reloadData];
    }

    if (self.currentlySelectedTabIndex == 0) {
        [TRACKER userTapsTodayTab];
    } else if (self.currentlySelectedTabIndex == 1) {
        [TRACKER userTapsThisWeekTab];
    } else {
        [TRACKER userTapsThisMonthTab];
    }
}

#pragma mark - searchnavigation view delegate methods
- (void)searchNavigationViewSearchButtonPressed:(NSString *)searchText searchField:(UITextField *)searchField
{
    self.isSearching = YES;
    self.searchText = searchText;
    [self searchWithSearchText:searchText];
}

- (void)searchNavigationViewUserEnteredNewCharacter:(NSString *)searchText
{
    [self cancelAllImageDownloads];

    self.isSearching = YES;
    self.searchText = searchText;
    [self searchWithSearchText:searchText];
}

- (void)searchNavigationViewCancelButtonPressedSearchField:(UITextField *)searchField
{
    self.isSearching = NO;
    self.searchText = @"";
    [self.tableView reloadData];
}

- (void)searchWithSearchText:(NSString*)searchText
{
    dispatch_async(dispatch_queue_create("com.SoundLove.searching", NULL), ^{
        if (searchText.length > 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
            self.searchConcertsArray = [[[self baseObjectsForSearching] filteredArrayUsingPredicate:predicate] mutableCopy];
        } else {
            self.searchConcertsArray = [self baseObjectsForSearching];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)refreshView
{
    [self.monthConcertsArray removeAllObjects];
    [self.weekConcertsArray removeAllObjects];
    [self.todayConcertsArray removeAllObjects];

    self.monthConcertsArray = [NSMutableArray array];
    self.weekConcertsArray = [NSMutableArray array];
    self.todayConcertsArray = [NSMutableArray array];

    [self downloadConcerts];
}

- (void)downloadConcerts
{
    if (self.concertClient) {
        self.concertClient = nil;
    }
    self.concertClient = [[FavoriteConcertsClient alloc] init];

    __weak typeof(self) weakSelf = self;
    [self.concertClient downloadConcertsWithCompletionBlock:^(NSString *errorMessage, NSArray *concertsArray) {
        if (errorMessage) {
            [weakSelf handleErrorMessage:errorMessage];
        } else {
            if (concertsArray.count > 0) {
                [weakSelf sortConcerts:concertsArray];
            } else {
                [weakSelf reloadView];
            }
        }
    }];
}

- (void)sortConcerts:(NSArray*)concertsArray
{
    // sort the concerts for this month, week, today

    NSDate *todayDate = [NSDate date];
    NSDateComponents *todayDateComponents = [todayDate dateComponents];
    NSInteger currentYear = todayDateComponents.year;
    NSInteger currentMonth = todayDateComponents.month;
    NSInteger currentWeek = todayDateComponents.weekOfYear;
    NSInteger currentDay = todayDateComponents.day;

    for (ConcertModel *concert in concertsArray)
    {
        NSDate *concertDate = concert.date;

        NSDateComponents *components = [concertDate dateComponents];
        NSInteger year = components.year;
        NSInteger month = components.month;
        NSInteger week = components.weekOfYear;
        NSInteger day = components.day;

        if (year == currentYear)
        {
            if (month == currentMonth)
            {
                [self.monthConcertsArray addObject:concert];

                if (week == currentWeek) {
                    [self.weekConcertsArray addObject:concert];
                }
                if (day == currentDay) {
                    [self.todayConcertsArray addObject:concert];
                }
            }
        }
    }

    [self reloadView];
}

- (void)reloadView
{
    if (self.tableView.contentOffset.y < 0) {
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
    }
    [self.refreshController endRefreshing];
    [self.tableView hideLoadingIndicator];
    [self.tableView reloadData];
}

- (void)handleErrorMessage:(NSString*)errorMessage
{
    // TODO:
}

- (void)downloadNextConcerts{}

- (void)calendarButtonTapped:(UIButton*)button
{
    UIView *aSuperview = [button superview];
    while (![aSuperview isKindOfClass:[ConcertsTableViewCell class]]) {
        aSuperview = [aSuperview superview];
    }

    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)aSuperview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ConcertModel *concertModel = [self objectsToDisplay][indexPath.row];

    BOOL alreadyExisting = [[CoreDataHandler sharedHandler] addConcertToFavorites:concertModel];
    if (alreadyExisting) {
        [TRACKER userRemovesConcertFromCalendar];
    } else {
        [TRACKER userSavesConcertToCalendar];
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

- (NSMutableArray*)baseObjectsForSearching
{
    switch (self.currentlySelectedTabIndex) {
        case 0:
            return self.todayConcertsArray;
            break;
        case 1:
            return self.weekConcertsArray;
            break;
        case 2:
            return self.monthConcertsArray;
            break;
        default:
            return nil;
            break;
    }
}

- (NSMutableArray*)objectsToDisplay
{
    NSMutableArray *arrayToReturn = nil;
    switch (self.currentlySelectedTabIndex) {
        case 0:
            arrayToReturn = self.isSearching ? self.searchConcertsArray : self.todayConcertsArray;
            break;
        case 1:
            arrayToReturn = self.isSearching ? self.searchConcertsArray : self.weekConcertsArray;
            break;
        case 2:
            arrayToReturn = self.isSearching ? self.searchConcertsArray : self.monthConcertsArray;
            break;
        default:
            return nil;
            break;
    }

    if (arrayToReturn.count == 0) {
        [self.tableView showEmptySearchView];
    } else {
        [self.tableView hideEmptyView];
    }
    return arrayToReturn;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - tableView methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self objectsToDisplay].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ConcertsTableViewCell alloc] init];
    }

    ConcertModel *concert = [self objectsToDisplay][indexPath.row];

    cell.concertTitleLabel.text = concert.name;
    cell.locationLabel.text = concert.place;
    cell.priceLabel.text = [concert priceString];
    cell.dateLabel.text = [concert calendarDaysTillStartDateString];

    [cell showSavedState:[[CoreDataHandler sharedHandler] isConcertSaved:concert]];
    [cell.calendarButton addTarget:self action:@selector(calendarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    if (concert.image) {
        cell.concertImageView.image = concert.image;
    } else {
        if (!tableView.dragging && !tableView.decelerating && concert.imageURL) {
            [super startImageDownloadForObject:concert atIndexPath:indexPath];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"openDetailView" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openDetailView"])
    {
        if ([sender isKindOfClass:[NSIndexPath class]])
        {
            NSIndexPath *indexPath = (NSIndexPath*)sender;
            ConcertModel *concertModel = [self objectsToDisplay][indexPath.row];
            ConcertDetailViewController *detailViewController = (ConcertDetailViewController*)[segue destinationViewController];
            detailViewController.concertToDisplay = concertModel;
        }
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [self addGradientBackground];

    [self.tableView registerNib:[UINib nibWithNibName:@"ConcertsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.filterSortView.backgroundColor = [UIColor navigationBarBackgroundColor];
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)];

    for (TabbingButton *button in self.tabbuttonsArray) {
        [button setButtonActive:button.tag == 0];
    }

    self.currentlySelectedTabIndex = 0;
    [self addRefreshController];
    [self.tableView showLoadingIndicator];
    [self refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
