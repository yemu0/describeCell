//
//  YMCellHeaderView.h
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/2.
//  Copyright © 2016年 yemu. All rights reserved.
//


#import "YMBaseCellsubView.h"

@interface YMCellHeaderView : YMBaseCellsubView


@property (nonatomic,weak) UILabel *ym_titleLabel;

/**使用subLabel 会自动加载titleLabel*/
@property (nonatomic,weak) UILabel *ym_subLabel;


@property (nonatomic,weak) UIImageView *ym_imageView;

/**subLabel 限制的宽高 默认为view的宽度*/
@property (nonatomic,assign) CGSize ym_subLabelMaxSize;



@end
