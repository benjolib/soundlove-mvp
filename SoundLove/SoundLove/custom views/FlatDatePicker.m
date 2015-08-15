//
//  FlatDatePicker.m
//  FlatDatePicker
//
//  Created by Christopher Ney on 25/05/13.
//  Copyright (c) 2013 Christopher Ney. All rights reserved.
//

#import "FlatDatePicker.h"

// Constants times :
#define kFlatDatePickerAnimationDuration 0.4

// Constants colors :
#define kFlatDatePickerBackgroundColor self.backgroundColor
#define kFlatDatePickerBackgroundColorTitle self.backgroundColorTitle
#define kFlatDatePickerBackgroundColorButtonValid self.backgroundColorButtonValid
#define kFlatDatePickerBackgroundColorButtonCancel self.backgroundColorButtonCancel
#define kFlatDatePickerBackgroundColorScrolView self.backgroundColorScrollView
#define kFlatDatePickerBackgroundColorLines self.backgroundColorLines
#define kFlatDatePickerBackgroundColorSelected self.backgroundColorSelected;

// Constants fonts colors :
#define kFlatDatePickerFontColorTitle self.fontColorTitle
#define kFlatDatePickerFontColorLabel self.fontColorLabel
#define kFlatDatePickerFontColorLabelSelected self.fontColorLabelSelected

// Constants sizes :
#define kFlatDatePickerHeight 260
#define kFlatDatePickerHeaderHeight ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 44 : (self.title == nil || self.title.length == 0) ? 0 : 44)
#define kFlatDatePickerButtonHeaderWidth 44
#define kFlatDatePickerHeaderBottomMargin 1
#define kFlatDatePickerScrollViewDaysWidth 90
#define kFlatDatePickerScrollViewMonthWidth 140
#define kFlatDatePickerScrollViewDateWidth 165
#define kFlatDatePickerScrollViewLeftMargin 1
#define kFlatDatePickerScrollViewItemHeight 45
#define kFlatDatePickerLineWidth 1
#define kFlatDatePickerLineMargin 15

// Constants fonts
#define kFlatDatePickerFontTitle self.fontTitle;
#define kFlatDatePickerFontLabel self.fontLabel;
#define kFlatDatePickerFontLabelSelected self.fontLabelSelected;

// Constants icons
#define kFlatDatePickerIconCancel @"FlatDatePicker-Icon-Close.png"
#define kFlatDatePickerIconValid @"FlatDatePicker-Icon-Check.png"

// Constants :
#define kStartYear ( self.minimumDate == nil ? 1900 : [self yearOfDate:self.minimumDate] )
#define TAG_DAYS 1
#define TAG_MONTHS 2
#define TAG_YEARS 3
#define TAG_HOURS 4
#define TAG_MINUTES 5
#define TAG_SECONDS 6
#define TAG_DATES 7

// Macros
#define IS_PHONE  UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone

@interface FlatDatePicker ()
@end

@implementation FlatDatePicker

#pragma mark -
#pragma mark Helpers

- (NSInteger) yearOfDate:(NSDate*)date {
	NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit) fromDate:date];
	return components.year;
}

#pragma mark - Initializers

-(id)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        _datePickerMode = FlatDatePickerModeDate;

        // Default Colors.
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColorTitle = [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
        self.backgroundColorButtonValid = [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0];
        self.backgroundColorButtonCancel = [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0];
        self.backgroundColorScrollView = [UIColor clearColor];
        self.backgroundColorLines = [UIColor colorWithRed:139.0/255.0 green:219.0/255.0 blue:180.0/255.0 alpha:1.0];
        self.backgroundColorSelected = [UIColor clearColor];
        
        self.fontColorTitle          = [UIColor colorWithWhite:1.0 alpha:0.8];
        self.fontColorLabel          = [UIColor colorWithWhite:1.0 alpha:0.2];
        self.fontColorLabelSelected  = [UIColor colorWithRed:139.0/255.0 green:219.0/255.0 blue:180.0/255.0 alpha:1.0];

        // Default fonts.
        self.fontTitle = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
        self.fontLabel = [UIFont fontWithName:@"HelveticaNeue-Regular" size:16.0];
        self.fontLabelSelected = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
        
        [self setupControl];
    }
    return self;
}

