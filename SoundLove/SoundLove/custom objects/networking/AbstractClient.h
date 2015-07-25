//
//  AbstractClient.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConstants.h"

@interface AbstractClient : NSObject

- (NSURLSessionConfiguration*)defaultSessionConfiguration;

- (void)startDataTaskWithRequest:(NSURLRequest*)request forSession:(NSURLSession*)session withCompletionBlock:(void (^)(NSData *data, NSString *errorMessage, BOOL completed))completionBlock;

@end
