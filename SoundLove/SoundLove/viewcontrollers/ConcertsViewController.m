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
#import "ConcertModel.h"
#import "CoreDataHandler.h"
#import "StoryboardManager.h"
#import "FilterNavigationController.h"
#import "SortingViewController.h"
#import "ConcertViewDatasourceManager.h"
#import "ConcertRankClient.h"
#import "ConcertDetailViewController.h"
#import "ConcertLoadMoreTableViewCell.h"
#import "FilterViewController.h"

@interface ConcertsViewController ()
@property (nonatomic, strong) ConcertRankClient *rankClient;
@property (nonatomic, strong) ConcertRefreshControl *refreshController;
@property (nonatomic, strong) ConcertViewDatasourceManager *datasourceManager;
@property (nonatomic) NSInteger currentlySelectedTabIndex;

@property (nonatomic) BOOL showLoadingIndicatorCell;
@property (nonatomic, strong) NSTimer *searchTimer;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic) BOOL isSearching;
@end

@implementation ConcertsViewController

- (IBAction)unwindFromSortingView:(UIStoryboardSegue*)unwindSegue
{
    SortingViewController *sortingViewController = unwindSegue.sourceViewController;
    self.filterModel.sortingObject = sortingViewController.selectedSortingObject;

    [self applySortingOptionToConcerts];
}

- (IBAction)unwindFromSortingViewWithClosing:(UIStoryboardSegue*)unwindSegue
{
    // do nothing here, user closed the sorting view
}

- (IBAction)tabbuttonSelected:(TabbingButton*)selectedButton
{
    // save the current content offset
    [self.datasourceManager saveContentOffset:self.tableView.contentOffset forSelectedIndex:self.currentlySelectedTabIndex];

    [self.tableView hideLoadingIndicator];
    [self.refreshController endRefreshing];
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)];
    if (self.tableView.contentOffset.y < 0) {
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
    }

    for (TabbingButton *button in self.tabbuttonsArray) {
        [button setButtonActive:(button == selectedButton)];
    }

    [self.tableView reloadData];
    self.currentlySelectedTabIndex = selectedButton.tag;

    [self downloadConcertsAccordingToSelection];

    if (self.currentlySelectedTabIndex == 0) {
        [TRACKER userTapsFavoriten];
    } else if (self.currentlySelectedTabIndex == 1) {
        [TRACKER userTapsEmpfohlen];
    } else {
        [TRACKER userTapsAll];
    }
}

- (IBAction)unwindFromFilteringViewByClosing:(UIStoryboardSegue*)segue
{
    // do nothing
}

- (IBAction)unwindFromFilterViewApplyingFilter:(UIStoryboardSegue*)unwindSegue
{
    [self.datasourceManager setAllContentOffsetToZero];
    [self.tableView setContentOffset:CGPointZero];

    [self.tableView showLoadingIndicator];

    FilterViewController *filterViewController = unwindSegue.sourceViewController;
    FilterModel *filterModel = filterViewController.filterModel;

    self.filterModel = filterModel;

    __weak typeof (self) weakSelf = self;
    [self.datasourceManager redownloadConcertsWithIndex:self.currentlySelectedTabIndex filterModel:filterModel withCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        [weakSelf.tableView hideLoadingIndicator];
        [weakSelf.refreshController endRefreshing];
        if (completed) {
            [weakSelf.datasourceManager showArrayAtIndex:weakSelf.currentlySelectedTabIndex];
            [weakSelf handleDownloadedConcerts];
        } else {
            [weakSelf handleDownloadErrorMessage:errorMesage];
        }
    }];
}

- (IBAction)filterButtonPressed:(id)sender
{
    [TRACKER userOpensFilter];

    FilterNavigationController *filterNav = [StoryboardManager filterNavigationController];
    [self presentViewController:filterNav animated:YES completion:nil];

    // assign the current filter model to the filter viewController
    if ([filterNav.topViewController isKindOfClass:[FilterViewController class]]) {
        FilterViewController *filterViewController = (FilterViewController*)filterNav.topViewController;
        filterViewController.filterModel = self.filterModel;
        [filterViewController reloadView];
    }
}

