//
//  TicketShopperClient.m
//  Festivalama
//
//  Created by Szabolcs Sztanyi on 13/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "TicketShopperClient.h"
#import "ConcertModel.h"

@implementation TicketShopperClient

- (void)sendTicketShopWithNumberOfTickets:(NSInteger)ticketNumber concert:(ConcertModel*)concert name:(NSString*)name email:(NSString*)email
                          completionBlock:(void (^)(NSString *errorMessage, BOOL completed))completionBlock
{
    NSString *dateString = @""; //festival.startDateString ? festival.startDateString : festival.endDateString;
    NSString *urlSuffixString = [NSString stringWithFormat:@"?dates[]=%@&customer_name=%@&customer_email=%@&tickets_count=%ld&festival_name=%@", dateString, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], email, (long)ticketNumber, [concert.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", kBaseURL, kTicketShop, urlSuffixString];
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self defaultSessionConfiguration]];

    [super startDataTaskWithRequest:request forSession:session withCompletionBlock:^(NSData *data, NSString *errorMessage, BOOL completed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(errorMessage, completed);
        });
    }];
}

@end
