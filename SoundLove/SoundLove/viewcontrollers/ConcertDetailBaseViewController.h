//
//  FestivalDetailBaseViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 09/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConcertModel.h"

@interface ConcertDetailBaseViewController : UIViewController

@property (nonatomic, weak) ConcertModel *concertToDisplay;

- (void)refreshView;

- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)ticketShopButtonPressed:(id)sender;

@end
