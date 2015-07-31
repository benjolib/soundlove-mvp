//
//  Band.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 02/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Band : NSObject

@property (nonatomic, copy) NSString *name;

+ (Band*)bandWithName:(NSString*)name;

+ (NSArray*)bandsArrayFromStringArray:(NSArray*)array;

@end
