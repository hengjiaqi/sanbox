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
    
    IBOutlet UILabel *preferenceLabel;
    IBOutlet UILabel *avaliableLabel;
    IBOutlet UINavigationItem *topbar;
    BOOL checked;
    
    IBOutlet UITableViewCell *numberCell;
    
    IBOutlet UITableViewCell *availablityCell;
    
    IBOutlet UITableViewCell *preferenceCell;
    IBOutlet UITableViewCell *contactCell;
    IBOutlet UIButton *callButton;
    IBOutlet UITableViewCell *checkboxCell;
}
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;

@property (strong, nonatomic) NSString* friendPhoneNumber;
@property (strong, nonatomic) NSString* friendNickName;
@property (strong, nonatomic) NSString* friendAvailablity;
@property (strong, nonatomic) NSString* friendPreference;
@property (strong, nonatomic) NSString* onlineORoffline;
@property (nonatomic) BOOL isalwaysUnavailable;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)callNumber:(id)sender;

- (IBAction)textNumber:(id)sender;

- (IBAction)checkBoxClicked:(id)sender;

@end
