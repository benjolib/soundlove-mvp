//
//  TicketShopTableViewCell.h
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketShopTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *textfield;
@property (nonatomic, weak) IBOutlet UIImageView *checkmarkView;

- (void)setFieldIsValid:(BOOL)valid;
- (void)setTextFieldPlaceholderText:(NSString*)text;

- (BOOL)isFieldEmpty;
- (BOOL)isEmailValid;

@end
