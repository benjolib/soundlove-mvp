//
//  FilterTableViewCell.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 01/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

- (void)setCellActive:(BOOL)active;

@end
