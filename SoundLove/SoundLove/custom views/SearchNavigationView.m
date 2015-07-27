//
//  SearchNavigationView.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 14/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "SearchNavigationView.h"
#import "UIColor+GlobalColors.h"
//#import "TrackingManager.h"

@interface SearchNavigationView () <UITextFieldDelegate>
@property (nonatomic) BOOL isSearching;
@end

@implementation SearchNavigationView

- (instancetype)initWithTitle:(NSString*)title andDelegate:(id<SearchNavigationViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SearchNavigationView" owner:nil options:nil];
        for (id object in bundle) {
            if ([object isKindOfClass:[SearchNavigationView class]]) {
                self = object;
                break;
            }
        }
        [self setupView];
        self.titleLabel.text = title;
        self.delegate = delegate;
    }
    return self;
}

- (void)setTitle:(NSString*)title
{
    self.titleLabel.text = title;
}

- (void)setupView
{
    self.activeSearchBackgroundView.alpha = 0.0;
    self.searchField.hidden = YES;
    self.searchField.tintColor = [UIColor globalGreenColor];
    self.searchField.textColor = [UIColor globalGreenColor];
    self.searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchField.placeholder
                                                                             attributes:@{NSFontAttributeName:self.searchField.font, NSForegroundColorAttributeName:[UIColor globalGreenColorWithAlpha:0.4]}];

    self.cancelButton.hidden = YES;
    self.cancelButton.alpha = 0.0;
    self.titleLabel.textColor = [UIColor globalGreenColor];

    [self.cancelButton setTitleColor:[UIColor globalGreenColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor globalGreenColorWithAlpha:0.6] forState:UIControlStateHighlighted];
    [self.searchField addTarget:self action:@selector(searchTextChanged:) forControlEvents:UIControlEventEditingChanged];

    self.backgroundColor = [UIColor navigationBarBackgroundColor];
}

- (void)setSearchModeActive:(BOOL)active
{
    if (active)
    {
        self.cancelButton.hidden = NO;
        self.isSearching = YES;

        [self removeConstraint:self.searchButtonLeftConstraint];
        self.searchButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self.activeSearchBackgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.searchButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5.0];
        [self removeConstraint:self.searchButtonRightConstraint];
        [self addConstraint:self.searchButtonLeftConstraint];

        self.searchField.hidden = NO;
        self.searchField.alpha = 0.0;
        [UIView animateKeyframesWithDuration:0.6 delay:0.0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            // fade out layers
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
                self.titleLabel.alpha = 0.0;
            }];
            // animate the search button
            [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.4 animations:^{
                self.searchButton.transform = CGAffineTransformMakeScale(0.6, 0.6);
                [self layoutIfNeeded];
            }];
            // animate the textfield & cancelButton
            [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
                self.searchField.alpha = 1.0;
                self.cancelButton.alpha = 1.0;
                self.activeSearchBackgroundView.alpha = 1.0;
            }];

        } completion:^(BOOL finished) {
                [self.searchField becomeFirstResponder];
        }];
    }
    else
    {
        self.isSearching = NO;
        [self.searchField resignFirstResponder];
        self.searchField.text = @"";

        [self removeConstraint:self.searchButtonLeftConstraint];
        self.searchButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.searchButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        [self addConstraint:self.searchButtonRightConstraint];

        [UIView animateKeyframesWithDuration:0.6
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionLayoutSubviews
                                  animations:^{
                                      [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.1 animations:^{
                                          self.cancelButton.alpha = 0.0;
                                          self.searchField.alpha = 0.0;
                                          self.activeSearchBackgroundView.alpha = 0.0;
                                      }];
                                      [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.4 animations:^{
                                          self.searchButton.transform = CGAffineTransformIdentity;
                                          [self layoutIfNeeded];
                                      }];

                                      [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
                                          self.titleLabel.alpha = 1.0;
                                      }];
                                  }
                                  completion:^(BOOL finished) {
                                      self.cancelButton.hidden = YES;
                                      self.searchField.hidden = YES;
                                      self.searchButton.userInteractionEnabled = YES;
        }];

    }
}

- (void)assignLeftButtonWithSelector:(SEL)selector toTarget:(id)target
{
    [self.menuButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)assignRightButtonWithSelector:(SEL)selector toTarget:(id)target
{
    [self.searchButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)searchButtonPressed
{
//    [[TrackingManager sharedManager] trackOpenSearch];

    if (!self.isSearching) {
        self.isSearching = YES;
        self.searchButton.userInteractionEnabled = NO;
        [self setSearchModeActive:YES];
    }
}

- (IBAction)menuButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchNavigationViewMenuButtonPressed)]) {
        [self.delegate searchNavigationViewMenuButtonPressed];
    }
}

- (IBAction)cancelButtonPressed
{
    [self setSearchModeActive:NO];
    if ([self.delegate respondsToSelector:@selector(searchNavigationViewCancelButtonPressed)]) {
        [self.delegate searchNavigationViewCancelButtonPressed];
    }
}

#pragma mark - textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(searchNavigationViewSearchButtonPressed:)]) {
        [self.delegate searchNavigationViewSearchButtonPressed:textField.text];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)searchTextChanged:(UITextField*)textfield
{
    if ([self.delegate respondsToSelector:@selector(searchNavigationViewUserEnteredNewCharacter:)]) {
        [self.delegate searchNavigationViewUserEnteredNewCharacter:textfield.text];
    }
}

@end
