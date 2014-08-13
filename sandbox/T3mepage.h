//
//  mepageTableViewController.h
//  sandbox
//
//  Created by wuyue on 3/28/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSS3/AWSS3.h>
typedef enum {
    GrandCentralDispatch,
    Delegate,
    BackgroundThread
} UploadType;

@interface T3mepage : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate,AmazonServiceRequestDelegate>{
   
    IBOutlet UIImageView *imageView;
    
    
}
- (IBAction)me_back_button:(id)sender;
- (IBAction)me_update_button:(id)sender;
- (IBAction)logOutButton:(id)sender;

@property (nonatomic, retain) AmazonS3Client *s3;
@property (nonatomic, weak) IBOutlet UITableViewCell *theStaticCell;
@property (weak, nonatomic) IBOutlet UILabel *NickNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *me_NickName_textfield;
@property (weak, nonatomic) IBOutlet UITextField *me_Password_textfield;
@property (weak, nonatomic) IBOutlet UITextField *me_rePassword_textfield;
@property (weak, nonatomic) IBOutlet UIImagePickerController *imagePicker;
-(void)dismissKeyboard;

@end
