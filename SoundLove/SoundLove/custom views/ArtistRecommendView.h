//
//  ArtistRecommendView.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 15/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtistModel;

@protocol ArtistRecommendViewDelegate <NSObject>

- (void)artistRecommendViewFadeOutSelected:(ArtistModel*)artistModel;
- (void)artistRecommendViewFadeInSelected:(ArtistModel*)artistModel;

@end

@interface ArtistRecommendView : UIView

@property (nonatomic, weak) id <ArtistRecommendViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *fadeLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *fadeController;
@property (nonatomic, weak) IBOutlet UIImageView *fadeControlBackgroundView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *fadeControllerCenterXConstraint;
@property (nonatomic, weak) IBOutlet UIView *emptyView;

// circle view
@property (nonatomic, weak) IBOutlet UIView *circleBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *imageWrapperView;
@property (nonatomic, weak) IBOutlet UIImageView *artistImageView;
@property (nonatomic, weak) IBOutlet UIView *middleCircleView;
@property (nonatomic, weak) IBOutlet UIView *middleSmallCircleView;
@property (nonatomic, weak) IBOutlet UIView *middleDotCircleView;

- (void)showViewWithArtist:(ArtistModel*)artist;

- (void)setEmptyViewVisible:(BOOL)visible;

@end
