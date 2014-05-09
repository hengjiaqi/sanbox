//
//  T3changePasswordPage.h
//  sandbox
//
//  Created by wuyue on 5/9/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T3changeNickNameTableViewController : UITableViewController
- (IBAction)back_button:(id)sender;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nickName_textfield;
-(void)dismissKeyboard;
@end

