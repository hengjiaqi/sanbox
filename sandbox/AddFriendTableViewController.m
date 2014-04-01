//
//  AddFriendTableViewController.m
//  friendlist
//
//  Created by wuyue on 3/24/14.
//  Copyright (c) 2014 wuyue. All rights reserved.
//

#import "AddFriendTableViewController.h"
#import "FriendListTableViewController.h"
#import "FriendList.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
@interface AddFriendTableViewController ()

@end

@implementation AddFriendTableViewController
@synthesize FriendListViewController_ADD = _FriendListViewController_ADD;


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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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

// start the view control dimissiong your self 
-(void)backButtonPress:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
//-(IBAction)searchbuttonPressed:(id)sender
//{
//    tableData = @"aaa"; //load the values in the table source
//    [self.tableView reloadData]; //just call reloadData on the tableView
//}
//-(IBAction)searchButtonPress:(id)sender{
 //   FriendList *newFriendListElement = [[FriendList alloc] initWithName:self.nameField.text onLineorNot:NO];
    
    // if it doesn't find this person give a alerm
    
    // else go create a table view by having a button add 
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"cannot find this person" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
    
    //[alert show];
   // [self dismissModalViewControllerAnimated:YES];
//}

- (IBAction)search:(id)sender {
    NSMutableArray *domains = [[NSMutableArray alloc] init];
    SimpleDBListDomainsRequest  *listDomainsRequest  = [[SimpleDBListDomainsRequest alloc] init];
    SimpleDBListDomainsResponse *listDomainsResponse = [[AmazonClientManager sdb] listDomains:listDomainsRequest];
    if(listDomainsResponse.error != nil)
    {
        NSLog(@"Error: %@", listDomainsResponse.error);
    }
    
    if (domains == nil) {
        domains = [[NSMutableArray alloc] initWithCapacity:[listDomainsResponse.domainNames count]];
    }
    else {
        [domains removeAllObjects];
    }
    
    for (NSString *name in listDomainsResponse.domainNames) {
        [domains addObject:name];
    }
    if (![domains containsObject:nameField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Cannot find this person." delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
    }
    
    
    
    
    
    

}
@end
