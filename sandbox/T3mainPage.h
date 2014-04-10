//
//  T3preferenceMainTableViewController.h
//  sandbox
//
//  Created by wuyue on 4/4/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T3mainPage : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *Availability;
@property (weak, nonatomic) IBOutlet UITableViewCell *myPreference;
@property (weak, nonatomic) IBOutlet UILabel *labelOnAvailability;
@property (weak, nonatomic) IBOutlet UILabel *labelOnPreference;
-(float)resizeToFit;
-(float)expectedHeight;
@end
