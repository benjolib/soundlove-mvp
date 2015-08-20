//
//  CDFriend+FriendHelper.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 20/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "CDFriend+FriendHelper.h"
#import "FriendObject.h"

@implementation CDFriend (FriendHelper)

- (FriendObject*)friendObject
{
    return [[FriendObject alloc] initWithName:self.name imageURL:self.imageURL userID:self.identifier];
}

@end
