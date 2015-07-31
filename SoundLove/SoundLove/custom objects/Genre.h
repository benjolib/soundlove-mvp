//
//  Genre.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Genre : NSObject

@property (nonatomic, copy) NSString *name;

+ (Genre*)genreWithName:(NSString*)name;
+ (NSArray*)genresFromArray:(NSArray*)array;

@end
