//
//  friendPreference.h
//  sandbox
//
//  Created by jake on 4/3/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T1friendPreference : UITableViewController{
    
    IBOutlet UILabel *phoneNumberLabel;
    
    IBOutlet UITableViewCell *preferenceLabel;
    IBOutlet UILabel *avaliableLabel;
    IBOutlet UINavigationItem *topbar;
    IBOutlet UISwitch *invisibleSwitch;

}
@property (strong, nonatomic) NSString* friendPhoneNumber;
@property (strong, nonatomic) NSString* friendNickName;
@property (strong, nonatomic) NSString* onlineORoffline;
- (IBAction)switchChanged:(id)sender;
- (IBAction)backButtonPressed:(id)sender;


@end
