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

- (IBAction)trashButtonPressed:(UIButton*)button
{
    [self.leftDatePickerView setActive:NO];
    [self.rightDatePickerView setActive:NO];

    self.fromDate = nil;
    self.toDate = nil;

    self.filterModel.startDate = nil;
    self.filterModel.endDate = nil;

    [self.leftDatePickerView setValueText:@""];
    [self.rightDatePickerView setValueText:@""];

    [self setTrashIconVisible:NO];
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
        self.filterModel.startDate = date;
    } else if ([self.rightDatePickerView isActive]) {
        NSString *dateString = [self.dateFormatter stringFromDate:date];
        self.toDate = date;
        [self.rightDatePickerView setValueText:dateString];
        self.filterModel.endDate = date;
    }

    [self setTrashIconVisible:YES];
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
    self.flatDatePicker.minimumDate = [NSDate date];
    [self.flatDatePicker show];

    CGFloat pickerHeight = CGRectGetHeight(self.flatDatePicker.frame);
    self.flatDatePicker.frame = CGRectMake(0.0, CGRectGetHeight(self.view.frame)-pickerHeight-100.0, CGRectGetWidth(self.view.frame), pickerHeight);

    [self.leftDatePickerView setActive:YES];

    self.fromDate = self.filterModel.startDate;
    self.toDate = self.filterModel.endDate;

    if (self.fromDate || self.toDate) {
        [self setTrashIconVisible:YES];
        if (self.fromDate) {
            [self.flatDatePicker setDate:self.fromDate animated:YES withDelegateCallback:YES];
        } else {
            [self.flatDatePicker setDate:self.toDate animated:YES withDelegateCallback:YES];
        }
    } else {
        [self setTrashIconVisible:NO];
    }
}

- (void)dateViewTapped:(UITapGestureRecognizer*)recognizer
{
    UIView *view = [recognizer view];
    if ([view isEqual:self.leftDatePickerView] && ![self.leftDatePickerView isActive]) {
        [self.leftDatePickerView setActive:YES];
        [self.rightDatePickerView setActive:NO];

        self.flatDatePicker.minimumDate = self.fromDate ? self.fromDate : [NSDate date];
        [self.flatDatePicker show];
    }

    if ([view isEqual:self.rightDatePickerView] && ![self.rightDatePickerView isActive]) {
        [self.leftDatePickerView setActive:NO];
        [self.rightDatePickerView setActive:YES];
        if (self.fromDate &&  [self.toDate timeIntervalSinceDate:self.fromDate] <= 0) { // if we selected the from date, and the toDate is earlier than fromDate
            self.flatDatePicker.minimumDate = self.fromDate;
            [self flatDatePicker:nil dateDidChange:self.fromDate];
        } else {
            [self.flatDatePicker setDate:self.toDate animated:YES withDelegateCallback:NO];
        }
        [self.flatDatePicker show];
    }
}

@end
