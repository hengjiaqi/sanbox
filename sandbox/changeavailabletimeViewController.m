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
    
    NSDate *select = [_datePicker date];
    NSString *message = [[NSString alloc] initWithFormat:@"%@",select];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"HH:mm"];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    
    NSString *stringToDisplay = [df stringFromDate:select];
    
    NSLog(@"%@",[message substringWithRange:NSMakeRange(10, 6)]);
    NSLog(@"%@",stringToDisplay);
    _starttimelabel.text = [stringToDisplay substringWithRange:NSMakeRange(13, 6)];
}

- (IBAction)setendtimebutton:(id)sender {
    NSDate *select = [_datePicker date];
    NSString *message = [[NSString alloc] initWithFormat:@"%@",select];
   // NSLog(@"%@",[message substringWithRange:NSMakeRange(10, 6)]);
    NSLog(@"%@",message );
    _endtimelabel.text = [message substringWithRange:NSMakeRange(10, 6)];
}

- (IBAction)updatebutton:(id)sender {
//    // put the start time and end time on the database
//      AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
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
//        //_me_NickName_textfield.text = attr.value;
//    }

}
@end