-(id)initWithParentView:(UIView*)parentView {
    
    _parentView = parentView;
    
    if ([self initWithFrame:CGRectMake(0.0, _parentView.frame.size.height, _parentView.frame.size.width, kFlatDatePickerHeight)]) {
        _datePickerMode = FlatDatePickerModeDate;
        [_parentView addSubview:self];
        [self setupControl];
        [self setDate:[NSDate date] animated:NO withDelegateCallback:NO];
    }
    return self;
}

-(void)setupControl
{
    // Set parent View :
    self.hidden = YES;
    
    // Clear old selectors
//    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeSelectorYears];
    [self removeSelectorMonths];
    [self removeSelectorDays];

    // Default parameters :
    self.calendar = [NSCalendar currentCalendar];
    self.locale = [NSLocale currentLocale];
    self.timeZone = nil;

    // Background :
    self.backgroundColor = kFlatDatePickerBackgroundColor;
    
    // Date Selectors :
    if (self.datePickerMode == FlatDatePickerModeDate ) {
        
        _years = [self getYears];
        _months = [self getMonths];
        _days = [self getDaysInMonth:[NSDate date]];

        [self buildSelectorMonthsOffsetX:0.0 andWidth:kFlatDatePickerScrollViewMonthWidth];
        [self buildSelectorDaysOffsetX:(_scrollViewMonths.frame.size.width + kFlatDatePickerScrollViewLeftMargin) andWidth:kFlatDatePickerScrollViewDaysWidth];
        [self buildSelectorYearsOffsetX:(CGRectGetMaxX(_scrollViewDays.frame) + kFlatDatePickerScrollViewLeftMargin)
                               andWidth:(self.frame.size.width - (CGRectGetMaxX(_scrollViewDays.frame) + kFlatDatePickerScrollViewLeftMargin))];
    }

    self.hidden = NO;
}

#pragma mark - Build Selector Days

