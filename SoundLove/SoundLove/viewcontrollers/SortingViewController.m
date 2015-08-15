//
//  SortingViewController.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 30/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "SortingViewController.h"
#import "LoadingTableView.h"
#import "FilterTableViewCell.h"
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
    FilterTableViewCell *cell = (FilterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
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
    self.sortingOptions = @[[SortingObject sortingWithName:@"Keine Sortierung" andKey:@"" orderDir:@""],
                           [SortingObject sortingWithName:@"Preis (hoch zu niedrig)" andKey:@"price_from" orderDir:@"DESC"],
                           [SortingObject sortingWithName:@"Preis (niedrig zu hoch)" andKey:@"price_from" orderDir:@"ASC"],
                           [SortingObject sortingWithName:@"Date (bald bis in weiter Zukunft)" andKey:@"date_ts" orderDir:@"DESC"],
                           [SortingObject sortingWithName:@"Date (bald bis in weiter Zukunft)" andKey:@"date_ts" orderDir:@"ASC"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
