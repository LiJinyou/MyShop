//
//  NetworkManager.h
//  WebShop
//
//  Created by lijingyou on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConfig.h"

@interface NetworkManager : NSObject

+ (NetworkManager*)shareMgr;

/**
 *  登录
 */
- (void)server_loginWithDic:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle;
- (void)server_registerWithDic:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle;
/**
 *  商品
 */
- (void)server_productListWithDic:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle;
- (void)server_productDetailsWithDic:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle;

/**
 *  订单
 */
- (void)server_OrderList:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle;
- (void)server_OrderDetails:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle;

@end












