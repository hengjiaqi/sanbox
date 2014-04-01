//
//  searchFriendPage.h
//  sandbox
//
//  Created by jake on 4/1/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchFriendPage : UITableViewController{
    
}
@property (strong, nonatomic) NSString* friendPhoneNumber;
@property (strong, nonatomic) NSString* friendNickName;
- (IBAction)backButtonPressed:(id)sender;
@end
