//
//  YMCellManager.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/19.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMCellManager.h"
#import "YMTableViewCell.h"

@interface YMCellManager()

@property (nonatomic,strong) NSMutableDictionary *identifierDict;


@end

@implementation YMCellManager

static YMCellManager *manager;
#pragma 懒加载

-(NSMutableDictionary *)identifierDict{
    
    if(_identifierDict==nil){
        _identifierDict = [NSMutableDictionary dictionary];
    }
    return _identifierDict;
}

+(instancetype)defaultManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YMCellManager alloc]init];
    });
    
    return manager;
}

-(void)ym_describeCellWithIdentifier:(NSString *const )identifier describe:(describeCell)describe{
    
    if(self.identifierDict[identifier]==nil){
        [self.identifierDict setValue:describe forKey:identifier];
    }
    
    return;
}

//获取之前描述的cell
-(YMTableViewCell *)ym_getCellDescribeWithTableView:(UITableView *)tableView
                                            Identifier:(NSString *)identifier
                                                 model:(NSObject *)model
                                            adjustment:(describeCell)adjustment{
    //判断是否注册类
    YMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        [tableView registerClass:[YMTableViewCell class] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [self ym_performDescribeWithCell:cell Identifier:identifier model:model adjustment:adjustment];
    
    return cell;
}

-(void)ym_performDescribeWithCell:(YMTableViewCell *)cell
                    Identifier:(NSString *)identfier
                         model:(NSObject *)model
                    adjustment:(describeCell)adjustment{
    
    describeCell draw =  self.identifierDict[identfier];
    if(draw==nil)
        return;
    draw(cell,model);
    if(adjustment)
        adjustment(cell,model);
    return;
}
-(NSIndexPath *)ym_getIndexPathWithView:(UIView *)view{
    
    //获取cell
    UITableViewCell *cell = [self ym_getCellWithView:view superIsTableView:YES];
    
    UITableView *tableV = [self getTableViewWithCell:cell];
    
    return [tableV indexPathForCell:cell];

}

-(UITableView *)getTableViewWithCell:(UITableViewCell *)cell{
    
    if(!cell.superview)
        return nil;
    
    if([cell.superview isKindOfClass:[UITableView class]])
        return (UITableView *)cell.superview;
    
    return [self getTableViewWithCell:(UITableViewCell *)cell.superview];
}

-(UITableViewCell *)ym_getCellWithView:(UIView *)view
                   superIsTableView:(BOOL)superIsTableView{
    
    if(!view.superview)
        return nil;
    
    if( [view.superview isKindOfClass:[UITableViewCell class]])
    {
        //当前这个cell是否为tableView的cell
        UITableViewCell *cell = (UITableViewCell *)view.superview;
        
        if(superIsTableView==NO)
            return cell;
        
        if([cell.superview isKindOfClass:NSClassFromString(@"UITableViewWrapperView")])
            return (UITableViewCell *)view.superview;
    }
    
    return [self ym_getCellWithView:view.superview superIsTableView:superIsTableView];
}

//移除
-(void)ym_removeDecribeWithIdentifier:(NSString *)identifier{
    
    [self.identifierDict removeObjectForKey:identifier];
}
-(void)ym_removeAll{
    [self.identifierDict removeAllObjects];
}


@end
