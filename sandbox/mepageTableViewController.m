//
//  mepageTableViewController.m
//  sandbox
//
//  Created by wuyue on 3/28/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "mepageTableViewController.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
//#import "FriendListTableViewController.m"
extern NSString *USER_NAME;
@interface mepageTableViewController ()

@end

@implementation mepageTableViewController
@synthesize me_NickName_textfield = _me_NickName_textfield;
@synthesize me_Password_textfield = _me_Password_textfield;
@synthesize me_rePassword_textfield = _me_rePassword_textfield;
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
     [self.view addGestureRecognizer:tap];
    
    //me_NickName_textfield.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
/*

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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


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
-(void)dismissKeyboard {
    [_me_NickName_textfield resignFirstResponder];
    [_me_Password_textfield resignFirstResponder];
    [_me_rePassword_textfield resignFirstResponder];
}
- (IBAction)me_back_button:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)me_update_button:(id)sender {
     NSLog(@"NickName text field%@", _me_NickName_textfield.text);
     NSLog(@"password text field%@", _me_Password_textfield.text);
     NSLog(@"repassword text field%@", _me_rePassword_textfield.text);
 
    // get the nickname on the database
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:@"2066608173" andItemName:@"nicknameItem"];
    SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
    NSLog(@"nickname here is %@", response.attributes);
    // update the nickname on the database
    //SimpleDBAttribute *attr = response;
    //NSString *nickname = [[NSString alloc]initWithName:attr.value];
    
    
    //SimpleDBDeleteAttributesRequest *deleteItem = [[[SimpleDBDeleteAttributesRequest alloc] initWithDomainName:@"2066608173" andItemName:@"nicknameItem"]autorelease];
    //[sdbClient deleteAttributes:deleteItem];
    
    
    //FriendList *myOnlineFriendListelement = [[FriendList alloc]initWithName:attr.value onLineorNot:(YES) number:attr.name];
    //[onlineFriendList addObject:myOnlineFriendListelement];

    //  NSLog(@"repassword text field%@", USER_NAME);
    // print out the current password on the database
    // print out the changed
    
}
@end