- (void)buildSelectorDaysOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Days :
    _scrollViewDays = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 10.0 + kFlatDatePickerHeaderBottomMargin, width, self.frame.size.height - 44.0 - kFlatDatePickerHeaderBottomMargin)];
    _scrollViewDays.tag = TAG_DAYS;
    _scrollViewDays.delegate = self;
    _scrollViewDays.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scrollViewDays.showsHorizontalScrollIndicator = NO;
    _scrollViewDays.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollViewDays];

    _daysTopArrow = [self addMoreDateIndicatorViewWithParentFrame:_scrollViewDays.frame onTop:YES];
    _daysBottomArrow = [self addMoreDateIndicatorViewWithParentFrame:_scrollViewDays.frame onTop:NO];
    [self addSubview:_daysTopArrow];
    [self addSubview:_daysBottomArrow];

    _lineDaysTop = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewDays.frame.origin.x + kFlatDatePickerLineMargin, _scrollViewDays.frame.origin.y + (_scrollViewDays.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDaysTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDaysTop];
    
    _lineDaysBottom = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewDays.frame.origin.x + kFlatDatePickerLineMargin, _scrollViewDays.frame.origin.y + (_scrollViewDays.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDaysBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDaysBottom];

    // Update ScrollView Data
    [self buildSelectorLabelsDays];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureDaysCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scrollViewDays addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsDays
{
    CGFloat offsetContentScrollView = (_scrollViewDays.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;
    
    if (_labelsDays != nil && _labelsDays.count > 0) {
        for (UILabel *label in _labelsDays) {
            [label removeFromSuperview];
        }
    }
    
    _labelsDays = [[NSMutableArray alloc] init];

    for (int i = 0; i < _days.count; i++)
    {
        NSString *day = (NSString*)[_days objectAtIndex:i];

        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scrollViewDays.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kFlatDatePickerFontLabel;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = kFlatDatePickerFontColorLabel;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsDays addObject:labelDay];
        [_scrollViewDays addSubview:labelDay];
    }
    
    _scrollViewDays.contentSize = CGSizeMake(_scrollViewDays.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _days.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorDays {
    
    if (_scrollViewDays != nil) {
        [_scrollViewDays removeFromSuperview];
        _scrollViewDays = nil;
    }
    if (_lineDaysTop != nil) {
        [_lineDaysTop removeFromSuperview];
        _lineDaysTop = nil;
    }
    if (_lineDaysBottom != nil) {
        [_lineDaysBottom removeFromSuperview];
        _lineDaysBottom = nil;
    }
}

#pragma mark - Build Selector Months

- (void)buildSelectorMonthsOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Months
    
    _scrollViewMonths = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 10.0 + kFlatDatePickerHeaderBottomMargin, width, self.frame.size.height - 44.0 - kFlatDatePickerHeaderBottomMargin)];
    _scrollViewMonths.tag = TAG_MONTHS;
    _scrollViewMonths.delegate = self;
    _scrollViewMonths.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scrollViewMonths.showsHorizontalScrollIndicator = NO;
    _scrollViewMonths.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollViewMonths];

    _monthsTopArrow = [self addMoreDateIndicatorViewWithParentFrame:_scrollViewMonths.frame onTop:YES];
    _monthsBottomArrow = [self addMoreDateIndicatorViewWithParentFrame:_scrollViewMonths.frame onTop:NO];
    [self addSubview:_monthsTopArrow];
    [self addSubview:_monthsBottomArrow];

    _lineMonthsTop = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewMonths.frame.origin.x + kFlatDatePickerLineMargin, _scrollViewMonths.frame.origin.y + (_scrollViewMonths.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineMonthsTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineMonthsTop];
    
    _lineDaysBottom = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewMonths.frame.origin.x + kFlatDatePickerLineMargin, _scrollViewMonths.frame.origin.y + (_scrollViewMonths.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineDaysBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineDaysBottom];
 
    
    // Update ScrollView Data
    [self buildSelectorLabelsMonths];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureMonthsCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scrollViewMonths addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsMonths {
    
    CGFloat offsetContentScrollView = self.datePickerMode == FlatDatePickerModeDate ?
                                            (_scrollViewMonths.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0 :
                                            (_scrollViewDays.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0 ;
    
    if (_labelsMonths != nil && _labelsMonths.count > 0) {
        for (UILabel *label in _labelsMonths) {
            [label removeFromSuperview];
        }
    }
    
    _labelsMonths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _months.count; i++) {
        
        NSString *day = (NSString*)[_months objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scrollViewMonths.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kFlatDatePickerFontLabel;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = kFlatDatePickerFontColorLabel;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsMonths addObject:labelDay];
        [_scrollViewMonths addSubview:labelDay];
    }
    
    _scrollViewMonths.contentSize = CGSizeMake(_scrollViewMonths.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _months.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorMonths {
    
    if (_scrollViewMonths != nil) {
        [_scrollViewMonths removeFromSuperview];
        _scrollViewMonths = nil;
    }
    if (_lineMonthsTop != nil) {
        [_lineMonthsTop removeFromSuperview];
        _lineMonthsTop = nil;
    }
    if (_lineMonthsBottom != nil) {
        [_lineMonthsBottom removeFromSuperview];
        _lineMonthsBottom = nil;
    }
}

#pragma mark - Build Selector Years
- (UIImageView*)addMoreDateIndicatorViewWithParentFrame:(CGRect)parentFrame onTop:(BOOL)onTop
{
    UIImage *image = [UIImage imageNamed:(onTop ? @"moreDateIcon" : @"moreDateIconDown")];

    CGFloat yOrigin = onTop ? -5.0 : CGRectGetHeight(self.frame) + 5.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(parentFrame) + CGRectGetWidth(parentFrame)/2-image.size.width/2, yOrigin, image.size.width, image.size.height)];
    imageView.image = image;

    return imageView;
}

- (void)buildSelectorYearsOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Years
    
    _scrollViewYears = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 10.0, width, self.frame.size.height - 44.0 - kFlatDatePickerHeaderBottomMargin)];
    _scrollViewYears.tag = TAG_YEARS;
    _scrollViewYears.delegate = self;
    _scrollViewYears.backgroundColor = kFlatDatePickerBackgroundColorScrolView;
    _scrollViewYears.showsHorizontalScrollIndicator = NO;
    _scrollViewYears.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollViewYears];

    _yearsTopArrow = [self addMoreDateIndicatorViewWithParentFrame:_scrollViewYears.frame onTop:YES];
    _yearsBottomArrow = [self addMoreDateIndicatorViewWithParentFrame:_scrollViewYears.frame onTop:NO];
    [self addSubview:_yearsTopArrow];
    [self addSubview:_yearsBottomArrow];

    _lineYearsTop = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewYears.frame.origin.x + kFlatDatePickerLineMargin, _scrollViewYears.frame.origin.y + (_scrollViewYears.frame.size.height / 2) - (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineYearsTop.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineYearsTop];
    
    _lineYearsBottom = [[UIView alloc] initWithFrame:CGRectMake(_scrollViewYears.frame.origin.x + kFlatDatePickerLineMargin, _scrollViewYears.frame.origin.y + (_scrollViewYears.frame.size.height / 2) + (kFlatDatePickerScrollViewItemHeight / 2), width - (2 * kFlatDatePickerLineMargin), kFlatDatePickerLineWidth)];
    _lineYearsBottom.backgroundColor = kFlatDatePickerBackgroundColorLines;
    [self addSubview:_lineYearsBottom];
    
    // Update ScrollView Data
    [self buildSelectorLabelsYears];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureYearsCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_scrollViewYears addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsYears {
    CGFloat offsetContentScrollView = self.datePickerMode == FlatDatePickerModeDate ?
                                            (_scrollViewMonths.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0 :
                                            (_scrollViewDays.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0 ;

    if (_labelsYears != nil && _labelsYears.count > 0) {
        for (UILabel *label in _labelsYears) {
            [label removeFromSuperview];
        }
    }
    
    _labelsYears = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _years.count; i++) {
        
        NSString *day = (NSString*)[_years objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * kFlatDatePickerScrollViewItemHeight) + offsetContentScrollView, _scrollViewYears.frame.size.width, kFlatDatePickerScrollViewItemHeight)];
        labelDay.text = day;
        labelDay.font = kFlatDatePickerFontLabel;
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = kFlatDatePickerFontColorLabel;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [_labelsYears addObject:labelDay];
        [_scrollViewYears addSubview:labelDay];
    }
    
    _scrollViewYears.contentSize = CGSizeMake(_scrollViewYears.frame.size.width, (kFlatDatePickerScrollViewItemHeight * _years.count) + (offsetContentScrollView * 2));
}

