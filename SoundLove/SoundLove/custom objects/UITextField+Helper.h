//
//  UITextField+Helper.h
//  TakeNote
//
//  Created by Sztanyi Szabolcs on 03/12/14.
//  Copyright (c) 2014 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   Useful textfield extensions.
 */

@interface UITextField (Helper)

/**
 *  Checks if the textfield is empty
 */
- (BOOL)isEmpty;
/**
 *  Checks if the email is valid
 */
- (BOOL)isEmailValid;

@end
