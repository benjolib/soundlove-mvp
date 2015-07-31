//
//  FilterViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 29/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "FilterViewController.h"
#import "UIColor+GlobalColors.h"
#import "FilterBandsTableViewCell.h"
#import "FilterGenresViewController.h"
#import "CustomNavigationView.h"

#define IS_iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface FilterViewController ()
@end

@implementation FilterViewController

- (void)adjustButtonToFilterModel
{
//    if ([[FilterModel sharedModel] isFiltering]) {
//        [self setTrashIconVisible:YES];
//        [self.applyButton setTitle:@"Suchen" forState:UIControlStateNormal];
//    } else {
//        [self setTrashIconVisible:NO];
//        [self.applyButton setTitle:@"Suchen" forState:UIControlStateNormal];
//    }
}

- (void)cellTrashButtonPressed:(UIButton*)button
{
    UIView *aSuperview = [button superview];
    while (![aSuperview isKindOfClass:[FilterBandsTableViewCell class]]) {
        aSuperview = [aSuperview superview];
    }

    FilterBandsTableViewCell *cell = (FilterBandsTableViewCell*)aSuperview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

//    if (indexPath.row == 0) {
//        [FilterModel sharedModel].selectedGenresArray = [NSArray array];
//    } else if (indexPath.row == 1) {
//        [FilterModel sharedModel].selectedBandsArray = [NSArray array];
//    } else if (indexPath.row == 2) {
//        [FilterModel sharedModel].selectedPostcodesArray = [NSArray array];
//        [FilterModel sharedModel].selectedCountriesArray = [NSArray array];
//    }
//
//    [[TrackingManager sharedManager] trackFilterTapsTrashIconOnMainBandCell];
//    [self.tableView reloadData];
//
//    [self adjustButtonToFilterModel];
}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_iOS8) {
        return UITableViewAutomaticDimension;
    }
    return 81.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterBandsTableViewCell *cell = (FilterBandsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"bandsCell"];
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor clearColor];

    BOOL enableTrashIcon = NO;

    switch (indexPath.row)
    {
        case 0:
            cell.nameLabel.text = @"Musik Genre";
            [cell setCellActive:NO];
            break;
        case 1:
            cell.nameLabel.text = @"Nach Künstlern";
            [cell setCellActive:NO];
            break;
        case 2:
            cell.nameLabel.text = @"Preis";
            [cell setCellActive:NO];
            break;
        case 3:
            cell.nameLabel.text = @"Datum";
            [cell setCellActive:NO];
            break;
        default:
            break;
    }

    if (enableTrashIcon) {
        cell.trashButton.userInteractionEnabled = YES;
        [cell.trashButton addTarget:self action:@selector(cellTrashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.trashButton setImage:[UIImage imageNamed:@"filterTrashIcon"] forState:UIControlStateNormal];
    } else {
        cell.trashButton.userInteractionEnabled = NO;
        [cell.trashButton setImage:[UIImage imageNamed:@"disclosureIcon"] forState:UIControlStateNormal];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
            [self performSegueWithIdentifier:@"openListView" sender:indexPath];
            break;
        case 1:

            break;
        case 2:
            [self performSegueWithIdentifier:@"openPreisView" sender:indexPath];
            break;
        case 3:
            [self performSegueWithIdentifier:@"openDateView" sender:indexPath];
            break;
        default:
            break;
    }

//    if (indexPath.row == 0) {
////        [self performSegueWithIdentifier:@"openGenres" sender:nil];
////        [[TrackingManager sharedManager] trackFilterSelectsGenreView];
//    } else if (indexPath.row == 1) {
////        [[TrackingManager sharedManager] trackFilterSelectsBandsView];
////        [self performSegueWithIdentifier:@"openBands" sender:nil];
//    } else if (indexPath.row == 2){
////        [[TrackingManager sharedManager] trackFilterSelectsPlaceView];
////        [self performSegueWithIdentifier:@"showLocation" sender:nil];
//    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openListView"])
    {
        if ([sender isKindOfClass:[NSIndexPath class]])
        {
            NSIndexPath *indexPath = (NSIndexPath*)sender;
            switch (indexPath.row)
            {
                case 0:
                    // genres
                    break;
                case 1:
                    // bands
                    break;
                case 2:
                    // preis
                    break;
                case 3:
                    // datum
                    break;
                default:
                    break;
            }
        }
    } else if ([segue.identifier isEqualToString:@"openPreisView"]) {
        
    } else if ([segue.identifier isEqualToString:@"openDatum"]) {

    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 81.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView hideLoadingIndicator];

    self.navigationView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
    self.navigationView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.navigationView.layer.shadowRadius = 2.0;
    self.navigationView.layer.shadowOpacity = 1.0;
    self.navigationView.backgroundColor = [UIColor navigationBarBackgroundColor];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
