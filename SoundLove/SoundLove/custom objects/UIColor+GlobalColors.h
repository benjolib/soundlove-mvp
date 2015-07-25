//
//  UIColor+GlobalColors.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 22/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GlobalColors)

+ (UIColor*)globalGreenColor;
+ (UIColor*)globalGreenColorWithAlpha:(CGFloat)alpha;
+ (UIColor*)darkGreenButtonTitleColor;
+ (UIColor*)navigationBarBackgroundColor;

+ (UIColor*)menuButtonSelectedColor;
+ (UIColor*)menuButtonDeselectedColor;

+ (UIColor*)gradientTopColor;
+ (UIColor*)gradientBottomColor;

+ (UIColor*)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue;
+ (UIColor*)tabbingButtonInactiveColor;
+ (UIColor*)tabbingButtonActiveColor;

@end
