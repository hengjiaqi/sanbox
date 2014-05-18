//
//  friendPreference.m
//  sandbox
//
//  Created by jake on 4/3/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T1friendPreference.h"
#import <QuartzCore/QuartzCore.h>
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "simpleDBHelper.h"
#import "loadingAnimation.h"
BOOL isOnline;

NSString* USER_NAME;
NSString* myNickName;
simpleDBHelper *hp;
@interface T1friendPreference (){
    dispatch_queue_t queue;
}
@end

@implementation T1friendPreference
@synthesize checkBoxButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"1221321");
    hp = [[simpleDBHelper alloc]init];
    topbar.title = self.friendNickName;
    //[invisibleSwitch setOnTintColor:[UIColor redColor]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    numberCell.userInteractionEnabled = NO;
    availablityCell.userInteractionEnabled = NO;
    preferenceCell.userInteractionEnabled = NO;
    [checkboxCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [callButton addTarget:self
                 action:@selector(callNumber:)
       forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewDidAppear:(BOOL)animated{
    [loadingAnimation showHUDAddedTo:self.view animated:YES];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    [self.view setUserInteractionEnabled:NO];
    dispatch_async(queue, ^{

        NSString* startTime = [hp getAtrributeValue:self.friendPhoneNumber item:@"availbilityItem" attribute:@"startTimeAttribute"];
        NSString* endTime = [hp getAtrributeValue:self.friendPhoneNumber item:@"availbilityItem" attribute:@"endTimeAttribute"];
        startTime = [startTime stringByAppendingString:@" - "];
        startTime = [startTime stringByAppendingString:endTime];
        self.friendAvailablity = startTime;
        self.friendPreference = [hp getAtrributeValue:self.friendPhoneNumber item:@"preferenceItem" attribute:@"preferenceAttribute"];
        self.isalwaysUnavailable = [hp hasAttributes:USER_NAME item:@"beUnavailableToListItem" attributeName:self.friendPhoneNumber];
        /*
        if (self.isalwaysUnavailable) {
            
            [hp addAtrribute:USER_NAME item:@"beUnavailableToListItem" attribute:self.friendPhoneNumber value:self.friendNickName];
            
            if([hp hasAttributes:self.friendPhoneNumber item:@"onlineFriendListItem" attributeName:USER_NAME]){
                [hp deleteAttributePair:self.friendPhoneNumber item:@"onlineFriendListItem" attributeName:USER_NAME attributeValue:myNickName];
                [hp addAtrribute:self.friendPhoneNumber item:@"offlineFriendListItem" attribute:USER_NAME value:myNickName];
            }
        }else{
            if([hp hasAttributes:USER_NAME item:@"beUnavailableToListItem" attributeName:self.friendPhoneNumber]){
                [hp deleteAttributePair:USER_NAME item:@"beUnavailableToListItem" attributeName:self.friendPhoneNumber attributeValue:self.friendNickName];
            }
            if([hp hasAttributes:self.friendPhoneNumber item:@"offlineFriendListItem" attributeName:USER_NAME]){
                [hp deleteAttributePair:self.friendPhoneNumber item:@"offlineFriendListItem" attributeName:USER_NAME attributeValue:myNickName];
                [hp addAtrribute:self.friendPhoneNumber item:@"offlineFriendListItem" attribute:USER_NAME value:myNickName];
            }
        }
        */
        dispatch_async(dispatch_get_main_queue(),^{
            //add all of them to the table view
            if ([self.onlineORoffline isEqualToString:@"online"]) {
                isOnline = YES;
            }else{
                isOnline = NO;
            }
            phoneNumberLabel.text = self.friendPhoneNumber;
            if(isOnline){
                avaliableLabel.font =[UIFont systemFontOfSize:14.0];
                avaliableLabel.text = self.friendAvailablity;
                NSMutableString *label = [[NSMutableString alloc]initWithFormat:@"%@",self.friendPreference];
                preferenceLabel.text = label;
            }else{
                avaliableLabel.text = @"This person is currently unavailable";
                preferenceLabel.text = @"This person is currently unavailable";
            }
            if (!isOnline) {
                phoneNumberLabel.textColor = [UIColor grayColor];
                avaliableLabel.textColor = [UIColor grayColor];
                preferenceLabel.textColor = [UIColor grayColor];
            }
            if (self.isalwaysUnavailable) {
                [checkBoxButton setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
                checked = YES;
            }else{
                [checkBoxButton setImage:[UIImage imageNamed:@"checkbox_normal.png"] forState:UIControlStateNormal];
                checked = NO;
            }


            [self performSelector:@selector(stopRKLoading) withObject:nil];
        });
        
    });
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return 2;
    }else{
        return 1;
    }
}






- (IBAction)switchChanged:(id)sender {
    //beUnavailable to this person
    NSLog(@"%@", myNickName);
    /*
    if (invisibleSwitch.isOn) {
        NSLog(@"it's on!");
     
        
    }else{
     
    }*/
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)callNumber:(id)sender {
    NSLog(@"CLICKED");
    
    NSString *phNo = [[NSString alloc] initWithFormat:@"+1%@", phoneNumberLabel.text];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]init];
        calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
    
}

