//
//  TicketShopperClient.h
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "AbstractClient.h"

@class ConcertModel;

@interface TicketShopperClient : AbstractClient

- (void)sendTicketShopWithNumberOfTickets:(NSInteger)ticketNumber concert:(ConcertModel*)concert name:(NSString*)name email:(NSString*)email
                          completionBlock:(void (^)(NSString *errorMessage, BOOL completed))completionBlock;

@end
