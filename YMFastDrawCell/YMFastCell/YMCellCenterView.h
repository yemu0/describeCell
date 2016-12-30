//
//  YMCenterContentView.h
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/2.
//  Copyright © 2016年 yemu. All rights reserved.
//


#import "YMSuduko.h"
#import "YMBaseCellsubView.h"
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

/**修改坐标找ym_clipImageView */
@property (nonatomic,weak)  UIImageView *ym_imageView;

/** 要下载的图片的尺寸 */
@property (nonatomic,assign) CGSize ym_imageSize;

/** 要图片最大的尺寸 */
@property (nonatomic,assign) CGSize ym_maxImageSize;
/** 要图片最小的尺寸 */
@property (nonatomic,assign) CGSize ym_miniImageSize;

/** ym_contentLable 最大尺寸 默认为view宽度 */
@property (nonatomic,assign) CGSize ym_labelMaxSize;


@property (nonatomic,weak) UILabel *ym_contentLable;

@property (nonatomic,assign) YMDescribeType ym_describeType;
/**
 * 添加九宫格布局
 * @param viewClass              view 的类型
 * @param sudoku                 设置九宫格布局内容
 * @param sudukoSubView          设置九宫格子视图内容
 */
-(void)ym_addSudokuLayoutWithClass:(Class)viewClass
                      setSuduko:(void(^)(YMSuduko * suduko))sudoku
              setSudukoSubviews:(sudukoView)sudukoSubView;

/**
 * 九宫格子视图被点击激活的块
 * @param active     如需依赖models,必须实现ym_sudukoActiveModels
 */
-(void)ym_sudukoActiveHaveModels:(void(^)(UIView *view,NSInteger index,NSArray *models))active;

-(void)ym_sudukoActiveModels:(NSArray *(^)(UIView *)) models;


/**获取sudukoView的下标*/
-(NSInteger)ym_getSudukoIndexWithView:(UIView *)view;

@end
