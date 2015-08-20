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
#import "AbstractClient.h"

@interface FacebookLoginClient : AbstractClient
- (void)sendFacebookLoginDataToServer:(NSString*)accessToken userID:(NSString*)userID completionBlock:(void (^)(BOOL completed, NSString *errorMessage))completionBlock;
@end

@implementation FacebookLoginClient

- (void)sendFacebookLoginDataToServer:(NSString*)accessToken userID:(NSString*)userID completionBlock:(void (^)(BOOL completed, NSString *errorMessage))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@access_token=%@&user_id=%@", kFacebookConnectURL, [FacebookManager currentUserAccessToken], userID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(completed, errorMessage);
            });
        }
    }];
}

@end



@interface FacebookManager ()
@property (nonatomic, strong) FBSDKLoginManager *loginManager;
@property (nonatomic, strong) FacebookLoginClient *facebookLoginClient;
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
        __weak typeof(self) weakSelf = self;
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

                [weakSelf sendFacebookLoginDataToServer:accessToken userID:userID completionBlock:completionBlock];
            }
        }];
    }
}

- (void)logoutUser
{
    [self.loginManager logOut];
}

#pragma mark - server login
- (void)sendFacebookLoginDataToServer:(NSString*)accessToken userID:(NSString*)userID completionBlock:(void (^)(BOOL completed, NSString *errorMessage))completionBlock
{
    if (self.facebookLoginClient) {
        self.facebookLoginClient = nil;
    }
    self.facebookLoginClient = [[FacebookLoginClient alloc] init];
    [self.facebookLoginClient sendFacebookLoginDataToServer:accessToken userID:userID completionBlock:completionBlock];
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
    return [FBSDKAccessToken currentAccessToken].tokenString.length != 0;
}

@end
