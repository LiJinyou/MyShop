//
//  GetCityCtrl.h
//  eCarter
//
//  Created by lijingyou on 15/8/27.
//  Copyright (c) 2015年 kinsuft173. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetCityCtrl : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (strong,nonatomic) NSMutableArray *arrayOfCity;
@property (strong,nonatomic) NSMutableArray *arrayOfRegion;

@property (strong,nonatomic) NSString *city;

@end
