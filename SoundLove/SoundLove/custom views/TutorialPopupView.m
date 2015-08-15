//
//  TutorialPopupView.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 07/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "TutorialPopupView.h"
#import "UIColor+GlobalColors.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSUInteger, PointerPosition) {
    PointerPositionRight,
    PointerPositionLeft,
    PointerPositionCenter,
};

@interface TutorialPopupView ()
@property (nonatomic, strong) UIView *dimmView;
@end

@implementation TutorialPopupView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"TutorialPopupView" owner:nil options:nil];
        for (id object in bundle) {
            if ([object isKindOfClass:[TutorialPopupView class]]) {
                self = object;
                break;
            }
        }
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView
{
    self.backgroundColor = [UIColor globalGreenColor];
    self.layer.cornerRadius = 14.0;

    self.textLabel.textColor = [UIColor colorWithR:31 G:38 B:49];

    [self.actionButton setTitleColor:[UIColor colorWithR:31 G:38 B:49] forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[[UIColor colorWithR:31 G:38 B:49] colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];

    self.separatorView.backgroundColor = [[UIColor colorWithR:100.0 G:100.0 B:100.0] colorWithAlphaComponent:0.3];
}

- (IBAction)actionButtonTapped:(UIButton*)button
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0.0;
                         self.dimmView.alpha = 0.0;
                         self.transform = CGAffineTransformMakeScale(0.4, 0.4);
                     }
                     completion:^(BOOL finished) {
                         [self.dimmView removeFromSuperview];
                         [self removeFromSuperview];
                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTutorialDismissed object:nil];
    }];
}

- (void)showWithText:(NSString*)text atPoint:(CGPoint)point highLightArea:(CGRect)highlightedArea
{
    self.textLabel.text = text;
    UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;

    NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font};
    NSInteger options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesLineFragmentOrigin;
    CGRect labelRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.textLabel.frame), CGFLOAT_MAX) options:options attributes:attributes context:NULL];

    CGFloat viewHeight = labelRect.size.height + 20.0 + 10.0;

    CGRect viewFrame = self.frame;
    viewFrame.size.height = viewHeight;
    viewFrame.size.width = CGRectGetWidth(window.frame) - 30.0;
    viewFrame.origin.x = 15.0;
    viewFrame.origin.y = point.y;
    self.frame = viewFrame;

    [self drawArrowLayerToPoint:point];

    [window addSubview:[self dimmViewOnWindow:window withHighlightedArea:highlightedArea]];
    [window insertSubview:self aboveSubview:self.dimmView];
}

- (UIView*)dimmViewOnWindow:(UIWindow*)window withHighlightedArea:(CGRect)highlightedArea
{
    CGRect windowFrame = window.frame;
    CGRect dimmViewFrame = CGRectZero;

    if (highlightedArea.origin.x == 0 && highlightedArea.origin.y == 0) {
        dimmViewFrame = CGRectMake(CGRectGetMinX(highlightedArea), CGRectGetMaxY(highlightedArea), CGRectGetWidth(windowFrame), CGRectGetHeight(windowFrame) - CGRectGetMaxY(highlightedArea));
    } else {
        dimmViewFrame = CGRectMake(0.0, 0.0, CGRectGetWidth(windowFrame), CGRectGetHeight(windowFrame) - CGRectGetHeight(highlightedArea));
    }

    UIView *view = [[UIView alloc] initWithFrame:dimmViewFrame];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];

    self.dimmView = view;
    return self.dimmView;
}

#pragma mark - private methods
- (void)drawArrowLayerToPoint:(CGPoint)point
{
    UIView *pointerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 1.0)];
    pointerView.backgroundColor = [UIColor clearColor];

    PointerPosition position = PointerPositionCenter;
    UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;

    if (point.x > CGRectGetWidth(window.frame)/2) {
        position = PointerPositionRight;
        pointerView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), 1.0);
    } else {
        position = PointerPositionCenter;
        pointerView.frame = CGRectMake(0.0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 1.0);
    }

    CAShapeLayer *arrowLayer = [CAShapeLayer layer];
    arrowLayer.path = [self arrowPathForView:pointerView pointToPosition:position].CGPath;
    arrowLayer.fillColor = [UIColor globalGreenColor].CGColor;

    [pointerView.layer addSublayer:arrowLayer];
    [self addSubview:pointerView];
}

- (UIBezierPath*)arrowPathForView:(UIView*)view pointToPosition:(PointerPosition)position
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];

    if (position == PointerPositionRight) {
        [bezierPath moveToPoint:CGPointMake(CGRectGetWidth(view.frame) - 10.0, 0.0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(view.frame) + 10.0, -12.0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(view.frame) + 10.0, 0.0)];
    } else if (position == PointerPositionCenter) {
        CGFloat middlePoint = CGRectGetMidX(view.frame);
        [bezierPath moveToPoint:CGPointMake(middlePoint - 15.0, 0.0)];
        [bezierPath addLineToPoint:CGPointMake(middlePoint, 0.0 + 16.0)];
        [bezierPath addLineToPoint:CGPointMake(middlePoint + 15.0, 0.0)];
    }
    [bezierPath closePath];
    return bezierPath;
}

@end
