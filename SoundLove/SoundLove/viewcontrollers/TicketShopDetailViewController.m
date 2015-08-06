//
//  TicketShopDetailViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 10/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "TicketShopDetailViewController.h"
#import "ConcertModel.h"
#import "RoundedButton.h"
#import "TicketShopTableViewCell.h"
#import "CustomNavigationView.h"
#import "TicketShopperClient.h"
#import "OverlayViewController.h"
#import "OverlayTransitionManager.h"
#import "UIColor+GlobalColors.h"
//#import "TrackingManager.h"

@interface TicketShopDetailViewController () <UITextFieldDelegate, OverlayViewControllerDelegate>
@property (nonatomic, strong) TicketShopperClient *shopperClient;
@property (nonatomic, strong) OverlayTransitionManager *overlayTransitionManager;
@property (nonatomic, strong) OverlayViewController *overlayViewController;
@end

@implementation TicketShopDetailViewController

- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonTapped:(id)sender
{
    BOOL allFieldsAreValid = [self allFieldsAreValid];
    
    if (allFieldsAreValid)
    {
//        [[TrackingManager sharedManager] trackUserSendsAnfrage];

        TicketShopTableViewCell *cell1 = (TicketShopTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        TicketShopTableViewCell *cell2 = (TicketShopTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        TicketShopTableViewCell *cell3 = (TicketShopTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

        // send the request
        self.shopperClient = [[TicketShopperClient alloc] init];
        [self.shopperClient sendTicketShopWithNumberOfTickets:[cell1.textfield.text integerValue]
                                                     concert:self.concertToDisplay
                                                         name:cell2.textfield.text
                                                        email:cell3.textfield.text
                                              completionBlock:^(NSString *errorMessage, BOOL completed) {
                                                  if (completed) {
                                                      [self showConfirmationPopup];
                                                  } else {
                                                      // TODO: needs input
                                                  }
        }];
    }
    else
    {

    }
}

- (BOOL)allFieldsAreValid
{
    TicketShopTableViewCell *cell1 = (TicketShopTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    TicketShopTableViewCell *cell2 = (TicketShopTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    TicketShopTableViewCell *cell3 = (TicketShopTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

    BOOL allFieldsAreValid = YES;
    if ([cell1 isFieldEmpty]) {
        allFieldsAreValid = NO;
    }
    if ([cell2 isFieldEmpty]) {
        allFieldsAreValid = NO;
    }
    if ([cell3 isFieldEmpty] || ![cell3 isEmailValid]) {
        allFieldsAreValid = NO;
    }

    return allFieldsAreValid;
}

- (void)showConfirmationPopup
{
    self.overlayTransitionManager = [[OverlayTransitionManager alloc] init];
    self.overlayViewController = [self.overlayTransitionManager presentOverlayViewWithType:OverlayTypeTicket24 onViewController:self];
    self.overlayViewController.delegate = self;
}

- (void)overlayViewControllerConfirmButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTicketButtonEnabled:(BOOL)enabled
{
    [self.sendButton setButtonActive:enabled];
}

#pragma mark - textField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.tableView reloadData];

    [self setTicketButtonEnabled:[self allFieldsAreValid]];
}

#pragma mark - tableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (indexPath.row == 0) {
        cell.textfield.keyboardType = UIKeyboardTypeDecimalPad;
        [cell setFieldIsValid:![cell isFieldEmpty]];
        [cell setTextFieldPlaceholderText:@"Wie viele Tickets benötigst du?"];
    } else if (indexPath.row == 1) {
        cell.textfield.keyboardType = UIKeyboardTypeDefault;
        [cell setFieldIsValid:![cell isFieldEmpty]];
        [cell setTextFieldPlaceholderText:@"Wie ist dein Vorname?"];
    } else {
        cell.textfield.keyboardType = UIKeyboardTypeEmailAddress;
        [cell setFieldIsValid:[cell isEmailValid]];
        [cell setTextFieldPlaceholderText:@"Wie ist deine E-mail Adresse?"];
    }
    cell.textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:cell.textfield.placeholder
                                                                           attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.5]}];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TicketShopTableViewCell *cell = (TicketShopTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.textfield becomeFirstResponder];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationView.titleLabel.text = self.concertToDisplay.name;

    [self setTicketButtonEnabled:NO];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
