//
//  ArtistRecommendView.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 15/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ArtistRecommendView.h"
#import "ArtistModel.h"
#import "ImageDownloader.h"

@interface ArtistRecommendView ()
@property (nonatomic, strong) ArtistModel *artistModel;
@property (nonatomic, strong) ImageDownloader *imageDownloader;
@end

@implementation ArtistRecommendView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"ArtistRecommendView" owner:nil options:nil];
        for (id object in bundle) {
            if ([object isKindOfClass:[ArtistRecommendView class]]) {
                self = object;
                break;
            }
        }
        [self setupFadeController];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.circleBackgroundView.layer.cornerRadius = CGRectGetHeight(self.circleBackgroundView.frame)/2;
    self.imageWrapperView.layer.cornerRadius = CGRectGetHeight(self.imageWrapperView.frame)/2;
    self.middleCircleView.layer.cornerRadius = CGRectGetHeight(self.middleCircleView.frame)/2;
    self.middleSmallCircleView.layer.cornerRadius = CGRectGetHeight(self.middleSmallCircleView.frame)/2;
    self.middleDotCircleView.layer.cornerRadius = CGRectGetHeight(self.middleDotCircleView.frame)/2;

    self.artistNameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.artistNameLabel.frame);
    [self layoutIfNeeded];
}

- (void)setEmptyViewVisible:(BOOL)visible
{
    if (visible) {
        self.artistNameLabel.text = @"";
        self.artistImageView.image = nil;
    }
    self.emptyView.hidden = !visible;
}

- (void)showViewWithArtist:(ArtistModel*)artist
{
    self.artistModel = artist;
    self.artistNameLabel.text = self.artistModel.name;

    self.artistImageView.image = nil;

    if (self.artistModel.imageURL.length > 0)
    {
        self.imageDownloader = [[ImageDownloader alloc] init];
        [self.imageDownloader startDownloadingImage:self.artistModel.imageURL completionBlock:^(UIImage *image) {
            if (image) {
                self.artistImageView.image = image;
                self.artistModel.image = image;
            }

            [self layoutIfNeeded];
        }];
    }
}

- (void)setupFadeController
{
    UIPanGestureRecognizer *panrecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fadeControllerPanned:)];
    [self.fadeController addGestureRecognizer:panrecognizer];
}

- (void)fadeControllerPanned:(UIPanGestureRecognizer*)panRecognizer
{
    switch (panRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint locationPoint = [panRecognizer locationInView:self.fadeControlBackgroundView];
            if (locationPoint.x <= 10.0) {
                return;
            }
            if (locationPoint.x >= CGRectGetWidth(self.fadeControlBackgroundView.frame)-10.0) {
                return;
            }
            self.fadeControllerCenterXConstraint.constant = [panRecognizer translationInView:self.fadeController].x;
        }
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (self.fadeControllerCenterXConstraint.constant < 30.0) {
                if ([self.delegate respondsToSelector:@selector(artistRecommendViewFadeOutSelected:)]) {
                    [self.delegate artistRecommendViewFadeOutSelected:self.artistModel];
                }
            } else if (self.fadeControllerCenterXConstraint.constant >= CGRectGetWidth(self.fadeControlBackgroundView.frame)/2-30.0) {
                if ([self.delegate respondsToSelector:@selector(artistRecommendViewFadeInSelected:)]) {
                    [self.delegate artistRecommendViewFadeInSelected:self.artistModel];
                }
            }

            self.fadeControllerCenterXConstraint.constant = 0.0;
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
            }];
        }
            break;
        default:
            break;
    }
}

@end
