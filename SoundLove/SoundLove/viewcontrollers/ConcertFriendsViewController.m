//
//  ConcertFriendsViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 05/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertFriendsViewController.h"
#import "BandCollectionViewCell.h"
#import "CustomPageControlView.h"
#import "UIColor+GlobalColors.h"
#import "ConcertDownloadClient.h"
#import "FriendObject.h"
#import "TabbingButton.h"
#import "ConcertDetailViewController.h"

@interface ConcertFriendsViewController ()
@property (nonatomic, strong) ConcertDownloadClient *friendsDownloadClient;
@property (nonatomic, strong) NSArray *friendsArray;
@end

@implementation ConcertFriendsViewController

#pragma mark - collectionView methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.friendsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    FriendObject *friend = self.friendsArray[indexPath.row];
    cell.nameLabel.text = friend.name;

    if (friend.image) {
        cell.artistImageView.image = friend.image;
    } else {
        if (!collectionView.dragging && !collectionView.decelerating) {
            [super startImageDownloadForObject:friend atIndexPath:indexPath];
        }
    }

    return cell;
}

- (void)updateTableViewCellAtIndexPath:(NSIndexPath *)indexPath image:(UIImage *)image
{
    FriendObject *friendObject = self.friendsArray[indexPath.row];

    BandCollectionViewCell *cell = (BandCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (image) {
        friendObject.image = image;
        cell.artistImageView.image = image;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return (CGRectGetWidth(collectionView.frame) - 3*100)/3;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    [self.pageControl setCurrentDotIndex:page];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wrapperView.backgroundColor = [UIColor tabbingButtonActiveColor];

    [self.collectionView showLoadingIndicator];
    __weak typeof(self) weakSelf = self;
    self.friendsDownloadClient = [[ConcertDownloadClient alloc] init];
    [self.friendsDownloadClient downloadListOfFriendsGoingToConcert:self.concertToDisplay withCompletionBlock:^(NSArray *listOfFriends, BOOL completed, NSString *errorMessage) {
        [self.collectionView hideLoadingIndicator];
        if (completed) {
            weakSelf.friendsArray = listOfFriends;
            [weakSelf setFriendsBadgeVisible];
            [weakSelf.collectionView reloadData];
            [weakSelf adjustPageControl];
        } else {
            if (errorMessage) {
                // TODO: handle error message
            }
        }
    }];
}

- (void)setFriendsBadgeVisible
{
    if ([self.parentViewController isKindOfClass:[ConcertDetailViewController class]]) {
        ConcertDetailViewController *parentVC = (ConcertDetailViewController*)self.parentViewController;
        [parentVC.friendsButton showBadgeWithValue:self.friendsArray.count];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self adjustPageControl];
}

- (void)adjustPageControl
{
    NSInteger numberOfScreens = self.collectionView.contentSize.width / CGRectGetWidth(self.view.frame);
    if (numberOfScreens <= 1) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
        [self.pageControl setNumberOfDots:numberOfScreens];
        [self.pageControl setCurrentDotIndex:0];
    }
}

@end
