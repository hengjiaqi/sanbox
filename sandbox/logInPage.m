//
//  logInPage.m
//  sandbox
//
//  Created by jake on 3/16/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "logInPage.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"


@interface logInPage ()

@end

@implementation logInPage

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
    password.secureTextEntry = YES;
    phoneNumber.delegate = self;
    password.delegate = self;

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
    
    AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
    SimpleDBDeleteDomainRequest *request = [[SimpleDBDeleteDomainRequest alloc] initWithDomainName:@"2066176882"];
    [sdb deleteDomain:request];
    
    
    [self performSegueWithIdentifier:@"loginTransistion" sender:sender];
}

/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)data;
    int code = [httpResponse statusCode];
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

@end
