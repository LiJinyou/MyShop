//
//  NetworkConfig.h
//  WebShop
//
//  Created by lijingyou on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#ifndef WebShop_NetworkConfig_h
#define WebShop_NetworkConfig_h

#define SERVER @"http://192.168.1.23/medical_consultation/json/medical_consultation/"
#define SERVERTEST @""

#define ISINTEST YES

#pragma mark - 网络接口回调类型
typedef void (^CompleteHandle)(NSDictionary*);
typedef void (^ErrorHandle)(NSError*);

#pragma mark - 网络相关url

//test
#define WEBSHOP_TEST @""

//用户
#define WEBSHOP_LOGIN_INTERFACE @""
#define WEBSHOP_REGISTER_INTERFACE @""

//商品
#define WEBSHOP_PRODUCT_LIST_INTERFACE @""
#define WEBSHOP_PRODUCT_DETAILS_INTERFACE @""

//订单
#define WEBSHOP_ORDER_LIST_INTERFACE @""
#define WEBSHOP_ORDER_DETAILS_INTERFACE @""

#endif








