//
//  newUser.h
//  sandbox
//
//  Created by jake on 3/17/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newUser : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *newUserPasswordAgain;
    IBOutlet UITextField *newUserPassword;
    IBOutlet UITextField *newUserPhoneNumber;
}
- (IBAction)confirmButton:(id)sender;

-(void)dismissKeyboard;
-(BOOL)textFieldShouldReturn:(UITextField*) textField;

@end
