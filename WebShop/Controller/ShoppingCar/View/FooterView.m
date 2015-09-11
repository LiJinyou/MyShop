//
//  FooterView.m
//  WebShop
//
//  Created by chutong-mini-201401 on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    self.img_01.layer.cornerRadius = 5.0f;
    self.img_01.layer.borderWidth = 1.0f;
    self.img_01.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.img_01.layer.masksToBounds = YES;
    
    self.img_02.layer.cornerRadius = 5.0f;
    self.img_02.layer.borderWidth = 1.0f;
    self.img_02.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.img_02.layer.masksToBounds = YES;

    
    self.img_03.layer.cornerRadius = 5.0f;
    self.img_03.layer.borderWidth = 1.0f;
    self.img_03.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.img_03.layer.masksToBounds = YES;

    self.backgroundColor = [UIColor clearColor];}


@end
