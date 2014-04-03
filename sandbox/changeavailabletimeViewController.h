//
//  changeAvailableTimeViewController.h
//  sandbox
//
//  Created by wuyue on 3/30/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changeAvailableTimeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *starttimelabel;
@property (weak, nonatomic) IBOutlet UILabel *endtimelabel;
- (IBAction)setstarttimebutton:(id)sender;
- (IBAction)setendtimebutton:(id)sender;
- (IBAction)updatebutton:(id)sender;
- (IBAction)backButtonPress:(id)sender;

@end
