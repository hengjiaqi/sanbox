//
//  confirmPage.h
//  sandbox
//
//  Created by jake on 3/17/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Security;

@interface T0confirmPage : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *confirmCode;
}
@property (strong, nonatomic) NSString* confirmationCode;
@property (strong, nonatomic) NSString* registerPhoneNumber;
@property (strong, nonatomic) NSString* registerNickName;
@property (strong, nonatomic) NSString* registerPassword;
- (IBAction)confirmButton:(id)sender;

-(void)dismissKeyboard;
-(BOOL)textFieldShouldReturn:(UITextField*) textField;
@end
