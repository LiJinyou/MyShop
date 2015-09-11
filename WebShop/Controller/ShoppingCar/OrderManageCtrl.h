//
//  OrderManageCtrl.h
//  WebShop
//
//  Created by chutong-mini-201401 on 15/9/8.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderManageCell.h"

@interface OrderManageCtrl : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOrder;

@end
