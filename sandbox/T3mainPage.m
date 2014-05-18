//
//  T3preferenceMainTableViewController.m
//  sandbox
//
//  Created by wuyue on 4/4/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "T3mainPage.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
#import "simpleDBhelper.h"


//#import "FriendListTableViewController.m"
NSString *USER_NAME;
NSString *GNickname;
NSString *startTimeFromDefault;
NSString *endTimeFromDefault;
NSString *preferenceFromDefault;
NSString *availableFromDefault;
NSString *kDateCellID = @"dateCell";
NSString *kNormalCellID = @"normalCell";
NSString *kPickerCellID = @"pickerCell";
NSString *kPreferenceCellID = @"preferenceCell";
NSDate *startTime;
NSDate *endTime;
NSArray *data;
BOOL pickerIsShown = NO;
int pickerRow;
UIView *inputAccView;
UIButton *btnDone;

@interface T3mainPage ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (assign) NSInteger pickerCellRowHeight;
@property (strong, nonatomic) IBOutlet UITableView *entireTableView;
@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (strong, nonatomic) IBOutlet UITextView *preferenceTextField;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;
@property dispatch_queue_t queue;
@end


#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view
#define kDateStartRow   0
#define kDateEndRow     1
#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation T3mainPage



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
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    [super viewDidLoad];
    
    // setup our data source (array store)
    data= @[@"From",@"Until",@"Preference",@"I want to eat!"];
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kPickerCellID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"EEE,MM/dd hh:mm a"];
    
    //get the information from AWS
    //get the start time and end time from AWS
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //get the user name
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    NSString *startTimeFromDB = [hp getAtrributeValue:USER_NAME item:@"availbilityItem" attribute:@"startTimeAttribute"];
    [defaults setObject:startTimeFromDB forKey:@"USER_START_DEFAULT"];
    [defaults synchronize];
    NSString *endTimeFromDB = [hp getAtrributeValue:USER_NAME item:@"availbilityItem" attribute:@"endTimeAttribute"];
    [defaults setObject:endTimeFromDB forKey:@"USER_END_DEFAULT"];
    [defaults synchronize];
    
    //get the preference from AWS
    NSString *preferenceFromDB = [hp getAtrributeValue:USER_NAME item:@"preferenceItem" attribute:@"preferenceAttribute"];
    [defaults setObject:preferenceFromDB forKey:@"USER_PREF_DEFAULT"];
    [defaults synchronize];
    
    //configure the switch
    NSString *availableButtonFromDB = [hp getAtrributeValue:USER_NAME item:@"onlineItem" attribute:@"onlineAttribute"];
    [defaults setObject:availableButtonFromDB forKey:@"USER_SWITCH_DEFAULT"];
    
    //[hp deleteAttributePair:USER_NAME item:@"onlineItem" attributeName:@"onlineAttribute" attributeValue:@"online"];
 

}

