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

@interface BandsViewController ()
@property (nonatomic, strong) NSMutableArray *bandsArray;
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

#pragma mark - collectionView methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10; //self.bandsArray.count;
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
}

@end
