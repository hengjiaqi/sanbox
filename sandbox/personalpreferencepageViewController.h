//
//  personalpreferencepageViewController.h
//  sandbox
//
//  Created by wuyue on 3/28/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personalpreferencepageViewController : UIViewController  <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *inputPreferText;
- (IBAction)backButtonPress:(id)sender;

@end
