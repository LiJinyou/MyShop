//
//  Common.m
//  WebShop
//
//  Created by lijingyou on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "Common.h"
#import "iToast.h"

@implementation Common

//json转成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString==nil) {
        return nil;
    }
    
    NSData *jsonData=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if (err) {
        NSLog(@"json解析失败:%@",err);
        return nil;
    }
    return dic;
}

+(void)addAlertViewWithTitel:(NSString*)string
{
    iToastSettings *theSettings=[iToastSettings getSharedSettings];
    
    [theSettings setDuration:iToastDurationNormal];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [[iToast makeText:string]show];
    });
}

@end
