//
//  FriendObject.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FriendObject.h"
#import "NSDictionary+nonNullObjectForKey.h"

@implementation FriendObject

- (instancetype)initWithName:(NSString*)name imageURL:(NSString*)imageURL userID:(NSString*)userID
{
    self = [super init];
    if (self) {
        self.name = name;
        self.imageURL = imageURL;
        self.userID = userID;
    }
    return self;
}

+ (FriendObject*)friendObjectWithDictionary:(NSDictionary*)dictionary
{
    NSString *name = [dictionary nonNullObjectForKey:@"name"];
    NSString *imageURL = [dictionary nonNullObjectForKey:@"picture"];
    NSString *userID = [dictionary nonNullObjectForKey:@"id"];

    FriendObject *friendObject = [[FriendObject alloc] initWithName:name imageURL:imageURL userID:userID];
    return friendObject;
}

@end
