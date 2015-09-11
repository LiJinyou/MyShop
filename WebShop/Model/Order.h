//
//  Order.h
//  WebShop
//
//  Created by walter on 15/9/8.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product,User;
@interface Order : NSObject


@property (nonatomic, copy) NSString *receiverName;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *receiverPhone;

@property (nonatomic, copy) NSString *receiverAdress;

@property (nonatomic, copy) NSString *payment;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *additionInfo;

@property (nonatomic, strong) Product *product;

@property (nonatomic, strong) User *user;


@end
@interface Product : NSObject

@property (nonatomic, copy) NSString *decript;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *saleCount;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *salesDate;

@property (nonatomic, copy) NSString *proName;

@end

@interface User : NSObject

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *imgOfHead;

@end

