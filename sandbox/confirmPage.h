//
//  confirmPage.h
//  sandbox
//
//  Created by jake on 3/17/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface confirmPage : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *confirmCode;
}
@property (strong, nonatomic) NSString* confirmationCode;
- (IBAction)confirmButton:(id)sender;

-(void)dismissKeyboard;
-(BOOL)textFieldShouldReturn:(UITextField*) textField;
@end
