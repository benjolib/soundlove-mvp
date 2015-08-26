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
- (void)logoutUser;

+ (BOOL)isUserLoggedInToFacebook;
+ (NSString*)currentUserAccessToken;
+ (NSString*)currentUserID;

- (void)refreshFacebookAccessTokenCompletionBlock:(void (^)(BOOL completed))completionBlock;
- (void)sendFacebookLoginDataToServerWithCompletionBlock:(void (^)(BOOL completed, NSString *errorMessage))completionBlock;

@end
