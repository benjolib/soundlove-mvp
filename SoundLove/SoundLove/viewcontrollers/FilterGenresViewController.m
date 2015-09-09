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
#import "ConcertRefreshControl.h"
#import "GenreDownloadClient.h"
#import "CustomNavigationView.h"
#import "UIColor+GlobalColors.h"

@interface FilterGenresViewController ()
@property (nonatomic, strong) GenreDownloadClient *genreDownloadClient;
@property (nonatomic, strong) NSArray *allGenresArrayCopy;
@property (nonatomic, strong) NSMutableArray *selectedGenresArray;
@property (nonatomic, strong) ConcertRefreshControl *refreshController;
@end

@implementation FilterGenresViewController

- (IBAction)trashButtonPressed:(id)sender
{
    [TRACKER userTapsTrashButtonOnDetail];
    
    self.filterModel.selectedGenresArray = nil;
    [self.selectedGenresArray removeAllObjects];
    [self.tableView reloadData];

    [super adjustButtonToFilterModel];
}

#pragma mark - tableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.genresArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];

    Genre *genre = self.genresArray[indexPath.row];
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

    Genre *selectedGenre = self.genresArray[indexPath.row];
    if ([self.selectedGenresArray containsObject:selectedGenre]) {
        [self.selectedGenresArray removeObject:selectedGenre];
        [TRACKER userTapsDeSelectsAGenreArtist];
    } else {
        [TRACKER userTapsSelectsAGenreArtist];
        [self.selectedGenresArray removeAllObjects];
        [self.selectedGenresArray addObject:selectedGenre];
    }

    [self.tableView reloadData];

    self.filterModel.selectedGenresArray = [self.selectedGenresArray copy];
    [self adjustButtonToFilterModel];
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

#pragma mark - view methods
- (void)viewDidLoad
{
    [self addGradientBackground];
    [self.navigationView setTitle:@"Musik Genres"];

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
        if (weakSelf.tableView.contentOffset.y < 0) {
            weakSelf.tableView.contentOffset = CGPointMake(0.0, 0.0);
        }
    }];
}

- (void)setupView
{
    self.allGenresArrayCopy = [self.genresArray copy];
    self.selectedGenresArray = [[self.filterModel selectedGenresArray] mutableCopy];

    [self.tableView reloadData];
    [self.tableView hideLoadingIndicator];
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
