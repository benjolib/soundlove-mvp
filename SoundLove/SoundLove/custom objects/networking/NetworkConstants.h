//
//  NetworkConstants.h
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#ifndef Festivalama_NetworkConstants_h
#define Festivalama_NetworkConstants_h

static NSString * const kBaseURL = @"http://api-eventim.makers.do/events/";

static NSString * const kConcertsList = @"list";
static NSString * const kConcertsRecommendedList = @"recommended/list";
static NSString * const kFavoriteConcertsList = @"calendar/list";

static NSString * const kFacebookConnectURL = @"http://api-eventim.makers.do/user/facebook/connect?";

static NSString * const kKunstlerFavorites = @"http://api-eventim.makers.do/artists/favorites/list";
static NSString * const kKunstlerRecommended = @"http://api-eventim.makers.do/artists/recommended/list";

static NSString * const  kKunstlerLike = @"http://api-eventim.makers.do/artists/favorites/add";
static NSString * const  kKunstlerDisLike = @"http://api-eventim.makers.do/artists/favorites/remove";

static NSString * const kBandsList = @"http://api-eventim.makers.do/festivals/band/list";
static NSString * const kGenresList = @"http://api-eventim.makers.do/events/categories/list";

static NSString * const kTicketShop = @"tickets/order";
static NSString * const kConcertIncrement = @"calendar/add";
static NSString * const kConcertDecrement = @"calendar/remove";

#endif
