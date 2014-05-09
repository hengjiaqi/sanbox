//
//  FriendListTableViewController.m
//  friendlist
//
//  Created by wuyue on 3/24/14.
//  Copyright (c) 2014 wuyue. All rights reserved.
//

#import "T1mainPage.h"
#import "FriendList.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "T1friendPreference.h"
#import "simpleDBHelper.h"
NSString *USER_NAME;
NSMutableArray *onlineFriendList;
NSMutableArray *offlineFriendList;
FriendList *currentFriend;

//setup the dispatch//
@interface T1mainPage (){
    dispatch_queue_t queue;
}

@end

@implementation T1mainPage

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
    
    [loadingAnimation showHUDAddedTo:self.view animated:YES];
    [self loadFriends];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Tabs showed up!");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    
    [self.tableView reloadData];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LOGGED_IN"];

    
    /*
     FriendList *myOnlineFriendListelement = [[FriendList alloc]initWithName:@"My first online friend" onLineorNot:(YES)];
     [self.FriendListelements addObject:myOnlineFriendListelement];
     
     FriendList *myOfflineFriendListelement = [[FriendList alloc]initWithName:@"My first Offline friend" onLineorNot:(NO)];
     [self.FriendListelements addObject:myOfflineFriendListelement];
     */
    // reload the data
    
    
}


- (void)loadFriends{
    
    
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    //*************************************//
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
        if (![myOnlineFriendListelement.phoneNumber isEqualToString:@"2060000000"]) {
            [onlineFriendList addObject:myOnlineFriendListelement];
        }
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
        if (![myOfflineFriendListelement.phoneNumber isEqualToString:@"2060000000"]) {
            [offlineFriendList addObject:myOfflineFriendListelement];
            count++;
        }
        
    }
    NSLog(@"RESPONSE2 IS %d", count);
        dispatch_async(dispatch_get_main_queue(),^{
    //add all of them to the table view
    self.FriendListelements =[[NSMutableArray alloc]init];
    [self.FriendListelements addObjectsFromArray:(onlineFriendList)];
    [self.FriendListelements addObjectsFromArray:(offlineFriendList)];
    [self.tableView reloadData];
            
            //Call the method to hide the Indicator after 3 seconds
            [self performSelector:@selector(stopRKLoading) withObject:nil];
        });
        
    });
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return onlineFriendList.count;
    }else{
        return offlineFriendList.count;
    }
}

// we can refer certain view
// index path a list of numbers what row we looking at

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OnLineCellIndetifier = @"Available Friends";  // what type of cell  to actuall indentify use that in story board
    
    
    static NSString *OffLineCellIndetifier = @"UnAvailable Friends";
    // which friend we point at
    if( indexPath.section == 0 ){
        currentFriend = [onlineFriendList objectAtIndex:indexPath.row];  // which cell we looking at

    }else{
        currentFriend = [offlineFriendList objectAtIndex:indexPath.row];  // which cell we looking at

    }
    
    
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
    currentFriend = [self.FriendListelements objectAtIndex:indexPath.row];
    if (currentFriend.onLineorNot) {
        [self performSegueWithIdentifier:@"onlineFriendClicked" sender:self];
    }else{
        [self performSegueWithIdentifier:@"offlineFriendClicked" sender:self];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    T1friendPreference *prefer = (T1friendPreference *)[[segue destinationViewController] topViewController];
    NSLog(@"second, %@", currentFriend.name);
    
    prefer.friendPhoneNumber = currentFriend.phoneNumber;
    prefer.friendNickName = currentFriend.name;
    if([segue.identifier isEqualToString:@"onlineFriendClicked"]){
        prefer.onlineORoffline = @"online";
    }else if([segue.identifier isEqualToString:@"offlineFriendClicked"]){
        prefer.onlineORoffline = @"offline";
    }
}


-(void)cancelButtonPress:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Available Friends";
    }
    else if(section == 1)
    {
        return @"Unavailable Friends";
    }
    else
    {
        return @"Title2";
    }
}
-(void)stopRKLoading
{
    [loadingAnimation hideHUDForView:self.view animated:YES];
}
@end
