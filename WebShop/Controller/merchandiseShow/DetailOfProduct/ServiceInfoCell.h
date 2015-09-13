//
//  ServiceInfoCell.h
//  WebShop
//
//  Created by walter on 15/9/11.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblServiceInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblServerier;
@property (weak, nonatomic) IBOutlet UILabel *lblPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblAfterService;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;



@end
