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
NSDate *selectend;
NSDate *selectstart;
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
    selectstart = [_datePicker date];
     NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    NSString *stringToDisplay = [df stringFromDate:selectstart];
    if(stringToDisplay.length == 24){
    NSLog(@"length of string to display %d",stringToDisplay.length);
    NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringWithRange:NSMakeRange(13, 5)]);
    NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringFromIndex:22]);
    hrmin = [stringToDisplay substringWithRange:NSMakeRange(13, 5)];
    PMAM =[stringToDisplay  substringFromIndex:22];
    }else{ NSLog(@"length of string to display %d",stringToDisplay.length);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringWithRange:NSMakeRange(12, 5)]);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringFromIndex:21]);
        hrmin = [stringToDisplay substringWithRange:NSMakeRange(12, 5)];
        PMAM =[stringToDisplay  substringFromIndex:21];
    }
    NSString *LABEL = [hrmin stringByAppendingString:PMAM];
   // _starttimelabel.text = [stringToDisplay substringWithRange:NSMakeRange(13, 5)];
    _starttimelabel.text = LABEL;
}

- (IBAction)setendtimebutton:(id)sender {
    NSString *hrmin;
    NSString *PMAM;
    selectend = [_datePicker date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    NSString *stringToDisplay = [df stringFromDate:selectend];
    if(stringToDisplay.length == 24){
        NSLog(@"length of string to display %d",stringToDisplay.length);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringWithRange:NSMakeRange(13, 5)]);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringFromIndex:22]);
        hrmin = [stringToDisplay substringWithRange:NSMakeRange(13, 5)];
        PMAM =[stringToDisplay  substringFromIndex:22];
    }else{ NSLog(@"length of string to display %d",stringToDisplay.length);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringWithRange:NSMakeRange(12, 5)]);
        NSLog(@"STRING TO DISPLAY IS %@",[stringToDisplay substringFromIndex:21]);
        hrmin = [stringToDisplay substringWithRange:NSMakeRange(12, 5)];
        PMAM =[stringToDisplay  substringFromIndex:21];
    }
    NSString *LABEL = [hrmin stringByAppendingString:PMAM];
    _endtimelabel.text = LABEL;
}

- (IBAction)updatebutton:(id)sender {
   
    
    NSLog(@"NickName text field%d", _starttimelabel.text.length);
    NSLog(@"password text field%d", _endtimelabel.text.length);
    NSString *starthr;
    NSString *startmin;
    NSString *endhr;
    NSString *endmin;
    NSString *startPMAM;
    NSString *endPMAM;
    if ([selectstart compare: selectend] == NSOrderedDescending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"startDate is later than endTime" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([selectstart compare:selectend] == NSOrderedAscending) {
        NSLog(@"startDate is earlier than endDate");
        starthr = [_starttimelabel.text substringWithRange:NSMakeRange(0, 2)];
        startmin =[_starttimelabel.text substringWithRange:NSMakeRange(3, 2)];
        startPMAM =[_starttimelabel.text substringWithRange:NSMakeRange(5, 2)];
        endhr = [_endtimelabel.text substringWithRange:NSMakeRange(0, 2)];
        endmin =[_endtimelabel.text substringWithRange:NSMakeRange(3, 2)];
        endPMAM =[_endtimelabel.text substringWithRange:NSMakeRange(5, 2)];
        int starthrI = [starthr intValue];
        int startminI = [startmin intValue];
        int endhrI = [endhr intValue];
        int endminI = [endmin intValue];
        NSLog(@"start hour I is %d ",starthrI);
        NSLog(@"start min I is %d", startminI);
        NSLog(@"END hour is %d",endhrI);
        NSLog(@"END min is %d", endminI);
        
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
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"time are the same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"dates are the same");
        
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
