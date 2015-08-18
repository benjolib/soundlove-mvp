//
//  ConcertFriendsViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 05/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertDetailBaseViewController.h"
#import "LoadingCollectionView.h"

@class CustomPageControlView;

@interface ConcertFriendsViewController : ConcertDetailBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UIView *wrapperView;
@property (nonatomic, weak) IBOutlet LoadingCollectionView *collectionView;
@property (nonatomic, weak) IBOutlet CustomPageControlView *pageControl;
@property (nonatomic, weak) IBOutlet UILabel *emptyViewLabel;

@end
