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
static NSString * const kCategoriesList = @"category/list";
static NSString * const kBandsList = @"band/list";
static NSString * const kPopularFestivalsList = @"rank/list";
static NSString * const kTicketShop = @"tickets/order";
static NSString * const kFestivalIncrement = @"rank/increment";
static NSString * const kFestivalDecrement = @"rank/decrement";

// To get recommended concerts
// http://api-eventim.makers.do/events/likes/list?user_id=XXX&access_token=xxx

#endif
