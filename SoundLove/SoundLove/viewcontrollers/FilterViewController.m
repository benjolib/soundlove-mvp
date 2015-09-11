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

@implementation FilterViewController

- (IBAction)unwindFromSubViewControllers:(UIStoryboardSegue*)unwindSegue
{
    [TRACKER userTapsBackButtonFromFilterDetail];

    FilterViewController *subViewController = unwindSegue.sourceViewController;
    self.filterModel = subViewController.filterModel;

    [self.tableView reloadData];
}

- (void)adjustButtonToFilterModel
{
    if ([self.filterModel isFiltering]) {
        [self setTrashIconVisible:YES];
    } else {
        [self setTrashIconVisible:NO];
    }
}

- (void)setTrashIconVisible:(BOOL)visible
{
    self.trashButton.alpha = visible ? 1.0 : 0.2;
}

- (void)cellTrashButtonPressed:(UIButton*)button
{
    [TRACKER userTapsTrashButtonOnMain];

    UIView *aSuperview = [button superview];
    while (![aSuperview isKindOfClass:[FilterBandsTableViewCell class]]) {
        aSuperview = [aSuperview superview];
    }

    FilterBandsTableViewCell *cell = (FilterBandsTableViewCell*)aSuperview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath.row == 0) {
        self.filterModel.selectedGenresArray = [NSArray array];
    } else if (indexPath.row == 1) {
        self.filterModel.selectedBandsArray = [NSArray array];
    } else if (indexPath.row == 2) {
        self.filterModel.fromPrice = 0;
        self.filterModel.toPrice = 0;
    } else if (indexPath.row == 3) {
        self.filterModel.startDate = nil;
        self.filterModel.endDate = nil;
    } else {
        [self.filterModel resetFiterLocation];
    }

    [self.tableView reloadData];

    [self adjustButtonToFilterModel];
}

- (IBAction)trashButtonPressed:(id)sender
{
    [TRACKER userTapsTrashButtonOnMain];

    [self.filterModel clearFilters];
    [self.tableView reloadData];

    [self adjustButtonToFilterModel];
}

#pragma mark - tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
        case 0: {
            cell.nameLabel.text = @"Genre";
            enableTrashIcon = self.filterModel.selectedGenresArray.count > 0;
            NSString *genresString = [self.filterModel genresString];
            cell.bandDetailLabel.text = genresString;
            [cell setCellActive:enableTrashIcon];
            break;
        }
        case 1: {
            cell.nameLabel.text = @"Künstler";
            enableTrashIcon = self.filterModel.selectedBandsArray.count > 0;
            NSString *bandString = [self.filterModel bandsString];
            cell.bandDetailLabel.text = bandString;
            [cell setCellActive:enableTrashIcon];
            break;
        }
        case 2:
            cell.nameLabel.text = @"Preis";
            cell.bandDetailLabel.text = [self.filterModel priceString];
            enableTrashIcon = (self.filterModel.fromPrice || self.filterModel.toPrice) != 0;
            [cell setCellActive:enableTrashIcon];
            break;
        case 3:
            cell.nameLabel.text = @"Datum";
            cell.bandDetailLabel.text = [self.filterModel dateString];
            enableTrashIcon = self.filterModel.startDate || self.filterModel.endDate;
            [cell setCellActive:enableTrashIcon];
            break;
        case 4:
            cell.nameLabel.text = @"Ort";
            cell.bandDetailLabel.text = @"";
            enableTrashIcon = [self.filterModel isLocationFilteringSet];
            [cell setCellActive:enableTrashIcon];
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
            [TRACKER userTapsNachMusikGenre];
            [self performSegueWithIdentifier:@"openListView" sender:indexPath];
            break;
        case 1:
            [TRACKER userTapsBands];
            [self performSegueWithIdentifier:@"openBands" sender:indexPath];
            break;
        case 2:
            [TRACKER userTapsPrice];
            [self performSegueWithIdentifier:@"openPreisView" sender:indexPath];
            break;
        case 3:
            [TRACKER userTapsDate];
            [self performSegueWithIdentifier:@"openDateView" sender:indexPath];
            break;
        case 4:
            [TRACKER userTapsLocation];
            [self performSegueWithIdentifier:@"openLocationView" sender:indexPath];
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"closeFilter"]) {
        return;
    }

    if (![segue.identifier isEqualToString:@"applyFilter"] || ![segue.identifier isEqualToString:@"showSortView"]) {
        FilterViewController *viewController = segue.destinationViewController;
        viewController.filterModel = self.filterModel;
    }
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 81.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView hideLoadingIndicator];

    [self adjustButtonToFilterModel];
    [self.navigationView setShadowActive:YES];

    if (!self.filterModel) {
        self.filterModel = [[FilterModel alloc] init];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self adjustButtonToFilterModel];
}

- (void)reloadView
{
    [self.tableView reloadData];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
