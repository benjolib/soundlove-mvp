//
//  FlatDatePicker.h
//  FlatDatePicker
//
//  Created by Christopher Ney on 25/05/13.
//  Copyright (c) 2013 Christopher Ney. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlatDatePicker;

@protocol FlatDatePickerDelegate<NSObject>
@optional
- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date;
- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender;
- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date;
@end

typedef NS_ENUM(NSInteger, FlatDatePickerMode) {
    FlatDatePickerModeDate,           // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
};

@interface FlatDatePicker : UIControl <UIScrollViewDelegate> {
    
    // Parent View :
    UIView *_parentView;
    
    // ScrollView :
    UIScrollView *_scollViewDays;
    UIScrollView *_scollViewMonths;
    UIScrollView *_scollViewYears;
    
    UIScrollView *_scollViewDates;
    
    UIScrollView *_scollViewHours;
    UIScrollView *_scollViewMinutes;
    UIScrollView *_scollViewSeconds;
    
    // Lines :
    UIView *_lineDaysTop;
    UIView *_lineDaysBottom;
    UIView *_lineMonthsTop;
    UIView *_lineMonthsBottom;
    UIView *_lineYearsTop;
    UIView *_lineYearsBottom;
    
    UIView *_lineDatesTop;
    UIView *_lineDatesBottom;
    
    UIView *_lineHoursTop;
    UIView *_lineHoursBottom;
    UIView *_lineMinutesTop;
    UIView *_lineMinutesBottom;
    UIView *_lineSecondsTop;
    UIView *_lineSecondsBottom;
    
    // Title :
    NSString *_title;
    
    // Days, Months, Years :
    NSMutableArray *_days;
    NSMutableArray *_months;
    NSMutableArray *_years;
    
    // Dates :
    NSMutableArray *_dates;
    
    // Labels :
    NSMutableArray *_labelsDays;
    NSMutableArray *_labelsMonths;
    NSMutableArray *_labelsYears;
    
    NSMutableArray *_labelsDates;
    
    NSMutableArray *_labelsHours;
    NSMutableArray *_labelsMinutes;
    NSMutableArray *_labelsSeconds;
    
    // Date selected :
    NSInteger _selectedDay;
    NSInteger _selectedMonth;
    NSInteger _selectedYear;
    
    int _selectedDate;
    
    // First init flag :
    BOOL _isInitialized;
}

@property (nonatomic, strong) NSObject<FlatDatePickerDelegate> *delegate;

@property(nonatomic) FlatDatePickerMode datePickerMode;           // default is UIDatePickerModeDate

@property(nonatomic,retain) NSLocale      *locale;                // default is [NSLocale currentLocale]. setting nil returns to default
@property(nonatomic,copy)   NSCalendar    *calendar;              // default is [NSCalendar currentCalendar]. setting nil returns to default
@property(nonatomic,retain) NSTimeZone    *timeZone;              // default is nil. use current time zone or time zone from calendar

@property(nonatomic,retain) NSDate        *minimumDate;           // specify min/max date range. default is nil. When min > max, the values are ignored.
@property(nonatomic,retain) NSDate        *maximumDate;           // default is nil

/**
 * Colors customization.
 */
@property (strong) UIColor *backgroundColor;
@property (strong) UIColor *backgroundColorTitle;
@property (strong) UIColor *backgroundColorButtonValid;
@property (strong) UIColor *backgroundColorButtonCancel;
@property (strong) UIColor *backgroundColorScrollView;
@property (strong) UIColor *backgroundColorLines;
@property (strong) UIColor *backgroundColorSelected;

@property (strong) UIColor *fontColorTitle;
@property (strong) UIColor *fontColorLabel;
@property (strong) UIColor *fontColorLabelSelected;

/**
 * Font customization.
 */
@property (strong) UIFont *fontTitle;
@property (strong) UIFont *fontLabel;
@property (strong) UIFont *fontLabelSelected;

#pragma mark - Initializers

- (id)initWithParentView:(UIView*)parentView;

- (void)show;

/**
 * Force to redraw the Picker. You should call this method after change the default colors.
 */
- (void)setupControl;

#pragma mark - DatePicker Mode

- (void)setDatePickerMode:(FlatDatePickerMode)mode;

#pragma mark - DatePicker Date Maximum And Minimum

- (void)setMinimumDate:(NSDate*)date;
- (void)setMaximumDate:(NSDate*)date;

#pragma mark - Date

- (void)setDate:(NSDate *)date animated:(BOOL)animated;
- (NSDate*)getDate;

@end

