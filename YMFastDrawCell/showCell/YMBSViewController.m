//
//  YMTiebaViewController.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/12.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMBSViewController.h"
#import "YMTableViewCell.h"
#import "YMTestModel.h"
#import "YMCellManager.h"
#import "YMTableView.h"
#import "UITableView+YMCellHeightCache.h"
@interface YMBSViewController ()

@property (nonatomic,strong)NSMutableArray <YMTestModel *>*testModelArray;

@property (nonatomic,strong) NSMutableArray *rowHeightArr;

@end

@implementation YMBSViewController


-(NSMutableArray *)rowHeightArr{
    
    if(_rowHeightArr==nil){
        _rowHeightArr = [NSMutableArray array];
        
    }
    return _rowHeightArr;
}
//-(NSMutableDictionary *)rowHeightDict{
//    
//    if(_rowHeightDict ==nil){
//        _rowHeightDict = [NSMutableDictionary dictionary];
//    }
//    return _rowHeightDict;
//}

-(NSMutableArray<YMTestModel *> *)testModelArray{
  

    if(_testModelArray==nil){
        _testModelArray = [NSMutableArray array];
        
        for(int i=0;i<20;i++){
            
            [_testModelArray addObject:[YMTestModel testModelFastCreate]];
        }
        
    }
    return _testModelArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[YMTableView alloc]init];
    self.tableView.backgroundColor = [UIColor grayColor];
    

    self.navigationItem.title = @"仿百思cell";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.testModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //获取模型
    YMTestModel *testM = self.testModelArray[indexPath.row];
    
    //根据 ymBaisi_Identifier 标识符获取描述的块
    YMTableViewCell *cell = [[YMCellManager defaultManager] ym_getCellDescribeWithTableView:tableView Identifier:ymBaisi_Identifier model:testM adjustment:nil];
    
    cell.ym_cellMargin = 0;

    //开始绘制
    [cell ym_startDescribe];
    //缓存高度
    [tableView ym_cacheRowHeight:cell.ym_height indexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [tableView ym_getRowHeightWithIndexPath:indexPath];
}

@end
