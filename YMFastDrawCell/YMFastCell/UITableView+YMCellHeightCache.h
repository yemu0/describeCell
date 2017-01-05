//
//  UITableView+YMCellHeightCache.h
//  YMFastDrawCell
//
//  Created by 夜幕 on 17/1/5.
//  Copyright © 2017年 yemu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableView (YMCellHeightCache)

-(void)ym_cacheRowHeight:(CGFloat)height indexPath:(NSIndexPath *) indexPath;

-(CGFloat)ym_getRowHeightWithIndexPath:(NSIndexPath*)indexPath;


@end
