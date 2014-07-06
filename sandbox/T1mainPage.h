//
//  FriendListTableViewController.h
//  friendlist
//
//  Created by wuyue on 3/24/14.
//  Copyright (c) 2014 wuyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>
#import "loadingAnimation.h"

#import <UIKit/UIKit.h>
#import <AWSS3/AWSS3.h>
#import <QuartzCore/QuartzCore.h>
typedef enum {
    GrandCentralDispatch,
    Delegate,
    BackgroundThread
} UploadType;
@interface T1mainPage : UITableViewController
//-(IBAction)cancelButtonPress:(id)sender;

// create a mutable array list for friend list reorder editing 
// here is domains  tasks
@property(nonatomic,strong) NSMutableArray *FriendListelements;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL fromPreferencePage;
@property (nonatomic, retain) AmazonS3Client *s3;

- (IBAction)sortFriend:(id)sender;

@end
