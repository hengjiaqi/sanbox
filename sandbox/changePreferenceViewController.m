//
//  changePreferenceViewController.m
//  sandbox
//
//  Created by wuyue on 4/2/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "changePreferenceViewController.h"


@interface changePreferenceViewController ()

@end

@implementation changePreferenceViewController
@synthesize charleft;

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
    CGRect textViewFrame = CGRectMake(20.0f, 80.0f, 280.0f, 150.0f);
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    textView.returnKeyType = UIReturnKeyDone;
    UIColor *color = [UIColor colorWithRed:242/255.0f green:243/255.0f blue:238/255.0f alpha:1.0f];
    textView.font=[UIFont fontWithName:@"Arial" size:20];
    textView.backgroundColor = color;
    textView.delegate=self;
    [self.view addSubview:textView];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 160){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)me_back_button:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)textViewDidChange:(UITextView *)textView
{
    int len = textView.text.length;
    charleft.text=[NSString stringWithFormat:@"%i",160-len];
}




@end
