//
//  ArtistDownloadClient.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "AbstractClient.h"

@interface ArtistDownloadClient : AbstractClient

- (void)downloadFavoriteArtistsWithCompletionBlock:(void (^)(NSArray *artists, BOOL completed, NSString *errorMessage))completionBlock;

@end
