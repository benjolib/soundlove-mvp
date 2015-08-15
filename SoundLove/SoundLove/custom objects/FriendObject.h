//
//  FriendObject.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendObject : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *userID;

+ (FriendObject*)friendObjectWithDictionary:(NSDictionary*)dictionary;
- (instancetype)initWithName:(NSString*)name imageURL:(NSString*)imageURL userID:(NSString*)userID;

@end
