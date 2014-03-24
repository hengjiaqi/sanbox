//
//  logInPage.h
//  sandbox
//
//  Created by jake on 3/16/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface logInPage : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *phoneNumber;
    IBOutlet UITextField *password;
}
- (IBAction)testMessage:(id)sender;
- (IBAction)LoginButton:(id)sender;

-(void)dismissKeyboard;
-(BOOL)textFieldShouldReturn:(UITextField*) textField;
@end