-(void) viewDidAppear:(BOOL)animated{
    NSUserDefaults *timeDefault = [NSUserDefaults standardUserDefaults];
    startTimeFromDefault = [timeDefault objectForKey:@"USER_START_DEFAULT"];
    endTimeFromDefault = [timeDefault objectForKey:@"USER_END_DEFAULT"];
    preferenceFromDefault = [timeDefault objectForKey:@"USER_PREF_DEFAULT"];
    availableFromDefault = [timeDefault objectForKey:@"USER_SWITCH_DEFAULT"];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (pickerIsShown && indexPath.row == pickerRow && indexPath.section == 0) {
        return self.pickerCellRowHeight;
    }else if(indexPath.section == 1){
        return self.tableView.rowHeight * 1.5;
    }else{
        return self.tableView.rowHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *timeDefault = [NSUserDefaults standardUserDefaults];
    startTimeFromDefault = [timeDefault objectForKey:@"USER_START_DEFAULT"];
    endTimeFromDefault = [timeDefault objectForKey:@"USER_END_DEFAULT"];
    preferenceFromDefault = [timeDefault objectForKey:@"USER_PREF_DEFAULT"];
    availableFromDefault = [timeDefault objectForKey:@"USER_SWITCH_DEFAULT"];
    NSString *cellIdentifier = [[NSString alloc]init];
    if (indexPath.row == pickerRow && pickerIsShown && indexPath.section == 0) {
        cellIdentifier = kPickerCellID;
    }else if (indexPath.section == 0){
        cellIdentifier = kDateCellID;
    }else if (indexPath.section == 1){
        cellIdentifier = kPreferenceCellID;
    }else{
        cellIdentifier = kNormalCellID;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    if (cellIdentifier == kDateCellID) {
        if (indexPath.row == 0) {
            cell.textLabel.text = data[0];
            cell.detailTextLabel.text = startTimeFromDefault;
        }else{
            cell.textLabel.text = data[1];
            cell.detailTextLabel.text = endTimeFromDefault;
        }
    }else if(cellIdentifier == kPreferenceCellID){
        self.preferenceTextField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height * 1.5)];
        //preferenceTextField.delegate = self;
        self.preferenceTextField.textColor = [UIColor blackColor];
        self.preferenceTextField.delegate = self;
        [self.preferenceTextField setFont:[UIFont systemFontOfSize:17.0f]];
        [self.preferenceTextField setReturnKeyType:UIReturnKeyNext];
        self.preferenceTextField.keyboardType = UIKeyboardTypeDefault;
        self.preferenceTextField.returnKeyType = UIReturnKeyDone;
        self.preferenceTextField.text = preferenceFromDefault;
        self.preferenceTextField.backgroundColor = [UIColor whiteColor];
        self.preferenceTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.preferenceTextField.autocapitalizationType = UITextAutocorrectionTypeDefault;
        self.preferenceTextField.tag = 0;
        self.preferenceTextField.returnKeyType = UIReturnKeyNext;
        [cell.contentView addSubview:self.preferenceTextField];
    }else if (cellIdentifier == kNormalCellID){
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryView = availableButton;
        if ([availableFromDefault isEqualToString:@"online"]) {
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.text =@"Make Me Unavailable";
        }else{
            
            cell.textLabel.textColor = [UIColor greenColor];
            cell.textLabel.text =@"Make Me Available";
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return cell;
}

-(void)createInputAccessoryView{
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [inputAccView setBackgroundColor:[UIColor grayColor]];
    [inputAccView setAlpha: 0.8];
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(240.0, 0.0f, 80.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor grayColor]];
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    [inputAccView addSubview:btnDone];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    [self createInputAccessoryView];
    [aTextView setInputAccessoryView:inputAccView];
    self.preferenceTextField = aTextView;
    return YES;
}

-(void)doneTyping{
    [self.preferenceTextField resignFirstResponder];
    
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(_queue, ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.preferenceTextField.text forKey:@"USER_PREF_DEFAULT"];
        if ([availableFromDefault isEqualToString:@"online"]) {
            simpleDBHelper *hp = [[simpleDBHelper alloc]init];
            [hp updateAtrribute:USER_NAME item:@"preferenceItem" attribute:@"preferenceAttribute" newValue:self.preferenceTextField.text];
        }
    });
}

// set the numbers of row in specific section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (pickerIsShown && section == 0) {
        return 3;
    }else if (section == 0){
        return 2;
    }
    return 1;
}

// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}



