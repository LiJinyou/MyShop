//
//  NetworkManager.m
//  WebShop
//
//  Created by lijingyou on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "NetworkManager.h"
#import "FakeDataMgr.h"
#import <AFNetworking/AFNetworking.h>

@interface NetworkManager ()
@property BOOL isTestMode;
@end

@implementation NetworkManager

+ (NetworkManager*)shareMgr
{
    static NetworkManager* instance=nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
    
        instance=[[NetworkManager alloc]init];
        instance.isTestMode=ISINTEST;
    });
    
    return instance;
}

//登陆注册
- (void)server_loginWithDic:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* strInterface;
    
    if (self.isTestMode) {
        
        strInterface = WEBSHOP_TEST;
        
    }else{
        
        strInterface = WEBSHOP_LOGIN_INTERFACE;
        
    }
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVER,strInterface] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (self.isTestMode) {
          
            NSDictionary *dictionary = [FakeDataMgr shareMgr].responseLogin;
            
            if (completeHandle) {
                
                completeHandle(dictionary);
                
            }
            
        }else{
            
            if (completeHandle) {
                
                completeHandle(responseObject);
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //ErrorHandle(error);
        
        NSLog(@"Error: %@", error);
        
        
    }];
    
}


- (void)server_registerWithDic:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    
    NSString* strInterface;
    
    if (self.isTestMode) {
        
        strInterface = WEBSHOP_TEST;
        
    }else{
        
        strInterface = WEBSHOP_REGISTER_INTERFACE;
        
    }
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVER,strInterface] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (self.isTestMode) {
            
            NSDictionary *dictionary = [FakeDataMgr shareMgr].responseRegister;
            
            if (completeHandle) {
                
                completeHandle(dictionary);
                
            }
            
        }else{
            
            if (completeHandle) {
                
                completeHandle(responseObject);
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //ErrorHandle(error);
        
        NSLog(@"Error: %@", error);
        
        
    }];
    
}



//商品
- (void)server_productListWithDic:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
    
    NSString* strInterface;
    
    if (self.isTestMode) {
        
        strInterface = WEBSHOP_TEST;
        
    }else{
        
        strInterface = WEBSHOP_PRODUCT_LIST_INTERFACE;
        
    }
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVER,strInterface] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (self.isTestMode) {
            
            NSDictionary *dictionary = [FakeDataMgr shareMgr].responseProductList;
            
            if (completeHandle) {
                
                completeHandle(dictionary);
                
            }
            
        }else{
            
            if (completeHandle) {
                
                completeHandle(responseObject);
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //ErrorHandle(error);
        
        NSLog(@"Error: %@", error);
        
        
    }];
    
}


- (void)server_productDetailsWithDic:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
    NSString* strInterface;
    
    if (self.isTestMode) {
        
        strInterface = WEBSHOP_TEST;
        
    }else{
        
        strInterface = WEBSHOP_PRODUCT_DETAILS_INTERFACE;
        
    }
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVER,strInterface] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (self.isTestMode) {
            
            NSDictionary *dictionary = [FakeDataMgr shareMgr].responseProductDetails;
            
            if (completeHandle) {
                
                completeHandle(dictionary);
                
            }
            
        }else{
            
            if (completeHandle) {
                
                completeHandle(responseObject);
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //ErrorHandle(error);
        
        NSLog(@"Error: %@", error);
        
        
    }];
    
}


//订单
- (void)server_OrderList:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    
    NSString* strInterface;
    
    if (self.isTestMode) {
        
        strInterface = WEBSHOP_TEST;
        
    }else{
        
        strInterface = WEBSHOP_ORDER_LIST_INTERFACE;
        
    }
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVER,strInterface] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (self.isTestMode) {
            
            NSDictionary *dictionary = [FakeDataMgr shareMgr].responseOrderList;
            
            if (completeHandle) {
                
                completeHandle(dictionary);
                
            }
            
        }else{
            
            if (completeHandle) {
                
                completeHandle(responseObject);
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //ErrorHandle(error);
        
        NSLog(@"Error: %@", error);
        
        
    }];
    
}



- (void)server_OrderDetails:(NSDictionary*)dic completeHandle:(CompleteHandle)completeHandle
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    
    NSString* strInterface;
    
    if (self.isTestMode) {
        
        strInterface = WEBSHOP_TEST;
        
    }else{
        
        strInterface = WEBSHOP_ORDER_DETAILS_INTERFACE;
        
    }
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVER,strInterface] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (self.isTestMode) {
            
            NSDictionary *dictionary = [FakeDataMgr shareMgr].responseOrderDetails;
            
            if (completeHandle) {
                
                completeHandle(dictionary);
                
            }
            
        }else{
            
            if (completeHandle) {
                
                completeHandle(responseObject);
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"Error: %@", error);
        
        
    }];
    
}



@end
