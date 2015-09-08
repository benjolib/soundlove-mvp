//
//  CalendarViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "CalendarViewController.h"
#import "TabbingButton.h"
#import <CoreData/CoreData.h>
#import "CoreDataHandler.h"
#import "CalendarEventFriendsTableViewCell.h"
#import "UIColor+GlobalColors.h"
#import "ConcertModel.h"
#import "CDConcert+ConcertHelper.h"
#import "CDConcertImage.h"
#import "LoadingTableView.h"
#import "ConcertDetailViewController.h"
#import "ImageDownloader.h"
#import "ImageDownloadManager.h"
#import "NSDictionary+nonNullObjectForKey.h"
#import "FriendObject.h"
#import "ConcertsTableViewCell.h"

@interface CalendarViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchController;
@property (nonatomic, strong) NSMutableSet *cellsCurrentlyEditing;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadDictionary;
// Contains an array of images
@property (nonatomic, strong) NSMutableDictionary *downloadedImagesDictionary;
@property (nonatomic) BOOL savedEventsSelected;
@property (nonatomic) BOOL isSearching;
@end

@implementation CalendarViewController

- (NSMutableDictionary*)imageDownloadDictionary
{
    if (!_imageDownloadDictionary) {
        _imageDownloadDictionary = [NSMutableDictionary dictionary];
    }

    return _imageDownloadDictionary;
}

- (NSMutableDictionary*)downloadedImagesDictionary
{
    if (!_downloadedImagesDictionary) {
        _downloadedImagesDictionary = [NSMutableDictionary dictionary];
    }

    return _downloadedImagesDictionary;
}

- (IBAction)friendsButtonPressed:(TabbingButton*)button
{
    [TRACKER userTapsFreundeTab];

    [button setButtonActive:YES];
    [self.eventsButton setButtonActive:NO];

    [self.cellsCurrentlyEditing removeAllObjects];
    self.savedEventsSelected = NO;
    [self loadFriends];
}

- (IBAction)eventsButtonPressed:(TabbingButton*)button
{
    [TRACKER userTapsMeineEventsTab];

    [button setButtonActive:YES];
    [self.friendsButton setButtonActive:NO];

    [self.cellsCurrentlyEditing removeAllObjects];
    self.savedEventsSelected = YES;
    [self loadAllSavedEvents];
}

#pragma mark - searching
- (void)searchNavigationViewSearchButtonPressed:(NSString *)searchText searchField:(UITextField *)searchField
{
    self.isSearching = YES;

    [self searchWithText:searchText];
}

- (void)searchNavigationViewUserEnteredNewCharacter:(NSString *)searchText
{
    self.isSearching = YES;

    [self searchWithText:searchText];
}

- (void)searchNavigationViewCancelButtonPressedSearchField:(UITextField *)searchField
{
    self.isSearching = NO;

    [self.tableView hideEmptyView];

    [self.fetchController.fetchRequest setPredicate:nil];
    [self loadAllSavedEvents];
}

- (void)searchWithText:(NSString*)searchText
{
    self.isSearching = YES;

    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
        [self.fetchController.fetchRequest setPredicate:predicate];
    } else {
        [self.fetchController.fetchRequest setPredicate:nil];
    }

    [self loadAllSavedEvents];

    if (self.fetchController.fetchedObjects.count == 0) {
        [self.tableView showEmptySearchView];
    } else {
        [self.tableView hideEmptyView];
    }
}

#pragma mark - core data
- (NSFetchedResultsController *)fetchController
{
    if (_fetchController) {
        return _fetchController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CDConcert"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];

    [fetchRequest setFetchLimit:20];
    fetchRequest.includesSubentities = YES;

    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                           managedObjectContext:[[CoreDataHandler sharedHandler] mainManagedObjectContext]
                                                             sectionNameKeyPath:@"sectionTitle"
                                                                      cacheName:nil];
    _fetchController.delegate = self;
    return _fetchController;
}

#pragma mark - fetchController delegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = self.tableView;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeUpdate:
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];

    if (self.fetchController.fetchedObjects.count == 0) {
        [self.tableView showEmptyCalendarView];
    } else {
        [self.tableView hideEmptyView];
    }
}

