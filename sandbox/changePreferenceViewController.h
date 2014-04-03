//
//  changePreferenceViewController.h
//  sandbox
//
//  Created by wuyue on 4/2/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changePreferenceViewController : UIViewController<UITextViewDelegate>{
    IBOutlet UITextView *mytextview;
}
- (IBAction)me_back_button:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *charleft;

@end
