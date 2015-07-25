//
//  SearchNavigationView.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 14/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchNavigationViewDelegate <NSObject>

- (void)searchNavigationViewMenuButtonPressed;
- (void)searchNavigationViewCancelButtonPressed;
- (void)searchNavigationViewSearchButtonPressed:(NSString*)searchText;
- (void)searchNavigationViewUserEnteredNewCharacter:(NSString*)searchText;

@end

@interface SearchNavigationView : UIView

@property (nonatomic, weak) id <SearchNavigationViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *searchButton;
@property (nonatomic, weak) IBOutlet UIButton *menuButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *searchField;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) NSLayoutConstraint *searchButtonLeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *searchButtonRightConstraint;

- (instancetype)initWithTitle:(NSString*)title andDelegate:(id<SearchNavigationViewDelegate>)delegate;

- (void)setSearchModeActive:(BOOL)active;
- (void)setTitle:(NSString*)title;

- (void)assignLeftButtonWithSelector:(SEL)selector toTarget:(id)target;
- (void)assignRightButtonWithSelector:(SEL)selector toTarget:(id)target;

@end
