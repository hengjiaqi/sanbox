//
//  simpleDBHelper.m
//  sandbox
//
//  Created by jake on 4/2/14.
//  Copyright (c) 2014 jake. All rights reserved.
//

#import "simpleDBHelper.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import "AmazonClientManager.h"
@implementation simpleDBHelper
-(void) addAtrribute: (NSString*)domainName item:(NSString*)itemName attribute:(NSString*)attributeName value:(NSString*)attributeValue{
    
    SimpleDBGetAttributesRequest* gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse* response = [[AmazonClientManager sdb] getAttributes:gar];
    NSMutableArray *ListAttributes = [[NSMutableArray alloc] init];
    for (SimpleDBAttribute *attr in response.attributes ) {
        SimpleDBReplaceableAttribute *ListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:attr.name andValue:attr.value andReplace:YES];
        [ListAttributes addObject:ListAttribute];
    }
    SimpleDBReplaceableAttribute *ListAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:attributeName andValue:attributeValue andReplace:YES];
    [ListAttributes addObject:ListAttribute];
    
    SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:domainName andItemName:itemName andAttributes:ListAttributes];
    AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
    [sdb putAttributes:putAttributesRequest];
    
}

-(void) updateAtrribute: (NSString*)domainName item:(NSString*)itemName attribute:(NSString*)attributeName newValue:(NSString*)attributeValue{
    SimpleDBGetAttributesRequest* gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse* response = [[AmazonClientManager sdb] getAttributes:gar];
    NSMutableArray *ListAttributes = response.attributes;
    BOOL attributeExist = NO;
    for (int i = 0; i < ListAttributes.count; i++) {
        SimpleDBReplaceableAttribute *temp =[ListAttributes objectAtIndex:i];
        if ([temp.name isEqualToString:attributeName]) {
            
            attributeExist = YES;
            [self deleteAttributePair:domainName item:itemName attributeName:temp.name attributeValue:temp.value];
            [self addAtrribute:domainName item:itemName attribute:attributeName value:attributeValue];
        }
    }
    
    if (attributeExist) {
        
    }else{
        NSLog(@"The attribute does NOT exist");
    }
}

-(BOOL) hasAttributes: (NSString*) domainName item:(NSString*) itemName attributeName:(NSString*) attributeName{
    NSLog(@"1");
    SimpleDBGetAttributesRequest* gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:domainName andItemName:itemName];
    NSLog(@"2 , domain name: %@, item name : %@" , domainName, itemName);
    SimpleDBGetAttributesResponse* response = [[AmazonClientManager sdb] getAttributes:gar];
    NSLog(@"3");
    BOOL attributeExist = NO;
    for (SimpleDBAttribute *attr in response.attributes ) {
        NSLog(@"4");
        if ([attr.name isEqualToString:attributeName]) {
            NSLog(@"5");
            attributeExist = YES;
        }
    }
    return attributeExist;
}

//this is a test for the gift from jing
-(NSMutableArray*) getAllAttributes: (NSString*) domainName item:(NSString*) itemName{
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
    return response.attributes;
}

-(NSMutableArray*) getAllAttributeNames: (NSString*) domainName item:(NSString*) itemName{
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse *response = [[AmazonClientManager sdb] getAttributes:gar];
    NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:[response.attributes count]];
    for(SimpleDBAttribute *attr in response.attributes){
        [names addObject:attr.name];
    }
    return names;
}


-(void) deleteAttributePair: (NSString*) domainName item:(NSString*)itemName
              attributeName:(NSString*)attributeName attributeValue:(NSString*) attributeValue{
    AmazonSimpleDBClient *sdb = [AmazonClientManager sdb];
    NSMutableArray *remove = [[NSMutableArray alloc] init];
    SimpleDBAttribute *ListAttribute = [[SimpleDBAttribute alloc] initWithName:attributeName andValue:attributeValue];
    [remove addObject:ListAttribute];
    SimpleDBDeleteAttributesRequest *request = [[SimpleDBDeleteAttributesRequest alloc] initWithDomainName:domainName andItemName:itemName andAttributes:remove];
    [sdb deleteAttributes:request];
    
}


-(NSString*) getAtrributeValue: (NSString*)domainName item:(NSString*)itemName attribute:(NSString*)attributeName{
    SimpleDBGetAttributesRequest* gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse* response = [[AmazonClientManager sdb] getAttributes:gar];
    NSString* result = [[NSString alloc] init];
    BOOL attributeExist = NO;
    for (SimpleDBAttribute *attr in response.attributes ) {
        if ([attr.name isEqualToString:attributeName]) {
            attributeExist = YES;
            result = attr.value;
        }
    }
    if (attributeExist) {
    }else{
        NSLog(@"The attribute does NOT exist");
    }
    return result;
}

@end
