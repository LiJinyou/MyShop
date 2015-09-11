//
//  ShoppingCarCtrl.h
//  WebShop
//
//  Created by walter on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarCtrl : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableVeiw;

@property (strong, nonatomic) NSDictionary *UserDic;
@property (strong, nonatomic) NSMutableArray *array;

@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) IBOutlet UIView *viewForTallyOrder;
@property (strong, nonatomic) IBOutlet UIButton *btnForChooseAll;
@property (strong, nonatomic) IBOutlet UIImageView *imgForBtnSelected;
@property (strong, nonatomic) IBOutlet UILabel *lblAllPrice;

@property (strong, nonatomic) IBOutlet UIView *viewSecond;
@property (strong, nonatomic) IBOutlet UIImageView *imgSecond;
@property (strong, nonatomic) IBOutlet UIButton *btnSecond;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
- (IBAction)deleteBtnClick:(id)sender;
- (IBAction)btnSecondClick:(id)sender;



- (IBAction)btnPayMoney:(id)sender;
- (IBAction)btnChooseAllClick:(id)sender;



@end
