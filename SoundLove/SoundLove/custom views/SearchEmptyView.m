//
//  SearchEmptyView.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 14/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "SearchEmptyView.h"
#import "UIColor+GlobalColors.h"

@interface SearchEmptyView ()
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@end

@implementation SearchEmptyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
        for (id object in bundle) {
            if ([object isKindOfClass:[SearchEmptyView class]]) {
                self = object;
                break;
            }
        }
    }
    return self;
}

+ (CGFloat)viewHeight
{
    return 270.0;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor globalGreenColor];
    self.titleLabel.textColor = [UIColor globalGreenColor];
}

- (void)showEmptyFilter
{
    self.textLabel.text = @"";
}

- (void)showEmptySearch
{
    self.textLabel.text = @"Wir haben leider keine Ergebnisse für Deine Suche gefunden";
}

- (void)showEmptyCalendarView
{
    self.textLabel.text = @"";
}

- (void)setText:(NSString*)text
{
    self.textLabel.text = text;
}

@end
