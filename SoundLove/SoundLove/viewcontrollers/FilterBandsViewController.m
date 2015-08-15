//
//  FilterBandsViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterBandsViewController.h"
#import "BandsDownloadClient.h"
#import "Band.h"
#import "FilterTableViewCell.h"
//#import "TrackingManager.h"
#import "ConcertRefreshControl.h"
#import "UIColor+GlobalColors.h"

@interface FilterBandsViewController ()
@property (nonatomic, strong) NSArray *allBandsArrayCopy;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *sectionIndexTitles;
@property (nonatomic, strong) BandsDownloadClient *bandsDownloadClient;
@property (nonatomic, strong) NSMutableArray *selectedBandsArray;
@property (nonatomic, strong) ConcertRefreshControl *refreshController;
@end

@implementation FilterBandsViewController

- (NSArray*)sectionIndexTitles
{
    if (_sectionIndexTitles) {
        return _sectionIndexTitles;
    }
    NSMutableArray *firstLetterArray = [NSMutableArray array];
    for (Band *band in self.allBandsArray) {
        NSString *bandName = band.name;

        if (bandName.length >= 1) {
            NSString *firstLetter = [bandName substringToIndex:1];
            if (![firstLetterArray containsObject:firstLetter]) {
                [firstLetterArray addObject:firstLetter];
            }
        }
    }
    _sectionIndexTitles = firstLetterArray;
    return _sectionIndexTitles;
}

- (void)trashButtonPressed:(id)sender
{
//    [[TrackingManager sharedManager] trackFilterTapsTrashIconDetail];

    self.filterModel.selectedBandsArray = nil;
    [self.selectedBandsArray removeAllObjects];
    [self.tableView reloadData];

    [super adjustButtonToFilterModel];
}

- (NSMutableArray *)selectedBandsArray
{
    [self setTrashIconVisible:_selectedBandsArray.count > 0];
    return _selectedBandsArray;
}

#pragma mark - search methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [[TrackingManager sharedManager] trackFilterSearches];

    self.searchWrapperViewTrailingConstraint.constant = 10.0;
    self.searchCancelButtonWidthConstraint.constant = 70.0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchWrapperView layoutIfNeeded];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self hideSearchCancelButton];
    }
}

- (void)searchFieldTextChanged:(UITextField*)textfield
{
    dispatch_async(dispatch_queue_create("com.festivalama.bandQueue", NULL), ^{
        if (textfield.text.length > 0) {
            _sectionIndexTitles = nil;
            self.allBandsArray = [self.allBandsArrayCopy filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@", textfield.text]];
            self.tableData = [self partitionObjects:self.allBandsArray collationStringSelector:@selector(name)];
        } else {
            _sectionIndexTitles = nil;
            self.tableData = [self partitionObjects:self.allBandsArrayCopy collationStringSelector:@selector(name)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (IBAction)searchCancelButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    [self hideSearchCancelButton];

    self.searchField.text = @"";
    dispatch_async(dispatch_queue_create("com.festivalama.bandQueue", NULL), ^{
        _sectionIndexTitles = nil;
        self.allBandsArray = [self.allBandsArrayCopy copy];
        self.tableData = [self partitionObjects:self.allBandsArrayCopy collationStringSelector:@selector(name)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)hideSearchCancelButton
{
    self.searchWrapperViewTrailingConstraint.constant = 0.0;
    self.searchCancelButtonWidthConstraint.constant = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchWrapperView layoutIfNeeded];
    }];
}

#pragma mark - view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tableData objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    Band *band = self.tableData[indexPath.section][indexPath.row];
    cell.textLabel.text = band.name;

    if ([self.selectedBandsArray containsObject:band]) {
        [cell setCellActive:YES];
    } else {
        [cell setCellActive:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.selectedBandsArray) {
        self.selectedBandsArray = [NSMutableArray array];
    }

    Band *selectedBand = self.tableData[indexPath.section][indexPath.row];
    if ([self.selectedBandsArray containsObject:selectedBand]) {
        [self.selectedBandsArray removeObject:selectedBand];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [[TrackingManager sharedManager] trackFilterSelectsBandAgainToUnselect];
    } else {
        [self.selectedBandsArray addObject:selectedBand];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [[TrackingManager sharedManager] trackFilterSelectsBand];
    }

    [self.filterModel setSelectedBandsArray:[self.selectedBandsArray copy]];
}

#pragma mark - section index titles
- (NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionCount = [[collation sectionTitles] count]; //section count is take from sectionTitles and not sectionIndexTitles
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    //create an array to hold the data for each section
    for(int i = 0; i < sectionCount; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    //put each object into a section
    for (id object in array) {
        NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    return unsortedSections;
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super addGradientBackground];
    [self setupSearchView];

    self.refreshController = [[ConcertRefreshControl alloc] initWithFrame:CGRectMake(0.0, -50.0, CGRectGetWidth(self.view.frame), 50.0)];
    [self.tableView addSubview:self.refreshController];

    [self.refreshController addTarget:self
                               action:@selector(refreshView)
                     forControlEvents:UIControlEventValueChanged];

    [self.tableView showLoadingIndicator];
    [self refreshView];

    [self addIndexView];
}

- (void)refreshView
{
    __weak typeof(self) weakSelf = self;
    [self downloadBandsWithCompletionBlock:^{
        weakSelf.allBandsArrayCopy = [weakSelf.allBandsArray copy];
        weakSelf.selectedBandsArray = [[self.filterModel selectedBandsArray] mutableCopy];
        weakSelf.tableData = [weakSelf partitionObjects:weakSelf.allBandsArray collationStringSelector:@selector(name)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView hideLoadingIndicator];
            [weakSelf.refreshController endRefreshing];
            if (weakSelf.tableView.contentOffset.y < 0) {
                weakSelf.tableView.contentOffset = CGPointMake(0.0, 0.0);
            }
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)downloadBandsWithCompletionBlock:(void(^)())completionBlock
{
    self.bandsDownloadClient = [BandsDownloadClient new];

    __weak typeof(self) weakSelf = self;
    [self.bandsDownloadClient downloadAllBandsWithCompletionBlock:^(NSArray *sortedBands, NSString *errorMessage, BOOL completed) {
        if (completed) {
            weakSelf.allBandsArray = [sortedBands copy];
        }
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self adjustButtonToFilterModel];
}

- (void)dealloc
{
    self.bandsDownloadClient = nil;
}

@end
