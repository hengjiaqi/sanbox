//
//  changepreferenceUIView.m
//  sandbox
//
//  Created by wuyue on 4/2/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "changepreferenceUIView.h"

@implementation changepreferenceUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)backButtonPress:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
