//
//  CDConcertImage.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 01/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDConcert;

@interface CDConcertImage : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) CDConcert *concert;

@end
