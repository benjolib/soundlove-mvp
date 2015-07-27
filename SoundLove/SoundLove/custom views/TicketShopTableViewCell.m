//
//  TicketShopTableViewCell.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "TicketShopTableViewCell.h"
#import "UITextField+Helper.h"
#import "UIColor+GlobalColors.h"

@implementation TicketShopTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.textfield.textColor = [UIColor globalGreenColor];
    self.textfield.tintColor = [UIColor globalGreenColor];
}

- (void)setTextFieldPlaceholderText:(NSString*)text
{
    self.textfield.placeholder = text;
    self.textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text
                                                                           attributes:@{NSFontAttributeName:self.textfield.font, NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:0.5]}];
}

- (void)setFieldIsValid:(BOOL)valid
{
//    self.checkmarkView.image = valid ? [UIImage imageNamed:@"checkMarkIcon"] : nil;
}

- (BOOL)isFieldEmpty
{
    return [self.textfield isEmpty];
}

- (BOOL)isEmailValid
{
    return [self.textfield isEmailValid];
}

@end
