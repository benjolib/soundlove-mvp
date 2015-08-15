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

@interface ConcertFriendsViewController ()
@property (nonatomic, strong) ConcertDownloadClient *friendsDownloadClient;
@property (nonatomic, strong) NSArray *friendsArray;
@end

@implementation ConcertFriendsViewController

#pragma mark - collectionView methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30; //self.bandsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (CGRectGetWidth(collectionView.frame) - 40.0)/3;
    return CGSizeMake(width, width);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10.0;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
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
            [weakSelf.collectionView reloadData];
            [weakSelf adjustPageControl];
        } else {
            if (errorMessage) {
                // TODO: handle error message
            }
        }
    }];
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
