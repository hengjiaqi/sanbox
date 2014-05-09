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
//#import "FriendListTableViewController.m"
NSString *USER_NAME;
NSString *GNickname;
@interface T3mepage ()

@end

@implementation T3mepage
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
    //AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
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
     NSLog(@"NickName text field%@", _me_NickName_textfield.text);
     NSLog(@"password text field%@", _me_Password_textfield.text);
     NSLog(@"repassword text field%@", _me_rePassword_textfield.text);
    AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
    // get the nickname on the database
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"nicknameItem"];
    SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
    for (SimpleDBAttribute *attr in response.attributes) {
          NSLog(@"nickname here is %@", attr.value);
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
    }
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
    [self presentModalViewController:picker2 animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
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
        default:
            break;
    }
}


@end
