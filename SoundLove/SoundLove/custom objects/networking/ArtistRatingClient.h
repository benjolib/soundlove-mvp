//
//  ArtistRatingClient.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 21/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "AbstractClient.h"
#import "ArtistModel.h"

@interface ArtistRatingClient : AbstractClient

- (void)likeArtist:(ArtistModel*)artist withCompletionBlock:(void (^)(BOOL completed, NSString *errorMessage))completionBlock;

- (void)dislikeArtist:(ArtistModel*)artist withCompletionBlock:(void (^)(BOOL completed, NSString *errorMessage))completionBlock;

@end