- (void)applySortingOptionToConcerts
{
    [self.tableView showLoadingIndicator];
    self.datasourceManager.currentSortingObject = self.filterModel.sortingObject;

    [self redownloadConcerts];
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

- (NSMutableArray*)objectsToDisplay
{
   return [self.datasourceManager currentlyUsedObjectsArray];
}

#pragma mark - searchnavigation view delegate methods
- (void)searchNavigationViewSearchButtonPressed:(NSString *)searchText searchField:(UITextField *)searchField
{
    [TRACKER userOpensSearch];

    self.isSearching = YES;
    self.searchText = searchText;
    self.datasourceManager.isSearching = YES;

    [self stopSearchTimer];
    [self searchForConcerts];
}

- (void)searchNavigationViewUserEnteredNewCharacter:(NSString *)searchText
{
    [self.datasourceManager setAllContentOffsetToZero];
    [self.tableView setContentOffset:CGPointZero];

    [self cancelAllImageDownloads];

    self.isSearching = YES;
    self.searchText = searchText;

    [self stopSearchTimer];
    [self startSearchTimer];
}

- (void)searchNavigationViewCancelButtonPressedSearchField:(UITextField *)searchField
{
    self.isSearching = NO;
    self.searchText = @"";

    self.datasourceManager.isSearching = NO;
    self.datasourceManager.searchText = @"";

    [self redownloadConcerts];
}

- (void)searchForConcerts
{
    self.datasourceManager.isSearching = YES;
    self.datasourceManager.searchText = self.searchText;

    __weak typeof(self) weakSelf = self;
    [self.datasourceManager redownloadConcertsWithIndex:self.currentlySelectedTabIndex filterModel:self.filterModel withCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        if (completed) {
            [weakSelf.datasourceManager showArrayAtIndex:weakSelf.currentlySelectedTabIndex];
            [weakSelf handleDownloadedConcerts];
        } else {
            [weakSelf handleDownloadErrorMessage:errorMesage];
        }
    }];
}

- (void)startSearchTimer
{
    [self stopSearchTimer];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchForConcerts) userInfo:nil repeats:NO];
}

