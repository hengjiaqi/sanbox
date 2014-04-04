//
//  newUser.h
//  sandbox
//
//  Created by jake on 3/17/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T0newUser : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *newUserNickName;
    IBOutlet UITextField *newUserPasswordAgain;
    IBOutlet UITextField *newUserPassword;
    IBOutlet UITextField *newUserPhoneNumber;
}


-(void)dismissKeyboard;
-(BOOL)textFieldShouldReturn:(UITextField*) textField;

@end
