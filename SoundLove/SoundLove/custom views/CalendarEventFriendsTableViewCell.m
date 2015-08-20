//
//  CalendarEventFriendsTableViewCell.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 19/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "CalendarEventFriendsTableViewCell.h"
#import "UIColor+GlobalColors.h"

#define kMaxImagesToDisplay 4

@implementation CalendarEventFriendsTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.additionalFriendsCircleView.layer.cornerRadius = CGRectGetHeight(self.additionalFriendsCircleView.frame)/2;
    self.additionalFriendsCircleView.layer.borderColor = [UIColor colorWithR:145.0 G:222.0 B:184.0].CGColor;
    self.additionalFriendsCircleView.layer.borderWidth = 1.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.additionalFriendsCircleView.layer.cornerRadius = CGRectGetHeight(self.additionalFriendsCircleView.frame)/2;

    self.firstImageView.layer.cornerRadius = CGRectGetHeight(self.firstImageView.frame)/2;
    self.secondImageView.layer.cornerRadius = CGRectGetHeight(self.secondImageView.frame)/2;
    self.thirdImageView.layer.cornerRadius = CGRectGetHeight(self.thirdImageView.frame)/2;
    self.fourthImageView.layer.cornerRadius = CGRectGetHeight(self.fourthImageView.frame)/2;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.firstImageView.image = nil;
    self.secondImageView.image = nil;
    self.thirdImageView.image = nil;
    self.fourthImageView.image = nil;

    self.firstImageViewWidthConstraint.constant = 30.0;
    self.secondImageViewWidthConstraint.constant = 30.0;
    self.thirdImageViewWidthConstraint.constant = 30.0;
    self.fourthImageViewWidthConstraint.constant = 30.0;

    [self layoutIfNeeded];
}

- (void)adjustFriendsViewWithFriends:(NSArray*)friendsArray
{
    NSInteger friendsCount = friendsArray.count;

    if (friendsCount > 0)
    {
        if (friendsCount > kMaxImagesToDisplay) {
            NSInteger additionalFriendsCount = friendsCount - 4;
            self.additionalFriendsLabel.text = [NSString stringWithFormat:@"+%ld", (long)additionalFriendsCount];
        }

        if (friendsCount == 1) {
            self.secondImageViewWidthConstraint.constant = 0.0;
            self.thirdImageViewWidthConstraint.constant = 0.0;
            self.fourthImageViewWidthConstraint.constant = 0.0;
            [self layoutIfNeeded];
        } else if (friendsCount == 2) {
            self.thirdImageViewWidthConstraint.constant = 0.0;
            self.fourthImageViewWidthConstraint.constant = 0.0;
            [self layoutIfNeeded];
        } else if (friendsCount == 3) {
            self.fourthImageViewWidthConstraint.constant = 0.0;
            [self layoutIfNeeded];
        } else if (friendsCount == 4) {
            self.additionalFriendsCircleView.hidden = YES;
            [self layoutIfNeeded];
        }
    }
    else
    {
        self.firstImageViewWidthConstraint.constant = 0.0;
        self.secondImageViewWidthConstraint.constant = 0.0;
        self.thirdImageViewWidthConstraint.constant = 0.0;
        self.fourthImageViewWidthConstraint.constant = 0.0;

        [self layoutIfNeeded];
        self.additionalFriendsLabel.text = @"0";
    }
}

- (void)applyImages:(NSArray*)imagesArray
{
    NSArray *subArray = [imagesArray subarrayWithRange:NSMakeRange(0, kMaxImagesToDisplay)];

    NSInteger arrayCount = subArray.count;

    if (arrayCount == 1) {
        self.firstImageView.image = subArray.firstObject;
    } else if (arrayCount == 2) {
        self.firstImageView.image = subArray.firstObject;
        self.secondImageView.image = subArray[1];
    } else if (arrayCount == 3) {
        self.firstImageView.image = subArray.firstObject;
        self.secondImageView.image = subArray[1];
        self.thirdImageView.image = subArray[2];
    } else {
        self.firstImageView.image = subArray.firstObject;
        self.secondImageView.image = subArray[1];
        self.thirdImageView.image = subArray[2];
        self.fourthImageView.image = subArray[3];
    }
}

@end
