//
//  changeAvailableTimeViewController.m
//  sandbox
//
//  Created by wuyue on 3/30/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "changeAvailableTimeViewController.h"

@interface changeAvailableTimeViewController ()

@end

@implementation changeAvailableTimeViewController

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
    NSDate *pickertime = [NSDate date];
    [_datePicker setDate:pickertime animated:YES];
//    NSString selectStarttime = [setstarttimebutton.message];
    _starttimelabel.text = @"ni hao";
   // _endtimelabel.text = [setendtimebutton message]];
    
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

- (IBAction)setstarttimebutton:(id)sender {
    
    NSDate *select = [_datePicker date];
    NSString *message = [[NSString alloc] initWithFormat:@"%@",select];
    
    NSLog(@"%@",[message substringWithRange:NSMakeRange(10, 6)]);
    _starttimelabel.text = [message substringWithRange:NSMakeRange(10, 6)];
}

- (IBAction)setendtimebutton:(id)sender {
    NSDate *select = [_datePicker date];
    NSString *message = [[NSString alloc] initWithFormat:@"%@",select];
    NSLog(@"%@",[message substringWithRange:NSMakeRange(10, 6)]);
    _endtimelabel.text = [message substringWithRange:NSMakeRange(10, 6)];

  //  _endtimelabel.text = message;
}

- (IBAction)updatebutton:(id)sender {
    
}
@end
