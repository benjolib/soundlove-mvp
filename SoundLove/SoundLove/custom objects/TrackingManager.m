//
//  TrackingManager.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 14/08/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "TrackingManager.h"
#import "Adjust.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface TrackingManager ()
@property(nonatomic, strong) id<GAITracker> tracker;
@end

@implementation TrackingManager

+ (instancetype)sharedManager
{
    static TrackingManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupAdjustTracker];
        [self setupGATracker];
    }
    return self;
}

#pragma mark - GA tracking
- (void)setupGATracker
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;

    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 40;

#ifdef DEBUG
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelInfo];
#endif

    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-62788448-12"];

    self.tracker = [[GAI sharedInstance] defaultTracker];
}

#pragma mark - adjustTracking
- (void)setupAdjustTracker
{
    NSString *yourAppToken = @"8zunhuxkf4wv";
    NSString *environment;
#ifdef DEBUG
    environment = ADJEnvironmentSandbox;
#else
    environment = ADJEnvironmentProduction;
#endif
    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:yourAppToken
                                                environment:environment];
    [Adjust appDidLaunch:adjustConfig];
    [adjustConfig setLogLevel:ADJLogLevelDebug];
}

#pragma mark - tracking methods
- (void)trackEventWithToken:(NSString*)token
{
    ADJEvent *event = [ADJEvent eventWithEventToken:token];
    [Adjust trackEvent:event];
}

- (void)trackUserLaunchedApp
{
    [self trackEventWithToken:@"zds6oq"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userLaunchedApp"
                                                                value:nil] build]];
}

- (void)userTapsMenuButton
{
    [self trackEventWithToken:@"z5b52y"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userTapsMenuButton"
                                                                value:nil] build]];
}

- (void)userTapsKonzerte
{
    [self trackEventWithToken:@"r9mrmw"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"opensConcerte"
                                                                value:nil] build]];
}

- (void)userTapsKalendar
{
    [self trackEventWithToken:@"hlwrvp"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"opensKalendar"
                                                                value:nil] build]];
}

- (void)userTapsBeliebteKonzerte
{
    [self trackEventWithToken:@"drohi9"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"opensBeliebteKonzerte"
                                                                value:nil] build]];
}

- (void)userTapsKunstler
{
    [self trackEventWithToken:@"dkezlq"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"opensKunstler"
                                                                value:nil] build]];
}

- (void)userTapsLogout
{
    [self trackEventWithToken:@"5rmt8g"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsLogout"
                                                                value:nil] build]];
}

- (void)userTapsInfo
{
    [self trackEventWithToken:@"fhry93"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"opensInfoView"
                                                                value:nil] build]];
}


- (void)userSavesConcertToCalendar
{
    [self trackEventWithToken:@"xhxqbg"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"savesConcertToKalendar"
                                                                value:nil] build]];
}

- (void)userRemovesConcertFromCalendar
{
    [self trackEventWithToken:@"hifked"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"deselectsConcert"
                                                                value:nil] build]];
}

- (void)userOpensFilter
{
    [self trackEventWithToken:@"gfeqx3"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"opensFilterView"
                                                                value:nil] build]];
}

- (void)userOpensSorting
{
    [self trackEventWithToken:@"6jnxsq"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"opensSortingView"
                                                                value:nil] build]];
}

- (void)userOpensSearch
{
    [self trackEventWithToken:@"je5i7a"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"opensSearch"
                                                                value:nil] build]];
}

- (void)userSelectsConcertForDetails
{
    [self trackEventWithToken:@"qwol01"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsConcertForDetails"
                                                                value:nil] build]];
}


// Konzerte
- (void)userTapsFavoriten
{
    [self trackEventWithToken:@"szz9su"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsFavoriteConcertTab"
                                                                value:nil] build]];
}

- (void)userTapsEmpfohlen
{
    [self trackEventWithToken:@"daenlz"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsEmpfohlenTab"
                                                                value:nil] build]];
}

- (void)userTapsAll
{
    [self trackEventWithToken:@"bo2eqh"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsAllTab"
                                                                value:nil] build]];
}


- (void)userTapsTrashIcon
{
    [self trackEventWithToken:@"9ff0kl"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsTrashButtonAtKalendar"
                                                                value:nil] build]];
}

- (void)userTapsShare
{
    [self trackEventWithToken:@"rd3c87"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsShareButtonAtKalendar"
                                                                value:nil] build]];
}

- (void)userTapsFreundeTab
{
    [self trackEventWithToken:@"qjfbcx"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsFreundeTabAtKalendar"
                                                                value:nil] build]];
}

- (void)userTapsMeineEventsTab
{
    [self trackEventWithToken:@"x20bs9"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsMeineEventsAtKalendar"
                                                                value:nil] build]];
}


