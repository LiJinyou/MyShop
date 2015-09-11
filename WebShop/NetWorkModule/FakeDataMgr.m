//
//  FakeDataMgr.m
//  WebShop
//
//  Created by lijingyou on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "FakeDataMgr.h"
#import "Common.h"

@implementation FakeDataMgr


@synthesize responseLogin,responseOrderDetails,responseOrderList,responseProductDetails,responseProductList,responseRegister;

+ (FakeDataMgr*)shareMgr
{
    static FakeDataMgr *instance=nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
    
        instance=[[FakeDataMgr alloc]init];
    });
    return instance;
}

- (NSDictionary*)responseRegister
{
    NSString* strJson = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"user" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary* dic = [Common dictionaryWithJsonString:strJson];
    
    return dic;
}

- (NSDictionary*)responseLogin
{
    
    NSString* strJson = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"login" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
   
    NSDictionary* dic = [Common dictionaryWithJsonString:strJson];
   
    return dic;
}

- (NSDictionary*)responseProductList
{
    NSString* strJson = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"product" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary* dic = [Common dictionaryWithJsonString:strJson];
    
    return dic;
}

- (NSDictionary*)responseProductDetails
{
    NSString* strJson = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"product" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary* dic = [Common dictionaryWithJsonString:strJson];
    
    return dic;
}

- (NSDictionary*)responseOrderList
{
    NSString* strJson = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"order" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary* dic = [Common dictionaryWithJsonString:strJson];
    
    return dic;
}

- (NSDictionary*)responseOrderDetails
{
    NSString* strJson = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"order" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary* dic = [Common dictionaryWithJsonString:strJson];
    
    return dic;
}



@end



