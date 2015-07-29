//
//  CalendarEventTableViewCell.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ConcertsTableViewCell.h"

@class CalendarEventTableViewCell, BasicButton;

@protocol CalendarEventTableViewCellDelegate <NSObject>

- (void)cellDidOpen:(CalendarEventTableViewCell*)cell;
- (void)cellDidClose:(CalendarEventTableViewCell*)cell;

@end

@interface CalendarEventTableViewCell : ConcertsTableViewCell

@property (nonatomic, weak) id <CalendarEventTableViewCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet BasicButton *trashButton;
@property (nonatomic, weak) IBOutlet BasicButton *shareButton;
@property (nonatomic, weak) IBOutlet UIView *slidingView;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

- (void)openCell;

@end
