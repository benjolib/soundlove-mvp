//
//  WebsiteButton.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 09/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "WebsiteButton.h"

@implementation WebsiteButton

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    [titleString addAttribute:NSForegroundColorAttributeName value:self.titleLabel.textColor range:NSMakeRange(0, [titleString length])];
    [self setAttributedTitle:titleString forState:UIControlStateNormal];

    NSMutableAttributedString *highlightedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    [highlightedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [highlightedString length])];
    [highlightedString addAttribute:NSForegroundColorAttributeName value:[self.titleLabel.textColor colorWithAlphaComponent:0.6] range:NSMakeRange(0, [highlightedString length])];
    [self setAttributedTitle:highlightedString forState:UIControlStateHighlighted];
}

@end
