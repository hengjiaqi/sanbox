//
//  AddFriendTableViewController.h
//  friendlist
//
//  Created by wuyue on 3/24/14.
//  Copyright (c) 2014 wuyue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendListTableViewController;
@interface AddFriendTableViewController : UITableViewController{
    IBOutlet UITextField *nameField;
}
// add the button click listener
-(IBAction)backButtonPress:(id)sender;
//-(IBAction)searchButtonPress:(id)sender;

- (IBAction)search:(id)sender;


// add the friend into list
@property(nonatomic, strong)FriendListTableViewController * FriendListViewController_ADD;
@end
