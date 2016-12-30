//
//  YMTiebaViewController.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/12.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMBSViewController.h"
#import "YMDescribeCell.h"
#import "YMTestModel.h"
#import "YMCellManager.h"
#import "YMTableView.h"
@interface YMBSViewController ()

@property (nonatomic,strong)NSMutableArray <YMTestModel *>*testModelArray;

@end

@implementation YMBSViewController

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
    self.tableView.estimatedRowHeight = 300;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.testModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //查看有多少个ceLl
    YMTestModel *testM = self.testModelArray[indexPath.row];
    
    YMDescribeCell *cell = [[YMCellManager defaultManager] ym_getCellDescribeWithTableView:tableView Identifier:ymBaisi_Identifier model:testM adjustment:nil];
    
    [cell ym_startDescribe];
    [tableView setRowHeight:cell.ym_height];
    
    return cell;
}


@end
