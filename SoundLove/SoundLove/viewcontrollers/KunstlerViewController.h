//
//  BandsViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ImageDownloadBaseViewController.h"

@class CustomNavigationView, LoadingCollectionView, TabbingButton;

@interface BandsViewController : ImageDownloadBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet TabbingButton *favoriteButton;
@property (nonatomic, weak) IBOutlet TabbingButton *recommendedButton;
@property (nonatomic, weak) IBOutlet LoadingCollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIView *wrapperView;

- (IBAction)favoriteButtonPressed:(TabbingButton*)button;
- (IBAction)recommendButtonPressed:(TabbingButton*)button;

@end
