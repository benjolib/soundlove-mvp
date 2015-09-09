//
//  ImageDownloader.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 31/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader ()
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@end

@implementation ImageDownloader

- (void)startDownloadingImage:(NSString*)urlString completionBlock:(void(^)(UIImage *image))completionBlock
{
    NSURL *url = [NSURL URLWithString:urlString];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

//    NSLog(@"URL for image loading: %@", urlString);

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if (completionBlock) {
                    completionBlock(image);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if (completionBlock) {
                    completionBlock(nil);
                }
            });
        }
    }];

    [self.downloadTask resume];
}

- (void)cancelDownload
{
    [self.downloadTask cancel];
    self.downloadTask = nil;
}

@end
