//
//  PriceCell.h
//  WebShop
//
//  Created by walter on 15/9/11.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblNameOfProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblAdditionInfo;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@end