- (void)removeSelectorYears {
    
    if (_scrollViewYears != nil) {
        [_scrollViewYears removeFromSuperview];
        _scrollViewYears = nil;
    }
    if (_lineYearsTop != nil) {
        [_lineYearsTop removeFromSuperview];
        _lineYearsTop = nil;
    }
    if (_lineYearsBottom != nil) {
        [_lineYearsBottom removeFromSuperview];
        _lineYearsBottom = nil;
    }
}

#pragma mark - Show and Dismiss
- (void)show
{
    if (_parentView != nil)
    {
        if (self.hidden == YES) {
            self.hidden = NO;
        }
        if (_isInitialized == NO) {
            self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height, self.frame.size.width, self.frame.size.height);
            _isInitialized = YES;
        }
        int indexDays = [self getIndexForScrollViewPosition:_scrollViewDays];
        [self highlightLabelInArray:_labelsDays atIndex:indexDays];

        int indexMonths = [self getIndexForScrollViewPosition:_scrollViewMonths];
        [self highlightLabelInArray:_labelsMonths atIndex:indexMonths];

        int indexYears = [self getIndexForScrollViewPosition:_scrollViewYears];
        [self highlightLabelInArray:_labelsYears atIndex:indexYears];
//        self.frame = CGRectMake(self.frame.origin.x, _parentView.frame.size.height - kFlatDatePickerHeight, self.frame.size.width, self.frame.size.height);
    }
}

