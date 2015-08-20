//
//  CDFriend.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 20/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDConcert;

@interface CDFriend : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) CDConcert *concert;

@end
