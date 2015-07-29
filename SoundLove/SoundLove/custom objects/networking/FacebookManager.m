//
//  FacebookManager.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FacebookManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation FacebookManager

- (void)loginUserToFacebookWithCompletion:(void (^)(BOOL completed, NSString *errorMessage))completionBlock
{
    if ([FacebookManager isUserLoggedInToFacebook])
    {
        if (completionBlock) {
            completionBlock(YES, nil);
        }
    }
    else
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                // Process error
                if (completionBlock) {
                    completionBlock(NO, error.localizedDescription);
                }
            } else if (result.isCancelled) {
                // Handle cancellations
                if (completionBlock) {
                    completionBlock(NO, nil);
                }
            } else {
                if (completionBlock) {
                    completionBlock(YES, nil);
                }
//                // If you ask for multiple permissions at once, you
//                // should check if specific permissions missing
//                if ([result.grantedPermissions containsObject:@"email"]) {
//                    // Do work
//                }
            }
        }];
    }
}

+ (BOOL)isUserLoggedInToFacebook
{
    return [FBSDKAccessToken currentAccessToken];
}

@end
