//
//  FacebookManager.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookManager : NSObject

- (void)loginUserToFacebookWithCompletion:(void (^)(BOOL completed, NSString *errorMessage))completionBlock;

+ (BOOL)isUserLoggedInToFacebook;

@end
