//
//  friendPreference.h
//  sandbox
//
//  Created by jake on 4/3/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface friendPreference : UITableViewController{
    
    IBOutlet UISwitch *invisibleSwitch;

}
- (IBAction)switchChanged:(id)sender;
- (IBAction)backButtonPressed:(id)sender;


@end
