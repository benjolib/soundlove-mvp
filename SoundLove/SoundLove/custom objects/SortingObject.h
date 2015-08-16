//
//  SortingObject.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SortingType) {
    SortingTypeNone,
    SortingTypePreisASC,
    SortingTypePreisDESC,
    SortingTypeDateASC,
    SortingTypeDateDESC
};

@interface SortingObject : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *orderDir;
@property (nonatomic) SortingType sortingType;

+ (SortingObject*)sortingWithType:(SortingType)sortingType;

- (BOOL)isAscending;

@end
