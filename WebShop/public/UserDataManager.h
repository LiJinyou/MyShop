//
//  UserDataManager.h
//  WebShop
//
//  Created by lijingyou on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLoginInfo.h"

@interface UserDataManager : NSObject

@property (nonatomic, strong) NSMutableDictionary* dicModel;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* userType;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* cityId;

@property (nonatomic, strong) UserLoginInfo* userLoginInfo;


+ (UserDataManager*)shareManager;

- (void)writeUserData;
- (void)readUserData;



@end
