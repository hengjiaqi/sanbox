//
//  mepageTableViewController.m
//  sandbox
//
//  Created by wuyue on 3/28/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T3mepage.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "simpleDBhelper.h"
//#import "FriendListTableViewController.m"
NSString *USER_NAME;
NSString *GNickname;
@interface T3mepage ()

@end

@implementation T3mepage
@synthesize me_NickName_textfield = _me_NickName_textfield;
@synthesize me_Password_textfield = _me_Password_textfield;
@synthesize me_rePassword_textfield = _me_rePassword_textfield;
@synthesize NickNameLabel = _NickNameLabel;
//@property (nonatomic, weak) IBOutlet UITableViewCell *theStaticCell;
NSString *imagecellID = @"imagecellID";
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
//


- (void)viewDidLoad
{
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    [super viewDidLoad];
    /*
  //  AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
=======
    //AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
>>>>>>> FETCH_HEAD
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
     [self.view addGestureRecognizer:tap];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"nicknameItem"];
    SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
    for (SimpleDBAttribute *attr in response.attributes) {
        NSLog(@"nickname here is %@", attr.value);
        _me_NickName_textfield.text = attr.value;
    }
    */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //get the user name
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    
    // get nickname
    
    NSString *myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
    NSLog(@"here my nick name is , %@",myNickName);
    NSString *mycurrentpassword = [hp getAtrributeValue: USER_NAME item:@"passwordItem" attribute:@"passwordAttribute"];
    NSLog(@"here mycurrentpassword password is , %@",mycurrentpassword);
    _me_NickName_textfield.text = myNickName;
    _NickNameLabel.text = myNickName;
    sc.selectedSegmentIndex = -1;
    
    //me_NickName_textfield.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)dismissKeyboard {
    [_me_NickName_textfield resignFirstResponder];
    [_me_Password_textfield resignFirstResponder];
    [_me_rePassword_textfield resignFirstResponder];
}
- (IBAction)me_back_button:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];

}

- (IBAction)me_update_button:(id)sender {
    /* NSLog(@"NickName text field%@", _me_NickName_textfield.text);
     NSLog(@"password text field%@", _me_Password_textfield.text);
     NSLog(@"repassword text field%@", _me_rePassword_textfield.text);
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
    NSString *udnickname = _me_NickName_textfield.text;
    NSString *udpassword1;
    NSString *udpassword2;
    if((_me_NickName_textfield.text == _me_rePassword_textfield.text) && (_me_NickName_textfield.text == NULL)){
         udpassword1 = [hp getAtrributeValue:USER_NAME item:@"passwordItem" attribute:@"passwordAttribute"];
         udpassword2 = udpassword1;
    }else{
        udpassword1 = _me_Password_textfield.text;
        udpassword2 = _me_rePassword_textfield.text;
    }
    if(![udpassword1 isEqualToString: udpassword2]){
        // give a alert
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please making sure your password and repassword are same" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
          [alert show];
    }else{
        [hp updateAtrribute:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute" newValue:udnickname];
        [hp updateAtrribute:USER_NAME item:@"passwordItem" attribute:@"passwordAttribute" newValue:udpassword1];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"update success" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
    }
    NSString *myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
    NSLog(@"after update here my nick name is , %@",myNickName);
    NSString *mycurrentpassword = [hp getAtrributeValue: USER_NAME item:@"passwordItem" attribute:@"passwordAttribute"];
    NSLog(@"after update here mycurrentpassword password is , %@",mycurrentpassword);
}

- (IBAction)logOutButton:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"This will log you out from this account" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Log out",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
}
- (IBAction)camera {
    picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    if(sc.selectedSegmentIndex == 0){
        [picker2 setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else if(sc.selectedSegmentIndex == 1){
        [picker2 setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
    }
    [self presentViewController:picker2 animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        // case 1 is logout
        case 1: {
            switch (buttonIndex) {
                case 0:
                    NSLog(@"detect the logout signal ");
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logged_in"];
                    [self performSegueWithIdentifier:@"logOut" sender:self];
                    break;
                default:
                    break;
            }
            break;
        }
        // case 2 is photo
        case 2:{
            switch (buttonIndex){
                case 0:
                    NSLog(@"take a photo");
                    [picker2 setSourceType:UIImagePickerControllerSourceTypeCamera];
                    break;
                case 1:
                     NSLog(@"choose from photo");
                    [picker2 setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
                    [self presentViewController:picker2 animated:YES completion:nil];
                    break;
            }
        }
        default:
            break;
    }
}
-(void) viewDidAppear:(BOOL)animated{
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //get the user name
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    
    // get nickname
    
    NSString *myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
    NSLog(@"here my nick name is , %@",myNickName);
    NSString *mycurrentpassword = [hp getAtrributeValue: USER_NAME item:@"passwordItem" attribute:@"passwordAttribute"];
    NSLog(@"here mycurrentpassword password is , %@",mycurrentpassword);
    _me_NickName_textfield.text = myNickName;
    _NickNameLabel.text = myNickName;
    
}

-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSString *cellText = cell.textLabel.text;
    
    if(cell==_theStaticCell){
        NSLog(@"fuck me fuck me");
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Change your Profile" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Take Photo",@"Choose Photo",
                                nil];
        picker2 = [[UIImagePickerController alloc] init];
        picker2.delegate = self;
        popup.tag = 2;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
   
    }
}


@end
