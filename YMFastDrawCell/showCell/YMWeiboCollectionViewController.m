//
//  YMWeiboCollectionViewController.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/18.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMWeiboCollectionViewController.h"
#import "YMTestModel.h"
#import "YMTestForwardModel.h"
#import "YMConstance.h"
#import "YMDescribeCell.h"
#import "YMPictureView.h"
@interface YMWeiboCollectionViewController ()

@property (nonatomic,strong)NSMutableArray <YMTestModel *>*testModelArray;
@end

@implementation YMWeiboCollectionViewController

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
    
    self.navigationItem.title = @"仿微博cell";
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.estimatedRowHeight = 400;
 
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
    
 
    YMTableViewCell *cell = [[YMCellManager defaultManager] ym_getCellDescribeWithTableView:self.tableView Identifier:ymWeiBoCell_Identifier model:testM adjustment:^(YMTableViewCell *cell, NSObject *model) {
    
        //当有的时候才创建 view占用少可以这样 占用多根据重用最终都回有值
        YMTableViewCell *forwarCell = [cell.ym_centerView ym_addSubViewWithClass:[YMTableViewCell class] identifier:@"forwarCell" initializeView:^(UIView *view) {
            YMTableViewCell *cell = (YMTableViewCell *)view;
            cell.ym_width = [UIScreen mainScreen].bounds.size.width;
            cell.ym_x = -10;
            //取消cell之间自动留10间距
            cell.ym_cellMargin = 0.01;
            cell.backgroundColor = YMGlobalBGColor;
        } isCreate:testM.forward];
        
        //传递一个cell 根据标识符绘制
        if(forwarCell)
            [[YMCellManager defaultManager] ym_performBlockWithCell:forwarCell Identifier:ymWeiBoForwarFinish_Identifier model:testM];
       
        //转发的被点击时候传入的数据
        __weak typeof(self) weakself = self;
        
        [forwarCell.ym_centerView ym_sudukoActiveModels:^NSArray *(UIView *view) {
            
            NSIndexPath *indexPath = [[YMCellManager defaultManager] ym_getIndexPathWithView:view];
            YMTestModel *testM = weakself.testModelArray[indexPath.row];
            return testM.forward.imageNames;
        }];
        //主cell的被点击时候传入的数据
        [cell.ym_centerView ym_sudukoActiveModels:^NSArray *(UIView *view) {
            NSIndexPath *indexPath = [[YMCellManager defaultManager] ym_getIndexPathWithView:view];
            YMTestModel *testM = weakself.testModelArray[indexPath.row];
            return testM.imageNames;
        }];
        //设置frame
        __weak YMCellCenterView * weakCT = cell.ym_centerView;
        [cell.ym_centerView ym_setupFrame:^{
            forwarCell.ym_y = weakCT.ym_contentLable.ym_bottom+10;
        }];
    }];
    //开始描述
    [cell ym_startDescribe];
    [tableView setRowHeight:cell.ym_height];
     return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==self.testModelArray.count-1){
        //刷新
        for (int i=0; i<20;i++) {
            [self.testModelArray addObject:[YMTestModel testModelFastCreate]];
        }
        [self.tableView reloadData];
    }
    
}


-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
