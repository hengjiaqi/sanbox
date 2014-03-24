//
//  newUser.m
//  sandbox
//
//  Created by jake on 3/17/14.
//  Copyright (c) 2014 jake. All rights reserved.
//test

#import "newUser.h"

@interface newUser ()

@end

@implementation newUser

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification object:nil];
    
    [self.view addGestureRecognizer:tap];
    newUserPassword.secureTextEntry = YES;
    newUserPasswordAgain.secureTextEntry = YES;
    newUserPassword.delegate = self;
    newUserPasswordAgain.delegate = self;
    newUserPhoneNumber.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)confirmButton:(id)sender {
    int code = [self checkRegisterInfo];
    UIAlertView *alert;
    if (code == 0) {
        [self performSegueWithIdentifier:@"goToConfirmPage" sender:sender];
    }else if(code == 1){
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid Phone Number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if(code == 2){
       alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your password is not consistant" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if(code == 3){
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if(code == 4){
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your password again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
}

-(int) checkRegisterInfo{
    if ([newUserPhoneNumber.text isEqualToString:@""]) {
        return 1;
    }else if (![newUserPassword.text isEqualToString:newUserPasswordAgain.text ]) {
        return 2;
    }else if ([newUserPassword.text isEqualToString:@""]) {
        return 3;
    }else if ([newUserPasswordAgain.text isEqualToString:@""]) {
        return 4;
    }else{
        return 0;
    }
}
-(void)dismissKeyboard {
    [newUserPassword resignFirstResponder];
    [newUserPhoneNumber resignFirstResponder];
    [newUserPasswordAgain resignFirstResponder];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)keyboardDidShow:(NSNotification *)notification{
    if ([[UIScreen mainScreen]bounds].size.height==568) {
        [self.view setFrame:CGRectMake(0, -50, 320, 568)];
    }else{
        [self.view setFrame:CGRectMake(0, -130, 320, 480)];
    }
}


-(void)keyboardDidHide:(NSNotification *)notification{
    if ([[UIScreen mainScreen]bounds].size.height==568) {
        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        [self.view setFrame:CGRectMake(0, 0, 320, 480)];
    }
}

@end