//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected indexpath is %d", indexPath.row);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID) {
        if (pickerIsShown) {
            [self.tableView beginUpdates];
            pickerIsShown = NO;
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:pickerRow inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationFade];
            pickerIsShown = NO;
            [self.tableView endUpdates];
            if (indexPath.row + 1 != pickerRow) {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
                    [self displayInlineDatePickerForRowAtIndexPath:indexPath];
                }else
                    [self displayExternalDatePickerForRowAtIndexPath:indexPath];
            }
        }else{
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
                [self displayInlineDatePickerForRowAtIndexPath:indexPath];
            }else
                [self displayExternalDatePickerForRowAtIndexPath:indexPath];
        }
        
    }
    if (cell.reuseIdentifier == kNormalCellID) {
        simpleDBHelper *hp = [[simpleDBHelper alloc]init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([availableFromDefault isEqualToString:@"online"]) {
            cell.textLabel.text = @"Make Me Available";
            cell.textLabel.textColor = [UIColor greenColor];
            [loadingAnimation showHUDAddedTo:self.view animated:YES];
            _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(_queue, ^{
                NSString *dummy = [hp getAtrributeValue:USER_NAME item:@"onlineItem" attribute:@"onlineAttribute"];
                [hp updateAtrribute:USER_NAME item:@"onlineItem" attribute:@"onlineAttribute" newValue:@"offline"];
                [defaults setObject:@"offline" forKey:@"USER_SWITCH_DEFAULT"];
                availableFromDefault = @"offline";
                while ([dummy isEqualToString:@"online"]) {
                    dummy = [hp getAtrributeValue:USER_NAME item:@"onlineItem" attribute:@"onlineAttribute"];
                    [hp updateAtrribute:USER_NAME item:@"onlineItem" attribute:@"onlineAttribute" newValue:@"offline"];
                }
                NSLog(@"It was on, and will be turned off");
                dispatch_async(dispatch_get_main_queue(),^{
                //To show the Indicator
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You are unavailable." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                [alert show];
                [self performSelector:@selector(stopRKLoading) withObject:nil];
                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
                });
            });
            //To show the Indicator
            [loadingAnimation showHUDAddedTo:self.view animated:YES];
            
            //Call the method to hide the Indicator after 3 seconds
            [self performSelector:@selector(stopRKLoading) withObject:nil];
        }else{
            BOOL valid = NO;
            if (startTimeFromDefault.length < 9) {
                valid = YES;
            }
            if (!valid) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"EEE,MM/dd hh:mm a"];
                NSDate *newStartDate = [[NSDate alloc]init];
                newStartDate = [df dateFromString:startTimeFromDefault];
                NSDate *newEndDate = [[NSDate alloc]init];
                newEndDate = [df dateFromString:endTimeFromDefault];
                if ([newStartDate compare:newEndDate] == NSOrderedAscending) {
                    valid = YES;
                }
            }
            
            if (valid) {
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.text = @"Make Me Unavailable";
                availableFromDefault = @"online";
                [defaults setObject:@"online" forKey:@"USER_SWITCH_DEFAULT"];
                [loadingAnimation showHUDAddedTo:self.view animated:YES];
                _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(_queue, ^{
                    [hp updateAtrribute:USER_NAME item:@"onlineItem" attribute:@"onlineAttribute" newValue:@"online"];
                    NSString *dummy = [hp getAtrributeValue:USER_NAME item:@"onlineItem" attribute:@"onlineAttribute"];
                    while ([dummy isEqualToString:@"offline"]) {
                        dummy = [hp getAtrributeValue:USER_NAME item:@"onlineItem" attribute:@"onlineAttribute"];
                        [hp updateAtrribute:USER_NAME item:@"onlineItem" attribute:@"onlineAttribute" newValue:@"online"];
                    }
                    //upload start time and end time to AWS
                    [hp updateAtrribute:USER_NAME item:@"availbilityItem" attribute:@"startTimeAttribute" newValue:startTimeFromDefault];
                    
                    [hp updateAtrribute:USER_NAME item:@"availbilityItem" attribute:@"endTimeAttribute" newValue:endTimeFromDefault];
                    
                    [hp updateAtrribute:USER_NAME item:@"preferenceItem" attribute:@"preferenceAttribute" newValue:self.preferenceTextField.text];
                    NSLog(@"DONE!");
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        //To show the Indicator
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You are available." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                        [alert show];
                        [self performSelector:@selector(stopRKLoading) withObject:nil];
                        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
                    });
                });
            }else{
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"The start time can not be later than end time!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            
        }
    }
    if (!pickerIsShown) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    
}



- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        [self.tableView beginUpdates];
        if (indexPath.row == 0) {
            pickerRow = indexPath.row+1;
        }else{
            pickerRow = 2;
        }
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:pickerRow inSection:0]];
        pickerIsShown = YES;
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        pickerIsShown = YES;
        [self.tableView endUpdates];

    
    NSLog(@"picker row is %d", pickerRow);
    
}

//
- (IBAction)pickerChanged:(id)sender {
    NSIndexPath *targetedCellIndexPath = nil;
    targetedCellIndexPath = [NSIndexPath indexPathForRow:pickerRow - 1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    if (pickerRow == 1) {
        startTime = targetedDatePicker.date;
    }else{
        endTime = targetedDatePicker.date;
    }
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    simpleDBHelper *hp = [[simpleDBHelper alloc]init];
    if (targetedCellIndexPath.row == 0) {
        if ([availableFromDefault isEqualToString:@"online"]) {
            
            _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(_queue, ^{
                NSString *dummy = [hp getAtrributeValue:USER_NAME item:@"availbilityItem" attribute:@"startTimeAttribute"];
                [hp updateAtrribute:USER_NAME item:@"availbilityItem" attribute:@"startTimeAttribute" newValue:cell.detailTextLabel.text];
                
                while (![dummy isEqualToString:cell.detailTextLabel.text]) {
                    dummy = [hp getAtrributeValue:USER_NAME item:@"availbilityItem" attribute:@"startTimeAttribute"];
                    [hp updateAtrribute:USER_NAME item:@"availbilityItem" attribute:@"startTimeAttribute" newValue:cell.detailTextLabel.text];
                }
            });
        }
        [defaults setObject:cell.detailTextLabel.text forKey:@"USER_START_DEFAULT"];
    }else{
        if ([availableFromDefault isEqualToString:@"online"]) {
            _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(_queue, ^{
                NSString *dummy = [hp getAtrributeValue:USER_NAME item:@"availbilityItem" attribute:@"endTimeAttribute"];
                [hp updateAtrribute:USER_NAME item:@"availbilityItem" attribute:@"endTimeAttribute" newValue:cell.detailTextLabel.text];
                
                while (![dummy isEqualToString:cell.detailTextLabel.text]) {
                    dummy = [hp getAtrributeValue:USER_NAME item:@"availbilityItem" attribute:@"endTimeAttribute"];
                    [hp updateAtrribute:USER_NAME item:@"availbilityItem" attribute:@"endTimeAttribute" newValue:cell.detailTextLabel.text];
                }
            });
        }
        [defaults setObject:cell.detailTextLabel.text forKey:@"USER_END_DEFAULT"];
    }
    [defaults synchronize];
}


- (void)updateDatePicker
{
    if (pickerIsShown)
    {
        NSIndexPath *targetedCellIndexPath = [NSIndexPath indexPathForRow:pickerRow inSection:0];
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            if (pickerRow == 1) {
                [targetedDatePicker setDate:startTime animated:NO];
            }else{
                [targetedDatePicker setDate:endTime animated:NO];
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Availbility";
    }
    else if(section == 1)
    {
        return @"Preference";
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(id)sender{
    if (self.preferenceTextField.text.length > 32) {
        CGRect frameRect = self.preferenceTextField.frame;
        frameRect.size.height = self.tableView.rowHeight * 2;
        self.preferenceTextField.frame = frameRect;
        
    }
}


-(void)dismissKeyboard {
    [self.preferenceTextField resignFirstResponder];
}

- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first update the date picker's date value according to our model
    NSDictionary *itemData = data[indexPath.row];
    [self.pickerView setDate:[itemData valueForKey:kDateKey] animated:YES];
    
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = self.view.frame.size.height;
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        // animate the date picker into view
        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = endFrame; }
                         completion:^(BOOL finished) {
                             // add the "Done" button to the nav bar
                             self.navigationItem.rightBarButtonItem = self.doneButton;
                         }];
    }
}

-(void)stopRKLoading
{
    [loadingAnimation hideHUDForView:self.view animated:YES];
}
// other code

-(void)dismissAlert:(UIAlertView *) alertView
{
   [alertView dismissWithClickedButtonIndex:nil animated:YES];
}

@end



