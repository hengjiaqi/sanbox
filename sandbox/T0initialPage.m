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
    NSLog(@"3232");
    NSString *userPhoneNumber = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    NSLog(@"%@", userPhoneNumber);
    NSString *passwordFromDB = @"";
    if (userPhoneNumber != nil) {
        if ([hp hasDomain:userPhoneNumber]) {
            passwordFromDB = [hp getAtrributeValue:userPhoneNumber item:@"passwordItem" attribute:@"passwordAttribute"];
        }
    }
    if (![defaults boolForKey:@"logged_in"] || ![passwordFromDB isEqualToString:userPassword] || userPhoneNumber == nil) {
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
