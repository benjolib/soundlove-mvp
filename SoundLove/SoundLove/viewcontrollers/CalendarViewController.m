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
#import "CalendarEventTableViewCell.h"
#import "UIColor+GlobalColors.h"
#import "ConcertModel.h"
#import "CDConcert+ConcertHelper.h"
#import "LoadingTableView.h"

@interface CalendarViewController () <NSFetchedResultsControllerDelegate, CalendarEventTableViewCellDelegate>
@property (nonatomic, strong) NSArray *savedConcertsArray;
@property (nonatomic, strong) NSFetchedResultsController *fetchController;
@property (nonatomic, strong) NSMutableSet *cellsCurrentlyEditing;
@end

@implementation CalendarViewController

- (IBAction)friendsButtonPressed:(TabbingButton*)button
{
    [button setButtonActive:YES];
    [self.eventsButton setButtonActive:NO];

    [self loadFriends];
}

- (IBAction)eventsButtonPressed:(TabbingButton*)button
{
    [button setButtonActive:YES];
    [self.friendsButton setButtonActive:NO];

    [self loadAllSavedEvents];
}

#pragma mark - tableViewCell button actions
- (IBAction)deleteButtonPressed:(UIButton*)button
{
    NSIndexPath *indexPath = [self indexPathForButton:button];
    CDConcert *concert = self.savedConcertsArray[indexPath.row];

    [self cellDidClose:(CalendarEventTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath]];

    [[CoreDataHandler sharedHandler] removeConcertObject:concert];
}

- (IBAction)shareButtonPressed:(UIButton*)button
{
    NSIndexPath *indexPath = [self indexPathForButton:button];
    CDConcert *concert = self.savedConcertsArray[indexPath.row];

    NSString *stringToShare = [NSString stringWithFormat:@"%@", concert.name];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[stringToShare]
                                                                                         applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                     UIActivityTypePrint,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypePostToFlickr,
                                                     UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (NSIndexPath*)indexPathForButton:(UIButton*)button
{
    UIView *aSuperview = [button superview];
    while (![aSuperview isKindOfClass:[ConcertsTableViewCell class]]) {
        aSuperview = [aSuperview superview];
    }

    ConcertsTableViewCell *cell = (ConcertsTableViewCell*)aSuperview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    return indexPath;
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
//    titleLabel.font = [UIFont latoBoldFontWithSize:17.0];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarEventTableViewCell *cell = (CalendarEventTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;

    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }

    CDConcert *savedConcert = [self.fetchController objectAtIndexPath:indexPath];
    ConcertModel *concert = [savedConcert concertModel];

    cell.concertTitleLabel.text = concert.name;
    cell.locationLabel.text = concert.place;
    cell.priceLabel.text = [concert priceString];
    cell.dateLabel.text = [concert calendarDaysTillStartDateString];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"openFestivalDetailView" sender:cell];
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
}

- (void)loadFriends
{

    [self.tableView hideLoadingIndicator];
    [self.tableView reloadData];
}

@end
