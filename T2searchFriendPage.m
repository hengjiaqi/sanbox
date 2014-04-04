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
    numberToAdd = currentFriend.phoneNumber;
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Add Friend" message:@"Send a friend request?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if ((buttonIndex == 0) && ([[alertView title] isEqualToString:@"Add Friend"]));
    {
        //Check to see if request has already been sent
        SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:numberToAdd andItemName:@"friendRequestListItem"];
        SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
        BOOL alreadySent = NO;
        for (SimpleDBAttribute *attr in response.attributes) {
            if ([attr.name isEqualToString:USER_NAME]) {
                alreadySent = YES;
                break;
            }
        }
        if (alreadySent) {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Friend Request" message:@"You have already sent this person a request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //Get my nick name
            
            NSString* myNickName = [[NSString alloc] init];
            SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"nicknameItem"];
            SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
            for (SimpleDBAttribute *attr in response.attributes) {
                myNickName = attr.value;
            }
            NSLog(@"MY NICK NAME IS %@", myNickName);
            //send the request
            simpleDBHelper *hp = [[simpleDBHelper alloc] init];
            [hp addAtrribute:numberToAdd item:@"friendRequestListItem" attribute:USER_NAME value:myNickName];
        }
        
       
            
    }
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
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
