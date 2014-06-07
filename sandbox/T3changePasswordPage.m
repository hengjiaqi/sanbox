//
//  T3changePasswordPage.m
//  sandbox
//
//  Created by wuyue on 5/9/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T3changePasswordPage.h"

#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "simpleDBhelper.h"
//#import "FriendListTableViewController.m"
NSString *USER_NAME;
NSString *GNickname;


@interface T3changePasswordPage ()

@end

@implementation T3changePasswordPage

@synthesize password =_password;
@synthesize repassword= _repassword;
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
     simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //get the user name
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    
    // get nickname
    
    NSString *myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
    NSLog(@"here my nick name is , %@",myNickName);
    NSString *mycurrentpassword = [hp getAtrributeValue: USER_NAME item:@"passwordItem" attribute:@"passwordAttribute"];
    NSLog(@"here mycurrentpassword password is , %@",mycurrentpassword);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}-(void)dismissKeyboard {
    [_password resignFirstResponder];
    [_repassword resignFirstResponder];
}
- (IBAction)back_button:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (IBAction)update_button:(id)sender {
    /* NSLog(@"NickName text field%@", _me_NickName_textfield.text);
     NSLog(@"password text field%@", _password.text);
     NSLog(@"repassword text field%@", _repassword.text);
     AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
     // get the nickname on the database
     SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"nicknameItem"];
     SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
     for (SimpleDBAttribute *attr in response.attributes) {
     NSLog(@"nickname here after update is %@", attr.value);
     }
     SimpleDBReplaceableAttribute *nickNameAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"nicknameAttribute" andValue:_me_NickName_textfield.text andReplace:YES];
     NSMutableArray *NicknameAttributes = [[NSMutableArray alloc] initWithCapacity:1];
     [NicknameAttributes addObject:nickNameAttribute];
     
     SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName: USER_NAME andItemName:@"nicknameItem" andAttributes:NicknameAttributes];
     [sdb putAttributes:putAttributesRequest];
     response = [[AmazonClientManager sdb] getAttributes:gar];
     for (SimpleDBAttribute *attr in response.attributes) {
     NSLog(@"nickname here is after update %@", attr.value);
     GNickname =attr.value;
     
     
     }*/
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    NSString *udpassword1;
    NSString *udpassword2;
    NSLog(@"the text field 1  , %@",_password.text);
    NSLog(@"the text field 2  , %@",_repassword.text);

    if((_password.text == _repassword.text) && (_password.text == nil)){
        udpassword1 = [hp getAtrributeValue:USER_NAME item:@"passwordItem" attribute:@"passwordAttribute"];
        udpassword2 = udpassword1;
          NSLog(@"I am here in the if udpassword1 is  , %@",udpassword1);
    }else{
        udpassword1 = _password.text;
        udpassword2 = _repassword.text;
         NSLog(@"I am here in the else udpassword1 is  , %@",udpassword1);
    }
    if(![udpassword1 isEqualToString: udpassword2]){
        // give a alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please making sure your password and repassword are same" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
    }else{
        [hp updateAtrribute:USER_NAME item:@"passwordItem" attribute:@"passwordAttribute" newValue:udpassword1];
        NSLog(@"I am currrently update the new password is %@",udpassword1);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"update success" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
    }
    NSString *myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
    NSLog(@"after update here my nick name is , %@",myNickName);
    NSString *mycurrentpassword = [hp getAtrributeValue: USER_NAME item:@"passwordItem" attribute:@"passwordAttribute"];
    NSLog(@"after update here mycurrentpassword password is , %@",mycurrentpassword);
}
-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
