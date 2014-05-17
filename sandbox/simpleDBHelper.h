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
-(void) addAtrribute: (NSString*)domainName item:(NSString*)itemName attribute:(NSString*)attributeName value:(NSString*)attributeValue;

-(void) updateAtrribute: (NSString*)domainName item:(NSString*)itemName attribute:(NSString*)attributeName newValue:(NSString*)attributeValue;

-(NSString*) getAtrributeValue: (NSString*)domainName item:(NSString*)itemName attribute:(NSString*)attributeName;

-(NSMutableArray*) getAllAttributes: (NSString*) domainName item:(NSString*) itemName;
-(NSMutableArray*) getAllAttributeNames: (NSString*) domainName item:(NSString*) itemName;

-(void) deleteAttributePair: (NSString*) domainName item:(NSString*)itemName
              attributeName:(NSString*)attributeName attributeValue:(NSString*) attributeValue;
-(BOOL) hasAttributes: (NSString*) domainName item:(NSString*) itemName attributeName:(NSString*) attributeName;

-(BOOL) hasDomain: (NSString*) domainName;

@end
