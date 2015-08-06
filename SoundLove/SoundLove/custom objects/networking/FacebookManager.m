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

@interface FacebookManager ()
@property (nonatomic, strong) FBSDKLoginManager *loginManager;
@end

@implementation FacebookManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loginManager = [[FBSDKLoginManager alloc] init];
    }
    return self;
}

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
        [self.loginManager logInWithReadPermissions:@[@"email", @"public_profile", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
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

                NSString *userID = result.token.userID;
                NSString *accessToken = result.token.tokenString;

                [FBSDKAccessToken setCurrentAccessToken:result.token];
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

- (void)logoutUser
{
    [self.loginManager logOut];
}

#pragma mark - class methods
+ (NSString*)currentUserID
{
    return [FBSDKAccessToken currentAccessToken].userID;
}

+ (NSString*)currentUserAccessToken
{
    return [FBSDKAccessToken currentAccessToken].tokenString;
}

+ (BOOL)isUserLoggedInToFacebook
{
    return [FBSDKAccessToken currentAccessToken];
}

@end
