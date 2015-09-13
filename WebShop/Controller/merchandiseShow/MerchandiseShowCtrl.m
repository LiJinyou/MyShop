//
//  MerchandiseShowCtrl.m
//  WebShop
//
//  Created by walter on 15/9/7.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "MerchandiseShowCtrl.h"
#import "NetworkManager.h"
#import "ShoppingListCtrl.h"
#import "ReactViewController.h"

@interface MerchandiseShowCtrl ()

@end

@implementation MerchandiseShowCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"商场";
    
    [self getData];
    
    [self initButton];
}

-(void)initButton
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(100, 100, 100, 60)];
    [button addTarget:self action:@selector(goTestView:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"商品列表" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(100, 200, 100, 60)];
    [button1 addTarget:self action:@selector(goReactView) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"测试" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
}

-(void)goReactView
{
    ReactViewController *vc=[[ReactViewController alloc]initWithNibName:@"ReactViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)goTestView:(UIButton*)button
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    
    ShoppingListCtrl *vc=[[ShoppingListCtrl alloc]initWithCollectionViewLayout:flowLayout];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getData
{
    [[NetworkManager shareMgr]server_loginWithDic:nil completeHandle:^(NSDictionary *response) {
        //NSLog(@"测试数据：%@",response);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
