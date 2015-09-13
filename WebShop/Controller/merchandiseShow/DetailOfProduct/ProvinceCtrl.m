//
//  ProvinceCtrl.m
//  WebShop
//
//  Created by lijingyou on 15/9/13.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "ProvinceCtrl.h"
#import "ProvinceCell.h"
#import "GetCityCtrl.h"
//#import "HKMapManager.h"
#import "ParserDataManager.h"

@interface ProvinceCtrl ()

@property (strong,nonatomic)NSMutableArray *arrayOfData;
@property (strong,nonatomic) NSMutableArray *arrayOfProvince;
@property (strong,nonatomic) NSMutableArray *arrayOfCity;
@property (strong,nonatomic) NSString *province;
@property (strong,nonatomic) NSMutableArray *arrayOfRegion;



@end

@implementation ProvinceCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title=@"选择省份";
    
    self.arrayOfData=[[NSMutableArray alloc]init];
    self.arrayOfData=[ParserDataManager shareManager].arrayOfProvince;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}



#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = @"ProvinceCell";
    
    
    ProvinceCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil] objectAtIndex:0];
        
    }
    
    cell.lbl_province.text = [self.arrayOfData objectAtIndex:indexPath.row];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView * )tableView
heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProvinceCell *cell=(ProvinceCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    self.province=cell.lbl_province.text;
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    for (int i=0; i<self.arrayOfCity.count; i++) {
        if ([[self.arrayOfCity objectAtIndex:i] hasPrefix:cell.lbl_province.text]) {
            
            NSString* str = [self.arrayOfCity objectAtIndex:i];
            
            NSString* strCity = [str substringFromIndex:cell.lbl_province.text.length];
            
            [array addObject:strCity];
        }
    }
    
    //[HKMapManager shareMgr].province = cell.lbl_province.text;
    
    GetCityCtrl *vc=[[GetCityCtrl alloc]initWithNibName:@"GetCityCtrl" bundle:nil];
    
    vc.arrayOfCity=array;
    vc.arrayOfRegion=self.arrayOfRegion;
    //vc.delegate=self;
    
   // [self.navigationController pushViewController:vc animated:YES];
   // [self performSegueWithIdentifier:@"goSelectCity" sender:nil];
   
    self.arrayOfData=[ParserDataManager shareManager].arrayOfCity;
    [self.tableView reloadData];
}


@end
