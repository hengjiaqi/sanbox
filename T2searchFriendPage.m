//
//  searchFriendPage.m
//  sandbox
//
//  Created by jake on 4/1/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T2searchFriendPage.h"
#import "FriendList.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "simpleDBhelper.h"
NSString *USER_NAME;
NSString* numberToAdd;
@interface T2searchFriendPage ()

@end

@implementation T2searchFriendPage

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
    self.FriendListelements =[[NSMutableArray alloc] initWithCapacity:1];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    FriendList *myOnlineFriendListelement = [[FriendList alloc]initWithName:self.friendNickName onLineorNot:(YES) number:self.friendPhoneNumber];
    [self.FriendListelements addObject:myOnlineFriendListelement];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FriendListelements.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    FriendList *currentFriend = [self.FriendListelements objectAtIndex:indexPath.row];
    
    cell.textLabel.text = currentFriend.name;

    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendList *currentFriend = [self.FriendListelements objectAtIndex:indexPath.row];
    numberToAdd = self.friendPhoneNumber;
    currentFriend.phoneNumber = numberToAdd;
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Add Friend" message:@"Send a friend request?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if ((buttonIndex == 0) && ([[alertView title] isEqualToString:@"Add Friend"]))
    {
        NSLog(@"dialog shows up");
        //Check to see if request has already been sent
        simpleDBHelper *hp = [[simpleDBHelper alloc]init];
        numberToAdd = self.friendPhoneNumber;
        NSLog(@"NUMBER TO ADD IS %@", numberToAdd);
        
        BOOL alreadySent = [hp hasAttributes:numberToAdd item:@"friendRequestListItem" attributeName:USER_NAME];
        NSLog(@"%hhd", alreadySent);
        if (alreadySent) {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Friend Request" message:@"You have already sent this person a request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //Get my nick name
            NSLog(@"2");
            NSString* myNickName = [[NSString alloc] init];
            myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
            NSLog(@"MY NICK NAME IS %@", myNickName);
            //send the request
            [hp addAtrribute:numberToAdd item:@"friendRequestListItem" attribute:USER_NAME value:myNickName];
        }
        
       
            
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
