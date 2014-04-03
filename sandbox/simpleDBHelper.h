//
//  simpleDBHelper.h
//  sandbox
//
//  Created by jake on 4/2/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface simpleDBHelper : NSObject
-(void) addAtrribute: (NSString*)doaminName item:(NSString*)itemName attribute:(NSString*)attributeName value:(NSString*)attributeValue;

-(void) updateAtrribute: (NSString*)doaminName item:(NSString*)itemName attribute:(NSString*)attributeName value:(NSString*)attributeValue;

-(NSString*) getAtrributeValue: (NSString*)doaminName item:(NSString*)itemName attribute:(NSString*)attributeName;
@end