- (void)stopSearchTimer
{
    [self.searchTimer invalidate];
    self.searchTimer = nil;
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
    if ((indexPath.row == lastRowIndex) && self.showLoadingIndicatorCell)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITableViewCell *reloadCell = [tableView cellForRowAtIndexPath:indexPath];
            if ([reloadCell isKindOfClass:[ConcertLoadMoreTableViewCell class]]) {
                ConcertLoadMoreTableViewCell *cell = (ConcertLoadMoreTableViewCell*)reloadCell;
                [cell startRefreshing];
            }
        });
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];

    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;

    if (maximumOffset - currentOffset <= -40 && [self.datasourceManager shouldLoadNextItemsAtIndex:self.currentlySelectedTabIndex])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self downloadNextConcerts];
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
    if (indexPath.row <= self.objectsToDisplay.count)
    {
        ConcertModel *concert = self.objectsToDisplay[indexPath.row];

        ConcertsTableViewCell *cell = (ConcertsTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        if (image)
        {
            concert.image = image;
            if (cell) {
                cell.concertImageView.image = image;
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openDetailView"])
    {
        [TRACKER userSelectsConcertForDetails];
        if ([sender isKindOfClass:[NSIndexPath class]])
        {
            NSIndexPath *indexPath = (NSIndexPath*)sender;

            ConcertModel *concertModel = self.objectsToDisplay[indexPath.row];
            ConcertDetailViewController *detailViewController = (ConcertDetailViewController*)[segue destinationViewController];
            detailViewController.concertToDisplay = concertModel;
        }
    }
    else if ([segue.identifier isEqualToString:@"showSortingView"])
    {
        [TRACKER userOpensSorting];
        SortingViewController *sortingViewController = (SortingViewController*)segue.destinationViewController;
        sortingViewController.selectedSortingObject = self.filterModel.sortingObject;
    }
}

#pragma mark - download methods
- (void)refreshView
{
    [self.refreshController startRefreshing];

    [self redownloadConcerts];
}

- (void)redownloadConcerts
{
    __weak typeof (self) weakSelf = self;
    [self.datasourceManager redownloadConcertsWithIndex:self.currentlySelectedTabIndex filterModel:self.filterModel withCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        [weakSelf.tableView hideLoadingIndicator];
        [weakSelf.refreshController endRefreshing];
        if (completed) {
            [weakSelf.datasourceManager showArrayAtIndex:weakSelf.currentlySelectedTabIndex];
            [weakSelf handleDownloadedConcerts];
        } else {
            [weakSelf handleDownloadErrorMessage:errorMesage];
        }
    }];
}

- (void)downloadNextConcerts
{
    __weak typeof(self) weakSelf = self;
    [self.datasourceManager downloadNextConcertsAtIndex:self.currentlySelectedTabIndex WithCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        [weakSelf.tableView hideLoadingIndicator];
        [weakSelf.refreshController endRefreshing];
        if (completed) {
            [weakSelf.datasourceManager showArrayAtIndex:weakSelf.currentlySelectedTabIndex];
            [weakSelf handleDownloadedConcerts];
        } else {
            [weakSelf handleDownloadErrorMessage:errorMesage];
        }
    }];
}

- (void)downloadConcertsAccordingToSelection
{
    [self.tableView showLoadingIndicator];

    __weak typeof(self) weakSelf = self;
    [self.datasourceManager loadSavedObjectsAtIndex:self.currentlySelectedTabIndex withCompletionBlock:^(BOOL completed, NSString *errorMesage) {
        [weakSelf.tableView hideLoadingIndicator];
        [weakSelf.refreshController endRefreshing];
        if (completed) {
            [weakSelf.datasourceManager showArrayAtIndex:weakSelf.currentlySelectedTabIndex];
            [weakSelf handleDownloadedConcerts];

            [weakSelf.tableView setContentOffset:[weakSelf.datasourceManager currentContentOffsetForSelectedIndex:weakSelf.currentlySelectedTabIndex]];
        } else {
            [weakSelf handleDownloadErrorMessage:errorMesage];
        }
    }];
}

- (void)handleDownloadedConcerts
{
    [self.tableView hideLoadingIndicator];
    [self.refreshController endRefreshing];

    self.showLoadingIndicatorCell = [self.datasourceManager shouldLoadNextItemsAtIndex:self.currentlySelectedTabIndex];

    if (self.tableView.contentOffset.y < 0) {
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
    }
    [self.tableView reloadData];

    if ([self objectsToDisplay].count == 0) {
        [self.tableView showEmptySearchView];
    } else {
        [self.tableView hideEmptyView];
    }
}

- (void)handleDownloadErrorMessage:(NSString*)errorMessage
{
    [self.tableView hideLoadingIndicator];
    [self.refreshController endRefreshing];

    if (self.tableView.contentOffset.y < 0) {
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
    }
}

#pragma mark - view methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshController parentScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
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
    self.datasourceManager.currentSortingObject = [SortingObject sortingWithType:SortingTypeNone];

    self.currentlySelectedTabIndex = SelectedTabIndexAll;

    self.filterModel = [[FilterModel alloc] init];
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
    [tutorial2 showWithText:@"Filtere die Ergebnisse nach Musik Genre, Künstler oder Ort"
                    atPoint:CGPointMake(CGRectGetMidX(self.filterSortView.frame), CGRectGetMinY(self.filterSortView.frame)-30.0)
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