- (void)calendarButtonTapped:(UIButton*)button
{
    UIView *aSuperview = [button superview];
    while (![aSuperview isKindOfClass:[ConcertsTableViewCell class]]) {
        aSuperview = [aSuperview superview];
    }

    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)aSuperview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CDConcert *concertModel = [self.fetchController objectAtIndexPath:indexPath];

    [[CoreDataHandler sharedHandler] removeConcertObject:concertModel];
    [TRACKER userRemovesConcertFromCalendar];
}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchController.sections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController.sections objectAtIndex:section];
    return [sectionInfo name];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), 30.0)];
    headerView.backgroundColor = [UIColor colorWithR:20 G:27 B:36];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, CGRectGetWidth(tableView.frame) - 30.0, 30.0)];
    titleLabel.textColor = [UIColor colorWithR:128 G:128 B:128];
    titleLabel.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:@"Montserrat" size:16.0];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    CDConcert *savedConcert = [self.fetchController objectAtIndexPath:indexPath];
    ConcertModel *concert = [savedConcert concertModel];

    if (self.savedEventsSelected)
    {
        cell.concertTitleLabel.text = concert.name;
        cell.locationLabel.text = concert.place;
        cell.priceLabel.text = [concert priceString];
        cell.dateLabel.text = [concert calendarDaysTillStartDateString];

        [cell showSavedState:[[CoreDataHandler sharedHandler] isConcertSaved:concert]];
        [cell.calendarButton addTarget:self action:@selector(calendarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        dispatch_async(dispatch_queue_create("com.SoundLove.getImageFromCoreData", NULL), ^{
            CDConcertImage *imageModel = savedConcert.image;
            if (imageModel) {
                UIImage *image = [UIImage imageWithData:imageModel.image];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.concertImageView.image = image;
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.concertImageView.image = [UIImage imageNamed:@"placeholder"];
                });
            }
        });
        return cell;
    }
    else
    {
        CalendarEventFriendsTableViewCell *friendsCell = (CalendarEventFriendsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"friendsCell"];
        friendsCell.concertTitleLabel.text = concert.name;
        [friendsCell adjustFriendsViewWithFriends:concert.friendsArray];

        [friendsCell showSavedState:[[CoreDataHandler sharedHandler] isConcertSaved:concert]];
        [friendsCell.calendarButton addTarget:self action:@selector(calendarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        if (concert.friendsArray.count > 0)
        {
            NSArray *imagesArray = [self.downloadedImagesDictionary nonNullObjectForKey:indexPath];
            if (imagesArray) {
                [friendsCell applyImages:imagesArray];
            } else {
                [self downloadImages:concert.friendsArray atIndexPath:indexPath];
            }
        }

        dispatch_async(dispatch_queue_create("com.SoundLove.getImageFromCoreData", NULL), ^{
            CDConcertImage *imageModel = savedConcert.image;
            if (imageModel) {
                UIImage *image = [UIImage imageWithData:imageModel.image];
                dispatch_async(dispatch_get_main_queue(), ^{
                    friendsCell.concertImageView.image = image;
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    friendsCell.concertImageView.image = [UIImage imageNamed:@"placeholder"];
                });
            }
        });

        return friendsCell;
    }
}

- (void)downloadImages:(NSArray*)friendsObjects atIndexPath:(NSIndexPath*)indexPath
{
    // check if there is a manager already for the given indexPath
    ImageDownloadManager *downloadManager = [self.imageDownloadDictionary nonNullObjectForKey:indexPath];

    if (!downloadManager)
    {
        downloadManager = [ImageDownloadManager new];

        NSMutableArray *tempImageURLs = [NSMutableArray array];
        for (FriendObject *friend in friendsObjects) {
            if (friend.imageURL) {
                [tempImageURLs addObject:friend.imageURL];
            }
        }
        downloadManager.imageURLsToDownload = tempImageURLs;

        __weak typeof(self) weakSelf = self;
        [downloadManager startDownloadingImagesWithCompletionBlock:^(NSArray *downloadedImagesArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (downloadedImagesArray.count > 0 && !weakSelf.savedEventsSelected) {
                    CalendarEventFriendsTableViewCell *cell = (CalendarEventFriendsTableViewCell*)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
                    [cell applyImages:downloadedImagesArray];

                    weakSelf.downloadedImagesDictionary[indexPath] = downloadedImagesArray;
                }
                [weakSelf.imageDownloadDictionary removeObjectForKey:indexPath];
            });
        }];
        self.imageDownloadDictionary[indexPath] = downloadManager;
    }
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

            CDConcert *concertModel = [self.fetchController objectAtIndexPath:indexPath];
            ConcertModel *concert = [concertModel concertModel];

            ConcertDetailViewController *detailViewController = (ConcertDetailViewController*)[segue destinationViewController];
            detailViewController.concertToDisplay = concert;
        }
    }
}

#pragma mark - tableView cell delegate methods
- (void)cellDidOpen:(UITableViewCell *)cell
{
    [self.cellsCurrentlyEditing addObject:[self.tableView indexPathForCell:cell]];
}

- (void)cellDidClose:(UITableViewCell *)cell
{
    [self.cellsCurrentlyEditing removeObject:[self.tableView indexPathForCell:cell]];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [self addGradientBackground];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];

    self.cellsCurrentlyEditing = [NSMutableSet new];
    [self.tableView showLoadingIndicator];
    
    [self.eventsButton setButtonActive:YES];
    [self eventsButtonPressed:nil];
}

- (void)loadAllSavedEvents
{
    NSError *fetchError = nil;
    if (![self.fetchController performFetch:&fetchError]) {
        NSLog(@"Error occured during fetching concerts: %@", fetchError.localizedDescription);
    }

    [self.tableView hideLoadingIndicator];
    [self.tableView reloadData];

    if (self.fetchController.fetchedObjects.count == 0 && !self.isSearching) {
        [self.tableView showEmptyCalendarView];
    } else {
        [self.tableView hideEmptyView];
    }
}

- (void)loadFriends
{
    [self.tableView hideLoadingIndicator];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [_downloadedImagesDictionary removeAllObjects];
    [_imageDownloadDictionary removeAllObjects];

}

@end
