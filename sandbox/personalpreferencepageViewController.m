//
//  personalpreferencepageViewController.m
//  sandbox
//
//  Created by wuyue on 3/28/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "personalpreferencepageViewController.h"

@interface personalpreferencepageViewController ()

@end

@implementation personalpreferencepageViewController

@synthesize inputPreferText;
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
    inputPreferText = [[UITextField alloc] initWithFrame: CGRectMake(20, 20, 200,31)];
    inputPreferText.borderStyle = UITextBorderStyleRoundedRect;
    inputPreferText.textColor = [UIColor blackColor];
    inputPreferText.placeholder = @"TYPE PLEASE";
    [inputPreferText setDelegate:self];
    [_txtText setInputAccessoryView:_toolbarIAV];
    // Set the background color of the view to a semi-transparent gray.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.66
                                                  green:0.66
                                                   blue:0.66
                                                  alpha:0.75]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPress:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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
//

@end
