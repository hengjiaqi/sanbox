//
//  T3changePasswordPage.m
//  sandbox
//
//  Created by wuyue on 5/9/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T3changeNickNameTableViewController.h"

#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "simpleDBhelper.h"
//#import "FriendListTableViewController.m"
NSString *USER_NAME;
NSString *GNickname;


@interface T3changeNickNameTableViewController ()
@property dispatch_queue_t queue;
@end

@implementation T3changeNickNameTableViewController

@synthesize nickName_textfield =_nickName_textfield;

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
   // [loadingAnimation showHUDAddedTo:self.view animated:YES];
    
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //get the user name
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    
    // get nickname
    
    NSString *myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
    NSLog(@"here my nick name is , %@",myNickName);
    NSString *mycurrentpassword = [hp getAtrributeValue: USER_NAME item:@"passwordItem" attribute:@"passwordAttribute"];
    NSLog(@"here mycurrentpassword password is , %@",mycurrentpassword);
    _nickName_textfield.text = myNickName;
    
    
    // delete one attribute //
    
//    [hp deleteAttributePair:USER_NAME item:@"nicknameItem" attributeName:@"nicknameAttribute" attributeValue:@"mason4"];
    
    
    NSLog(@"my user name is %@", USER_NAME);
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
- (IBAction)back_button:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (IBAction)save:(id)sender {
 //   [loadingAnimation showHUDAddedTo:self.view animated:YES];
    
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
    [loadingAnimation showHUDAddedTo:self.view animated:YES];
    
    [self saveChanges];
    
}
-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}


-(void)saveChanges
{
    [self dismissKeyboard];
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(_queue, ^{
        simpleDBHelper *hp = [[simpleDBHelper alloc]init];
        
        NSString *currentnickName;
        currentnickName = _nickName_textfield.text;
        NSLog(@"my currentnickName  , %@",currentnickName);
        
        NSString *myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
        
        [hp updateAtrribute:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute" newValue:currentnickName];
        while(![myNickName isEqualToString:currentnickName]){
            myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
            [hp updateAtrribute:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute" newValue:currentnickName];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"update success" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [self performSelector:@selector(stopRKLoading) withObject:nil];
            [alert show];
            
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
        });
    });

}
-(void)stopRKLoading
{
    [loadingAnimation hideHUDForView:self.view animated:YES];
}
-(void)dismissKeyboard {
    [self.nickName_textfield resignFirstResponder];
}


@end
