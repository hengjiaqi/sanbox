//
//  mepageTableViewController.h
//  sandbox
//
//  Created by wuyue on 3/28/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T3mepageTableViewController : UITableViewController
- (IBAction)me_back_button:(id)sender;
- (IBAction)me_update_button:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *me_NickName_textfield;
@property (weak, nonatomic) IBOutlet UITextField *me_Password_textfield;
@property (weak, nonatomic) IBOutlet UITextField *me_rePassword_textfield;
-(void)dismissKeyboard;

@end
