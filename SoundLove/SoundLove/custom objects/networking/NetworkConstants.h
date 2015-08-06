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
static NSString * const kConcertsRecommendedList = @"likes/list";
static NSString * const kFavoriteConcertsList = @"rank/list";

static NSString * const kBandsList = @"http://api-eventim.makers.do/festivals/band/list";
static NSString * const kGenresList = @"http://api-eventim.makers.do/festivals/genre/list";

static NSString * const kTicketShop = @"tickets/order";
static NSString * const kConcertIncrement = @"rank/increment";
static NSString * const kConcertDecrement = @"rank/decrement";

// To get recommended concerts
// http://api-eventim.makers.do/events/likes/list?user_id=XXX&access_token=xxx

#endif
