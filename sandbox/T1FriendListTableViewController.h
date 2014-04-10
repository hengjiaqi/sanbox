//
//  FriendListTableViewController.h
//  friendlist
//
//  Created by wuyue on 3/24/14.
//  Copyright (c) 2014 wuyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T1FriendListTableViewController : UITableViewController
//-(IBAction)cancelButtonPress:(id)sender;

// create a mutable array list for friend list reorder editing 
// here is domains  tasks
@property(nonatomic,strong) NSMutableArray *FriendListelements;

@end
