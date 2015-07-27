//
//  TutorialPopupView.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kNotificationTutorialDismissed = @"kTutorialDismissed";

@interface TutorialPopupView : UIView

@property (nonatomic, weak) IBOutlet UIButton *actionButton;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UIView *separatorView;

- (void)showWithText:(NSString*)text atPoint:(CGPoint)point highLightArea:(CGRect)highlightedArea;

@end
