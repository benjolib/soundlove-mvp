//
//  WebsiteButton.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 09/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "WebsiteButton.h"
#import "UIFont+LatoFonts.h"

@implementation WebsiteButton

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.titleLabel.font = [UIFont latoBoldFontWithSize:16.0];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    [titleString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [titleString length])];
    [self setAttributedTitle:titleString forState:UIControlStateNormal];

    NSMutableAttributedString *highlightedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    [highlightedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [highlightedString length])];
    [highlightedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1.0 alpha:0.6] range:NSMakeRange(0, [highlightedString length])];
    [self setAttributedTitle:highlightedString forState:UIControlStateHighlighted];
}

@end
