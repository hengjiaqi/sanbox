//
//  FriendListTableViewController.m
//  friendlist
//
//  Created by wuyue on 3/24/14.
//  Copyright (c) 2014 wuyue. All rights reserved.
//

#import "FriendListTableViewController.h"
#import "FriendList.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
NSString *USER_NAME;
NSMutableArray *onlineFriendList;
NSMutableArray *offlineFriendList;


@interface FriendListTableViewController ()

@end

@implementation FriendListTableViewController

// set and get the frindlist

@synthesize FriendListelements = _FriendListelements;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"Tabs showed up!");
    [self loadFriends];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Tabs showed up!");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    [self.tableView reloadData];
    
    /*
    FriendList *myOnlineFriendListelement = [[FriendList alloc]initWithName:@"My first online friend" onLineorNot:(YES)];
    [self.FriendListelements addObject:myOnlineFriendListelement];
    
    FriendList *myOfflineFriendListelement = [[FriendList alloc]initWithName:@"My first Offline friend" onLineorNot:(NO)];
    [self.FriendListelements addObject:myOfflineFriendListelement];
    */
    // reload the data
}


- (void)loadFriends{
    //load all the online friend
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"onlineFriendListItem"];
    SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
    if(response.error != nil)
    {
        NSLog(@"Error: %@", response.error);
    }
    if (onlineFriendList == nil) {
        onlineFriendList = [[NSMutableArray alloc] initWithCapacity:[response.attributes count]];
    }
    else {
        [onlineFriendList removeAllObjects];
    }
    for (SimpleDBAttribute *attr in response.attributes) {
        FriendList *myOnlineFriendListelement = [[FriendList alloc]initWithName:attr.value onLineorNot:(YES) number:attr.name];
        [onlineFriendList addObject:myOnlineFriendListelement];
    }
    
    [self.tableView reloadData];
    //load all the offline friend
    SimpleDBGetAttributesRequest *gar2 = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"offlineFriendListItem"];
    SimpleDBGetAttributesResponse *response2 = [[AmazonClientManager sdb] getAttributes:gar2];
    if(response2.error != nil)
    {
        NSLog(@"Error: %@", response2.error);
    }
    if (offlineFriendList == nil) {
        offlineFriendList = [[NSMutableArray alloc] initWithCapacity:[response2.attributes count]];
    }
    else {
        [offlineFriendList removeAllObjects];
    }
    int count = 0;
    for (SimpleDBAttribute *attr in response2.attributes) {
        FriendList *myOfflineFriendListelement = [[FriendList alloc]initWithName:attr.value onLineorNot:(NO) number:attr.name];
        [offlineFriendList addObject:myOfflineFriendListelement];
        count++;
    }
    NSLog(@"RESPONSE2 IS %d", count);
    
    //add all of them to the table view
    self.FriendListelements =[[NSMutableArray alloc]init];
    [self.FriendListelements addObjectsFromArray:(onlineFriendList)];
    [self.FriendListelements addObjectsFromArray:(offlineFriendList)];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections. always in one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"THERE ARE %d", self.FriendListelements.count);
    return self.FriendListelements.count;
}

// we can refer certain view
// index path a list of numbers what row we looking at

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OnLineCellIndetifier = @"OnLineFriendCell";  // what type of cell  to actuall indentify use that in story board
    
    
    static NSString *OffLineCellIndetifier = @"OffLineFriendCell";
    // which friend we point at
    FriendList *currentFriend = [self.FriendListelements objectAtIndex:indexPath.row];  // which cell we looking at
    
    
    NSString *cellIdentifier = currentFriend.onLineorNot ? OnLineCellIndetifier : OffLineCellIndetifier;
    
    
    // if you have extra give it to me
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    
    
    // set the text of the cell
    cell.textLabel.text = currentFriend.name;
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendList *currentFriend = [self.FriendListelements objectAtIndex:indexPath.row];
    
    
}

-(void)cancelButtonPress:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
