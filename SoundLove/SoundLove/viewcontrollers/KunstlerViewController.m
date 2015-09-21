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
#import "ConcertRefreshControl.h"
#import "TutorialPopupView.h"
#import "GeneralSettings.h"

@interface KunstlerViewController () <ArtistRecommendViewDelegate>
@property (nonatomic, strong) NSMutableArray *favoriteArtistsArray;
@property (nonatomic, strong) NSMutableArray *recommendedArtistsArray;
@property (nonatomic, strong) ArtistDownloadClient *artistDownloadClient;
@property (nonatomic, strong) ArtistRatingClient *ratingClient;
@property (nonatomic, strong) ArtistRecommendView *recommendedView;
@property (nonatomic, strong) ConcertRefreshControl *refreshController;
@property (nonatomic) BOOL recommendedTabSelected;
@end

@implementation KunstlerViewController

- (IBAction)favoriteButtonPressed:(TabbingButton*)button
{
    self.recommendedTabSelected = NO;

    [self.recommendedButton setButtonActive:NO];
    [button setButtonActive:YES];
    [self switchSubviewsToRecommend:NO];
}

- (IBAction)recommendButtonPressed:(TabbingButton*)button
{
    self.recommendedTabSelected = YES;

    if (!self.recommendedView) {
        [self createRecommendView];
    }
    
    if (self.recommendedArtistsArray.count == 0) {
        [self downloadRecommendedArtists];
    } else {
        [self loadRecommendedViewWithArtist];
    }

    [self.favoriteButton setButtonActive:NO];
    [button setButtonActive:YES];

    [self switchSubviewsToRecommend:YES];

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
                            [self.view layoutIfNeeded];
                        }];
    } else {
        [UIView transitionFromView:self.recommendedView
                            toView:self.collectionView
                          duration:0.3
                           options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished) {
                            [self.collectionView reloadData];
                        }];

    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.recommendedTabSelected) {
        [self.recommendedView layoutIfNeeded];
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
    if (!self.ratingClient) {
        self.ratingClient = [[ArtistRatingClient alloc] init];
    }

    [self.ratingClient dislikeArtist:artistModel withCompletionBlock:^(BOOL completed, NSString *errorMessage) {
        if (completed) {
            [self.recommendedArtistsArray removeLastObject];
        }

        [self loadRecommendedViewWithArtist];
    }];
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
        [self.recommendedView setEmptyViewVisible:NO];
        
        ArtistModel *artist = [self.recommendedArtistsArray lastObject];
        [self.recommendedView showViewWithArtist:artist];
    } else {
        [self.recommendedView setEmptyViewVisible:YES];
    }
}

- (NSMutableArray *)objectsToDisplay
{
    return self.favoriteArtistsArray;
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
    ArtistModel *artist = [self objectsToDisplay][indexPath.row];

    BandCollectionViewCell *cell = (BandCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (image) {
        artist.image = image;
        cell.artistImageView.image = image;
    } else {
        cell.artistImageView.image = [UIImage imageNamed:@"placeholder"];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = CGRectGetWidth(collectionView.frame)/3-10;
    return CGSizeMake(cellWidth, 160 /*MAX(130.0, cellHeight*/);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (void)loadImagesForVisibleRows
{
    NSArray *visibleRows = [self.collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexpath in visibleRows) {
        if (indexpath.row < [self objectsToDisplay].count )
        {
            BaseImageModel *object = self.objectsToDisplay[indexpath.row];
            if (!object.image) {
                [self startImageDownloadForObject:object atIndexPath:indexpath];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshController parentScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [self.refreshController parentScrollViewDidEndDragging:scrollView];
}

#pragma mark - view methods
- (void)addRefreshController
{
    self.refreshController = [[ConcertRefreshControl alloc] initWithFrame:CGRectMake(0.0, -50.0, CGRectGetWidth(self.view.frame), 50.0)];
    [self.collectionView addSubview:self.refreshController];

    [self.refreshController addTarget:self
                               action:@selector(refreshView)
                     forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];

    [self.favoriteButton setButtonActive:YES];
    [self.recommendedButton setButtonActive:NO];

    [self addRefreshController];

    [self.collectionView showLoadingIndicator];
    [self refreshView];
    [self downloadRecommendedArtists];





    [self customiseViewForFirstTime];
}

- (void)refreshView
{
    [self.refreshController startRefreshing];
    [self downloadArtists];
}

- (void)downloadArtists
{
    self.artistDownloadClient = [[ArtistDownloadClient alloc] init];

    __weak typeof(self) weakSelf = self;
    [self.artistDownloadClient downloadFavoriteArtistsWithCompletionBlock:^(NSArray *artists, BOOL completed, NSString *errorMessage) {
        [weakSelf.refreshController endRefreshing];
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
            [weakSelf.recommendedView setEmptyViewVisible:NO];
            weakSelf.recommendedArtistsArray = [artists mutableCopy];

            if (weakSelf.recommendedTabSelected) {
                [weakSelf loadRecommendedViewWithArtist];
            }
        }
    }];
}

#pragma mark - first time view
- (void)customiseViewForFirstTime
{
    [self recommendButtonPressed:nil];

    [self.favoriteButton setButtonActive:NO];
    [self.recommendedButton setButtonActive:YES];

    [self showFirstTimeGuideViewAtMiddle];
//    [self showFirstTimeGuideViewAtLeft];
//    [self showFirstTimeGuideViewAtRight];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tutorialPopupDismissed:)
                                                 name:kNotificationTutorialDismissed object:nil];
}

- (void)tutorialPopupDismissed:(NSNotification*)notification
{
    [self.recommendedView setMarkerToDefaultPoint];


}

- (void)showFirstTimeGuideViewAtMiddle
{
    CGPoint markerPoint = CGPointMake(self.recommendedView.fadeController.center.x, self.recommendedView.fadeController.center.y - 20.0);

    TutorialPopupView *tutorialView = [[TutorialPopupView alloc] init];
    [tutorialView showWithText:@"Wähle 5 Künstler die du gerne hörst, damit du loslegen kannst."
                       atPoint:markerPoint
                 highLightArea:CGRectNull
                      position:PointerPositionCenter];

    [GeneralSettings setFirstTimeMarkerMiddleShown];
}

- (void)showFirstTimeGuideViewAtRight
{
    CGPoint markerPoint = [self.recommendedView setMarkerToRightPoint];

    TutorialPopupView *tutorialView = [[TutorialPopupView alloc] init];
    [tutorialView showWithText:@"Bewege den Regler nach rechts, wenn Dir ein Künstler gefällt."
                       atPoint:markerPoint
                 highLightArea:CGRectNull
                      position:PointerPositionRight];

    [GeneralSettings setFirstTimeMarkerRightShown];
}

- (void)showFirstTimeGuideViewAtLeft
{
    CGPoint markerPoint = [self.recommendedView setMarkerToLeftPoint];

    TutorialPopupView *tutorialView = [[TutorialPopupView alloc] init];
    [tutorialView showWithText:@"Bewege den Regler nach links, wenn Dir der Künstler nicht gefällt."
                       atPoint:markerPoint
                 highLightArea:CGRectNull
                      position:PointerPositionLeft];

    [GeneralSettings setFirstTimeMarkerLeftShown];
}

@end
