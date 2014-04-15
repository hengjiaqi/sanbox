//
//  friendPreference.m
//  sandbox
//
//  Created by jake on 4/3/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T1friendPreference.h"
#import <QuartzCore/QuartzCore.h>
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "simpleDBHelper.h"
BOOL isOnline;

NSString* USER_NAME;
NSString* myNickName;

@interface T1friendPreference ()

@end

@implementation T1friendPreference
@synthesize checkBoxButton;

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
    NSLog(@"1221321");
    topbar.title = self.friendNickName;
    //[invisibleSwitch setOnTintColor:[UIColor redColor]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    simpleDBHelper *hp = [[simpleDBHelper alloc] init];
    myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
    if ([self.onlineORoffline isEqualToString:@"online"]) {
        isOnline = YES;
    }else{
        isOnline = NO;
    }
    phoneNumberLabel.text = self.friendPhoneNumber;
    simpleDBHelper *hp = [[simpleDBHelper alloc] init];
    NSString* startTime = [hp getAtrributeValue:self.friendPhoneNumber item:@"availbilityItem" attribute:@"startTimeAttribute"];
    NSString* endTime = [hp getAtrributeValue:self.friendPhoneNumber item:@"availbilityItem" attribute:@"endTimeAttribute"];
    NSLog(startTime);
    NSLog(endTime);
    startTime = [startTime stringByAppendingString:@" - "];
    if(isOnline){
        avaliableLabel.text = [startTime stringByAppendingString:endTime];
        preferenceLabel.text = [hp getAtrributeValue:self.friendPhoneNumber item:@"preferenceItem" attribute:@"preferenceAttribute"];

    }else{
        avaliableLabel.text = @"This person is currently unavailable";
        preferenceLabel.text = @"This person is currently unavailablehahahaahhahahahahahaahhaahahahaahahahahaahahahaahaha";
    }
    if (!isOnline) {
        phoneNumberLabel.textColor = [UIColor grayColor];
        avaliableLabel.textColor = [UIColor grayColor];
        preferenceLabel.textColor = [UIColor grayColor];
    }
    if ([hp hasAttributes:USER_NAME item:@"beUnavailableToListItem" attributeName:self.friendPhoneNumber]) {
        //[invisibleSwitch setOn:YES];
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    if (section == 3) {
        return 2;
    }
    return 1;
}






- (IBAction)switchChanged:(id)sender {
    //beUnavailable to this person
    simpleDBHelper *hp = [[simpleDBHelper alloc] init];
    NSLog(@"@%", myNickName);
    /*
    if (invisibleSwitch.isOn) {
        NSLog(@"it's on!");
        [hp addAtrribute:USER_NAME item:@"beUnavailableToListItem" attribute:self.friendPhoneNumber value:self.friendNickName];
        
        if([hp hasAttributes:self.friendPhoneNumber item:@"onlineFriendListItem" attributeName:USER_NAME]){
            [hp deleteAttributePair:self.friendPhoneNumber item:@"onlineFriendListItem" attributeName:USER_NAME attributeValue:myNickName];
            [hp addAtrribute:self.friendPhoneNumber item:@"offlineFriendListItem" attribute:USER_NAME value:myNickName];
        }
        
    }else{
        if([hp hasAttributes:USER_NAME item:@"beUnavailableToListItem" attributeName:self.friendPhoneNumber]){
            [hp deleteAttributePair:USER_NAME item:@"beUnavailableToListItem" attributeName:self.friendPhoneNumber attributeValue:self.friendNickName];
        }
        if([hp hasAttributes:self.friendPhoneNumber item:@"offlineFriendListItem" attributeName:USER_NAME]){
            [hp deleteAttributePair:self.friendPhoneNumber item:@"offlineFriendListItem" attributeName:USER_NAME attributeValue:myNickName];
            [hp addAtrribute:self.friendPhoneNumber item:@"onlineFriendListItem" attribute:USER_NAME value:myNickName];
        }
    }*/
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)checkBoxClicked:(id)sender {
    
    if (!checked) {
        [checkBoxButton setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
        checked = YES;
    }
    
    else if (checked) {
        [checkBoxButton setImage:[UIImage imageNamed:@"checkbox_normal.png"] forState:UIControlStateNormal];
        checked = NO;
    }
}
@end
