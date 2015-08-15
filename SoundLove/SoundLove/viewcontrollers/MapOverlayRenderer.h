//
//  MapOverlayRenderer.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 13/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <MapKit/MapKit.h>

@class MapOverlay;

@interface MapOverlayRenderer : MKCircleRenderer

- (instancetype)initWithSelectorOverlay:(MapOverlay *)selectorOverlay;

@end
