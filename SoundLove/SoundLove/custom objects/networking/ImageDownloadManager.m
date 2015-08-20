//
//  ImageDownloadManager.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 20/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ImageDownloadManager.h"
#import "ImageDownloader.h"

@interface ImageDownloadManager ()
@property (nonatomic, strong) NSMutableArray *imageDownloaders;
@property (nonatomic, strong) NSMutableArray *downloadedImagesArray;
@property (nonatomic) NSInteger failedImageDownloadCount;
@property (nonatomic, copy) void(^completionBlock)(NSArray *downloadedImagesArray);
@end

@implementation ImageDownloadManager

- (NSMutableArray*)downloadedImagesArray
{
    if (!_downloadedImagesArray) {
        _downloadedImagesArray = [NSMutableArray array];
    }

    return _downloadedImagesArray;
}

- (void)startDownloadingImagesWithCompletionBlock:(void(^)(NSArray *downloadedImagesArray))completionBlock
{
    if (completionBlock) {
        self.completionBlock = completionBlock;
    }

    self.imageDownloaders = [NSMutableArray array];
    for (NSString *imageURL in self.imageURLsToDownload) {
        [self downloadImage:imageURL];
    }
}

- (void)downloadImage:(NSString*)imageURL
{
    __weak typeof(self) weakSelf = self;

    ImageDownloader *imageDownloader = [ImageDownloader new];
    [imageDownloader startDownloadingImage:imageURL completionBlock:^(UIImage *image) {
        if (image) {
            [weakSelf.downloadedImagesArray addObject:image];
        } else {
            weakSelf.failedImageDownloadCount++;
        }
        [weakSelf.imageDownloaders removeObject:imageDownloader];

        if ((weakSelf.downloadedImagesArray.count == weakSelf.imageURLsToDownload.count) || (weakSelf.downloadedImagesArray.count + weakSelf.failedImageDownloadCount == weakSelf.imageURLsToDownload.count)) {
            weakSelf.completionBlock(weakSelf.downloadedImagesArray);
        }
    }];

    [self.imageDownloaders addObject:imageDownloader];
}

@end
