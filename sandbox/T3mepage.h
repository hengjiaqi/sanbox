//
//  mepageTableViewController.h
//  sandbox
//
//  Created by wuyue on 3/28/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T3mepage : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    IBOutlet UISegmentedControl *sc;
    IBOutlet UIImageView *imageView;
    UIImagePickerController *picker2;
}
- (IBAction)me_back_button:(id)sender;
- (IBAction)me_update_button:(id)sender;
- (IBAction)logOutButton:(id)sender;
- (IBAction)camera;
@property (weak, nonatomic) IBOutlet UITextField *me_NickName_textfield;
@property (weak, nonatomic) IBOutlet UITextField *me_Password_textfield;
@property (weak, nonatomic) IBOutlet UITextField *me_rePassword_textfield;
-(void)dismissKeyboard;

@end
