//
//  T0initialPage.m
//  sandbox
//
//  Created by jake on 5/8/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T0initialPage.h"
#import "simpleDBHelper.h"

@interface T0initialPage ()

@end

@implementation T0initialPage



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userPassword = [defaults objectForKey:@"EAT2GETHER_PASSWORD"];
    NSString *userPhoneNumber = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    NSString *passwordFromDB = [hp getAtrributeValue:userPhoneNumber item:@"passwordItem" attribute:@"passwordAttribute"];
    if (userPassword.length == 0 || ![passwordFromDB isEqualToString:userPassword]) {
        [self performSegueWithIdentifier:@"startFromLoginPage" sender:self];
    }else{
        [self performSegueWithIdentifier:@"startFromMainPage" sender:self];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
