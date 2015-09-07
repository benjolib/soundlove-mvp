//
//  SortingViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "SortingViewController.h"
#import "LoadingTableView.h"
#import "FilterBandsTableViewCell.h"
#import "SortingObject.h"
#import "CustomNavigationView.h"
#import "SortingButton.h"

@interface SortingViewController ()
@property (nonatomic, strong) NSArray *sortingOptions;
@end

@implementation SortingViewController

#pragma mark - tableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterBandsTableViewCell *cell = (FilterBandsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryNone;

    SortingObject *sortingObj = self.sortingOptions[indexPath.row];
    cell.nameLabel.text = sortingObj.name;

    if ([self.selectedSortingObject isEqual:sortingObj]) {
        [cell setCellActive:YES];
    } else {
        [cell setCellActive:NO];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortingOptions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SortingObject *sortingObj = self.sortingOptions[indexPath.row];
    self.selectedSortingObject = sortingObj;

    switch (indexPath.row) {
        case 0:
            [TRACKER userTapsNoSorting];
            break;
        case 1:
            [TRACKER userTapsPriceDESC];
            break;
        case 2:
            [TRACKER userTapsPriceASC];
            break;
        case 3:
            [TRACKER userTapsDateDESC];
            break;
        case 4:
            [TRACKER userTapsDateASC];
            break;
        case 5:
            // Popularity sorting
            break;
        default:
            break;
    }

    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationView setTitle:@"Sortieren"];
    [self.tableView hideLoadingIndicator];
    [self populateArray];
    [self.tableView reloadData];
}

- (void)populateArray
{
    self.sortingOptions = @[[SortingObject sortingWithType:SortingTypeNone], [SortingObject sortingWithType:SortingTypePreisDESC], [SortingObject sortingWithType:SortingTypePreisASC],
                            [SortingObject sortingWithType:SortingTypeDateDESC], [SortingObject sortingWithType:SortingTypeDateASC], [SortingObject sortingWithType:SortingTypePopularity]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
