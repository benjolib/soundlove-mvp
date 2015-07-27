//
//  UITextField+Helper.m
//  TakeNote
//
//  Created by Sztanyi Szabolcs on 03/12/14.
//  Copyright (c) 2014 Sztanyi Szabolcs. All rights reserved.
//

#import "UITextField+Helper.h"

@implementation UITextField (Helper)

- (BOOL)isEmpty
{
    return self.text.length == 0;
}

- (BOOL)isEmailValid
{
    if ([self.text length] == 0)
    {
        return NO;
    }

    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:self.text options:0 range:NSMakeRange(0, [self.text length])];

    return (regExMatches != 0);
}

@end
