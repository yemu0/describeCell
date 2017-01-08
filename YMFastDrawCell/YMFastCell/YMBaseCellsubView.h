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
typedef void(^ym_setupFrame)();
#pragma mark 属性

/**使用子控件默认布局 默认为YES*/
@property (nonatomic,assign) BOOL isUserNormalLayout;

/** 默认 10 */
@property (nonatomic,assign) NSInteger ym_margin;


#pragma mark 方法
/** 动态frame设置 持有block 注意循环引用*/
-(void)ym_setupFrame:(ym_setupFrame)setupFrame;

/**
 * 根据标识符取出view
 * @param objectClass    view 的类型
 * @param identifier    取出这个view时候使用
 * @param view          初始化viewblock 只会执行一次
 * @param activate       tap手势激活
 * return objectClass   创建的view
 */

-(id)ym_addSubviewWithClass:(Class) objectClass identifier:(NSString *) identifier initializeView:(void(^)(UIView *view)) view  tapGesture:( void(^)(UIView *view))activate;


/** 根据view类型创建view 标识符代表这个view 没有则创建 */
-(id)ym_addSubviewWithClass:(Class) objectClass identifier:(NSString *) identifier initializeView:(void(^)(UIView *view)) view;

/** 
 * 根据标识符取出view
 * @param objectClass    view 的类型
 * @param identifier    取出这个view时候使用
 * @param view          初始化viewblock 只会执行一次
 * @param isCreate      如果没有是否创建
 * return objectClass   创建的view
 */
-(id)ym_addSubViewWithClass:(Class) objectClass identifier:(NSString *) identifier initializeView:(void(^)(UIView *view)) view isCreate:(BOOL) isCreate;

/**
 * 添加手势
 * @param gestureClass 手势类型
 * @param targetView   给那个view
 * @param activate     手势激活后
 */
-(void)ym_addGestureRecognizerTypeWithClass:( Class) gestureClass targetView:( UIView *)targetView activeBlock:( void(^)(UIView *view))activate;



-(void)ym_startDraw;

@end