#pragma mark - DatePicker Mode
- (void)setDatePickerMode:(FlatDatePickerMode)mode {
    _datePickerMode = mode;
    [self setupControl];
}

#pragma mark - DatePicker Date Maximum And Minimum
- (void)setMinimumDate:(NSDate*)date {
    _minimumDate = date;
    [self setupControl];
    [self setDate:date animated:NO withDelegateCallback:NO];
}

#pragma mark - Collections
- (NSMutableArray*)getYears
{
    NSMutableArray *years = [[NSMutableArray alloc] init];

    NSInteger yearMin = kStartYear;
    
    NSInteger yearMax = 0;
    NSDateComponents* componentsMax = nil;
    
    if (self.maximumDate != nil) {
        componentsMax = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.maximumDate];
        yearMax = [componentsMax year];
    } else {
        componentsMax = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        yearMax = [componentsMax year] + 20;
    }

    for (NSInteger i = yearMin; i <= yearMax; i++) {
        [years addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    return years;
}

- (NSMutableArray*)getMonths
{
    NSMutableArray *months = [[NSMutableArray alloc] init];
    
    for (int monthNumber = 1; monthNumber <= 12; monthNumber++) {
        
        NSString *dateString = [NSString stringWithFormat: @"%d", monthNumber];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        if (self.timeZone != nil) [dateFormatter setTimeZone:self.timeZone];
        [dateFormatter setLocale:self.locale];
        [dateFormatter setDateFormat:@"MM"];
        NSDate* myDate = [dateFormatter dateFromString:dateString];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if (self.timeZone != nil) [dateFormatter setTimeZone:self.timeZone];
        [dateFormatter setLocale:self.locale];
        [formatter setDateFormat:@"MMM"];
        NSString *stringFromDate = [formatter stringFromDate:myDate];
        
        [months addObject:stringFromDate];
    }
  
    return months;
}

- (NSMutableArray*)getDaysInMonth:(NSDate*)date {

    if (date == nil)
        date = [NSDate date];
    
    NSRange daysRange = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSMutableArray *days = [[NSMutableArray alloc] init];
    for (int i = 1; i <= daysRange.length; i++) {
        [days addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return days;
}

#pragma mark - UIScrollView Delegate
- (void)singleTapGestureDaysCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (_lineDaysTop.frame.origin.y)) {
        if (_selectedDay > 1) {
            _selectedDay -= 1;
            [self setScrollView:_scrollViewDays atIndex:(_selectedDay - 1) animated:YES withDelegateCallback:YES];
        }
    } else if (touchY > (_lineDaysBottom.frame.origin.y)) {
        if (_selectedDay < _days.count) {
            _selectedDay += 1;
            [self setScrollView:_scrollViewDays atIndex:(_selectedDay - 1) animated:YES withDelegateCallback:YES];
        }
    }
}

- (void)singleTapGestureMonthsCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;

    if (touchY < (_lineMonthsTop.frame.origin.y)) {
        if (_selectedMonth > 1) {
            _selectedMonth -= 1;
            [self setScrollView:_scrollViewMonths atIndex:(_selectedMonth - 1) animated:YES withDelegateCallback:YES];
        }
    } else if (touchY > (_lineMonthsBottom.frame.origin.y)) {
        if (_selectedMonth < _months.count) {
            _selectedMonth += 1;
            [self setScrollView:_scrollViewMonths atIndex:(_selectedMonth - 1) animated:YES withDelegateCallback:YES];
        }
    }
}

