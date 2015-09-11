//
//  FakeDataMgr.h
//  WebShop
//
//  Created by lijingyou on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeDataMgr : NSObject

+ (FakeDataMgr*)shareMgr;

@property (nonatomic, strong) NSDictionary* responseRegister;
@property (nonatomic, strong) NSDictionary* responseLogin;

@property (nonatomic, strong) NSDictionary* responseProductList;
@property (nonatomic, strong) NSDictionary* responseProductDetails;

@property (nonatomic, strong) NSDictionary* responseOrderList;
@property (nonatomic, strong) NSDictionary* responseOrderDetails;

@end
