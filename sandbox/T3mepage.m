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
#import "Constants.h"
#import <AWSRuntime/AWSRuntime.h>
//#import "FriendListTableViewController.m"
NSString *USER_NAME;
NSString *GNickname;
@interface T3mepage ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,
UITextFieldDelegate>
@end

@implementation T3mepage
@synthesize me_NickName_textfield = _me_NickName_textfield;
@synthesize me_Password_textfield = _me_Password_textfield;
@synthesize me_rePassword_textfield = _me_rePassword_textfield;
@synthesize NickNameLabel = _NickNameLabel;
@synthesize s3 = _s3;

//@property (nonatomic, weak) IBOutlet UITableViewCell *theStaticCell;
NSString *imagecellID = @"imagecellID";
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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
    _me_NickName_textfield.text = myNickName;
    _NickNameLabel.text = myNickName;
    sc.selectedSegmentIndex = -1;
    
    self.s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];
    
    //me_NickName_textfield.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //S3CreateBucketRequest *createBucketRequest = [[S3CreateBucketRequest alloc] initWithName:[Constants pictureBucket]  andRegion:[S3Region USWest2]];
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
    
    // put this image to database
    [imageView setImage:image];
    
    // Convert the image to JPEG data.
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    
    [self processGrandCentralDispatchUpload:imageData];
    
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
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        picker.allowsEditing = YES;
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        
                        [self presentViewController:picker animated:YES completion:NULL];
                    }
                    //[picker2 setSourceType:(UIImagePickerControllerSourceTypeCamera)];
                    break;
                case 1:
                    NSLog(@"choose from photo");
                    [picker2 setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
          //          [self presentModalViewController:picker2 animated:YES];
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
    
    
    // load the image on the s3
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        // Set the content type so that the browser will treat the URL as an image.
        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
        override.contentType = @"image/jpeg";
        
        // Request a pre-signed URL to picture that has been uplaoded.
        S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
        gpsur.key                     = USER_NAME;
        gpsur.bucket                  = [Constants pictureBucket];
        gpsur.expires                 = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600]; // Added an hour's worth of seconds to the current time.
        gpsur.responseHeaderOverrides = override;
        
        
        
        
        // Get the URL
        NSError *error = nil;
        NSURL *url = [self.s3 getPreSignedURL:gpsur error:&error];
        
        NSString *simpleDBURL = [url absoluteString];
        // try to put the url to simpledb
        simpleDBHelper *hp = [[simpleDBHelper alloc]init];
        [hp updateAtrribute:USER_NAME item:@"photoProfileItem" attribute:@"photoAttribute" newValue:simpleDBURL];
        
        
        NSData *data = [NSData dataWithContentsOfURL: url];
        UIImage *image = [UIImage imageWithData:data];
        if(url == nil)
        {
            if(error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"Error: %@", error);
                    
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [imageView setImage:image];
                
            });
        }
        
    });
}

-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // NSString *cellText = cell.textLabel.text;
    
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
- (void)processGrandCentralDispatchUpload:(NSData *)imageData
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        // Upload image data.  Remember to set the content type.
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:USER_NAME
                                                                 inBucket:[Constants pictureBucket]];
        por.contentType = @"image/jpeg";
        por.data        = imageData;
        // Put the image data into the specified s3 bucket and object.
        S3PutObjectResponse *putObjectResponse = [self.s3 putObject:por];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(putObjectResponse.error != nil)
            {
                NSLog(@"Error: %@", putObjectResponse.error);
                [self showAlertMessage:[putObjectResponse.error.userInfo objectForKey:@"message"] withTitle:@"Upload Error"];
            }
            else
            {
                [self showAlertMessage:@"The image was successfully uploaded." withTitle:@"Upload Completed"];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
}
- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


@end
