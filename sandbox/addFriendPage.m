//
//  addFriendPage.m
//  sandbox
//
//  Created by jake on 3/31/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "addFriendPage.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "searchFriendPage.h"
NSString *USER_NAME;
NSString *friendNumber;
NSString *friendNickname;
@interface addFriendPage ()

@end

@implementation addFriendPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
    numberToSearch.delegate = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goToSearchResult"]){
        searchFriendPage *confirmm = (searchFriendPage *)[[segue destinationViewController] topViewController];
        confirmm.friendPhoneNumber = friendNumber;
        confirmm.friendNickName = friendNickname;
    }
}
- (IBAction)searchNumber:(id)sender {
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
    if (![domains containsObject:numberToSearch.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot find this user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        // get the nickname on the database
        SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"friendListItem"];
        SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
        BOOL alreadyFriend = NO;
        for (SimpleDBAttribute *attr in response.attributes) {
            if ([attr.name isEqualToString:numberToSearch.text]) {
                alreadyFriend = YES;
                break;
            }
        }
        
        if (alreadyFriend) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This person is already your friend." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            
            SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:numberToSearch.text andItemName:@"nicknameItem"];
            SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
            friendNumber = numberToSearch.text;
            for (SimpleDBAttribute *attr in response.attributes) {
                friendNickname = attr.value;
            }
            [self performSegueWithIdentifier:@"goToSearchResult" sender:sender];
        }
    }
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)dismissKeyboard {
    [numberToSearch resignFirstResponder];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)keyboardDidShow:(NSNotification *)notification{
    if ([[UIScreen mainScreen]bounds].size.height==568) {
        [self.view setFrame:CGRectMake(0, -50, 320, 568)];
    }else{
        [self.view setFrame:CGRectMake(0, -130, 320, 480)];
    }
}


-(void)keyboardDidHide:(NSNotification *)notification{
    if ([[UIScreen mainScreen]bounds].size.height==568) {
        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        [self.view setFrame:CGRectMake(0, 0, 320, 480)];
    }
}
@end
