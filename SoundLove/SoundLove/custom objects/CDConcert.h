//
//  CDConcert.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 01/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface CDConcert : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * concertID;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * sectionTitle;
@property (nonatomic, retain) NSManagedObject *image;

@end
