//
//  logInPage.h
//  sandbox
//
//  Created by jake on 3/16/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loadingAnimation.h"
#import <QuartzCore/QuartzCore.h>

@interface T0logInPage : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *phoneNumber;
    IBOutlet UITextField *password;
}
- (IBAction)LoginButton:(id)sender;

-(void)dismissKeyboard;
-(BOOL)textFieldShouldReturn:(UITextField*) textField;
@end
