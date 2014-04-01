//
//  addFriendPage.h
//  sandbox
//
//  Created by jake on 3/31/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addFriendPage : UIViewController<UITextFieldDelegate>{

   
    IBOutlet UITextField *numberToSearch;

    
}

- (IBAction)searchNumber:(id)sender;

- (IBAction)backButtonPressed:(id)sender;
-(void)dismissKeyboard;
-(BOOL)textFieldShouldReturn:(UITextField*) textField;

@end
