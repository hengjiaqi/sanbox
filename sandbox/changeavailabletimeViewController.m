//
//  changeAvailableTimeViewController.m
//  sandbox
//
//  Created by wuyue on 3/30/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "changeAvailableTimeViewController.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
NSString *USER_NAME;

@interface changeAvailableTimeViewController ()

@end

@implementation changeAvailableTimeViewController

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
    NSDate *pickertime = [NSDate date];
    [_datePicker setDate:pickertime animated:YES];
//    NSString selectStarttime = [setstarttimebutton.message];
    _starttimelabel.text = @"ni hao";
   // _endtimelabel.text = [setendtimebutton message]];
    
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

- (IBAction)setstarttimebutton:(id)sender {
    NSString *hrmin;
    NSString *PMAM;
    NSDate *select = [_datePicker date];
     NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    NSString *stringToDisplay = [df stringFromDate:select];
    if(stringToDisplay.length == 25){
    NSLog(@"length of string to display %d",stringToDisplay.length);
    NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringWithRange:NSMakeRange(13, 6)]);
    NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringFromIndex:22]);
    hrmin = [stringToDisplay substringWithRange:NSMakeRange(13, 6)];
    PMAM =[stringToDisplay  substringFromIndex:22];
    }else{ NSLog(@"length of string to display %d",stringToDisplay.length);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringWithRange:NSMakeRange(13, 5)]);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringFromIndex:21]);
        hrmin = [stringToDisplay substringWithRange:NSMakeRange(13, 5)];
        PMAM =[stringToDisplay  substringFromIndex:21];
    }
    NSString *LABEL = [hrmin stringByAppendingString:PMAM];
   // _starttimelabel.text = [stringToDisplay substringWithRange:NSMakeRange(13, 5)];
    _starttimelabel.text = LABEL;
}

- (IBAction)setendtimebutton:(id)sender {
    NSString *hrmin;
    NSString *PMAM;
    NSDate *select = [_datePicker date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    NSString *stringToDisplay = [df stringFromDate:select];
    if(stringToDisplay.length == 25){
        NSLog(@"length of string to display %d",stringToDisplay.length);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringWithRange:NSMakeRange(13, 6)]);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringFromIndex:22]);
        hrmin = [stringToDisplay substringWithRange:NSMakeRange(13, 6)];
        PMAM =[stringToDisplay  substringFromIndex:22];
    }else{ NSLog(@"length of string to display %d",stringToDisplay.length);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringWithRange:NSMakeRange(13, 5)]);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringFromIndex:21]);
        hrmin = [stringToDisplay substringWithRange:NSMakeRange(13, 5)];
        PMAM =[stringToDisplay  substringFromIndex:21];
    }
    NSString *LABEL = [hrmin stringByAppendingString:PMAM];
    _endtimelabel.text = LABEL;
}

- (IBAction)updatebutton:(id)sender {
    NSLog(@"NickName text field%d", _starttimelabel.text.length);
    NSLog(@"password text field%d", _endtimelabel.text.length);
    // load start time to the database
    if(_starttimelabel.text.length == 8){
        
    }

    
//    AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
//    // get the nickname on the database
//    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"nicknameItem"];
//    SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
//    for (SimpleDBAttribute *attr in response.attributes) {
//        NSLog(@"nickname here is %@", attr.value);
//    }
//    SimpleDBReplaceableAttribute *nickNameAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"nicknameAttribute" andValue:_me_NickName_textfield.text andReplace:YES];
//    NSMutableArray *NicknameAttributes = [[NSMutableArray alloc] initWithCapacity:1];
//    [NicknameAttributes addObject:nickNameAttribute];
//    
//    SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName: USER_NAME andItemName:@"nicknameItem" andAttributes:NicknameAttributes];
//    [sdb putAttributes:putAttributesRequest];
//    response = [[AmazonClientManager sdb] getAttributes:gar];
//    
//    for (SimpleDBAttribute *attr in response.attributes) {
//        NSLog(@"nickname here is after update %@", attr.value);
//        GNickname =attr.value;
//    }

}
@end
