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
int pickerRow;
@interface T3mainPage ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;

@property (strong, nonatomic) IBOutlet UITableView *entireTableView;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;
@end


#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view
#define kDateStartRow   0
#define kDateEndRow     1
#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value
static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kNormalCellID = @"normalCell";     // the cells with the start or end date
static NSString *kPickerCellID = @"pickerCell";     // the cells with the start or end date
BOOL pickerIsShown = NO;
NSArray *data;
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
    NSLog(@"1");
    [super viewDidLoad];
    // setup our data source
    data= @[@"Available From",@"Available Until",@"Preference",@"Available to all friends"];


    NSLog(@"2");
    
    
    self.entireTableView.backgroundColor = [UIColor grayColor];
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kPickerCellID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    NSLog(@"3");
    NSString *starttimeload;
    NSString *endtimeload;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    USER_NAME = [defaults objectForKey:@"EAT2GETHER_ACCOUNT_NAME"];
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USER_NAME andItemName:@"availbilityItem"];
    SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
    for (SimpleDBAttribute *attr in response.attributes) {
        NSLog(@"nickname here is %@", attr.name);
        if([attr.name isEqualToString:@"startTimeAttribute"]){
            starttimeload = attr.value;
        }else{
            endtimeload = attr.value;
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (pickerIsShown && indexPath.row == pickerRow) {
        return self.pickerCellRowHeight;
    }else{
        return self.tableView.rowHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSLog(@"4");
    NSString *cellIdentifier = [[NSString alloc]init];
    if (indexPath.row == pickerRow && pickerIsShown) {
        cellIdentifier = kPickerCellID;
    }else if (pickerIsShown && indexPath.row != pickerRow && indexPath.row <=2 ){
        cellIdentifier = kDateCellID;
    }else if (!pickerIsShown && indexPath.row < 2 ){
        cellIdentifier = kDateCellID;
    }else{
        cellIdentifier = kNormalCellID;
    }
    
    NSLog(@"4.1");
    // if you have extra give it to me
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    if (pickerIsShown && indexPath.row == pickerRow){
        return cell;
    }
    NSLog(@"4.2");
    // Configure the cell...
    
    
    // set the text of the cell
    if (pickerIsShown && indexPath.row >2) {
        cell.textLabel.text = data[indexPath.row - 1];
    }else{
        cell.textLabel.text = data[indexPath.row];
    }
    return cell;
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"5");
    if (pickerIsShown) {
        return 5;
    }
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"6");
    // Return the number of sections. always in one section
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID && !pickerIsShown)
    {
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
            NSLog(@"IT'S HERE!!!");
            [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        }else
            [self displayExternalDatePickerForRowAtIndexPath:indexPath];
    }
    else if(pickerIsShown)
    {
        pickerIsShown = NO;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:pickerRow inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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


- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"The indexpath is %d", indexPath.row);
    if (pickerIsShown) {
        
    }else{
        [self.tableView beginUpdates];
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
        NSLog(@"%@",[indexPaths componentsJoinedByString:@" "]);
        NSLog(@"length is %d", indexPaths.count);
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        pickerRow = indexPath.row+1;
        pickerIsShown = YES;
        NSLog(@"hello");
        [self.tableView endUpdates];
        //[data insertObject:@"test" atIndex:indexPaths]
        //[self.tableView endUpdates];
    }
    /*
    NSLog(@"NUMBER OF ROW IS %d", [data count]);
    NSLog(@"picker is shown %@", pickerIsShown);
    BOOL sameCellClicked = pickerIsShown;
    BOOL before = NO;
    if(pickerIsShown){
        before = self.datePickerIndexPath.row < indexPath.row;
        if (sameCellClicked) {
            
            NSLog(@"DATE PICKER IS AT %@", self.datePickerIndexPath);
            [data removeObjectAtIndex:self.datePickerIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationFade];
            self.datePickerIndexPath = nil;
        }
        pickerIsShown = NO;
    }
    NSLog(@"IT'S HERE!!! %hhd", sameCellClicked);
    if(!sameCellClicked){
        NSLog(@"IT'S HERE!!!!!!!");
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
        NSLog(@"PICKER INDEX IS %d", self.datePickerIndexPath.row);
        
        
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    */
}
/*
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    

    // didn't find a picker below it, so we should insert it
    [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];

    pickerIsShown = YES;
    [self.tableView endUpdates];
}*/

@end



