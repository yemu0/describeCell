//
//  YMTopicCellManager.h
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/2.
//  Copyright © 2016年 yemu. All rights reserved.
//
//heightForRowAtIndexPath 默认获取RowHeight作为行高 运行完cellForRowAtIndexPath 会运行heightForRowAtIndexPath

#import <UIKit/UIKit.h>

@class YMCellHeaderView,YMCellCenterView,YMCellFooterView;

@interface YMTableViewCell: UITableViewCell

typedef void(^ym_setAttributeBlock)();

/**view */
@property (nonatomic,weak) YMCellHeaderView *ym_headerView;

@property (nonatomic,weak) YMCellCenterView *ym_centerView;

@property (nonatomic,weak) YMCellFooterView *ym_footerView;


/**默认10 */
@property (nonatomic,assign) CGFloat ym_cellMargin;


/**开始绘制 必须执行一次*/
-(void)ym_startDescribe;


/**完成绘制后的block */
-(void)ym_completionDescribe:(void(^)())completion;

/** 设置view的属性,只会执行一次 */
-(void)ym_setupAttribute: (ym_setAttributeBlock) setBlock;



@end

