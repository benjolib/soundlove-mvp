//
//  AbstractClient.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 28/05/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "AbstractClient.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "OverlayTransitionManager.h"

#define kRetryLimit 3

@interface AbstractClient () <OverlayViewControllerDelegate>
@property (nonatomic, strong) OverlayTransitionManager *overlayTransitionManager;
@property (nonatomic, strong) OverlayViewController *overlayViewController;
@property (nonatomic, copy) void (^completionBlock)(NSData *data, NSString *errorMessage, BOOL completed);
@property (nonatomic, copy) NSURLRequest *retryRequest;
@property (nonatomic, copy) NSURLSession *retrySession;
@property (nonatomic) NSInteger retryCount;
@end

@implementation AbstractClient

- (NSURLSessionConfiguration*)defaultSessionConfiguration
{
    // setup the configuration for the session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.allowsCellularAccess = YES;
    [sessionConfiguration setHTTPAdditionalHeaders:@{@"Content-Type": @"application/json"}];
    sessionConfiguration.timeoutIntervalForRequest = 20.0;
    sessionConfiguration.timeoutIntervalForResource = 20.0;
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
    return sessionConfiguration;
}

- (void)startDataTaskWithRequest:(NSURLRequest*)request forSession:(NSURLSession*)session withCompletionBlock:(void (^)(NSData *data, NSString *errorMessage, BOOL completed))completionBlock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;

        NSInteger statusCode = httpResponse.statusCode;
        if (statusCode != 200 && weakSelf.retryCount < kRetryLimit)
        {
            weakSelf.completionBlock = completionBlock;
            weakSelf.retryRequest = request;
            weakSelf.retrySession = session;
            weakSelf.retryCount++;

            if (![weakSelf isInternetConnectionAvailable] && statusCode == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf showNoInternetConnectionPopup];
                });
            } else {
                [weakSelf startDataTaskWithRequest:request forSession:session withCompletionBlock:weakSelf.completionBlock];
            }
        }
        else
        {
            completionBlock(data, error.localizedDescription, (statusCode == 200));
        }
    }];

    [[NSOperationQueue new] addOperationWithBlock:^{
        [task resume];
    }];
}

#pragma mark - handle internet connection
- (void)showNoInternetConnectionPopup
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;

    self.overlayTransitionManager = [[OverlayTransitionManager alloc] init];
    self.overlayViewController = [self.overlayTransitionManager presentOverlayViewWithType:OverlayTypeNoInternet onViewController:window.rootViewController];
    self.overlayViewController.delegate = self;
}

- (void)overlayViewControllerConfirmButtonPressed
{
    [self startDataTaskWithRequest:self.retryRequest forSession:self.retrySession withCompletionBlock:self.completionBlock];
}

- (BOOL)isInternetConnectionAvailable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
