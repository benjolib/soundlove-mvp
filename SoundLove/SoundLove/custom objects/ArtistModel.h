//
//  ArtistModel.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "BaseImageModel.h"

@interface ArtistModel : BaseImageModel

@property (nonatomic, copy) NSString *name;

+ (ArtistModel*)artistWithName:(NSString*)name imageURL:(NSString*)imageURL;

+ (NSArray*)artistArrayFromStringArray:(NSArray*)array;

@end
