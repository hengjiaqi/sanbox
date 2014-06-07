//
//  T2addFromContact.m
//  Eat2gether
//
//  Created by jake on 5/17/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T2addFromContact.h"
#import <AddressBook/AddressBook.h>
#import "simpleDBHelper.h"
NSMutableDictionary *contacts;
NSMutableArray *registeredContactsName;
NSMutableArray *registeredContactsNumber;
NSMutableArray *unregisteredContactsName;
NSMutableArray *unregisteredContactsNumber;
NSString *USER_NAME;
NSMutableArray *allDomains;
NSString *friendPhoneNumber;
NSArray *allKeys;

@interface T2addFromContact ()

@end

@implementation T2addFromContact

ABAddressBookRef addressBookRef;
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
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    allDomains = [hp getAllDomains];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    contacts = [[NSMutableDictionary alloc]init];
    registeredContactsName = [[NSMutableArray alloc]init];
    registeredContactsNumber = [[NSMutableArray alloc]init];
    unregisteredContactsName = [[NSMutableArray alloc]init];
    unregisteredContactsNumber = [[NSMutableArray alloc]init];
    
    addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                [self getAllContactNames];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [self getAllContactNames];

    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    NSMutableArray *friendList = [hp getAllAttributeNames:USER_NAME item:@"friendListItem"];
    for (NSString *number in allKeys) {
        NSLog(@"%@", number);
        if ([allDomains containsObject:number] && ![friendList containsObject:number]
            && ![number isEqualToString:USER_NAME]) {
            [registeredContactsNumber addObject:number];
            [registeredContactsName addObject:[contacts objectForKey:number]];
            NSLog(@"1232131334422434%@",number);
        }else{
            [unregisteredContactsNumber addObject:number];
            [unregisteredContactsName addObject:[contacts objectForKey:number]];
            
        }
    }
    
}

- (void)getAllContactNames
{
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        ABMultiValueRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *firstNameString = (__bridge NSString *) firstName;
        NSString *lastNameString;
        if ((__bridge NSString *) lastName == nil) {
            lastNameString = @"";
        }else{
            lastNameString = (__bridge NSString *) lastName;
        }
        
        NSString *fullName = [[NSString alloc]initWithFormat:@"%@ %@", firstNameString, lastNameString];
        
        ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
            CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
            CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
            
            NSString *check = (__bridge NSString *)currentPhoneLabel;
            if (check.length !=0 ) {
                if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                    NSString *afterPhoneNumber = [(__bridge NSString *)currentPhoneValue stringByReplacingOccurrencesOfString:@"+1" withString:@""];
                    afterPhoneNumber = [[afterPhoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
                    NSLog(@"%@",afterPhoneNumber);
                    [contacts setObject:fullName forKey:afterPhoneNumber];
                }
            }
            CFRelease(currentPhoneLabel);
            CFRelease(currentPhoneValue);
        }
        CFRelease(phonesRef);
        if (((__bridge NSString *) firstName).length != 0) {
            CFRelease(firstName);
        }
        if (((__bridge NSString *) lastName).length != 0) {
            CFRelease(lastName);
        }
    }
    CFRelease(addressBookRef);
    CFRelease(people);
    allKeys = [contacts allKeys];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return registeredContactsName.count;
    }
    return unregisteredContactsNumber.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"registeredCell" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"unregisteredCell" forIndexPath:indexPath];
    }

    
    if (cell==nil){
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"registeredCell"];
        }else{
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"unregisteredCell"];
        }
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = registeredContactsName[indexPath.row];
    }else{
        cell.textLabel.text = unregisteredContactsName[indexPath.row];
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Registered Friends";
    }
    else
    {
        return @"Unregistered Friends";
    }
}

- (IBAction)backButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Add Friend" message:@"Send a friend request?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
        friendPhoneNumber = registeredContactsNumber[indexPath.row];
        
    }else{
        //NSLog(unregisteredContactsNumber[indexPath.row]);
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ((buttonIndex == 0) && ([[alertView title] isEqualToString:@"Add Friend"]))
    {
        NSLog(@"dialog shows up");
        //Check to see if request has already been sent
        simpleDBHelper *hp = [[simpleDBHelper alloc]init];
        NSString *numberToAdd = friendPhoneNumber;
        NSLog(@"NUMBER TO ADD IS %@", numberToAdd);
        
        BOOL alreadySent = [hp hasAttributes:numberToAdd item:@"friendRequestListItem" attributeName:USER_NAME];
        NSLog(@"%hhd", alreadySent);
        if (alreadySent) {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Friend Request" message:@"You have already sent this person a request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //Get my nick name
            NSLog(@"2");
            NSString* myNickName = [[NSString alloc] init];
            myNickName = [hp getAtrributeValue:USER_NAME item:@"nicknameItem" attribute:@"nicknameAttribute"];
            NSLog(@"MY NICK NAME IS %@", myNickName);
            //send the request
            [hp addAtrribute:numberToAdd item:@"friendRequestListItem" attribute:USER_NAME value:myNickName];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Request Sent." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
            
        }
    }
}

-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}


@end
