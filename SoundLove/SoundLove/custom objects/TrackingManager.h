//
//  TrackingManager.h
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackingManager : NSObject

+ (instancetype)sharedManager;

- (void)trackUserLaunchedApp;

- (void)userTapsMenuButton;
- (void)userTapsKonzerte;
- (void)userTapsKalendar;
- (void)userTapsBeliebteKonzerte;
- (void)userTapsKunstler;
- (void)userTapsLogout;
- (void)userTapsInfo;

- (void)userSavesConcertToCalendar;
- (void)userRemovesConcertFromCalendar;
- (void)userOpensFilter;
- (void)userOpensSorting;
- (void)userOpensSearch;
- (void)userSelectsConcertForDetails;

// Konzerte
- (void)userTapsFavoriten;
- (void)userTapsEmpfohlen;
- (void)userTapsAll;

- (void)userTapsTrashIcon;
- (void)userTapsShare;
- (void)userTapsFreundeTab;
- (void)userTapsMeineEventsTab;

- (void)userLeavesConcertDetail;
- (void)userTapsToTicketShopButton;
- (void)userTapsLadeFreundeEin;

- (void)userTapsAnfrageSenden;

// Beliebte concerts
- (void)userTapsTodayTab;
- (void)userTapsThisWeekTab;
- (void)userTapsThisMonthTab;

// Filter
- (void)userTapsNachMusikGenre;
- (void)userTapsBands;
- (void)userTapsPrice;
- (void)userTapsDate;
- (void)userTapsLocation;
- (void)userTapsBackButtonFromFilterDetail;
- (void)userTapsTrashButtonOnMain;
- (void)userTapsFilterSearch;
- (void)userTapsSelectsAGenreArtist;
- (void)userTapsDeSelectsAGenreArtist;
- (void)userTapsTrashButtonOnDetail;

// Sorting
- (void)userTapsNoSorting;
- (void)userTapsPriceDESC;
- (void)userTapsPriceASC;
- (void)userTapsDateDESC;
- (void)userTapsDateASC;

// Info view
- (void)userTapsWasWirMachen;
- (void)userTapsTeileDieApp;
- (void)userTapsBewerteDieApp;

// Review overlay
- (void)userTapsReviewNow;
- (void)userTapsReviewLater;

@end
