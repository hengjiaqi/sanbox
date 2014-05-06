//
//  newUser.m
//  sandbox
//
//  Created by jake on 3/17/14.
//  Copyright (c) 2014 jake. All rights reserved.
//testtt

#import "T0newUser.h"
#import "AmazonClientManager.h"
#import "T0confirmPage.h"
NSString *twilioAccount = @"ACa8cd84343d08f6f84fd3ca5b1c532751";
NSString *twilioAuth = @"dd10c126da38021664352140c022b0a6";
NSString *twilioNumber = @"4257287464";
int confirmation;
NSMutableArray *domains;
@interface T0newUser ()

@end

@implementation T0newUser

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
    /*
     AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
    NSMutableArray *remove = [[NSMutableArray alloc] init];
    SimpleDBAttribute *ListAttribute = [[SimpleDBAttribute alloc] initWithName:@"2060000000" andValue:@"firstUser"];
    [remove addObject:ListAttribute];
    SimpleDBDeleteAttributesRequest *request = [[SimpleDBDeleteAttributesRequest alloc] initWithDomainName:@"2069723264" andItemName:@"friendListItem" andAttributes:remove];
    [sdb deleteAttributes:request];
     
    AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
     SimpleDBDeleteDomainRequest *request = [[SimpleDBDeleteDomainRequest alloc] initWithDomainName:@"2066176882"];
     [sdb deleteDomain:request];
    */
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification object:nil];
    
    [self.view addGestureRecognizer:tap];
    newUserPassword.secureTextEntry = YES;
    newUserPasswordAgain.secureTextEntry = YES;
    newUserPassword.delegate = self;
    newUserPasswordAgain.delegate = self;
    newUserPhoneNumber.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goToConfirmPage"]){
        T0confirmPage *confirm = (T0confirmPage *)[[segue destinationViewController] topViewController];
        NSString* myNewString = [NSString stringWithFormat:@"%d", confirmation];
        NSLog(@"mynewString is %@", myNewString);
        confirm.confirmationCode = myNewString;
        confirm.registerNickName = newUserNickName.text;
        confirm.registerPhoneNumber = newUserPhoneNumber.text;
        confirm.registerPassword = newUserPassword.text;
    }
}

- (IBAction)confirmButton:(id)sender {
    int code = [self checkRegisterInfo];
    UIAlertView *alert;
    //everything is ok, send user a confirmation code
    if (code == 0) {
        [self sendMessage : newUserPhoneNumber.text];
        alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"We have send you a text message with confirmation code." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self performSegueWithIdentifier:@"goToConfirmPage" sender:sender];
        
        
    }else if(code == 1){
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid Phone Number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if(code == 2){
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your password is not consistant" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if(code == 3){
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if(code == 4){
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your password again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if(code == 5){
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Nick name cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if(code == 6){
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your phone number is already registered. Please contact admin if this is a mistake. We are sorry about inconvenience." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
}
- (BOOL) checkPhoneNumberRegistered{
    SimpleDBListDomainsRequest *listDoaminRequest = [[SimpleDBListDomainsRequest alloc]init];
    SimpleDBListDomainsResponse *listDomainResponse = [[AmazonClientManager sdb] listDomains:listDoaminRequest];
    if (listDomainResponse.error != nil) {
        NSLog(@"Error: @%", listDomainResponse.error);
    }
    if (domains == nil) {
        domains = [[NSMutableArray alloc] initWithCapacity:[listDomainResponse.domainNames count]];
    }
    else {
        [domains removeAllObjects];
    }
    
    for (NSString *name in listDomainResponse.domainNames) {
        [domains addObject:name];
    }
    
    [domains sortUsingSelector:@selector(compare:)];
    
    bool exist = [domains containsObject:newUserPhoneNumber.text];
    return exist;
}



-(int) checkRegisterInfo{
    if ([newUserPhoneNumber.text isEqualToString:@""]) {
        return 1;
    }else if (![newUserPassword.text isEqualToString:newUserPasswordAgain.text ]) {
        return 2;
    }else if ([newUserPassword.text isEqualToString:@""]) {
        return 3;
    }else if ([newUserPasswordAgain.text isEqualToString:@""]) {
        return 4;
    }else if ([newUserNickName.text isEqualToString:@""]) {
        return 5;
    }else if ([self checkPhoneNumberRegistered]) {
        return 6;
    }else{
        return 0;
    }
}

- (void)sendMessage:(NSString *) userPhoneNumber {
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", twilioAccount, twilioAuth, twilioAccount];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    confirmation = (arc4random() % (9000)) + 1000;
    NSString *textContent = [NSString stringWithFormat:@"Hello from Eat2gether! Your confirmation code IS: %d", confirmation];
    //textContent = @"LALALALALALA";
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", twilioNumber,userPhoneNumber,textContent];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSError *error;
    NSURLResponse *response;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something is wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSLog(@"%@", receivedData.description);
    }
    
}



//Dismiss keyboard
-(void)dismissKeyboard {
    [newUserPassword resignFirstResponder];
    [newUserPhoneNumber resignFirstResponder];
    [newUserPasswordAgain resignFirstResponder];
    [newUserNickName resignFirstResponder];
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
