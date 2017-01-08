//
//  YMCellHeaderView.h
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/2.
//  Copyright © 2016年 yemu. All rights reserved.
//


#import "YMBaseCellsubView.h"

@class YMLabel;

@interface YMCellHeaderView : YMBaseCellsubView

@property (nonatomic,weak) UILabel *ym_titleLabel;

/**使用subLabel 会自动加载titleLabel*/
@property (nonatomic,weak) YMLabel *ym_subLabel;


@property (nonatomic,weak) UIImageView *ym_imageView;




@end
