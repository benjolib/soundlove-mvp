//
//  BandsViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BandsViewController.h"
#import "TabbingButton.h"
#import "BandCollectionViewCell.h"
#import "CustomNavigationView.h"
#import "ArtistDownloadClient.h"
#import "LoadingCollectionView.h"
#import "ArtistModel.h"

@interface BandsViewController ()
@property (nonatomic, strong) NSMutableArray *artistsArray;
@property (nonatomic, strong) ArtistDownloadClient *artistDownloadClient;
@end

@implementation BandsViewController

- (IBAction)favoriteButtonPressed:(TabbingButton*)button
{
    [self.recommendedButton setButtonActive:NO];
    [button setButtonActive:YES];
}

- (IBAction)recommendButtonPressed:(TabbingButton*)button
{
    [self.favoriteButton setButtonActive:NO];
    [button setButtonActive:YES];
}

- (NSMutableArray *)objectsToDisplay
{
    return self.artistsArray;
}

#pragma mark - collectionView methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self objectsToDisplay].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    ArtistModel *artist = [[self objectsToDisplay] objectAtIndex:indexPath.row];
    cell.nameLabel.text = artist.name;

    if (artist.image) {
        cell.artistImageView.image = artist.image;
    } else {
        if (!collectionView.dragging && !collectionView.decelerating) {
            [super startImageDownloadForObject:artist atIndexPath:indexPath];
        }
    }

    return cell;
}

- (void)updateTableViewCellAtIndexPath:(NSIndexPath *)indexPath image:(UIImage *)image
{
    ArtistModel *artist = self.objectsToDisplay[indexPath.row];

    BandCollectionViewCell *cell = (BandCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (image) {
        artist.image = image;
        cell.artistImageView.image = image;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame)/3 - 20.0, 120.0);
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];

    [self.favoriteButton setButtonActive:YES];
    [self.recommendedButton setButtonActive:NO];

    [self.collectionView showLoadingIndicator];
    [self downloadArtists];
}

- (void)downloadArtists
{
    self.artistDownloadClient = [[ArtistDownloadClient alloc] init];

    __weak typeof(self) weakSelf = self;
    [self.artistDownloadClient downloadFavoriteArtistsWithCompletionBlock:^(NSArray *artists, BOOL completed, NSString *errorMessage) {
        if (errorMessage) {

        } else {
            weakSelf.artistsArray = [artists copy];
            [weakSelf.collectionView hideLoadingIndicator];
            if (weakSelf.artistsArray.count == 0) {
                [weakSelf.collectionView showEmptySearchView];
            } else {
                [weakSelf.collectionView hideEmptyView];
                [weakSelf.collectionView reloadData];
            }
        }
    }];
}

@end
