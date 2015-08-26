//
//  BandsViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "KunstlerViewController.h"
#import "TabbingButton.h"
#import "BandCollectionViewCell.h"
#import "CustomNavigationView.h"
#import "ArtistDownloadClient.h"
#import "LoadingCollectionView.h"
#import "ArtistModel.h"
#import "ArtistRecommendView.h"
#import "ArtistRatingClient.h"

@interface KunstlerViewController () <ArtistRecommendViewDelegate>
@property (nonatomic, strong) NSMutableArray *favoriteArtistsArray;
@property (nonatomic, strong) NSMutableArray *recommendedArtistsArray;
@property (nonatomic, strong) ArtistDownloadClient *artistDownloadClient;
@property (nonatomic, strong) ArtistRatingClient *ratingClient;
@property (nonatomic, strong) ArtistRecommendView *recommendedView;
@end

@implementation KunstlerViewController

- (IBAction)favoriteButtonPressed:(TabbingButton*)button
{
    [self.recommendedButton setButtonActive:NO];
    [button setButtonActive:YES];
    [self switchSubviewsToRecommend:NO];
}

- (IBAction)recommendButtonPressed:(TabbingButton*)button
{
    if (self.recommendedArtistsArray.count == 0) {
        [self downloadRecommendedArtists];
    }

    [self.favoriteButton setButtonActive:NO];
    [button setButtonActive:YES];

    if (!self.recommendedView) {
        [self createRecommendView];
    }
    [self switchSubviewsToRecommend:YES];

    [self loadRecommendedViewWithArtist];

    [self.recommendedView setEmptyViewVisible:self.recommendedArtistsArray.count == 0];
}

- (void)switchSubviewsToRecommend:(BOOL)displayRecommendView
{
    if (displayRecommendView) {
        [UIView transitionFromView:self.collectionView
                            toView:self.recommendedView
                          duration:0.3
                           options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished) {
                            self.recommendedView.alpha = 1.0;
                            [self.recommendedView setNeedsLayout];
                        }];
    } else {
        [UIView transitionFromView:self.recommendedView
                            toView:self.collectionView
                          duration:0.3
                           options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished) {
                            [self downloadArtists];
                        }];

    }
}

#pragma mark - recommend view methods
- (void)createRecommendView
{
    self.recommendedView = [[ArtistRecommendView alloc] init];
    self.recommendedView.translatesAutoresizingMaskIntoConstraints = NO;
    self.recommendedView.delegate = self;
    [self.wrapperView addSubview:self.recommendedView];
    self.recommendedView.alpha = 0.0;

    [self.wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:self.wrapperView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.recommendedView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:self.wrapperView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.recommendedView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self.wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:self.wrapperView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.recommendedView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:self.wrapperView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.recommendedView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
}

- (void)artistRecommendViewFadeOutSelected:(ArtistModel *)artistModel
{
    [self.recommendedArtistsArray removeLastObject];
    [self loadRecommendedViewWithArtist];
}

- (void)artistRecommendViewFadeInSelected:(ArtistModel *)artistModel
{
    if (!self.ratingClient) {
        self.ratingClient = [[ArtistRatingClient alloc] init];
    }

    [self.ratingClient likeArtist:artistModel withCompletionBlock:^(BOOL completed, NSString *errorMessage) {
        if (completed) {
            [self.recommendedArtistsArray removeLastObject];
        }

        [self loadRecommendedViewWithArtist];
    }];
}

- (void)loadRecommendedViewWithArtist
{
    if (self.recommendedArtistsArray.count > 0) {
        ArtistModel *artist = [self.recommendedArtistsArray lastObject];
        [self.recommendedView showViewWithArtist:artist];
    } else {
        [self downloadRecommendedArtists];
    }
}

#pragma mark - collectionView methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.favoriteArtistsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    ArtistModel *artist = [self.favoriteArtistsArray objectAtIndex:indexPath.row];
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
    ArtistModel *artist = self.favoriteArtistsArray[indexPath.row];

    BandCollectionViewCell *cell = (BandCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (image) {
        artist.image = image;
        cell.artistImageView.image = image;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = CGRectGetWidth(collectionView.frame)/3-10;
    CGFloat cellHeight = cellWidth;
    return CGSizeMake(cellWidth, MAX(130.0, cellHeight));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
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

//    self.favoriteArtistsArray = [[self createFakeFriends] mutableCopy];
//    [self.collectionView reloadData];
//    [self.collectionView hideLoadingIndicator];

    [self downloadArtists];

    [self downloadRecommendedArtists];
}

- (NSArray*)createFakeFriends
{
    NSMutableArray *friendsTempArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [friendsTempArray addObject:[ArtistModel artistWithName:@"John Magenta" imageURL:@"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/v/t1.0-1/p50x50/10603588_102209476787153_6748298543344698984_n.jpg?oh=6bc4c78d9f568041cd48e06b91fbdf20&oe=56782B82&__gda__=1450349470_68e004032853bc5f3b469a5a8538ce6b"]];
    }
    return friendsTempArray;
}

- (void)downloadArtists
{
    self.artistDownloadClient = [[ArtistDownloadClient alloc] init];

    __weak typeof(self) weakSelf = self;
    [self.artistDownloadClient downloadFavoriteArtistsWithCompletionBlock:^(NSArray *artists, BOOL completed, NSString *errorMessage) {
        if (errorMessage) {
            [weakSelf.collectionView showEmptyKunstlerFavoriteView];
        } else {
            weakSelf.favoriteArtistsArray = [artists copy];
            [weakSelf.collectionView hideLoadingIndicator];
            if (weakSelf.favoriteArtistsArray.count == 0) {
                [weakSelf.collectionView showEmptyKunstlerFavoriteView];
            } else {
                [weakSelf.collectionView hideEmptyView];
                [weakSelf.collectionView reloadData];
            }
        }
    }];
}

- (void)downloadRecommendedArtists
{
    if (!self.artistDownloadClient) {
        self.artistDownloadClient = [[ArtistDownloadClient alloc] init];
    }

    __weak typeof(self) weakSelf = self;
    [self.artistDownloadClient downloadRecommendedArtistsWithCompletionBlock:^(NSArray *artists, BOOL completed, NSString *errorMessage) {
        if (errorMessage) {
            [weakSelf.recommendedView setEmptyViewVisible:YES];
        } else {
            weakSelf.recommendedArtistsArray = [artists mutableCopy];
        }
    }];
}

@end