- (void)singleTapGestureYearsCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    NSInteger minYear = kStartYear;
    if (touchY < (_lineYearsTop.frame.origin.y)) {
        if (_selectedYear > minYear) {
            _selectedYear -= 1;
            [self setScrollView:_scrollViewYears atIndex:(_selectedYear - minYear) animated:YES withDelegateCallback:YES];
        }
    } else if (touchY > (_lineYearsBottom.frame.origin.y)) {
        if (_selectedYear < (_years.count + (minYear - 1))) {
            _selectedYear += 1;
            [self setScrollView:_scrollViewYears atIndex:(_selectedYear - minYear) animated:YES withDelegateCallback:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = [self getIndexForScrollViewPosition:scrollView];
    
    [self updateSelectedDateAtIndex:index forScrollView:scrollView];

    if (scrollView.tag == TAG_DAYS) {
        _daysTopArrow.hidden = index == 0;
        _daysBottomArrow.hidden = index == _labelsDays.count-1;
        [self highlightLabelInArray:_labelsDays atIndex:index];
    } else if (scrollView.tag == TAG_MONTHS) {
        _monthsTopArrow.hidden = index == 0;
        _monthsBottomArrow.hidden = index == _labelsMonths.count-1;
        [self highlightLabelInArray:_labelsMonths atIndex:index];
    } else if (scrollView.tag == TAG_YEARS) {
        _yearsTopArrow.hidden = index == 0;
        _yearsBottomArrow.hidden = index == _labelsYears.count-1;
        [self highlightLabelInArray:_labelsYears atIndex:index];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    int index = [self getIndexForScrollViewPosition:scrollView];

    [self updateSelectedDateAtIndex:index forScrollView:scrollView];

    [self setScrollView:scrollView atIndex:index animated:YES withDelegateCallback:YES];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:dateDidChange:)]) {
        [self.delegate flatDatePicker:self dateDidChange:[self getDate]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    int index = [self getIndexForScrollViewPosition:scrollView];

    [self updateSelectedDateAtIndex:index forScrollView:scrollView];
    
    [self setScrollView:scrollView atIndex:index animated:YES withDelegateCallback:YES];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:dateDidChange:)]) {
        [self.delegate flatDatePicker:self dateDidChange:[self getDate]];
    }
}

- (void)updateSelectedDateAtIndex:(int)index forScrollView:(UIScrollView*)scrollView
{
    if (scrollView.tag == TAG_DAYS) {
        _selectedDay = index + 1; // 1 to 31
    } else if (scrollView.tag == TAG_MONTHS) {
        _selectedMonth = index + 1; // 1 to 12
        // Updates days :
        [self updateNumberOfDays];

    } else if (scrollView.tag == TAG_YEARS) {
        _selectedYear = kStartYear + index;
        // Updates days :
        [self updateNumberOfDays];
    }

    if ([[self getDate] timeIntervalSinceDate:_minimumDate] < 0) {
        [self setDate:_minimumDate animated:NO withDelegateCallback:YES];
    } else if ([[self getDate] timeIntervalSinceNow] < 0) {
        [self setDate:[NSDate date] animated:NO withDelegateCallback:YES];
    }
}

- (void)updateNumberOfDays
{
    // Updates days :
    NSDate *date = [self convertToDateDay:1 month:_selectedMonth year:_selectedYear hours:0 minutes:0 seconds:0 date:nil];
    
    if (date != nil)
    {
        NSMutableArray *newDays = [self getDaysInMonth:date];
        if (newDays.count != _days.count) {
            
            _days = newDays;
            
            [self buildSelectorLabelsDays];
            
            if (_selectedDay > _days.count) {
                _selectedDay = _days.count;
            }
            
            [self highlightLabelInArray:_labelsDays atIndex:_selectedDay - 1];
        }
    }
}

