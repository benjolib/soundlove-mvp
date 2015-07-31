//
//  BaseImageModel.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 31/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// A custom, basic model that has an UIImage and imageURL property

@interface BaseImageModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageURL;

@end
