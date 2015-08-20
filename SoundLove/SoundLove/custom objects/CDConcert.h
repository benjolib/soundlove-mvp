//
//  CDConcert.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 20/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDConcertImage, CDConcertLocation;

@interface CDConcert : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * concertID;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * sectionTitle;
@property (nonatomic, retain) CDConcertImage *image;
@property (nonatomic, retain) CDConcertLocation *location;
@property (nonatomic, retain) NSSet *friends;
@end

@interface CDConcert (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(NSManagedObject *)value;
- (void)removeFriendsObject:(NSManagedObject *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

@end
