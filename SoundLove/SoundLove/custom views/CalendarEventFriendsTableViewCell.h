//
//  CalendarEventFriendsTableViewCell.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 19/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertsTableViewCell.h"

@interface CalendarEventFriendsTableViewCell : ConcertsTableViewCell

@property (nonatomic, weak) IBOutlet UIView *friendsWrapperView;
@property (nonatomic, weak) IBOutlet UIView *additionalFriendsCircleView;
@property (nonatomic, weak) IBOutlet UILabel *additionalFriendsLabel;

@property (nonatomic, weak) IBOutlet UIImageView *firstImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondImageView;
@property (nonatomic, weak) IBOutlet UIImageView *thirdImageView;
@property (nonatomic, weak) IBOutlet UIImageView *fourthImageView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *firstImageViewWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *secondImageViewWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *thirdImageViewWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *fourthImageViewWidthConstraint;

- (void)adjustFriendsViewWithFriends:(NSArray*)friendsArray;

- (void)applyImages:(NSArray*)imagesArray;

@end
