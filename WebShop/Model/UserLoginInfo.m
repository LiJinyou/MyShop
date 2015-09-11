//
//  UserLoginInfo.m
//  WebShop
//
//  Created by lijingyou on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "UserLoginInfo.h"

@implementation UserLoginInfo

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    // 这里放置需要持久化的属性
    [aCoder encodeObject:self.sessionId forKey:@"sessionId"];
    [aCoder encodeObject:self.expire forKey:@"expire"];
    [aCoder encodeObject:self.user forKey:@"user"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        //  这里务必和encodeWithCoder方法里面的内容一致，不然会读不到数据
        self.sessionId = [aDecoder decodeObjectForKey:@"sessionId"];
        self.expire = [aDecoder decodeObjectForKey:@"expire"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
    }
    return self;
}

@end


@implementation User


- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    // 这里放置需要持久化的属性
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:[NSNumber numberWithInteger: self.device] forKey:@"device"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    [aCoder encodeObject:self.bUserId forKey:@"bUserId"];
    [aCoder encodeObject:self.realname forKey:@"realname"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [aCoder encodeObject:self.lastAccessIp forKey:@"lastAccessIp"];
    [aCoder encodeObject:self.merchantsId forKey:@"merchantsId"];
    [aCoder encodeObject:self.lastAccessTime forKey:@"lastAccessTime"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        //  这里务必和encodeWithCoder方法里面的内容一致，不然会读不到数据
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.device = [[aDecoder decodeObjectForKey:@"device"] integerValue];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
        self.bUserId = [aDecoder decodeObjectForKey:@"bUserId"];
        self.realname = [aDecoder decodeObjectForKey:@"realname"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
        self.lastAccessIp = [aDecoder decodeObjectForKey:@"lastAccessIp"];
        self.merchantsId = [aDecoder decodeObjectForKey:@"merchantsId"];
        self.lastAccessTime = [aDecoder decodeObjectForKey:@"lastAccessTime"];

    }
    return self;
}


@end
