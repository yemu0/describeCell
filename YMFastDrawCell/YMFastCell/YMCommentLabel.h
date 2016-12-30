//
//  YMComment.h
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/27.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMCommentLabel : UILabel

/**点击的时候是否显示背景颜色*/
@property (nonatomic,assign) BOOL isShowTapBackgouradColor;

/**点击的背景颜色*/
@property (nonatomic,strong) UIColor *touchBackgouradColor;

/**默认状态下的高亮颜色*/
@property (nonatomic,strong) UIColor *normalColor;

/**
 * 根据字符串rect  设置属性
 * @param range  设置的范围
 */
-(void)ym_setupAttributeColorWithRange:(NSRange)range;

/** 
 * 根据字符串rect 设置属性
 * @param array   数组内容 NSStringFromCGRect() 设置具体的range 位置

 */
-(void)ym_setupAttributeColorWithArray:(NSArray <NSString *>*)array;


/**
* 根据字符串rect 设置属性
* @param array  数组内容  只要字符串包含有传进来的文本 就设置
*/
-(void)ym_setupAttributeColorWithTextArray:(NSArray <NSString *>*)array;


/**
 *  通过 ym_setupAttributeColorWithRange 或者 ym_setupAttributeColorWithArray 设置的默认都回添加上
 * @param active 点击时候激活的块,string被点击的字符串
 */
-(void)ym_clickActive:(void(^)(NSString *string)) active;



-(CGFloat)ym_getContentHeight;



@end
