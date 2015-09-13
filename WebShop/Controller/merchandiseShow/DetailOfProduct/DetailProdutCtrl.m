//
//  DetailProdutCtrl.m
//  WebShop
//
//  Created by walter on 15/9/11.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "DetailProdutCtrl.h"
#import "CommonCell.h"
#import "CommentDetailCell.h"
#import "LookAllCommentCell.h"
#import "ServiceInfoCell.h"
#import "MapController.h"
#import "REFrostedViewController.h"
#import "UIView+REFrostedViewController.h"
#import "GetCityCtrl.h"
//#import "GetProvinceCtrl.h"
#import "ProvinceCtrl.h"

@interface DetailProdutCtrl ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *arrayOfData;
@end

@implementation DetailProdutCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.arrayOfData=[[NSMutableArray alloc]initWithObjects:@"1",@"2", nil];
    self.navigationItem.title=@"商品详情";
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI
{
    
}

#pragma mark - Table view data source

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* commonTitle=@"CommonCell";
    static NSString* serviceInfoTitle=@"ServiceInfoCell";
    
    
    if (indexPath.section==0) {
        CommonCell* cell = [tableView dequeueReusableCellWithIdentifier:commonTitle];
        if (!cell) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommonCell" owner:self options:nil];
            
            cell = [topLevelObjects objectAtIndex:0];
        }
        return cell;
    }
    else
    {
        ServiceInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:serviceInfoTitle];
        if (!cell) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ServiceInfoCell" owner:self options:nil];
            
            cell = [topLevelObjects objectAtIndex:0];
        }
        [cell.btnLocation addTarget:self action:@selector(goToMap:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 72;
    }
    
    else
    {
        return 240;
    }
}

-(void)goToMap:(UIButton*)button
{
//    MapController *vc=[[MapController alloc]initWithNibName:@"MapController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    

    
    [self.frostedViewController presentMenuViewController];
    
//    UIStoryboard *story=[UIStoryboard storyboardWithName:@"ProductDetail" bundle:nil];
//    ProvinceCtrl *vc = [story instantiateViewControllerWithIdentifier:@"ProvinceCtrl"];
//    [self.navigationController pushViewController:vc animated:YES];
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
