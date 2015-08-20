//
//  ImageDownloadManager.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 20/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloadManager : NSObject

@property (nonatomic, strong) NSArray *imageURLsToDownload;

- (void)startDownloadingImagesWithCompletionBlock:(void(^)(NSArray *downloadedImagesArray))completionBlock;

@end
