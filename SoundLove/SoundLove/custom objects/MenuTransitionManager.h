//
//  MenuTransitionManager.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 31/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MenuTransitionManager : NSObject <UIViewControllerTransitioningDelegate>

- (void)presentMenuViewControllerOnViewController:(UIViewController*)baseController;

@end
