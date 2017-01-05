//
//  UITableView+YMCellHeightCache.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 17/1/5.
//  Copyright © 2017年 yemu. All rights reserved.
//

#import "UITableView+YMCellHeightCache.h"
#import <objc/runtime.h>

#define AssociatedKey "rowheightArr_"
@implementation UITableView (YMCellHeightCache)


-(void)ym_cacheRowHeight:(CGFloat)height indexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *rowHeightArr = objc_getAssociatedObject(self,AssociatedKey);
    if(!rowHeightArr){
        rowHeightArr = [NSMutableArray array];
        objc_setAssociatedObject(self, AssociatedKey, rowHeightArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    if(indexPath.row>=rowHeightArr.count){
        [rowHeightArr addObject:[NSNumber numberWithFloat:height]];
    }
    else{
        rowHeightArr[indexPath.row] = [NSNumber numberWithFloat:height];
    }
}
-(CGFloat)ym_getRowHeightWithIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *rowHeightArr = objc_getAssociatedObject(self,AssociatedKey);
    if(rowHeightArr){
        
        if(indexPath.row < rowHeightArr.count){
            NSNumber *height = rowHeightArr[indexPath.row];
            return height.floatValue;
        }
    }
    return self.rowHeight;
}


@end
