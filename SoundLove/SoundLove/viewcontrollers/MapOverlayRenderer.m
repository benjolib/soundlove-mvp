//
//  MapOverlayRenderer.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 13/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "MapOverlayRenderer.h"
#import "MapOverlay.h"
#import "UIColor+GlobalColors.h"

@interface MapOverlayRenderer ()
@property (nonatomic, strong) MapOverlay *mapOverlay;
@end

@implementation MapOverlayRenderer

- (instancetype)initWithSelectorOverlay:(MapOverlay *)selectorOverlay
{
    self = [super initWithOverlay:selectorOverlay];
    if (self) {
        self.mapOverlay = selectorOverlay;
        [self addOverlayObserver];
    }
    return self;
}

- (void)dealloc {
    [self removeOverlayObserver];
}

#pragma mark - Observering
- (NSArray *)overlayObserverArray {
    return @[NSStringFromSelector(@selector(radius)),
             NSStringFromSelector(@selector(editingCoordinate)),
             NSStringFromSelector(@selector(editingRadius))];
}

- (void)addOverlayObserver {
    for (NSString *keyPath in [self overlayObserverArray]) {
        [self.mapOverlay addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeOverlayObserver {
    for (NSString *keyPath in [self overlayObserverArray]) {
        [self.mapOverlay removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[self.mapOverlay class]]) {
        if ([[self overlayObserverArray] containsObject:keyPath]) {
            [self invalidatePath];
        }
    }
}

#pragma mark - Drawing

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    MKMapPoint mpoint = MKMapPointForCoordinate([[self overlay] coordinate]);

    CLLocationDistance radius = self.mapOverlay.radius;
    CGFloat radiusAtLatitude = radius * MKMapPointsPerMeterAtLatitude([[self overlay] coordinate].latitude);

    MKMapRect circlebounds = MKMapRectMake(mpoint.x, mpoint.y, radiusAtLatitude *2, radiusAtLatitude * 2);
    CGRect overlayRect = [self rectForMapRect:circlebounds];
    
    CGContextSetStrokeColorWithColor(context, [UIColor globalGreenColor].CGColor);
    CGContextSetLineWidth(context, overlayRect.size.width *.015f);
    CGContextSetShouldAntialias(context, YES);

    CGContextSetFillColorWithColor(context, [[UIColor colorWithR:39 G:48 B:61] colorWithAlphaComponent:0.2].CGColor);
    CGContextAddArc(context, overlayRect.origin.x, overlayRect.origin.y, radiusAtLatitude, 0, 2 * M_PI, true);
    CGContextDrawPath(context, kCGPathFillStroke);
    UIGraphicsPopContext();
}


@end
