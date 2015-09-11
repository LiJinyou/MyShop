//
//  ShoppingCartCell.h
//  WebShop
//
//  Created by chutong-mini-201401 on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCarCtrl.h"

@protocol deleteCellDelegate <NSObject>

- (void)addObjectToDeleteArray:(NSIndexPath *)indexPath;

@end

@interface ShoppingCartCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblProName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnChoose;
@property (strong, nonatomic) IBOutlet UIImageView *imgForBtnSeleted;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id<deleteCellDelegate>delegate;
- (IBAction)btnChooseClick:(id)sender;

- (void)initWithDic:(NSMutableDictionary*)dic;
- (void)configWithDic:(NSMutableDictionary*)dic;

@end
