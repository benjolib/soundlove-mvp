//
//  BandsViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"

@class TabbingButton;

@interface BandsViewController : BaseGradientViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet TabbingButton *favoriteButton;
@property (nonatomic, weak) IBOutlet TabbingButton *recommendedButton;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (IBAction)favoriteButtonPressed:(TabbingButton*)button;
- (IBAction)recommendButtonPressed:(TabbingButton*)button;

@end
