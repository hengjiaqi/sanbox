//
//  confirmPage.m
//  sandbox
//
//  Created by jake on 3/17/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T0confirmPage.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "loadingAnimation.h"
@interface T0confirmPage (){
    dispatch_queue_t queue;
}

@end

@implementation T0confirmPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification object:nil];
    [self.view addGestureRecognizer:tap];
    confirmCode.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)confirmButton:(id)sender {
    NSLog(@"code got sent is %@", self.confirmationCode);
    NSLog(@"code got entered is %@", confirmCode.text);
    if ( [self.confirmationCode isEqualToString:confirmCode.text]) {
        [confirmCode resignFirstResponder];
        [loadingAnimation showHUDAddedTo:self.view animated:YES];
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [self setupDatabase];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.registerPhoneNumber forKey:@"EAT2GETHER_ACCOUNT_NAME"];
            [defaults setObject:self.registerPassword forKey:@"EAT2GETHER_PASSWORD"];
            [defaults synchronize];
            dispatch_async(dispatch_get_main_queue(),^{
                [self performSegueWithIdentifier:@"logInAfterRegister" sender:sender];
                //Call the method to hide the Indicator after 3 seconds
                [self performSelector:@selector(stopRKLoading) withObject:nil];
            });
        });
    }else{
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"The confirmation code is incorret. Please check again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)setupDatabase{
    //create domain
    AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
    SimpleDBCreateDomainRequest *request = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:self.registerPhoneNumber];
    [sdb createDomain:request];
    
    //password item
    SimpleDBReplaceableAttribute *passwordAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"passwordAttribute" andValue:self.registerPassword andReplace:YES];
    SimpleDBReplaceableAttribute *passwordAttribute1 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"dummyAttribute" andValue:@"dummyAttribute" andReplace:YES];
    NSMutableArray *attributes = [[NSMutableArray alloc] initWithCapacity:2];
    [attributes addObject:passwordAttribute];
    [attributes addObject:passwordAttribute1];
    SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"passwordItem" andAttributes:attributes];
    [sdb putAttributes:putAttributesRequest];
    
    //nickname item
    SimpleDBReplaceableAttribute *nickNameAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"nicknameAttribute" andValue:self.registerNickName andReplace:YES];
    NSMutableArray *NicknameAttributes = [[NSMutableArray alloc] initWithCapacity:2];
    [NicknameAttributes addObject:nickNameAttribute];
    [NicknameAttributes addObject:passwordAttribute1];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"nicknameItem" andAttributes:NicknameAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //onlineItem
    SimpleDBReplaceableAttribute *onlineAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"onlineAttribute" andValue:@"offline" andReplace:YES];
    NSMutableArray *onlineAttributes = [[NSMutableArray alloc] initWithCapacity:2];
    [onlineAttributes addObject:onlineAttribute];
    [onlineAttributes addObject:passwordAttribute1];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"onlineItem" andAttributes:onlineAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //preferenceItem
    SimpleDBReplaceableAttribute *preferenceAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"preferenceAttribute" andValue:@"I have no preference" andReplace:YES];
    NSMutableArray *preferenceAttributes = [[NSMutableArray alloc] initWithCapacity:2];
    [preferenceAttributes addObject:passwordAttribute1];
    [preferenceAttributes addObject:preferenceAttribute];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"preferenceItem" andAttributes:preferenceAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //friendList item
    NSMutableArray *friendListAttributes = [[NSMutableArray alloc] initWithCapacity:2];
    SimpleDBReplaceableAttribute *friendListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000000" andValue:@"dummyUser" andReplace:YES];
    //SimpleDBReplaceableAttribute *friendListAttribute2 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000001" andValue:@"secondUser" andReplace:YES];
    //SimpleDBReplaceableAttribute *friendListAttribute3 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000002" andValue:@"thirdUser" andReplace:YES];
    [friendListAttributes addObject:friendListAttribute];
    //[friendListAttributes addObject:friendListAttribute2];
    //[friendListAttributes addObject:friendListAttribute3];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"friendListItem" andAttributes:friendListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //friendRequestList item
    NSMutableArray *friendRequestListAttributes = [[NSMutableArray alloc] initWithCapacity:1];
    SimpleDBReplaceableAttribute *friendRequestListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000000" andValue:@"dummyUser" andReplace:YES];
    [friendRequestListAttributes addObject:friendRequestListAttribute];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"friendRequestListItem" andAttributes:friendRequestListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //Availibility item
    NSMutableArray *availibility= [[NSMutableArray alloc] initWithCapacity:2];
    SimpleDBReplaceableAttribute *startTimeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"startTimeAttribute" andValue:@"00:00AM" andReplace:YES];
    SimpleDBReplaceableAttribute *endTimeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"endTimeAttribute" andValue:@"00:00AM" andReplace:YES];
    [availibility addObject:startTimeAttribute];
    [availibility addObject:endTimeAttribute];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"availbilityItem" andAttributes:availibility];
    [sdb putAttributes:putAttributesRequest];
    
    //beVisiableTo item
    /*
     NSMutableArray *beVisibleToListAttributes = [[NSMutableArray alloc] initWithCapacity:1];
     SimpleDBReplaceableAttribute *beVisibleToListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000000" andValue:@"dummyUser" andReplace:YES];
     //SimpleDBReplaceableAttribute *beVisibleToListAttribute2 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000002" andValue:@"thirdUser" andReplace:YES];
     [beVisibleToListAttributes addObject:beVisibleToListAttribute];
     //[beVisibleToListAttributes addObject:beVisibleToListAttribute2];
     
     putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"beVisiableToItem" andAttributes:beVisibleToListAttributes];
     [sdb putAttributes:putAttributesRequest];
     */
    
    
    //beUnavailableTo item
    NSMutableArray *beUnavailableToListAttributes = [[NSMutableArray alloc] initWithCapacity:1];
    SimpleDBReplaceableAttribute *beUnavailableToListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000000" andValue:@"dummyUser" andReplace:YES];
    [beUnavailableToListAttributes addObject:beUnavailableToListAttribute];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"beUnavailableToListItem" andAttributes:beUnavailableToListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //onlineFriendList item
    NSMutableArray *onlineFriendListAttributes = [[NSMutableArray alloc] initWithCapacity:2];
    SimpleDBReplaceableAttribute *onlineFriendListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000000" andValue:@"dummyUser" andReplace:YES];
    //SimpleDBReplaceableAttribute *onlineFriendListAttribute2 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000002" andValue:@"thirdUser" andReplace:YES];
    [onlineFriendListAttributes addObject:onlineFriendListAttribute];
    //[onlineFriendListAttributes addObject:onlineFriendListAttribute2];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"onlineFriendListItem" andAttributes:onlineFriendListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //offlineFriendList item
    NSMutableArray *offlineFriendListAttributes = [[NSMutableArray alloc] initWithCapacity:1];
    SimpleDBReplaceableAttribute *offlineFriendListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000000" andValue:@"dummyUser" andReplace:YES];
    [offlineFriendListAttributes addObject:offlineFriendListAttribute];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"offlineFriendListItem" andAttributes:offlineFriendListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    // photoProfileItem
    NSMutableArray *attributes1 = [[NSMutableArray alloc] initWithCapacity:2];
    SimpleDBReplaceableAttribute *photoAttribute = [[SimpleDBReplaceableAttribute alloc]  initWithName:@"photoAttribute" andValue:@"nil" andReplace:YES];
    SimpleDBReplaceableAttribute *photoAttribute1 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"dummyAttribute" andValue:@"dummyAttribute" andReplace:YES];
    [attributes1 addObject:photoAttribute];
    [attributes1 addObject:photoAttribute1];
    SimpleDBPutAttributesRequest *putAttributesRequest1 = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"photoProfileItem" andAttributes:attributes1];
    [sdb putAttributes:putAttributesRequest1];
    
    
    
    
//    NSMutableArray *availibility= [[NSMutableArray alloc] initWithCapacity:2];
//    SimpleDBReplaceableAttribute *startTimeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"startTimeAttribute" andValue:@"00:00AM" andReplace:YES];
//    SimpleDBReplaceableAttribute *endTimeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"endTimeAttribute" andValue:@"00:00AM" andReplace:YES];
//    [availibility addObject:startTimeAttribute];
//    [availibility addObject:endTimeAttribute];
//    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"availbilityItem" andAttributes:availibility];
//    [sdb putAttributes:putAttributesRequest];
}

-(void)dismissKeyboard {
    [confirmCode resignFirstResponder];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)keyboardDidShow:(NSNotification *)notification{
    if ([[UIScreen mainScreen]bounds].size.height==568) {
        [self.view setFrame:CGRectMake(0, -50, 320, 568)];
    }else{
        [self.view setFrame:CGRectMake(0, -130, 320, 480)];
    }
}


-(void)keyboardDidHide:(NSNotification *)notification{
    if ([[UIScreen mainScreen]bounds].size.height==568) {
        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        [self.view setFrame:CGRectMake(0, 0, 320, 480)];
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
