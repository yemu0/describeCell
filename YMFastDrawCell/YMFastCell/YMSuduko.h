//
//  YMSudoko.h
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/10.
//  Copyright © 2016年 yemu. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface YMSuduko : NSObject

@property (nonatomic,assign) NSInteger column;

@property (nonatomic,assign) NSInteger number;

/**存放子控件的view宽度*/
@property (nonatomic,assign) CGFloat viewWidth;

/**
 * 宽度设置为0,自动计算  同时当数量少于每列的数量时候 自动宽度拉伸
 * 高度为0,等宽
 */
@property (nonatomic,assign) CGSize subviewSize;


@property (nonatomic,assign) CGFloat viewMargin;

-(void)sudukoWithSuduko:(YMSuduko *)suduko;

-(CGFloat)sudukoSubviewWidth:(CGFloat)sudukoWidth;
@end
