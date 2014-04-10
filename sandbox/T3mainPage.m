//
//  T3preferenceMainTableViewController.m
//  sandbox
//
//  Created by wuyue on 4/4/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T3mainPage.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "simpleDBhelper.h"
//#import "FriendListTableViewController.m"
NSString *USER_NAME;
NSString *GNickname;
@interface T3mainPage ()

@end

@implementation T3mainPage
@synthesize Availability;
@synthesize myPreference;
@synthesize tableView;

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
    
    
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    NSString *starttimeload;
    NSString *endtimeload;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"availbilityItem"];
    SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
    for (SimpleDBAttribute *attr in response.attributes) {
        NSLog(@"nickname here is %@", attr.name);
        if([attr.name isEqualToString:@"startTimeAttribute"]){
            starttimeload = attr.value;
        }else{
            endtimeload = attr.value;
        }
    }
    NSString *displayAvailability =  [NSString stringWithFormat:@"%@ - %@", starttimeload, endtimeload];
    _labelOnAvailability.textColor = [UIColor grayColor];
    _labelOnAvailability.text = displayAvailability;
    
    simpleDBHelper *hp = [[simpleDBHelper alloc] init];
    NSString *loadstring = [hp getAtrributeValue: USER_NAME item:@"preferenceItem" attribute:@"preferenceAttribute"];
    
    _labelOnPreference.numberOfLines = 0; //will wrap text in new line
    [_labelOnPreference sizeToFit];
    _labelOnPreference.textColor = [UIColor grayColor];
    _labelOnPreference.text = loadstring;
}

@end
