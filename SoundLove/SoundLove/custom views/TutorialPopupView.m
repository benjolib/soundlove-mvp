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

- (void)showWithText:(NSString*)text atPoint:(CGPoint)point highLightArea:(CGRect)highlightedArea position:(PointerPosition)position
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

    [self drawArrowLayerToPoint:point position:position];

    [window addSubview:[self dimmViewOnWindow:window withHighlightedArea:highlightedArea]];
    [window insertSubview:self aboveSubview:self.dimmView];
}

- (void)showWithText:(NSString*)text atPoint:(CGPoint)point highLightArea:(CGRect)highlightedArea
{
    [self showWithText:text atPoint:point highLightArea:highlightedArea];
}

- (UIView*)dimmViewOnWindow:(UIWindow*)window withHighlightedArea:(CGRect)highlightedArea
{
    CGRect windowFrame = window.frame;
    CGRect dimmViewFrame = CGRectZero;

    if (!CGRectIsNull(highlightedArea))
    {
        if (highlightedArea.origin.x == 0 && highlightedArea.origin.y == 0) {
            dimmViewFrame = CGRectMake(CGRectGetMinX(highlightedArea), CGRectGetMaxY(highlightedArea), CGRectGetWidth(windowFrame), CGRectGetHeight(windowFrame) - CGRectGetMaxY(highlightedArea));
        } else {
            dimmViewFrame = CGRectMake(0.0, 0.0, CGRectGetWidth(windowFrame), CGRectGetHeight(windowFrame) - CGRectGetHeight(highlightedArea));
        }
    } else {
        dimmViewFrame = windowFrame;
    }

    UIView *view = [[UIView alloc] initWithFrame:dimmViewFrame];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];

    self.dimmView = view;
    return self.dimmView;
}

#pragma mark - private methods
- (void)drawArrowLayerToPoint:(CGPoint)point position:(PointerPosition)position
{
    UIView *pointerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 1.0)];
    pointerView.backgroundColor = [UIColor clearColor];

    CGFloat pointX = point.x;

//    if (position == PointerPositionCenter) {
        pointerView.frame = CGRectMake(pointX, CGRectGetHeight(self.frame), 30.0, 30.0);
//    } else if (position == PointerPositionLeft) {
//        pointerView.frame = CGRectMake(pointX, CGRectGetHeight(self.frame), 30.0, 30.0);
//    } else {
//        pointerView.frame = CGRectMake(pointX, CGRectGetHeight(self.frame), 30.0, 30.0);
//    }

//    PointerPosition position;
//    if (pointX <= self.frame.size.width/2) {
//        position = PointerPositionLeft;
//        pointerView.frame = CGRectMake(pointX, CGRectGetHeight(self.frame), 30.0, 30.0);
//    } else if (pointX >= self.frame.size.width/2) {
//        position = PointerPositionRight;
//        pointerView.frame = CGRectMake(pointX, CGRectGetHeight(self.frame), 30.0, 30.0);
//    } else {
//        position = PointerPositionCenter;
//        pointerView.frame = CGRectMake(0.0, CGRectGetHeight(self.frame), 30.0, 30.0);
//    }

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
        [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
        [bezierPath addLineToPoint:CGPointMake(10.0, 16.0)];
        [bezierPath addLineToPoint:CGPointMake(0.0 + 20.0, 0.0)];
    } else if (position == PointerPositionCenter) {
        [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
        [bezierPath addLineToPoint:CGPointMake(10.0, 16.0)];
        [bezierPath addLineToPoint:CGPointMake(0.0 + 20.0, 0.0)];
    } else {
        [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(view.frame) - 10.0, 0.0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(view.frame), 16.0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(view.frame) + 10.0, 0.0)];
    }

    [bezierPath closePath];
    return bezierPath;
}

@end
