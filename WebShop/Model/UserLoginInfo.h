//
//  UserLoginInfo.h
//  WebShop
//
//  Created by lijingyou on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface UserLoginInfo : NSObject


@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, strong) User *user;

@property (nonatomic, copy) NSString *expire;

@end


@interface User : NSObject

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) NSInteger device;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *bUserId;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *lastAccessIp;

@property (nonatomic, copy) NSString *merchantsId;

@property (nonatomic, copy) NSString *lastAccessTime;


@end
