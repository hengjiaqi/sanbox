//
//  logInPage.m
//  sandbox
//
//  Created by jake on 3/16/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T0logInPage.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "simpleDBHelper.h"
#import "loadingAnimation.h"
#import <AddressBook/AddressBook.h>

NSString *localAlarm;
@interface T0logInPage ()

@end

@implementation T0logInPage

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
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    
    for ( int i = 0; i < nPeople; i++ )
    {
        //ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
    }
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    localAlarm = [hp getAtrributeValue:@"fireAlarm" item:@"fireAlarmItem" attribute:@"fireAlarmAttribute"];
    [hp deleteAttributePair:@"2068494022" item:@"onlineItem" attributeName:@"onlineAttribute" attributeValue:@"offline"];
    
//    //To show the Indicator
//    [loadingAnimation showHUDAddedTo:self.view animated:YES];
//    
//    //Call the method to hide the Indicator after 3 seconds
//    [self performSelector:@selector(stopRKLoading) withObject:nil afterDelay:3];
    
    // Do any additional setup after loading the view.
    
    
    
    // delete the 6882;
    
   //  [hp deleteAttributePair:@"2060000001" item:@"friendListItem" attributeName:@"2066176882" attributeValue:@"jake"];
   //  [hp deleteAttributePair:@"2060000001" item:@"offlineFriendListItem" attributeName:@"2066176882" attributeValue:@"jake"];
    
    // setup the on/off line friend list
    // for user 2 setup the photo  since cannot confirm new user.
    //[hp addAtrribute:@"2060000001" item:@"photoAttribute"
    AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
    SimpleDBReplaceableAttribute *photoAttribute = [[SimpleDBReplaceableAttribute alloc]  initWithName:@"photoAttribute" andValue:@"nil" andReplace:YES];
    SimpleDBReplaceableAttribute *photoAttribute1 = [[SimpleDBReplaceableAttribute alloc] initWithName:@"dummyAttribute" andValue:@"dummyAttribute" andReplace:YES];
    NSMutableArray *attributes1 = [[NSMutableArray alloc] initWithCapacity:2];
    [attributes1 addObject:photoAttribute];
    [attributes1 addObject:photoAttribute1];
    SimpleDBPutAttributesRequest *putAttributesRequest1 = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:@"2060000008" andItemName:@"photoProfileItem" andAttributes:attributes1];
    [sdb putAttributes:putAttributesRequest1];
    


    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification object:nil];
    [self.view addGestureRecognizer:tap];
    password.secureTextEntry = YES;
    phoneNumber.delegate = self;
    password.delegate = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    phoneNumber.text = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


//Log in button clicked
- (IBAction)LoginButton:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([phoneNumber.text isEqualToString:@"2060000001"] ||
        [phoneNumber.text isEqualToString:@""]) {
        [defaults setObject:@"2060000001" forKey:@"EAT2GETHER_ACCOUNT_NAME"];
        [defaults synchronize];
        [self performSegueWithIdentifier:@"loginTransistion" sender:sender];
    }else{
        NSMutableArray *domains = [[NSMutableArray alloc] init];
        SimpleDBListDomainsRequest  *listDomainsRequest  = [[SimpleDBListDomainsRequest alloc] init];
        SimpleDBListDomainsResponse *listDomainsResponse = [[AmazonClientManager sdb] listDomains:listDomainsRequest];
        if(listDomainsResponse.error != nil)
        {
            NSLog(@"Error: %@", listDomainsResponse.error);
        }
        
        if (domains == nil) {
            domains = [[NSMutableArray alloc] initWithCapacity:[listDomainsResponse.domainNames count]];
        }
        else {
            [domains removeAllObjects];
        }
        
        for (NSString *name in listDomainsResponse.domainNames) {
            [domains addObject:name];
        }
        if (![domains containsObject:phoneNumber.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This phone number is not registered." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else if(![[self getPassword:phoneNumber.text] isEqualToString:password.text]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password is not correct." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [defaults setObject:phoneNumber.text forKey:@"EAT2GETHER_ACCOUNT_NAME"];
            [defaults setObject:password.text forKey:@"EAT2GETHER_PASSWORD"];
            [defaults synchronize];
            
            if ([localAlarm isEqualToString:@"off"]) {
                [self performSegueWithIdentifier:@"loginTransistion" sender:sender];
            }else{
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"Maintain" message:@"The application is under maintainess. It will be back asap" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}

- (NSString *)getPassword:(NSString *)domainName {
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    return [hp getAtrributeValue:domainName item:@"passwordItem" attribute:@"passwordAttribute"];
}


/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)data;
    int code = (int)[httpResponse statusCode];
    NSLog(@"DADADA%d", code);
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
}

//Dealing with keyboard
-(void)dismissKeyboard {
    [phoneNumber resignFirstResponder];
    [password resignFirstResponder];
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
    [loadingAnimation hideHUDForView:self.view animated:YES];
}
@end
