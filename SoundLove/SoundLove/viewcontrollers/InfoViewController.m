//
//  InfoViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 05/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "InfoViewController.h"
#import "BaseTableViewCell.h"
#import <StoreKit/StoreKit.h>
//#import "TrackingManager.h"
#import "GeneralSettings.h"

@interface InfoViewController () <SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) NSArray *cellTitlesArray;
@end

@implementation InfoViewController

- (NSArray*)cellTitlesArray
{
    if (!_cellTitlesArray) {
        _cellTitlesArray = @[@"Was wir machen", @"Teile die App", @"Bewerte die App", @"Unsere Festival App", @"Unsere Apps", @"Auf Jobsuche?"];
    }

    return _cellTitlesArray;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitlesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.cellTitlesArray[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureIcon"]];
    cell.accessoryView = accessoryView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        [[TrackingManager sharedManager] trackUserSelectsWasWirMachen];
        [self performSegueWithIdentifier:@"openWhatWeDo" sender:nil];
    } else if (indexPath.row == 1) {
//        [[TrackingManager sharedManager] trackUserSelectsTeileDieApp];
        [self shareTheApp];
    } else {
//        [[TrackingManager sharedManager] trackUserSelectsBewerteDieApp];
        [self rateTheApp];
    }
}

- (void)shareTheApp
{
    NSString *stringToShare = @"FestivaLama App besorgt Dir die besten Festival Deals für Dich und Deine Freunde www.FestivaLama.io";
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[stringToShare]
                                                                                         applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                     UIActivityTypePrint,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypePostToFlickr,
                                                     UIActivityTypeSaveToCameraRoll,
                                                     UIActivityTypeAddToReadingList];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (void)rateTheApp
{
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    [storeProductViewController setDelegate:self];

    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : [GeneralSettings appStoreID]} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);

        } else {
            // Present Store Product View Controller
            [self presentViewController:storeProductViewController animated:YES completion:nil];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Info";

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

@end
