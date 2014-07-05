//
//  FriendList.h
//  friendlist
//
//  Created by wuyue on 3/24/14.
//  Copyright (c) 2014 wuyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendList : UIView

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *phoneNumber;
@property(nonatomic, strong) NSString *startTime;
@property(nonatomic, strong) NSString *endTime;



@property(nonatomic,assign)BOOL onLineorNot;

-(id)initWithName:(NSString *)name onLineorNot:(BOOL)onLineorNot number:(NSString *)phonenumber;
-(id)initWithName:(NSString *)name onLineorNot:(BOOL)onLineorNot number:(NSString *)phonenumber
            start:(NSString *)startTime end:(NSString *)endTime;
@end
