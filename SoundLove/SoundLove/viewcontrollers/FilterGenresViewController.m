//
//  FilterGenresViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FilterGenresViewController.h"
#import "FilterTableViewCell.h"
#import "Genre.h"
//#import "TrackingManager.h"
#import "ConcertRefreshControl.h"
#import "GenreDownloadClient.h"
#import "CustomNavigationView.h"
#import "UIColor+GlobalColors.h"

@interface FilterGenresViewController ()
@property (nonatomic, strong) GenreDownloadClient *genreDownloadClient;
@property (nonatomic, strong) NSArray *allGenresArrayCopy;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *sectionIndexTitles;
@property (nonatomic, strong) NSMutableArray *selectedGenresArray;
@property (nonatomic, strong) ConcertRefreshControl *refreshController;
@end

@implementation FilterGenresViewController

- (void)trashButtonPressed:(id)sender
{
    [TRACKER userTapsTrashButtonOnDetail];
    
    self.filterModel.selectedGenresArray = nil;
    [self.selectedGenresArray removeAllObjects];
    [self.tableView reloadData];

    [super adjustButtonToFilterModel];
}

- (NSArray*)sectionIndexTitles
{
    if (_sectionIndexTitles) {
        return _sectionIndexTitles;
    }
    NSMutableArray *firstLetterArray = [NSMutableArray array];
    for (Genre *genre in self.genresArray) {
        NSString *genreName = genre.name;

        if (genreName.length >= 1) {
            NSString *firstLetter = [genreName substringToIndex:1];
            if (![firstLetterArray containsObject:firstLetter]) {
                [firstLetterArray addObject:firstLetter];
            }
        }
    }
    _sectionIndexTitles = firstLetterArray;
    return _sectionIndexTitles;
}

#pragma mark - search methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [TRACKER userTapsFilterSearch];

    self.searchCancelButtonWidthConstraint.priority = 250.0;
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
            self.genresArray = [self.allGenresArrayCopy filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@", textfield.text]];
            self.tableData = [self partitionObjects:self.genresArray collationStringSelector:@selector(name)];
        } else {
            _sectionIndexTitles = nil;
            self.tableData = [self partitionObjects:self.allGenresArrayCopy collationStringSelector:@selector(name)];
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
    dispatch_async(dispatch_queue_create("com.festivalama.genreQueue", NULL), ^{
        _sectionIndexTitles = nil;
        self.genresArray = [self.allGenresArrayCopy copy];
        self.tableData = [self partitionObjects:self.allGenresArrayCopy collationStringSelector:@selector(name)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)hideSearchCancelButton
{
    self.searchWrapperViewTrailingConstraint.constant = 0.0;
    self.searchCancelButtonWidthConstraint.priority = 999.0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchWrapperView layoutIfNeeded];
    }];
}


#pragma mark - tableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tableData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    Genre *genre = self.tableData[indexPath.section][indexPath.row];
    cell.textLabel.text = genre.name;

    if ([self.selectedGenresArray containsObject:genre]) {
        [cell setCellActive:YES];
    } else {
        [cell setCellActive:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.selectedGenresArray) {
        self.selectedGenresArray = [NSMutableArray array];
    }

    Genre *selectedGenre = self.tableData[indexPath.section][indexPath.row];
    if ([self.selectedGenresArray containsObject:selectedGenre]) {
        [self.selectedGenresArray removeObject:selectedGenre];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [TRACKER userTapsDeSelectsAGenreArtist];
    } else {
        [TRACKER userTapsSelectsAGenreArtist];
        [self.selectedGenresArray addObject:selectedGenre];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

    self.filterModel.selectedGenresArray = [self.selectedGenresArray copy];
    [self adjustButtonToFilterModel];
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
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    //sort each section
    for (NSMutableArray *section in unsortedSections) {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
    }
    return sections;
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

#pragma mark - indexView methods
- (void)addIndexView
{
    self.indexView = [[RGIndexView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-30.0, CGRectGetMaxY(self.searchWrapperView.frame), 30.0, CGRectGetHeight(self.view.frame)-CGRectGetHeight(self.searchWrapperView.frame)-CGRectGetHeight(self.filterButtonWrapperView.frame))];
    self.indexView.delegate = self;
    self.indexView.displayMode = RGIndexViewDisplayModeFull;
    [self.view insertSubview:self.indexView aboveSubview:self.tableView];
    [self.indexView reloadIndex];
}

#pragma mark - indexView delegate methods
- (NSInteger)numberOfItemsInIndexView
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}

- (NSString *)textForIndex:(NSInteger)index
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:index];
}

- (void)indexView:(RGIndexView *)indexView didSelectIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [self addGradientBackground];
    [self.navigationView setTitle:@"Musik Genres"];
    [self setupSearchView];

    self.refreshController = [[ConcertRefreshControl alloc] initWithFrame:CGRectMake(0.0, -50.0, CGRectGetWidth(self.view.frame), 50.0)];
    [self.tableView addSubview:self.refreshController];

    [self.refreshController addTarget:self
                               action:@selector(refreshView)
                     forControlEvents:UIControlEventValueChanged];

    [self.tableView showLoadingIndicator];
    [self refreshView];
}

- (void)refreshView
{
    [self.refreshController startRefreshing];
    __weak typeof(self) weakSelf = self;
    [self downloadGenresWithCompletionBlock:^{
        [weakSelf.refreshController endRefreshing];
        [weakSelf.tableView hideLoadingIndicator];
        [weakSelf setupView];
        [weakSelf addIndexView];
        if (weakSelf.tableView.contentOffset.y < 0) {
            weakSelf.tableView.contentOffset = CGPointMake(0.0, 0.0);
        }
    }];
}

- (void)setupView
{
    self.allGenresArrayCopy = [self.genresArray copy];
    self.selectedGenresArray = [[self.filterModel selectedGenresArray] mutableCopy];
    self.tableData = [self partitionObjects:self.allGenresArrayCopy collationStringSelector:@selector(name)];

    [self.tableView reloadData];
    [self.tableView hideLoadingIndicator];
}

- (void)setupSearchView
{
    self.searchWrapperView.backgroundColor = [UIColor clearColor];
    self.searchField.layer.cornerRadius = 6.0;
    self.searchField.layer.borderWidth = 1.0;
    self.searchField.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    self.searchField.textColor = [UIColor globalGreenColor];
    self.searchField.tintColor = [UIColor globalGreenColor];

    self.searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchField.placeholder
                                                                             attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.3]}];

    UIView *leftSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 0.0)];
    leftSpacerView.backgroundColor = [UIColor clearColor];
    self.searchField.leftView = leftSpacerView;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;

    [self.searchField addTarget:self
                         action:@selector(searchFieldTextChanged:)
               forControlEvents:UIControlEventEditingChanged];

    [self.searchCancelButton setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];
    [self.searchCancelButton setTitleColor:[[UIColor globalGreenColor] colorWithAlphaComponent:0.4] forState:UIControlStateHighlighted];

    self.searchCancelButtonWidthConstraint.priority = 999.0;
    [self.searchWrapperView layoutIfNeeded];
}

- (void)downloadGenresWithCompletionBlock:(void(^)())completionBlock
{
    self.genreDownloadClient = [GenreDownloadClient new];

    __weak typeof(self) weakSelf = self;
    [self.genreDownloadClient downloadAllGenresWithCompletionBlock:^(NSArray *sortedGenres, NSString *errorMessage, BOOL completed) {
        if (completed) {
            weakSelf.genresArray = [sortedGenres copy];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
