//
//  SettingPageTableViewController.h
//  sandbox
//
//  Created by wuyue on 3/27/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>
#define starthour 0
#define startmin 1
#define endhour 2
#define endmin 3




@interface SettingPageTableViewController : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)NSArray *sh;
@property(nonatomic,strong)NSArray *sm;
@property(nonatomic,strong)NSArray *eh;
@property(nonatomic,strong)NSArray *em;

@property (strong, nonatomic) IBOutlet UITableView *timepicker;

@end
