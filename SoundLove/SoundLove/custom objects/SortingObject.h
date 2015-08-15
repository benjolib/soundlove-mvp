//
//  SortingObject.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortingObject : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *orderDir;

+ (SortingObject*)sortingWithName:(NSString*)name andKey:(NSString*)key orderDir:(NSString*)orderDir;

@end
