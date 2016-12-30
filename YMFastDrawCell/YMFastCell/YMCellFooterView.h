//
//  YMCellFooterView.h
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/18.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMBaseCellsubView.h"
#import "YMCommentLabel.h"
@interface YMCellFooterView : YMBaseCellsubView


/**
 * 添加工具条
 * @param number              数量
 * @param margin              间距
 * @param toolViewHeight      工具条高度
 * @param btnBlock            设置子视图block
 */
-(void)ym_addToolsViewWithNumber:(NSInteger)number
                          margin:(NSInteger)margin
                  toolViewHeight:(CGFloat)toolViewHeight
                   setupSubviews:(void(^)(UIButton *btn,UIView *toolsView)) btnBlock;
/**工具条被点击的block*/
-(void)ym_toolsSubviewsClick:(void(^)(UIButton *btn)) btnClick;

/**
 * 添加评论栏
 */
//夜幕:我是评论
typedef void(^commentBlock)(YMCommentLabel *label,NSInteger index);

-(void)ym_addCommentViewWithNumber:(NSInteger)number
                       setupComment:(commentBlock)comment;
@end