- (IBAction)textNumber:(id)sender {
    NSString *number = [[NSString alloc]initWithFormat:@"sms:+1%@", phoneNumberLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];

}

- (IBAction)checkBoxClicked:(id)sender {
    simpleDBHelper *hp = [[simpleDBHelper alloc] init];
    if (!checked) {
        [checkBoxButton setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
        checked = YES;
        
        
        [loadingAnimation showHUDAddedTo:self.view animated:YES];
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [hp addAtrribute:USER_NAME item:@"beUnavailableToListItem" attribute:self.friendPhoneNumber value:self.friendNickName];
            
            if([hp hasAttributes:self.friendPhoneNumber item:@"onlineFriendListItem" attributeName:USER_NAME]){
                [hp deleteAttributePair:self.friendPhoneNumber item:@"onlineFriendListItem" attributeName:USER_NAME attributeValue:myNickName];
                [hp addAtrribute:self.friendPhoneNumber item:@"offlineFriendListItem" attribute:USER_NAME value:myNickName];
            }
            dispatch_async(dispatch_get_main_queue(),^{
                //Call the method to hide the Indicator after 3 seconds
                [self performSelector:@selector(stopRKLoading) withObject:nil];
            });
        });
        
        
    }
    
    else if (checked) {
        [checkBoxButton setImage:[UIImage imageNamed:@"checkbox_normal.png"] forState:UIControlStateNormal];
        checked = NO;
        
        [loadingAnimation showHUDAddedTo:self.view animated:YES];
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            if([hp hasAttributes:USER_NAME item:@"beUnavailableToListItem" attributeName:self.friendPhoneNumber]){
                [hp deleteAttributePair:USER_NAME item:@"beUnavailableToListItem" attributeName:self.friendPhoneNumber attributeValue:self.friendNickName];
            }
            if([hp hasAttributes:self.friendPhoneNumber item:@"offlineFriendListItem" attributeName:USER_NAME]){
                [hp deleteAttributePair:self.friendPhoneNumber item:@"offlineFriendListItem" attributeName:USER_NAME attributeValue:myNickName];
                [hp addAtrribute:self.friendPhoneNumber item:@"onlineFriendListItem" attribute:USER_NAME value:myNickName];
            }
            dispatch_async(dispatch_get_main_queue(),^{
                //Call the method to hide the Indicator after 3 seconds
                [self performSelector:@selector(stopRKLoading) withObject:nil];
            });
        });
    }
}

-(void)stopRKLoading
{
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    [self.view setUserInteractionEnabled:YES];
    [loadingAnimation hideHUDForView:self.view animated:YES];
}

- (void) handleRefresh:(id)paramSender{
    
    /* Put a bit of delay between when the refresh control is released
     and when we actually do the refreshing to make the UI look a bit
     smoother than just doing the update without the animation */
    int64_t delayInSeconds = 1.0f;
    dispatch_time_t popTime =
    dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
    });
    
}

@end
