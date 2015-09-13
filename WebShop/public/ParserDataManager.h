//
//  ParserDataManager.h
//  WebShop
//
//  Created by lijingyou on 15/9/13.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserDataManager : NSObject

@property (strong,nonatomic) NSMutableArray *arrayOfProvince;
@property (strong,nonatomic) NSMutableArray *arrayOfCity;
@property (strong,nonatomic) NSMutableArray *arrayOfRegion;

+ (ParserDataManager*)shareManager;

- (void)writeProvinceData;
- (void)readProvinceData;

- (void)writeCityData;
- (void)readCityData;

@end
