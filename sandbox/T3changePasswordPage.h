//
//  T3changePasswordPage.h
//  sandbox
//
//  Created by wuyue on 5/9/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T3changePasswordPage : UITableViewController
    - (IBAction)back_button:(id)sender;
    - (IBAction)update_button:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *repassword;

   
    -(void)dismissKeyboard;
@end

