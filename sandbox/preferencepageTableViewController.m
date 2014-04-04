//
//  preferencepageTableViewController.m
//  sandbox
//
//  Created by wuyue on 3/28/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "preferencepageTableViewController.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "simpleDBhelper.h"
@interface preferencepageTableViewController ()

@end

@implementation preferencepageTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
@end