- (int)getIndexForScrollViewPosition:(UIScrollView *)scrollView {

    CGFloat offsetContentScrollView = (scrollView.frame.size.height - kFlatDatePickerScrollViewItemHeight) / 2.0;
    CGFloat offetY = scrollView.contentOffset.y;
    CGFloat index = floorf((offetY + offsetContentScrollView) / kFlatDatePickerScrollViewItemHeight);
    if (IS_PHONE) {
        index = (index - 1);
    } else {
        index = (index - 2);
    }
    return index;
}

- (void)setScrollView:(UIScrollView*)scrollView atIndex:(NSInteger)index animated:(BOOL)animated withDelegateCallback:(BOOL)callDelegateMethod
{
    if (scrollView != nil)
    {
        if (animated) {
            [UIView beginAnimations:@"ScrollViewAnimation" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:kFlatDatePickerAnimationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        }
        scrollView.contentOffset = CGPointMake(0.0, (index * kFlatDatePickerScrollViewItemHeight));
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:dateDidChange:)] && callDelegateMethod) {
            [self.delegate flatDatePicker:self dateDidChange:[self getDate]];
        }
    }
}

- (void)highlightLabelInArray:(NSMutableArray*)labels atIndex:(int)index {
    
    if (labels != nil) {
        
        if ((index - 1) >= 0 && (index - 1) < labels.count) {
            UILabel *label = (UILabel*)[labels objectAtIndex:(index - 1)];
            label.textColor = kFlatDatePickerFontColorLabel;
            label.backgroundColor = [UIColor clearColor];
            label.font = kFlatDatePickerFontLabel;
        }
        
        if (index >= 0 && index < labels.count) {
            UILabel *label = (UILabel*)[labels objectAtIndex:index];
            label.textColor = kFlatDatePickerFontColorLabelSelected;
            label.backgroundColor = kFlatDatePickerBackgroundColorSelected;
            label.font = kFlatDatePickerFontLabelSelected;
        }
        
        if ((index + 1) >= 0 && (index + 1) < labels.count) {
            UILabel *label = (UILabel*)[labels objectAtIndex:(index + 1)];
            label.textColor = kFlatDatePickerFontColorLabel;
            label.backgroundColor = [UIColor clearColor];
            label.font = kFlatDatePickerFontLabel;
        }
    }
}

#pragma mark - Date

- (void)setDate:(NSDate *)date animated:(BOOL)animated withDelegateCallback:(BOOL)delegateCallback
{
    if (date != nil)
    {
        NSDateComponents* components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:date];
       
        _selectedDay = [components day];
        _selectedMonth = [components month];
        _selectedYear = [components year];
        
        [self setScrollView:_scrollViewDays atIndex:(_selectedDay - 1) animated:animated withDelegateCallback:NO];
        [self setScrollView:_scrollViewMonths atIndex:(_selectedMonth - 1) animated:animated withDelegateCallback:NO];
        [self setScrollView:_scrollViewYears atIndex:(_selectedYear - kStartYear) animated:animated withDelegateCallback:NO];

        if (delegateCallback) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(flatDatePicker:dateDidChange:)]) {
                [self.delegate flatDatePicker:self dateDidChange:[self getDate]];
            }
        }
    }
}

- (NSDate*)convertToDateDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds date:(NSDate*)date
{
    NSDateComponents *dateComponents = nil;
    // Date Mode :
    if (self.datePickerMode == FlatDatePickerModeDate)
    {
        dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setTimeZone:self.timeZone];
        [dateComponents setCalendar:self.calendar];
        [dateComponents setYear:year];
        [dateComponents setMonth:month];
        [dateComponents setDay:day];
    }
    
    return [dateComponents date];
}

- (NSDate*)getDate
{
    NSDate *selectedDate = nil;
    
    if (_dates.count > 0 && _selectedDate >= 0 && _selectedDate < _dates.count) {
        selectedDate = (NSDate*)[_dates objectAtIndex:_selectedDate];
    }
    return [self convertToDateDay:_selectedDay month:_selectedMonth year:_selectedYear hours:0 minutes:0 seconds:0 date:selectedDate];
}

@end
