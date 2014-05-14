//
//  FriendList.m
//  friendlist
//
//  Created by wuyue on 3/24/14.
//  Copyright (c) 2014 wuyue. All rights reserved.
//

#import "FriendList.h"

@implementation FriendList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@synthesize name = _name;
@synthesize onLineorNot = _onLineorNot;
@synthesize phoneNumber = _phoneNumber;
-(id)initWithName:(NSString *)name onLineorNot:(BOOL)onLineorNot number:(NSString *)phonenumber{
    self = [super init];
    if(self){
        self.phoneNumber = phonenumber;
        self.name=name;
        self.onLineorNot = onLineorNot;
        
    }
    return self;
}

-(id)initWithName:(NSString *)name onLineorNot:(BOOL)onLineorNot number:(NSString *)phonenumber
start:(NSString *)startTime end:(NSString *)endTime{
    self = [super init];
    if(self){
        self.phoneNumber = phonenumber;
        self.name=name;
        self.onLineorNot = onLineorNot;
        self.endTime = endTime;
        self.startTime = startTime;
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

@end
