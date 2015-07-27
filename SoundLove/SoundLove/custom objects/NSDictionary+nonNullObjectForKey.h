//
//  NSDictionary+nonNullObjectForKey.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 15/12/14.
//  Copyright (c) 2014 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Helper method for dictionaries, to avoid crashes when parsing
 */

@interface NSDictionary (nonNullObjectForKey)

- (id)nonNullObjectForKey:(id)key;

@end
