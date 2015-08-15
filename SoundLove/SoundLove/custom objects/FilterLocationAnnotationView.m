//
//  FilterLocationAnnotationView.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 13/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FilterLocationAnnotationView.h"
#import "UIColor+GlobalColors.h"

@interface FilterLocationAnnotationMarkerView : UIView
@end

@implementation FilterLocationAnnotationMarkerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor globalGreenColor].CGColor);
    CGContextFillEllipseInRect(context, rect);
}

@end

@interface FilterLocationAnnotationView ()
@property (nonatomic, strong) FilterLocationAnnotationMarkerView *markerView;
@end

@implementation FilterLocationAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.markerView = [[FilterLocationAnnotationMarkerView alloc] initWithFrame:CGRectMake(-10.0, -10.0, 20.0, 20.0)];
        self.markerView.userInteractionEnabled = YES;
        [self addSubview:self.markerView];
    }
    return self;
}

@end