- (void)userLeavesConcertDetail
{
    [self trackEventWithToken:@"btlkbc"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userLeavesConcertDetailView"
                                                                value:nil] build]];
}

- (void)userTapsToTicketShopButton
{
    [self trackEventWithToken:@"xbx1du"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userTapsJetztZumTicketShop"
                                                                value:nil] build]];
}

- (void)userTapsLadeFreundeEin
{
    [self trackEventWithToken:@"ci5mfr"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userSelectsToInviteFriendToConcert"
                                                                value:nil] build]];
}


- (void)userTapsAnfrageSenden
{
    [self trackEventWithToken:@"rbcbws"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsAnfrageSender"
                                                                value:nil] build]];
}


// Beliebte concerts
- (void)userTapsTodayTab
{
    [self trackEventWithToken:@"tl38du"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsTodayAtBeliebteConcert"
                                                                value:nil] build]];
}

- (void)userTapsThisWeekTab
{
    [self trackEventWithToken:@"42kpd9"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsThisWeekAtBeliebteConcert"
                                                                value:nil] build]];
}

- (void)userTapsThisMonthTab
{
    [self trackEventWithToken:@"5jakot"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"selectsThisMonthAtBeliebteConcert"
                                                                value:nil] build]];
}


// Filter
- (void)userTapsNachMusikGenre
{
    [self trackEventWithToken:@"aubp17"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsFilterMusikGenre"
                                                                value:nil] build]];
}

- (void)userTapsBands
{
    [self trackEventWithToken:@"ak1bcm"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsFilterBands"
                                                                value:nil] build]];
}

- (void)userTapsPrice
{
    [self trackEventWithToken:@"z4bvn8"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsFilterPrice"
                                                                value:nil] build]];
}

- (void)userTapsDate
{
    [self trackEventWithToken:@"kcf9cj"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsFilterDate"
                                                                value:nil] build]];
}

- (void)userTapsLocation
{
    [self trackEventWithToken:@"becaqq"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsFilterLocation"
                                                                value:nil] build]];
}

- (void)userTapsBackButtonFromFilterDetail
{
    [self trackEventWithToken:@"btlkbc"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsFilterBackButton"
                                                                value:nil] build]];
}

- (void)userTapsTrashButtonOnMain
{
    [self trackEventWithToken:@"3el6t4"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsFilterMenuTrashButton"
                                                                value:nil] build]];
}

- (void)userTapsFilterSearch
{
    [self trackEventWithToken:@"d40t8x"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsFilterSearch"
                                                                value:nil] build]];
}

- (void)userTapsSelectsAGenreArtist
{
    [self trackEventWithToken:@"dzv9cx"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userSelectsFilterArtistGenre"
                                                                value:nil] build]];
}

- (void)userTapsDeSelectsAGenreArtist
{
    [self trackEventWithToken:@"3bceft"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userDeselectsFilterArtistGenre"
                                                                value:nil] build]];
}

- (void)userTapsTrashButtonOnDetail
{
    [self trackEventWithToken:@"py2h2f"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userTapsTrashButtonFilterDetail"
                                                                value:nil] build]];
}


// Sorting
- (void)userTapsNoSorting
{
    [self trackEventWithToken:@"vvpsyv"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsNoSortingOption"
                                                                value:nil] build]];
}

- (void)userTapsPriceDESC
{
    [self trackEventWithToken:@"wl4iex"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsPriceDESCSorting"
                                                                value:nil] build]];
}

- (void)userTapsPriceASC
{
    [self trackEventWithToken:@"yexvoj"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsPriceASCSorting"
                                                                value:nil] build]];
}

- (void)userTapsDateDESC
{
    [self trackEventWithToken:@"yerwlj"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsDateDESCSorting"
                                                                value:nil] build]];
}

- (void)userTapsDateASC
{
    [self trackEventWithToken:@"uq1wg6"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsDateASCSorting"
                                                                value:nil] build]];
}


// Info view
- (void)userTapsWasWirMachen
{
    [self trackEventWithToken:@"pzlunk"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsWasWirMachen"
                                                                value:nil] build]];
}

- (void)userTapsTeileDieApp
{
    [self trackEventWithToken:@"157917"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsTeileDieApp"
                                                                value:nil] build]];
}

- (void)userTapsBewerteDieApp
{
    [self trackEventWithToken:@"sbo8sd"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"tapsBewerteDieApp"
                                                                value:nil] build]];
}


// Review overlay
- (void)userTapsReviewNow
{
    [self trackEventWithToken:@"q3hi3f"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userTapsReviewNow"
                                                                value:nil] build]];
}

- (void)userTapsReviewLater
{
    [self trackEventWithToken:@"tdf5a2"];

    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                               action:@"launch"
                                                                label:@"userTapsReviewLater"
                                                                value:nil] build]];
}


@end
