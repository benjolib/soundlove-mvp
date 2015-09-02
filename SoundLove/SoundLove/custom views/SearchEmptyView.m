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
@property (nonatomic, strong) IBOutlet UIImageView *logoView;
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
    return 450.0;
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
    self.logoView.image = [UIImage imageNamed:@"emptySearchIcon"];
    self.textLabel.text = @"Wir haben leider keine Ergebnisse für Deine Suche gefunden";
}

- (void)showEmptyCalendarView
{
    self.logoView.image = [UIImage imageNamed:@"emptyKalendar"];
    self.textLabel.text = @"Zur Zeit ist diese Liste leer. Lade am besten ein paar Freunde zu Deinen Konzerten ein, um diese Liste zu füllen.";
}

- (void)showEmptyKunslterFavoriteView
{
    self.logoView.image = [UIImage imageNamed:@"emptyKünstler"];
    self.textLabel.text = @"Deine Favoriten-Liste ist zur Zeit noch leer. Sobald Du einen Künstler oder eine Band markierst, kannst Du sie unter Favoriten einsehen.";
}

- (void)setText:(NSString*)text
{
    self.textLabel.text = text;
}

@end
