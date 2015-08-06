//
//  FestivalDetailLocationViewController.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "FestivalDetailBaseViewController.h"

@class WebsiteButton;

@interface FestivalDetailLocationViewController : FestivalDetailBaseViewController

@property (nonatomic, weak) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *streetLabel;
@property (nonatomic, weak) IBOutlet UILabel *postCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;
@property (nonatomic, weak) IBOutlet WebsiteButton *websiteButton;

@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postcodeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeTitleLabel;

@end
