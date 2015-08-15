//
//  BandCollectionViewCell.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BandCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *artistImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end
