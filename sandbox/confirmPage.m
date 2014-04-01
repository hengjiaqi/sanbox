//
//  confirmPage.m
//  sandbox
//
//  Created by jake on 3/17/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "confirmPage.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
@interface confirmPage ()

@end

@implementation confirmPage

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
        [self setupDatabase];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:self.registerPhoneNumber forKey:@"EAT2GETHER_ACCOUNT_NAME"];
        [defaults synchronize];
        
        [self performSegueWithIdentifier:@"logInAfterRegister" sender:sender];
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
    NSMutableArray *attributes = [[NSMutableArray alloc] initWithCapacity:1];
    [attributes addObject:passwordAttribute];
    SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"passwordItem" andAttributes:attributes];
    [sdb putAttributes:putAttributesRequest];
    
    //nickname item
    SimpleDBReplaceableAttribute *nickNameAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"nicknameAttribute" andValue:self.registerNickName andReplace:YES];
    NSMutableArray *NicknameAttributes = [[NSMutableArray alloc] initWithCapacity:1];
    [NicknameAttributes addObject:nickNameAttribute];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"nicknameItem" andAttributes:NicknameAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //friendList item
    NSMutableArray *friendListAttributes = [[NSMutableArray alloc] initWithCapacity:2];
    SimpleDBReplaceableAttribute *friendListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000000" andValue:@"firstUser" andReplace:YES];
    SimpleDBReplaceableAttribute *friendListAttribute2 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000001" andValue:@"secondUser" andReplace:YES];
    SimpleDBReplaceableAttribute *friendListAttribute3 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000002" andValue:@"thirdUser" andReplace:YES];
    [friendListAttributes addObject:friendListAttribute];
    [friendListAttributes addObject:friendListAttribute2];
    [friendListAttributes addObject:friendListAttribute3];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"friendListItem" andAttributes:friendListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //friendRequestList item
    NSMutableArray *friendRequestListAttributes = [[NSMutableArray alloc] initWithCapacity:1];
    SimpleDBReplaceableAttribute *friendRequestListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000000" andValue:@"firstUser" andReplace:YES];
    [friendRequestListAttributes addObject:friendRequestListAttribute];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"friendRequestListItem" andAttributes:friendRequestListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //Availibility item
    NSMutableArray *availibility= [[NSMutableArray alloc] initWithCapacity:2];
    SimpleDBReplaceableAttribute *startTimeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"startTimeAttribute" andValue:@"" andReplace:YES];
    SimpleDBReplaceableAttribute *endTimeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"endTimeAttribute" andValue:@"" andReplace:YES];
    [availibility addObject:startTimeAttribute];
    [availibility addObject:endTimeAttribute];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"availbilityItem" andAttributes:availibility];
    [sdb putAttributes:putAttributesRequest];
    
    //beVisiableTo item
    NSMutableArray *beVisibleToListAttributes = [[NSMutableArray alloc] initWithCapacity:1];
    SimpleDBReplaceableAttribute *beVisibleToListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000000" andValue:@"firstUser" andReplace:YES];
    SimpleDBReplaceableAttribute *beVisibleToListAttribute2 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000002" andValue:@"thirdUser" andReplace:YES];
    [beVisibleToListAttributes addObject:beVisibleToListAttribute];
    [beVisibleToListAttributes addObject:beVisibleToListAttribute2];
    
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"beVisiableToItem" andAttributes:beVisibleToListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //beInvisiableTo item
    NSMutableArray *beInvisibleToListAttributes = [[NSMutableArray alloc] initWithCapacity:1];
    SimpleDBReplaceableAttribute *beInvisibleToListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000001" andValue:@"secondUser" andReplace:YES];
    [beInvisibleToListAttributes addObject:beInvisibleToListAttribute];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"beInvisiableToItem" andAttributes:beInvisibleToListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //onlineFriendList item
    NSMutableArray *onlineFriendListAttributes = [[NSMutableArray alloc] initWithCapacity:2];
    SimpleDBReplaceableAttribute *onlineFriendListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000001" andValue:@"secondUser" andReplace:YES];
    SimpleDBReplaceableAttribute *onlineFriendListAttribute2 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000002" andValue:@"thirdUser" andReplace:YES];
    [onlineFriendListAttributes addObject:onlineFriendListAttribute];
    [onlineFriendListAttributes addObject:onlineFriendListAttribute2];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"onlineFriendListItem" andAttributes:onlineFriendListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    //offlineFriendList item
    NSMutableArray *offlineFriendListAttributes = [[NSMutableArray alloc] initWithCapacity:1];
    SimpleDBReplaceableAttribute *offlineFriendListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"2060000000" andValue:@"firstUser" andReplace:YES];
    [offlineFriendListAttributes addObject:offlineFriendListAttribute];
    putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:self.registerPhoneNumber andItemName:@"offlineFriendListItem" andAttributes:offlineFriendListAttributes];
    [sdb putAttributes:putAttributesRequest];
    
    
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

@end
