//
//  FriendListTableViewController.m
//  friendlist
//
//  Created by wuyue on 3/24/14.
//  Copyright (c) 2014 wuyue. All rights reserved.
//

#import "FriendListTableViewController.h"
#import "FriendList.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.FriendListelements =[[NSMutableArray alloc]init];
    FriendList *myOnlineFriendListelement = [[FriendList alloc]initWithName:@"My first online friend" onLineorNot:(YES)];
    [self.FriendListelements addObject:myOnlineFriendListelement];
    
    FriendList *myOfflineFriendListelement = [[FriendList alloc]initWithName:@"My first Offline friend" onLineorNot:(NO)];
    
    [self.FriendListelements addObject:myOfflineFriendListelement];
    
    // reload the data
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

-(void)cancelButtonPress:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

@end
