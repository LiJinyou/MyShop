//
//  LoadHeaderView.m
//  WebShop
//
//  Created by chutong-mini-201401 on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "LoadHeaderView.h"
#import "LoginViewController.h"

@implementation LoadHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.btnLogin.layer.borderWidth = 1.0f;
    self.btnLogin.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.btnLogin.layer.cornerRadius = 5.0f;
}


- (IBAction)loginBtnClick:(id)sender {
    NSLog(@"登录");
    
    [self.delegate JumpToLoginView:nil];
}
@end
