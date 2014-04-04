//
//  searchFriendPage.h
//  sandbox
//
//  Created by jake on 4/1/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T2searchFriendPage : UITableViewController<UIAlertViewDelegate>{
    
}
@property (strong, nonatomic) NSString* friendPhoneNumber;
@property (strong, nonatomic) NSString* friendNickName;
@property(nonatomic,strong) NSMutableArray* FriendListelements;

- (IBAction)backButtonPressed:(id)sender;
@end
