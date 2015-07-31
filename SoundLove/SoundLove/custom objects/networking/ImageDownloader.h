//
//  ImageDownloader.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 31/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageDownloader : NSObject

- (void)startDownloadingImage:(NSString*)urlString completionBlock:(void(^)(UIImage *image))completionBlock;
- (void)cancelDownload;

@end
