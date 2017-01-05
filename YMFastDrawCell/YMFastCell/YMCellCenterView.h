//
//  YMCenterContentView.h
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/2.
//  Copyright © 2016年 yemu. All rights reserved.
//


#import "YMBaseCellsubView.h"

@class YMSuduko,YMLabel;
@interface YMCellCenterView : YMBaseCellsubView

typedef NS_ENUM(NSInteger, YMDescribeType) {
    YMDescribeTypeLabelTop = 0,
    YMDescribeTypeLabelRight   = 1,
    YMDescribeTypeLabelButtom  = 2,
    YMDescribeTypeLabelLeft  = 3,
    YMDescribeTypeLabelNone  = 4,
};

/**第一个参数 九宫格子控件的view 
 第二个参数是存放子控件的view
 */
typedef void(^sudukoView)(id sudukoSubview,UIView *sudukoView,NSInteger index);


/**存放九宫格的view*/
@property (nonatomic,weak) UIView *sudukoView;

/** imageView */
@property (nonatomic,weak)  UIImageView *ym_imageView;

/** 要下载的图片的尺寸 */
@property (nonatomic,assign) CGSize ym_imageSize;

/** 
 * imageView图片最大的尺寸
 * 默认宽度 self.frame.size.width
 * 默认高度 [UIScreen mainScreen].bounds.size.height-self.ym_margin*2
 */
@property (nonatomic,assign) CGSize ym_maxImageSize;
/** 要图片最小的尺寸 */
@property (nonatomic,assign) CGSize ym_miniImageSize;


@property (nonatomic,weak) YMLabel *ym_contentLable;

/** 位置类型*/
@property (nonatomic,assign) YMDescribeType ym_describeType;

#pragma mark 方法
/**
 * 添加九宫格布局
 * @param viewClass              view 的类型
 * @param sudoku                 设置九宫格布局内容
 * @param subview                设置九宫格子视图内容
 */
-(void)ym_addSudokuLayoutWithClass:(Class)viewClass
                      setupSuduko:(void(^)(YMSuduko * suduko))sudoku
                     setupSubviews:(sudukoView)subview;


/**
 * 九宫格子视图被点击激活的块
 * @param active     如需依赖models,必须实现ym_sudukoActiveModels 传递模型
 */
-(void)ym_sudukoActiveHaveModels:(void(^)(UIView *view,NSInteger index,NSArray *models))active;


/**返回一个数组 就是ym_sudukoActiveHaveModels 使用的models*/
-(void)ym_sudukoActiveModels:(NSArray *(^)(UIView *)) models;


/**获取sudukoView的下标*/
-(NSInteger)ym_getSudukoIndexWithView:(UIView *)view;

@end
