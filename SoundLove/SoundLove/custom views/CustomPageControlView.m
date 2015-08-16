//
//  OnboardingPageControlView.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 24/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "CustomPageControlView.h"
#import "UIColor+GlobalColors.h"

@interface CustomPageControlView ()
@property (nonatomic) NSInteger currentDotIndex;
@property (nonatomic) NSInteger totalNumberOfDots;
@end

@implementation CustomPageControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setNumberOfDots:(NSInteger)totalDots
{
    self.totalNumberOfDots = totalDots;
    [self setNeedsDisplay];
}

- (void)setCurrentDotIndex:(NSInteger)currentDotIndex
{
    if (_currentDotIndex != currentDotIndex) {
        _currentDotIndex = currentDotIndex;
        [self setNeedsDisplay];
    }
}

#pragma mark - private methods
- (void)drawRect:(CGRect)rect
{
    CGFloat dotDiameter = 6.0;
    CGFloat kDotSpacer = 6.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.totalNumberOfDots * dotDiameter + MAX(0, self.totalNumberOfDots-1) * kDotSpacer;
    CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth/2;
    CGFloat y = CGRectGetMidY(currentBounds)-dotDiameter/2;
    
    for (int i = 0; i < self.totalNumberOfDots; i++)
    {
        CGRect circleRect = CGRectMake(x, y, dotDiameter, dotDiameter);
        UIColor *fillColor = (i == self.currentDotIndex) ? [UIColor globalGreenColor] : [UIColor clearColor];
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor globalGreenColor].CGColor);
        CGContextFillEllipseInRect(context, circleRect);
        CGContextStrokeEllipseInRect(context, circleRect);
        x += dotDiameter + kDotSpacer;
    }
}

@end
