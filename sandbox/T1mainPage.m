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
        
        [self.tableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:@"Available Friends"];
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl = self.refreshControl;
        [self.refreshControl addTarget:self
                                action:@selector(handleRefresh:)
                      forControlEvents:UIControlEventValueChanged];
        
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
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    /*
     FriendList *myOnlineFriendListelement = [[FriendList alloc]initWithName:@"My first online friend" onLineorNot:(YES)];
     [self.FriendListelements addObject:myOnlineFriendListelement];
     
     FriendList *myOfflineFriendListelement = [[FriendList alloc]initWithName:@"My first Offline friend" onLineorNot:(NO)];
     [self.FriendListelements addObject:myOfflineFriendListelement];
     */
    // reload the data
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [onlineFriendList removeAllObjects];
    [offlineFriendList removeAllObjects];
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
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    for (SimpleDBAttribute *attr in response.attributes) {
        if (![attr.name isEqualToString:@"2060000000"]) {
        NSLog(@"number to search is %@", attr.name);
        NSString *startTime = [hp getAtrributeValue:attr.name item:@"availbilityItem" attribute:@"startTimeAttribute"];
        NSString *endTime = [hp getAtrributeValue:attr.name item:@"availbilityItem" attribute:@"endTimeAttribute"];
        FriendList *myOnlineFriendListelement = [[FriendList alloc]initWithName:attr.value onLineorNot:(YES) number:attr.name start:startTime end:endTime];
            
            
            // DON'T DELETE!!!!!!!!!!!!!!!!!!!!
            /*
            if (onlineFriendList.count > 0) {
                for (int i = 0; i<onlineFriendList.count; i++) {
                    FriendList *local = [onlineFriendList objectAtIndex:i];
                    if (local.startTime.length > 8 && myOnlineFriendListelement.startTime.length > 8) {
                        NSDateFormatter *df = [[NSDateFormatter alloc] init];
                        [df setDateFormat:@"EEE,MM/dd hh:mm a"];
                        for (int j = 0; j< onlineFriendList.count
                             ; j++) {
                            NSDate *localDate = [[NSDate alloc]init];
                            localDate = [df dateFromString:local.startTime];
                            NSDate *newDate = [[NSDate alloc]init];
                            newDate = [df dateFromString:myOnlineFriendListelement.startTime];
                            if ([localDate compare:newDate] == NSOrderedDescending) {
                                [onlineFriendList insertObject:myOnlineFriendListelement atIndex:j];
                            }
                            break;
                        }
                        [onlineFriendList addObject:myOnlineFriendListelement];
                        
                    }else{
                        [onlineFriendList insertObject:myOnlineFriendListelement atIndex:0];
                    }
                }*/
            //}else{
                [onlineFriendList addObject:myOnlineFriendListelement];
            //}
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
    NSString *cellIdentifier = currentFriend.onLineorNot ? OnLineCellIndetifier : OffLineCellIndetifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( indexPath.section == 0 ){
        currentFriend = [onlineFriendList objectAtIndex:indexPath.row];  // which cell we looking at
    }else{
        currentFriend = [offlineFriendList objectAtIndex:indexPath.row];  // which cell we looking at
    }
    
    
    
    // if you have extra give it to me
    
    
    if (cell==nil){
        if( indexPath.section == 0 ){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            NSMutableString *label = [[NSMutableString alloc]initWithFormat:@"%@",currentFriend.startTime];
            [label appendFormat:@"\n to \n"];
            [label appendFormat:@"%@",currentFriend.endTime];
            cell.detailTextLabel.text = label;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
            cell.detailTextLabel.numberOfLines = 3;
        }else{
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }else{
        if (indexPath.section == 0) {
            NSMutableString *label = [[NSMutableString alloc]initWithFormat:@"%@",currentFriend.startTime];
            [label appendFormat:@"\n to \n"];
            [label appendFormat:@"%@",currentFriend.endTime];
            cell.detailTextLabel.text = label;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
            cell.detailTextLabel.numberOfLines = 3;
        }

    }
    
    // Configure the cell...
    cell.textLabel.text = currentFriend.name;
    return cell;
}




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
        NSLog(@"it's here");
        prefer.onlineORoffline = @"online";
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            simpleDBHelper *hp = [[simpleDBHelper alloc] init];
            NSString* startTime = [hp getAtrributeValue:currentFriend.phoneNumber item:@"availbilityItem" attribute:@"startTimeAttribute"];
            NSString* endTime = [hp getAtrributeValue:currentFriend.phoneNumber item:@"availbilityItem" attribute:@"endTimeAttribute"];
            startTime = [startTime stringByAppendingString:@" - "];
            startTime = [startTime stringByAppendingString:endTime];
            prefer.friendAvailablity = startTime;
            prefer.friendPreference = [hp getAtrributeValue:currentFriend.phoneNumber item:@"preferenceItem" attribute:@"preferenceAttribute"];
            dispatch_async(dispatch_get_main_queue(),^{
                //add all of them to the table view
                [self performSelector:@selector(stopRKLoading) withObject:nil];
            });
            
        });
    }else if([segue.identifier isEqualToString:@"offlineFriendClicked"]){
        prefer.onlineORoffline = @"offline";
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.rowHeight * 1.5;
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

- (void) handleRefresh:(id)paramSender{
    
    /* Put a bit of delay between when the refresh control is released
     and when we actually do the refreshing to make the UI look a bit
     smoother than just doing the update without the animation */
    int64_t delayInSeconds = 1.0f;
    dispatch_time_t popTime =
    dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
    });
    
}
- (IBAction)sortFriend:(id)sender {
    for (int m = 0; m < onlineFriendList.count; m++) {
        
    
        FriendList *myOnlineFriendListelement = [onlineFriendList objectAtIndex:m];
    for (int i = 0; i<onlineFriendList.count; i++) {
        FriendList *local = [onlineFriendList objectAtIndex:i];
        if (local.startTime.length > 8 && myOnlineFriendListelement.startTime.length > 8) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"EEE,MM/dd hh:mm a"];
            for (int j = 0; j< onlineFriendList.count
                 ; j++) {
                NSDate *localDate = [[NSDate alloc]init];
                localDate = [df dateFromString:local.startTime];
                NSDate *newDate = [[NSDate alloc]init];
                newDate = [df dateFromString:myOnlineFriendListelement.startTime];
                if ([localDate compare:newDate] == NSOrderedDescending) {
                    [onlineFriendList insertObject:myOnlineFriendListelement atIndex:j];
                }
                break;
            }
            [onlineFriendList addObject:myOnlineFriendListelement];
            
        }else{
            [onlineFriendList insertObject:myOnlineFriendListelement atIndex:0];
        }
    }
    
    }
    [self.tableView reloadData];

    
}
@end
