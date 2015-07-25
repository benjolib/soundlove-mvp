//
//  ConcertsTableViewCell.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 25/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarButton.h"

@interface ConcertsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *concertTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@property (nonatomic, weak) IBOutlet UIImageView *concertImageView;
@property (nonatomic, weak) IBOutlet CalendarButton *calendarButton;



@end
