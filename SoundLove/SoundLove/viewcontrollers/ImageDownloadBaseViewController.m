//
//  ImageDownloadBaseViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 31/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "ImageDownloadBaseViewController.h"
#import "LoadingTableView.h"
#import "BaseImageModel.h"
#import "ImageDownloader.h"
#import "NSDictionary+nonNullObjectForKey.h"

@interface ImageDownloadBaseViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *imageDownloadDictionary;
@end

@implementation ImageDownloadBaseViewController

- (NSMutableDictionary*)imageDownloadDictionary
{
    if (!_imageDownloadDictionary) {
        _imageDownloadDictionary = [NSMutableDictionary dictionary];
    }
    return _imageDownloadDictionary;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self cancelAllImageDownloads];
}

- (NSMutableArray*)objectsToDisplay
{
    return nil;
}

- (void)cancelAllImageDownloads
{
    NSArray *allDownloads = [self.imageDownloadDictionary allValues];

    for (ImageDownloader *downloader in allDownloads) {
        [downloader cancelDownload];
    }

    [self.imageDownloadDictionary removeAllObjects];
}

- (void)loadImagesForVisibleRows
{
    NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexpath in visibleRows) {
        if (indexpath.row < [self objectsToDisplay].count )
        {
            BaseImageModel *object = self.objectsToDisplay[indexpath.row];
            if (!object.image) {
                [self startImageDownloadForObject:object atIndexPath:indexpath];
            }
        }
    }
}

- (void)startImageDownloadForObject:(BaseImageModel*)object atIndexPath:(NSIndexPath*)indexPath
{
    ImageDownloader *downloader = [self.imageDownloadDictionary nonNullObjectForKey:indexPath];
    if (!downloader && object.imageURL)
    {
        downloader = [ImageDownloader new];
        __weak typeof(self) weakSelf = self;
        [downloader startDownloadingImage:object.imageURL completionBlock:^(UIImage *image) {
            [weakSelf updateTableViewCellAtIndexPath:indexPath image:image];
            [weakSelf.imageDownloadDictionary removeObjectForKey:indexPath];
        }];

        self.imageDownloadDictionary[indexPath] = downloader;
    }
}

- (void)updateTableViewCellAtIndexPath:(NSIndexPath*)indexPath image:(UIImage*)image
{
    // implement in subclasses
}

#pragma mark - scrollView methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForVisibleRows];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self loadImagesForVisibleRows];
    }
}

@end
