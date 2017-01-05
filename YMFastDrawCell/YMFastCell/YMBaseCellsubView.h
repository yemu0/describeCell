//
//  YMBaseCellsubView.h
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/3.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMBaseCellsubView : UIView


typedef void(^ym_gestureActive)(UIView *view);
typedef void(^ym_setAttributeBlock)();
typedef void(^ym_setupFrame)();
#pragma mark 属性

/**使用子控件默认布局 默认为YES*/

@property (nonatomic,assign) BOOL isUserNormalLayout;
/** 默认 10 */
@property (nonatomic,assign) NSInteger ym_margin;


/** 统一设置view属性 静态属性设置*/
@property (nonatomic,strong) void(^ym_subViewLoad)(id caller,UIView *loadView);


#pragma mark 方法

/** 动态frame设置 */
-(void)ym_setupFrame:(ym_setupFrame)setupFrame;

/** 设置view的属性,每个cell只会执行一次 */
-(void)ym_setupAttribute: (ym_setAttributeBlock) setBlock;

/** 根据view类型创建view 标识符代表这个view 没有则创建 */
-(id)ym_addSubviewWithClass:(Class) objectClass identifier:(NSString *) identifier initializeView:(void(^)(UIView *view)) view;

/** 
 * 根据标识符取出view
 * @param objectClass    view 的类型
 * @param identifier    取出这个view时候使用
 * @param view          初始化viewblock
 * @param isCreate      如果没有是否创建
 */
-(id)ym_addSubViewWithClass:(Class) objectClass identifier:(NSString *) identifier initializeView:(void(^)(UIView *view)) view isCreate:(BOOL) isCreate;

/**添加手势
 参数1:手势类型
 参数2:给那个view
 参数3:手势激活后
 */
-(void)ym_addGestureRecognizerTypeWithClass:( Class) gestureClass targetView:( UIView *)targetView activeBlock:( void(^)(UIView *view))active;

/** 开始绘制 */
-(void)ym_startDraw;

/** 根据控件计算view自身大小*/
-(CGFloat)ym_GetSelfViewHeight;



@end
