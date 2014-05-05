//
//  changeAvailableTimeViewController.m
//  sandbox
//
//  Created by wuyue on 3/30/14.
//  Copyright (c) 2014 jake. All rights reserved.
//
/*
#import "T3changeAvailableTimeViewController.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
NSString *USER_NAME;
NSDate *selectend;
NSDate *selectstart;
@interface T3changeAvailableTimeViewController ()

@end

@implementation T3changeAvailableTimeViewController

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
    NSString *starthr;
    NSString *startmin;
    NSString *endhr;
    NSString *endmin;
    NSString *startPMAM;
    NSString *endPMAM;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"availbilityItem"];
    SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
    for (SimpleDBAttribute *attr in response.attributes) {
        NSLog(@"nickname here is %@", attr.name);
        if([attr.name isEqualToString:@"startTimeAttribute"]){
            _starttimelabel.text = attr.value;
            starthr = [_starttimelabel.text substringWithRange:NSMakeRange(0, 2)];
            startmin =[_starttimelabel.text substringWithRange:NSMakeRange(3, 2)];
            startPMAM =[_starttimelabel.text substringWithRange:NSMakeRange(5, 2)];
        }else{
            _endtimelabel.text = attr.value;
            endhr = [_endtimelabel.text substringWithRange:NSMakeRange(0, 2)];
            endmin =[_endtimelabel.text substringWithRange:NSMakeRange(3, 2)];
            endPMAM =[_endtimelabel.text substringWithRange:NSMakeRange(5, 2)];
        }
    }
    int starthrI;
    int endhrI;
    if([startPMAM isEqualToString:@"PM"])
        starthrI= [starthr intValue]+12;
    else
        starthrI=[starthr intValue];
    if ([endPMAM isEqualToString:@"PM"])
        endhrI = [endhr intValue]+12;
    else
        endhrI = [endhr intValue];
    int startminI = [startmin intValue];
   // int endhrI = [endhr intValue];
    int endminI = [endmin intValue];
    NSDateComponents *compsstart = [[NSDateComponents alloc] init];
    [compsstart setHour:starthrI];
    [compsstart setMinute:startminI];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *datestart = [gregorian dateFromComponents:compsstart];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    NSString *stringToDisplay1 = [df stringFromDate:datestart];
     NSLog(@"current start time %@", stringToDisplay1);
    selectstart = datestart;
    NSDateComponents *compsend = [[NSDateComponents alloc] init];
    [compsend setHour:endhrI];
    [compsend setMinute:endminI];
    NSCalendar *gregorian2 = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dateend = [gregorian2 dateFromComponents:compsend];
    NSDateFormatter *dfend = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    NSString *stringToDisplay2 = [dfend stringFromDate:dateend];
    selectend = dateend;
    NSLog(@"current end time %@", stringToDisplay2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)setstarttimebutton:(id)sender {
    NSString *hr;
    NSString *min;
    NSString *PMAM;
    selectstart = [_datePicker date];
     NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setDateFormat:@"HH:mm"];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:selectstart];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSLog(@"before subtraction   %d", hour);
  //hr= [NSString stringWithFormat:@"%d", hour];
 //  min = [NSString stringWithFormat:@"%d", minute];
    if(hour >= 12 & hour < 24 ){
        PMAM = @"PM";
        if(hour >=13){
            hour = hour - 12;
        }
    }else{
        if(hour == 0){
            hour = hour + 12;
        }
        PMAM = @"AM";
    }
    hr= [NSString stringWithFormat:@"%d", hour];
    min = [NSString stringWithFormat:@"%d", minute];
    NSLog(@"selectstart hr is  %d",hour);
    NSLog(@"selectstart min is % d",minute);
    // _starttimelabel.text = [stringToDisplay substringWithRange:NSMakeRange(13, 5)];
   _starttimelabel.text = [NSString stringWithFormat:@"%@ : %@ %@" , hr, min,PMAM];
  //  _starttimelabel.text = LABEL;
}

- (IBAction)setendtimebutton:(id)sender {
    NSString *hr;
    NSString *min;
    NSString *PMAM;
    selectend = [_datePicker date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setDateFormat:@"HH:mm"];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:selectend];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSLog(@"before subtraction   %d", hour);
    //hr= [NSString stringWithFormat:@"%d", hour];
    //  min = [NSString stringWithFormat:@"%d", minute];
    if(hour >= 12 & hour < 24 ){
        PMAM = @"PM";
        if(hour >=13){
            hour = hour - 12;
        }
    }else{
        if(hour == 0){
            hour = hour + 12;
        }
        PMAM = @"AM";
    }
    hr= [NSString stringWithFormat:@"%d", hour];
    min = [NSString stringWithFormat:@"%d", minute];
    _endtimelabel.text = [NSString stringWithFormat:@"%@ : %@ %@" , hr, min,PMAM];
}

- (IBAction)updatebutton:(id)sender {
    NSLog(@"NickName text field%d", _starttimelabel.text.length);
    NSLog(@"password text field%d", _endtimelabel.text.length);
 
    if ([selectstart compare: selectend] == NSOrderedDescending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"startDate is later than endTime" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([selectstart compare:selectend] == NSOrderedAscending) {
        NSLog(@"startDate is earlier than endDate");

        AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
        //get the nickname on the database
        SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"availbilityItem"];
            SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
            for (SimpleDBAttribute *attr in response.attributes) {
                NSLog(@"nickname here is %@", attr.value);
            }
        NSMutableArray *availibility= [[NSMutableArray alloc] initWithCapacity:2];
        SimpleDBReplaceableAttribute *startTimeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"startTimeAttribute" andValue: _starttimelabel.text andReplace:YES];
        SimpleDBReplaceableAttribute *endTimeAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:@"endTimeAttribute" andValue:_endtimelabel.text andReplace:YES];
        [availibility addObject:startTimeAttribute];
        [availibility addObject:endTimeAttribute];
        SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"availbilityItem" andAttributes:availibility];
        [sdb putAttributes:putAttributesRequest];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"time are the same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"dates are the same");
        
    }
}

- (IBAction)backButtonPress:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
*/