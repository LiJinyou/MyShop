//
//  ShoppingCartCell.m
//  WebShop
//
//  Created by chutong-mini-201401 on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "ShoppingCartCell.h"

@implementation ShoppingCartCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnChooseClick:(id)sender {
    if (self.imgForBtnSeleted.hidden == YES) {
        self.imgForBtnSeleted.hidden = NO;
    }else{
        self.imgForBtnSeleted.hidden = YES;
    }
}

- (void)initWithDic:(NSMutableDictionary*)dic {
    NSLog(@"生成了一个ProductCell");
    
    self.imgProduct.layer.cornerRadius = 5.0f;
    self.imgProduct.layer.borderWidth = 1.0f;
    self.imgProduct.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.imgProduct.layer.masksToBounds = YES;
    
    self.imgForBtnSeleted.layer.cornerRadius = 10.0f;
    self.imgForBtnSeleted.layer.masksToBounds = YES;
    
    self.btnChoose.layer.borderWidth = 1.0f;
    self.btnChoose.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.btnChoose.layer.cornerRadius = 10.0f;
    self.btnChoose.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor clearColor];
}
- (void)configWithDic:(NSMutableDictionary*)dic {
    
    if (dic) {
        self.lblProName.text = dic[@"proName"];
        self.lblPrice.text = [NSString stringWithFormat:@"￥%@", dic[@"price"]];
    }
}

@end
