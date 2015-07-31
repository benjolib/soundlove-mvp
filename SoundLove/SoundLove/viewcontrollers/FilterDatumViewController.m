//
//  FilterDatumViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 31/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FilterDatumViewController.h"
#import "PriceContainerView.h"
#import "CustomNavigationView.h"
#import "FlatDatePicker.h"

@interface FilterDatumViewController () <FlatDatePickerDelegate>
@property (nonatomic, strong) FlatDatePicker *flatDatePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation FilterDatumViewController

- (IBAction)closeButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)trashButtonPressed:(UIButton*)button
{
    [self.leftDatePickerView setActive:NO];
    [self.rightDatePickerView setActive:NO];

    self.fromDate = nil;
    self.toDate = nil;

    [self.leftDatePickerView setValueText:@""];
    [self.rightDatePickerView setValueText:@""];

    button.alpha = 0.4;
    button.enabled = NO;
}

- (NSDateFormatter*)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"dd.MM.YYY";
    }
    return _dateFormatter;
}

#pragma mark - date picker
- (void)flatDatePicker:(FlatDatePicker *)datePicker dateDidChange:(NSDate *)date
{
    if ([self.leftDatePickerView isActive]) {
        NSString *dateString = [self.dateFormatter stringFromDate:date];
        self.fromDate = date;
        [self.leftDatePickerView setValueText:dateString];
    } else if ([self.rightDatePickerView isActive]) {
        NSString *dateString = [self.dateFormatter stringFromDate:date];
        self.toDate = date;
        [self.rightDatePickerView setValueText:dateString];
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *leftGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateViewTapped:)];
    UITapGestureRecognizer *rightGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateViewTapped:)];
    [self.leftDatePickerView addGestureRecognizer:leftGestureRecognizer];
    [self.rightDatePickerView addGestureRecognizer:rightGestureRecognizer];

    self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
    [self.flatDatePicker show];

    CGFloat pickerHeight = CGRectGetHeight(self.flatDatePicker.frame);
    self.flatDatePicker.frame = CGRectMake(0.0, CGRectGetHeight(self.view.frame)-pickerHeight-100.0, CGRectGetWidth(self.view.frame), pickerHeight);

    [self.leftDatePickerView setActive:YES];

    if (self.fromDate || self.toDate) {
        self.trashButton.enabled = YES;
    } else {
        self.trashButton.enabled = NO;
    }
}

- (void)dateViewTapped:(UITapGestureRecognizer*)recognizer
{
    UIView *view = [recognizer view];
    if ([view isEqual:self.leftDatePickerView]) {
        [self.leftDatePickerView setActive:YES];
        [self.rightDatePickerView setActive:NO];
    }

    if ([view isEqual:self.rightDatePickerView]) {
        [self.leftDatePickerView setActive:NO];
        [self.rightDatePickerView setActive:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
