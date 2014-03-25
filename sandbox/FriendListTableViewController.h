//
//  FriendListTableViewController.h
//  friendlist
//
//  Created by wuyue on 3/24/14.
//  Copyright (c) 2014 wuyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListTableViewController : UITableViewController
-(IBAction)cancelButtonPress:(id)sender;

// create a mutable array list for friend list
@property(nonatomic,strong) NSMutableArray *FriendListelement;

@end
