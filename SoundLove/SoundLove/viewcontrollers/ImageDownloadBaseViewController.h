//
//  ImageDownloadBaseViewController.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 31/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseGradientViewController.h"

@class LoadingTableView, BaseImageModel;

@interface ImageDownloadBaseViewController : BaseGradientViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet LoadingTableView *tableView;

- (NSMutableArray*)objectsToDisplay;

- (void)startImageDownloadForObject:(BaseImageModel*)object atIndexPath:(NSIndexPath*)indexPath;
- (void)updateTableViewCellAtIndexPath:(NSIndexPath*)indexPath image:(UIImage*)image;

- (void)cancelAllImageDownloads;
- (void)loadImagesForVisibleRows;

@end
