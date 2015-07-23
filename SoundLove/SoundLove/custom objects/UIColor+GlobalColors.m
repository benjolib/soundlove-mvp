//
//  UIColor+GlobalColors.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 22/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "UIColor+GlobalColors.h"

#define RGB(r, g, b) [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: 1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: a]

@implementation UIColor (GlobalColors)

+ (UIColor*)globalGreenColor
{
    return [self globalGreenColorWithAlpha:1.0];
}

+ (UIColor*)globalGreenColorWithAlpha:(CGFloat)alpha
{
    return RGBA(142.0, 223.0, 183.0, alpha);
}

+ (UIColor*)darkGreenButtonTitleColor
{
    return RGB(23.0, 26.0, 38.0);
}

@end
