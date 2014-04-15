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
    BOOL checked;
    
}
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;

@property (strong, nonatomic) NSString* friendPhoneNumber;
@property (strong, nonatomic) NSString* friendNickName;
@property (strong, nonatomic) NSString* onlineORoffline;
- (IBAction)backButtonPressed:(id)sender;

- (IBAction)checkBoxClicked:(id)sender;

@end
