//
//  LoadHeaderView.h
//  WebShop
//
//  Created by chutong-mini-201401 on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginDelegate <NSObject>

- (void)JumpToLoginView:(NSDictionary *)loginDic;

@end

@interface LoadHeaderView : UIView

@property (weak, nonatomic) id<loginDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)loginBtnClick:(id)sender;

@end
