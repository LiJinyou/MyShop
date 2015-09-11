//
//  OrderManageCtrl.m
//  WebShop
//
//  Created by chutong-mini-201401 on 15/9/8.
//  Copyright (c) 2015年 chutong. All rights reserved.
//

#import "OrderManageCtrl.h"

@interface OrderManageCtrl ()<deleteOrder, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>


@end

@implementation OrderManageCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.navigationItem.title = @"全部订单";
    
    //去掉tableView多余的空白行分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.arrayOrder = [[NSMutableArray alloc] initWithObjects:
                  @{@"productId": @"1", @"proName":@"一打阿波罗17号宇宙飞船，阿斯顿发的货", @"saleCount":@"1", @"image":@"", @"price":@"998.0", @"decript":@"good", @"salesDate":@"2015.06.22"},
                  @{@"productId": @"2", @"proName":@"阿斯顿发送到发送到发送到发送到发送到发送到发", @"saleCount":@"1", @"image":@"", @"price":@"99.8", @"decript":@"good", @"salesDate":@"2015.02.03"},
                  @{@"productId": @"3", @"proName":@"阿斯蒂芬V型注册V型注册vwerqwrtqwertqwerqwer", @"saleCount":@"1", @"image":@"", @"price":@"9.98", @"decript":@"good", @"salesDate":@"2015.05.04"},
                  @{@"productId": @"4", @"proName":@"自行车自行车V型从vqerwerqwer", @"saleCount":@"1", @"image":@"", @"price":@"199.0", @"decript":@"good", @"salesDate":@"2015.07.31"},
                  @{@"productId": @"5", @"proName":@"个人台湾清华是打发打发的发送到发送到发送到发送到发送到发", @"saleCount":@"1", @"image":@"", @"price":@"9999.0", @"decript":@"good", @"salesDate":@"2015.02.03"},nil];

}

- (void)deleteOeder:(NSString *)orderId{
    NSLog(@"orderID = %@", orderId);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确认删除此订单？"
                                  delegate:self // telling this class(ViewController) to implement UIActionSheetDelegate
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"删除"
                                  otherButtonTitles:nil];
    
    [actionSheet showInView:self.tabBarController.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSLog(@"删除订单操作");
        
//        [self.tableView deleteRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>];
        
    }else if (buttonIndex == 1){
        NSLog(@"取消删除");
    }
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    NSLog(@"取消删除订单");
}
#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 30;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//
//    return 80;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
    //设置是否显示一个可编辑视图的视图控制器
//-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    //切换接收者的进入和退出编辑模式。
//    [self.tableView setEditing:editing animated:animated];
//}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.arrayOrder removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
        [self.tableView endUpdates];

    }
}

#pragma mark - TableVeiw Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.arrayOrder count];
    return [self.arrayOrder count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellId = @"OrderManageCell";
    
    if ([self.arrayOrder count]) {
        
        NSMutableDictionary *dic = [self.arrayOrder objectAtIndex:indexPath.row];
        NSLog(@"OrderCellDic = %@", dic);
        
        OrderManageCell* cell = [tableView dequeueReusableCellWithIdentifier:CellId];
        
        if (!cell) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellId owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            
            cell.delegate = self;
            [cell initWithDic:nil];
            [cell configWithDic:dic];
            
        }
        return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
